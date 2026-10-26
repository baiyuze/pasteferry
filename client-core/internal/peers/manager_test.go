package peers

import (
	"context"
	"errors"
	"io"
	"log/slog"
	"net"
	"net/http/httptest"
	"path/filepath"
	"slices"
	"strconv"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/identity"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/lan"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/p2p"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
	turnrelay "github.com/baiyuze/pasteferry/server/relay"
	"github.com/baiyuze/pasteferry/server/signal"
)

// device 是测试里的一台完整设备：真实的 peers.Manager、数据库和身份。
type device struct {
	name string
	m    *Manager

	mu       sync.Mutex
	cfg      config.Config
	sessions chan string // 对方兑换了我的码，界面上该弹出的确认
	messages chan *pb.PeerMessage
}

func newDevice(t *testing.T, name string, net *lan.MemoryNetwork, cfg config.Config) *device {
	t.Helper()
	dir := t.TempDir()
	id, err := identity.LoadOrCreate(filepath.Join(dir, "identity.json"))
	if err != nil {
		t.Fatal(err)
	}
	db, err := store.Open(filepath.Join(dir, "pasteferry.db"))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { db.Close() })

	cfg.DeviceName = name
	d := &device{
		name:     name,
		cfg:      cfg,
		sessions: make(chan string, 4),
		messages: make(chan *pb.PeerMessage, 16),
	}
	var disc lan.Discovery
	if net != nil {
		disc = net.Discovery()
	}
	d.m, err = NewManager(Options{
		Identity:   id,
		Store:      db,
		Logger:     slog.New(slog.NewTextHandler(io.Discard, nil)),
		LoadConfig: d.config,
		StatePath:  filepath.Join(dir, "egress.json"),
		OnDeviceChanged: func(dev *pb.Device) {
			if dev.GetPairingSession() != "" {
				d.sessions <- dev.GetPairingSession()
			}
		},
		OnPeerMessage: func(_ string, msg *pb.PeerMessage) { d.messages <- msg },
		LANPort:       -1,
		LANDiscovery:  disc,
	})
	if err != nil {
		t.Fatal(err)
	}
	ctx, cancel := context.WithCancel(context.Background())
	done := make(chan struct{})
	go func() { d.m.Run(ctx); close(done) }()
	t.Cleanup(func() {
		cancel()
		<-done
		d.m.P2P().Close()
	})
	return d
}

func (d *device) config() config.Config {
	d.mu.Lock()
	defer d.mu.Unlock()
	return d.cfg
}

func (d *device) id() string { return d.m.identity.DeviceID }

func lanOnly() config.Config {
	c := config.Default()
	c.SignalingURL = ""
	return c
}

func waitFor(t *testing.T, what string, cond func() bool) {
	t.Helper()
	waitForWithin(t, what, 15*time.Second, cond)
}

func waitForWithin(t *testing.T, what string, timeout time.Duration, cond func() bool) {
	t.Helper()
	deadline := time.Now().Add(timeout)
	for !cond() {
		if time.Now().After(deadline) {
			t.Fatalf("等不到：%s", what)
		}
		time.Sleep(50 * time.Millisecond)
	}
}

func waitLANUp(t *testing.T, ds ...*device) {
	t.Helper()
	for _, d := range ds {
		waitFor(t, d.name+" 的局域网通道开启", d.m.LANEnabled)
	}
}

// pairDevices 走一遍完整的配对：a 显示码，b 输入码（和地址），双方核对后确认。
func pairDevices(t *testing.T, a, b *device, address string) {
	t.Helper()
	ctx := context.Background()
	code, _, addrs, err := a.m.CreatePairingCode(ctx)
	if err != nil {
		t.Fatalf("生成配对码: %v", err)
	}
	if len(code) != 6 {
		t.Fatalf("配对码格式不对: %q", code)
	}
	_ = addrs

	peer, session, err := b.m.RedeemPairingCode(ctx, strings.ToLower(code), address)
	if err != nil {
		t.Fatalf("兑换配对码: %v", err)
	}
	if peer.GetId() != a.id() {
		t.Fatalf("找到的不是 a: %v", peer)
	}

	var aSession string
	select {
	case aSession = <-a.sessions:
	case <-time.After(5 * time.Second):
		t.Fatal("显示码的一方没收到配对请求")
	}
	if err := a.m.ConfirmPairing(ctx, aSession, true); err != nil {
		t.Fatal(err)
	}
	if err := b.m.ConfirmPairing(ctx, session, true); err != nil {
		t.Fatal(err)
	}
}

