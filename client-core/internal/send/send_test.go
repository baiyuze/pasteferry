package send

import (
	"bytes"
	"context"
	"crypto/rand"
	"os"
	"path/filepath"
	"runtime"
	"sync"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/p2p"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// 两台设备：各有自己的数据库、保存位置和隔空传送引擎，经本机回环上真实的 WebRTC 连接互发。

type side struct {
	id      string
	mgr     *p2p.Manager
	eng     *Engine
	db      *store.Store
	recvDir string

	mu       sync.Mutex
	cfg      config.Config
	offers   []*pb.SendOffer // 发出去的 SendOffer，看续传位置用
	answers  []*pb.SendAnswer
	blockOut bool // 模拟连接断了：控制消息发不出去
}

func (s *side) config() config.Config {
	s.mu.Lock()
	defer s.mu.Unlock()
	return s.cfg
}

type pair struct {
	a, b *side
	mu   sync.Mutex
	mgrs map[string]*p2p.Manager
}

func newPair(t *testing.T) *pair {
	t.Helper()
	p := &pair{mgrs: map[string]*p2p.Manager{}}
	p.a = p.newSide(t, "alice", "bob")
	p.b = p.newSide(t, "bob", "alice")
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()
	if err := p.a.mgr.Connect(ctx, "bob"); err != nil {
		t.Fatalf("建立连接: %v", err)
	}
	waitFor(t, 30*time.Second, func() bool {
		return connected(p.a.mgr.State("bob")) && connected(p.b.mgr.State("alice"))
	})
	return p
}

func connected(s p2p.ConnState) bool { return s == p2p.StateDirect || s == p2p.StateRelay }

func (p *pair) newSide(t *testing.T, id, peer string) *side {
	t.Helper()
	dir := t.TempDir()
	db, err := store.Open(filepath.Join(dir, "db.sqlite"))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { db.Close() })
	s := &side{id: id, db: db, recvDir: filepath.Join(dir, "Downloads")}
	if err := os.MkdirAll(s.recvDir, 0o755); err != nil {
		t.Fatal(err)
	}
	s.cfg = config.Default()
	s.cfg.ReceiveDir = s.recvDir

	s.mgr = p2p.NewManager(p2p.ManagerOptions{
		SelfID: id,
		SendSignal: func(_ context.Context, to string, msg *pb.SignalMessage) error {
			p.mu.Lock()
			target := p.mgrs[to]
			p.mu.Unlock()
			if target != nil {
				go func() {
					ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
					defer cancel()
					_ = target.HandleSignal(ctx, id, msg)
				}()
			}
			return nil
		},
		OnMessage: func(from string, msg *pb.PeerMessage) {
			if a := msg.GetSendAnswer(); a != nil {
				s.mu.Lock()
				s.answers = append(s.answers, a)
				s.mu.Unlock()
			}
			if s.eng != nil {
				s.eng.HandleMessage(from, msg)
			}
		},
		OnStream: func(from, label string, st *p2p.Stream) {
			if s.eng != nil && IsStream(label) {
				s.eng.HandleStream(from, label, st)
			}
		},
	})
	s.mgr.SetICEServers(nil)
	p.mu.Lock()
	p.mgrs[id] = s.mgr
	p.mu.Unlock()
	t.Cleanup(s.mgr.Close)

	s.eng = New(Options{
		Store:      db,
		LoadConfig: s.config,
		Send: func(to string, msg *pb.PeerMessage) error {
			s.mu.Lock()
			blocked := s.blockOut
			if o := msg.GetSendOffer(); o != nil {
				s.offers = append(s.offers, o)
			}
			s.mu.Unlock()
			if blocked {
				return p2p.ErrNotConnected
			}
			return s.mgr.Send(to, msg)
		},
		OpenStream: s.mgr.OpenStream,
		Peer: func(deviceID string) Peer {
			if deviceID != peer {
				return Peer{}
			}
			st := s.mgr.State(deviceID)
			return Peer{Known: true, Name: deviceID, Online: true, Connected: connected(st),
				Relayed: st == p2p.StateRelay, Supported: true}
		},
		AnswerTimeout: 10 * time.Second,
	})
	s.eng.Start()
	t.Cleanup(s.eng.Close)
	return s
}

func waitFor(t *testing.T, d time.Duration, ok func() bool) {
	t.Helper()
	deadline := time.Now().Add(d)
	for !ok() {
		if time.Now().After(deadline) {
			t.Fatal("等待超时")
		}
		time.Sleep(20 * time.Millisecond)
	}
}

