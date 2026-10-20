package config

import (
	"strings"
)

// 快捷键的写法：修饰键在前、按 ctrl、alt、shift、meta 的顺序，最后是一个键，用 + 连起来，全小写，
// 如 "alt+v"、"ctrl+shift+v"、"meta+f9"。meta 是 Mac 上的 ⌘、Windows 上的 Win 键、Linux 上的 Super 键。
// 界面（ui/lib/hotkey.dart）与快捷窗口的原生外壳按同样的写法解析。

var hotkeyModifiers = []string{"ctrl", "alt", "shift", "meta"}

// hotkeyAliases 是常见的别名，存的时候统一换成标准写法。
var hotkeyAliases = map[string]string{
	"control": "ctrl", "option": "alt", "opt": "alt",
	"cmd": "meta", "command": "meta", "win": "meta", "super": "meta",
}

// hotkeyNamedKeys 是除了字母、数字、F1–F24 以外能用的键。
var hotkeyNamedKeys = map[string]bool{
	"space": true, "tab": true, "enter": true, "backspace": true, "delete": true,
	"insert": true, "home": true, "end": true, "pageup": true, "pagedown": true,
	"up": true, "down": true, "left": true, "right": true,
	"comma": true, "period": true, "slash": true, "semicolon": true, "quote": true,
	"bracketleft": true, "bracketright": true, "backslash": true,
	"minus": true, "equal": true, "backquote": true,
}

// NormalizeHotkey 把快捷键换成标准写法；写不对的返回空字符串（即默认快捷键）。
// 至少要有一个修饰键，单独的 F1–F24 除外：全局快捷键不该吃掉一个普通字母。
func NormalizeHotkey(s string) string {
	s = strings.ToLower(strings.ReplaceAll(strings.TrimSpace(s), " ", ""))
	if s == "" {
		return ""
	}
	parts := strings.Split(s, "+")
	key := parts[len(parts)-1]
	mods := map[string]bool{}
	for _, p := range parts[:len(parts)-1] {
		if a, ok := hotkeyAliases[p]; ok {
			p = a
		}
		if !contains(hotkeyModifiers, p) || mods[p] {
			return ""
		}
		mods[p] = true
	}
	fkey := isFunctionKey(key)
	if !fkey && !hotkeyNamedKeys[key] && !(len(key) == 1 && (key[0] >= 'a' && key[0] <= 'z' || key[0] >= '0' && key[0] <= '9')) {
		return ""
	}
	if len(mods) == 0 && !fkey {
		return ""
	}
	var out []string
	for _, m := range hotkeyModifiers {
		if mods[m] {
			out = append(out, m)
		}
	}
	return strings.Join(append(out, key), "+")
}

func isFunctionKey(k string) bool {
	if len(k) < 2 || k[0] != 'f' {
		return false
	}
	n := 0
	for _, c := range k[1:] {
		if c < '0' || c > '9' {
			return false
		}
		n = n*10 + int(c-'0')
	}
	return n >= 1 && n <= 24 && k[1] != '0'
}

func contains(list []string, s string) bool {
	for _, v := range list {
		if v == s {
			return true
		}
	}
	return false
}