func waitDirect(t *testing.T, a, b *device) {
	t.Helper()
	waitFor(t, "P2P 直连", func() bool {
		return a.m.P2P().State(b.id()) == p2p.StateDirect && b.m.P2P().State(a.id()) == p2p.StateDirect
	})
}

func sendAndExpect(t *testing.T, from, to *device, clipID string) {
	t.Helper()
	msg := &pb.PeerMessage{Payload: &pb.PeerMessage_Fetch{Fetch: &pb.PeerFetch{ClipId: clipID}}}
	if err := from.m.P2P().Send(to.id(), msg); err != nil {
		t.Fatal(err)
	}
	deadline := time.After(5 * time.Second)
	for {
		select {
		case got := <-to.messages:
			if got.GetFetch().GetClipId() == clipID {
				return
			}
		case <-deadline:
			t.Fatalf("%s 没收到 %s 发的消息", to.name, from.name)
		}
	}
}

// 没有服务器：同一网络里的两台设备配对、直连、互发消息。
func TestPairAndConnectWithoutServer(t *testing.T) {
	net := lan.NewMemoryNetwork()
	a, b := newDevice(t, "a", net, lanOnly()), newDevice(t, "b", net, lanOnly())
	waitLANUp(t, a, b)

	pairDevices(t, a, b, "")
	waitDirect(t, a, b)
	sendAndExpect(t, a, b, "clip-1")
	sendAndExpect(t, b, a, "clip-2")

	_, peers := a.m.Devices()
	if len(peers) != 1 || !peers[0].GetOnline() {
		t.Fatalf("配对后对方应当显示在线: %v", peers)
	}

	// 解除配对后连接要断开，对方也不再显示
	if err := a.m.Unpair(context.Background(), b.id()); err != nil {
		t.Fatal(err)
	}
	waitFor(t, "解除配对后断开连接", func() bool { return a.m.P2P().State(b.id()) == p2p.StateOffline })
	if _, peers := a.m.Devices(); len(peers) != 0 {
		t.Fatalf("解除配对后不该还有设备: %v", peers)
	}
}

// 不在同一网段：mDNS 找不到对方，输入对方显示的地址配对；之后靠地址簿重新找到对方。
func TestPairByAddressAcrossSubnets(t *testing.T) {
	a := newDevice(t, "a", lan.NewMemoryNetwork(), lanOnly())
	b := newDevice(t, "b", lan.NewMemoryNetwork(), lanOnly())
	waitLANUp(t, a, b)

	ctx := context.Background()
	code, _, _, err := a.m.CreatePairingCode(ctx)
	if err != nil {
		t.Fatal(err)
	}
	if _, _, err := b.m.RedeemPairingCode(ctx, code, ""); !errors.Is(err, lan.ErrNotFound) {
		t.Fatalf("不输地址应当找不到，得到 %v", err)
	}
	// 上一次兑换没碰到 a，码还有效；这次带上地址
	a.m.lan.ClosePairing()
	addr := "127.0.0.1:" + strconv.Itoa(a.m.lan.Port())
	pairDevices(t, a, b, addr)
	waitDirect(t, a, b)
	sendAndExpect(t, b, a, "clip-3")
}

