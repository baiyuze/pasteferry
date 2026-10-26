package update

import (
	"path/filepath"
	"runtime"
	"strings"

	"golang.org/x/sys/unix"
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
	// 按本机芯片下载单芯片版，装的是通用版也换成单芯片版（下载量约为一半）；
	// 在 Apple 芯片上经 Rosetta 运行的 Intel 版换成 Apple 芯片版
	t.Asset = "mac-x64"
	if runtime.GOARCH == "arm64" || translated() {
		t.Asset = "mac-arm64"
	}
	return t
}

// translated 报告本进程是否在 Rosetta 下运行。
func translated() bool {
	v, err := unix.SysctlUint32("sysctl.proc_translated")
	return err == nil && v == 1
}
