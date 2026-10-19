package update

import (
	"os/exec"
	"path/filepath"
	"strings"
	"syscall"
	"time"

	"golang.org/x/sys/windows"
)

func waitExit(pid int, timeout time.Duration) bool {
	h, err := windows.OpenProcess(windows.SYNCHRONIZE, false, uint32(pid))
	if err != nil {
		return true // 打不开就是已经退出了
	}
	defer windows.CloseHandle(h)
	ev, err := windows.WaitForSingleObject(h, uint32(timeout/time.Millisecond))
	return err == nil && ev == windows.WAIT_OBJECT_0
}

// Windows 上没有能让后台服务自己收尾的信号，直接结束；数据库每次写入都已落盘。
func terminate(pid int) { kill(pid) }

func kill(pid int) {
	h, err := windows.OpenProcess(windows.PROCESS_TERMINATE, false, uint32(pid))
	if err != nil {
		return
	}
	defer windows.CloseHandle(h)
	_ = windows.TerminateProcess(h, 1)
}

func processInDir(pid int, dir string) bool {
	h, err := windows.OpenProcess(windows.PROCESS_QUERY_LIMITED_INFORMATION, false, uint32(pid))
	if err != nil {
		return false
	}
	defer windows.CloseHandle(h)
	buf := make([]uint16, windows.MAX_LONG_PATH)
	n := uint32(len(buf))
	if err := windows.QueryFullProcessImageName(h, 0, &buf[0], &n); err != nil {
		return false
	}
	exe := windows.UTF16ToString(buf[:n])
	return strings.HasPrefix(strings.ToLower(exe), strings.ToLower(filepath.Clean(dir))+`\`)
}

func startDetached(path string, args ...string) error {
	cmd := exec.Command(path, args...)
	// 在程序自己的文件夹里运行，不把调用者的工作目录（可能是要替换的文件夹）带过去
	cmd.Dir = filepath.Dir(path)
	cmd.SysProcAttr = &syscall.SysProcAttr{
		CreationFlags: windows.DETACHED_PROCESS | windows.CREATE_NEW_PROCESS_GROUP,
		HideWindow:    true,
	}
	if err := cmd.Start(); err != nil {
		return err
	}
	return cmd.Process.Release()
}
