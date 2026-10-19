package update

import (
	"archive/tar"
	"archive/zip"
	"compress/gzip"
	"errors"
	"fmt"
	"io"
	"os"
	"path"
	"path/filepath"
	"strings"
)

// safeJoin 把压缩包里的路径接到 root 下，拒绝绝对路径与 ..（防止解压到外面）。
// Windows 的便携版 zip 用反斜杠分隔路径，统一换成斜杠。
func safeJoin(root, name string) (string, error) {
	name = strings.ReplaceAll(name, `\`, "/")
	clean := path.Clean("/" + name)
	if clean == "/" || strings.HasPrefix(name, "/") || strings.Contains(name, "../") || strings.HasSuffix(name, "/..") || name == ".." {
		return "", fmt.Errorf("压缩包里有不安全的路径 %q", name)
	}
	return filepath.Join(root, filepath.FromSlash(strings.TrimPrefix(clean, "/"))), nil
}

// unzip 把 zip 解压到 root。
func unzip(zipPath, root string) error {
	r, err := zip.OpenReader(zipPath)
	if err != nil {
		return err
	}
	defer r.Close()
	for _, f := range r.File {
		dest, err := safeJoin(root, f.Name)
		if err != nil {
			return err
		}
		if strings.HasSuffix(strings.ReplaceAll(f.Name, `\`, "/"), "/") || f.FileInfo().IsDir() {
			if err := os.MkdirAll(dest, 0o755); err != nil {
				return err
			}
			continue
		}
		if err := os.MkdirAll(filepath.Dir(dest), 0o755); err != nil {
			return err
		}
		in, err := f.Open()
		if err != nil {
			return err
		}
		err = writeFile(dest, in, f.Mode().Perm()|0o600)
		in.Close()
		if err != nil {
			return err
		}
	}
	return nil
}

// untar 把 tar.gz 解压到 root，保留可执行权限与包里的相对符号链接。
func untar(tgzPath, root string) error {
	f, err := os.Open(tgzPath)
	if err != nil {
		return err
	}
	defer f.Close()
	gz, err := gzip.NewReader(f)
	if err != nil {
		return err
	}
	defer gz.Close()
	tr := tar.NewReader(gz)
	for {
		h, err := tr.Next()
		if errors.Is(err, io.EOF) {
			return nil
		}
		if err != nil {
			return err
		}
		dest, err := safeJoin(root, h.Name)
		if err != nil {
			return err
		}
		switch h.Typeflag {
		case tar.TypeDir:
			if err := os.MkdirAll(dest, 0o755); err != nil {
				return err
			}
		case tar.TypeReg:
			if err := os.MkdirAll(filepath.Dir(dest), 0o755); err != nil {
				return err
			}
			if err := writeFile(dest, tr, os.FileMode(h.Mode).Perm()|0o600); err != nil {
				return err
			}
		case tar.TypeSymlink:
			if filepath.IsAbs(h.Linkname) || strings.Contains(h.Linkname, "..") {
				return fmt.Errorf("压缩包里有不安全的链接 %q", h.Linkname)
			}
			if err := os.MkdirAll(filepath.Dir(dest), 0o755); err != nil {
				return err
			}
			if err := os.Symlink(h.Linkname, dest); err != nil {
				return err
			}
		}
	}
}

func writeFile(dest string, r io.Reader, mode os.FileMode) error {
	out, err := os.OpenFile(dest, os.O_CREATE|os.O_TRUNC|os.O_WRONLY, mode)
	if err != nil {
		return err
	}
	if _, err := io.Copy(out, r); err != nil {
		out.Close()
		return err
	}
	return out.Close()
}

// stageFolder 把便携版或 tar.gz 解压到 app 旁边，返回其中的 PasteFerry 文件夹。
// 解压与 app 在同一个文件夹里，替换时只需改名。
func stageFolder(p *Plan, extract func(pkg, root string) error, required ...string) error {
	root := filepath.Join(filepath.Dir(p.App), ".PasteFerry-update-"+p.To)
	_ = os.RemoveAll(root)
	if err := extract(p.Package, root); err != nil {
		os.RemoveAll(root)
		return fmt.Errorf("解压新版本: %w", err)
	}
	staged := filepath.Join(root, "PasteFerry")
	for _, name := range required {
		if st, err := os.Stat(filepath.Join(staged, name)); err != nil || st.IsDir() {
			os.RemoveAll(root)
			return fmt.Errorf("新版本里缺少 %s", name)
		}
	}
	p.Staged = staged
	return nil
}

// stagingRoot 是 stageFolder 建的外层文件夹，替换完成后删掉。
func stagingRoot(p *Plan) string { return filepath.Dir(p.Staged) }

func oldFolder(p *Plan) string {
	return filepath.Join(filepath.Dir(p.App), ".PasteFerry-"+p.From+".old")
}
