//go:build linux

package main

import (
	"os"
	"path/filepath"
	"syscall"
)

// 界面程序与后台服务在同一个目录（.deb 装在 /opt/PasteFerry）。
func pickerExecutable() string {
	exe, err := os.Executable()
	if err != nil {
		return ""
	}
	return filepath.Join(filepath.Dir(exe), "pasteferry")
}

// 后台服务退出时快捷窗口随之结束，不会留下一个没人照看、连不上后台服务的窗口。
func pickerAttr() *syscall.SysProcAttr {
	return &syscall.SysProcAttr{Pdeathsig: syscall.SIGTERM}
}

func bindPicker(*os.Process) {}
