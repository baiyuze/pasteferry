// Package mobile 是 Android App 内嵌的 Go 核心（design/phone-sync.md 3.3.1、3.3.2 节），
// 用 gomobile bind 导出给 Kotlin：
//
//	gomobile bind -target=android/arm64 -androidapi 29 -ldflags=-checklinkname=0 ./mobile（见 scripts/build-android.sh）
//
// 组装方式与桌面的 cmd/pasteferryd 相同，只是：
//   - 只开局域网通道（服务模式固定为 lan），不连服务器；
//   - 没有托盘、桌面通知、快捷粘贴、隔空传送、好友、自动更新；
//   - 剪贴板只写不读：写由 Kotlin 宿主完成（Host.WriteClipboard），后台读不到别的 App 复制的内容，
//     手机发出的文字走 SubmitText RPC；
//   - 对端推送来的图片和文件收完后不写剪贴板，用户点了「复制」才写。
//
// Flutter 界面与桌面一样，经本机 gRPC（127.0.0.1 随机端口 + 一次性 token）连进来：
// 端口与 token 写在数据目录的 daemon.json 里，数据目录是 App 的私有目录，别的 App 读不到。
package mobile

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"os"
	"path/filepath"
	"slices"
	"strings"
	gosync "sync"
	"time"

	"google.golang.org/grpc"

	"github.com/baiyuze/pasteferry/client-core/internal/cache"
	"github.com/baiyuze/pasteferry/client-core/internal/clipboard"
	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/gc"
	"github.com/baiyuze/pasteferry/client-core/internal/identity"
	"github.com/baiyuze/pasteferry/client-core/internal/peers"
	"github.com/baiyuze/pasteferry/client-core/internal/rpc"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	syncengine "github.com/baiyuze/pasteferry/client-core/internal/sync"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/p2p"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// Host 由 Kotlin 宿主实现。gomobile 只支持基本类型，多个路径、设备名用换行分隔。
type Host interface {
	// WriteClipboard 把内容写进系统剪贴板。kind 是 text、html、image 或 files；
	// image 与 files 时 paths 是换行分隔的本地路径（都在数据目录里），宿主转成 FileProvider 的 content:// 地址。
	// Android 写剪贴板不需要焦点，App 在后台也能写
	WriteClipboard(kind, text, html, paths string) error
	// StatusChanged 在在线的电脑变化、或收到新内容时调用，宿主据此更新常驻通知。
	// online 是换行分隔的在线设备名；lastFrom、lastKind 是最近收到的一条的来源与类型（text、image、file），没有时为空
	StatusChanged(online, lastFrom, lastKind string)
}

var (
	mu      gosync.Mutex
	running *core
)

// Start 启动核心。dataDir 是 App 私有目录下的数据目录，deviceName 是第一次运行时的设备名，
// version 是 App 的版本号。已在运行时什么也不做。
func Start(dataDir, deviceName, version string, host Host) error {
	mu.Lock()
	defer mu.Unlock()
	if running != nil {
		return nil
	}
	if host == nil {
		return errors.New("host 不能为空")
	}
	c, err := start(dataDir, deviceName, version, host)
	if err != nil {
		return err
	}
	running = c
	return nil
}

// Stop 停止核心，可以再次 Start。
func Stop() {
	mu.Lock()
	c := running
	running = nil
	mu.Unlock()
	if c != nil {
		c.stop()
	}
}

// Running 报告核心是否在运行。
func Running() bool {
	mu.Lock()
	defer mu.Unlock()
	return running != nil
}

type core struct {
	cancel context.CancelFunc
	grpc   *grpc.Server
	closes []func()
	paths  config.Paths
}

func (c *core) stop() {
	c.cancel()
	if c.grpc != nil {
		done := make(chan struct{})
		go func() { c.grpc.GracefulStop(); close(done) }()
		select {
		case <-done:
		case <-time.After(2 * time.Second):
			c.grpc.Stop()
		}
	}
	for i := len(c.closes) - 1; i >= 0; i-- {
		c.closes[i]()
	}
	rpc.RemoveEndpoint(c.paths.Endpoint)
}