// 关掉局域网，只用服务器：原来的配对路径不受影响。
func TestServerOnlyPairingStillWorks(t *testing.T) {
	// Hosted Windows runners may block UDP routed through their own NIC.
	// Match the transport relay fixtures: listen on the wildcard socket while
	// advertising loopback, so Windows can route both allocation directions.
	// Keep the real P2P/message assertions.
	socket, err := net.ListenPacket("udp4", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	port := socket.LocalAddr().(*net.UDPAddr).Port
	_ = socket.Close()
	turnServer, err := turnrelay.New(turnrelay.Options{PublicIP: "127.0.0.1", Port: port, Secret: "local-pairing-test", CredentialTTL: time.Hour})
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = turnServer.Close() })
	srv := httptest.NewServer(signal.NewServer(signal.Options{ICEServers: func(id string) []*pb.IceServer {
		credential := turnServer.Issue(id)
		return []*pb.IceServer{{Urls: credential.URLs, Username: credential.Username, Credential: credential.Password}}
	}}))
	t.Cleanup(srv.Close)
	cfg := config.Default()
	cfg.SignalingURL = "ws" + strings.TrimPrefix(srv.URL, "http") + "/signal"
	cfg.LANDisabled = true
	// This fixture has a local signaling server and no external STUN service.
	// Public probe reachability must not decide whether local pairing passes.
	cfg.OnlyOwnSTUN = true

	a, b := newDevice(t, "a", nil, cfg), newDevice(t, "b", nil, cfg)
	waitFor(t, "连上服务器", func() bool { return a.m.Connected() && b.m.Connected() })
	if a.m.LANEnabled() {
		t.Fatal("关掉局域网后不该开启局域网通道")
	}

	pairDevices(t, a, b, "")
	// 托管的 CI 机器上第一次 ICE 偶尔连不上（经网卡的 UDP 可能被拦），之后由每 10 秒一次的巡检
	// 重新连接（第一次尝试最长 30 秒才放弃）。这里验证的是只靠服务器配对最终能连通，所以等足一轮重连
	waitForWithin(t, "P2P 连通", 60*time.Second, func() bool { return connected(a.m.P2P().State(b.id())) })
	sendAndExpect(t, a, b, "clip-4")

	// 服务器上不存在的码：立即报错，而不是干等
	start := time.Now()
	if _, _, err := b.m.RedeemPairingCode(context.Background(), "ZZZZZZ", ""); !errors.Is(err, ErrCodeRejected) {
		t.Fatalf("错码应当被服务器拒绝，得到 %v", err)
	}
	if time.Since(start) > 5*time.Second {
		t.Errorf("服务器拒绝后应当马上返回，花了 %v", time.Since(start))
	}
}

// 局域网和服务器都开着：同一个码两边都开放，用掉一次就失效。
func TestCodeUsableOnceAcrossChannels(t *testing.T) {
	srv := httptest.NewServer(signal.NewServer(signal.Options{}))
	t.Cleanup(srv.Close)
	cfg := config.Default()
	cfg.SignalingURL = "ws" + strings.TrimPrefix(srv.URL, "http") + "/signal"

	net := lan.NewMemoryNetwork()
	a, b, c := newDevice(t, "a", net, cfg), newDevice(t, "b", net, cfg), newDevice(t, "c", net, cfg)
	waitFor(t, "连上服务器", func() bool { return a.m.Connected() && b.m.Connected() && c.m.Connected() })
	waitLANUp(t, a, b, c)

	ctx := context.Background()
	code, _, _, err := a.m.CreatePairingCode(ctx)
	if err != nil {
		t.Fatal(err)
	}
	if _, _, err := b.m.RedeemPairingCode(ctx, code, ""); err != nil {
		t.Fatal(err)
	}
	<-a.sessions
	// c 拿同一个码：局域网里已撤下，服务器那边的兑换也会被 a 忽略
	_, _, _ = c.m.RedeemPairingCode(ctx, code, "")
	select {
	case s := <-a.sessions:
		t.Fatalf("同一个码不该被用第二次，又收到配对请求 %s", s)
	case <-time.After(time.Second):
	}
}

