//go:build !windows && !linux

package main

import (
	"os"
	"syscall"
)

// Mac 上快捷窗口是 App 包里单独的辅助程序（PasteFerryPicker.app），由界面登记的 LaunchAgent 拉起和照看。
func pickerExecutable() string { return "" }

func pickerAttr() *syscall.SysProcAttr { return nil }

func bindPicker(*os.Process) {}