func start(dataDir, deviceName, version string, host Host) (_ *core, err error) {
	ctx, cancel := context.WithCancel(context.Background())
	c := &core{cancel: cancel, paths: config.PathsUnder(dataDir)}
	defer func() {
		if err != nil {
			c.stop()
		}
	}()
	paths := c.paths
	if err := paths.EnsureDirs(); err != nil {
		return nil, err
	}
	cfg, err := config.Load(paths)
	if err != nil {
		return nil, err
	}
	id, err := identity.LoadOrCreate(filepath.Join(paths.Root, "identity.json"))
	if err != nil {
		return nil, err
	}
	// 一期只在局域网里用；对端推送来的图片和文件不自动写剪贴板
	before := cfg
	cfg.DeviceID = id.DeviceID
	cfg.ServiceMode = "lan"
	cfg.MediaAutoApplyDisabled = true
	if cfg.DeviceName == "" || cfg.DeviceName == config.Default().DeviceName {
		cfg.DeviceName = strings.TrimSpace(deviceName)
	}
	if !slices.Equal(before.SyncDisabledPeers, cfg.SyncDisabledPeers) || before.DeviceID != cfg.DeviceID ||
		before.ServiceMode != cfg.ServiceMode || before.MediaAutoApplyDisabled != cfg.MediaAutoApplyDisabled ||
		before.DeviceName != cfg.DeviceName {
		if err := config.Save(paths, cfg); err != nil {
			return nil, err
		}
	}
	slog.Info("隔空贴核心启动", "device_id", id.DeviceID, "name", cfg.DeviceName, "fingerprint", id.Fingerprint(), "version", version)

	db, err := store.Open(paths.DB)
	if err != nil {
		return nil, err
	}
	c.closes = append(c.closes, func() { db.Close() })
	if err := db.RecoverReceives(); err != nil {
		return nil, err
	}
	blobs, err := cache.New(paths.Cache)
	if err != nil {
		return nil, err
	}
	_ = blobs.CleanTemp()
	favorites, err := cache.New(paths.Favorites)
	if err != nil {
		return nil, err
	}

	var cfgMu gosync.RWMutex
	loadCfg := func() config.Config {
		cfgMu.RLock()
		defer cfgMu.RUnlock()
		return cfg
	}
	saveCfg := func(next config.Config) error {
		cfgMu.Lock()
		defer cfgMu.Unlock()
		next.ServiceMode = "lan" // 一期界面上没有服务器设置，防止被意外改掉
		if err := config.Save(paths, next); err != nil {
			return err
		}
		cfg = next
		return nil
	}

	hub := rpc.NewHub()

	// 剪贴板：Watcher 要一个主循环来串行执行读写；Android 上 Kotlin 自己切到主线程，这里普通 goroutine 即可
	loop := clipboard.NewMainLoop()
	go loop.Run(ctx)
	watcher := clipboard.NewWatcher(clipboard.WatcherOptions{
		Clipboard: newHostClipboard(host, filepath.Join(paths.Root, "clipboard")),
		MainLoop:  loop,
	})

	var engine *syncengine.Engine
	var peerMgr *peers.Manager
	notify := newStatusNotifier(host)

	statusDirty := make(chan struct{}, 1)
	markDirty := func() {
		select {
		case statusDirty <- struct{}{}:
		default:
		}
	}

	peerMgr, err = peers.NewManager(peers.Options{
		Identity:   id,
		Store:      db,
		LoadConfig: loadCfg,
		StatePath:  filepath.Join(paths.Root, "egress.json"),
		AppVersion: version,
		OnDeviceChanged: func(d *pb.Device) {
			hub.Publish(rpc.EventDeviceChanged(d))
			if peerMgr != nil {
				notify.online(peerMgr)
			}
		},
		OnStatusChanged: markDirty,
		OnPeerMessage: func(deviceID string, msg *pb.PeerMessage) {
			if engine != nil {
				engine.HandlePeerMessage(ctx, deviceID, msg)
			}
		},
		OnPeerStream: func(deviceID, label string, stream *p2p.Stream) {
			if engine != nil {
				engine.HandlePeerStream(deviceID, label, stream)
			} else {
				stream.Close()
			}
		},
		OnPeerReady: func(deviceID string) {
			if engine != nil {
				go engine.PeerReady(ctx, deviceID)
			}
		},
		// 一期没有好友与隔空传送：名片只带设备名，别人开来的隔空传送数据流一律关掉
		Card: func() *pb.FriendCard {
			n := loadCfg().DeviceName
			return &pb.FriendCard{DisplayName: n, DeviceName: n, Platform: "android"}
		},
		Avatar:          func() []byte { return nil },
		SaveAvatar:      func(string, []byte) (string, error) { return "", errors.New("不支持好友") },
		ShareableStream: func(string) bool { return false },
		InUse:           func(string) bool { return false },
	})
	if err != nil {
		return nil, err
	}

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
		OnClipboardResult: func(result *pb.ClipboardWriteResult) {
			hub.Publish(&pb.Event{Payload: &pb.Event_ClipboardWritten{ClipboardWritten: result}})
		},
		OnRecord: func(r *pb.ClipRecord) {
			hub.Publish(rpc.EventClipAdded(r))
			if !r.GetOutgoing() && !r.GetFavorite() {
				notify.received(r)
			}
		},
		OnRemoved: func(id string) { hub.Publish(rpc.EventClipRemoved(id)) },
		OnProgress: func(p *pb.TransferProgress) {
			hub.Publish(rpc.EventProgress(p))
		},
	})
	c.closes = append(c.closes, engine.Close)
	// 后台读不到别的 App 复制的内容，Watcher 只会看到自己写入的变化；照样接上，行为与桌面一致
	watcher.SetOnChange(func(snap clipboard.Snapshot) { go engine.HandleClipboardChange(ctx, snap) })

	// 停止时要等 Run 退出（它在退出前关掉局域网通道、放掉 8788 端口），再关 P2P：
	// 桌面上进程退出时这些自然就没了，这里要能停了再启动
	runDone := make(chan struct{})
	go func() { peerMgr.Run(ctx); close(runDone) }()
	c.closes = append(c.closes, func() {
		select {
		case <-runDone:
		case <-time.After(3 * time.Second):
			slog.Warn("等局域网通道停下超时")
		}
		peerMgr.P2P().Close()
	})
	go watcher.Run(ctx)
	go gc.New(gc.Options{
		Store: db, Cache: blobs, Favorites: favorites, LoadConfig: loadCfg,
		OnRemoved: func(ids []string) {
			for _, cid := range ids {
				hub.Publish(rpc.EventClipRemoved(cid))
			}
		},
	}).Run(ctx)

	saveCfgAndApply := func(next config.Config) error {
		prev := loadCfg()
		if err := saveCfg(next); err != nil {
			return err
		}
		if next.RealtimeSyncDisabled != prev.RealtimeSyncDisabled || next.SyncBacklog != prev.SyncBacklog ||
			!slices.Equal(next.SyncDisabledPeers, prev.SyncDisabledPeers) {
			engine.ApplySyncPolicy()
		}
		if next.LANDisabled != prev.LANDisabled {
			peerMgr.SetLANEnabled(!next.LANDisabled)
		}
		hub.Publish(rpc.EventConfigChanged(rpc.ConfigToProto(loadCfg())))
		markDirty()
		return nil
	}

	token, err := rpc.NewToken()
	if err != nil {
		return nil, err
	}
	srv := rpc.NewServer(rpc.Deps{
		Store:              db,
		Paths:              paths,
		Version:            version,
		DeviceID:           id.DeviceID,
		LoadConfig:         loadCfg,
		SaveConfig:         saveCfgAndApply,
		Devices:            peerMgr.Devices,
		CreatePairingCode:  peerMgr.CreatePairingCode,
		RedeemPairingCode:  peerMgr.RedeemPairingCode,
		ConfirmPairing:     peerMgr.ConfirmPairing,
		Unpair:             peerMgr.Unpair,
		Reconnect:          peerMgr.Reconnect,
		SetDeviceAddress:   peerMgr.SetDeviceAddress,
		ShowNearby:         peerMgr.ShowNearby,
		Nearby:             peerMgr.Nearby,
		PairNearby:         peerMgr.PairNearby,
		SignalingConnected: peerMgr.Connected,
		ServerConfigured:   peerMgr.ServerConfigured,
		LANEnabled:         peerMgr.LANEnabled,
		LANBlocked:         peerMgr.LANBlocked,
		Fetch:              engine.Fetch,
		FetchForPreview:    engine.FetchForPreview,
		ApplyToClipboard:   engine.ApplyToClipboardAs,
		SearchHistory:      engine.SearchHistory,
		SetFavorite:        engine.SetFavorite,
		SetAlias:           engine.SetAlias,
		ClipDetail:         engine.ClipDetail,
		ImagePreview:       engine.ImagePreview,
		CacheBytesUsed:     blobs.Size,
		Permission:         func() clipboard.Permission { return clipboard.PermissionNotApplicable },
		Network: func() *pb.NetworkInfo {
			return &pb.NetworkInfo{Lan: peerMgr.LANInfo()}
		},
		SubmitText: func(ctx context.Context, text string) (store.Clip, error) {
			// 手机本机的内容：不写回手机自己的剪贴板
			return engine.SubmitLocal(ctx, clipboard.Content{Kind: clipboard.KindText, Text: text}, "", false)
		},
		SubmitFiles: func(ctx context.Context, paths []string) (store.Clip, error) {
			return engine.SubmitLocal(ctx, clipboard.Content{Kind: clipboard.KindFile, Files: paths}, "", false)
		},
	}, hub, token)

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
		return nil, err
	}
	c.grpc = grpcServer
	if err := rpc.WriteEndpoint(paths.Endpoint, rpc.Endpoint{Port: port, Token: token, PID: os.Getpid(), Version: version}); err != nil {
		return nil, fmt.Errorf("写 daemon.json: %w", err)
	}
	notify.online(peerMgr)
	slog.Info("隔空贴核心就绪", "port", port, "data", paths.Root)
	return c, nil
}

