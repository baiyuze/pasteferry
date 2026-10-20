package store

import (
	"database/sql"
	"path/filepath"
	"testing"
	"time"
)

func TestIsLink(t *testing.T) {
	for text, want := range map[string]bool{
		"https://github.com/baiyuze/pasteferry":    true,
		"  http://example.com/a?b=1#c \n":          true, // 首尾空白不算
		"HTTPS://EXAMPLE.COM":                      true,
		"https://例子.中国/路径":                        true,
		"看这个 https://example.com":                  false, // 一段话里夹着网址
		"https://example.com\nhttps://example.org": false, // 两个网址
		"https://example.com/a b":                  false,
		"ftp://example.com":                        false,
		"example.com":                              false,
		"https://":                                 false,
		"mailto:a@example.com":                     false,
		"":                                         false,
	} {
		if got := IsLink(text); got != want {
			t.Errorf("IsLink(%q) = %v, want %v", text, got, want)
		}
	}
}

func textClip(id, text string, kind Kind, at time.Time) Clip {
	return Clip{ID: id, Kind: kind, Status: StatusReady, TextContent: text, TextPreview: text,
		CreatedAt: at, ExpiresAt: at.Add(time.Hour)}
}

// 筛选：「文字」含网页格式、不含链接；收藏与复制记录各查各的。
func TestListRecordsFilter(t *testing.T) {
	s := openTest(t)
	now := time.Now()
	clips := []Clip{
		textClip("text", "会议改到周四", KindText, now.Add(1*time.Second)),
		textClip("html", "<b>粗体</b>", KindHTML, now.Add(2*time.Second)),
		textClip("link", "https://pasteferry.cc/download/", KindText, now.Add(3*time.Second)),
		sampleClip("file", now.Add(4*time.Second)),
	}
	fav := textClip("fav", "收藏的文字", KindText, now)
	fav.Favorite, fav.FavoritedAt, fav.SourceClipID, fav.ExpiresAt = true, now, "text", FavoriteExpiry
	for _, c := range append(clips, fav) {
		if err := s.PutClip(c); err != nil {
			t.Fatal(err)
		}
	}
	ids := func(f Filter) []string {
		got, err := s.ListRecords(10, time.Time{}, f)
		if err != nil {
			t.Fatal(err)
		}
		var out []string
		for _, c := range got {
			out = append(out, c.ID)
		}
		return out
	}
	for _, tc := range []struct {
		f    Filter
		want []string
	}{
		{Filter{}, []string{"file", "link", "html", "text"}},
		{Filter{Text: true}, []string{"html", "text"}},
		{Filter{LinksOnly: true}, []string{"link"}},
		{Filter{Kind: KindFile}, []string{"file"}},
		{Filter{Favorites: true}, []string{"fav"}},
		{Filter{Favorites: true, LinksOnly: true}, nil},
	} {
		if got := ids(tc.f); !equal(got, tc.want) {
			t.Errorf("%+v: %v, want %v", tc.f, got, tc.want)
		}
	}

	text, err := s.GetClip("text")
	if err != nil {
		t.Fatal(err)
	}
	if !text.Favorited {
		t.Error("收藏过的复制记录 Favorited 应为 true")
	}
	link, _ := s.GetClip("link")
	if !link.IsLink || link.Favorited {
		t.Errorf("link: IsLink=%v Favorited=%v", link.IsLink, link.Favorited)
	}

	got, err := s.SearchRecords("收藏", 10, Filter{Favorites: true})
	if err != nil {
		t.Fatal(err)
	}
	if len(got) != 1 || got[0].ID != "fav" {
		t.Errorf("在收藏里搜：%v", got)
	}
	got, err = s.SearchRecords("收藏", 10, Filter{})
	if err != nil {
		t.Fatal(err)
	}
	if len(got) != 0 {
		t.Errorf("在复制记录里搜不该搜到收藏：%v", got)
	}

	// 清空、过期与对账都只管复制记录
	if err := s.DeleteAllClips(); err != nil {
		t.Fatal(err)
	}
	if got := ids(Filter{Favorites: true}); !equal(got, []string{"fav"}) {
		t.Errorf("清空复制记录后收藏：%v", got)
	}
}

func equal(a, b []string) bool {
	if len(a) != len(b) {
		return false
	}
	for i := range a {
		if a[i] != b[i] {
			return false
		}
	}
	return true
}

// 收藏的副本在收藏目录里，缓存目录的对账不能把同名的东西当成还在用。
func TestFavoritePathsSeparateFromCache(t *testing.T) {
	s := openTest(t)
	now := time.Now()
	c := sampleClip("history", now)
	f := sampleClip("fav", now)
	f.Favorite, f.FavoritedAt, f.ExpiresAt = true, now, FavoriteExpiry
	for _, x := range []Clip{c, f} {
		if err := s.PutClip(x); err != nil {
			t.Fatal(err)
		}
	}
	cache, err := s.CachePaths()
	if err != nil {
		t.Fatal(err)
	}
	favs, err := s.FavoritePaths()
	if err != nil {
		t.Fatal(err)
	}
	if _, ok := cache["fav.bin"]; ok || len(cache) != 1 {
		t.Errorf("缓存引用：%v", cache)
	}
	if _, ok := favs["fav.bin"]; !ok || len(favs) != 1 {
		t.Errorf("收藏引用：%v", favs)
	}
	if used, _ := s.CacheReferenced("fav.bin"); used {
		t.Error("收藏的路径不算缓存引用")
	}
	if used, _ := s.FavoriteReferenced("fav.bin"); !used {
		t.Error("收藏的路径要算收藏引用")
	}
}

// 加 is_link 列之前存下的文字记录，升级后第一次打开时补算。
func TestBackfillLinksOnUpgrade(t *testing.T) {
	path := filepath.Join(t.TempDir(), "old.db")
	db, err := sql.Open("sqlite", path)
	if err != nil {
		t.Fatal(err)
	}
	// 2.3.0 的表结构
	if _, err := db.Exec(`
CREATE TABLE clips (
    id TEXT PRIMARY KEY, kind INTEGER NOT NULL, status INTEGER NOT NULL,
    origin_device_id TEXT NOT NULL DEFAULT '', origin_device_name TEXT NOT NULL DEFAULT '',
    outgoing INTEGER NOT NULL DEFAULT 0, total_size INTEGER NOT NULL DEFAULT 0,
    text_preview TEXT NOT NULL DEFAULT '', text_content TEXT NOT NULL DEFAULT '',
    text_plain TEXT NOT NULL DEFAULT '', cache_path TEXT NOT NULL DEFAULT '',
    source_paths TEXT NOT NULL DEFAULT '[]', error TEXT NOT NULL DEFAULT '',
    created_at INTEGER NOT NULL, expires_at INTEGER NOT NULL);
INSERT INTO clips (id, kind, status, text_content, created_at, expires_at) VALUES
    ('link', 1, 1, 'https://example.com', 1, 9999999999),
    ('text', 1, 1, '不是网址', 1, 9999999999);`); err != nil {
		t.Fatal(err)
	}
	db.Close()

	s, err := Open(path)
	if err != nil {
		t.Fatal(err)
	}
	defer s.Close()
	links, err := s.ListRecords(10, time.Time{}, Filter{LinksOnly: true})
	if err != nil {
		t.Fatal(err)
	}
	if len(links) != 1 || links[0].ID != "link" {
		t.Fatalf("补算后的链接：%v", links)
	}
}
