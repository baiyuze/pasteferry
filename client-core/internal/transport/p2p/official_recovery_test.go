package p2p

import (
	"context"
	"sync"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/gateway"
	"github.com/baiyuze/pasteferry/client-core/internal/identity"
)

// relayFixture 搭一个已经「连通过」的官方中转：Peer 有打开的 PeerConnection，
// 状态由测试直接设置，模拟 ICE 的 Disconnected / Connected / Failed。
type relayFixture struct {
	m      *Manager
	a      *officialAttempt
	p      *Peer
	mu     sync.Mutex
	states []ConnState
}

func newRelayFixture(t *testing.T, connected bool) *relayFixture {
	t.Helper()
	oldWait, oldPoll := relayRecoveryWait, relayRecoveryPoll
	relayRecoveryWait, relayRecoveryPoll = 600*time.Millisecond, 10*time.Millisecond
	t.Cleanup(func() { relayRecoveryWait, relayRecoveryPoll = oldWait, oldPoll })

	id := identity.FromSeed(make([]byte, 32))
	c, err := gateway.NewClient(id, "http://127.0.0.1:1", nil)
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(c.Close)
	f := &relayFixture{}
	f.m = NewManager(ManagerOptions{SelfID: id.DeviceID, Gateway: c, Official: func() bool { return true },
		DisableEgressProbe: true,
		OnState: func(_ string, s ConnState) {
			f.mu.Lock()
			f.states = append(f.states, s)
			f.mu.Unlock()
		}})
	t.Cleanup(f.m.Close)

	ctx, cancel := context.WithCancel(context.Background())
	f.a = &officialAttempt{id: "attempt", ctx: ctx, cancel: cancel}
	f.p, err = NewPeer(PeerOptions{DeviceID: "peer", SelfID: id.DeviceID, ForceRelay: true,
		OnState: func(s ConnState) { f.m.relayStateChanged("peer", f.a, s) }})
	if err != nil {
		t.Fatal(err)
	}
	if _, err := f.p.newPeerConnection(); err != nil {
		t.Fatal(err)
	}
	f.p.mu.Lock()
	f.p.pcConnected = connected
	f.p.state = StateRelay
	f.p.mu.Unlock()
	f.a.peer = f.p
	f.m.mu.Lock()
	f.m.relays["peer"] = f.a
	f.m.mu.Unlock()
	return f
}

func (f *relayFixture) reported() []ConnState {
	f.mu.Lock()
	defer f.mu.Unlock()
	return append([]ConnState(nil), f.states...)
}

func waitFor(t *testing.T, what string, cond func() bool) {
	t.Helper()
	until := time.Now().Add(3 * time.Second)
	for !cond() {
		if time.Now().After(until) {
			t.Fatal("timed out waiting for " + what)
		}
		time.Sleep(5 * time.Millisecond)
	}
}

// 中转暂时断开（ICE Disconnected）不再立即拆掉：等待期间对上层仍是「中转」，恢复后照常使用。
func TestOfficialRelaySurvivesTransientDisconnect(t *testing.T) {
	f := newRelayFixture(t, true)
	f.p.setState(StateOffline)
	waitFor(t, "recovery wait", f.a.recovering.Load)
	if got := f.m.State("peer"); got != StateRelay {
		t.Fatalf("state while stalled = %v, want relay", got)
	}
	for _, s := range f.reported() {
		if s == StateOffline {
			t.Fatal("a transient disconnect was reported as offline")
		}
	}

	f.p.setState(StateRelay)
	waitFor(t, "recovery", func() bool { return !f.a.recovering.Load() })
	time.Sleep(3 * relayRecoveryPoll)
	if f.a.ctx.Err() != nil {
		t.Fatal("recovered relay was torn down")
	}
	if got := f.m.State("peer"); got != StateRelay {
		t.Fatalf("state after recovery = %v, want relay", got)
	}
}

// 等待期间连接被关闭（ICE Failed）就放弃中转，并补报离线。
func TestOfficialRelayGivesUpWhenConnectionCloses(t *testing.T) {
	f := newRelayFixture(t, true)
	f.p.setState(StateOffline)
	waitFor(t, "recovery wait", f.a.recovering.Load)
	f.p.Close()
	waitFor(t, "relay release", func() bool { return f.a.ctx.Err() != nil })
	waitFor(t, "offline report", func() bool {
		r := f.reported()
		return len(r) > 0 && r[len(r)-1] == StateOffline
	})
	if got := f.m.State("peer"); got != StateOffline {
		t.Fatalf("state after giving up = %v, want offline", got)
	}
	if f.a.failedUntil.IsZero() {
		t.Fatal("failed relay has no retry cooldown")
	}
}

// 一直没恢复，超过等待时限也放弃。
func TestOfficialRelayGivesUpAfterRecoveryWait(t *testing.T) {
	f := newRelayFixture(t, true)
	start := time.Now()
	f.p.setState(StateOffline)
	waitFor(t, "relay release", func() bool { return f.a.ctx.Err() != nil })
	if time.Since(start) < relayRecoveryWait {
		t.Fatal("gave up before the recovery wait")
	}
	if f.a.recovering.Load() {
		t.Fatal("still marked as recovering")
	}
}

// 还没连通过的中转（握手超时被关闭）照旧立即放弃，不等待。
func TestOfficialRelayNeverConnectedFailsAtOnce(t *testing.T) {
	f := newRelayFixture(t, false)
	f.p.setState(StateOffline)
	waitFor(t, "relay release", func() bool { return f.a.ctx.Err() != nil })
	if f.a.recovering.Load() {
		t.Fatal("waited for a relay that never connected")
	}
}
