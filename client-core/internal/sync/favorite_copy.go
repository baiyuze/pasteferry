package sync

import (
	"io"
	"os"
	"path/filepath"
)

// copyEntry 把 src（文件或文件夹）另存到 dst，dst 不能已经存在。
//
// linkOK 时文件先试硬链接：只用于缓存里的内容，那是隔空贴自己的文件，不会被用户改动。
// 否则先试写时复制（APFS clonefile、btrfs/XFS reflink）：几乎瞬间完成，不占额外空间，
// 之后改原文件也不影响副本。都不行再整份复制。
func copyEntry(src, dst string, linkOK bool) error {
	info, err := os.Lstat(src)
	if err != nil {
		return err
	}
	if !linkOK && cloneTree(src, dst) == nil {
		return nil
	}
	switch {
	case info.Mode()&os.ModeSymlink != 0:
		target, err := os.Readlink(src)
		if err == nil && os.Symlink(target, dst) == nil {
			return nil
		}
		// 建不了符号链接（Windows 上要特殊权限）：存一份它指向的内容
		if info, err = os.Stat(src); err != nil {
			return nil // 指向的东西已经不在了，跳过
		}
		if info.IsDir() {
			return copyDir(src, dst, linkOK)
		}
		return copyRegular(src, dst, info.Mode().Perm(), linkOK)
	case info.IsDir():
		return copyDir(src, dst, linkOK)
	case info.Mode().IsRegular():
		return copyRegular(src, dst, info.Mode().Perm(), linkOK)
	default:
		return nil // 设备文件、管道之类，剪贴板里不会有，跳过
	}
}

func copyDir(src, dst string, linkOK bool) error {
	if err := os.MkdirAll(dst, 0o700); err != nil {
		return err
	}
	entries, err := os.ReadDir(src)
	if err != nil {
		return err
	}
	for _, e := range entries {
		if err := copyEntry(filepath.Join(src, e.Name()), filepath.Join(dst, e.Name()), linkOK); err != nil {
			return err
		}
	}
	return nil
}

func copyRegular(src, dst string, perm os.FileMode, linkOK bool) error {
	if linkOK && os.Link(src, dst) == nil {
		return nil
	}
	if cloneFile(src, dst) == nil {
		return nil
	}
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()
	out, err := os.OpenFile(dst, os.O_CREATE|os.O_EXCL|os.O_WRONLY, perm|0o600)
	if err != nil {
		return err
	}
	if _, err := io.Copy(out, in); err != nil {
		out.Close()
		os.Remove(dst)
		return err
	}
	return out.Close()
}
