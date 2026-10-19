package update

import (
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"
)

// DebDir 是 .deb 的安装位置。
const DebDir = "/opt/PasteFerry"

// detectTarget：.deb 装在 /opt/PasteFerry 并登记在 dpkg 里；其他位置当作解压出来的 tar.gz。
func detectTarget(exe string) Target {
	dir := filepath.Dir(exe)
	if runtime.GOARCH != "amd64" && runtime.GOARCH != "arm64" {
		return Target{App: dir, Blocker: BlockerUnsupported}
	}
	if dir == DebDir && debInstalled() {
		t := Target{Kind: KindLinuxDeb, Asset: "linux-" + runtime.GOARCH + "-deb", App: dir}
		if _, err := exec.LookPath("pkexec"); err != nil {
			t.Blocker = BlockerReadOnly
		}
		return t
	}
	t := Target{Kind: KindLinuxTar, Asset: "linux-" + runtime.GOARCH + "-tar", App: dir}
	if _, err := os.Stat(filepath.Join(dir, "pasteferry")); err != nil {
		t.Blocker = BlockerDev
	} else if !writable(dir) || !writable(filepath.Dir(dir)) {
		t.Blocker = BlockerReadOnly
	}
	return t
}

func debInstalled() bool {
	out, err := exec.Command("dpkg-query", "-W", "-f=${Status}", "pasteferry").Output()
	return err == nil && strings.Contains(string(out), "install ok installed")
}