// statusNotifier 把在线的电脑与最近收到的内容告诉宿主，宿主更新常驻通知。只报名字和类型，不报内容。
type statusNotifier struct {
	host     Host
	mu       gosync.Mutex
	names    string
	lastFrom string
	lastKind string
}

func newStatusNotifier(h Host) *statusNotifier { return &statusNotifier{host: h} }

func (n *statusNotifier) online(m *peers.Manager) {
	_, list := m.Devices()
	var names []string
	for _, d := range list {
		if d.GetOnline() {
			names = append(names, d.GetName())
		}
	}
	n.mu.Lock()
	n.names = strings.Join(names, "\n")
	n.mu.Unlock()
	n.push()
}

func (n *statusNotifier) received(r *pb.ClipRecord) {
	kind := "file"
	switch r.GetKind() {
	case pb.ClipKind_CLIP_KIND_TEXT, pb.ClipKind_CLIP_KIND_HTML:
		kind = "text"
	case pb.ClipKind_CLIP_KIND_IMAGE:
		kind = "image"
	}
	n.mu.Lock()
	n.lastFrom, n.lastKind = r.GetOriginDeviceName(), kind
	n.mu.Unlock()
	n.push()
}

func (n *statusNotifier) push() {
	n.mu.Lock()
	names, from, kind := n.names, n.lastFrom, n.lastKind
	n.mu.Unlock()
	n.host.StatusChanged(names, from, kind)
}
