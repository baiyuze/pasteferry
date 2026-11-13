package p2p

// Independent bulk connections negotiate over an already authenticated data
// channel. No new signaling-server protocol or TURN permission is required.
import (
	"context"
	"encoding/binary"
	"encoding/json"
	"errors"
	"io"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	"github.com/pion/ice/v4"
	"github.com/pion/webrtc/v4"
)

// DuplexStream exposes an existing stream as a bounded, bidirectional byte pipe.
// There must be exactly one reader and one writer.
func DuplexStream(st *Stream) io.ReadWriteCloser {
	return &duplexStream{st: st, r: st.Reader(), w: NewChunkWriter(st.dc, nil)}
}

type duplexStream struct {
	st *Stream
	r  io.Reader
	w  *ChunkWriter
}

func (s *duplexStream) Read(p []byte) (int, error) { return s.r.Read(p) }
func (s *duplexStream) Write(p []byte) (int, error) {
	n, err := s.w.Write(p)
	if err == nil {
		err = s.w.Flush()
	}
	return n, err
}
func (s *duplexStream) Close() error {
	err := s.w.Close()
	_ = s.st.Close()
	return err
}

func (s *duplexStream) Drain(ctx context.Context) error { return s.w.WaitDrained(ctx, 15*time.Second) }

type independentStream struct {
	io.ReadWriteCloser
	pc      *webrtc.PeerConnection
	neg     io.ReadWriteCloser
	once    sync.Once
	done    chan struct{}
	release func()
}

func (s *independentStream) Close() error {
	s.once.Do(func() {
		close(s.done)
		_ = s.ReadWriteCloser.Close()
		_ = s.neg.Close()
		_ = s.pc.Close()
		s.release()
	})
	return nil
}

func waitChannelOpen(ctx context.Context, dc *webrtc.DataChannel) error {
	tick := time.NewTicker(2 * time.Millisecond)
	defer tick.Stop()
	for {
		switch dc.ReadyState() {
		case webrtc.DataChannelStateOpen:
			return nil
		case webrtc.DataChannelStateClosed:
			return io.ErrClosedPipe
		}
		select {
		case <-ctx.Done():
			return ctx.Err()
		case <-tick.C:
		}
	}
}

// OpenIndependentStream creates a new UDP/ICE/DTLS/SCTP connection for bulk
// data. The negotiation channel uses the authenticated existing connection.
// Callers must first negotiate the bulk-stream capability with the peer.
func (m *Manager) OpenIndependentStream(ctx context.Context, device, label string) (_ io.ReadWriteCloser, err error) {
	if m.State(device) != StateDirect {
		return nil, ErrNotConnected
	}
	release, err := m.reserveBulk(device)
	if err != nil {
		return nil, err
	}
	defer func() {
		if err != nil {
			release()
		}
	}()
	dc, err := m.OpenStream(device, label)
	if err != nil {
		return nil, err
	}
	st := NewStream(dc) // Install the receiver before the first answer can arrive.
	neg := DuplexStream(st)
	setup, cancel := context.WithTimeout(ctx, 15*time.Second)
	defer cancel()
	stop := context.AfterFunc(setup, func() { _ = neg.Close() })
	defer stop()
	if err = waitChannelOpen(setup, dc); err != nil {
		_ = neg.Close()
		return nil, err
	}
	return m.independent(ctx, setup, neg, true, release)
}

// AcceptIndependentStream is called only after the file engine checks the
// transfer id, attempt, capability and connection budget of the negotiation.
func (m *Manager) AcceptIndependentStream(ctx context.Context, device string, st *Stream) (_ io.ReadWriteCloser, err error) {
	neg := DuplexStream(st)
	if m.State(device) != StateDirect {
		_ = neg.Close()
		return nil, ErrNotConnected
	}
	release, err := m.reserveBulk(device)
	if err != nil {
		_ = neg.Close()
		return nil, err
	}
	defer func() {
		if err != nil {
			release()
		}
	}()
	setup, cancel := context.WithTimeout(ctx, 15*time.Second)
	defer cancel()
	stop := context.AfterFunc(setup, func() { _ = neg.Close() })
	defer stop()
	return m.independent(ctx, setup, neg, false, release)
}

func (m *Manager) reserveBulk(device string) (func(), error) {
	m.bulkMu.Lock()
	defer m.bulkMu.Unlock()
	select {
	case <-m.stop:
		return nil, ErrNotConnected
	default:
	}
	if m.bulkSlots == nil {
		m.bulkSlots = make(map[string]int)
	}
	if m.bulkSlots[device] >= 3 {
		return nil, errors.New("independent WebRTC connection limit reached")
	}
	m.bulkSlots[device]++
	var once sync.Once
	return func() {
		once.Do(func() {
			m.bulkMu.Lock()
			m.bulkSlots[device]--
			if m.bulkSlots[device] == 0 {
				delete(m.bulkSlots, device)
			}
			m.bulkMu.Unlock()
		})
	}, nil
}