func waitStatus(t *testing.T, s *side, id, want string) store.Transfer {
	t.Helper()
	var got store.Transfer
	deadline := time.Now().Add(60 * time.Second)
	for {
		tr, err := s.db.GetTransfer(id)
		if err == nil && tr.Status == want {
			return tr
		}
		if err == nil {
			got = tr
		}
		if time.Now().After(deadline) {
			t.Fatalf("%s 上的传输 %s 一直没有变成 %s（现在 %s %s）", s.id, id, want, got.Status, got.Error)
		}
		time.Sleep(20 * time.Millisecond)
	}
}

func writeFile(t *testing.T, path string, data []byte) {
	t.Helper()
	if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(path, data, 0o644); err != nil {
		t.Fatal(err)
	}
}

func randomBytes(t *testing.T, n int) []byte {
	t.Helper()
	b := make([]byte, n)
	if _, err := rand.Read(b); err != nil {
		t.Fatal(err)
	}
	return b
}

func sameFile(t *testing.T, want []byte, path string) {
	t.Helper()
	got, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("读取 %s: %v", path, err)
	}
	if !bytes.Equal(got, want) {
		t.Fatalf("%s 的内容不对：%d 字节，应为 %d 字节", path, len(got), len(want))
	}
}

func TestSendFilesAndFolder(t *testing.T) {
	p := newPair(t)
	src := t.TempDir()
	report := randomBytes(t, 3<<20)
	photo := randomBytes(t, 700<<10)
	writeFile(t, filepath.Join(src, "报告.pdf"), report)
	writeFile(t, filepath.Join(src, "照片", "2026", "IMG_1.HEIC"), photo)
	writeFile(t, filepath.Join(src, "照片", "空文件.txt"), nil)
	if err := os.MkdirAll(filepath.Join(src, "照片", "空文件夹"), 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.Symlink("2026/IMG_1.HEIC", filepath.Join(src, "照片", "最新")); err != nil {
		t.Fatal(err)
	}
	// 对方的保存位置里已经有一个同名文件：收到的要改名，不能覆盖
	writeFile(t, filepath.Join(p.b.recvDir, "报告.pdf"), []byte("old"))

	tr, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "报告.pdf"), filepath.Join(src, "照片")}, false)
	if err != nil {
		t.Fatal(err)
	}
	out := waitStatus(t, p.a, tr.GetId(), store.TransferDone)
	in := waitStatus(t, p.b, tr.GetId(), store.TransferDone)

	if out.FileCount != 3 || out.TotalBytes != int64(len(report)+len(photo)) {
		t.Fatalf("统计不对：%d 个文件，%d 字节", out.FileCount, out.TotalBytes)
	}
	sameFile(t, report, filepath.Join(p.b.recvDir, "报告 (2).pdf"))
	sameFile(t, []byte("old"), filepath.Join(p.b.recvDir, "报告.pdf"))
	sameFile(t, photo, filepath.Join(p.b.recvDir, "照片", "2026", "IMG_1.HEIC"))
	sameFile(t, nil, filepath.Join(p.b.recvDir, "照片", "空文件.txt"))
	if info, err := os.Stat(filepath.Join(p.b.recvDir, "照片", "空文件夹")); err != nil || !info.IsDir() {
		t.Fatal("空文件夹没有收到")
	}
	// 普通用户在 Windows 上建不了符号链接，接收方跳过它；其他平台照原样建
	if runtime.GOOS == "windows" {
		if _, err := os.Lstat(filepath.Join(p.b.recvDir, "照片", "最新")); !os.IsNotExist(err) {
			t.Fatalf("Windows 上应当跳过符号链接：%v", err)
		}
	} else if link, err := os.Readlink(filepath.Join(p.b.recvDir, "照片", "最新")); err != nil || link != "2026/IMG_1.HEIC" {
		t.Fatalf("符号链接不对：%q %v", link, err)
	}
	if _, err := os.Stat(filepath.Join(p.b.recvDir, partialDir)); !os.IsNotExist(err) {
		t.Fatal("临时目录没有清掉")
	}
	if len(in.Paths) != 2 || filepath.Base(in.Paths[0]) != "报告 (2).pdf" || in.Items[0].Name != "报告 (2).pdf" {
		t.Fatalf("收到的记录不对：%v %v", in.Paths, in.Items)
	}
	if rows, _ := p.b.db.TransferEntries(tr.GetId(), 0, 10); len(rows) != 0 {
		t.Fatal("收完以后条目应当清掉")
	}
}

