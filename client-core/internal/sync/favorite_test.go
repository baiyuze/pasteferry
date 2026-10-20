package sync

import (
	"context"
	"errors"
	"io"
	"log/slog"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/cache"
	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

type favoriteEnv struct {
	e       *Engine
	removed []string
}

func newFavoriteEngine(t *testing.T) *favoriteEnv {
	t.Helper()
	dir := t.TempDir()
	db, err := store.Open(filepath.Join(dir, "pasteferry.db"))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { db.Close() })
	blobs, err := cache.New(filepath.Join(dir, "cache"))
	if err != nil {
		t.Fatal(err)
	}
	favs, err := cache.New(filepath.Join(dir, "favorites"))
	if err != nil {
		t.Fatal(err)
	}
	cfg := config.Default()
	env := &favoriteEnv{}
	env.e = &Engine{
		log:          slog.New(slog.NewTextHandler(io.Discard, nil)),
		store:        db,
		cache:        blobs,
		favorites:    favs,
		loadConfig:   func() config.Config { return cfg },
		send:         func(string, *pb.PeerMessage) error { return errors.New("对端不在线") },
		quiet:        map[string]bool{},
		lastProgress: map[string]time.Time{},
		receives:     map[string]*receiveAttempt{},
		incoming:     map[string]*receiver{},
		onRemoved:    func(id string) { env.removed = append(env.removed, id) },
	}
	return env
}

func (env *favoriteEnv) get(t *testing.T, id string) store.Clip {
	t.Helper()
	c, err := env.e.store.GetClip(id)
	if err != nil {
		t.Fatalf("读取 %s: %v", id, err)
	}
	return c
}

// waitReady 等另存完成：整份复制可能比 saveWait 慢。
func (env *favoriteEnv) waitReady(t *testing.T, id string) store.Clip {
	t.Helper()
	deadline := time.Now().Add(5 * time.Second)
	for {
		c := env.get(t, id)
		if c.Status != store.StatusFetching || time.Now().After(deadline) {
			return c
		}
		time.Sleep(20 * time.Millisecond)
	}
}

// 收藏是另存的一份：原记录被删掉后收藏还在，也不会被当成过期记录清理。
func TestFavoriteTextIsIndependentCopy(t *testing.T) {
	env := newFavoriteEngine(t)
	ctx := context.Background()
	src := putText(t, env.e, "src", "收货地址：上海市徐汇区", time.Now().Add(-time.Hour))

	fav, err := env.e.SetFavorite(ctx, src.ID, true)
	if err != nil {
		t.Fatal(err)
	}
	if !fav.Favorite || fav.ID == src.ID || fav.SourceClipID != src.ID || fav.TextContent != src.TextContent {
		t.Fatalf("收藏不对：%+v", fav)
	}
	if fav.CreatedAt.Unix() != src.CreatedAt.Unix() {
		t.Errorf("收藏要保留原来的复制时间：%v != %v", fav.CreatedAt, src.CreatedAt)
	}
	if !env.get(t, src.ID).Favorited {
		t.Error("原记录的星标没亮")
	}
	if p := recordProto(fav); p.GetExpiresAtUnix() != 0 || !p.GetFavorite() || p.GetFavoritedAtUnix() == 0 {
		t.Errorf("收藏的 ClipRecord 不对：%v", p)
	}

	if err := env.e.store.DeleteAllClips(); err != nil {
		t.Fatal(err)
	}
	expired, err := env.e.store.ExpiredClips(time.Now().AddDate(100, 0, 0))
	if err != nil {
		t.Fatal(err)
	}
	if len(expired) != 0 {
		t.Errorf("收藏不该过期：%v", expired)
	}
	if got := env.get(t, fav.ID); !got.Favorite || got.TextContent != src.TextContent {
		t.Errorf("清空复制记录后收藏不对：%+v", got)
	}
}

// 同样的文字不重复收藏，只把已有的那条挪到最上面；再收藏同一条记录也一样。
func TestFavoriteSameTextNotDuplicated(t *testing.T) {
	env := newFavoriteEngine(t)
	ctx := context.Background()
	now := time.Now()
	a := putText(t, env.e, "a", "pnpm install", now.Add(-2*time.Minute))
	b := putText(t, env.e, "b", "pnpm install", now.Add(-time.Minute))

	first, err := env.e.SetFavorite(ctx, a.ID, true)
	if err != nil {
		t.Fatal(err)
	}
	again, err := env.e.SetFavorite(ctx, a.ID, true)
	if err != nil {
		t.Fatal(err)
	}
	second, err := env.e.SetFavorite(ctx, b.ID, true)
	if err != nil {
		t.Fatal(err)
	}
	if again.ID != first.ID || second.ID != first.ID {
		t.Fatalf("重复收藏了：%s %s %s", first.ID, again.ID, second.ID)
	}
	favs, err := env.e.store.ListRecords(100, time.Time{}, store.Filter{Favorites: true})
	if err != nil {
		t.Fatal(err)
	}
	if len(favs) != 1 || favs[0].SourceClipID != b.ID {
		t.Fatalf("收藏应只有一条、来自最后收藏的那条记录：%+v", favs)
	}
}

