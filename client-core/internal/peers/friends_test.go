package peers

import (
	"context"
	"errors"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/lan"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/p2p"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
	"github.com/baiyuze/pasteferry/server/signal"
)

// friendDevice 是带好友回调的测试设备：好友码被兑换时推来的确认请求、好友变化都记下来。
type friendEvents struct {
	requests chan *pb.FriendRequest
	removed  chan string
}

func newFriendDevice(t *testing.T, name string, net *lan.MemoryNetwork, cfg config.Config) (*device, *friendEvents) {
	t.Helper()
	d := newDevice(t, name, net, cfg)
	ev := &friendEvents{requests: make(chan *pb.FriendRequest, 4), removed: make(chan string, 4)}
	d.m.onFriendRequest = func(r *pb.FriendRequest) { ev.requests <- r }
	d.m.onFriendRemoved = func(id string) { ev.removed <- id }
	d.m.card = func() *pb.FriendCard {
		return &pb.FriendCard{DisplayName: "用户 " + name, DeviceName: name, Platform: "darwin", Service: "lan"}
	}
	d.m.shareableStream = func(label string) bool { return strings.HasPrefix(label, "send:") }
	return d, ev
}

// addFriends 走一遍加好友：a 显示好友码，b 输入；两边都点「添加」。
func addFriends(t *testing.T, a, b *device, aev *friendEvents) {
	t.Helper()
	ctx := context.Background()
	code, _, _, err := a.m.CreateFriendCode(ctx)
	if err != nil {
		t.Fatalf("生成好友码: %v", err)
	}
	if len(code) != 7 || code[0] != 'F' {
		t.Fatalf("好友码格式不对: %q", code)
	}
	req, err := b.m.RedeemFriendCode(ctx, "f-"+strings.ToLower(code[1:]), "")
	if err != nil {
		t.Fatalf("兑换好友码: %v", err)
	}
	if req.GetDeviceId() != a.id() || req.GetDisplayName() != "用户 a" {
		t.Fatalf("对方的名片不对: %v", req)
	}
	var aReq *pb.FriendRequest
	select {
	case aReq = <-aev.requests:
	case <-time.After(15 * time.Second):
		t.Fatal("显示好友码的一方没收到确认请求")
	}
	if aReq.GetDeviceId() != b.id() || aReq.GetDisplayName() != "用户 b" {
		t.Fatalf("a 看到的名片不对: %v", aReq)
	}
	if err := b.m.ConfirmFriend(ctx, req.GetSession(), true); err != nil {
		t.Fatal(err)
	}
	if _, ok := b.m.Friend(a.id()); ok {
		t.Fatal("对方还没添加，不该成为好友")
	}
	if err := a.m.ConfirmFriend(ctx, aReq.GetSession(), true); err != nil {
		t.Fatal(err)
	}
	waitFor(t, "两边都成为好友", func() bool {
		_, ok1 := a.m.Friend(b.id())
		_, ok2 := b.m.Friend(a.id())
		return ok1 && ok2
	})
}

// 局域网里加好友：好友不是配对设备，只能收发隔空传送的消息。
func TestAddFriendOnLAN(t *testing.T) {
	network := lan.NewMemoryNetwork()
	a, aev := newFriendDevice(t, "a", network, lanOnly())
	b, _ := newFriendDevice(t, "b", network, lanOnly())
	waitLANUp(t, a, b)
	addFriends(t, a, b, aev)

	if role := a.m.Role(b.id()); role != RoleFriend {
		t.Fatalf("角色应当是好友，得到 %q", role)
	}
	if devices, _ := a.m.store.ListDevices(); len(devices) != 0 {
		t.Fatalf("好友不该进配对设备: %v", devices)
	}
	// 加上后连一次，交换功能声明与名片
	waitFor(t, "好友连上并交换功能声明", func() bool {
		f, _ := a.m.Friend(b.id())
		return connected(a.m.P2P().State(b.id())) && f.GetFeaturesKnown() && f.GetReceivesFiles()
	})
	f, _ := a.m.Friend(b.id())
	if f.GetDisplayName() != "用户 b" || f.GetDeviceName() != "b" {
		t.Fatalf("好友的名片不对: %v", f)
	}

	// 剪贴板同步的消息不放行，隔空传送的放行
	clip := &pb.PeerMessage{Payload: &pb.PeerMessage_Fetch{Fetch: &pb.PeerFetch{ClipId: "secret"}}}
	if err := b.m.P2P().Send(a.id(), clip); err != nil {
		t.Fatal(err)
	}
	offer := &pb.PeerMessage{Payload: &pb.PeerMessage_SendOffer{SendOffer: &pb.SendOffer{TransferId: "t1"}}}
	if err := b.m.P2P().Send(a.id(), offer); err != nil {
		t.Fatal(err)
	}
	select {
	case got := <-a.messages:
		if got.GetSendOffer().GetTransferId() != "t1" {
			t.Fatalf("好友发来的剪贴板消息漏了进来: %v", got)
		}
	case <-time.After(5 * time.Second):
		t.Fatal("好友发来的隔空传送消息没到")
	}
	select {
	case got := <-a.messages:
		t.Fatalf("不该再收到消息: %v", got)
	case <-time.After(300 * time.Millisecond):
	}
}

