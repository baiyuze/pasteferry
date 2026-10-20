//go:build linux

package sync

import (
	"errors"
	"os"

	"golang.org/x/sys/unix"
)

// Linux 上只有单个文件的写时复制（FICLONE，btrfs、XFS 等支持），文件夹由调用方逐个文件处理。
func cloneTree(string, string) error { return errors.ErrUnsupported }

func cloneFile(src, dst string) error {
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()
	out, err := os.OpenFile(dst, os.O_CREATE|os.O_EXCL|os.O_WRONLY, 0o600)
	if err != nil {
		return err
	}
	if err := unix.IoctlFileClone(int(out.Fd()), int(in.Fd())); err != nil {
		out.Close()
		os.Remove(dst)
		return err
	}
	if info, err := in.Stat(); err == nil {
		_ = out.Chmod(info.Mode().Perm() | 0o600)
	}
	return out.Close()
}
