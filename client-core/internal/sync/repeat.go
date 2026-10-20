package sync

import (
	"crypto/sha256"
	"fmt"
	"sync"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/clipboard"
)

// repeatWindow 内又出现在剪贴板上的同一份内容不再记一条、也不再发一遍。
// 有的程序一次复制会让剪贴板变好几次（PowerShell 的 Set-Clipboard、先放 OLE 数据对象再 OleFlushClipboard 的程序），
// 剪贴板监听会把挨得很近的通知合并（见 clipboard.Watcher），隔得远一点的在这里按内容认出来。
const repeatWindow = 2 * time.Second

// repeatGuard 记着上一次本机复制的内容摘要与时间。
type repeatGuard struct {
	mu  sync.Mutex
	sum [32]byte
	at  time.Time
}

// seen 记下这次复制，返回它是不是 repeatWindow 内刚出现过的同一份内容。
func (g *repeatGuard) seen(c clipboard.Content, now time.Time) bool {
	sum := contentDigest(c)
	g.mu.Lock()
	defer g.mu.Unlock()
	repeat := !g.at.IsZero() && sum == g.sum && now.Sub(g.at) < repeatWindow
	g.sum, g.at = sum, now
	return repeat
}

func contentDigest(c clipboard.Content) [32]byte {
	h := sha256.New()
	fmt.Fprintf(h, "%d\x00%d:%s\x00%d:%s\x00%d:", c.Kind, len(c.Text), c.Text, len(c.HTML), c.HTML, len(c.Image))
	h.Write(c.Image)
	for _, f := range c.Files {
		fmt.Fprintf(h, "\x00%d:%s", len(f), f)
	}
	return [32]byte(h.Sum(nil))
}
