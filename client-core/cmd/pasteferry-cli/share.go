package main

import (
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"net/url"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"
	"time"
)

// prepareShare only queues local input. The user still chooses the receiver
// and confirms in the GUI; no clipboard or network operation happens here.
func prepareShare(root string, args []string) (string, error) {
	if len(args) >= 1 && args[0] == "--uri-list" {
		if len(args) != 2 {
			return "", errors.New("usage: share --uri-list URI_LIST")
		}
		var paths []string
		for _, line := range strings.Split(args[1], "\n") {
			line = strings.TrimSuffix(line, "\r")
			if line == "" {
				continue
			}
			u, err := url.Parse(line)
			if err != nil || u.Scheme != "file" || u.Host != "" && u.Host != "localhost" || u.RawQuery != "" || u.Fragment != "" {
				return "", errors.New("only local file URIs can be shared")
			}
			path := u.Path
			if runtime.GOOS == "windows" && len(path) >= 3 && path[0] == '/' && path[2] == ':' {
				path = path[1:]
			}
			paths = append(paths, filepath.FromSlash(path))
		}
		args = paths
	}
	if len(args) == 0 || len(args) > 10000 {
		return "", errors.New("usage: share PATH... (1–10000 files or folders)")
	}
	var paths []string
	seen := make(map[string]bool)
	for _, path := range args {
		absolute, err := filepath.Abs(path)
		if err != nil {
			return "", err
		}
		info, err := os.Stat(absolute)
		if err != nil {
			return "", err
		}
		if !info.IsDir() && !info.Mode().IsRegular() {
			return "", fmt.Errorf("not a file or folder: %s", path)
		}
		if !seen[absolute] {
			paths = append(paths, absolute)
			seen[absolute] = true
		}
	}
	var entropy [16]byte
	if _, err := rand.Read(entropy[:]); err != nil {
		return "", err
	}
	id := hex.EncodeToString(entropy[:])
	body, err := json.Marshal(map[string]any{"id": id, "paths": paths, "createdAt": time.Now().UnixMilli()})
	if err != nil {
		return "", err
	}
	if len(body) > 2<<20 {
		return "", errors.New("share request is too large")
	}
	inbox := filepath.Join(root, "share-inbox")
	if err := os.MkdirAll(inbox, 0700); err != nil {
		return "", err
	}
	if err := os.Chmod(inbox, 0700); err != nil {
		return "", err
	}
	tmp := filepath.Join(inbox, id+".tmp")
	if err := os.WriteFile(tmp, body, 0600); err != nil {
		return "", err
	}
	target := filepath.Join(inbox, id+".json")
	if err := os.Rename(tmp, target); err != nil {
		_ = os.Remove(tmp)
		return "", err
	}
	return id, nil
}

func shareFiles(root string, args []string) error {
	if _, err := prepareShare(root, args); err != nil {
		return err
	}
	executable, err := os.Executable()
	if err != nil {
		return err
	}
	executable, err = filepath.EvalSymlinks(executable)
	if err != nil {
		return err
	}
	var command *exec.Cmd
	switch runtime.GOOS {
	case "darwin":
		bundle := filepath.Dir(filepath.Dir(filepath.Dir(executable)))
		if !strings.HasSuffix(bundle, ".app") {
			return errors.New("the CLI must be inside PasteFerry.app to open sharing")
		}
		command = exec.Command("open", bundle)
	case "windows":
		command = exec.Command(filepath.Join(filepath.Dir(executable), "PasteFerry.exe"))
	default:
		command = exec.Command(filepath.Join(filepath.Dir(executable), "pasteferry"))
	}
	if err := command.Start(); err != nil {
		return err
	}
	return command.Process.Release()
}