// 搜索附近设备：两台都打开窗口，a 点了 b，b 弹出确认（重复的请求只弹一次），
// 双方核对后确认、直连；之后 b 在 a 的列表里显示为已配对。
func TestPairNearby(t *testing.T) {
	net := lan.NewMemoryNetwork()
	a, b := newDevice(t, "办公室的 Mac", net, lanOnly()), newDevice(t, "b", net, lanOnly())
	waitLANUp(t, a, b)
	hideA, hideB := a.m.ShowNearby(), b.m.ShowNearby()
	defer hideA()
	defer hideB()

	var target *pb.NearbyDevice
	waitFor(t, "a 看到附近的 b", func() bool {
		list := a.m.Nearby()
		if len(list) == 1 {
			target = list[0]
		}
		return target != nil
	})
	if target.GetName() != "b" || target.GetPaired() {
		t.Fatalf("附近的设备信息不对: %v", target)
	}
	waitFor(t, "b 看到附近的 a", func() bool {
		list := b.m.Nearby()
		return len(list) == 1 && list[0].GetName() == "办公室的 Mac"
	})

	ctx := context.Background()
	peer, session, err := a.m.PairNearby(ctx, target.GetId())
	if err != nil {
		t.Fatalf("向附近的设备发起配对: %v", err)
	}
	if peer.GetId() != b.id() || peer.GetName() != "b" {
		t.Fatalf("配对的不是 b: %v", peer)
	}
	var bSession string
	select {
	case bSession = <-b.sessions:
	case <-time.After(5 * time.Second):
		t.Fatal("b 没收到配对请求")
	}
	// a 没收到回复时会重发；同一台设备的请求只弹一次确认
	if _, _, err := a.m.PairNearby(ctx, target.GetId()); err != nil {
		t.Fatalf("再点一次: %v", err)
	}
	select {
	case s := <-b.sessions:
		t.Fatalf("同一台设备的请求不该再弹一次确认: %s", s)
	case <-time.After(300 * time.Millisecond):
	}

	if err := b.m.ConfirmPairing(ctx, bSession, true); err != nil {
		t.Fatal(err)
	}
	if err := a.m.ConfirmPairing(ctx, session, true); err != nil {
		t.Fatal(err)
	}
	waitDirect(t, a, b)
	sendAndExpect(t, a, b, "clip-nearby")
	waitFor(t, "b 在 a 的列表里显示为已配对", func() bool {
		list := a.m.Nearby()
		return len(list) == 1 && list[0].GetPaired()
	})
}

// 对方没打开窗口时看不到它，也配不上。
func TestNearbyNeedsBothWindows(t *testing.T) {
	net := lan.NewMemoryNetwork()
	a, b := newDevice(t, "a", net, lanOnly()), newDevice(t, "b", net, lanOnly())
	waitLANUp(t, a, b)
	defer a.m.ShowNearby()()

	time.Sleep(500 * time.Millisecond)
	if list := a.m.Nearby(); len(list) != 0 {
		t.Fatalf("b 没打开窗口，不该出现在附近: %v", list)
	}
	if _, _, err := a.m.PairNearby(context.Background(), "pasteferry-000000000000"); !errors.Is(err, lan.ErrNotFound) {
		t.Fatalf("应当找不到，得到 %v", err)
	}
	if _, peers := b.m.Devices(); len(peers) != 0 {
		t.Fatalf("b 不该多出设备: %v", peers)
	}
}

// 两端同版本：功能声明迟到或丢失后，刷新声明恢复接收能力与用户开关。
func TestRefreshPeerFeatures(t *testing.T) {
	network := lan.NewMemoryNetwork()
	a, b := newDevice(t, "a", network, lanOnly()), newDevice(t, "b", network, lanOnly())
	waitLANUp(t, a, b)
	pairDevices(t, a, b, "")
	waitDirect(t, a, b)
	waitFor(t, "双方收到功能声明", func() bool {
		sa, _ := a.m.SendFilesSupport(b.id())
		sb, _ := b.m.SendFilesSupport(a.id())
		return sa && sb
	})
	a.m.mu.Lock()
	delete(a.m.features, b.id()) // 模拟没有收到对方的首条声明
	a.m.mu.Unlock()
	b.m.BroadcastFeatures()
	waitFor(t, "刷新恢复接收能力", func() bool { ok, _ := a.m.SendFilesSupport(b.id()); return ok })
	b.mu.Lock()
	b.cfg.ReceiveDisabled = true
	b.mu.Unlock()
	b.m.BroadcastFeatures()
	waitFor(t, "刷新接收开关", func() bool { ok, off := a.m.SendFilesSupport(b.id()); return ok && off })
	if !a.m.HasFeature(b.id(), FeatureSendFilesTCP) {
		t.Fatal("快速通道能力丢失")
	}
}

