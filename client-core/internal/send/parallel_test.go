package send

import (
	"bytes"
	"context"
	"io"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/store"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/striped"
	"github.com/pion/webrtc/v4"
)

func newParallelPair(t *testing.T, aNew, bNew bool, opens *atomic.Int32, configure func(*side, *Options)) *pair {
	return newPairWith(t, func(s *side, opts *Options) {
		local, remote := aNew, bNew
		if s.id == "bob" {
			local, remote = bNew, aNew
		}
		old := opts.Peer
		opts.Peer = func(id string) Peer { peer := old(id); peer.Parallel = remote; return peer }
		if local {
			opts.OpenIndependent = func(ctx context.Context, id, label string) (io.ReadWriteCloser, error) {
				if opens != nil {
					opens.Add(1)
				}
				return s.mgr.OpenIndependentStream(ctx, id, label)
			}
			opts.AcceptIndependent = s.mgr.AcceptIndependentStream
		}
		if configure != nil {
			configure(s, opts)
		}
	})
}

// These exercise both wire directions with absent legacy capability/handlers.
// The legacy file codec and protobuf messages themselves remain unchanged.
func TestParallelLegacyCompatibilityBothDirections(t *testing.T) {
	for _, c := range []struct {
		name string
		a, b bool
	}{{"new_to_old", true, false}, {"old_to_new", false, true}, {"new_to_new", true, true}} {
		t.Run(c.name, func(t *testing.T) {
			var opens atomic.Int32
			var mu sync.Mutex
			var labels []string
			p := newParallelPair(t, c.a, c.b, &opens, func(s *side, opts *Options) {
				old := opts.OpenStream
				opts.OpenStream = func(id, label string) (*webrtc.DataChannel, error) {
					mu.Lock()
					labels = append(labels, label)
					mu.Unlock()
					return old(id, label)
				}
			})
			for _, direction := range [][2]*side{{p.a, p.b}, {p.b, p.a}} {
				from, to := direction[0], direction[1]
				data := randomBytes(t, 2<<20+17)
				path := filepath.Join(t.TempDir(), "文件-compat.bin")
				writeFile(t, path, data)
				tr, err := from.eng.SendFiles(to.id, []string{path}, false, "")
				if err != nil {
					t.Fatal(err)
				}
				waitStatus(t, from, tr.GetId(), store.TransferDone)
				received := waitStatus(t, to, tr.GetId(), store.TransferDone)
				got, err := os.ReadFile(received.Paths[0])
				if err != nil {
					t.Fatal(err)
				}
				if !bytes.Equal(got, data) {
					t.Fatal("compatibility payload mismatch")
				}
			}
			if opens.Load() != 0 {
				t.Fatal("fast/legacy transfer unexpectedly opened independent connection")
			}
			mu.Lock()
			defer mu.Unlock()
			if len(labels) != 2 {
				t.Fatalf("expected two primary streams: %v", labels)
			}
			for _, label := range labels {
				if strings.HasSuffix(label, ":striped") != (c.a && c.b) {
					t.Fatalf("incorrect compatibility mode: %s", label)
				}
			}
		})
	}
}

func TestParallelTransferOpensIndependentConnection(t *testing.T) {
	var opens atomic.Int32
	p := newParallelPair(t, true, true, &opens, func(s *side, opts *Options) {
		opts.ParallelPolicy = striped.Policy{Observe: 10 * time.Millisecond, SlowBytesPerSecond: 1e12, MinRemaining: time.Nanosecond, MaxConnections: 2}
	})
	data := randomBytes(t, 32<<20+119)
	path := filepath.Join(t.TempDir(), "bulk.bin")
	writeFile(t, path, data)
	tr, err := p.a.eng.SendFiles("bob", []string{path}, false, "")
	if err != nil {
		t.Fatal(err)
	}
	waitStatus(t, p.a, tr.GetId(), store.TransferDone)
	received := waitStatus(t, p.b, tr.GetId(), store.TransferDone)
	got, err := os.ReadFile(received.Paths[0])
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(got, data) {
		t.Fatal("parallel file corrupted")
	}
	if opens.Load() < 1 {
		t.Fatal("slow-transfer policy did not open an independent WebRTC")
	}
}

