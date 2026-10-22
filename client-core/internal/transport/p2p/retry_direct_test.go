package p2p

import (
	"context"
	"testing"
	"time"

	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// fakeRelay 让两端都谎报「我这边走中转」，两端随之显示中转，见 TestUpgradeFromRelay。
// 自动换直连的间隔调到很长，测到的只能是「重新连接」触发的那一次。
func fakeRelay(t *testing.T) (alice, bob *testNode, bus *signalBus) {
	t.Helper()
	saveDelays := upgradeDelays
	upgradeDelays = []time.Duration{time.Hour}
	t.Cleanup(func() { upgradeDelays = saveDelays })

	alice, bob, bus = connectPairOn(t)
	for _, p := range []*Peer{alice.peer("bob"), bob.peer("alice")} {
		if err := p.Send(&pb.PeerMessage{Payload: &pb.PeerMessage_Link{
			Link: &pb.LinkInfo{Relayed: true},
		}}); err != nil {
			t.Fatalf("发送 LinkInfo: %v", err)
		}
	}
	waitState(t, alice, "bob", StateRelay, 5*time.Second)
	waitState(t, bob, "alice", StateRelay, 5*time.Second)
	return alice, bob, bus
}

// restartsOf 是 p 经历的 ICE 重启次数，发起的和应答的都算。
func restartsOf(p *Peer) int {
	p.mu.Lock()
	defer p.mu.Unlock()
	return p.restarts
}

// TestRetryDirectFromOfferer 验证发起方点「重新连接」马上做 ICE 重启、回到直连，
// 有数据在传也不推迟。
func TestRetryDirectFromOfferer(t *testing.T) {
	alice, bob, _ := fakeRelay(t)
	alice.peer("bob").touch() // 刚有过消息往来：自动换直连会推迟，手动的不该

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	if err := alice.m.RetryDirect(ctx, "bob"); err != nil {
		t.Fatalf("RetryDirect: %v", err)
	}
	waitState(t, alice, "bob", StateDirect, 20*time.Second)
	waitState(t, bob, "alice", StateDirect, 20*time.Second)
	if restartsOf(alice.peer("bob")) == 0 {
		t.Fatal("alice 没有做 ICE 重启")
	}
}

// TestRetryDirectFromAnswerer 验证应答方点「重新连接」时，请发起方来做 ICE 重启，自己不发起。
func TestRetryDirectFromAnswerer(t *testing.T) {
	alice, bob, bus := fakeRelay(t)
	bobOffers := bus.offersFrom("bob")

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	if err := bob.m.RetryDirect(ctx, "alice"); err != nil {
		t.Fatalf("RetryDirect: %v", err)
	}
	waitState(t, bob, "alice", StateDirect, 20*time.Second)
	waitState(t, alice, "bob", StateDirect, 20*time.Second)
	if restartsOf(alice.peer("bob")) == 0 {
		t.Error("alice 没有做 ICE 重启")
	}
	if n := bus.offersFrom("bob") - bobOffers; n != 0 {
		t.Errorf("应答方 bob 自己发了 %d 个 offer，应该请 alice 发起", n)
	}
}

// TestRetryDirectWhenDirect 验证已是直连时「重新连接」什么也不做。
func TestRetryDirectWhenDirect(t *testing.T) {
	alice, bob := connectPair(t)
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	if err := alice.m.RetryDirect(ctx, "bob"); err != nil {
		t.Fatalf("alice RetryDirect: %v", err)
	}
	if err := bob.m.RetryDirect(ctx, "alice"); err != nil {
		t.Fatalf("bob RetryDirect: %v", err)
	}
	time.Sleep(time.Second)
	if n := restartsOf(alice.peer("bob")) + restartsOf(bob.peer("alice")); n != 0 {
		t.Errorf("已是直连，却做了 %d 次 ICE 重启", n)
	}
	if s := alice.m.State("bob"); s != StateDirect {
		t.Errorf("alice 的状态 = %v，应仍为直连", s)
	}
}

// TestRetryDirectWhenOffline 验证还没连上时「重新连接」马上发起连接，不等巡检。
func TestRetryDirectWhenOffline(t *testing.T) {
	bus := &signalBus{targets: map[string]*Manager{}}
	alice := newTestNode(t, bus, "alice")
	bob := newTestNode(t, bus, "bob")

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	// 从应答方点：请发起方来连
	if err := bob.m.RetryDirect(ctx, "alice"); err != nil {
		t.Fatalf("RetryDirect: %v", err)
	}
	waitState(t, alice, "bob", StateDirect, 20*time.Second)
	waitState(t, bob, "alice", StateDirect, 20*time.Second)
}
