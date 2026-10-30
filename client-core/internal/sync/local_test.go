package sync

import (
	"context"
	"errors"
	"os"
	"path/filepath"
	"runtime"
	"testing"
	"time"

	"github.com/pion/webrtc/v4"

	"github.com/baiyuze/pasteferry/client-core/internal/cache"
	"github.com/baiyuze/pasteferry/client-core/internal/clipboard"
	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// localFixture 是带剪贴板、两台已配对设备（office 在线、home 不在线）的引擎。
func localFixture(t *testing.T, cfg config.Config) (*Engine, *receiveClipboard, *fakePeers) {
	t.Helper()
	db, err := store.Open(filepath.Join(t.TempDir(), "test.db"))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { db.Close() })
	blobs, err := cache.New(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	loop := clipboard.NewMainLoop()
	ctx, cancel := context.WithCancel(context.Background())
	done := make(chan struct{})
	go func() { runtime.LockOSThread(); defer runtime.UnlockOSThread(); defer close(done); loop.Run(ctx) }()
	t.Cleanup(func() { cancel(); <-done })
	cb := &receiveClipboard{}
	peers := &fakePeers{up: map[string]bool{"office": true}, offers: map[string][]*pb.ClipOffer{}}
	e := New(Options{Store: db, Cache: blobs, Watcher: clipboard.NewWatcher(clipboard.WatcherOptions{Clipboard: cb, MainLoop: loop}),
		DeviceID: "self", DeviceName: func() string { return "MacBook" },
		LoadConfig: func() config.Config { return cfg }, Send: peers.send,
		OpenStream: func(string, string) (*webrtc.DataChannel, error) { return nil, errors.New("测试里不开数据通道") },
		PairedPeers: func() []string { return []string{"office", "home"} },
	})
	t.Cleanup(e.Close)
	return e, cb, peers
}

func TestSubmitLocalTextRecordsOffersAndWritesClipboard(t *testing.T) {
	cfg := config.Default()
	cfg.SyncBacklog = true
	e, cb, peers := localFixture(t, cfg)

	clip, err := e.SubmitLocal(context.Background(), clipboard.Content{Kind: clipboard.KindText, Text: "来自手机的一段话"}, "iPhone", true)
	if err != nil {
		t.Fatal(err)
	}
	got, err := e.store.GetClip(clip.ID)
	if err != nil {
		t.Fatal(err)
	}
	if !got.Outgoing || got.Via != "iPhone" || got.OriginDeviceID != "self" || got.OriginDeviceName != "MacBook" {
		t.Errorf("记录 = outgoing %v via %q origin %q/%q，应为本机发出、经由 iPhone", got.Outgoing, got.Via, got.OriginDeviceID, got.OriginDeviceName)
	}
	if got.TextContent != "来自手机的一段话" || got.Status != store.StatusReady {
		t.Errorf("内容 = %q，状态 %v", got.TextContent, got.Status)
	}
	if r := recordProto(got); r.GetViaName() != "iPhone" {
		t.Errorf("推给界面的记录 via_name = %q", r.GetViaName())
	}
	offers := peers.received("office")
	if len(offers) != 1 || offers[0].GetClipId() != clip.ID || offers[0].GetTextContent() != "来自手机的一段话" {
		t.Fatalf("在线设备收到的 offer = %v", offers)
	}
	if missed := e.backlog.take("home"); len(missed) != 1 || missed[0] != clip.ID {
		t.Errorf("不在线的设备没进补发队列：%v", missed)
	}
	if cb.writes != 1 {
		t.Errorf("写了 %d 次剪贴板，应为 1", cb.writes)
	}
}

func TestSubmitLocalRespectsClipboardChoices(t *testing.T) {
	for _, c := range []struct {
		name       string
		applyLocal bool
		autoApply  bool
		writes     int
	}{
		{"Android 发送页：不写本机", false, true, 0},
		{"电脑上关了自动写入", true, false, 0},
		{"网页传输：写本机", true, true, 1},
	} {
		t.Run(c.name, func(t *testing.T) {
			cfg := config.Default()
			cfg.AutoApplyToClipboard = c.autoApply
			e, cb, _ := localFixture(t, cfg)
			if _, err := e.SubmitLocal(context.Background(), clipboard.Content{Kind: clipboard.KindText, Text: "hi"}, "", c.applyLocal); err != nil {
				t.Fatal(err)
			}
			if cb.writes != c.writes {
				t.Errorf("写了 %d 次剪贴板，应为 %d", cb.writes, c.writes)
			}
		})
	}
}

func TestSubmitLocalKeepsRecordWhenKindNotSynced(t *testing.T) {
	cfg := config.Default()
	cfg.SyncText = false
	e, _, peers := localFixture(t, cfg)
	clip, err := e.SubmitLocal(context.Background(), clipboard.Content{Kind: clipboard.KindText, Text: "只留在本机"}, "iPhone", false)
	if err != nil {
		t.Fatal(err)
	}
	if _, err := e.store.GetClip(clip.ID); err != nil {
		t.Errorf("记录没落库：%v", err)
	}
	if offers := peers.received("office"); len(offers) != 0 {
		t.Errorf("关掉文字同步后仍发出了 %d 条 offer", len(offers))
	}
}

func TestSubmitLocalFilesAndLocalPaths(t *testing.T) {
	e, _, peers := localFixture(t, config.Default())
	dir := t.TempDir()
	photo := filepath.Join(dir, "IMG_0001.jpg")
	if err := os.WriteFile(photo, []byte("jpeg"), 0o600); err != nil {
		t.Fatal(err)
	}
	clip, err := e.SubmitLocal(context.Background(), clipboard.Content{Kind: clipboard.KindFile, Files: []string{photo}}, "Android 手机", false)
	if err != nil {
		t.Fatal(err)
	}
	if clip.Kind != store.KindFile || len(clip.Items) != 1 || clip.Items[0].Name != "IMG_0001.jpg" {
		t.Fatalf("文件记录 = kind %v items %v", clip.Kind, clip.Items)
	}
	if offers := peers.received("office"); len(offers) != 1 || !offers[0].GetWillPush() {
		t.Errorf("小文件应随即推送：%v", offers)
	}
	paths, err := e.LocalPaths(clip.ID)
	if err != nil || len(paths) != 1 || paths[0] != photo {
		t.Errorf("LocalPaths = %v, %v", paths, err)
	}
}

func TestSubmitLocalRejectsEmptyContent(t *testing.T) {
	e, _, _ := localFixture(t, config.Default())
	for _, c := range []clipboard.Content{
		{Kind: clipboard.KindText},
		{Kind: clipboard.KindFile},
		{Kind: clipboard.KindUnknown, Text: "x"},
	} {
		if _, err := e.SubmitLocal(context.Background(), c, "", false); !errors.Is(err, ErrNothingToSubmit) {
			t.Errorf("%v: err = %v，应为 ErrNothingToSubmit", c.Kind, err)
		}
	}
}

// 复制的文件都读不到时不进记录，但要给界面一条提示：不然用户只会觉得「没反应」。
func TestUnreadableClipboardFilesNotice(t *testing.T) {
	cfg := config.Default()
	e, cb, _ := localFixture(t, cfg)
	notices := make(chan string, 4)
	e.onNotice = func(kind string) { notices <- kind }

	cb.mu.Lock()
	cb.content = clipboard.Content{
		Kind:  clipboard.KindFile,
		Files: []string{filepath.Join(t.TempDir(), "已删除.zip预览文件.txt")},
	}
	cb.revision++
	cb.mu.Unlock()

	e.HandleClipboardChange(context.Background(), clipboard.Snapshot{Kind: clipboard.KindFile, ChangeCount: cb.revision})

	select {
	case kind := <-notices:
		if kind != NoticeClipboardFilesUnreadable {
			t.Fatalf("提示 = %q", kind)
		}
	case <-time.After(5 * time.Second):
		t.Fatal("文件读不到时没有给界面提示")
	}
	if list, err := e.SearchHistory("", 10, store.Filter{}); err == nil && len(list) > 0 {
		t.Fatalf("读不到的文件不应进记录：%d 条", len(list))
	}
}
