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
		var exit *exec.ExitError
		if errors.As(err, &exit) && (exit.ExitCode() == 126 || exit.ExitCode() == 127) {
			return errors.New("没有获得管理员授权，已取消安装")
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
