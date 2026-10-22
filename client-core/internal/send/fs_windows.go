package send

import (
	"strings"

	"golang.org/x/sys/windows"
)

func freeSpace(dir string) (int64, error) {
	p, err := windows.UTF16PtrFromString(dir)
	if err != nil {
		return 0, err
	}
	var free, total, totalFree uint64
	if err := windows.GetDiskFreeSpaceEx(p, &free, &total, &totalFree); err != nil {
		return 0, err
	}
	return int64(free), nil
}

// fat32 判断这个位置是不是在 FAT32 盘上：单个文件放不下 4 GB。exFAT 没有这个限制。
func fat32(dir string) bool {
	p, err := windows.UTF16PtrFromString(dir)
	if err != nil {
		return false
	}
	root := make([]uint16, windows.MAX_PATH+1)
	if err := windows.GetVolumePathName(p, &root[0], uint32(len(root))); err != nil {
		return false
	}
	fsName := make([]uint16, windows.MAX_PATH+1)
	if err := windows.GetVolumeInformation(&root[0], nil, 0, nil, nil, nil, &fsName[0], uint32(len(fsName))); err != nil {
		return false
	}
	name := windows.UTF16ToString(fsName)
	return strings.EqualFold(name, "FAT32") || strings.EqualFold(name, "FAT")
}

// hideDir 隐藏保存位置里放半成品的目录，资源管理器里不显示它。
func hideDir(dir string) {
	p, err := windows.UTF16PtrFromString(dir)
	if err != nil {
		return
	}
	attrs, err := windows.GetFileAttributes(p)
	if err != nil {
		return
	}
	_ = windows.SetFileAttributes(p, attrs|windows.FILE_ATTRIBUTE_HIDDEN)
}

// markQuarantine 在 Windows 上不打「来自网络」的标记：打了以后 Office 会以受保护的视图
// 只读打开每一份收到的文档。见 design/send-files.md 第 7 节。
func markQuarantine(string) {}
