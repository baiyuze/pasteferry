// pasteferryd 是 PasteFerry 的常驻后台进程，承载全部核心逻辑：
// 剪贴板监听、设备配对、P2P 传输、本地缓存与回收。
//
// Flutter UI 只是控制台——关掉 UI 不影响后台同步。UI 通过
// 本地 gRPC（127.0.0.1 随机端口 + 一次性 token）连接本进程。
package main

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"log/slog"
	"os"
	"os/signal"
	"path/filepath"
	"runtime"
	"sync"
	"syscall"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/cache"
	"github.com/baiyuze/pasteferry/client-core/internal/clipboard"
	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/gc"
	"github.com/baiyuze/pasteferry/client-core/internal/identity"
	"github.com/baiyuze/pasteferry/client-core/internal/notifications"
	"github.com/baiyuze/pasteferry/client-core/internal/peers"
	"github.com/baiyuze/pasteferry/client-core/internal/power"
	"github.com/baiyuze/pasteferry/client-core/internal/rpc"
	"github.com/baiyuze/pasteferry/client-core/internal/send"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	syncengine "github.com/baiyuze/pasteferry/client-core/internal/sync"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/lan"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/p2p"
	"github.com/baiyuze/pasteferry/client-core/internal/update"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

var version = "0.1.0-dev"

func main() {
	// 必须在任何其他 goroutine 启动前锁定主线程。
	//
	// macOS 的剪贴板 API 在隐私机制开启时会经 ViewBridge 与系统 UI 服务通信，
	// 其内部 NSCFRunLoopSemaphore 依赖 run loop；在非主线程调用会直接
	// SIGSEGV（M-1 实测，见 spikes/results.md）。所以主线程被专门留出来
	// 跑 MainLoop，业务逻辑一律在其他 goroutine 里，通过 Post/Call 投递。
	runtime.LockOSThread()

	var (
		notificationAction = flag.String("notification-action", "", "Handle a desktop notification action and exit")
		dataDir            = flag.String("data-dir", "", "数据目录（默认为系统标准位置）")
		verbose            = flag.Bool("v", false, "输出调试日志")
		probe              = flag.Bool("probe-clipboard", false,
			"诊断用：在主线程直接读一次剪贴板并打印结果后退出")
		supervise = flag.Bool("supervise", false,
			"守护模式：拉起后台服务，异常退出时自动重启（Windows、Linux 开机自启用）")
		applyUpdate    = flag.String("apply-update", "", "更新助手：按这个安装计划安装新版本（由后台服务调用）")
		applyUpdateRun = flag.String("apply-update-run", "", "更新助手脱离进程树之后的第二级，不要直接调用")
	)
	flag.Parse()
	if *applyUpdate != "" || *applyUpdateRun != "" {
		if *applyUpdate != "" {
			os.Exit(update.RunHelper(*applyUpdate, true))
		}
		os.Exit(update.RunHelper(*applyUpdateRun, false))
	}
	if *notificationAction != "" {
		if err := activateNotification(*notificationAction); err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}
		return
	}

	if *dataDir == "" {
		if p, err := config.DefaultPaths(); err == nil {
			if moved, err := config.MigrateLegacy(p); err != nil {
				fmt.Fprintln(os.Stderr, "挪动旧数据目录失败：", err)
			} else if moved {
				fmt.Fprintln(os.Stderr, "已把旧数据目录挪到", p.Root)
			}
		}
	}

	if *supervise {
		os.Exit(runSupervisor(*dataDir))
	}

	if *verbose {
		logLevel.Set(slog.LevelDebug)
	}
	logOut := logOutput(*dataDir)
	if *probe {
		logOut = os.Stderr
	}
	slog.SetDefault(slog.New(slog.NewTextHandler(logOut, &slog.HandlerOptions{Level: &logLevel})))

	if *probe {
		probeClipboard()
		return
	}

	if err := run(*dataDir); err != nil {
		if errors.Is(err, errAlreadyRunning) {
			slog.Info("已有后台服务在运行，本进程退出")
			os.Exit(exitAlreadyRunning)
		}
		slog.Error("daemon 退出", "err", err)
		os.Exit(1)
	}
}

// exitAlreadyRunning 是「已有实例在运行」的退出码。守护进程见到它就不再重启。
const exitAlreadyRunning = 3

