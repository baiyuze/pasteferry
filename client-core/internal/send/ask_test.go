package send

import (
	"os"
	"path/filepath"
	"runtime"
	"strings"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/store"
)

// friendPair 是两个互为好友的设备：bob 收 alice 发来的文件要问用户。
func friendPair(t *testing.T) *pair {
	t.Helper()
	p := newPair(t)
	for _, s := range []*side{p.a, p.b} {
		s.mu.Lock()
		s.role = store.RoleFriend
		s.admit = Admission{Allowed: true}
		s.mu.Unlock()
	}
	return p
}

func askingOn(t *testing.T, s *side) store.Transfer {
	t.Helper()
	var found store.Transfer
	waitFor(t, 15*time.Second, func() bool {
		list, _ := s.db.ListTransfers(store.Incoming, 10, time.Time{})
		for _, tr := range list {
			if tr.Status == store.TransferAsking {
				found = tr
				return true
			}
		}
		return false
	})
	return found
}

func TestFriendAskAccept(t *testing.T) {
	p := friendPair(t)
	src := t.TempDir()
	data := randomBytes(t, 200<<10)
	writeFile(t, filepath.Join(src, "合同.png"), data)
	script := filepath.Join(src, "run.sh")
	writeFile(t, script, []byte("#!/bin/sh\necho hi\n"))
	if err := os.Chmod(script, 0o755); err != nil {
		t.Fatal(err)
	}
	tr, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "合同.png"), script}, false, "  合同第 3 页要签字 ")
	if err != nil {
		t.Fatal(err)
	}
	waitStatus(t, p.a, tr.Id, store.TransferAsking)
	got := askingOn(t, p.b)
	if got.Note != "合同第 3 页要签字" || got.PeerRole != store.RoleFriend {
		t.Fatalf("接收方看到的备注或角色不对: %q %q", got.Note, got.PeerRole)
	}
	if _, _, err := p.b.eng.Answer(got.ID, true); err != nil {
		t.Fatal(err)
	}
	waitStatus(t, p.a, tr.Id, store.TransferDone)
	done := waitStatus(t, p.b, got.ID, store.TransferDone)
	sameFile(t, data, filepath.Join(p.b.recvDir, "合同.png"))
	if len(done.Thumbs) != 2 || done.Thumbs[0] != "thumb:合同.png" || done.Thumbs[1] != "" {
		t.Fatalf("缩略图不对: %v", done.Thumbs)
	}
	if runtime.GOOS != "windows" {
		info, err := os.Stat(filepath.Join(p.b.recvDir, "run.sh"))
		if err != nil {
			t.Fatal(err)
		}
		if info.Mode().Perm()&0o111 != 0 {
			t.Fatalf("好友发来的文件不该能执行: %v", info.Mode())
		}
	}
}

func TestFriendAskDeclineAndMute(t *testing.T) {
	p := friendPair(t)
	src := t.TempDir()
	writeFile(t, filepath.Join(src, "a.txt"), []byte("hello"))
	for i := 0; i < declineLimit; i++ {
		tr, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "a.txt")}, false, "")
		if err != nil {
			t.Fatal(err)
		}
		got := askingOn(t, p.b)
		if _, _, err := p.b.eng.Answer(got.ID, false); err != nil {
			t.Fatal(err)
		}
		out := waitStatus(t, p.a, tr.Id, store.TransferDeclined)
		if out.Error != "declined" {
			t.Fatalf("发送方看到的原因不对: %q", out.Error)
		}
		waitStatus(t, p.b, got.ID, store.TransferDeclined)
	}
	// 一分钟内拒绝了 3 次：之后直接拒绝，不再问
	tr, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "a.txt")}, false, "")
	if err != nil {
		t.Fatal(err)
	}
	out := waitStatus(t, p.a, tr.Id, store.TransferDeclined)
	if out.Error != "rate_limited" {
		t.Fatalf("应当被防打扰挡住: %q", out.Error)
	}
}

func TestFriendAskTimeoutAndNotAllowed(t *testing.T) {
	p := friendPair(t)
	src := t.TempDir()
	writeFile(t, filepath.Join(src, "a.txt"), []byte("hello"))
	tr, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "a.txt")}, false, "")
	if err != nil {
		t.Fatal(err)
	}
	got := askingOn(t, p.b)
	if out := waitStatus(t, p.a, tr.Id, store.TransferDeclined); out.Error != "timeout" {
		t.Fatalf("没有回应应当是 timeout: %q", out.Error)
	}
	if in := waitStatus(t, p.b, got.ID, store.TransferDeclined); in.Error != "timeout" {
		t.Fatalf("接收方应当记为 timeout: %q", in.Error)
	}

	p.b.mu.Lock()
	p.b.admit = Admission{}
	p.b.mu.Unlock()
	tr, err = p.a.eng.SendFiles("bob", []string{filepath.Join(src, "a.txt")}, false, "")
	if err != nil {
		t.Fatal(err)
	}
	if out := waitStatus(t, p.a, tr.Id, store.TransferDeclined); out.Error != "not_allowed" {
		t.Fatalf("对方不接收时应当是 not_allowed: %q", out.Error)
	}
}

func TestFriendAutoAccept(t *testing.T) {
	p := friendPair(t)
	p.b.mu.Lock()
	p.b.admit = Admission{Allowed: true, AutoAccept: true}
	p.b.mu.Unlock()
	src := t.TempDir()
	writeFile(t, filepath.Join(src, "a.txt"), []byte("hello"))
	tr, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "a.txt")}, false, "")
	if err != nil {
		t.Fatal(err)
	}
	waitStatus(t, p.a, tr.Id, store.TransferDone)
}

// 发送方取消时，接收方的确认也随之结束
func TestFriendAskCancelledBySender(t *testing.T) {
	p := friendPair(t)
	src := t.TempDir()
	writeFile(t, filepath.Join(src, "a.txt"), []byte("hello"))
	tr, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "a.txt")}, false, "")
	if err != nil {
		t.Fatal(err)
	}
	got := askingOn(t, p.b)
	if err := p.a.eng.Cancel(tr.Id); err != nil {
		t.Fatal(err)
	}
	waitStatus(t, p.b, got.ID, store.TransferCancelled)
	if _, _, err := p.b.eng.Answer(got.ID, true); err != ErrNotAsking {
		t.Fatalf("取消后不能再接受: %v", err)
	}
}

func TestSendToFriendNeedsAskAndValidNote(t *testing.T) {
	p := friendPair(t)
	src := t.TempDir()
	writeFile(t, filepath.Join(src, "a.txt"), []byte("hello"))
	for _, note := range []string{"第一行\n第二行", strings.Repeat("长", MaxNote+1), "a\x07b"} {
		if _, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "a.txt")}, false, note); err != ErrBadNote {
			t.Fatalf("备注 %q 应当被拒: %v", note, err)
		}
	}
	if _, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "a.txt")}, false, strings.Repeat("长", MaxNote)); err != nil {
		t.Fatalf("200 字的备注可以发: %v", err)
	}
	// 对方是旧版本：收到会直接接收、绕过确认，不能发给它
	p.a.mu.Lock()
	p.a.noAsk = true
	p.a.mu.Unlock()
	if _, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "a.txt")}, false, ""); err != ErrUnsupported {
		t.Fatalf("对方不能等用户接受时不该发: %v", err)
	}
}