func TestResumeAfterInterruption(t *testing.T) {
	p := newPair(t)
	src := t.TempDir()
	first := randomBytes(t, 2<<20)
	big := randomBytes(t, 40<<20)
	writeFile(t, filepath.Join(src, "a", "1.bin"), first)
	writeFile(t, filepath.Join(src, "a", "2.bin"), big)

	tr, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "a")}, false)
	if err != nil {
		t.Fatal(err)
	}
	// 等第二个文件收了一部分，然后掐断接收方的数据流（相当于连接断了）
	waitFor(t, 60*time.Second, func() bool {
		rows, _ := p.b.db.TransferEntries(tr.GetId(), 0, 10)
		return len(rows) == 3 && rows[2].DoneBytes > 8<<20
	})
	p.b.eng.mu.Lock()
	in := p.b.eng.in[tr.GetId()]
	p.b.eng.mu.Unlock()
	in.abort(errIdle)
	waitStatus(t, p.b, tr.GetId(), store.TransferInterrupted)
	waitStatus(t, p.a, tr.GetId(), store.TransferInterrupted)

	// 连接恢复：发送方自动续传
	p.a.eng.PeerReady("bob")
	waitStatus(t, p.a, tr.GetId(), store.TransferDone)
	waitStatus(t, p.b, tr.GetId(), store.TransferDone)
	sameFile(t, first, filepath.Join(p.b.recvDir, "a", "1.bin"))
	sameFile(t, big, filepath.Join(p.b.recvDir, "a", "2.bin"))

	p.a.mu.Lock()
	defer p.a.mu.Unlock()
	if len(p.a.offers) < 2 || !p.a.offers[len(p.a.offers)-1].GetResume() {
		t.Fatal("第二次发起应当是续传")
	}
	var resumed *pb.SendAnswer
	for _, a := range p.a.answers {
		if a.GetAttempt() == 2 {
			resumed = a
		}
	}
	if resumed == nil || resumed.GetResumeIndex() != 2 || resumed.GetResumeOffset() < 8<<20 {
		t.Fatalf("续传位置不对：%v", resumed)
	}
}

func TestCancelBySender(t *testing.T) {
	p := newPair(t)
	src := t.TempDir()
	writeFile(t, filepath.Join(src, "big.bin"), randomBytes(t, 60<<20))
	tr, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "big.bin")}, false)
	if err != nil {
		t.Fatal(err)
	}
	waitStatus(t, p.b, tr.GetId(), store.TransferActive)
	if err := p.a.eng.Cancel(tr.GetId()); err != nil {
		t.Fatal(err)
	}
	waitStatus(t, p.a, tr.GetId(), store.TransferCancelled)
	got := waitStatus(t, p.b, tr.GetId(), store.TransferCancelled)
	if got.Error != "peer_cancelled" {
		t.Fatalf("接收方的原因应为 peer_cancelled，实际 %q", got.Error)
	}
	if _, err := os.Stat(filepath.Join(p.b.recvDir, partialDir, tr.GetId())); !os.IsNotExist(err) {
		t.Fatal("取消后没收完的部分应当删掉")
	}
}

func TestReceiveDisabled(t *testing.T) {
	p := newPair(t)
	p.b.mu.Lock()
	p.b.cfg.ReceiveDisabled = true
	p.b.mu.Unlock()
	src := t.TempDir()
	writeFile(t, filepath.Join(src, "x.txt"), []byte("hi"))
	tr, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "x.txt")}, false)
	if err != nil {
		t.Fatal(err)
	}
	got := waitStatus(t, p.a, tr.GetId(), store.TransferDeclined)
	if got.Error != "disabled" {
		t.Fatalf("原因应为 disabled，实际 %q", got.Error)
	}
	if _, err := p.b.db.GetTransfer(tr.GetId()); err == nil {
		t.Fatal("关闭接收时不应留下记录")
	}
}

func TestSourceChangedBeforeSending(t *testing.T) {
	p := newPair(t)
	src := t.TempDir()
	path := filepath.Join(src, "notes.txt")
	writeFile(t, path, []byte("version 1"))

	// 先让控制消息发不出去，这一批统计完会停在中断
	p.a.mu.Lock()
	p.a.blockOut = true
	p.a.mu.Unlock()
	tr, err := p.a.eng.SendFiles("bob", []string{path}, false)
	if err != nil {
		t.Fatal(err)
	}
	waitStatus(t, p.a, tr.GetId(), store.TransferInterrupted)

	writeFile(t, path, []byte("version 2, longer"))
	p.a.mu.Lock()
	p.a.blockOut = false
	p.a.mu.Unlock()
	p.a.eng.PeerReady("bob")
	got := waitStatus(t, p.a, tr.GetId(), store.TransferFailed)
	if got.Error != "source_changed" {
		t.Fatalf("原因应为 source_changed，实际 %q", got.Error)
	}
	waitStatus(t, p.b, tr.GetId(), store.TransferFailed)
}