var errAlreadyRunning = errors.New("已有后台服务在运行")

// probeClipboard 在主线程直接走一遍探测与读取，用来把剪贴板问题
// 与 daemon 的其余部分隔离开。
func probeClipboard() {
	clipboard.InitPlatform()
	cb := newClipboard()

	fmt.Println("授权状态:", cb.Permission())

	snap, err := cb.Peek()
	if err != nil {
		fmt.Println("Peek 失败:", err)
		return
	}
	fmt.Printf("changeCount: %d\n分类: %v\ncontentType: %q\ntypes: %v\n",
		snap.ChangeCount, snap.Kind, snap.ContentType, snap.Types)

	content, err := cb.Read()
	if err != nil {
		fmt.Println("Read 失败:", err)
		return
	}
	fmt.Printf("读取结果: kind=%v 文本=%d字符 HTML=%d字符 图片=%d字节 文件=%v\n",
		content.Kind, len([]rune(content.Text)), len(content.HTML),
		len(content.Image), content.Files)
	if content.Text != "" {
		fmt.Printf("文本内容: %q\n", content.Text)
	}
}

func run(dataDir string) error {
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()
	// 注销、关机时调用（Windows 由剪贴板窗口收到系统通知，Linux 是与 X11 显示的连接断了），见下方 SetSystemHooks
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	// ── 路径与配置 ──
	paths, err := resolvePaths(dataDir)
	if err != nil {
		return err
	}
	release, ok := acquireInstance(paths.Root)
	if !ok {
		return errAlreadyRunning
	}
	defer release()
	if err := paths.EnsureDirs(); err != nil {
		return err
	}
	cfg, err := config.Load(paths)
	if err != nil {
		return err
	}

	// ── 设备身份 ──
	id, err := identity.LoadOrCreate(filepath.Join(paths.Root, "identity.json"))
	if err != nil {
		return err
	}
	if cfg.DeviceID != id.DeviceID {
		cfg.DeviceID = id.DeviceID
		if err := config.Save(paths, cfg); err != nil {
			return err
		}
	}
	slog.Info("设备身份就绪",
		"device_id", id.DeviceID, "name", cfg.DeviceName, "fingerprint", id.Fingerprint())

	// ── 存储与缓存 ──
	db, err := store.Open(paths.DB)
	if err != nil {
		return err
	}
	defer db.Close()
	if err := db.RecoverReceives(); err != nil {
		return err
	}

	blobs, err := cache.New(paths.Cache)
	if err != nil {
		return err
	}
	// 上次异常退出可能留下半截的临时文件
	if err := blobs.CleanTemp(); err != nil {
		slog.Debug("清理临时文件失败", "err", err)
	}
	// 收藏另存的图片与文件，与缓存分开放：缓存会过期，收藏不会
	favorites, err := cache.New(paths.Favorites)
	if err != nil {
		return err
	}

	// ── 配置的并发安全读写 ──
	var cfgMu sync.RWMutex
	loadCfg := func() config.Config {
		cfgMu.RLock()
		defer cfgMu.RUnlock()
		return cfg
	}
	saveCfg := func(c config.Config) error {
		cfgMu.Lock()
		defer cfgMu.Unlock()
		if err := config.Save(paths, c); err != nil {
			return err
		}
		cfg = c
		return nil
	}

	hub := rpc.NewHub()

	// ── 剪贴板（必须在主线程使用）──
	clipboard.InitPlatform()
	loop := clipboard.NewMainLoop()
	watcher := clipboard.NewWatcher(clipboard.WatcherOptions{
		Clipboard: newClipboard(),
		MainLoop:  loop,
		OnPermission: func(p clipboard.Permission) {
			hub.Publish(rpc.EventPermissionChanged(permissionToProto(p)))
		},
	})

	// ── 设备配对与信令（引擎稍后注入）──
	var engine *syncengine.Engine
	var sender *send.Engine
	notifier := notifications.New(ctx, notifications.Options{
		Enabled: dataDir == "", Loop: loop, Language: func() string { return loadCfg().Language },
		Fetch: func(ctx context.Context, id string) error { return engine.Fetch(ctx, id) },
		Apply: func(ctx context.Context, id string) error { return engine.ApplyToClipboard(ctx, id) },
		Record: func(id string) (*pb.ClipRecord, error) {
			clip, err := db.GetClip(id)
			if err != nil {
				return nil, err
			}
			return rpc.ClipToProto(clip), nil
		},
		Reveal: func(id string) error {
			t, err := db.GetTransfer(id)
			if err != nil {
				return err
			}
			for _, p := range t.Paths {
				if _, err := os.Lstat(p); err == nil {
					return notifications.Reveal(p)
				}
			}
			return notifications.Reveal(t.DestDir)
		},
		OpenPage: func(page string) error {
			hub.Navigate(page)
			return notifications.OpenUI()
		},
	})
	defer notifier.Close()

	// 状态快照要由 gRPC 服务组装，而它晚于 peerMgr 创建，这里先记下"状态变了"，
	// 等服务就绪后统一推送。容量 1 让连续的变化合并成一次刷新。
	statusDirty := make(chan struct{}, 1)
	verbose := &verboseLog{base: logLevel.Level(), changed: func() {
		select {
		case statusDirty <- struct{}{}:
		default:
		}
	}}

	peerMgr, err := peers.NewManager(peers.Options{
		Identity:   id,
		Store:      db,
		LoadConfig: loadCfg,
		StatePath:  filepath.Join(paths.Root, "egress.json"),
		OnDeviceChanged: func(d *pb.Device) {
			hub.Publish(rpc.EventDeviceChanged(d))
		},
		OnStatusChanged: func() {
			select {
			case statusDirty <- struct{}{}:
			default:
			}
		},
		OnPeerMessage: func(deviceID string, msg *pb.PeerMessage) {
			if sender != nil && sender.HandleMessage(deviceID, msg) {
				return
			}
			if engine != nil {
				engine.HandlePeerMessage(ctx, deviceID, msg)
			}
		},
		OnPeerStream: func(deviceID, label string, stream *p2p.Stream) {
			if send.IsStream(label) {
				if sender != nil {
					sender.HandleStream(deviceID, label, stream)
				} else {
					stream.Close()
				}
				return
			}
			if engine != nil {
				engine.HandlePeerStream(deviceID, label, stream)
			}
		},
		OnPeerReady: func(deviceID string) {
			if engine != nil {
				go engine.PeerReady(ctx, deviceID)
			}
			if sender != nil {
				go sender.PeerReady(deviceID)
			}
		},
	})
	if err != nil {
		return err
	}

	// ── 同步引擎 ──
	engine = syncengine.New(syncengine.Options{
		Store:      db,
		Cache:      blobs,
		Favorites:  favorites,
		Watcher:    watcher,
		DeviceID:   id.DeviceID,
		DeviceName: func() string { return loadCfg().DeviceName },
		LoadConfig: loadCfg,
		Send:       peerMgr.P2P().Send,
		OpenStream: peerMgr.P2P().OpenStream,
		PairedPeers: func() []string {
			_, list := peerMgr.Devices()
			ids := make([]string, 0, len(list))
			for _, d := range list {
				ids = append(ids, d.GetId())
			}
			return ids
		},
		OnReceive: func(ev syncengine.ReceiveEvent) {
			switch ev.Stage {
			case syncengine.ReceivePending:
				notifier.Pending(ev.Record)
			case syncengine.ReceiveStarted:
				notifier.Started(ev.Record)
			case syncengine.ReceiveCompleted:
				notifier.Completed(ev.Record, ev.Clipboard)
			case syncengine.ReceiveFailed:
				notifier.Failed(ev.Record)
			}
		},
		OnClipboardResult: func(result *pb.ClipboardWriteResult) {
			hub.Publish(&pb.Event{Payload: &pb.Event_ClipboardWritten{ClipboardWritten: result}})
		},
		OnRecord: func(r *pb.ClipRecord) {
			hub.Publish(rpc.EventClipAdded(r))
		},
		OnRemoved: func(id string) {
			hub.Publish(rpc.EventClipRemoved(id))
		},
		OnProgress: func(p *pb.TransferProgress) {
			hub.Publish(rpc.EventProgress(p))
		},
	})

	// 剪贴板变化在独立 goroutine 里处理：读内容可能耗时，
	// 不能拖住轮询循环，更不能占着主线程。
	watcher.SetOnChange(func(snap clipboard.Snapshot) {
		go engine.HandleClipboardChange(ctx, snap)
	})

	defer engine.Close()

	// ── 隔空传送 ──
	sender = send.New(send.Options{
		Store:      db,
		LoadConfig: loadCfg,
		Send:       peerMgr.P2P().Send,
		OpenStream: peerMgr.P2P().OpenStream,
		Peer: func(deviceID string) send.Peer {
			_, list := peerMgr.Devices()
			for _, d := range list {
				if d.GetId() != deviceID {
					continue
				}
				state := peerMgr.ConnState(deviceID)
				return send.Peer{
					Known: true, Name: d.GetName(), Online: d.GetOnline(),
					Connected: state == p2p.StateDirect || state == p2p.StateRelay,
					Relayed:   state == p2p.StateRelay,
					Supported: d.GetReceivesFiles(), Disabled: d.GetReceiveDisabled(),
				}
			}
			return send.Peer{}
		},
		RelayQuotaExhausted: func() bool {
			u := peerMgr.OfficialUsage()
			return u != nil && (u.GetReason() == "quota_exhausted" || u.GetReason() == "global_exhausted" ||
				(u.GetAvailable() && u.GetLimitBytes() > 0 && u.GetRemainingBytes() <= 0))
		},
		Inhibit: func() func() { return power.Inhibit("PasteFerry is transferring files") },
		OnChange: func(t *pb.Transfer) {
			hub.Publish(rpc.EventTransferChanged(t))
		},
		OnRemoved: func(id string) {
			hub.Publish(rpc.EventTransferRemoved(id))
		},
		OnNotice: func(kind send.NoticeKind, t *pb.Transfer) {
			if loadCfg().ReceiveNotifyDisabled {
				return
			}
			name := map[send.NoticeKind]string{send.NoticeIncoming: "incoming", send.NoticeReceived: "received", send.NoticeFailed: "failed"}[kind]
			notifier.Transfer(name, t, receivedFolder(t))
		},
	})
	defer sender.Close()

	go peerMgr.Run(ctx)
	sender.Start()
	go watcher.Run(ctx)

	// ── 过期回收 ──
	collector := gc.New(gc.Options{
		Store:      db,
		Cache:      blobs,
		Favorites:  favorites,
		LoadConfig: loadCfg,
		OnRemoved: func(ids []string) {
			for _, cid := range ids {
				hub.Publish(rpc.EventClipRemoved(cid))
			}
		},
	})
	go collector.Run(ctx)

	// 快捷粘贴窗口（Windows、Linux 上由这里拉起，Mac 上由 LaunchAgent），见 quickpaste.go
	quickPaste := newQuickPasteRunner(ctx, dataDir == "", !cfg.QuickPasteDisabled)

	// 改了服务器地址要立即重连，否则用户得重启 daemon 才生效
	saveCfgAndApply := func(c config.Config) error {
		prev := loadCfg()
		if err := saveCfg(c); err != nil {
			return err
		}
		if c.EffectiveSignalingURL() != prev.EffectiveSignalingURL() || c.ServiceMode != prev.ServiceMode {
			slog.Info("公网连接模式已变更")
			peerMgr.SetSignalingURL(c.EffectiveSignalingURL())
		}
		if c.LANDisabled != prev.LANDisabled {
			peerMgr.SetLANEnabled(!c.LANDisabled)
		}
		// 关掉或打开接收文件后，让对方的雷达立即更新
		if c.ReceiveDisabled != prev.ReceiveDisabled {
			peerMgr.BroadcastFeatures()
		}
		if c.EffectiveSignalingURL() != prev.EffectiveSignalingURL() || c.ServiceMode != prev.ServiceMode || c.LANDisabled != prev.LANDisabled ||
			c.UpdateCheckDisabled != prev.UpdateCheckDisabled || c.UpdateSkipVersion != prev.UpdateSkipVersion {
			select {
			case statusDirty <- struct{}{}:
			default:
			}
		}
		// 快捷窗口据此重新注册快捷键、换语言；关掉快捷粘贴时它自己退出
		hub.Publish(rpc.EventConfigChanged(rpc.ConfigToProto(c)))
		quickPaste.SetEnabled(!c.QuickPasteDisabled)
		return nil
	}

	// ── gRPC 服务 ──
	token, err := rpc.NewToken()
	if err != nil {
		return err
	}
	updater := newUpdater(paths.Root, loadCfg, func() {
		select {
		case statusDirty <- struct{}{}:
		default:
		}
	})
	deps := rpc.Deps{
		Store:                    db,
		Paths:                    paths,
		Version:                  version,
		DeviceID:                 id.DeviceID,
		LoadConfig:               loadCfg,
		SaveConfig:               saveCfgAndApply,
		Devices:                  peerMgr.Devices,
		CreatePairingCode:        peerMgr.CreatePairingCode,
		RedeemPairingCode:        peerMgr.RedeemPairingCode,
		ConfirmPairing:           peerMgr.ConfirmPairing,
		Unpair:                   peerMgr.Unpair,
		SetDeviceAddress:         peerMgr.SetDeviceAddress,
		LogFiles:                 func() ([]string, string) { return logFiles(dataDir) },
		VerboseLog:               verbose.Set,
		VerboseUntil:             verbose.Until,
		ShowNearby:               peerMgr.ShowNearby,
		Nearby:                   peerMgr.Nearby,
		PairNearby:               peerMgr.PairNearby,
		SignalingConnected:       peerMgr.Connected,
		ServerConfigured:         peerMgr.ServerConfigured,
		LANEnabled:               peerMgr.LANEnabled,
		LANBlocked:               peerMgr.LANBlocked,
		OpenLocalNetworkSettings: lan.RequestPermission,
		Fetch:                    engine.Fetch,
		FetchForPreview:          engine.FetchForPreview,
		ApplyToClipboard:         engine.ApplyToClipboardAs,
		SearchHistory:            engine.SearchHistory,
		SetFavorite:              engine.SetFavorite,
		ClipDetail:               engine.ClipDetail,
		ImagePreview:             engine.ImagePreview,
		CacheBytesUsed:           blobs.Size,
		OfficialUsage:            peerMgr.OfficialUsage,
		Permission: func() clipboard.Permission {
			ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
			defer cancel()
			return watcher.Permission(ctx)
		},
		Network: func() *pb.NetworkInfo {
			r := peerMgr.P2P().Egress()
			info := &pb.NetworkInfo{
				LocalPort: int32(r.LocalPort), Probed: int32(r.Probed),
				Answered: int32(r.Answered), ProbedAtUnix: r.At.Unix(),
			}
			for _, e := range r.Egresses {
				info.Egresses = append(info.Egresses, &pb.NetworkEgress{
					Address: e.Addr.String(), PortPreserved: e.PortPreserved,
					Guessed: e.Guessed(), Via: e.Via,
				})
			}
			info.Lan = peerMgr.LANInfo()
			return info
		},
		OpenPermissionSettings: func() error {
			ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
			defer cancel()
			return watcher.OpenPermissionSettings(ctx)
		},
		NotificationStatus:   notifier.Status,
		RequestNotifications: notifier.Request,
		ActivateNotification: notifier.Activate,
		Transfers:            sender,
	}
	wireUpdater(&deps, updater)
	srv := rpc.NewServer(deps, hub, token)
	if updater != nil {
		go updater.Run(ctx)
	}

	// 信令连接与在线对端数的变化推给 UI。Subscribe 只在建立订阅时推一次状态，
	// 没有这里的话，UI 会一直停留在它打开那一刻的连接状态。
	go func() {
		for {
			select {
			case <-ctx.Done():
				return
			case <-statusDirty:
				if st, err := srv.GetStatus(ctx, &pb.Empty{}); err == nil {
					hub.Publish(rpc.EventStatusChanged(st))
				}
			}
		}
	}()

	port, grpcServer, err := srv.Serve(ctx)
	if err != nil {
		return err
	}
	// 界面开着时它的事件订阅一直不结束，GracefulStop 会等到界面断开为止：
	// 被界面「重新启动」或更新时，旧进程就一直占着单实例锁，新的起不来。最多等两秒，然后断开所有连接
	defer func() {
		done := make(chan struct{})
		go func() { grpcServer.GracefulStop(); close(done) }()
		select {
		case <-done:
		case <-time.After(2 * time.Second):
			grpcServer.Stop()
		}
	}()

	// UI 靠这个文件发现 daemon
	if err := rpc.WriteEndpoint(paths.Endpoint, rpc.Endpoint{
		Port: port, Token: token, PID: os.Getpid(), Version: version,
	}); err != nil {
		return err
	}
	defer rpc.RemoveEndpoint(paths.Endpoint)

	slog.Info("daemon 已就绪",
		"port", port, "endpoint", paths.Endpoint, "cache", paths.Cache)

	// 托盘属于后台服务：关掉界面后仍能打开它。独立数据目录用于测试，
	// 不创建托盘，避免与用户正在运行的实例混在一起。
	trayLanguage = func() string { return loadCfg().Language }
	stopTray := startTray(ctx, cancel, dataDir == "")
	defer stopTray()

	// 系统事件（Windows 上报注销关机与唤醒，Linux 上报注销）：注销关机时正常退出，唤醒后立即重新探测网络
	clipboard.SetSystemHooks(
		func() {
			slog.Info("系统正在注销或关机，退出")
			cancel()
		},
		func() {
			slog.Info("从睡眠中唤醒，重新探测网络出口")
			peerMgr.P2P().Reprobe()
		},
	)

	// ── 主线程交给 MainLoop ──
	// 剪贴板相关的一切都在这条线程上执行，同时驱动平台的事件循环（macOS 的 run loop、Windows 的消息泵）。
	loop.Run(ctx)

	slog.Info("正在退出")
	exitWatchdog(shutdownTimeout, os.Exit)
	return nil
}

