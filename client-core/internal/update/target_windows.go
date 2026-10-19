package update

import (
	"os"
	"path/filepath"
	"runtime"
)

// detectTarget：安装程序会在程序文件夹里留下卸载程序 unins000.exe，便携版没有。
func detectTarget(exe string) Target {
	dir := filepath.Dir(exe)
	if runtime.GOARCH != "amd64" {
		return Target{App: dir, Blocker: BlockerUnsupported}
	}
	if _, err := os.Stat(filepath.Join(dir, "unins000.exe")); err == nil {
		return Target{Kind: KindWindowsSetup, Asset: "windows-setup", App: dir}
	}
	t := Target{Kind: KindWindowsPortable, Asset: "windows-portable", App: dir}
	if _, err := os.Stat(filepath.Join(dir, "PasteFerry.exe")); err != nil {
		t.Blocker = BlockerDev
	} else if !writable(dir) || !writable(filepath.Dir(dir)) {
		t.Blocker = BlockerReadOnly
	}
	return t
}
