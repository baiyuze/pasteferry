package main

import (
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"runtime"
	"strings"
)

const shareMenuMarker = "# PasteFerry file sharing\n"

func dolphinShareMenu(cli string) (string, error) {
	if strings.ContainsAny(cli, "\r\n") {
		return "", errors.New("the application path cannot contain a line break")
	}
	quoted := strings.NewReplacer(`\`, `\\\\`, `"`, `\\"`, "`", "\\`", "$", `\\$`, "%", "%%").Replace(cli)
	return shareMenuMarker + `[Desktop Entry]
Type=Service
MimeType=application/octet-stream;inode/directory;
Actions=pasteferry-send;
X-KDE-Protocols=file
X-KDE-Priority=TopLevel

[Desktop Action pasteferry-send]
Name=Send with PasteFerry
Name[zh_CN]=通过 PasteFerry 发送
Name[zh_TW]=透過 PasteFerry 傳送
Name[zh_HK]=透過 PasteFerry 傳送
Name[ja]=PasteFerry で送信
Icon=com.pasteferry.app
Exec="` + quoted + `" share %F
`, nil
}

func installShareMenus(cli, data string, remove bool) error {
	menu, err := dolphinShareMenu(cli)
	if err != nil {
		return err
	}
	quoted := "'" + strings.ReplaceAll(cli, "'", "'\"'\"'") + "'"
	script := "#!/bin/sh\n" + shareMenuMarker + "exec " + quoted + " share --uri-list \"${NAUTILUS_SCRIPT_SELECTED_URIS:-}\"\n"
	items := map[string]string{
		filepath.Join(data, "kio", "servicemenus", "pasteferry-send.desktop"): menu,
		filepath.Join(data, "nautilus", "scripts", "Send with PasteFerry"):    script,
	}
	// Check every destination before changing either menu, including removal.
	for path := range items {
		if old, err := os.ReadFile(path); err == nil && !strings.Contains(string(old), shareMenuMarker) {
			return fmt.Errorf("refusing to replace a non-PasteFerry menu: %s", path)
		} else if err != nil && !os.IsNotExist(err) {
			return err
		}
	}
	for path, content := range items {
		if remove {
			if err := os.Remove(path); err != nil && !os.IsNotExist(err) {
				return err
			}
			continue
		}
		if err := os.MkdirAll(filepath.Dir(path), 0755); err != nil {
			return err
		}
		if err := os.WriteFile(path, []byte(content), 0755); err != nil {
			return err
		}
		if err := os.Chmod(path, 0755); err != nil {
			return err
		}
	}
	return nil
}

func shareMenuCommand(args []string) error {
	if runtime.GOOS != "linux" {
		return errors.New("file manager menu installation is available on Linux")
	}
	if len(args) != 1 || args[0] != "install" && args[0] != "remove" {
		return errors.New("usage: share-menu install|remove")
	}
	executable, err := os.Executable()
	if err != nil {
		return err
	}
	executable, err = filepath.EvalSymlinks(executable)
	if err != nil {
		return err
	}
	data := os.Getenv("XDG_DATA_HOME")
	if !filepath.IsAbs(data) {
		home, err := os.UserHomeDir()
		if err != nil {
			return err
		}
		data = filepath.Join(home, ".local", "share")
	}
	return installShareMenus(executable, data, args[0] == "remove")
}
