package sync

import (
	"strings"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/store"
)

func TestSearchHistory(t *testing.T) {
	e := newBacklogEngine(t, &fakePeers{})
	now := time.Now().Truncate(time.Second)
	long := strings.Repeat("前面的内容很长，", 30) + "回滚预案见文档第 3 节"
	clips := []store.Clip{
		{ID: "long", Kind: store.KindText, TextContent: long, TextPreview: preview(long)},
		// 旧版本存下的 HTML 没有纯文本：只能从 HTML 里提取，标签名不算
		{ID: "legacy", Kind: store.KindHTML, TextContent: `<div class="Rollout">灰度发布</div>`,
			TextPreview: "灰度发布"},
		{ID: "file", Kind: store.KindFile, Items: []store.Item{{Name: "Contract-Signed.PDF"}},
			TextPreview: "Contract-Signed.PDF"},
	}
	for i, c := range clips {
		c.Status = store.StatusReady
		c.CreatedAt = now.Add(time.Duration(i) * time.Minute)
		c.ExpiresAt = c.CreatedAt.Add(time.Hour)
		if err := e.store.PutClip(c); err != nil {
			t.Fatal(err)
		}
	}

	find := func(query string) []store.Clip {
		got, err := e.SearchHistory(query, 50, store.Filter{})
		if err != nil {
			t.Fatal(err)
		}
		return got
	}

	got := find("回滚预案")
	if len(got) != 1 || got[0].ID != "long" {
		t.Fatalf("长文本后半段的匹配：%v", got)
	}
	// 匹配处在原来的预览之外，预览换成它前后的一段
	if p := got[0].TextPreview; !strings.HasPrefix(p, "…") || !strings.Contains(p, "回滚预案") {
		t.Errorf("预览没有换到匹配处：%q", p)
	}

	if got := find("灰度"); len(got) != 1 || got[0].ID != "legacy" {
		t.Errorf("没存纯文本的 HTML 应按可见文字匹配：%v", got)
	}
	if got := find("rollout"); len(got) != 0 {
		t.Errorf("HTML 的属性值不应算匹配：%v", got)
	}
	if got := find("  contract-signed  "); len(got) != 1 || got[0].ID != "file" {
		t.Errorf("文件名不分大小写、去掉首尾空格：%v", got)
	}
	if got := find(" "); len(got) != 0 {
		t.Errorf("空白的搜索词不应返回记录：%v", got)
	}
}

func TestSearchHistoryByPinyin(t *testing.T) {
	e := newBacklogEngine(t, &fakePeers{})
	now := time.Now().Truncate(time.Second)
	long := strings.Repeat("前面的内容很长，", 30) + "快递单号 7712 3456 0098"
	clips := []store.Clip{
		{ID: "meeting", Kind: store.KindText, TextContent: "会议链接：https://meeting.example.com/j/8823"},
		{ID: "long", Kind: store.KindText, TextContent: long, TextPreview: preview(long)},
		{ID: "file", Kind: store.KindFile, Items: []store.Item{{Name: "合同扫描件.pdf"}}},
		// 原文里就有 hy（why），按原文也能找到
		{ID: "english", Kind: store.KindText, TextContent: "why not"},
		{ID: "fav", Kind: store.KindText, TextContent: "周报模板：本周完成", Favorite: true},
	}
	for i, c := range clips {
		c.Status = store.StatusReady
		c.CreatedAt = now.Add(time.Duration(i) * time.Minute)
		c.ExpiresAt = c.CreatedAt.Add(time.Hour)
		if c.TextPreview == "" {
			c.TextPreview = preview(c.TextContent)
		}
		if c.Favorite {
			c.FavoritedAt = c.CreatedAt
			c.ExpiresAt = store.FavoriteExpiry
		}
		if err := e.store.PutClip(c); err != nil {
			t.Fatal(err)
		}
	}
	ids := func(query string, f store.Filter) []string {
		got, err := e.SearchHistory(query, 50, f)
		if err != nil {
			t.Fatal(err)
		}
		var out []string
		for _, c := range got {
			out = append(out, c.ID)
		}
		return out
	}
	same := func(a, b []string) bool { return strings.Join(a, ",") == strings.Join(b, ",") }

	for _, q := range []string{"huiyi", "hy", "Hui Yi", "hui'yi", "huiylj"} {
		got := ids(q, store.Filter{})
		if q == "hy" {
			// 按原文找到的 why 和按拼音找到的会议，合在一起按时间倒序
			if !same(got, []string{"english", "meeting"}) {
				t.Errorf("%q：%v", q, got)
			}
			continue
		}
		if !same(got, []string{"meeting"}) {
			t.Errorf("%q：%v", q, got)
		}
	}
	if got := ids("hetong", store.Filter{}); !same(got, []string{"file"}) {
		t.Errorf("文件名也按拼音找：%v", got)
	}
	got, err := e.SearchHistory("kuaididanhao", 50, store.Filter{})
	if err != nil || len(got) != 1 || got[0].ID != "long" {
		t.Fatalf("长文本后半段的拼音匹配：%v %v", got, err)
	}
	if p := got[0].TextPreview; !strings.HasPrefix(p, "…") || !strings.Contains(p, "快递单号") {
		t.Errorf("预览没有换到匹配处：%q", p)
	}
	if got := ids("zbmb", store.Filter{Favorites: true}); !same(got, []string{"fav"}) {
		t.Errorf("收藏里也按拼音找：%v", got)
	}
	if got := ids("zbmb", store.Filter{}); len(got) != 0 {
		t.Errorf("复制记录里不该搜到收藏：%v", got)
	}
	// 一个字母不按拼音找，免得什么都匹配
	if got := ids("y", store.Filter{}); len(got) != 1 || got[0] != "english" {
		t.Errorf("一个字母只按原文找：%v", got)
	}
}

func TestIndexFold(t *testing.T) {
	q := []rune("straße")
	if i := indexFold("Die STRAßE ist lang", q); i != 4 {
		t.Errorf("indexFold = %d，应为 4（按 rune 计，不分大小写）", i)
	}
	if i := indexFold("没有", []rune("有没")); i != -1 {
		t.Errorf("找不到时应为 -1，得到 %d", i)
	}
}
