package config

import (
	"os"
	"path/filepath"

	"golang.org/x/sys/windows"
)

// DownloadsDir 返回系统的「下载」文件夹。用系统的已知文件夹接口取：
// 「下载」被移到别的盘、或被 OneDrive 重定向时，%USERPROFILE%\Downloads 就不对了。
func DownloadsDir() string {
	if dir, err := windows.KnownFolderPath(windows.FOLDERID_Downloads, 0); err == nil && dir != "" {
		return dir
	}
	return filepath.Join(os.Getenv("USERPROFILE"), "Downloads")
}
