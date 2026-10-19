package update

import (
	"os"
	"path/filepath"
)

// Kind 是本机的安装方式，决定下载哪个安装包、怎么装。
type Kind string

const (
	KindMacApp          Kind = "mac-app"          // /Applications 等处的 PasteFerry.app，用 DMG 里的 App 替换
	KindWindowsSetup    Kind = "windows-setup"    // 安装程序装的，静默运行新的安装程序
	KindWindowsPortable Kind = "windows-portable" // 便携版文件夹，解压新的 zip 替换
	KindLinuxDeb        Kind = "linux-deb"        // /opt/PasteFerry，用 pkexec 安装新的 .deb
	KindLinuxTar        Kind = "linux-tar"        // 解压出来的文件夹，解压新的 tar.gz 替换
)

// 不能自动安装的原因，界面按它给出说明，并改为打开下载页。
const (
	BlockerDev         = "dev"         // 开发构建，不在发布包里运行
	BlockerMustMove    = "must_move"   // Mac 上直接从 DMG 或随机化路径运行
	BlockerReadOnly    = "read_only"   // 安装位置没有写权限
	BlockerUnsupported = "unsupported" // 没有这个系统或芯片的安装包
)

// Target 描述本机怎么更新。
type Target struct {
	Kind Kind
	// Asset 是清单里安装包的键，如 mac-arm64、windows-setup、linux-amd64-deb
	Asset string
	// App 是要替换的位置：Mac 上是 .app，Windows、Linux 上是程序所在的文件夹
	App string
	// Blocker 不为空时不能自动安装
	Blocker string
}

// DetectTarget 按后台服务自身所在的位置判断安装方式。
func DetectTarget() Target {
	exe, err := os.Executable()
	if err != nil {
		return Target{Blocker: BlockerUnsupported}
	}
	if resolved, err := filepath.EvalSymlinks(exe); err == nil {
		exe = resolved
	}
	return detectTarget(exe)
}

// writable 判断能否在 dir 里新建与改名文件：替换安装要在同一个文件夹里改名。
func writable(dir string) bool {
	f, err := os.CreateTemp(dir, ".pasteferry-write-test-*")
	if err != nil {
		return false
	}
	name := f.Name()
	f.Close()
	return os.Remove(name) == nil
}
