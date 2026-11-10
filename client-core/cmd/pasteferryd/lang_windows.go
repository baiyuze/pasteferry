//go:build windows

package main

import "golang.org/x/sys/windows"

var procGetUserDefaultUILanguage = windows.NewLazySystemDLL("kernel32.dll").NewProc("GetUserDefaultUILanguage")

// systemLanguage 按 Windows 的界面语言返回界面支持的语言代码（见 lang.Supported），其他语言返回 "en"。
func systemLanguage() string {
	id, _, _ := procGetUserDefaultUILanguage.Call()
	switch id & 0x3ff { // 低 10 位是主语言，高 6 位是地区
	case 0x04: // LANG_CHINESE
		switch id {
		case 0x0c04, 0x1404: // 香港、澳门
			return "zh-Hant-HK"
		case 0x0404, 0x7c04: // 台湾，以及没写地区的繁体
			return "zh-Hant-TW"
		}
		return "zh-Hans"
	case 0x11: // LANG_JAPANESE
		return "ja"
	case 0x01: // LANG_ARABIC
		return "ar"
	case 0x07: // LANG_GERMAN
		return "de"
	case 0x0a: // LANG_SPANISH
		return "es"
	case 0x0c: // LANG_FRENCH
		return "fr"
	case 0x10: // LANG_ITALIAN
		return "it"
	case 0x12: // LANG_KOREAN
		return "ko"
	case 0x15: // LANG_POLISH
		return "pl"
	case 0x16: // LANG_PORTUGUESE
		return "pt-BR"
	case 0x19: // LANG_RUSSIAN
		return "ru"
	case 0x1f: // LANG_TURKISH
		return "tr"
	case 0x21: // LANG_INDONESIAN
		return "id"
	case 0x22: // LANG_UKRAINIAN
		return "uk"
	case 0x2a: // LANG_VIETNAMESE
		return "vi"
	default:
		return "en"
	}
}
