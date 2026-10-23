package sync

import (
	"context"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

func TestDefaultPolicySkipsOfflineCopies(t *testing.T) {
	peers := &fakePeers{up: map[string]bool{"office": true}, offers: map[string][]*pb.ClipOffer{}}
	e := newBacklogEngine(t, peers)
	cfg := config.Default()
	e.loadConfig = func() config.Config { return cfg }
	ctx := context.Background()
	clip := putText(t, e, "missed", "offline", time.Now())
	e.offerToPeers(ctx, clip, cfg)
	peers.up["home"] = true
	e.PeerReady(ctx, "home")
	if len(peers.received("home")) != 0 {
		t.Fatal("default policy replayed offline copies")
	}
	clip = putText(t, e, "new", "online", time.Now())
	e.offerToPeers(ctx, clip, cfg)
	if got := peers.received("home"); len(got) != 1 || got[0].GetClipId() != "new" {
		t.Fatalf("new copy not delivered: %v", got)
	}
}

func TestPauseDropsQueueAndResumesWithNewCopies(t *testing.T) {
	for _, mode := range []string{"global", "peer", "backlog"} {
		t.Run(mode, func(t *testing.T) {
			peers := &fakePeers{up: map[string]bool{"office": true}, offers: map[string][]*pb.ClipOffer{}}
			e := newBacklogEngine(t, peers)
			cfg := config.Default()
			cfg.SyncBacklog = true
			e.loadConfig = func() config.Config { return cfg }
			ctx := context.Background()
			e.offerToPeers(ctx, putText(t, e, "before", "before", time.Now()), cfg)
			switch mode {
			case "global":
				cfg.RealtimeSyncDisabled = true
			case "peer":
				cfg.SyncDisabledPeers = []string{"home"}
			case "backlog":
				cfg.SyncBacklog = false
			}
			e.ApplySyncPolicy()
			e.offerToPeers(ctx, putText(t, e, "paused", "paused", time.Now()), cfg)
			cfg.RealtimeSyncDisabled = false
			cfg.SyncDisabledPeers = nil
			cfg.SyncBacklog = true
			peers.up["home"] = true
			e.PeerReady(ctx, "home")
			if len(peers.received("home")) != 0 {
				t.Fatal("resuming replayed old or paused copies")
			}
			e.offerToPeers(ctx, putText(t, e, "after", "after", time.Now()), cfg)
			got := peers.received("home")
			if len(got) != 1 || got[0].GetClipId() != "after" {
				t.Fatalf("unexpected delivery: %v", got)
			}
		})
	}
}

func TestIncomingPolicyRejectsPausedPeersAndDefaultBacklog(t *testing.T) {
	for _, mode := range []string{"global", "peer", "backlog"} {
		t.Run(mode, func(t *testing.T) {
			cfg := config.Default()
			switch mode {
			case "global":
				cfg.RealtimeSyncDisabled = true
			case "peer":
				cfg.SyncDisabledPeers = []string{"peer"}
			}
			e, events := receiveFixture(t, &receiveClipboard{}, cfg, 0)
			offerLarge(e, "ignored", mode == "backlog")
			if _, err := e.store.GetClip("ignored"); err == nil {
				t.Fatal("blocked offer appeared in history")
			}
			select {
			case event := <-events:
				t.Fatalf("blocked offer emitted event: %v", event)
			default:
			}
		})
	}
}

func TestPauseCancelsAutomaticReceivesButKeepsManualRequests(t *testing.T) {
	cfg := config.Default()
	e, _ := receiveFixture(t, &receiveClipboard{}, cfg, 0)
	e.loadConfig = func() config.Config { return cfg }
	offerLarge(e, "auto", false)
	offerLarge(e, "manual", false)
	for _, id := range []string{"auto", "manual"} {
		clip, err := e.store.GetClip(id)
		if err != nil {
			t.Fatal(err)
		}
		e.startAutomaticReceive(clip, false)
	}
	e.mu.Lock()
	e.receives["manual"].manual = true
	e.mu.Unlock()
	cfg.RealtimeSyncDisabled = true
	e.ApplySyncPolicy()
	e.mu.Lock()
	defer e.mu.Unlock()
	if e.receives["auto"] != nil {
		t.Fatal("automatic receive survived a pause")
	}
	if e.receives["manual"] == nil {
		t.Fatal("manual download was cancelled")
	}
}
