package gc

import (
	"io"
	"log/slog"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/cache"
	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
)

// 收藏不会过期：GC 只清复制记录，以及两个目录里没人引用的副本。
func TestCollectKeepsFavorites(t *testing.T) {
	dir := t.TempDir()
	db, err := store.Open(filepath.Join(dir, "pasteferry.db"))
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()
	blobs, _ := cache.New(filepath.Join(dir, "cache"))
	favs, _ := cache.New(filepath.Join(dir, "favorites"))

	mkdir := func(c *cache.Cache, id string) string {
		rel, abs, err := c.Dir(id)
		if err != nil {
			t.Fatal(err)
		}
		if err := os.WriteFile(filepath.Join(abs, "a.png"), []byte("png"), 0o600); err != nil {
			t.Fatal(err)
		}
		return rel
	}
	old := time.Now().Add(-30 * 24 * time.Hour)
	expired := store.Clip{ID: "expired", Kind: store.KindImage, Status: store.StatusReady,
		CachePath: mkdir(blobs, "expired"), CreatedAt: old, ExpiresAt: old.Add(time.Hour)}
	fav := store.Clip{ID: "fav", Kind: store.KindImage, Status: store.StatusReady, Favorite: true,
		FavoritedAt: old, CachePath: mkdir(favs, "fav"), CreatedAt: old, ExpiresAt: store.FavoriteExpiry}
	for _, c := range []store.Clip{expired, fav} {
		if err := db.PutClip(c); err != nil {
			t.Fatal(err)
		}
	}
	orphan := mkdir(favs, "orphan")

	cfg := config.Default()
	cfg.CacheTTL = config.Duration(time.Hour) // 比记录保留时间短，也会清缓存
	c := New(Options{
		Logger: slog.New(slog.NewTextHandler(io.Discard, nil)),
		Store:  db, Cache: blobs, Favorites: favs,
		LoadConfig: func() config.Config { return cfg },
	})
	res := c.Collect()

	if _, err := db.GetClip("expired"); err == nil {
		t.Error("过期的复制记录没删")
	}
	got, err := db.GetClip("fav")
	if err != nil || got.Status != store.StatusReady {
		t.Fatalf("收藏被动了：%+v %v", got, err)
	}
	if !favs.Exists(fav.CachePath) {
		t.Error("收藏的副本被删了")
	}
	if favs.Exists(orphan) {
		t.Error("收藏目录里没人引用的副本没清掉")
	}
	if res.RecordsRemoved != 1 {
		t.Errorf("result = %+v", res)
	}
}
