// Package striped stripes a byte stream over independently congested reliable
// connections. The existing file codec, SHA-256 checks and resume protocol stay
// above this layer. Out-of-order bytes are bounded and never exposed to it.
package striped

import (
	"bytes"
	"context"
	"crypto/sha256"
	"encoding/binary"
	"errors"
	"fmt"
	"io"
	"sync"
	"time"
)

const (
	BlockSize         = 64 << 10
	window            = 32 // At most 2 MiB of unacknowledged/reordered payload per direction.
	dataPacket   byte = 1
	ackPacket    byte = 2
	endPacket    byte = 3
	endACKPacket byte = 4
	headerSize        = 45
)

// Policy values can be shortened in integration tests. Zero uses production
// defaults. MaxConnections includes the primary connection and never exceeds 4.
type Policy struct {
	Observe            time.Duration
	SlowBytesPerSecond float64
	MinRemaining       time.Duration
	Cooldown           time.Duration
	MaxConnections     int
}

func (p Policy) defaults() Policy {
	if p.Observe <= 0 {
		p.Observe = 10 * time.Second
	}
	if p.SlowBytesPerSecond <= 0 {
		p.SlowBytesPerSecond = 256 << 10
	}
	if p.MinRemaining <= 0 {
		p.MinRemaining = 30 * time.Second
	}
	if p.Cooldown <= 0 {
		p.Cooldown = 30 * time.Second
	}
	if p.MaxConnections <= 0 || p.MaxConnections > 4 {
		p.MaxConnections = 4
	}
	return p
}

type block struct {
	data  []byte
	owner *link
}
type link struct {
	id      int
	c       io.ReadWriteCloser
	mu      sync.Mutex
	closed  bool // guarded by Pipe.mu
	lastACK time.Time
	limit   int // Grow the application window only after observing fast delivery.
}

// Pipe has one application writer (sender) or one reader (receiver). Add may be
// called concurrently. Connections are owned by the pipe after being added.
type Pipe struct {
	ctx        context.Context
	cancel     context.CancelCauseFunc
	mu         sync.Mutex
	changed    chan struct{}
	sender     bool
	links      []*link
	pending    map[uint64]*block
	next, base uint64
	end        *uint64
	current    []byte
	buf        []byte
	acked      int64
	closed     bool
	wg         sync.WaitGroup
}

func newPipe(ctx context.Context, c io.ReadWriteCloser, sender bool) *Pipe {
	ctx, cancel := context.WithCancelCause(ctx)
	p := &Pipe{ctx: ctx, cancel: cancel, sender: sender, changed: make(chan struct{}), pending: make(map[uint64]*block)}
	p.add(c)
	// The goroutine owns cancellation cleanup; Close is also safe before it runs.
	go func() { <-ctx.Done(); p.closeLinks() }()
	return p
}

// NewSender starts with one connection. open is called in the background only
// for sustained slow transfers. remaining reports remaining source-file bytes.
func NewSender(ctx context.Context, c io.ReadWriteCloser, open func(context.Context) (io.ReadWriteCloser, error), remaining func() int64, policy Policy) *Pipe {
	p := newPipe(ctx, c, true)
	if open != nil && remaining != nil {
		p.wg.Add(1)
		go func() { defer p.wg.Done(); p.adapt(open, remaining, policy.defaults()) }()
	}
	return p
}

func NewReceiver(ctx context.Context, c io.ReadWriteCloser) *Pipe { return newPipe(ctx, c, false) }

// Add accepts at most four simultaneous connections, including the primary.
func (p *Pipe) Add(c io.ReadWriteCloser) error {
	p.mu.Lock()
	defer p.mu.Unlock()
	if p.closed || p.ctx.Err() != nil {
		return io.ErrClosedPipe
	}
	n := 0
	for _, l := range p.links {
		if !l.closed {
			n++
		}
	}
	if n >= 4 {
		return errors.New("parallel connection limit")
	}
	p.addLocked(c)
	return nil
}

func (p *Pipe) add(c io.ReadWriteCloser) { p.mu.Lock(); defer p.mu.Unlock(); p.addLocked(c) }
func (p *Pipe) addLocked(c io.ReadWriteCloser) {
	l := &link{id: len(p.links), c: c, lastACK: time.Now(), limit: 1}
	p.links = append(p.links, l)
	p.wg.Add(1)
	go func() { defer p.wg.Done(); p.receive(l) }()
	if p.sender {
		p.wg.Add(1)
		go func() { defer p.wg.Done(); p.send(l) }()
	}
	p.signal()
}
func (p *Pipe) signal() { close(p.changed); p.changed = make(chan struct{}) }
func (p *Pipe) wait(ch <-chan struct{}) error {
	select {
	case <-ch:
		return nil
	case <-p.ctx.Done():
		return context.Cause(p.ctx)
	}
}

