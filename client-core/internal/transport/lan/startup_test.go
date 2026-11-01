package lan

import (
	"errors"
	"sync/atomic"
	"testing"
	"time"
)

type lostAdvertDiscovery struct {
	countingDiscovery
	updates atomic.Int32
}

func (d *lostAdvertDiscovery) Update(text map[string]string) error {
	if d.updates.Add(1) == 1 {
		// Windows replaces DNS-SD records by unregistering first. If the
		// subsequent registration fails, the previous advert is also gone.
		d.Discovery.Stop()
		return errors.New("temporary DNS-SD registration failure")
	}
	return d.Discovery.Update(text)
}

func TestDiscoveryRecoversAfterAdvertUpdateFailure(t *testing.T) {
	network := NewMemoryNetwork()
	d := &lostAdvertDiscovery{countingDiscovery: countingDiscovery{Discovery: network.Discovery()}}
	n := newNodeWith(t, d)
	observer := newNode(t, network)
	n.t.ShowEveryone("new Windows PC", "windows")
	deadline := time.Now().Add(4 * time.Second)
	for {
		if found := observer.t.Strangers(); len(found) == 1 && found[0].Name == "new Windows PC" {
			return
		}
		if time.Now().After(deadline) {
			t.Fatal("device remained undiscoverable after a temporary advert update failure")
		}
		// Advance an existing retry deadline without waiting for its backoff.
		n.t.mu.Lock()
		if !n.t.discoveryRetry.IsZero() {
			n.t.discoveryRetry = time.Now()
		}
		n.t.mu.Unlock()
		time.Sleep(20 * time.Millisecond)
	}
}
