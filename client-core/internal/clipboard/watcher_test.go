package clipboard

import (
	"context"
	"errors"
	"sync/atomic"
	"testing"
	"time"
)

type testClipboard struct {
	revision          int64
	writeErr, peekErr error
	writes            int
}

func (c *testClipboard) Peek() (Snapshot, error) { return Snapshot{ChangeCount: c.revision}, c.peekErr }
func (*testClipboard) Read() (Content, error)    { return Content{}, nil }
func (c *testClipboard) Write(Content) error {
	if c.writeErr != nil {
		return c.writeErr
	}
	c.writes++
	c.revision++
	return nil
}
func (*testClipboard) Permission() Permission        { return PermissionNotApplicable }
func (*testClipboard) OpenPermissionSettings() error { return nil }

func TestWatcherConditionalWriteAndErrors(t *testing.T) {
	loop := NewMainLoop()
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	// Fake clipboard: execute the actual main-loop tasks without touching an OS
	// clipboard or requiring an interactive desktop on CI.
	done := make(chan struct{})
	go func() {
		defer close(done)
		for {
			select {
			case fn := <-loop.tasks:
				fn()
			case <-ctx.Done():
				return
			}
		}
	}()
	t.Cleanup(func() { cancel(); <-done })
	cb := &testClipboard{revision: 7}
	w := NewWatcher(WatcherOptions{Clipboard: cb, MainLoop: loop})
	if ok, err := w.WriteIfUnchanged(ctx, Content{}, 6); err != nil || ok {
		t.Fatalf("changed clipboard: %v %v", ok, err)
	}
	if cb.writes != 0 {
		t.Fatal("overwrote a newer clipboard")
	}
	if ok, err := w.WriteIfUnchanged(ctx, Content{}, 7); err != nil || !ok {
		t.Fatalf("unchanged clipboard: %v %v", ok, err)
	}
	writeErr := errors.New("clipboard locked")
	cb.writeErr = writeErr
	if err := w.Write(ctx, Content{}); !errors.Is(err, writeErr) {
		t.Fatalf("write error swallowed: %v", err)
	}
	cb.peekErr = errors.New("metadata unavailable")
	if ok, err := w.WriteIfUnchanged(ctx, Content{}, 8); err == nil || ok {
		t.Fatalf("failed probe authorized a write: %v %v", ok, err)
	}
}

// 本机写入正好插在一次轮询的探测与比对之间，也不能被当成用户的新复制
func TestOwnWritesNeverReportedWhilePolling(t *testing.T) {
	loop := NewMainLoop()
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	done := make(chan struct{})
	go func() {
		defer close(done)
		for {
			select {
			case fn := <-loop.tasks:
				fn()
			case <-ctx.Done():
				return
			}
		}
	}()
	t.Cleanup(func() { cancel(); <-done })

	cb := &testClipboard{revision: 1}
	w := NewWatcher(WatcherOptions{Clipboard: cb, MainLoop: loop, Interval: time.Microsecond})
	var reported atomic.Int32
	w.SetOnChange(func(Snapshot) { reported.Add(1) })
	go w.Run(ctx)
	time.Sleep(20 * time.Millisecond) // 先让它记下基线
	for range 3000 {
		if err := w.Write(ctx, Content{Kind: KindText, Text: "x"}); err != nil {
			t.Fatal(err)
		}
	}
	time.Sleep(20 * time.Millisecond)
	if n := reported.Load(); n != 0 {
		t.Fatalf("%d of our own writes were reported as new copies", n)
	}
}

func TestSettleWaitsForNotificationsToStop(t *testing.T) {
	notify := make(chan struct{}, 1)
	// 同一次复制连着来的几个通知：最后一个之后再等 delay
	go func() {
		for range 3 {
			notify <- struct{}{}
			time.Sleep(20 * time.Millisecond)
		}
	}()
	start := time.Now()
	settle(context.Background(), notify, 80*time.Millisecond, time.Second)
	if took := time.Since(start); took < 100*time.Millisecond || took > 600*time.Millisecond {
		t.Fatalf("settle took %v, want the notifications plus the 80ms delay", took)
	}
	select {
	case <-notify:
		t.Fatal("a notification was left over; settle should have drained it")
	default:
	}
}

func TestSettleGivesUpAfterMax(t *testing.T) {
	notify := make(chan struct{}, 1)
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	// 一直有通知
	go func() {
		for ctx.Err() == nil {
			select {
			case notify <- struct{}{}:
			default:
			}
			time.Sleep(10 * time.Millisecond)
		}
	}()
	start := time.Now()
	settle(ctx, notify, 50*time.Millisecond, 200*time.Millisecond)
	if took := time.Since(start); took < 190*time.Millisecond || took > 600*time.Millisecond {
		t.Fatalf("settle took %v, want it to stop at the 200ms limit", took)
	}
}