func TestRejectsPathsThroughSymlinks(t *testing.T) {
	base := t.TempDir()
	if err := os.MkdirAll(filepath.Join(base, "top"), 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.Symlink(t.TempDir(), filepath.Join(base, "top", "link")); err != nil {
		t.Fatal(err)
	}
	if err := noLinkParents(base, filepath.Join(base, "top", "link", "sub"), map[string]bool{}); err == nil {
		t.Fatal("经过符号链接的路径应当被拒绝")
	}
	if err := noLinkParents(base, filepath.Join(base, "top", "dir"), map[string]bool{}); err != nil {
		t.Fatalf("普通路径不该被拒绝: %v", err)
	}
}

func TestClaimDest(t *testing.T) {
	dir := t.TempDir()
	writeFile(t, filepath.Join(dir, "a.txt"), nil)
	writeFile(t, filepath.Join(dir, "a (2).txt"), nil)
	if got := filepath.Base(claimDest(dir, "a.txt", false)); got != "a (3).txt" {
		t.Fatalf("得到 %q", got)
	}
	if err := os.Mkdir(filepath.Join(dir, "v1.0"), 0o755); err != nil {
		t.Fatal(err)
	}
	if got := filepath.Base(claimDest(dir, "v1.0", true)); got != "v1.0 (2)" {
		t.Fatalf("文件夹不该按扩展名拆分，得到 %q", got)
	}
}

func TestDeclinesWhenSaveLocationIsGone(t *testing.T) {
	p := newPair(t)
	p.b.mu.Lock()
	p.b.cfg.ReceiveDir = filepath.Join(p.b.recvDir, "外置盘已拔出")
	p.b.mu.Unlock()
	src := t.TempDir()
	writeFile(t, filepath.Join(src, "x.txt"), []byte("hi"))
	tr, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "x.txt")}, false)
	if err != nil {
		t.Fatal(err)
	}
	if got := waitStatus(t, p.a, tr.GetId(), store.TransferDeclined); got.Error != "dest_unavailable" {
		t.Fatalf("发送方的原因应为 dest_unavailable，实际 %q", got.Error)
	}
	// 接收方也留一条记录：本机用户要知道有人发过来、为什么没收下
	if got := waitStatus(t, p.b, tr.GetId(), store.TransferDeclined); got.Error != "dest_unavailable" {
		t.Fatalf("接收方的原因应为 dest_unavailable，实际 %q", got.Error)
	}
}

func TestRefusesPeersThatCannotReceive(t *testing.T) {
	db, err := store.Open(filepath.Join(t.TempDir(), "db.sqlite"))
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()
	src := filepath.Join(t.TempDir(), "x.txt")
	writeFile(t, src, []byte("hi"))
	peer := Peer{Known: true, Online: true, Connected: true}
	e := New(Options{Store: db, LoadConfig: config.Default, Peer: func(string) Peer { return peer }})
	defer e.Close()

	cases := []struct {
		name string
		set  func()
		want error
	}{
		{"旧版本", func() {}, ErrUnsupported},
		{"关闭了接收", func() { peer.Supported, peer.Disabled = true, true }, ErrPeerDisabled},
		{"离线", func() { peer.Disabled, peer.Online = false, false }, ErrOffline},
		{"没配对", func() { peer.Known = false }, ErrUnknownDevice},
	}
	for _, c := range cases {
		c.set()
		if _, err := e.SendFiles("x", []string{src}, false); err != c.want {
			t.Errorf("%s：应返回 %v，实际 %v", c.name, c.want, err)
		}
	}
	peer = Peer{Known: true, Online: true, Connected: true, Supported: true}
	if _, err := e.SendFiles("x", []string{filepath.Join(t.TempDir(), "不存在")}, false); err == nil {
		t.Error("路径不存在时应当报错")
	}
}

func TestOfficialRelayNeedsConsent(t *testing.T) {
	db, err := store.Open(filepath.Join(t.TempDir(), "db.sqlite"))
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()
	src := filepath.Join(t.TempDir(), "x.txt")
	writeFile(t, src, []byte("hi"))
	cfg := config.Default()
	cfg.ServiceMode = "official"
	e := New(Options{Store: db, LoadConfig: func() config.Config { return cfg },
		Peer: func(string) Peer {
			return Peer{Known: true, Online: true, Connected: true, Relayed: true, Supported: true}
		},
		Send: func(string, *pb.PeerMessage) error { return p2p.ErrNotConnected }})
	defer e.Close()
	if _, err := e.SendFiles("x", []string{src}, false); err != ErrNeedRelayConsent {
		t.Fatalf("经官方中转时应先征得同意，实际 %v", err)
	}
	if _, err := e.SendFiles("x", []string{src}, true); err != nil {
		t.Fatalf("同意后应当能发：%v", err)
	}
}
