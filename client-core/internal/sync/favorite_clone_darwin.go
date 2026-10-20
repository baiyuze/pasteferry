//go:build darwin

package sync

import "golang.org/x/sys/unix"

// APFS 的 clonefile 能整个复制一个文件夹，几乎不花时间，也不占额外空间。
// 不在 APFS 上（外接的 exFAT 盘等）会失败，调用方再退回逐个文件复制。

func cloneTree(src, dst string) error { return unix.Clonefile(src, dst, unix.CLONE_NOFOLLOW) }

func cloneFile(src, dst string) error { return unix.Clonefile(src, dst, unix.CLONE_NOFOLLOW) }