func (m *Manager) independent(ctx, setup context.Context, neg io.ReadWriteCloser, offerer bool, release func()) (_ io.ReadWriteCloser, err error) {
	// Never reuse the primary connection's UDP mux or its public candidates:
	// those mappings belong to a different socket. Never fall back to TURN.
	m.egressMu.Lock()
	urls := append([]string(nil), m.serverSTUN...)
	m.egressMu.Unlock()
	if m.probeServers != nil {
		urls = append(urls, m.probeServers()...)
	}
	var servers []webrtc.ICEServer
	for _, url := range urls {
		if strings.HasPrefix(url, "stun:") || strings.HasPrefix(url, "stuns:") {
			servers = append(servers, webrtc.ICEServer{URLs: []string{url}})
		}
	}
	settings := webrtc.SettingEngine{}
	settings.SetICEMulticastDNSMode(ice.MulticastDNSModeDisabled)
	pc, err := webrtc.NewAPI(webrtc.WithSettingEngine(settings)).NewPeerConnection(webrtc.Configuration{ICEServers: servers})
	if err != nil {
		_ = neg.Close()
		return nil, err
	}
	stop := context.AfterFunc(setup, func() { _ = neg.Close(); _ = pc.Close() })
	defer stop()
	defer func() {
		if err != nil {
			_ = neg.Close()
			_ = pc.Close()
		}
	}()
	ready := make(chan *Stream, 1)
	if offerer {
		dc, createErr := pc.CreateDataChannel("bulk", nil)
		if createErr != nil {
			return nil, createErr
		}
		st := NewStream(dc)
		dc.OnOpen(func() { ready <- st })
	} else {
		var accepted atomic.Bool
		pc.OnDataChannel(func(dc *webrtc.DataChannel) {
			if dc.Label() != "bulk" || !accepted.CompareAndSwap(false, true) {
				_ = dc.Close()
				return
			}
			st := NewStream(dc)
			select {
			case ready <- st:
			default:
				_ = st.Close()
			}
		})
	}
	local := func(offer bool) error {
		var desc webrtc.SessionDescription
		var e error
		if offer {
			desc, e = pc.CreateOffer(nil)
		} else {
			desc, e = pc.CreateAnswer(nil)
		}
		if e != nil {
			return e
		}
		gathered := webrtc.GatheringCompletePromise(pc)
		if e = pc.SetLocalDescription(desc); e != nil {
			return e
		}
		select {
		case <-gathered:
		case <-setup.Done():
			return setup.Err()
		}
		data, e := json.Marshal(pc.LocalDescription())
		if e != nil {
			return e
		}
		if len(data) > 64<<10 {
			return errors.New("bulk SDP too large")
		}
		var hdr [4]byte
		binary.BigEndian.PutUint32(hdr[:], uint32(len(data)))
		if _, e = neg.Write(hdr[:]); e != nil {
			return e
		}
		_, e = neg.Write(data)
		return e
	}
	remote := func() error {
		var hdr [4]byte
		if _, e := io.ReadFull(neg, hdr[:]); e != nil {
			return e
		}
		n := binary.BigEndian.Uint32(hdr[:])
		if n == 0 || n > 64<<10 {
			return errors.New("invalid bulk SDP length")
		}
		data := make([]byte, n)
		if _, e := io.ReadFull(neg, data); e != nil {
			return e
		}
		var desc webrtc.SessionDescription
		if e := json.Unmarshal(data, &desc); e != nil {
			return e
		}
		if offerer && desc.Type != webrtc.SDPTypeAnswer || !offerer && desc.Type != webrtc.SDPTypeOffer {
			return errors.New("invalid bulk SDP type")
		}
		return pc.SetRemoteDescription(desc)
	}
	if offerer {
		if err = local(true); err == nil {
			err = remote()
		}
	} else {
		if err = remote(); err == nil {
			err = local(false)
		}
	}
	if err != nil {
		return nil, err
	}
	var st *Stream
	select {
	case st = <-ready:
	case <-setup.Done():
		return nil, setup.Err()
	}
	if err = waitChannelOpen(setup, st.dc); err != nil {
		return nil, err
	}
	s := &independentStream{ReadWriteCloser: DuplexStream(st), pc: pc, neg: neg, done: make(chan struct{}), release: release}
	// Use the transfer lifetime, not the short setup deadline.
	go func() {
		select {
		case <-ctx.Done():
			_ = s.Close()
		case <-s.done:
		}
	}()
	if ctx.Err() != nil {
		_ = s.Close()
		return nil, ctx.Err()
	}
	return s, nil
}
