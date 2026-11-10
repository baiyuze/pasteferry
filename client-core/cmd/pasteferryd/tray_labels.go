package main

import "github.com/baiyuze/pasteferry/client-core/internal/lang"

// trayLanguage 返回界面语言设置（空字符串表示跟随系统）。由 run 在读到配置后设置，
// 托盘每次弹出菜单时读取，用户在界面里改了语言，下次右键就是新语言。
var trayLanguage = func() string { return "" }

// trayWebShare 返回手机网页传输是否在监听：开着时托盘菜单多一项「手机扫码连接」。
// trayNavigate 让界面切到某一页（rpc.Hub.Navigate）。都由 run 在组装好之后设置
var (
	trayWebShare = func() bool { return false }
	trayNavigate = func(string) {}
)

// trayText 是托盘菜单的文字，按界面语言（lang.Supported 的写法）：打开、退出、手机扫码连接。
var trayText = map[string][3]string{
	"en":         {"Open PasteFerry", "Quit PasteFerry", "Connect a phone…"},
	"zh-Hans":    {"打开 PasteFerry", "退出 PasteFerry", "手机扫码连接"},
	"zh-Hant-TW": {"開啟 PasteFerry", "結束 PasteFerry", "手機掃碼連線"},
	"zh-Hant-HK": {"開啟 PasteFerry", "結束 PasteFerry", "手機掃碼連線"},
	"ja":         {"PasteFerry を開く", "PasteFerry を終了", "スマートフォンで読み取る"},
	"ar":         {"فتح PasteFerry", "إنهاء PasteFerry", "توصيل هاتف…"},
	"de":         {"PasteFerry öffnen", "PasteFerry beenden", "Smartphone verbinden…"},
	"es":         {"Abrir PasteFerry", "Salir de PasteFerry", "Conectar un teléfono…"},
	"fr":         {"Ouvrir PasteFerry", "Quitter PasteFerry", "Connecter un téléphone…"},
	"id":         {"Buka PasteFerry", "Keluar dari PasteFerry", "Hubungkan ponsel…"},
	"it":         {"Apri PasteFerry", "Esci da PasteFerry", "Connetti un telefono…"},
	"ko":         {"PasteFerry 열기", "PasteFerry 종료", "휴대폰 연결…"},
	"pl":         {"Otwórz PasteFerry", "Zakończ PasteFerry", "Połącz telefon…"},
	"pt-BR":      {"Abrir PasteFerry", "Sair do PasteFerry", "Conectar um celular…"},
	"ru":         {"Открыть PasteFerry", "Выйти из PasteFerry", "Подключить телефон…"},
	"tr":         {"PasteFerry'yi aç", "PasteFerry'den çık", "Telefon bağla…"},
	"uk":         {"Відкрити PasteFerry", "Вийти з PasteFerry", "Підключити телефон…"},
	"vi":         {"Mở PasteFerry", "Thoát PasteFerry", "Kết nối điện thoại…"},
}

// trayStrings 按语言取托盘菜单的文字。language 为空时按系统界面语言，对不上的用英文。
func trayStrings(language string) [3]string {
	if language == "" {
		language = systemLanguage()
	}
	if t, ok := trayText[lang.Match(language)]; ok {
		return t
	}
	return trayText["en"]
}

// trayLabels 返回托盘菜单的「打开」与「退出」两项。lang 为空时按系统界面语言。
func trayLabels(language string) (open, quit string) {
	t := trayStrings(language)
	return t[0], t[1]
}

// trayWebShareLabel 是托盘菜单里的「手机扫码连接」：打开界面里手机网页传输的二维码窗口。
func trayWebShareLabel(language string) string { return trayStrings(language)[2] }