// 本机复制的文件收藏时另存一份：之后改动、删除原文件，收藏里的内容都不变。
func TestFavoriteLocalFileIsSnapshot(t *testing.T) {
	env := newFavoriteEngine(t)
	ctx := context.Background()
	userDir := t.TempDir()
	doc := filepath.Join(userDir, "合同.txt")
	folder := filepath.Join(userDir, "资料")
	if err := os.WriteFile(doc, []byte("第一版"), 0o644); err != nil {
		t.Fatal(err)
	}
	if err := os.MkdirAll(filepath.Join(folder, "子目录"), 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(folder, "子目录", "a.md"), []byte("内容"), 0o644); err != nil {
		t.Fatal(err)
	}
	src := store.Clip{
		ID: "files", Kind: store.KindFile, Status: store.StatusReady, Outgoing: true,
		SourcePaths: []string{doc, folder}, TotalSize: 15,
		Items:     []store.Item{{Name: "合同.txt", Size: 9}, {Name: "资料", IsDir: true}},
		CreatedAt: time.Now(), ExpiresAt: time.Now().Add(time.Hour),
	}
	if err := env.e.store.PutClip(src); err != nil {
		t.Fatal(err)
	}

	fav, err := env.e.SetFavorite(ctx, src.ID, true)
	if err != nil {
		t.Fatal(err)
	}
	fav = env.waitReady(t, fav.ID)
	if fav.Status != store.StatusReady || fav.CachePath == "" {
		t.Fatalf("另存没完成：%+v", fav)
	}

	if err := os.WriteFile(doc, []byte("改过的第二版"), 0o644); err != nil {
		t.Fatal(err)
	}
	if err := os.RemoveAll(folder); err != nil {
		t.Fatal(err)
	}
	paths, err := env.e.localPaths(fav)
	if err != nil {
		t.Fatal(err)
	}
	got := map[string]string{}
	for _, p := range paths {
		if !strings.HasPrefix(p, env.e.favorites.Root()) {
			t.Errorf("收藏的内容不在收藏目录里：%s", p)
		}
		got[filepath.Base(p)] = p
	}
	if data, _ := os.ReadFile(got["合同.txt"]); string(data) != "第一版" {
		t.Errorf("原文件改动影响了收藏：%q", data)
	}
	if data, _ := os.ReadFile(filepath.Join(got["资料"], "子目录", "a.md")); string(data) != "内容" {
		t.Errorf("文件夹没另存完整：%q", data)
	}
}

// 取消收藏：放回复制记录的最上面，保留期从现在重新算；原记录还在时合并成一条。
func TestUnfavoriteMovesBackToHistory(t *testing.T) {
	env := newFavoriteEngine(t)
	ctx := context.Background()
	src := putText(t, env.e, "src", "会议改到周四", time.Now().Add(-48*time.Hour))
	fav, err := env.e.SetFavorite(ctx, src.ID, true)
	if err != nil {
		t.Fatal(err)
	}

	before := time.Now().Add(-time.Second)
	back, err := env.e.SetFavorite(ctx, fav.ID, false)
	if err != nil {
		t.Fatal(err)
	}
	if back.ID != fav.ID || back.Favorite || back.CreatedAt.Before(before) {
		t.Fatalf("没有放回复制记录的最上面：%+v", back)
	}
	ttl := env.e.loadConfig().HistoryTTL.Std()
	if back.ExpiresAt.Before(before.Add(ttl)) {
		t.Errorf("保留期没有从现在重新算：%v", back.ExpiresAt)
	}
	if _, err := env.e.store.GetClip(src.ID); !errors.Is(err, store.ErrNotFound) {
		t.Errorf("原记录应该合并掉：%v", err)
	}
	if len(env.removed) != 1 || env.removed[0] != src.ID {
		t.Errorf("要通知界面原记录已删：%v", env.removed)
	}
	history, err := env.e.store.ListClips(10, time.Time{}, store.KindUnspecified)
	if err != nil {
		t.Fatal(err)
	}
	if len(history) != 1 || history[0].ID != fav.ID {
		t.Errorf("复制记录里应只有放回来的那一条：%+v", history)
	}

	// 撤销：再收藏一次
	again, err := env.e.SetFavorite(ctx, back.ID, true)
	if err != nil {
		t.Fatal(err)
	}
	if !again.Favorite || again.TextContent != src.TextContent {
		t.Errorf("撤销后没有重新收藏：%+v", again)
	}
}

