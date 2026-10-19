//go:build darwin || linux

package update

import (
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"syscall"
	"time"
)

// alive 把僵尸进程也算作已退出：结束守护进程后，它的子进程可能要等一会儿才被收走。
func alive(pid int) bool {
	if err := syscall.Kill(pid, 0); err != nil && err != syscall.EPERM {
		return false
	}
	if raw, err := os.ReadFile("/proc/" + itoa(pid) + "/stat"); err == nil {
		if i := strings.LastIndexByte(string(raw), ')'); i > 0 && i+2 < len(raw) && raw[i+2] == 'Z' {
			return false
		}
	}
	return true
}

func waitExit(pid int, timeout time.Duration) bool {
	deadline := time.Now().Add(timeout)
	for alive(pid) {
		if time.Now().After(deadline) {
			return false
		}
		time.Sleep(200 * time.Millisecond)
	}
	return true
}

func terminate(pid int) { _ = syscall.Kill(pid, syscall.SIGTERM) }
func kill(pid int)      { _ = syscall.Kill(pid, syscall.SIGKILL) }

// processInDir 判断进程的程序文件是否在 dir 里。替换后旧程序文件已被删掉，
// Linux 的 /proc/<pid>/exe 会带上 " (deleted)"。
func processInDir(pid int, dir string) bool {
	exe, err := os.Readlink("/proc/" + itoa(pid) + "/exe")
	if err != nil {
		out, perr := exec.Command("ps", "-p", itoa(pid), "-o", "comm=").Output()
		if perr != nil {
			return false
		}
		exe = strings.TrimSpace(string(out))
	}
	exe = strings.TrimSuffix(exe, " (deleted)")
	return strings.HasPrefix(exe, filepath.Clean(dir)+string(filepath.Separator))
}

func startDetached(path string, args ...string) error {
	cmd := exec.Command(path, args...)
	// 在程序自己的文件夹里运行，不把调用者的工作目录（可能是要替换的文件夹）带过去
	cmd.Dir = filepath.Dir(path)
	cmd.SysProcAttr = &syscall.SysProcAttr{Setsid: true}
	if err := cmd.Start(); err != nil {
		return err
	}
	return cmd.Process.Release()
}

func itoa(n int) string { return strconv.Itoa(n) }
