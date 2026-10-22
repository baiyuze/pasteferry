package send

import (
	"context"
	"crypto/ed25519"
	"crypto/rand"
	"io"
	"net/netip"
	"os"
	"path/filepath"
	"sync/atomic"
	"testing"
	"time"

	"github.com/pion/webrtc/v4"

	"github.com/baiyuze/pasteferry/client-core/internal/store"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/lantcp"
	"github.com/baiyuze/pasteferry/proto/deviceid"
)

// 局域网快速通道：在两台设备之间接上真实的 lantcp（本机回环），看文件数据确实改走 TCP，
// 续传、取消照常，连不上时退回数据通道。

type lanStats struct {
	dials    atomic.Int32 // 发送方连上 TCP 的次数
	accepts  atomic.Int32 // 接收方接到 TCP 的次数
	channels atomic.Int32 // 发送方开数据通道的次数
}

// useLAN 给两边装上 ListenLAN、DialLAN。refuse 为 true 时接收方给出的端口一开就关，模拟防火墙挡住。
func useLAN(t *testing.T, p *pair, refuse bool) *lanStats {
	t.Helper()
	ids := map[string]string{} // 测试里的设备名 → 由公钥派生的设备 ID（lantcp 按它核对身份）
	links := map[string]*lantcp.Link{}
	for _, name := range []string{"alice", "bob"} {
		pub, priv, err := ed25519.GenerateKey(rand.Reader)
		if err != nil {
			t.Fatal(err)
		}
		l, err := lantcp.New(priv)
		if err != nil {
			t.Fatal(err)
		}
		ids[name], links[name] = deviceid.For(pub), l
	}
	st := &lanStats{}
	for _, s := range []*side{p.a, p.b} {
		self := links[s.id]
		open := s.eng.opts.OpenStream
		s.eng.opts.OpenStream = func(deviceID, label string) (*webrtc.DataChannel, error) {
			st.channels.Add(1)
			return open(deviceID, label)
		}
		s.eng.opts.ListenLAN = func(deviceID string) (string, func(context.Context) (io.ReadCloser, string, error), bool) {
			ln, err := self.Listen(netip.MustParseAddr("127.0.0.1"), ids[deviceID])
			if err != nil {
				t.Error(err)
				return "", nil, false
			}
			addr := ln.Addr()
			if refuse {
				ln.Close()
			}
			return addr, func(ctx context.Context) (io.ReadCloser, string, error) {
				c, label, err := ln.Accept(ctx)
				if err != nil {
					return nil, "", err
				}
				st.accepts.Add(1)
				return c, label, nil
			}, true
		}
		s.eng.opts.DialLAN = func(ctx context.Context, deviceID, addr, label string) (io.WriteCloser, error) {
			c, err := self.Dial(ctx, addr, ids[deviceID], label)
			if err != nil {
				return nil, err
			}
			st.dials.Add(1)
			return c, nil
		}
	}
	return st
}

func TestSendOverLAN(t *testing.T) {
	p := newPair(t)
	st := useLAN(t, p, false)
	src := t.TempDir()
	report := randomBytes(t, 3<<20)
	photo := randomBytes(t, 700<<10)
	writeFile(t, filepath.Join(src, "报告.pdf"), report)
	writeFile(t, filepath.Join(src, "照片", "2026", "IMG_1.HEIC"), photo)
	writeFile(t, filepath.Join(src, "照片", "空文件.txt"), nil)
	if err := os.MkdirAll(filepath.Join(src, "照片", "空文件夹"), 0o755); err != nil {
		t.Fatal(err)
	}

	tr, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "报告.pdf"), filepath.Join(src, "照片")}, false)
	if err != nil {
		t.Fatal(err)
	}
	waitStatus(t, p.a, tr.GetId(), store.TransferDone)
	waitStatus(t, p.b, tr.GetId(), store.TransferDone)
	sameFile(t, report, filepath.Join(p.b.recvDir, "报告.pdf"))
	sameFile(t, photo, filepath.Join(p.b.recvDir, "照片", "2026", "IMG_1.HEIC"))
	sameFile(t, nil, filepath.Join(p.b.recvDir, "照片", "空文件.txt"))
	if info, err := os.Stat(filepath.Join(p.b.recvDir, "照片", "空文件夹")); err != nil || !info.IsDir() {
		t.Fatal("空文件夹没有收到")
	}
	if st.dials.Load() != 1 || st.accepts.Load() != 1 || st.channels.Load() != 0 {
		t.Fatalf("应当只走 TCP：连上 %d 次，接到 %d 次，数据通道 %d 次", st.dials.Load(), st.accepts.Load(), st.channels.Load())
	}
}

