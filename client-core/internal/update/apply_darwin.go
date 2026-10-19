package update

import (
	"fmt"
	"log/slog"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

// launchdLabel 与界面登记的 LaunchAgent 相同，见 ui/lib/background_service.dart。
const launchdLabel = "com.pasteferry.daemon"

// prepare 挂载 DMG，把新 App 复制到旧 App 旁边（同一个磁盘，替换时只需改名），
// 核对版本号、Bundle ID 与签名。
func prepare(p *Plan, work string) error {
	mnt := filepath.Join(work, "mnt")
	_ = exec.Command("hdiutil", "detach", "-force", mnt).Run()
	if err := os.MkdirAll(mnt, 0o700); err != nil {
		return err
	}
	// 安装包已经按清单校验过 SHA-256，不必再让 hdiutil 校验一遍
	if out, err := exec.Command("hdiutil", "attach", "-nobrowse", "-readonly", "-noautoopen", "-noverify",
		"-mountpoint", mnt, p.Package).CombinedOutput(); err != nil {
		return fmt.Errorf("打开 DMG: %v %s", err, out)
	}
	defer exec.Command("hdiutil", "detach", "-force", mnt).Run()
	apps, _ := filepath.Glob(filepath.Join(mnt, "*.app"))
	if len(apps) != 1 {
		return fmt.Errorf("DMG 里应当正好有一个 App，找到 %d 个", len(apps))
	}
	staged := filepath.Join(filepath.Dir(p.App), ".PasteFerry-"+p.To+".app")
	_ = os.RemoveAll(staged)
	if out, err := exec.Command("ditto", apps[0], staged).CombinedOutput(); err != nil {
		os.RemoveAll(staged)
		return fmt.Errorf("复制新版本: %v %s", err, out)
	}
	_ = exec.Command("xattr", "-dr", "com.apple.quarantine", staged).Run()
	if err := checkBundle(staged, p.App, p.To); err != nil {
		os.RemoveAll(staged)
		return err
	}
	p.Staged = staged
	return nil
}

func checkBundle(staged, current, version string) error {
	got := plistValue(staged, "CFBundleShortVersionString")
	if got != version {
		return fmt.Errorf("新 App 的版本是 %q，不是 %s", got, version)
	}
	if a, b := plistValue(staged, "CFBundleIdentifier"), plistValue(current, "CFBundleIdentifier"); a == "" || a != b {
		return fmt.Errorf("新 App 的 Bundle ID 是 %q，与现在的 %q 不同", a, b)
	}
	if out, err := exec.Command("codesign", "--verify", "--deep", "--strict", staged).CombinedOutput(); err != nil {
		return fmt.Errorf("新 App 的签名无效: %s", strings.TrimSpace(string(out)))
	}
	return nil
}

func plistValue(app, key string) string {
	out, err := exec.Command("/usr/libexec/PlistBuddy", "-c", "Print :"+key, filepath.Join(app, "Contents", "Info.plist")).Output()
	if err != nil {
		return ""
	}
	return strings.TrimSpace(string(out))
}

func oldBundle(p *Plan) string {
	return filepath.Join(filepath.Dir(p.App), ".PasteFerry-"+p.From+".app.old")
}

func apply(p *Plan, log *slog.Logger) error {
	if err := swapDir(p.App, p.Staged, oldBundle(p)); err != nil {
		os.RemoveAll(p.Staged)
		return err
	}
	return nil
}

// relaunch 让 launchd 按新 App 里的程序重启后台服务（只在 LaunchAgent 指向这个 App 时），再打开界面。
func relaunch(p *Plan, log *slog.Logger) error {
	home, _ := os.UserHomeDir()
	plist := filepath.Join(home, "Library", "LaunchAgents", launchdLabel+".plist")
	if raw, err := os.ReadFile(plist); err == nil && strings.Contains(string(raw), p.App+"/") {
		target := fmt.Sprintf("gui/%d/%s", os.Getuid(), launchdLabel)
		if out, err := exec.Command("launchctl", "kickstart", "-k", target).CombinedOutput(); err != nil {
			log.Warn("重启后台服务失败", "err", err, "out", string(out))
		}
	}
	// open 启动的 App 不继承这里的环境变量：把 HOME 明确带过去，界面才会连回同一个数据目录。
	// -n 让系统启动刚换上的这个 App，而不是去激活另一个同 Bundle ID、还开着的副本。
	// 平时旧界面已经退出，两者效果相同；只在系统的 open 不认这些参数时退回普通打开
	err := exec.Command("open", "-n", "--env", "HOME="+home, p.App).Run()
	if err != nil {
		err = exec.Command("open", p.App).Run()
	}
	_ = os.RemoveAll(oldBundle(p))
	return err
}
