//go:build windows

package main

import (
	"log/slog"
	"os"
	"path/filepath"
	"sync"
	"syscall"
	"unsafe"

	"golang.org/x/sys/windows"
)

// 界面程序 PasteFerry.exe 与后台服务在同一个文件夹。
func pickerExecutable() string {
	exe, err := os.Executable()
	if err != nil {
		return ""
	}
	return filepath.Join(filepath.Dir(exe), "PasteFerry.exe")
}

func pickerAttr() *syscall.SysProcAttr { return nil }

var (
	pickerJobOnce sync.Once
	pickerJob     windows.Handle
)

// bindPicker 把快捷窗口放进一个 Job Object：后台服务退出（哪怕是被结束进程）时，
// 系统关掉这个 Job，快捷窗口随之结束。
func bindPicker(p *os.Process) {
	pickerJobOnce.Do(func() {
		job, err := windows.CreateJobObject(nil, nil)
		if err != nil {
			slog.Debug("创建 Job Object 失败", "err", err)
			return
		}
		info := windows.JOBOBJECT_EXTENDED_LIMIT_INFORMATION{}
		info.BasicLimitInformation.LimitFlags = windows.JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE
		if _, err := windows.SetInformationJobObject(job, windows.JobObjectExtendedLimitInformation,
			uintptr(unsafe.Pointer(&info)), uint32(unsafe.Sizeof(info))); err != nil {
			slog.Debug("设置 Job Object 失败", "err", err)
			windows.CloseHandle(job)
			return
		}
		pickerJob = job
	})
	if pickerJob == 0 {
		return
	}
	h, err := windows.OpenProcess(windows.PROCESS_SET_QUOTA|windows.PROCESS_TERMINATE, false, uint32(p.Pid))
	if err != nil {
		return
	}
	defer windows.CloseHandle(h)
	if err := windows.AssignProcessToJobObject(pickerJob, h); err != nil {
		slog.Debug("把快捷窗口放进 Job Object 失败", "err", err)
	}
}
