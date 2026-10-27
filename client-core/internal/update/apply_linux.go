package update

import (
	"errors"
	"fmt"
	"log/slog"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func prepare(p *Plan, work string) error {
	if p.Kind == KindLinuxTar {
		return stageFolder(p, untar, "pasteferry", "pasteferryd")
	}
	return nil
}

func apply(p *Plan, log *slog.Logger) error {
	switch p.Kind {
	case KindLinuxDeb:
		// /opt 要管理员权限：pkexec 会弹出系统的密码框
		out, err := exec.Command("pkexec", "dpkg", "-i", p.Package).CombinedOutput()
		// 126：用户关掉了密码框。127：没拿到授权，常见的是系统根本没弹密码框——
		// 后台服务不在桌面会话里（比如从 SSH 启动），找不到桌面的认证代理
		var exit *exec.ExitError
		if errors.As(err, &exit) && exit.ExitCode() == 126 {
			return errors.New("没有获得管理员授权，已取消安装")
		}
		if errors.As(err, &exit) && exit.ExitCode() == 127 {
			log.Warn("pkexec 没有获得授权", "out", strings.TrimSpace(string(out)))
			return errors.New("系统没有弹出密码框：后台服务不是在桌面里启动的（比如从 SSH 启动）。请退出 PasteFerry，从应用菜单重新打开，在「设置 › 后台服务」里重新启动后再试，或者下载 .deb 手动安装")
		}
		if err != nil {
			return fmt.Errorf("安装 .deb 失败: %v %s", err, strings.TrimSpace(string(out)))
		}
		stopDaemons(p, log)
		return nil
	case KindLinuxTar:
		stopDaemons(p, log)
		return swapDir(p.App, p.Staged, oldFolder(p))
	}
	return fmt.Errorf("不支持的安装方式 %s", p.Kind)
}

// relaunch 按开机自启的方式重新拉起后台服务（原先在运行、现在没在运行时），再打开界面。
func relaunch(p *Plan, log *slog.Logger) error {
	if len(p.Daemons) > 0 && !anyAlive(p.Daemons) {
		if err := startDetached(filepath.Join(p.App, "pasteferryd"), "-supervise"); err != nil {
			log.Warn("启动后台服务失败", "err", err)
		}
	}
	if p.Kind == KindLinuxTar {
		defer os.RemoveAll(oldFolder(p))
		if p.Staged != "" {
			defer os.RemoveAll(stagingRoot(p))
		}
	}
	return startDetached(filepath.Join(p.App, "pasteferry"))
}

func anyAlive(pids []int) bool {
	for _, pid := range pids {
		if pid > 0 && alive(pid) {
			return true
		}
	}
	return false
}