func writePacket(l *link, kind byte, seq uint64, data []byte) error {
	var h [headerSize]byte
	h[0] = kind
	binary.BigEndian.PutUint64(h[1:9], seq)
	binary.BigEndian.PutUint32(h[9:13], uint32(len(data)))
	if kind == dataPacket {
		sum := sha256.Sum256(data)
		copy(h[13:], sum[:])
	}
	l.mu.Lock()
	defer l.mu.Unlock()
	if err := writeAll(l.c, h[:]); err != nil {
		return err
	}
	return writeAll(l.c, data)
}
func writeAll(w io.Writer, b []byte) error {
	for len(b) > 0 {
		n, err := w.Write(b)
		if err != nil {
			return err
		}
		if n <= 0 {
			return io.ErrShortWrite
		}
		b = b[n:]
	}
	return nil
}

func (p *Pipe) receive(l *link) {
	for {
		var h [headerSize]byte
		if _, err := io.ReadFull(l.c, h[:]); err != nil {
			p.failed(l, err)
			return
		}
		kind, seq, n := h[0], binary.BigEndian.Uint64(h[1:9]), binary.BigEndian.Uint32(h[9:13])
		if kind == dataPacket && !p.sender && n > 0 && n <= BlockSize {
			b := make([]byte, n)
			if _, err := io.ReadFull(l.c, b); err != nil {
				p.failed(l, err)
				return
			}
			sum := sha256.Sum256(b)
			if !bytes.Equal(sum[:], h[13:]) {
				p.cancel(errors.New("parallel block checksum mismatch"))
				return
			}
			p.mu.Lock()
			if seq < p.next {
				p.mu.Unlock()
				if err := writePacket(l, ackPacket, seq, nil); err != nil {
					p.failed(l, err)
					return
				}
				continue
			}
			if seq-p.next >= window || p.end != nil && seq >= *p.end {
				p.mu.Unlock()
				p.cancel(errors.New("parallel block outside receive window"))
				return
			}
			if old := p.pending[seq]; old != nil && !bytes.Equal(old.data, b) {
				p.mu.Unlock()
				p.cancel(errors.New("conflicting parallel block"))
				return
			}
			p.pending[seq] = &block{data: b, owner: l}
			p.signal()
			p.mu.Unlock()
		} else if kind == ackPacket && p.sender && n == 0 {
			p.mu.Lock()
			if seq >= p.next {
				p.mu.Unlock()
				p.cancel(errors.New("invalid parallel acknowledgement"))
				return
			}
			if b := p.pending[seq]; b != nil {
				elapsed := time.Since(l.lastACK).Seconds()
				if elapsed > 0 && float64(len(b.data))/elapsed >= 256<<10 {
					l.limit = min(window, l.limit*2)
				} else {
					l.limit = 1
				}
				p.acked += int64(len(b.data))
				delete(p.pending, seq)
				for p.base < p.next && p.pending[p.base] == nil {
					p.base++
				}
			}
			l.lastACK = time.Now()
			p.signal()
			p.mu.Unlock()
		} else if kind == endPacket && !p.sender && l.id == 0 && n == 0 {
			p.mu.Lock()
			if seq < p.next || seq-p.next > window {
				p.mu.Unlock()
				p.cancel(errors.New("invalid parallel stream end"))
				return
			}
			p.mu.Unlock()
			if err := writePacket(l, endACKPacket, seq, nil); err != nil {
				p.failed(l, err)
				return
			}
			if d, ok := l.c.(interface{ Drain(context.Context) error }); ok {
				if err := d.Drain(p.ctx); err != nil {
					p.failed(l, err)
					return
				}
			}
			p.mu.Lock()
			p.end = &seq
			p.signal()
			p.mu.Unlock()
			return
		} else if kind == endACKPacket && p.sender && l.id == 0 && n == 0 {
			p.mu.Lock()
			if seq != p.next || len(p.pending) != 0 {
				p.mu.Unlock()
				p.cancel(errors.New("invalid parallel end acknowledgement"))
				return
			}
			p.end = &seq
			p.signal()
			p.mu.Unlock()
		} else {
			p.cancel(errors.New("invalid parallel packet"))
			return
		}
	}
}

