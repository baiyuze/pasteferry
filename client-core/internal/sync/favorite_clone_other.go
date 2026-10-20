//go:build !darwin && !linux

package sync

import "errors"

// Windows 上的 NTFS 没有写时复制，整份复制。
func cloneTree(string, string) error { return errors.ErrUnsupported }

func cloneFile(string, string) error { return errors.ErrUnsupported }
