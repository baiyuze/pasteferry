package main

import "strings"

// trayLanguage 返回界面语言设置（空字符串表示跟随系统）。由 run 在读到配置后设置，
// 托盘每次弹出菜单时读取，用户在界面里改了语言，下次右键就是新语言。
var trayLanguage = func() string { return "" }

// trayWebShare 返回手机网页传输是否在监听：开着时托盘菜单多一项「手机扫码连接」。
// trayNavigate 让界面切到某一页（rpc.Hub.Navigate）。都由 run 在组装好之后设置
var (
	trayWebShare = func() bool { return false }
	trayNavigate = func(string) {}
)

// trayLabels 返回托盘菜单的「打开」与「退出」两项。lang 为空时按系统界面语言。
func trayLabels(lang string) (open, quit string) {
	if lang == "" {
		lang = systemLanguage()
	}
	switch {
	case strings.HasPrefix(lang, "zh-Hant"): // 台湾、香港的 Windows 都这样写
		return "開啟 PasteFerry", "結束 PasteFerry"
	case strings.HasPrefix(lang, "zh"):
		return "打开 PasteFerry", "退出 PasteFerry"
	case strings.HasPrefix(lang, "ja"):
		return "PasteFerry を開く", "PasteFerry を終了"
	default:
		return "Open PasteFerry", "Quit PasteFerry"
	}
}

// trayWebShareLabel 是托盘菜单里的「手机扫码连接」：打开界面里手机网页传输的二维码窗口。
func trayWebShareLabel(lang string) string {
	if lang == "" {
		lang = systemLanguage()
	}
	switch {
	case strings.HasPrefix(lang, "zh-Hant"):
		return "手機掃碼連線"
	case strings.HasPrefix(lang, "zh"):
		return "手机扫码连接"
	case strings.HasPrefix(lang, "ja"):
		return "スマートフォンで読み取る"
	default:
		return "Connect a phone…"
	}
}
