package sync

import (
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/clipboard"
)

func TestRepeatGuard(t *testing.T) {
	var g repeatGuard
	t0 := time.Unix(1_700_000_000, 0)
	text := clipboard.Content{Kind: clipboard.KindText, Text: "pnpm install"}

	if g.seen(text, t0) {
		t.Fatal("first copy reported as a repeat")
	}
	// 同一次复制让剪贴板变了两次
	if !g.seen(text, t0.Add(300*time.Millisecond)) {
		t.Fatal("same content right after was not a repeat")
	}
	// 过了一会儿再复制同样的内容：照常记录、同步
	if g.seen(text, t0.Add(300*time.Millisecond+repeatWindow)) {
		t.Fatal("same content after the window was a repeat")
	}

	// 内容不同就不算，哪怕只差格式或文件
	cases := []clipboard.Content{
		{Kind: clipboard.KindHTML, Text: "pnpm install", HTML: "<b>pnpm install</b>"},
		{Kind: clipboard.KindText, Text: "pnpm install "},
		{Kind: clipboard.KindFile, Files: []string{"/tmp/a"}},
		{Kind: clipboard.KindFile, Files: []string{"/tmp/a", "/tmp/b"}},
		{Kind: clipboard.KindImage, Image: []byte{1, 2, 3}},
		{Kind: clipboard.KindImage, Image: []byte{1, 2, 4}},
	}
	now := t0.Add(10 * time.Second)
	for i, c := range cases {
		now = now.Add(100 * time.Millisecond)
		if g.seen(c, now) {
			t.Fatalf("case %d reported as a repeat of the previous content", i)
		}
	}
}
