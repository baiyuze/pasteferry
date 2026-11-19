package p2p

import (
	"context"
	"crypto/rand"
	"encoding/base64"
	"errors"
	"github.com/baiyuze/pasteferry/client-core/internal/gateway"
	"net"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
	"github.com/pion/webrtc/v4"
)

const officialDirectWait = 8 * time.Second

// 官方中转暂时断开后，等它自己恢复的时限与检查间隔（变量供测试缩短）。
//
// 中转的数据走 WSS 隧道（TCP），4G、随身 WiFi 一卡顿，几秒收不到包是常事。
// pion 5 秒收不到就报 Disconnected，这只是「暂时断开」，包一恢复就自动回到 Connected；
// 30 秒仍没有包才报 Failed。时限要比这长，让 pion 先作结论。
var (
	relayRecoveryWait = 35 * time.Second
	relayRecoveryPoll = time.Second
)

type officialAttempt struct {
	id          string
	ctx         context.Context
	peer        *Peer
	cancel      context.CancelFunc
	pending     []*pb.SignalMessage
	failedUntil time.Time
	failReason  string
	// recovering 表示中转暂时断开、正在等它恢复。这期间仍把中转当作当前连接，
	// 不向上层报告离线，免得一次卡顿就打断发送、让界面跳回「正在连接」
	recovering atomic.Bool
	mu         sync.Mutex
}

func (m *Manager) officialEnabled() bool {
	return m.gateway != nil && m.official != nil && m.official()
}

// relayCarryingLocked 报告官方中转是否正承载与该设备的连接：已连通，或暂时断开、正在等它恢复。
func (m *Manager) relayCarryingLocked(id string) bool {
	a := m.relays[id]
	return a != nil && a.peer != nil && (a.peer.State() == StateRelay || a.recovering.Load())
}

func (m *Manager) selectedLocked(id string) *Peer {
	p := m.peers[id]
	if p != nil && p.State() == StateDirect {
		return p
	}
	if m.relayCarryingLocked(id) {
		return m.relays[id].peer
	}
	return p
}

