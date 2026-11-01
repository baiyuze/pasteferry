package p2p

import (
	"context"
	"errors"
	"sync/atomic"
	"testing"
	"time"

	"github.com/pion/transport/v5"
	"github.com/pion/transport/v5/stdnet"

	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

var errNetworkStarting = errors.New("network interfaces are not ready")

type startingNet struct {
	transport.Net
	ready atomic.Bool
}

func (n *startingNet) Interfaces() ([]*transport.Interface, error) {
	if !n.ready.Load() {
		return nil, errNetworkStarting
	}
	return n.Net.Interfaces()
}

// An interface enumeration failure during CreateOffer must not leave an
// offline PeerConnection that makes every later Connect silently do nothing.
func TestConnectRecoversFromStartupNetworkError(t *testing.T) {
	network, err := stdnet.NewNet()
	if err != nil {
		t.Fatal(err)
	}
	n := &startingNet{Net: network}
	bus := &signalBus{targets: map[string]*Manager{}}
	alice := newTestNode(t, bus, "alice")
	bob := newTestNode(t, bus, "bob")
	p, err := NewPeer(PeerOptions{
		SelfID: "alice", DeviceID: "bob", Net: n,
		SendSignal: func(ctx context.Context, msg *pb.SignalMessage) error {
			return bus.send("alice")(ctx, "bob", msg)
		},
	})
	if err != nil {
		t.Fatal(err)
	}
	alice.m.mu.Lock()
	alice.m.peers["bob"] = p
	alice.m.mu.Unlock()
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	if err := alice.m.RetryDirect(ctx, "bob"); !errors.Is(err, errNetworkStarting) {
		t.Fatalf("initial Connect = %v, want temporary network error", err)
	}
	n.ready.Store(true)
	if err := alice.m.RetryDirect(ctx, "bob"); err != nil {
		t.Fatalf("Connect after network recovery: %v", err)
	}
	waitState(t, alice, "bob", StateDirect, 10*time.Second)
	waitState(t, bob, "alice", StateDirect, 10*time.Second)
	if err := alice.m.Send("bob", &pb.PeerMessage{
		Payload: &pb.PeerMessage_Fetch{Fetch: &pb.PeerFetch{ClipId: "startup-recovery"}},
	}); err != nil {
		t.Fatal(err)
	}
	expectMessage(t, bob, "startup-recovery")
}
