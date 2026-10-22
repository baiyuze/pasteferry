package send

import (
	"fmt"
	"io/fs"
	"path/filepath"
	"strings"
	"time"

	"golang.org/x/sys/unix"
)

func freeSpace(dir string) (int64, error) {
	var st unix.Statfs_t
	if err := unix.Statfs(dir, &st); err != nil {
		return 0, err
	}
	return int64(st.Bavail) * int64(st.Bsize), nil
}

// fat32 判断这个位置是不是在 FAT32 盘上：单个文件放不下 4 GB。exFAT 没有这个限制。
func fat32(dir string) bool {
	var st unix.Statfs_t
	if err := unix.Statfs(dir, &st); err != nil {
		return false
	}
	name := unix.ByteSliceToString(st.Fstypename[:])
	return strings.EqualFold(name, "msdos")
}

func hideDir(string) {} // 以点开头的目录访达本来就不显示

// markQuarantine 给收到的文件打上「来自网络」的标记，和隔空投送一样：
// 打开收到的程序或脚本时系统先确认一次，普通文档没有任何变化。
func markQuarantine(root string) {
	value := []byte(fmt.Sprintf("0083;%x;PasteFerry;", time.Now().Unix()))
	_ = filepath.WalkDir(root, func(p string, d fs.DirEntry, err error) error {
		if err != nil || d.Type()&fs.ModeSymlink != 0 {
			return nil
		}
		_ = unix.Setxattr(p, "com.apple.quarantine", value, 0)
		return nil
	})
}
