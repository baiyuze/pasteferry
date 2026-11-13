package striped

import (
	"bytes"
	"context"
	"crypto/rand"
	"encoding/binary"
	"io"
	"net"
	"sync/atomic"
	"testing"
	"time"
)

func randomPayload(t *testing.T, n int) []byte {
	t.Helper()
	b := make([]byte, n)
	if _, err := rand.Read(b); err != nil {
		t.Fatal(err)
	}
	return b
}

func runTransfer(t *testing.T, s, r *Pipe, payload []byte) {
	t.Helper()
	done := make(chan error, 1)
	go func() {
		_, err := s.Write(payload)
		if err == nil {
			err = s.Finish(s.ctx)
		}
		done <- err
	}()
	got, err := io.ReadAll(r)
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(got, payload) {
		t.Fatalf("payload mismatch: got %d, want %d", len(got), len(payload))
	}
	if err := <-done; err != nil {
		t.Fatal(err)
	}
}

func TestOrderedReassemblyAndLaneFailure(t *testing.T) {
	for _, fail := range []bool{false, true} {
		t.Run(map[bool]string{false: "out_of_order", true: "failed_lane"}[fail], func(t *testing.T) {
			ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
			defer cancel()
			a, b := net.Pipe()
			s := NewSender(ctx, &delayedConn{Conn: a, perBlock: time.Millisecond}, nil, nil, Policy{})
			defer s.Close()
			r := NewReceiver(ctx, b)
			defer r.Close()
			for i := 0; i < 3; i++ {
				x, y := net.Pipe()
				if err := r.Add(y); err != nil {
					t.Fatal(err)
				}
				var c io.ReadWriteCloser = x
				if fail && i == 0 {
					c = &breakingConn{Conn: x, remaining: BlockSize + headerSize + 20}
				}
				if err := s.Add(c); err != nil {
					t.Fatal(err)
				}
			}
			runTransfer(t, s, r, randomPayload(t, 5<<20+217))
		})
	}
}

type delayedConn struct {
	net.Conn
	perBlock time.Duration
}

func (c *delayedConn) Write(b []byte) (int, error) {
	if len(b) > headerSize {
		time.Sleep(c.perBlock)
	}
	return c.Conn.Write(b)
}

type breakingConn struct {
	net.Conn
	remaining int
}

func (c *breakingConn) Write(b []byte) (int, error) {
	if len(b) > c.remaining {
		_ = c.Conn.Close()
		return 0, io.ErrClosedPipe
	}
	c.remaining -= len(b)
	return c.Conn.Write(b)
}

func TestRejectsCorruptionAndUnboundedReordering(t *testing.T) {
	for _, kind := range []string{"checksum", "window", "oversize"} {
		t.Run(kind, func(t *testing.T) {
			ctx, cancel := context.WithTimeout(context.Background(), time.Second)
			defer cancel()
			a, b := net.Pipe()
			defer a.Close()
			r := NewReceiver(ctx, b)
			defer r.Close()
			go func() {
				if kind == "window" {
					_ = writePacket(&link{c: a}, dataPacket, window, []byte{1})
					return
				}
				var h [headerSize]byte
				h[0] = dataPacket
				if kind == "oversize" {
					binary.BigEndian.PutUint32(h[9:13], BlockSize+1)
					_, _ = a.Write(h[:])
					return
				}
				binary.BigEndian.PutUint32(h[9:13], 1)
				_, _ = a.Write(h[:])
				_, _ = a.Write([]byte{1})
			}()
			if _, err := io.ReadAll(r); err == nil || ctx.Err() != nil {
				t.Fatalf("expected immediate protocol error, got %v", err)
			}
		})
	}
}

func TestCancellationUnblocksFullWindow(t *testing.T) {
	ctx, cancel := context.WithCancel(context.Background())
	a, b := net.Pipe()
	defer b.Close()
	s := NewSender(ctx, a, nil, nil, Policy{})
	defer s.Close()
	done := make(chan error, 1)
	go func() { _, err := s.Write(make([]byte, (window+2)*BlockSize)); done <- err }()
	time.Sleep(20 * time.Millisecond)
	cancel()
	select {
	case err := <-done:
		if err == nil {
			t.Fatal("write unexpectedly succeeded")
		}
	case <-time.After(time.Second):
		t.Fatal("blocked writer survived cancellation")
	}
	s.wg.Wait()
}

func TestAdaptiveConnectionLimitAndRollback(t *testing.T) {
	for _, gain := range []bool{true, false} {
		t.Run(map[bool]string{true: "grow_to_four", false: "rollback"}[gain], func(t *testing.T) {
			ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
			defer cancel()
			a, b := net.Pipe()
			r := NewReceiver(ctx, b)
			defer r.Close()
			var opens atomic.Int32
			s := NewSender(ctx, &delayedConn{Conn: a, perBlock: 15 * time.Millisecond}, func(context.Context) (io.ReadWriteCloser, error) {
				opens.Add(1)
				x, y := net.Pipe()
				if err := r.Add(y); err != nil {
					return nil, err
				}
				if gain {
					return &delayedConn{Conn: x, perBlock: 15 * time.Millisecond}, nil
				}
				return &delayedConn{Conn: x, perBlock: 200 * time.Millisecond}, nil
			}, func() int64 { return 1 << 30 }, Policy{Observe: 200 * time.Millisecond, SlowBytesPerSecond: 1e12, MinRemaining: time.Nanosecond, Cooldown: time.Hour})
			defer s.Close()
			runTransfer(t, s, r, randomPayload(t, 12<<20))
			if gain && opens.Load() != 3 {
				t.Fatalf("expected three additional connections, got %d", opens.Load())
			}
			if !gain {
				if opens.Load() != 1 {
					t.Fatalf("rollback ignored cooldown: %d opens", opens.Load())
				}
				s.mu.Lock()
				closed := s.links[1].closed
				s.mu.Unlock()
				if !closed {
					t.Fatal("unhelpful extra connection was retained")
				}
			}
		})
	}
}

func TestRefusesFifthConnection(t *testing.T) {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	a, b := net.Pipe()
	defer b.Close()
	s := NewSender(ctx, a, nil, nil, Policy{})
	defer s.Close()
	for i := 0; i < 3; i++ {
		x, y := net.Pipe()
		defer y.Close()
		if err := s.Add(x); err != nil {
			t.Fatal(err)
		}
	}
	x, y := net.Pipe()
	defer x.Close()
	defer y.Close()
	if err := s.Add(x); err == nil {
		t.Fatal("fifth connection accepted")
	}
}
