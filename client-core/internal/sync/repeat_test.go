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
	// 文字在 textRepeatWindow 内重复复制（比如在网页上又点了一次「复制」）不再记一条
	if !g.seen(text, t0.Add(textRepeatWindow-time.Second)) {
		t.Fatal("same text inside the text window was not a repeat")
	}
	// 过了文字窗口再复制同样的内容：照常记录、同步
	if g.seen(text, t0.Add(2*textRepeatWindow)) {
		t.Fatal("same text after the text window was a repeat")
	}
	// 媒体仍按短的窗口算，避免把用户重新截的图当成重复
	img := clipboard.Content{Kind: clipboard.KindImage, Image: []byte{9, 9, 9}}
	if g.seen(img, t0.Add(time.Hour)) {
		t.Fatal("image after the window was a repeat")
	}
	if !g.seen(img, t0.Add(time.Hour+500*time.Millisecond)) {
		t.Fatal("same image right after was not a repeat")
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
