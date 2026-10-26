package peers

// 「所有人」模式下的陌生设备：只在局域网里，公钥只记在内存里。见 lan/stranger.go。

import (
	"context"
	"errors"
	"runtime"
	"strings"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/lan"
	"github.com/baiyuze/pasteferry/proto/deviceid"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// StrangerPrefix 是界面上陌生设备的 ID 前缀：后面是它的 mDNS 实例名。发文件时先换成真正的设备 ID
const StrangerPrefix = "lan:"

var ErrStrangerGone = errors.New("对方不在附近，或者已经关掉了「所有人」")

// strangerKeep 是发送方记住陌生设备多久（没有再联系就忘掉）
const strangerKeep = 30 * time.Minute

// ApplyEveryone 按设置打开或关掉「所有人」：设置变了、到时间了都调一次。关掉时忘掉所有陌生设备
func (m *Manager) ApplyEveryone() {
	cfg := m.loadConfig()
	if cfg.EffectiveReceiveFrom(time.Now()) == config.ReceiveFromEveryone {
		card := m.selfCard()
		m.lan.ShowEveryone(card.GetDisplayName(), runtime.GOOS)
		return
	}
	m.lan.ShowEveryone("", "")
	m.mu.Lock()
	var gone []string
	for id, c := range m.strangers {
		// 本机主动联系过的（发送方这边）保留，对方开着「所有人」时还要用
		if c.Service != "outgoing" {
			gone = append(gone, id)
			delete(m.strangers, id)
		}
	}
	m.mu.Unlock()
	for _, id := range gone {
		m.p2p.Disconnect(id)
		m.mu.Lock()
		delete(m.conn, id)
		m.mu.Unlock()
	}
	if len(gone) > 0 {
		m.lan.PeersChanged()
	}
}

// acceptStranger：本机开着「所有人」，有陌生设备要给本机发文件。记下它的公钥，回本机的名片
func (m *Manager) acceptStranger(peer lan.PeerInfo) *pb.FriendCard {
	if !deviceid.Valid(peer.ID, peer.PublicKey) || peer.ID == m.identity.DeviceID {
		return nil
	}
	if m.loadConfig().EffectiveReceiveFrom(time.Now()) != config.ReceiveFromEveryone || m.store.IsBlocked(peer.ID) {
		return nil
	}
	m.mu.Lock()
	switch m.roleLocked(peer.ID) {
	case RoleSelf, RoleFriend:
		// 已经认识的，不当陌生设备
	default:
		card := cleanCard(peer.Card)
		m.strangers[peer.ID] = store.Contact{ID: peer.ID, PublicKey: peer.PublicKey, DisplayName: card.GetDisplayName(),
			DeviceName: card.GetDeviceName(), Platform: peer.Platform, AddedAt: time.Now()}
		m.lastUse[peer.ID] = time.Now()
	}
	m.mu.Unlock()
	m.lan.PeersChanged()
	return m.selfCard()
}

// ResolveStranger 把界面上的陌生设备（lan:实例名）换成设备 ID：向它要公钥和名片，记下来。
// 不是 lan: 开头的原样返回。
func (m *Manager) ResolveStranger(ctx context.Context, id string) (string, error) {
	inst, ok := strings.CutPrefix(id, StrangerPrefix)
	if !ok {
		return id, nil
	}
	lctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()
	peer, err := m.lan.RequestStranger(lctx, inst, m.selfCard())
	if err != nil {
		return "", ErrStrangerGone
	}
	if !deviceid.Valid(peer.ID, peer.PublicKey) {
		return "", ErrBadPeerID
	}
	m.mu.Lock()
	if m.roleLocked(peer.ID) == "" {
		card := cleanCard(peer.Card)
		// Service 借来标记「本机主动联系的」，关掉本机的「所有人」时不删
		m.strangers[peer.ID] = store.Contact{ID: peer.ID, PublicKey: peer.PublicKey, DisplayName: card.GetDisplayName(),
			DeviceName: card.GetDeviceName(), Platform: peer.Platform, AddedAt: time.Now(), Service: "outgoing"}
	}
	m.lastUse[peer.ID] = time.Now()
	m.mu.Unlock()
	if len(peer.Addrs) > 0 {
		m.lan.Remember(peer.ID, peer.Addrs)
	}
	m.lan.PeersChanged()
	go m.ConnectFriend(peer.ID)
	return peer.ID, nil
}

// Stranger 返回认得的陌生设备
func (m *Manager) Stranger(id string) (*pb.Stranger, bool) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	c, ok := m.strangers[id]
	if !ok {
		return nil, false
	}
	return &pb.Stranger{Id: c.ID, DisplayName: c.DisplayName, DeviceName: c.DeviceName, Platform: c.Platform, ReceivesFiles: true}, true
}

// WatchStrangers 在隔空传送页打开期间每 2 秒推一次附近开着「所有人」的陌生设备（有变化时）。
func (m *Manager) WatchStrangers(ctx context.Context, send func(*pb.Strangers) error) error {
	t := time.NewTicker(2 * time.Second)
	defer t.Stop()
	var last string
	for {
		list := &pb.Strangers{}
		var key strings.Builder
		for _, s := range m.lan.Strangers() {
			if s.PeerID != "" {
				continue // 自己的设备或好友，雷达上已经有了
			}
			list.Strangers = append(list.Strangers, &pb.Stranger{Id: StrangerPrefix + s.ID, DisplayName: s.Name, Platform: s.Platform, ReceivesFiles: true})
			key.WriteString(s.ID + "\x00" + s.Name + "\x00")
		}
		if k := key.String(); k != last || last == "" {
			last = k
			if k == "" {
				last = "\x01"
			}
			if err := send(list); err != nil {
				return err
			}
		}
		select {
		case <-ctx.Done():
			return nil
		case <-t.C:
		}
	}
}

// BlockDevice 屏蔽一台陌生设备：以后它的请求直接拒绝
func (m *Manager) BlockDevice(id string) error {
	if err := m.store.BlockDevice(id, time.Now()); err != nil {
		return err
	}
	m.mu.Lock()
	_, was := m.strangers[id]
	delete(m.strangers, id)
	m.mu.Unlock()
	if was {
		m.p2p.Disconnect(id)
		m.lan.PeersChanged()
	}
	return nil
}

// forgetIdleStrangers 忘掉很久没联系的陌生设备
func (m *Manager) forgetIdleStrangers() {
	now := time.Now()
	m.mu.Lock()
	defer m.mu.Unlock()
	for id := range m.strangers {
		if now.Sub(m.lastUse[id]) > strangerKeep && !connected(m.conn[id]) {
			delete(m.strangers, id)
		}
	}
}
