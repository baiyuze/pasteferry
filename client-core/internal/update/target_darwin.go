package update

import (
	"debug/macho"
	"path/filepath"
	"runtime"
	"strings"
)

// detectTarget：后台服务在 PasteFerry.app/Contents/Helpers/PasteFerryDaemon.app/Contents/MacOS/ 里。
func detectTarget(exe string) Target {
	i := strings.Index(exe, ".app/Contents/Helpers/")
	if i < 0 {
		return Target{Kind: KindMacApp, Blocker: BlockerDev}
	}
	app := exe[:i+len(".app")]
	t := Target{Kind: KindMacApp, App: app}
	switch {
	case strings.HasPrefix(app, "/Volumes/") || strings.Contains(app, "/AppTranslocation/"):
		t.Blocker = BlockerMustMove
	case !writable(filepath.Dir(app)) || !writable(app):
		t.Blocker = BlockerReadOnly
	}
	// 装的是通用版就继续用通用版；单芯片版按本机芯片
	if f, err := macho.OpenFat(filepath.Join(app, "Contents", "MacOS", "PasteFerry")); err == nil {
		f.Close()
		t.Asset = "mac-universal"
	} else if runtime.GOARCH == "arm64" {
		t.Asset = "mac-arm64"
	} else {
		t.Asset = "mac-x64"
	}
	return t
}