func peerDevice(t *testing.T, d *device, id string) *pb.Device {
	t.Helper()
	dev, ok := d.m.device(id)
	if !ok {
		t.Fatalf("%s 没有设备 %s", d.name, id)
	}
	return dev
}

// 没连上的设备只能说「还不知道」：在线（服务器或局域网报告）但 P2P 没通时，
// 不能因为没收到声明就判定为旧版本。
func TestFeaturesUnknownWhileNotConnected(t *testing.T) {
	a := newDevice(t, "a", nil, lanOnly())
	peer := store.Device{ID: "peer", Name: "peer", PublicKey: make([]byte, 32), PairedAt: time.Now()}
	if err := a.m.store.PutDevice(peer); err != nil {
		t.Fatal(err)
	}
	a.m.mu.Lock()
	a.m.known[peer.ID] = peer
	a.m.serverOnline[peer.ID] = true
	a.m.mu.Unlock()
	a.m.checkLegacy(peer.ID)
	dev := peerDevice(t, a, peer.ID)
	if !dev.GetOnline() || dev.GetFeaturesKnown() || dev.GetReceivesFiles() {
		t.Fatalf("没连上就判定了功能: %v", dev)
	}
}

// 收到声明后知道对方能收文件和它的版本号，并存进数据库；重启后不必等连上就知道。
func TestFeaturesDeclaredAndRemembered(t *testing.T) {
	network := lan.NewMemoryNetwork()
	a, b := newDevice(t, "a", network, lanOnly()), newDevice(t, "b", network, lanOnly())
	b.m.appVersion = "2.5.4"
	waitLANUp(t, a, b)
	pairDevices(t, a, b, "")
	waitDirect(t, a, b)
	waitFor(t, "a 收到 b 的声明", func() bool { return peerDevice(t, a, b.id()).GetFeaturesKnown() })
	dev := peerDevice(t, a, b.id())
	if !dev.GetReceivesFiles() || dev.GetAppVersion() != "2.5.4" {
		t.Fatalf("声明不对: %v", dev)
	}
	devices, err := a.m.store.ListDevices()
	if err != nil || len(devices) != 1 {
		t.Fatalf("读设备: %v %v", devices, err)
	}
	got := devices[0]
	if got.AppVersion != "2.5.4" || !slices.Contains(got.Features, FeatureSendFiles) {
		t.Fatalf("没存下声明: %+v", got)
	}

	// 用同一个数据库再建一个 Manager，相当于重启：还没连上就知道对方的功能
	restarted, err := NewManager(Options{
		Identity:   a.m.identity,
		Store:      a.m.store,
		Logger:     slog.New(slog.NewTextHandler(io.Discard, nil)),
		LoadConfig: lanOnly,
		StatePath:  filepath.Join(t.TempDir(), "egress.json"),
		LANPort:    -1,
	})
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { restarted.P2P().Close() })
	dev, _ = restarted.device(b.id())
	if !dev.GetFeaturesKnown() || !dev.GetReceivesFiles() || dev.GetAppVersion() != "2.5.4" {
		t.Fatalf("重启后没读回声明: %v", dev)
	}
}

// 旧版本从不发声明：连上 legacyWait 后仍没有，才判定为旧版本，并清掉上次存下的声明。
func TestLegacyPeerAfterWait(t *testing.T) {
	old := legacyWait
	legacyWait = 300 * time.Millisecond
	t.Cleanup(func() { legacyWait = old })
	network := lan.NewMemoryNetwork()
	a, b := newDevice(t, "a", network, lanOnly()), newDevice(t, "b", network, lanOnly())
	b.m.noFeatures = true
	waitLANUp(t, a, b)
	pairDevices(t, a, b, "")
	waitDirect(t, a, b)
	waitFor(t, "判定为旧版本", func() bool { return peerDevice(t, a, b.id()).GetFeaturesKnown() })
	if dev := peerDevice(t, a, b.id()); dev.GetReceivesFiles() || dev.GetAppVersion() != "" {
		t.Fatalf("旧版本不该能收文件: %v", dev)
	}
}
