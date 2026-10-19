package update

import (
	"fmt"
	"log/slog"
	"os"
	"os/exec"
	"path/filepath"
)

func prepare(p *Plan, work string) error {
	if p.Kind == KindWindowsPortable {
		return stageFolder(p, unzip, "PasteFerry.exe", "pasteferryd.exe")
	}
	return nil
}

func apply(p *Plan, log *slog.Logger) error {
	switch p.Kind {
	case KindWindowsSetup:
		// 安装程序自己会结束正在运行的界面与后台服务，装完按开机自启的登记把后台服务拉起来
		logPath := filepath.Join(filepath.Dir(p.Package), "install.log")
		cmd := exec.Command(p.Package, "/VERYSILENT", "/SUPPRESSMSGBOXES", "/NORESTART", "/NOCANCEL", "/LOG="+logPath)
		if err := cmd.Run(); err != nil {
			return fmt.Errorf("安装程序没有成功（日志 %s）: %w", logPath, err)
		}
		return nil
	case KindWindowsPortable:
		stopDaemons(p, log)
		if err := swapDir(p.App, p.Staged, oldFolder(p)); err != nil {
			return err
		}
		return nil
	}
	return fmt.Errorf("不支持的安装方式 %s", p.Kind)
}

func relaunch(p *Plan, log *slog.Logger) error {
	if p.Kind == KindWindowsPortable {
		// 便携版的后台服务原先在运行、现在没在运行时，按开机自启的方式拉起来
		if len(p.Daemons) > 0 && !anyAlive(p.Daemons) {
			if err := startDetached(filepath.Join(p.App, "pasteferryd.exe"), "-supervise"); err != nil {
				log.Warn("启动后台服务失败", "err", err)
			}
		}
		defer os.RemoveAll(oldFolder(p))
		if p.Staged != "" {
			defer os.RemoveAll(stagingRoot(p))
		}
	}
	return startDetached(filepath.Join(p.App, "PasteFerry.exe"))
}

func anyAlive(pids []int) bool {
	for _, pid := range pids {
		if pid > 0 && !waitExit(pid, 0) {
			return true
		}
	}
	return false
}