// shutdownTimeout 是收到退出信号后收尾的最长时间，见 exitWatchdog。
const shutdownTimeout = 10 * time.Second

// exitWatchdog 在收尾超时时强制结束进程。收尾（停 gRPC、关引擎、关数据库……）某一步卡住时，
// 进程不能一直占着单实例锁：界面重启或更新后台服务时，新进程会因「已有后台服务在运行」而退出，
// 旧的一直跑到重启。超时先把所有协程的堆栈写进日志，诊断报告里能看到卡在哪里。
// 退出码用 0：本来就是要退出，守护进程见到 0 不会再拉起。
func exitWatchdog(timeout time.Duration, exit func(int)) *time.Timer {
	return time.AfterFunc(timeout, func() {
		buf := make([]byte, 1<<20)
		n := runtime.Stack(buf, true)
		slog.Error("退出超时，强制结束", "timeout", timeout, "stacks", string(buf[:n]))
		exit(0)
	})
}

func resolvePaths(dataDir string) (config.Paths, error) {
	if dataDir != "" {
		abs, err := filepath.Abs(dataDir)
		if err != nil {
			return config.Paths{}, err
		}
		return config.PathsUnder(abs), nil
	}
	return config.DefaultPaths()
}

func permissionToProto(p clipboard.Permission) pb.ClipboardPermission {
	switch p {
	case clipboard.PermissionNotApplicable:
		return pb.ClipboardPermission_CLIPBOARD_PERMISSION_NOT_APPLICABLE
	case clipboard.PermissionDefault:
		return pb.ClipboardPermission_CLIPBOARD_PERMISSION_DEFAULT
	case clipboard.PermissionAsk:
		return pb.ClipboardPermission_CLIPBOARD_PERMISSION_ASK
	case clipboard.PermissionAlwaysAllow:
		return pb.ClipboardPermission_CLIPBOARD_PERMISSION_ALWAYS_ALLOW
	case clipboard.PermissionAlwaysDeny:
		return pb.ClipboardPermission_CLIPBOARD_PERMISSION_ALWAYS_DENY
	default:
		return pb.ClipboardPermission_CLIPBOARD_PERMISSION_UNSPECIFIED
	}
}

// receivedFolder 是通知里对保存位置的叫法：系统的「下载」文件夹叫 "downloads"（通知按语言翻译），
// 其他位置用文件夹的名字。
func receivedFolder(t *pb.Transfer) string {
	if len(t.GetPaths()) == 0 {
		return ""
	}
	dir := filepath.Dir(t.GetPaths()[0])
	if filepath.Clean(dir) == filepath.Clean(config.DownloadsDir()) {
		return "downloads"
	}
	return filepath.Base(dir)
}