func TestParallelResumeAfterInterruption(t *testing.T) {
	for _, fallback := range []bool{false, true} {
		t.Run(map[bool]string{false: "parallel", true: "legacy_fallback"}[fallback], func(t *testing.T) {
			var enabled atomic.Bool
			enabled.Store(true)
			p := newParallelPair(t, true, true, nil, func(s *side, opts *Options) {
				old := opts.Peer
				opts.Peer = func(id string) Peer { peer := old(id); peer.Parallel = enabled.Load(); return peer }
			})
			first := randomBytes(t, 2<<20)
			big := randomBytes(t, 40<<20)
			src := filepath.Join(t.TempDir(), "resume")
			writeFile(t, filepath.Join(src, "1.bin"), first)
			writeFile(t, filepath.Join(src, "2.bin"), big)
			tr, err := p.a.eng.SendFiles("bob", []string{src}, false, "")
			if err != nil {
				t.Fatal(err)
			}
			waitFor(t, 10*time.Second, func() bool {
				rows, _ := p.b.db.TransferEntries(tr.GetId(), 0, 10)
				return len(rows) == 3 && rows[2].DoneBytes >= 8<<20
			})
			p.b.eng.mu.Lock()
			in := p.b.eng.in[tr.GetId()]
			p.b.eng.mu.Unlock()
			if in == nil {
				t.Fatal("transfer completed before interruption")
			}
			in.abort(errIdle)
			waitStatus(t, p.a, tr.GetId(), store.TransferInterrupted)
			waitStatus(t, p.b, tr.GetId(), store.TransferInterrupted)
			if fallback {
				enabled.Store(false)
			}
			p.a.eng.PeerReady("bob")
			waitStatus(t, p.a, tr.GetId(), store.TransferDone)
			waitStatus(t, p.b, tr.GetId(), store.TransferDone)
			sameFile(t, first, filepath.Join(p.b.recvDir, "resume", "1.bin"))
			sameFile(t, big, filepath.Join(p.b.recvDir, "resume", "2.bin"))
			p.a.mu.Lock()
			defer p.a.mu.Unlock()
			var resumed bool
			for _, answer := range p.a.answers {
				if answer.GetAttempt() > 1 && answer.GetResumeIndex() == 2 && answer.GetResumeOffset() >= 8<<20 {
					resumed = true
				}
			}
			if !resumed {
				t.Fatal("parallel retry did not retain the legacy file checkpoint")
			}
		})
	}
}

func TestParallelCancelCleansPartialFiles(t *testing.T) {
	p := newParallelPair(t, true, true, nil, nil)
	path := filepath.Join(t.TempDir(), "cancel.bin")
	writeFile(t, path, randomBytes(t, 32<<20))
	tr, err := p.a.eng.SendFiles("bob", []string{path}, false, "")
	if err != nil {
		t.Fatal(err)
	}
	waitStatus(t, p.b, tr.GetId(), store.TransferActive)
	if err := p.a.eng.Cancel(tr.GetId()); err != nil {
		t.Fatal(err)
	}
	waitStatus(t, p.a, tr.GetId(), store.TransferCancelled)
	waitStatus(t, p.b, tr.GetId(), store.TransferCancelled)
	if _, err := os.Stat(filepath.Join(p.b.recvDir, partialDir, tr.GetId())); !os.IsNotExist(err) {
		t.Fatal("cancelled parallel transfer left partial files")
	}
}

type failingBulk struct {
	io.ReadWriteCloser
	remaining int
}

func (c *failingBulk) Write(b []byte) (int, error) {
	if len(b) > c.remaining {
		_ = c.Close()
		return 0, io.ErrClosedPipe
	}
	c.remaining -= len(b)
	return c.ReadWriteCloser.Write(b)
}

func TestParallelAuxiliaryFailureKeepsFileTransferAlive(t *testing.T) {
	var failed atomic.Int32
	p := newParallelPair(t, true, true, nil, func(s *side, opts *Options) {
		opts.ParallelPolicy = striped.Policy{Observe: 10 * time.Millisecond, SlowBytesPerSecond: 1e12, MinRemaining: time.Nanosecond, MaxConnections: 2, Cooldown: time.Hour}
		open := opts.OpenIndependent
		opts.OpenIndependent = func(ctx context.Context, id, label string) (io.ReadWriteCloser, error) {
			c, err := open(ctx, id, label)
			if err != nil {
				return nil, err
			}
			failed.Add(1)
			return &failingBulk{ReadWriteCloser: c, remaining: 64<<10 + 100}, nil
		}
	})
	data := randomBytes(t, 32<<20)
	path := filepath.Join(t.TempDir(), "replay.bin")
	writeFile(t, path, data)
	tr, err := p.a.eng.SendFiles("bob", []string{path}, false, "")
	if err != nil {
		t.Fatal(err)
	}
	got := waitStatus(t, p.a, tr.GetId(), store.TransferDone)
	waitStatus(t, p.b, tr.GetId(), store.TransferDone)
	sameFile(t, data, filepath.Join(p.b.recvDir, "replay.bin"))
	if failed.Load() == 0 {
		t.Fatal("did not exercise an independent connection")
	}
	if got.Attempt != 1 {
		t.Fatalf("auxiliary failure restarted entire transfer: %d attempts", got.Attempt)
	}
}