// stateLocked 是对上层报告的连接状态：中转暂时断开、等待恢复时仍报「中转」。
func (m *Manager) stateLocked(id string) ConnState {
	p := m.selectedLocked(id)
	if p == nil {
		return StateOffline
	}
	if a := m.relays[id]; a != nil && p == a.peer && a.recovering.Load() {
		return StateRelay
	}
	return p.State()
}
func (m *Manager) scheduleFallback(id string) {
	if !m.officialEnabled() || m.selfID > id {
		return
	}
	m.mu.Lock()
	defer m.mu.Unlock()
	if p := m.peers[id]; p == nil || !p.DirectAttemptReady() {
		return
	}
	if !m.capable[id] || m.fallbackTimers[id] != nil {
		return
	}
	m.fallbackTimers[id] = time.AfterFunc(officialDirectWait, func() {
		m.mu.Lock()
		delete(m.fallbackTimers, id)
		p := m.peers[id]
		existing := m.relays[id]
		keepExisting := existing != nil && (time.Now().Before(existing.failedUntil) ||
			existing.ctx != nil && existing.ctx.Err() == nil)
		m.mu.Unlock()
		if p == nil || p.State() == StateDirect || keepExisting {
			return
		}
		if m.officialOnline != nil && !m.officialOnline(id) {
			return
		}
		b := make([]byte, 32)
		if _, err := rand.Read(b); err != nil {
			return
		}
		m.startOfficial(id, base64.RawURLEncoding.EncodeToString(b), nil, true)
	})
}
func (m *Manager) handleOfficialSignal(from string, msg *pb.SignalMessage) error {
	id := msg.GetConnectionAttemptId()
	b, err := base64.RawURLEncoding.DecodeString(id)
	if err != nil || len(b) != 32 || !msg.GetGatewayCapable() {
		return errors.New("invalid official connection attempt")
	}
	if m.officialOnline != nil && !m.officialOnline(from) {
		return errors.New("peer is not online on official signaling")
	}
	if reason := msg.GetRelayDenialCode(); reason != "" {
		m.mu.Lock()
		a := m.relays[from]
		if reason == "quota_available" {
			if a != nil && a.id == id && a.failReason == "peer_quota_exhausted" {
				a.failedUntil = time.Time{}
				a.failReason = ""
			}
			m.mu.Unlock()
			m.scheduleFallback(from)
			return nil
		}
		m.mu.Unlock()
		if a == nil || a.id != id {
			return nil
		}
		switch reason {
		case "quota_exhausted":
			reason = "peer_quota_exhausted"
		case "global_exhausted", "global_paused", "relay_blocked", "device_banned":
		default:
			return nil
		}
		m.officialFailed(from, a, &gateway.Error{Code: reason})
		return nil
	}
	m.mu.Lock()
	a := m.relays[from]
	direct := m.peers[from]
	if direct != nil && direct.State() == StateDirect {
		m.mu.Unlock()
		return nil
	}
	if a != nil && a.id == id {
		p := a.peer
		if p == nil {
			if len(a.pending) < 256 {
				a.pending = append(a.pending, msg)
			}
			m.mu.Unlock()
			return nil
		}
		m.mu.Unlock()
		return p.HandleSignal(context.Background(), msg)
	}
	m.mu.Unlock()
	// Only the deterministic offerer may initiate a relay attempt.
	if from > m.selfID || msg.GetOffer() == nil {
		return nil
	}
	m.startOfficial(from, id, msg, false)
	return nil
}
func (m *Manager) startOfficial(deviceID, id string, initial *pb.SignalMessage, offerer bool) {
	if !m.officialEnabled() {
		return
	}
	ctx, cancel := context.WithCancel(context.Background())
	a := &officialAttempt{id: id, ctx: ctx, cancel: cancel}
	if initial != nil {
		a.pending = append(a.pending, initial)
	}
	m.mu.Lock()
	old := m.relays[deviceID]
	if old != nil && old.id == id {
		m.mu.Unlock()
		cancel()
		return
	}
	m.relays[deviceID] = a
	m.mu.Unlock()
	if old != nil {
		old.cancel()
		m.gateway.ReleaseSession(old.id)
		if old.peer != nil {
			old.peer.Close()
		}
	}
	go func() {
		authCtx, stop := context.WithTimeout(ctx, 15*time.Second)
		_, err := m.gateway.Authorize(authCtx, deviceID, id)
		stop()
		if err != nil {
			m.officialFailed(deviceID, a, err)
			return
		}
		m.mu.RLock()
		servers := append([]webrtc.ICEServer(nil), m.iceServers...)
		m.mu.RUnlock()
		servers, addr := officialTURN(servers)
		if addr == "" {
			m.officialFailed(deviceID, a, errors.New("TURN configuration unavailable"))
			return
		}
		network, err := m.gateway.Network(ctx, id, addr)
		if err != nil {
			m.officialFailed(deviceID, a, err)
			return
		}
		network.OnClosed = func(err error) { m.officialFailed(deviceID, a, err) }
		p, err := NewPeer(PeerOptions{DeviceID: deviceID, SelfID: m.selfID, Logger: m.log, ICEServers: servers, ForceRelay: true, Net: network,
			SendSignal: func(ctx context.Context, msg *pb.SignalMessage) error {
				msg.GatewayCapable = true
				msg.OfficialRelay = true
				msg.ConnectionAttemptId = id
				return m.sendSignal(ctx, deviceID, msg)
			},
			OnState: func(s ConnState) { m.relayStateChanged(deviceID, a, s) },
			OnMessage: func(msg *pb.PeerMessage) {
				if m.onMessage != nil {
					m.onMessage(deviceID, msg)
				}
			}, OnStream: func(label string, stream *Stream) {
				if m.onStream != nil {
					m.onStream(deviceID, label, stream)
				}
			},
		})
		if err != nil {
			m.officialFailed(deviceID, a, err)
			return
		}
		m.mu.Lock()
		if m.relays[deviceID] != a || ctx.Err() != nil {
			m.mu.Unlock()
			p.Close()
			return
		}
		a.peer = p
		pending := a.pending
		a.pending = nil
		m.mu.Unlock()
		if offerer {
			if err = p.Connect(ctx); err != nil {
				m.officialFailed(deviceID, a, err)
				return
			}
		}
		for _, msg := range pending {
			if err = p.HandleSignal(ctx, msg); err != nil {
				m.officialFailed(deviceID, a, err)
				return
			}
		}
	}()
}
// relayStateChanged 处理官方中转连接的状态变化。
func (m *Manager) relayStateChanged(deviceID string, a *officialAttempt, s ConnState) {
	m.mu.RLock()
	current := m.relays[deviceID] == a
	direct := m.peers[deviceID]
	p := a.peer
	m.mu.RUnlock()
	if !current || direct != nil && direct.State() == StateDirect {
		return
	}
	if s == StateOffline && a.ctx.Err() == nil {
		if p != nil && p.Recoverable() {
			// 只是暂时断开（ICE Disconnected），连接还在，先等它恢复。
			// 以前这里立即拆掉中转并冷却一分钟，链路一卡顿就前功尽弃
			go m.awaitRelayRecovery(deviceID, a)
			return
		}
		go m.officialFailed(deviceID, a, errors.New("relay connection closed"))
		return
	}
	if m.onState != nil {
		m.onState(deviceID, s)
	}
}

