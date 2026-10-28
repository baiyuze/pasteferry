package mobile

import (
	"errors"
	"os"
	"path/filepath"
	"strings"
	gosync "sync"

	"github.com/baiyuze/pasteferry/client-core/internal/clipboard"
)

// hostClipboard 是 Android 上的剪贴板：只写不读（design/phone-sync.md 3.3.2 节第 4 条）。
//
// Android 10 起后台读不到别的 App 复制的内容，所以 Read 返回 ErrUnsupported，手机发出的文字走 SubmitText。
// Peek 的变化计数只在本机写入时增加，Watcher 把这些变化认作「本机刚写的」，不会当成新复制再发出去。
type hostClipboard struct {
	host  Host
	dir   string // 剪贴板图片落盘的位置，宿主据此生成 content:// 地址
	mu    gosync.Mutex
	count int64
}

func newHostClipboard(h Host, dir string) *hostClipboard { return &hostClipboard{host: h, dir: dir} }

func (c *hostClipboard) Peek() (clipboard.Snapshot, error) {
	c.mu.Lock()
	defer c.mu.Unlock()
	return clipboard.Snapshot{ChangeCount: c.count}, nil
}

func (c *hostClipboard) Read() (clipboard.Content, error) {
	return clipboard.Content{}, clipboard.ErrUnsupported
}

func (c *hostClipboard) Write(content clipboard.Content) error {
	var err error
	switch content.Kind {
	case clipboard.KindText:
		err = c.host.WriteClipboard("text", content.Text, "", "")
	case clipboard.KindHTML:
		err = c.host.WriteClipboard("html", content.Text, content.HTML, "")
	case clipboard.KindImage:
		// 剪贴板图片是内存里的 PNG：先落盘，宿主才能给出 content:// 地址。每次覆盖同一个文件
		if err = os.MkdirAll(c.dir, 0o700); err == nil {
			path := filepath.Join(c.dir, "image.png")
			if err = os.WriteFile(path, content.Image, 0o600); err == nil {
				err = c.host.WriteClipboard("image", "", "", path)
			}
		}
	case clipboard.KindFile:
		if len(content.Files) == 0 {
			return errors.New("没有文件")
		}
		err = c.host.WriteClipboard("files", "", "", strings.Join(content.Files, "\n"))
	default:
		return clipboard.ErrUnsupported
	}
	if err != nil {
		return err
	}
	c.mu.Lock()
	c.count++
	c.mu.Unlock()
	return nil
}

func (c *hostClipboard) Permission() clipboard.Permission { return clipboard.PermissionNotApplicable }

func (c *hostClipboard) OpenPermissionSettings() error { return nil }
