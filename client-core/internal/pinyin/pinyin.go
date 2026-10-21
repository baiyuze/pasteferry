// Package pinyin 让中文内容可以按拼音搜：全拼（huiyi）、首字母（hy）或两者混着打（huiy、hyi）
// 都能找到「会议」。多音字的每个读音都算；ü 写作 v，也可以写作 u。读音来自 go-pinyin 的字典。
package pinyin

import (
	"strings"
	"sync"
	"unicode"
	"unicode/utf8"

	gopinyin "github.com/mozillazg/go-pinyin"
)

var (
	mu    sync.RWMutex
	cache = map[rune][]string{}
	args  = func() gopinyin.Args {
		a := gopinyin.NewArgs()
		a.Heteronym = true
		return a
	}()
)

// readings 返回汉字 c 的所有读音（不带声调，小写）；不是汉字或字典里没有时返回 nil。
func readings(c rune) []string {
	mu.RLock()
	r, ok := cache[c]
	mu.RUnlock()
	if ok {
		return r
	}
	for _, p := range gopinyin.SinglePinyin(c, args) {
		r = append(r, p)
		// 「绿」lv 也可以打成 lu：有的输入法和用户习惯这样写
		if strings.Contains(p, "v") {
			r = append(r, strings.ReplaceAll(p, "v", "u"))
		}
	}
	mu.Lock()
	cache[c] = r
	mu.Unlock()
	return r
}

// Index 返回 q 在 s 里第一次匹配的位置（按 rune 计），找不到返回 -1。
//
// q 由小写字母组成。s 里的汉字可以用它任一读音的全拼或声母（首字母，或 zh、ch、sh）匹配；
// q 的最后一段还可以只是某个读音的开头，边打边搜时就能看到结果。其他字符原样匹配，不分大小写；
// s 里的空白可以跳过（拼音里不打空格）。
// s 里没有汉字时直接返回 -1：只按原文匹配的情况由调用方处理。
func Index(s, q string) int {
	if q == "" {
		return 0
	}
	text := []rune(strings.Map(unicode.ToLower, s))
	if !containsHan(text) {
		return -1
	}
	m := len(q)
	// done[i*(m+1)+j]：text[i:] 能否从开头匹配 q[j:]，0 还没算、1 能、2 不能
	done := make([]uint8, (len(text)+1)*(m+1))
	var match func(i, j int) bool
	match = func(i, j int) bool {
		if j == m {
			return true
		}
		if i == len(text) {
			return false
		}
		key := i*(m+1) + j
		if done[key] != 0 {
			return done[key] == 1
		}
		c := text[i]
		ok := c < utf8.RuneSelf && byte(c) == q[j] && match(i+1, j+1)
		// 拼音里不打空格：「发 PDF 给我」用 fapdfgw 也能找到
		if !ok && j > 0 && unicode.IsSpace(c) {
			ok = match(i+1, j)
		}
		if !ok && unicode.Is(unicode.Han, c) {
			for _, r := range readings(c) {
				for _, l := range spans(r, q[j:]) {
					if match(i+1, j+l) {
						ok = true
						break
					}
				}
				if ok {
					break
				}
			}
		}
		done[key] = 2
		if ok {
			done[key] = 1
		}
		return ok
	}
	for i, c := range text {
		if canStart(c, q[0]) && match(i, 0) {
			return i
		}
	}
	return -1
}

// canStart：一次匹配能不能从字符 c 开始，即 c 就是 first，或者是有以 first 开头的读音的汉字。
func canStart(c rune, first byte) bool {
	if c < utf8.RuneSelf {
		return byte(c) == first
	}
	if !unicode.Is(unicode.Han, c) {
		return false
	}
	for _, r := range readings(c) {
		if r[0] == first {
			return true
		}
	}
	return false
}

// spans 返回读音 r 能吃掉 rest 开头的几种长度：完整的读音、声母，或者 rest 剩下的全部（只打了读音的开头）。
func spans(r, rest string) []int {
	var out []int
	add := func(l int) {
		if l > 0 && l <= len(r) && l <= len(rest) && rest[:l] == r[:l] {
			out = append(out, l)
		}
	}
	add(len(r))
	add(1)
	if len(r) > 2 && (r[:2] == "zh" || r[:2] == "ch" || r[:2] == "sh") {
		add(2)
	}
	if len(rest) < len(r) {
		add(len(rest))
	}
	return out
}

func containsHan(text []rune) bool {
	for _, c := range text {
		if unicode.Is(unicode.Han, c) {
			return true
		}
	}
	return false
}

// Query 把用户输入的搜索词整理成拼音搜索用的形式：去掉空格和隔音符号（'），转成小写。
// 只有剩下的全是字母、至少两个时才按拼音搜，否则返回空串：一个字母会匹配到太多字。
func Query(s string) string {
	var b strings.Builder
	for _, c := range strings.ToLower(s) {
		switch {
		case c == ' ' || c == '\'' || c == '’':
		case c >= 'a' && c <= 'z':
			b.WriteRune(c)
		default:
			return ""
		}
	}
	if b.Len() < 2 {
		return ""
	}
	return b.String()
}
