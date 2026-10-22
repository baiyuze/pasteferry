package send

import "golang.org/x/sys/unix"

func freeSpace(dir string) (int64, error) {
	var st unix.Statfs_t
	if err := unix.Statfs(dir, &st); err != nil {
		return 0, err
	}
	return int64(st.Bavail) * st.Bsize, nil
}

// fat32 判断这个位置是不是在 FAT32 盘上：单个文件放不下 4 GB。exFAT 没有这个限制。
func fat32(dir string) bool {
	var st unix.Statfs_t
	if err := unix.Statfs(dir, &st); err != nil {
		return false
	}
	return st.Type == unix.MSDOS_SUPER_MAGIC
}

func hideDir(string) {}

func markQuarantine(string) {}