// 取消收藏文件时，另存的内容从收藏目录挪进缓存目录，仍然能粘贴。
func TestUnfavoriteFileMovesContentToCache(t *testing.T) {
	env := newFavoriteEngine(t)
	ctx := context.Background()
	doc := filepath.Join(t.TempDir(), "报价.pdf")
	if err := os.WriteFile(doc, []byte("pdf"), 0o644); err != nil {
		t.Fatal(err)
	}
	src := store.Clip{
		ID: "file", Kind: store.KindFile, Status: store.StatusReady, Outgoing: true,
		SourcePaths: []string{doc}, Items: []store.Item{{Name: "报价.pdf", Size: 3}},
		CreatedAt: time.Now(), ExpiresAt: time.Now().Add(time.Hour),
	}
	if err := env.e.store.PutClip(src); err != nil {
		t.Fatal(err)
	}
	fav, err := env.e.SetFavorite(ctx, src.ID, true)
	if err != nil {
		t.Fatal(err)
	}
	fav = env.waitReady(t, fav.ID)
	if err := os.Remove(doc); err != nil {
		t.Fatal(err)
	}

	back, err := env.e.SetFavorite(ctx, fav.ID, false)
	if err != nil {
		t.Fatal(err)
	}
	if env.e.favorites.Exists(fav.CachePath) {
		t.Error("收藏目录里的副本没挪走")
	}
	paths, err := env.e.localPaths(back)
	if err != nil || len(paths) != 1 || !strings.HasPrefix(paths[0], env.e.cache.Root()) {
		t.Fatalf("放回去的记录找不到内容：%v %v", paths, err)
	}
	if data, _ := os.ReadFile(paths[0]); string(data) != "pdf" {
		t.Errorf("内容不对：%q", data)
	}
}

// 内容已经不在本机的图片、文件不能收藏。
func TestCannotFavoriteExpiredFile(t *testing.T) {
	env := newFavoriteEngine(t)
	src := store.Clip{
		ID: "old", Kind: store.KindImage, Status: store.StatusExpired,
		Items: []store.Item{{Name: "image.png"}}, CreatedAt: time.Now(), ExpiresAt: time.Now().Add(time.Hour),
	}
	if err := env.e.store.PutClip(src); err != nil {
		t.Fatal(err)
	}
	if _, err := env.e.SetFavorite(context.Background(), src.ID, true); !errors.Is(err, ErrCannotFavorite) {
		t.Fatalf("err = %v", err)
	}
}

// 只有元数据的大文件：先下载再另存。源设备不在线时收藏标成失败，下载完成后另存好。
func TestFavoriteRemoteOnlyWaitsForDownload(t *testing.T) {
	env := newFavoriteEngine(t)
	ctx := context.Background()
	src := store.Clip{
		ID: "remote", Kind: store.KindFile, Status: store.StatusRemoteOnly, OriginDeviceID: "office",
		Items: []store.Item{{Name: "安装包.dmg", Size: 800 << 20}}, TotalSize: 800 << 20,
		CreatedAt: time.Now(), ExpiresAt: time.Now().Add(time.Hour),
	}
	if err := env.e.store.PutClip(src); err != nil {
		t.Fatal(err)
	}
	fav, err := env.e.SetFavorite(ctx, src.ID, true)
	if err != nil {
		t.Fatal(err)
	}
	if fav.Status != store.StatusFailed || fav.Error == "" {
		t.Fatalf("源设备不在线时收藏应标成失败：%+v", fav)
	}

	// 模拟下载完成：缓存里有了内容，记录就绪
	rel, abs, err := env.e.cache.Dir("remote-dl")
	if err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(abs, "安装包.dmg"), []byte("dmg"), 0o600); err != nil {
		t.Fatal(err)
	}
	if err := env.e.store.SetClipCache(src.ID, rel, 3); err != nil {
		t.Fatal(err)
	}
	if err := env.e.store.SetClipStatus(fav.ID, store.StatusFetching, ""); err != nil {
		t.Fatal(err)
	}
	env.e.completePendingFavorites(env.get(t, src.ID))
	got := env.waitReady(t, fav.ID)
	if got.Status != store.StatusReady {
		t.Fatalf("下载完成后没有另存：%+v", got)
	}
	paths, err := env.e.localPaths(got)
	if err != nil || len(paths) != 1 || !strings.HasPrefix(paths[0], env.e.favorites.Root()) {
		t.Fatalf("另存的位置不对：%v %v", paths, err)
	}
}

func TestClipDetail(t *testing.T) {
	env := newFavoriteEngine(t)
	long := strings.Repeat("行\n", 3000) // 6000 个字，保留换行
	putText(t, env.e, "long", long, time.Now())
	d, err := env.e.ClipDetail("long")
	if err != nil {
		t.Fatal(err)
	}
	if d.GetTextLength() != 6000 || len([]rune(d.GetText())) != 4000 || !strings.HasPrefix(d.GetText(), "行\n行\n") {
		t.Fatalf("length=%d text=%d", d.GetTextLength(), len([]rune(d.GetText())))
	}
}
