package main

import (
	_ "embed"
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"runtime"
	"sort"
	"strings"
)

const shareMenuMarker = "# PasteFerry file sharing\n"

//go:embed share_menu_names.json
var shareMenuNamesJSON []byte

var shareMenuNames = func() map[string]string {
	var names map[string]string
	if err := json.Unmarshal(shareMenuNamesJSON, &names); err != nil {
		panic(err)
	}
	return names
}()

func nativeShareLanguage(locale string) string {
	locale = strings.ToLower(strings.ReplaceAll(locale, "_", "-"))
	locale = strings.SplitN(strings.SplitN(locale, ".", 2)[0], "@", 2)[0]
	if strings.HasPrefix(locale, "zh") {
		switch {
		case strings.Contains(locale, "-hk"), strings.Contains(locale, "-mo"):
			return "zh-HK"
		case strings.Contains(locale, "hant"), strings.Contains(locale, "-tw"):
			return "zh-Hant"
		default:
			return "zh-Hans"
		}
	}
	base := strings.SplitN(locale, "-", 2)[0]
	if base == "pt" {
		return "pt-BR"
	}
	if _, ok := shareMenuNames[base]; ok {
		return base
	}
	return "en"
}

func shareMenuSystemLanguage() string {
	for _, key := range []string{"LC_ALL", "LC_MESSAGES", "LANG"} {
		if value := os.Getenv(key); value != "" {
			if value == "C" || value == "POSIX" || strings.HasPrefix(value, "C.") {
				return "en"
			}
			if preferred := os.Getenv("LANGUAGE"); preferred != "" {
				return nativeShareLanguage(strings.SplitN(preferred, ":", 2)[0])
			}
			return nativeShareLanguage(value)
		}
	}
	return "en"
}

func dolphinShareMenu(cli string) (string, error) {
	if strings.ContainsAny(cli, "\r\n") {
		return "", errors.New("the application path cannot contain a line break")
	}
	quoted := strings.NewReplacer(`\`, `\\\\`, `"`, `\\"`, "`", "\\`", "$", `\\$`, "%", "%%").Replace(cli)
	var names strings.Builder
	languages := make([]string, 0, len(shareMenuNames))
	for language := range shareMenuNames {
		languages = append(languages, language)
	}
	sort.Strings(languages)
	for _, language := range languages {
		locale := strings.ReplaceAll(language, "-", "_")
		switch language {
		case "zh-Hans":
			locale = "zh_CN"
		case "zh-Hant":
			locale = "zh_TW"
		}
		fmt.Fprintf(&names, "Name[%s]=%s\n", locale, shareMenuNames[language])
	}
	return shareMenuMarker + `[Desktop Entry]
Type=Service
MimeType=application/octet-stream;inode/directory;
Actions=pasteferry-send;
X-KDE-Protocols=file
X-KDE-Priority=TopLevel

[Desktop Action pasteferry-send]
Name=Send with PasteFerry
` + names.String() + `Icon=com.pasteferry.app
Exec="` + quoted + `" share %F
`, nil
}

func installShareMenus(cli, data string, remove bool, language string) error {
	menu, err := dolphinShareMenu(cli)
	if err != nil {
		return err
	}
	quoted := "'" + strings.ReplaceAll(cli, "'", "'\"'\"'") + "'"
	script := "#!/bin/sh\n" + shareMenuMarker + "exec " + quoted + " share --uri-list \"${NAUTILUS_SCRIPT_SELECTED_URIS:-}\"\n"
	name := shareMenuNames[nativeShareLanguage(language)]
	items := map[string]string{
		filepath.Join(data, "kio", "servicemenus", "pasteferry-send.desktop"): menu,
		filepath.Join(data, "nautilus", "scripts", name):                      script,
	}
	// Preflight all localized and legacy names before changing either menu.
	// Only files carrying our marker may be replaced, renamed or removed.
	for _, title := range shareMenuNames {
		path := filepath.Join(data, "nautilus", "scripts", title)
		if _, keep := items[path]; !keep {
			items[path] = ""
		}
	}
	for path := range items {
		if old, err := os.ReadFile(path); err == nil && !strings.Contains(string(old), shareMenuMarker) {
			return fmt.Errorf("refusing to replace a non-PasteFerry menu: %s", path)
		} else if err != nil && !os.IsNotExist(err) {
			return err
		}
	}
	for path, content := range items {
		if remove || content == "" {
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
	return installShareMenus(executable, data, args[0] == "remove", shareMenuSystemLanguage())
}