// awaitRelayRecovery 等暂时断开的中转恢复；连接被关闭、或超过 relayRecoveryWait 仍未恢复才放弃。
func (m *Manager) awaitRelayRecovery(id string, a *officialAttempt) {
	if !a.recovering.CompareAndSwap(false, true) {
		return
	}
	m.mu.RLock()
	p := a.peer
	m.mu.RUnlock()
	m.log.Info("官方中转暂时断开，等待恢复", "peer", id)
	deadline := time.Now().Add(relayRecoveryWait)
	tick := time.NewTicker(relayRecoveryPoll)
	defer tick.Stop()
	for {
		select {
		case <-a.ctx.Done():
			// 别处已经放弃了这次中转（隧道关闭、被新的尝试取代、断开设备）
			a.recovering.Store(false)
			m.reportAfterRelay(id, a)
			return
		case <-tick.C:
		}
		if p.State() == StateRelay {
			a.recovering.Store(false)
			m.log.Info("官方中转已恢复", "peer", id)
			return
		}
		if !p.Recoverable() || time.Now().After(deadline) {
			break
		}
	}
	a.recovering.Store(false)
	m.officialFailed(id, a, errors.New("relay connection lost"))
	m.reportAfterRelay(id, a)
}

// reportAfterRelay 在等待恢复的中转被放弃后，向上层补报一次真实状态：
// 等待期间一直报的是「中转」，放弃时中转连接已是离线，关闭它不会再触发状态回调。
func (m *Manager) reportAfterRelay(id string, a *officialAttempt) {
	m.mu.RLock()
	current := m.relays[id] == a
	s := m.stateLocked(id)
	m.mu.RUnlock()
	if current && m.onState != nil {
		m.onState(id, s)
	}
}

