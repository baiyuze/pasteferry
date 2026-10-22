// Package power 在有文件正在传输时阻止系统空闲睡眠，见 design/send-files.md 第 9 节。
// 只挡「放着不动自动睡眠」：合上盖子、用户自己选睡眠，照样会睡。
package power

import (
	"log/slog"
	"os/exec"
)

// Inhibit 开始阻止空闲睡眠，返回解除的函数。做不到时（缺少系统工具）什么也不做。
func Inhibit(reason string) (release func()) {
	release, err := inhibit(reason)
	if err != nil {
		slog.Debug("无法阻止系统睡眠", "err", err)
		return func() {}
	}
	return release
}

// holdProcess 启动一个外部程序，在它运行期间系统不会空闲睡眠；解除时结束它。
func holdProcess(cmd *exec.Cmd) (func(), error) {
	if err := cmd.Start(); err != nil {
		return nil, err
	}
	go cmd.Wait()
	return func() { _ = cmd.Process.Kill() }, nil
}