func (p *Pipe) failed(l *link, err error) {
	// EOF here belongs to the network, never the source file. The file codec
	// uses source EOF to detect truncation, so preserve that distinction.
	if errors.Is(err, io.EOF) {
		err = io.ErrUnexpectedEOF
	}
	p.mu.Lock()
	if l.closed {
		p.mu.Unlock()
		return
	}
	l.closed = true
	for _, b := range p.pending {
		if p.sender && b.owner == l {
			b.owner = nil
		}
	}
	p.signal()
	p.mu.Unlock()
	_ = l.c.Close()
	p.mu.Lock()
	ended := p.end != nil
	p.mu.Unlock()
	if l.id == 0 && !ended {
		p.cancel(fmt.Errorf("primary parallel connection: %w", err))
	}
}

func (p *Pipe) send(l *link) {
	for {
		p.mu.Lock()
		if p.closed || l.closed || p.ctx.Err() != nil {
			p.mu.Unlock()
			return
		}
		var chosen *block
		var seq uint64
		inflight := 0
		for _, b := range p.pending {
			if b.owner == l {
				inflight++
			}
		}
		if inflight >= l.limit {
			ch := p.changed
			p.mu.Unlock()
			if p.wait(ch) != nil {
				return
			}
			continue
		}
		for i := p.base; i < p.next; i++ {
			if b := p.pending[i]; b != nil && b.owner == nil {
				idle := true
				for _, v := range p.pending {
					if v.owner == l {
						idle = false
						break
					}
				}
				if idle {
					l.lastACK = time.Now()
				}
				chosen, seq = b, i
				b.owner = l
				break
			}
		}
		ch := p.changed
		p.mu.Unlock()
		if chosen == nil {
			if p.wait(ch) != nil {
				return
			}
			continue
		}
		if err := writePacket(l, dataPacket, seq, chosen.data); err != nil {
			p.failed(l, err)
			return
		}
	}
}

func (p *Pipe) enqueue(b []byte) error {
	for {
		p.mu.Lock()
		if p.ctx.Err() != nil {
			p.mu.Unlock()
			return context.Cause(p.ctx)
		}
		if p.next-p.base < window {
			p.pending[p.next] = &block{data: append([]byte(nil), b...)}
			p.next++
			p.signal()
			p.mu.Unlock()
			return nil
		}
		ch := p.changed
		p.mu.Unlock()
		if err := p.wait(ch); err != nil {
			return err
		}
	}
}
func (p *Pipe) Write(b []byte) (int, error) {
	if !p.sender {
		return 0, errors.New("receive-only parallel pipe")
	}
	total := len(b)
	for len(b) > 0 {
		n := min(BlockSize-len(p.buf), len(b))
		p.buf = append(p.buf, b[:n]...)
		b = b[n:]
		if len(p.buf) == BlockSize {
			if err := p.enqueue(p.buf); err != nil {
				return total - len(b), err
			}
			p.buf = p.buf[:0]
		}
	}
	return total, nil
}

// Finish acknowledges every block before sending the stream end marker.
func (p *Pipe) Finish(ctx context.Context) error {
	if !p.sender {
		return errors.New("receive-only parallel pipe")
	}
	if len(p.buf) > 0 {
		if err := p.enqueue(p.buf); err != nil {
			return err
		}
		p.buf = p.buf[:0]
	}
	for {
		p.mu.Lock()
		empty := len(p.pending) == 0
		ch := p.changed
		seq := p.next
		primary := p.links[0]
		p.mu.Unlock()
		if p.ctx.Err() != nil {
			return context.Cause(p.ctx)
		}
		if empty {
			if err := writePacket(primary, endPacket, seq, nil); err != nil {
				return err
			}
			for {
				p.mu.Lock()
				ended := p.end != nil
				ch = p.changed
				p.mu.Unlock()
				if ended {
					return nil
				}
				select {
				case <-ch:
				case <-ctx.Done():
					return ctx.Err()
				case <-p.ctx.Done():
					return context.Cause(p.ctx)
				}
			}
		}
		select {
		case <-ch:
		case <-ctx.Done():
			return ctx.Err()
		case <-p.ctx.Done():
			return context.Cause(p.ctx)
		}
	}
}
func (p *Pipe) Read(b []byte) (int, error) {
	if p.sender {
		return 0, errors.New("send-only parallel pipe")
	}
	if len(b) == 0 {
		return 0, nil
	}
	for len(p.current) == 0 {
		p.mu.Lock()
		if p.ctx.Err() != nil {
			p.mu.Unlock()
			return 0, context.Cause(p.ctx)
		}
		if v := p.pending[p.next]; v != nil {
			seq := p.next
			delete(p.pending, seq)
			p.next++
			p.current = v.data
			p.signal()
			p.mu.Unlock()
			// Consumption, rather than arrival, releases the sender's window.
			// If this lane failed, replay on another lane will receive a duplicate ACK.
			if err := writePacket(v.owner, ackPacket, seq, nil); err != nil {
				p.failed(v.owner, err)
			}
			break
		}
		if p.end != nil && p.next == *p.end {
			p.mu.Unlock()
			return 0, io.EOF
		}
		ch := p.changed
		p.mu.Unlock()
		if err := p.wait(ch); err != nil {
			return 0, err
		}
	}
	n := copy(b, p.current)
	p.current = p.current[n:]
	return n, nil
}
func (p *Pipe) closeLinks() {
	p.mu.Lock()
	if p.closed {
		p.mu.Unlock()
		return
	}
	p.closed = true
	links := append([]*link(nil), p.links...)
	p.signal()
	p.mu.Unlock()
	for _, l := range links {
		_ = l.c.Close()
	}
}
func (p *Pipe) Close() error { p.cancel(io.ErrClosedPipe); p.closeLinks(); return nil }

