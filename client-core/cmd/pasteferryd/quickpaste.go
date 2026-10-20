package main

import (
	"context"
	"log/slog"
	"os"
	"os/exec"
	"sync"
	"time"
)

// quickPasteRunner 在 Windows 与 Linux 上拉起并照看快捷粘贴窗口进程：界面程序加上 --picker 参数。
// 它崩溃了过 10 秒再拉起；后台服务退出时它也跟着结束（Windows 用 Job Object，Linux 用 Pdeathsig）。
// Mac 上快捷窗口是单独的辅助程序，由界面登记的 LaunchAgent 照看，这里什么都不做。
// 见 design/quick-paste-and-favorites.md 第 6.1 节。
type quickPasteRunner struct {
	mu      sync.Mutex
	enabled bool
	wake    chan struct{}
}

// pickerRestartDelay 是快捷窗口退出后过多久再拉起。
const pickerRestartDelay = 10 * time.Second

// newQuickPasteRunner 在 active（不是测试用的独立数据目录）且找得到界面程序时开始照看快捷窗口。
func newQuickPasteRunner(ctx context.Context, active, enabled bool) *quickPasteRunner {
	r := &quickPasteRunner{enabled: enabled, wake: make(chan struct{}, 1)}
	exe := pickerExecutable()
	if !active || exe == "" {
		return r
	}
	if _, err := os.Stat(exe); err != nil {
		slog.Debug("没有界面程序（开发构建），不拉起快捷粘贴窗口", "path", exe)
		return r
	}
	go r.run(ctx, exe)
	return r
}

// SetEnabled 在设置里开关快捷粘贴时调用。关掉时快捷窗口收到 config_changed 会自己退出，
// 几秒内没退出就结束它。
func (r *quickPasteRunner) SetEnabled(on bool) {
	r.mu.Lock()
	changed := r.enabled != on
	r.enabled = on
	r.mu.Unlock()
	if changed {
		select {
		case r.wake <- struct{}{}:
		default:
		}
	}
}

func (r *quickPasteRunner) isEnabled() bool {
	r.mu.Lock()
	defer r.mu.Unlock()
	return r.enabled
}

func (r *quickPasteRunner) run(ctx context.Context, exe string) {
	for {
		if !r.isEnabled() {
			select {
			case <-ctx.Done():
				return
			case <-r.wake:
				continue
			}
		}
		cmd := exec.Command(exe, "--picker")
		cmd.SysProcAttr = pickerAttr()
		if err := cmd.Start(); err != nil {
			slog.Warn("拉起快捷粘贴窗口失败", "err", err)
			if !r.sleep(ctx, pickerRestartDelay) {
				return
			}
			continue
		}
		bindPicker(cmd.Process)
		slog.Info("快捷粘贴窗口已启动", "pid", cmd.Process.Pid)
		exited := make(chan error, 1)
		go func() { exited <- cmd.Wait() }()

		stopped := false
		for !stopped {
			select {
			case <-ctx.Done():
				_ = cmd.Process.Kill()
				<-exited
				return
			case err := <-exited:
				slog.Info("快捷粘贴窗口已退出", "err", err)
				stopped = true
			case <-r.wake:
				if r.isEnabled() {
					continue
				}
				select {
				case <-exited:
				case <-time.After(3 * time.Second):
					_ = cmd.Process.Kill()
					<-exited
				}
				stopped = true
			}
		}
		if r.isEnabled() && !r.sleep(ctx, pickerRestartDelay) {
			return
		}
	}
}

// sleep 等 d，期间开关变了就提前醒来。返回 false 表示后台服务要退出了。
func (r *quickPasteRunner) sleep(ctx context.Context, d time.Duration) bool {
	t := time.NewTimer(d)
	defer t.Stop()
	select {
	case <-ctx.Done():
		return false
	case <-t.C:
	case <-r.wake:
	}
	return true
}
