package sync

import (
	"context"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/clipboard"
	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

func TestLegacyRemotePlaceholderOffer(t *testing.T) {
	e := newBacklogEngine(t, &fakePeers{})
	emitted := 0
	e.onRecord = func(*pb.ClipRecord) { emitted++ }
	for i := range 100 {
		id := fmt.Sprintf("legacy-%d", i)
		e.handleOffer(context.Background(), "old-peer", &pb.ClipOffer{
			ClipId: id, Kind: pb.ClipKind(store.KindFile), WillPush: true,
			Items: []*pb.ClipItem{{Name: fmt.Sprintf(".uuremote_aeawv%d", i)}},
		})
		e.handleHeader("old-peer", &pb.TransferHeader{ClipId: id})
	}
	clips, err := e.store.ListClips(500, time.Time{}, store.KindUnspecified)
	if err != nil || len(clips) != 0 || emitted != 0 || len(e.incoming) != 0 {
		t.Fatalf("legacy flood: records=%d, events=%d, receivers=%d, err=%v", len(clips), emitted, len(e.incoming), err)
	}
}

func TestRemotePlaceholderFlood(t *testing.T) {
	e := newBacklogEngine(t, &fakePeers{})
	e.deviceName = func() string { return "test" }
	cfg := config.Default()
	dir := t.TempDir()
	for i := range 100 {
		p := filepath.Join(dir, fmt.Sprintf(".uuremote_aeawv%d", i))
		if err := os.WriteFile(p, nil, 0600); err != nil {
			t.Fatal(err)
		}
		_, err := e.recordOutgoing(clipboard.Content{Kind: clipboard.KindFile, Files: []string{p}}, cfg)
		if !errors.Is(err, errRemotePlaceholder) {
			t.Fatalf("placeholder %d recorded: %v", i, err)
		}
	}
	clips, err := e.store.ListClips(500, time.Time{}, store.KindUnspecified)
	if err != nil || len(clips) != 0 {
		t.Fatalf("flood left %d records: %v", len(clips), err)
	}

	// No broad hidden-file, zero-byte, or >50 MB filter: actual files survive.
	for _, size := range []int64{0, 5 * 1024, 50 << 20, (50 << 20) + 1, 1100 << 20} {
		p := filepath.Join(dir, fmt.Sprintf(".real-%d", size))
		f, err := os.Create(p)
		if err != nil {
			t.Fatal(err)
		}
		err = f.Truncate(size) // sparse: validate metadata without transferring 1 GB
		f.Close()
		if err != nil {
			t.Fatal(err)
		}
		c, err := e.recordOutgoing(clipboard.Content{Kind: clipboard.KindFile,
			Files: []string{filepath.Join(dir, ".uuremote_aeawv999"), p}}, cfg)
		if err != nil {
			t.Fatal(err)
		}
		if len(c.Items) != 1 || len(c.SourcePaths) != 1 || c.SourcePaths[0] != p || c.TotalSize != size {
			t.Fatalf("mixed selection corrupted: %+v", c)
		}
		offer := e.buildOffer(c, cfg)
		if len(offer.Items) != 1 || offer.TotalSize != size || offer.WillPush != (size <= cfg.AutoSyncThresholdBytes) {
			t.Fatalf("wrong offer: %v", offer)
		}
	}
}

// 推给界面的记录要带着「是链接」：本机复制的与对端发来的都一样，不能等界面重新加载
func TestRecordsAreMarkedAsLinkWhenEmitted(t *testing.T) {
	e := newBacklogEngine(t, &fakePeers{})
	e.deviceName = func() string { return "test" }
	var emitted []*pb.ClipRecord
	e.onRecord = func(r *pb.ClipRecord) { emitted = append(emitted, r) }

	c, err := e.recordOutgoing(clipboard.Content{Kind: clipboard.KindText, Text: "https://github.com/baiyuze/pasteferry"}, config.Default())
	if err != nil || !c.IsLink {
		t.Fatalf("outgoing link: IsLink=%v err=%v", c.IsLink, err)
	}

	cfg := config.Default()
	cfg.AutoApplyToClipboard = false
	e.loadConfig = func() config.Config { return cfg }
	e.handleOffer(context.Background(), "office", &pb.ClipOffer{
		ClipId: "remote-link", Kind: pb.ClipKind(store.KindText), TextContent: "https://pasteferry.cc/download/",
		CreatedAtUnix: time.Now().Unix(),
	})
	if len(emitted) != 1 || !emitted[0].GetIsLink() {
		t.Fatalf("received link emitted as %v", emitted)
	}
}