func (p *Pipe) adapt(open func(context.Context) (io.ReadWriteCloser, error), remaining func() int64, policy Policy) {
	tick := time.NewTicker(policy.Observe)
	defer tick.Stop()
	lastAt, lastBytes := time.Now(), int64(0)
	var baseline float64
	var trial []*link
	trialWindows := 0
	cooldown := time.Time{}
	for {
		select {
		case <-p.ctx.Done():
			return
		case now := <-tick.C:
			p.mu.Lock()
			acked := p.acked
			active := 0
			busy := len(p.pending) > 0
			var queued int64
			for _, b := range p.pending {
				queued += int64(len(b.data))
			}
			trialAlive := false
			for _, l := range trial {
				if !l.closed {
					trialAlive = true
				}
			}
			var stalled []*link
			for _, l := range p.links {
				if !l.closed {
					active++
					if l.id > 0 && now.Sub(l.lastACK) > max(3*policy.Observe, time.Second) {
						for _, b := range p.pending {
							if b.owner == l {
								stalled = append(stalled, l)
								break
							}
						}
					}
				}
			}
			p.mu.Unlock()
			if len(stalled) > 0 {
				for _, l := range stalled {
					p.failed(l, errors.New("parallel connection stopped acknowledging"))
				}
				trial = nil
				cooldown = now.Add(policy.Cooldown)
				continue
			}
			rate := float64(acked-lastBytes) / now.Sub(lastAt).Seconds()
			lastAt, lastBytes = now, acked
			if len(trial) > 0 {
				if !trialAlive {
					trial = nil
					cooldown = now.Add(policy.Cooldown)
					continue
				}
				if rate <= 0 || rate < baseline*1.2 {
					for _, l := range trial {
						p.failed(l, errors.New("parallel probe produced no gain"))
					}
					cooldown = now.Add(policy.Cooldown)
					trial = nil
					tick.Reset(policy.Observe)
					continue
				}
				trialWindows++
				if trialWindows < 2 {
					continue
				}
				trial = nil
				tick.Reset(policy.Observe)
			}
			// Source progress can already include the entire small file while its
			// queued bytes are still crossing a slow link. Count those bytes too.
			left := max(0, remaining()) + queued
			if !busy || left <= 0 || active >= policy.MaxConnections || now.Before(cooldown) {
				continue
			}
			if active == 1 && rate >= policy.SlowBytesPerSecond {
				continue
			}
			if rate > 0 && float64(left)/rate < policy.MinRemaining.Seconds() {
				continue
			}
			baseline = rate
			trialWindows = 0
			count := min(active, policy.MaxConnections-active)
			for range count {
				c, err := open(p.ctx)
				if err != nil {
					cooldown = time.Now().Add(policy.Cooldown)
					break
				}
				p.mu.Lock()
				if p.ctx.Err() != nil {
					p.mu.Unlock()
					_ = c.Close()
					return
				}
				p.addLocked(c)
				trial = append(trial, p.links[len(p.links)-1])
				p.mu.Unlock()
			}
			// Handshake time is excluded from the next rate interval.
			p.mu.Lock()
			lastBytes = p.acked
			p.mu.Unlock()
			lastAt = time.Now()
			if len(trial) > 0 {
				tick.Reset(policy.Observe / 2)
			} else {
				tick.Reset(policy.Observe)
			}
		}
	}
}
