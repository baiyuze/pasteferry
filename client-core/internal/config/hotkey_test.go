package config

import "testing"

func TestNormalizeHotkey(t *testing.T) {
	for in, want := range map[string]string{
		"":                 "",
		"alt+v":            "alt+v",
		"Alt+V":            "alt+v",
		" option + v ":     "alt+v",
		"shift+ctrl+v":     "ctrl+shift+v",
		"cmd+shift+space":  "shift+meta+space",
		"win+v":            "meta+v",
		"f9":               "f9",
		"ctrl+f24":         "ctrl+f24",
		"v":                "",  // 没有修饰键
		"alt":              "",  // 没有键
		"alt+alt+v":        "",  // 重复的修饰键
		"hyper+v":          "",  // 不认识的修饰键
		"alt+vv":           "",  // 不认识的键
		"f0":               "",
		"f25":              "",
		"f01":              "",
		"ctrl+alt+comma":   "ctrl+alt+comma",
		"alt+backquote":    "alt+backquote",
		"ctrl+alt+shift+1": "ctrl+alt+shift+1",
	} {
		if got := NormalizeHotkey(in); got != want {
			t.Errorf("NormalizeHotkey(%q) = %q, want %q", in, got, want)
		}
	}
}

func TestValidateDropsBadHotkey(t *testing.T) {
	c := Default()
	c.QuickPasteHotkey = "Option+V"
	c.Validate()
	if c.QuickPasteHotkey != "alt+v" {
		t.Fatalf("hotkey = %q", c.QuickPasteHotkey)
	}
	c.QuickPasteHotkey = "v"
	c.Validate()
	if c.QuickPasteHotkey != "" {
		t.Fatalf("hotkey = %q, want default", c.QuickPasteHotkey)
	}
}
