//go:build !windows

package config

import (
	"bufio"
	"os"
	"path/filepath"
	"runtime"
	"strings"
)

// DownloadsDir 返回系统的「下载」文件夹。Linux 上这个文件夹按系统语言命名（比如「下载」），
// 以 XDG 的 user-dirs.dirs 为准。
func DownloadsDir() string {
	home, _ := os.UserHomeDir()
	if runtime.GOOS == "linux" {
		if dir := xdgDownloadDir(home); dir != "" {
			return dir
		}
	}
	return filepath.Join(home, "Downloads")
}

func xdgDownloadDir(home string) string {
	cfg := os.Getenv("XDG_CONFIG_HOME")
	if cfg == "" {
		cfg = filepath.Join(home, ".config")
	}
	f, err := os.Open(filepath.Join(cfg, "user-dirs.dirs"))
	if err != nil {
		return ""
	}
	defer f.Close()
	sc := bufio.NewScanner(f)
	for sc.Scan() {
		line := strings.TrimSpace(sc.Text())
		value, ok := strings.CutPrefix(line, "XDG_DOWNLOAD_DIR=")
		if !ok {
			continue
		}
		value = strings.Trim(value, `"`)
		value = strings.Replace(value, "$HOME", home, 1)
		// 指向家目录本身表示用户关掉了这个文件夹，退回默认
		if value == "" || filepath.Clean(value) == filepath.Clean(home) {
			return ""
		}
		return value
	}
	return ""
}