func TestResumeOverLAN(t *testing.T) {
	p := newPair(t)
	st := useLAN(t, p, false)
	src := t.TempDir()
	first := randomBytes(t, 2<<20)
	big := randomBytes(t, 120<<20)
	writeFile(t, filepath.Join(src, "a", "1.bin"), first)
	writeFile(t, filepath.Join(src, "a", "2.bin"), big)

	tr, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "a")}, false)
	if err != nil {
		t.Fatal(err)
	}
	waitFor(t, 60*time.Second, func() bool {
		rows, _ := p.b.db.TransferEntries(tr.GetId(), 0, 10)
		return len(rows) == 3 && rows[2].DoneBytes > 8<<20
	})
	p.b.eng.mu.Lock()
	in := p.b.eng.in[tr.GetId()]
	p.b.eng.mu.Unlock()
	if in == nil {
		t.Skip("这台机器太快，还没来得及掐断就传完了")
	}
	in.abort(errIdle)
	waitStatus(t, p.b, tr.GetId(), store.TransferInterrupted)
	waitStatus(t, p.a, tr.GetId(), store.TransferInterrupted)

	p.a.eng.PeerReady("bob")
	waitStatus(t, p.a, tr.GetId(), store.TransferDone)
	waitStatus(t, p.b, tr.GetId(), store.TransferDone)
	sameFile(t, first, filepath.Join(p.b.recvDir, "a", "1.bin"))
	sameFile(t, big, filepath.Join(p.b.recvDir, "a", "2.bin"))
	if st.dials.Load() != 2 || st.channels.Load() != 0 {
		t.Fatalf("两次尝试都应当走 TCP：连上 %d 次，数据通道 %d 次", st.dials.Load(), st.channels.Load())
	}
}

func TestCancelOverLAN(t *testing.T) {
	p := newPair(t)
	st := useLAN(t, p, false)
	src := t.TempDir()
	writeFile(t, filepath.Join(src, "big.bin"), randomBytes(t, 200<<20))
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
	if st.dials.Load() != 1 {
		t.Fatalf("应当走 TCP，连上 %d 次", st.dials.Load())
	}
}

// 接收方给了地址但连不上（防火墙挡住）：退回数据通道，照常传完
func TestFallsBackWhenLANRefused(t *testing.T) {
	p := newPair(t)
	st := useLAN(t, p, true)
	src := t.TempDir()
	data := randomBytes(t, 5<<20)
	writeFile(t, filepath.Join(src, "a.bin"), data)
	tr, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "a.bin")}, false)
	if err != nil {
		t.Fatal(err)
	}
	waitStatus(t, p.a, tr.GetId(), store.TransferDone)
	waitStatus(t, p.b, tr.GetId(), store.TransferDone)
	sameFile(t, data, filepath.Join(p.b.recvDir, "a.bin"))
	if st.dials.Load() != 0 || st.channels.Load() != 1 {
		t.Fatalf("应当退回数据通道：连上 %d 次，数据通道 %d 次", st.dials.Load(), st.channels.Load())
	}
}

// 接收方不开端口（对方不支持、不是局域网直连）：应答里没有地址，直接走数据通道
func TestNoLANAddrUsesDataChannel(t *testing.T) {
	p := newPair(t)
	st := useLAN(t, p, false)
	p.b.eng.opts.ListenLAN = func(string) (string, func(context.Context) (io.ReadCloser, string, error), bool) {
		return "", nil, false
	}
	src := t.TempDir()
	data := randomBytes(t, 2<<20)
	writeFile(t, filepath.Join(src, "a.bin"), data)
	tr, err := p.a.eng.SendFiles("bob", []string{filepath.Join(src, "a.bin")}, false)
	if err != nil {
		t.Fatal(err)
	}
	waitStatus(t, p.a, tr.GetId(), store.TransferDone)
	sameFile(t, data, filepath.Join(p.b.recvDir, "a.bin"))
	p.a.mu.Lock()
	defer p.a.mu.Unlock()
	for _, a := range p.a.answers {
		if a.GetLanAddr() != "" {
			t.Fatalf("不开端口时应答里不该有地址：%q", a.GetLanAddr())
		}
	}
	if st.dials.Load() != 0 || st.channels.Load() != 1 {
		t.Fatalf("应当走数据通道：连上 %d 次，数据通道 %d 次", st.dials.Load(), st.channels.Load())
	}
}
