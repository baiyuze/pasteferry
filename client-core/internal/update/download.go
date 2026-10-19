package update

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

// orderedMirrors 把与清单同一来源的镜像排在前面。
func orderedMirrors(m *Manifest, source string) []Mirror {
	var first, rest []Mirror
	for _, x := range m.Mirrors {
		if x.Source == source {
			first = append(first, x)
		} else {
			rest = append(rest, x)
		}
	}
	return append(first, rest...)
}

// Download 把安装包下载到 dir 里，大小与 SHA-256 都对上才返回它的路径。
// 已经下载好的同一个文件直接复用。各个镜像依次尝试，某个镜像的文件不对就换下一个。
func Download(ctx context.Context, client *http.Client, m *Manifest, source string, a Asset, dir string,
	progress func(done, total int64)) (string, error) {
	if err := os.MkdirAll(dir, 0o700); err != nil {
		return "", err
	}
	dest := filepath.Join(dir, a.Name)
	if ok, _ := matches(dest, a); ok {
		if progress != nil {
			progress(a.Size, a.Size)
		}
		return dest, nil
	}
	var lastErr error
	for _, mirror := range orderedMirrors(m, source) {
		if !strings.HasPrefix(mirror.Base, "https://") && !strings.HasPrefix(mirror.Base, "http://") {
			continue
		}
		err := downloadFrom(ctx, client, mirror.Base+a.Name, dest, a, progress)
		if err == nil {
			return dest, nil
		}
		if ctx.Err() != nil {
			return "", ctx.Err()
		}
		lastErr = fmt.Errorf("%s: %w", mirror.Source, err)
	}
	if lastErr == nil {
		lastErr = errors.New("没有可用的下载地址")
	}
	return "", lastErr
}

func downloadFrom(ctx context.Context, client *http.Client, url, dest string, a Asset, progress func(done, total int64)) error {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return err
	}
	req.Header.Set("User-Agent", "PasteFerry")
	// 下载大文件不受检查清单时的 30 秒总超时限制，靠 ctx 取消
	dl := *client
	dl.Timeout = 0
	resp, err := dl.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("HTTP %d", resp.StatusCode)
	}
	if resp.ContentLength > 0 && resp.ContentLength != a.Size {
		return fmt.Errorf("文件大小是 %d，清单里是 %d", resp.ContentLength, a.Size)
	}
	part := dest + ".part"
	f, err := os.OpenFile(part, os.O_CREATE|os.O_TRUNC|os.O_WRONLY, 0o600)
	if err != nil {
		return err
	}
	h := sha256.New()
	var done int64
	buf := make([]byte, 256<<10)
	for {
		n, rerr := resp.Body.Read(buf)
		if n > 0 {
			if done+int64(n) > a.Size {
				f.Close()
				os.Remove(part)
				return errors.New("文件比清单里的大")
			}
			if _, werr := f.Write(buf[:n]); werr != nil {
				f.Close()
				os.Remove(part)
				return werr
			}
			h.Write(buf[:n])
			done += int64(n)
			if progress != nil {
				progress(done, a.Size)
			}
		}
		if rerr == io.EOF {
			break
		}
		if rerr != nil {
			f.Close()
			os.Remove(part)
			return rerr
		}
	}
	if err := f.Close(); err != nil {
		os.Remove(part)
		return err
	}
	if done != a.Size || !strings.EqualFold(hex.EncodeToString(h.Sum(nil)), a.SHA256) {
		os.Remove(part)
		return errors.New("下载的文件与更新清单里的校验值不一致")
	}
	return os.Rename(part, dest)
}

// matches 检查已有的文件是否就是清单里的那个。
func matches(path string, a Asset) (bool, error) {
	f, err := os.Open(path)
	if err != nil {
		return false, err
	}
	defer f.Close()
	st, err := f.Stat()
	if err != nil || st.Size() != a.Size {
		return false, err
	}
	h := sha256.New()
	if _, err := io.Copy(h, f); err != nil {
		return false, err
	}
	return strings.EqualFold(hex.EncodeToString(h.Sum(nil)), a.SHA256), nil
}
