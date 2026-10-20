package store

import (
	"net/url"
	"strings"
	"unicode"
)

// maxLinkLength 以上的文字不当作链接：浏览器地址栏也放不下这么长的网址，多半是一段数据。
const maxLinkLength = 8192

// IsLink 判断一段文字是不是「链接」：去掉首尾空白后，整段就是一个 http 或 https 网址，
// 中间没有空格，也没有换行。一段话里夹着网址的仍然算文字。
func IsLink(text string) bool {
	s := strings.TrimSpace(text)
	if s == "" || len(s) > maxLinkLength || strings.IndexFunc(s, unicode.IsSpace) >= 0 {
		return false
	}
	u, err := url.Parse(s)
	if err != nil {
		return false
	}
	scheme := strings.ToLower(u.Scheme)
	return (scheme == "http" || scheme == "https") && u.Host != ""
}
