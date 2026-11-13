package p2p_test

import (
	"bytes"
	"context"
	"io"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/transport/p2p"
)

func TestIndependentStreamSurvivesPrimaryConnectionClosure(t *testing.T) {
	r := newRelay()
	alice := newHarness(t, "alice", r)
	bob := newHarness(t, "bob", r)
	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()
	if err := alice.manager.Connect(ctx, "bob"); err != nil {
		t.Fatal(err)
	}
	waitConnected(t, alice, "bob")
	waitConnected(t, bob, "alice")
	type result struct {
		c   io.ReadWriteCloser
		err error
	}
	accepted := make(chan result, 1)
	go func() {
		select {
		case st := <-bob.streams:
			c, err := bob.manager.AcceptIndependentStream(ctx, "alice", st)
			accepted <- result{c, err}
		case <-ctx.Done():
			accepted <- result{err: ctx.Err()}
		}
	}()
	a, err := alice.manager.OpenIndependentStream(ctx, "bob", "test-independent")
	if err != nil {
		t.Fatal(err)
	}
	defer a.Close()
	b := <-accepted
	if b.err != nil {
		t.Fatal(b.err)
	}
	defer b.c.Close()
	// A second DataChannel on the primary could not survive this. The
	// independent ICE/DTLS/SCTP connection must still deliver in both directions.
	alice.manager.Close()
	bob.manager.Close()
	payload := bytes.Repeat([]byte("independent bulk connection\x00"), 80000)
	done := make(chan error, 1)
	go func() { _, err := a.Write(payload); done <- err }()
	got := make([]byte, len(payload))
	if _, err := io.ReadFull(b.c, got); err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(got, payload) {
		t.Fatal("independent stream corrupted data")
	}
	if err := <-done; err != nil {
		t.Fatal(err)
	}
	go func() { _, err := b.c.Write([]byte("ack")); done <- err }()
	if _, err := io.ReadFull(a, got[:3]); err != nil {
		t.Fatal(err)
	}
	if string(got[:3]) != "ack" {
		t.Fatal("reverse independent stream failed")
	}
	if err := <-done; err != nil {
		t.Fatal(err)
	}
}

func TestIndependentHandshakeCancellation(t *testing.T) {
	r := newRelay()
	alice := newHarness(t, "alice", r)
	bob := newHarness(t, "bob", r)
	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()
	if err := alice.manager.Connect(ctx, "bob"); err != nil {
		t.Fatal(err)
	}
	waitConnected(t, alice, "bob")
	waitConnected(t, bob, "alice")
	setup, stop := context.WithTimeout(ctx, 100*time.Millisecond)
	defer stop()
	if c, err := alice.manager.OpenIndependentStream(setup, "bob", "unanswered"); err == nil {
		c.Close()
		t.Fatal("unanswered handshake succeeded")
	}
	if alice.manager.State("bob") != p2p.StateDirect {
		t.Fatal("bulk cancellation closed primary connection")
	}
}

func TestThreeIndependentConnectionsAndPrimaryShareFourConnectionBudget(t *testing.T) {
	r := newRelay()
	alice := newHarness(t, "alice", r)
	bob := newHarness(t, "bob", r)
	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()
	if err := alice.manager.Connect(ctx, "bob"); err != nil {
		t.Fatal(err)
	}
	waitConnected(t, alice, "bob")
	waitConnected(t, bob, "alice")
	for i := 0; i < 3; i++ {
		type result struct {
			c   io.ReadWriteCloser
			err error
		}
		accepted := make(chan result, 1)
		go func() {
			select {
			case st := <-bob.streams:
				c, err := bob.manager.AcceptIndependentStream(ctx, "alice", st)
				accepted <- result{c, err}
			case <-ctx.Done():
				accepted <- result{err: ctx.Err()}
			}
		}()
		a, err := alice.manager.OpenIndependentStream(ctx, "bob", "budget-test")
		if err != nil {
			t.Fatal(err)
		}
		defer a.Close()
		b := <-accepted
		if b.err != nil {
			t.Fatal(b.err)
		}
		defer b.c.Close()
		written := make(chan error, 1)
		go func() { _, err := a.Write([]byte("separate WebRTC")); written <- err }()
		got := make([]byte, len("separate WebRTC"))
		if _, err := io.ReadFull(b.c, got); err != nil {
			t.Fatal(err)
		}
		if string(got) != "separate WebRTC" {
			t.Fatal("bulk payload mismatch")
		}
		if err := <-written; err != nil {
			t.Fatal(err)
		}
	}
	if c, err := alice.manager.OpenIndependentStream(ctx, "bob", "fifth-connection"); err == nil {
		c.Close()
		t.Fatal("fifth WebRTC connection was accepted")
	}
}
