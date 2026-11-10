// Package lang 是界面语言的代码表：设置里存的写法（Config.language），以及把系统报的语言代码对到其中一种。
//
// 界面（Flutter）在 ui/lib/i18n.dart 里有同一张表，两边要一起改。
package lang

import "strings"

// Supported 是界面支持的语言，写法与 Config.language 一致。
// 葡萄牙语按巴西的写法，写作 pt-BR；葡萄牙的用户也用它。
var Supported = []string{
	"zh-Hans", "zh-Hant-TW", "zh-Hant-HK", "en", "ja",
	"ar", "de", "es", "fr", "id", "it", "ko", "pl", "pt-BR", "ru", "tr", "uk", "vi",
}

// Valid 报告 code 是不是 Supported 里的一种。空字符串（跟随系统）不算。
func Valid(code string) bool {
	for _, s := range Supported {
		if s == code {
			return true
		}
	}
	return false
}

// Match 把系统或设置里的语言代码对到 Supported 里的一种，对不上时返回空字符串。
// 各系统写法不一：macOS 是 zh-Hant-TW、pt-BR，Windows 是 zh-TW、ar-EG，Linux 是 zh_TW.UTF-8、pt_PT@euro。
//
// 中文写了文字（Hans、Hant）看文字，没写时看地区：香港、澳门用香港的繁体，台湾与其他繁体用台湾的。
func Match(tag string) string {
	t := tag
	if i := strings.IndexAny(t, ".@"); i >= 0 {
		t = t[:i]
	}
	parts := strings.Split(strings.ToLower(strings.ReplaceAll(t, "_", "-")), "-")
	switch parts[0] {
	case "":
		return ""
	case "zh":
		var hans, hant, hk, tw bool
		for _, p := range parts[1:] {
			switch p {
			case "hans":
				hans = true
			case "hant":
				hant = true
			case "hk", "mo":
				hk = true
			case "tw":
				tw = true
			}
		}
		switch {
		case hans:
			return "zh-Hans"
		case hk:
			return "zh-Hant-HK"
		case hant || tw:
			return "zh-Hant-TW"
		}
		return "zh-Hans"
	case "pt":
		return "pt-BR"
	}
	for _, s := range Supported {
		if s == parts[0] {
			return s
		}
	}
	return ""
}