func officialTURN(servers []webrtc.ICEServer) ([]webrtc.ICEServer, string) {
	for _, s := range servers {
		for _, u := range s.URLs {
			if !strings.HasPrefix(u, "turn:") || strings.Contains(u, "transport=tcp") {
				continue
			}
			addr := strings.SplitN(strings.TrimPrefix(u, "turn:"), "?", 2)[0]
			host, _, err := net.SplitHostPort(addr)
			if err != nil || net.ParseIP(host).To4() == nil {
				continue
			}
			s.URLs = []string{u}
			return []webrtc.ICEServer{s}, addr
		}
	}
	return nil, ""
}
func directICEServers(servers []webrtc.ICEServer) []webrtc.ICEServer {
	var out []webrtc.ICEServer
	for _, s := range servers {
		var urls []string
		for _, u := range s.URLs {
			if strings.HasPrefix(u, "stun:") || strings.HasPrefix(u, "stuns:") {
				urls = append(urls, u)
			}
		}
		if len(urls) > 0 {
			s.URLs = urls
			out = append(out, s)
		}
	}
	return out
}
func (m *Manager) officialFailed(id string, a *officialAttempt, err error) {
	// A tunnel reports quota closure before ICE notices the disconnected
	// transport. Preserve that reason so a later allowance increase can clear
	// the cooldown and notify the peer, rather than waiting until midnight.
	var quotaError *gateway.Error
	if !errors.As(err, &quotaError) {
		u := m.gateway.Usage()
		switch u.Reason {
		case "quota_exhausted", "global_exhausted", "global_paused", "relay_blocked", "device_banned":
			err = &gateway.Error{Code: u.Reason, Usage: &u}
		}
	}
	m.mu.Lock()
	if m.relays[id] != a || a.ctx != nil && a.ctx.Err() != nil {
		m.mu.Unlock()
		return
	}
	if m.relays[id] == a {
		var ge *gateway.Error
		if errors.As(err, &ge) {
			a.failReason = ge.Code
		}
		u := m.gateway.Usage()
		a.failedUntil = time.Now().Add(time.Minute)
		if u.ResetAt > time.Now().Unix() && (a.failReason == "quota_exhausted" || a.failReason == "global_exhausted" || a.failReason == "peer_quota_exhausted") {
			a.failedUntil = time.Unix(u.ResetAt, 0)
		}
	}
	p := a.peer
	retryAt := a.failedUntil
	m.mu.Unlock()
	// 中转失败的原因以前只在调试日志里，诊断报告看不出中转为什么断
	m.log.Warn("官方中转失败", "peer", id, "err", err, "最早重试", retryAt.Format("01-02 15:04:05"))
	a.cancel()
	m.gateway.ReleaseSession(a.id)
	if p != nil {
		p.Close()
	}
	m.gateway.ReportError(err)
	var denied *gateway.Error
	if errors.As(err, &denied) {
		switch denied.Code {
		case "quota_exhausted", "global_exhausted", "global_paused", "relay_blocked", "device_banned":
			ctx, stop := context.WithTimeout(context.Background(), 5*time.Second)
			defer stop()
			_ = m.sendSignal(ctx, id, &pb.SignalMessage{GatewayCapable: true, OfficialRelay: true, ConnectionAttemptId: a.id, RelayDenialCode: denied.Code})
		}
	}
}

// A fresh owner snapshot can re-enable relay after a policy change or reset.
// A paired peer receives only a signed availability hint; the gateway still
// independently verifies all new grants and never controls pairing trust.
func (m *Manager) OfficialAllowanceChanged() {
	if !m.officialEnabled() {
		return
	}
	m.mu.Lock()
	ready := map[string]string{}
	for id, a := range m.relays {
		switch a.failReason {
		case "quota_exhausted", "global_exhausted", "global_paused", "relay_blocked":
			a.failedUntil = time.Time{}
			a.failReason = ""
			ready[id] = a.id
		}
	}
	m.mu.Unlock()
	for id, session := range ready {
		m.scheduleFallback(id)
		go func(id, session string) {
			ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
			defer cancel()
			_ = m.sendSignal(ctx, id, &pb.SignalMessage{GatewayCapable: true, OfficialRelay: true, ConnectionAttemptId: session, RelayDenialCode: "quota_available"})
		}(id, session)
	}
}
func (m *Manager) stopOfficial(id string) {
	m.mu.Lock()
	a := m.relays[id]
	delete(m.relays, id)
	if t := m.fallbackTimers[id]; t != nil {
		t.Stop()
		delete(m.fallbackTimers, id)
	}
	m.mu.Unlock()
	if a != nil {
		a.cancel()
		m.gateway.ReleaseSession(a.id)
		if a.peer != nil {
			a.peer.Close()
		}
	}
}
func (m *Manager) stopAllOfficial() {
	m.mu.RLock()
	ids := make([]string, 0, len(m.relays)+len(m.fallbackTimers))
	for id := range m.relays {
		ids = append(ids, id)
	}
	for id := range m.fallbackTimers {
		ids = append(ids, id)
	}
	m.mu.RUnlock()
	for _, id := range ids {
		m.stopOfficial(id)
	}
}
func (m *Manager) officialRetryLoop() {
	t := time.NewTicker(30 * time.Second)
	defer t.Stop()
	for {
		select {
		case <-m.stop:
			return
		case <-t.C:
			if !m.officialEnabled() {
				continue
			}
			m.mu.RLock()
			ps := map[string]*Peer{}
			for id, a := range m.relays {
				if a.peer != nil && a.peer.State() == StateRelay && !a.peer.busy() && m.selfID < id {
					ps[id] = m.peers[id]
				}
			}
			m.mu.RUnlock()
			for _, p := range ps {
				if p != nil && p.State() != StateDirect {
					_ = p.Connect(context.Background())
				}
			}
		}
	}
}
