package sync

import (
	"slices"
	"strings"
	"time"
	"unicode"

	"github.com/baiyuze/pasteferry/client-core/internal/pinyin"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
)

// 按拼音搜时最多看最近这么多条记录：数据库没法按拼音粗筛，只能逐条核对
const pinyinScan = 2000

// 每条文字只看开头这么多个字有没有拼音匹配，超长的文字不拖慢搜索
const pinyinText = 5000

// SearchHistory 搜索复制记录：文字内容、文件名或收藏的别名包含 query 的，不分大小写，按时间倒序，最多 limit 条。
//
// 数据库只能粗筛（见 store.SearchClips），这里按用户看得到的文字再核对一遍：
// HTML 记录看纯文本，不看标签。匹配处不在预览片段里的文字记录，预览换成匹配处前后的一段，
// 列表里一眼能看出为什么搜到了它。
//
// 搜索词是两个以上的字母时，再按拼音找一遍中文内容（全拼、首字母或混着打，见 pinyin.Index），
// 比如 huiyi 或 hy 都能找到「会议」。按拼音找到的只在最近 pinyinScan 条里找，和按原文找到的合在一起，
// 仍按时间排序。
//
// f 选定在复制记录还是收藏里搜、只搜哪一类，见 store.Filter。
func (e *Engine) SearchHistory(query string, limit int, f store.Filter) ([]store.Clip, error) {
	q := []rune(strings.Map(unicode.ToLower, strings.TrimSpace(query)))
	if len(q) == 0 {
		return nil, nil
	}
	candidates, err := e.store.SearchRecords(string(q), limit, f)
	if err != nil {
		return nil, err
	}
	out := candidates[:0]
	for _, c := range candidates {
		if c.Favorite && indexFold(c.Alias, q) >= 0 {
			out = append(out, c)
			continue
		}
		if c.Kind != store.KindImage && slices.ContainsFunc(c.Items, func(it store.Item) bool {
			return indexFold(it.Name, q) >= 0
		}) {
			out = append(out, c)
			continue
		}
		if c.Kind != store.KindText && c.Kind != store.KindHTML {
			continue
		}
		text := plainText(c)
		at := indexFold(text, q)
		if at < 0 {
			continue
		}
		if indexFold(c.TextPreview, q) < 0 {
			c.TextPreview = snippet(text, at)
		}
		out = append(out, c)
	}
	py := pinyin.Query(query)
	if py == "" {
		return out, nil
	}
	more, err := e.searchPinyin(py, f, out)
	if err != nil {
		return nil, err
	}
	if len(more) == 0 {
		return out, nil
	}
	out = append(out, more...)
	slices.SortStableFunc(out, func(a, b store.Clip) int {
		if f.Favorites && !a.FavoritedAt.Equal(b.FavoritedAt) {
			return b.FavoritedAt.Compare(a.FavoritedAt)
		}
		return b.CreatedAt.Compare(a.CreatedAt)
	})
	if limit > 0 && len(out) > limit {
		out = out[:limit]
	}
	return out, nil
}

// searchPinyin 在最近 pinyinScan 条记录里，找按原文没搜到、按拼音 py 能匹配的。
func (e *Engine) searchPinyin(py string, f store.Filter, found []store.Clip) ([]store.Clip, error) {
	seen := make(map[string]bool, len(found))
	for _, c := range found {
		seen[c.ID] = true
	}
	var out []store.Clip
	var before time.Time
	for scanned := 0; scanned < pinyinScan; {
		page, err := e.store.ListRecords(500, before, f)
		if err != nil {
			return nil, err
		}
		for _, c := range page {
			if seen[c.ID] {
				continue
			}
			if c.Favorite && pinyin.Index(c.Alias, py) >= 0 {
				out = append(out, c)
				continue
			}
			if c.Kind != store.KindImage && slices.ContainsFunc(c.Items, func(it store.Item) bool {
				return pinyin.Index(it.Name, py) >= 0
			}) {
				out = append(out, c)
				continue
			}
			if c.Kind != store.KindText && c.Kind != store.KindHTML {
				continue
			}
			text := plainText(c)
			if r := []rune(text); len(r) > pinyinText {
				text = string(r[:pinyinText])
			}
			at := pinyin.Index(text, py)
			if at < 0 {
				continue
			}
			if pinyin.Index(c.TextPreview, py) < 0 {
				c.TextPreview = snippet(text, at)
			}
			out = append(out, c)
		}
		scanned += len(page)
		// 收藏不分页，一次就全取到了
		if len(page) < 500 || f.Favorites {
			break
		}
		before = page[len(page)-1].CreatedAt
	}
	return out, nil
}

// indexFold 返回 q（已转小写）在 s 里第一次出现的位置，按 rune 计，不分大小写；找不到返回 -1。
func indexFold(s string, q []rune) int {
	r := []rune(strings.Map(unicode.ToLower, s)) // 逐个 rune 转换，位置与原文一一对应
	for i := 0; i+len(q) <= len(r); i++ {
		if slices.Equal(r[i:i+len(q)], q) {
			return i
		}
	}
	return -1
}

// snippet 从匹配处往前留一小段上下文开始截取预览，前面被截掉的部分用省略号表示。
func snippet(text string, at int) string {
	const lead = 16
	r := []rune(text)
	if at <= lead {
		return preview(text)
	}
	return "…" + preview(string(r[at-lead:]))
}