// 用途不一致：好友码输进「添加设备」、配对码输进「添加好友」都被回绝，码也不会被用掉。
func TestFriendCodeIntentMismatchOnLAN(t *testing.T) {
	network := lan.NewMemoryNetwork()
	a, aev := newFriendDevice(t, "a", network, lanOnly())
	b, _ := newFriendDevice(t, "b", network, lanOnly())
	waitLANUp(t, a, b)
	ctx := context.Background()

	code, _, _, err := a.m.CreateFriendCode(ctx)
	if err != nil {
		t.Fatal(err)
	}
	if _, _, err := b.m.RedeemPairingCode(ctx, code, ""); !errors.Is(err, ErrIsFriendCode) {
		t.Fatalf("带 F 的好友码输进添加设备: %v", err)
	}
	// 去掉 F 当配对码输：局域网里回绝，码还在
	if _, _, err := b.m.RedeemPairingCode(ctx, code[1:], ""); !errors.Is(err, ErrIsFriendCode) {
		t.Fatalf("去掉 F 的好友码输进添加设备: %v", err)
	}
	if _, err := b.m.RedeemFriendCode(ctx, code, ""); err != nil {
		t.Fatalf("码被用掉了: %v", err)
	}
	select {
	case <-aev.requests:
	case <-time.After(5 * time.Second):
		t.Fatal("没收到确认请求")
	}

	pcode, _, _, err := a.m.CreatePairingCode(ctx)
	if err != nil {
		t.Fatal(err)
	}
	if _, err := b.m.RedeemFriendCode(ctx, pcode, ""); !errors.Is(err, ErrIsDeviceCode) {
		t.Fatalf("配对码输进添加好友: %v", err)
	}
}

// 删除好友：两边都删；不在线的一方上线后补发。
func TestRemoveFriend(t *testing.T) {
	network := lan.NewMemoryNetwork()
	a, aev := newFriendDevice(t, "a", network, lanOnly())
	b, bev := newFriendDevice(t, "b", network, lanOnly())
	waitLANUp(t, a, b)
	addFriends(t, a, b, aev)
	if err := a.m.RemoveFriend(context.Background(), b.id()); err != nil {
		t.Fatal(err)
	}
	select {
	case id := <-bev.removed:
		if id != a.id() {
			t.Fatalf("删错了: %s", id)
		}
	case <-time.After(10 * time.Second):
		t.Fatal("对方没收到删除好友的通知")
	}
	if _, ok := b.m.Friend(a.id()); ok {
		t.Fatal("对方还留着好友")
	}
	waitFor(t, "收到回执后不再补发", func() bool {
		a.m.mu.RLock()
		defer a.m.mu.RUnlock()
		return len(a.m.notices) == 0
	})
	if role := b.m.Role(a.id()); role != "" {
		t.Fatalf("删除后不该还有角色: %q", role)
	}
}

// 只用服务器：好友码经服务器兑换，两边用签名的信令交换用途。
func TestAddFriendViaServer(t *testing.T) {
	srv := httptest.NewServer(signal.NewServer(signal.Options{}))
	t.Cleanup(srv.Close)
	cfg := config.Default()
	cfg.SignalingURL = "ws" + strings.TrimPrefix(srv.URL, "http") + "/signal"
	cfg.LANDisabled = true
	cfg.OnlyOwnSTUN = true

	a, aev := newFriendDevice(t, "a", nil, cfg)
	b, _ := newFriendDevice(t, "b", nil, cfg)
	c, _ := newFriendDevice(t, "c", nil, cfg)
	waitFor(t, "连上服务器", func() bool { return a.m.Connected() && b.m.Connected() && c.m.Connected() })
	addFriends(t, a, b, aev)
	if a.m.Role(b.id()) != RoleFriend || b.m.Role(a.id()) != RoleFriend {
		t.Fatal("没成为好友")
	}

	// 配对码输进「添加好友」：对方说明这是配对，回绝
	ctx := context.Background()
	pcode, _, _, err := a.m.CreatePairingCode(ctx)
	if err != nil {
		t.Fatal(err)
	}
	if _, err := c.m.RedeemFriendCode(ctx, pcode, ""); !errors.Is(err, ErrIsDeviceCode) {
		t.Fatalf("配对码输进添加好友: %v", err)
	}
	// 好友码去掉 F 输进「添加设备」：确认时报出原因
	code, _, _, err := a.m.CreateFriendCode(ctx)
	if err != nil {
		t.Fatal(err)
	}
	_, session, err := c.m.RedeemPairingCode(ctx, code[1:], "")
	if err != nil {
		t.Fatal(err)
	}
	waitFor(t, "知道这是好友码", func() bool {
		c.m.mu.RLock()
		defer c.m.mu.RUnlock()
		return c.m.mismatched[session] != nil
	})
	if err := c.m.ConfirmPairing(ctx, session, true); !errors.Is(err, ErrIsFriendCode) {
		t.Fatalf("确认时应当报出这是好友码: %v", err)
	}
	if devices, _ := c.m.store.ListDevices(); len(devices) != 0 {
		t.Fatalf("好友码被当成配对码配上了: %v", devices)
	}
}

var _ = p2p.StateOffline
