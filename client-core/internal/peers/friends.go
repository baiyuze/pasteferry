package peers

// 好友：别人的一台电脑，只能互相发文件，见 design/friends-send.md。
//
// 好友与配对设备分开存（store 的 contacts 表），连接按角色区分：
//   - self：自己配对的设备，什么都能收发（剪贴板同步、隔空传送）；
//   - friend：好友，只放行隔空传送、名片、头像和功能声明；
//   - stranger：「所有人」模式下局域网里的陌生设备，只放行隔空传送和功能声明。
// 白名单在 allowFromOther，以后新加的消息默认不放行。
//
// 加好友复用配对码的通道：好友码就是 F 加一个配对码。两边在交换公钥时说明这次的用途
// （局域网里放在 LanPairInfo.intent，经服务器时用签名的 PairIntent 信令），用途不一致就回绝，
// 免得把好友码当成配对码输进「添加设备」，把别人加成了自己的设备。

import (
	"bytes"
	"context"
	"crypto/sha256"
	"errors"
	"fmt"
	"net/netip"
	"runtime"
	"slices"
	"strings"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/lan"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/p2p"
	"github.com/baiyuze/pasteferry/proto/deviceid"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
	"github.com/baiyuze/pasteferry/proto/pairingcode"
)

// 连接的角色，与 store.RoleSelf 等相同
const (
	RoleSelf     = store.RoleSelf
	RoleFriend   = store.RoleFriend
	RoleStranger = store.RoleStranger
)

// 好友相关的功能标记（2.6.0）
const (
	FeatureFriends = "friends_v1"
	// 发来的文件可以等接收方的用户点「接受」（SendAnswer.reason = pending），带备注。
	// 给好友、陌生设备发文件要求对方声明它：旧版本收到发送请求会直接接收，绕过确认
	FeatureSendAsk = "send_files_ask_v1"
)

var (
	// ErrIsFriendCode：在「添加设备」里输入了好友码
	ErrIsFriendCode = errors.New("这是好友码，请在「添加好友」里输入")
	// ErrIsDeviceCode：在「添加好友」里输入了配对码
	ErrIsDeviceCode = errors.New("这是配对码，请在「添加设备」里输入")
	// ErrPeerOutdated：对方的版本不认识好友码
	ErrPeerOutdated = errors.New("对方需要更新到 2.6.0 或更高")
	// ErrAlreadyPaired：这台电脑已经是自己配对的设备
	ErrAlreadyPaired = errors.New("这台电脑已经是你的设备")
	ErrNotFriend     = errors.New("没有这个好友")
	// ErrFriendDeclined：对方在确认框里点了取消
	ErrFriendDeclined = errors.New("对方取消了")
)

const (
	// friendIdle 是好友的连接空闲多久后断开
	friendIdle = 2 * time.Minute
	// intentWait 是经服务器兑换好友码后，等对方说明用途的时间
	intentWait = 12 * time.Second
	// intentConfirmWait 是确认配对时最多再等对方说明用途多久
	intentConfirmWait = 5 * time.Second
	// noticeKeep 是删除好友的通知最多补发多久
	noticeKeep = 30 * 24 * time.Hour
	// 头像最大多大（JPEG）
	maxAvatarBytes = 64 << 10
)

// ─────────────────────── 角色 ───────────────────────

// Role 返回与某台电脑的关系：RoleSelf、RoleFriend、RoleStranger，都不是时为空。
func (m *Manager) Role(deviceID string) string {
	m.mu.RLock()
	defer m.mu.RUnlock()
	return m.roleLocked(deviceID)
}

func (m *Manager) roleLocked(id string) string {
	if _, ok := m.known[id]; ok {
		return RoleSelf
	}
	if _, ok := m.contacts[id]; ok {
		return RoleFriend
	}
	if _, ok := m.strangers[id]; ok {
		return RoleStranger
	}
	return ""
}

// allowFromOther 是好友和陌生设备发来的 P2P 消息里可以交给上层的那些：隔空传送的控制消息。
// 功能声明、名片、头像在本包里处理。其余（剪贴板同步等）一律不收
func allowFromOther(msg *pb.PeerMessage) bool {
	switch msg.GetPayload().(type) {
	case *pb.PeerMessage_SendOffer, *pb.PeerMessage_SendAnswer, *pb.PeerMessage_SendCancel, *pb.PeerMessage_SendResult:
		return true
	}
	return false
}

// handleOtherMessage 处理好友与陌生设备的 P2P 消息，返回 true 表示已处理或丢弃，不再交给上层。
func (m *Manager) handleOtherMessage(id, role string, msg *pb.PeerMessage) bool {
	m.touch(id)
	switch p := msg.GetPayload().(type) {
	case *pb.PeerMessage_Features:
		m.updatePeerFeatures(id, p.Features)
		return true
	case *pb.PeerMessage_FriendCard:
		if role == RoleFriend {
			m.updateFriendCard(id, p.FriendCard)
		}
		return true
	case *pb.PeerMessage_AvatarRequest:
		if role == RoleFriend {
			m.sendAvatar(id, p.AvatarRequest.GetAvatarHash())
		}
		return true
	case *pb.PeerMessage_AvatarData:
		if role == RoleFriend {
			m.receiveAvatar(id, p.AvatarData)
		}
		return true
	}
	if !allowFromOther(msg) {
		m.log.Warn("丢弃非自己设备发来的消息", "device", id, "role", role, "type", fmt.Sprintf("%T", msg.GetPayload()))
		return true
	}
	return false
}

func (m *Manager) touch(id string) {
	m.mu.Lock()
	m.lastUse[id] = time.Now()
	m.mu.Unlock()
}

// otherIDs 返回好友、待补发删除通知的、正在配对的和陌生设备：局域网通道也要去找它们。
func (m *Manager) lanPeerIDs() []string {
	m.mu.RLock()
	defer m.mu.RUnlock()
	ids := make([]string, 0, len(m.known)+len(m.contacts))
	for id := range m.known {
		ids = append(ids, id)
	}
	for id := range m.contacts {
		ids = append(ids, id)
	}
	for id := range m.notices {
		ids = append(ids, id)
	}
	for _, p := range m.pending {
		ids = append(ids, p.peer.ID)
	}
	for id := range m.strangers {
		ids = append(ids, id)
	}
	return ids
}

// watchIDs 是请服务器推送在线状态的设备：配对设备、好友、待补发删除通知的
func (m *Manager) watchIDsLocked() []string {
	ids := make([]string, 0, len(m.known)+len(m.contacts))
	for id := range m.known {
		ids = append(ids, id)
	}
	for id := range m.contacts {
		ids = append(ids, id)
	}
	for id := range m.notices {
		ids = append(ids, id)
	}
	return ids
}

// ─────────────────────── 功能声明 ───────────────────────

// featuresFor 是发给某个角色的功能声明。自己的设备看「接收文件」开关，别人看「允许这些人给我发文件」
func (m *Manager) featuresFor(role string) *pb.PeerMessage {
	cfg := m.loadConfig()
	var f []string
	switch role {
	case RoleSelf:
		f = []string{FeatureSendFiles}
		if cfg.ReceiveDisabled {
			f = []string{FeatureSendFilesOff}
		}
	default:
		if receivesFrom(cfg, role, time.Now()) {
			f = []string{FeatureSendFiles}
		} else {
			f = []string{FeatureSendFilesOff}
		}
	}
	f = append(f, FeatureSendFilesTCP, FeatureFriends, FeatureSendAsk)
	return &pb.PeerMessage{Payload: &pb.PeerMessage_Features{Features: &pb.PeerFeatures{Features: f, AppVersion: m.appVersion}}}
}

// receivesFrom 报告此刻是否接收某个角色发来的文件。
func receivesFrom(cfg config.Config, role string, now time.Time) bool {
	switch cfg.EffectiveReceiveFrom(now) {
	case config.ReceiveFromEveryone:
		return role == RoleFriend || role == RoleStranger
	case config.ReceiveFromFriends:
		return role == RoleFriend
	}
	return false
}

// ReceivesFrom 报告本机此刻是否接收这台电脑发来的文件（按它的角色和设置）。自己的设备看「接收文件」开关
func (m *Manager) ReceivesFrom(deviceID string) bool {
	role := m.Role(deviceID)
	if role == RoleSelf {
		return !m.loadConfig().ReceiveDisabled
	}
	return receivesFrom(m.loadConfig(), role, time.Now())
}

// ─────────────────────── 名片与头像 ───────────────────────

func (m *Manager) selfCard() *pb.FriendCard {
	if m.card != nil {
		return m.card()
	}
	cfg := m.loadConfig()
	return &pb.FriendCard{DisplayName: cfg.DisplayName, DeviceName: cfg.DeviceName, Platform: runtime.GOOS}
}

// ServiceHash 是自建服务器地址的哈希，好友据此判断两边是不是同一台服务器
func ServiceHash(url string) []byte {
	if url == "" {
		return nil
	}
	sum := sha256.Sum256([]byte(strings.TrimRight(strings.ToLower(strings.TrimSpace(url)), "/")))
	return sum[:16]
}

// AvatarHash 是头像（JPEG）的哈希
func AvatarHash(jpeg []byte) []byte {
	if len(jpeg) == 0 {
		return nil
	}
	sum := sha256.Sum256(jpeg)
	return sum[:16]
}

func cleanCard(c *pb.FriendCard) *pb.FriendCard {
	if c == nil {
		return &pb.FriendCard{}
	}
	trim := func(s string, n int) string {
		s = strings.Map(func(r rune) rune {
			if r < 0x20 || r == 0x7f {
				return -1
			}
			return r
		}, s)
		if len(s) > n {
			s = s[:n]
		}
		return s
	}
	out := &pb.FriendCard{
		DisplayName: trim(c.GetDisplayName(), 64),
		DeviceName:  trim(c.GetDeviceName(), 64),
		Platform:    trim(c.GetPlatform(), 16),
		Service:     trim(c.GetService(), 16),
	}
	if len(c.GetCustomServerHash()) <= 32 {
		out.CustomServerHash = c.GetCustomServerHash()
	}
	if len(c.GetAvatarHash()) <= 32 {
		out.AvatarHash = c.GetAvatarHash()
	}
	return out
}

func (m *Manager) updateFriendCard(id string, card *pb.FriendCard) {
	card = cleanCard(card)
	m.mu.Lock()
	c, ok := m.contacts[id]
	if !ok {
		m.mu.Unlock()
		return
	}
	if card.GetDisplayName() != "" {
		c.DisplayName = card.GetDisplayName()
	}
	if card.GetDeviceName() != "" {
		c.DeviceName = card.GetDeviceName()
	}
	if card.GetPlatform() != "" {
		c.Platform = card.GetPlatform()
	}
	c.Service, c.ServerHash = card.GetService(), card.GetCustomServerHash()
	wantAvatar := len(card.GetAvatarHash()) > 0 && !bytes.Equal(card.GetAvatarHash(), c.AvatarHash)
	if len(card.GetAvatarHash()) == 0 {
		c.AvatarHash, c.AvatarPath = nil, ""
	}
	m.contacts[id] = c
	m.mu.Unlock()
	if err := m.store.PutContact(c); err != nil {
		m.log.Warn("保存好友名片失败", "device", id, "err", err)
	}
	if wantAvatar {
		_ = m.p2p.Send(id, &pb.PeerMessage{Payload: &pb.PeerMessage_AvatarRequest{
			AvatarRequest: &pb.AvatarRequest{AvatarHash: card.GetAvatarHash()}}})
	}
	m.notifyFriend(id)
}

func (m *Manager) sendAvatar(id string, want []byte) {
	if m.avatar == nil {
		return
	}
	jpeg := m.avatar()
	if len(jpeg) == 0 || len(jpeg) > maxAvatarBytes || !bytes.Equal(AvatarHash(jpeg), want) {
		return
	}
	_ = m.p2p.Send(id, &pb.PeerMessage{Payload: &pb.PeerMessage_AvatarData{
		AvatarData: &pb.AvatarData{AvatarHash: AvatarHash(jpeg), Jpeg: jpeg}}})
}

func (m *Manager) receiveAvatar(id string, d *pb.AvatarData) {
	jpeg := d.GetJpeg()
	if len(jpeg) == 0 || len(jpeg) > maxAvatarBytes || !bytes.Equal(AvatarHash(jpeg), d.GetAvatarHash()) || m.saveAvatar == nil {
		return
	}
	// 收到的头像不直接显示：后台服务重新解码、编码后存一份，界面只读这一份
	path, err := m.saveAvatar(id, jpeg)
	if err != nil {
		m.log.Warn("好友的头像不能用", "device", id, "err", err)
		return
	}
	m.mu.Lock()
	c, ok := m.contacts[id]
	if ok {
		c.AvatarHash, c.AvatarPath = d.GetAvatarHash(), path
		m.contacts[id] = c
	}
	m.mu.Unlock()
	if ok {
		_ = m.store.PutContact(c)
		m.notifyFriend(id)
	}
}

// BroadcastCard 在本机的名字、头像或服务变了以后告诉连着的好友。
func (m *Manager) BroadcastCard() {
	card := m.selfCard()
	m.mu.RLock()
	var ids []string
	for id := range m.contacts {
		if connected(m.conn[id]) {
			ids = append(ids, id)
		}
	}
	m.mu.RUnlock()
	for _, id := range ids {
		_ = m.p2p.Send(id, &pb.PeerMessage{Payload: &pb.PeerMessage_FriendCard{FriendCard: card}})
	}
}

// ─────────────────────── 加好友 ───────────────────────

// CreateFriendCode 生成好友码：F 加一个配对码。别人兑换后由 OnFriendRequest 推给界面。
func (m *Manager) CreateFriendCode(ctx context.Context) (string, time.Time, []string, error) {
	code, expires, addrs, err := m.createCode(ctx, lan.IntentFriend)
	if err != nil {
		return "", time.Time{}, nil, err
	}
	return "F" + code, expires, addrs, nil
}

// splitCode 认出好友码：F 加 6 位。去掉连字符和空白后是 7 位、以 F 开头的就是好友码
func splitCode(code string) (string, bool) {
	c := pairingcode.Normalize(code)
	if len(c) == pairingcode.Length+1 && c[0] == 'F' {
		return c[1:], true
	}
	return c, false
}

// RedeemFriendCode 兑换好友码，返回对方的名片和会话；用户确认后调 ConfirmFriend。
func (m *Manager) RedeemFriendCode(ctx context.Context, code, address string) (*pb.FriendRequest, error) {
	code, _ = splitCode(code)
	var extra []netip.AddrPort
	if address != "" {
		aps, err := lan.ResolveAddress(ctx, address)
		if err != nil {
			return nil, err
		}
		extra = aps
	}
	lanErr := lan.ErrDisabled
	if m.lan.Running() {
		wait := 3 * time.Second
		if len(extra) > 0 {
			wait = 5 * time.Second
		}
		lctx, cancel := context.WithTimeout(ctx, wait)
		peer, err := m.lan.PairFor(lctx, code, extra, lan.IntentFriend, m.selfCard())
		cancel()
		if err == nil {
			dev := store.Device{ID: peer.ID, Name: peer.Name, Platform: peer.Platform, PublicKey: peer.PublicKey}
			session, err := m.addPendingFor(dev, false, peer.Addrs, lan.IntentFriend, peer.Intent, peer.Card)
			if err != nil {
				return nil, err
			}
			return m.friendRequest(session)
		}
		if errors.Is(err, lan.ErrIsDeviceCode) {
			return nil, ErrIsDeviceCode
		}
		lanErr = err
	}
	if m.client.Connected() {
		session, err := m.redeemViaServerFor(ctx, code, lan.IntentFriend)
		if err != nil {
			if errors.Is(lanErr, lan.ErrWrongCode) || errors.Is(lanErr, lan.ErrTooManyAttempts) || errors.Is(lanErr, lan.ErrCodeClosed) {
				return nil, lanErr
			}
			return nil, err
		}
		return m.awaitIntent(ctx, session)
	}
	if errors.Is(lanErr, lan.ErrDisabled) {
		return nil, ErrNoChannel
	}
	return nil, lanErr
}

// awaitIntent 等经服务器兑换的对方说明用途。不一致或一直没有（旧版本）就放弃这次加好友
func (m *Manager) awaitIntent(ctx context.Context, session string) (*pb.FriendRequest, error) {
	m.mu.RLock()
	p := m.pending[session]
	m.mu.RUnlock()
	if p == nil {
		return nil, ErrSessionUnknown
	}
	select {
	case <-p.intentKnown:
	case <-ctx.Done():
		m.dropPending(session)
		return nil, ctx.Err()
	case <-time.After(intentWait):
		m.dropPending(session)
		return nil, ErrPeerOutdated
	}
	m.mu.RLock()
	err := p.mismatch
	m.mu.RUnlock()
	if err != nil {
		return nil, err
	}
	return m.friendRequest(session)
}

func (m *Manager) dropPending(session string) {
	m.mu.Lock()
	if p, ok := m.pending[session]; ok {
		delete(m.pending, session)
		delete(m.stashed, p.peer.ID)
	}
	m.mu.Unlock()
}

func (m *Manager) friendRequest(session string) (*pb.FriendRequest, error) {
	m.mu.RLock()
	p, ok := m.pending[session]
	m.mu.RUnlock()
	if !ok {
		return nil, ErrSessionUnknown
	}
	card := cleanCard(p.peerCard)
	name := card.GetDeviceName()
	if name == "" {
		name = p.peer.Name
	}
	return &pb.FriendRequest{
		Session:         session,
		DeviceId:        p.peer.ID,
		DisplayName:     card.GetDisplayName(),
		DeviceName:      name,
		Platform:        p.peer.Platform,
		Fingerprint:     deviceid.Fingerprint(p.peer.PublicKey),
		SelfFingerprint: m.identity.Fingerprint(),
	}, nil
}

// exchangeIntent 经服务器兑换配对码后，把本端的用途发给对方，直到收到对方的或会话结束。
func (m *Manager) exchangeIntent(session string) {
	for i := 0; i < int(intentWait/time.Second)+3; i++ {
		m.mu.RLock()
		p, ok := m.pending[session]
		done := ok && p.peerIntent != ""
		m.mu.RUnlock()
		if !ok || done {
			return
		}
		m.sendIntent(p)
		time.Sleep(time.Second)
	}
}

func (m *Manager) sendIntent(p *pendingPair) {
	msg := &pb.PairIntent{Intent: p.intent}
	if p.intent == lan.IntentFriend {
		msg.Card = m.selfCard()
	}
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	_ = m.sendSignal(ctx, p.peer.ID, &pb.SignalMessage{Payload: &pb.SignalMessage_PairIntent{PairIntent: msg}})
}

func (m *Manager) handlePairIntent(from string, in *pb.PairIntent) {
	intent := lan.IntentDevice
	if in.GetIntent() == lan.IntentFriend {
		intent = lan.IntentFriend
	}
	m.mu.Lock()
	var p *pendingPair
	for _, q := range m.pending {
		if q.peer.ID == from {
			p = q
			break
		}
	}
	if p == nil {
		m.mu.Unlock()
		return
	}
	first := p.peerIntent == ""
	p.peerIntent = intent
	if in.GetCard() != nil {
		p.peerCard = cleanCard(in.GetCard())
	}
	m.mu.Unlock()
	if first {
		// 对方可能还没收到本端的，回一条
		go m.sendIntent(p)
	}
	m.evaluateIntent(p)
}

// evaluateIntent 在两边的用途都知道以后：一致的加好友弹出确认框；不一致就作废这次配对。
func (m *Manager) evaluateIntent(p *pendingPair) {
	m.mu.Lock()
	if p.peerIntent == "" || p.intentDone {
		m.mu.Unlock()
		return
	}
	p.intentDone = true
	announce := false
	switch {
	case p.intent == lan.IntentFriend && p.peerIntent == lan.IntentFriend:
		announce = p.initiated
	case p.intent == lan.IntentFriend:
		p.mismatch = ErrIsDeviceCode
		delete(m.pending, p.session)
	case p.peerIntent == lan.IntentFriend:
		// 本端在配对，对方开放的是好友码
		p.mismatch = ErrIsFriendCode
		delete(m.pending, p.session)
		m.mismatched[p.session] = ErrIsFriendCode
	}
	close(p.intentKnown)
	m.mu.Unlock()
	if p.mismatch != nil {
		m.log.Info("配对用途不一致，作废", "peer", p.peer.ID, "本端", p.intent, "对方", p.peerIntent)
	}
	if announce && m.onFriendRequest != nil {
		if req, err := m.friendRequest(p.session); err == nil {
			m.onFriendRequest(req)
		}
	}
}

// ConfirmFriend 是用户在加好友的确认框里点了「添加」或「取消」。两边都添加了才成为好友，
// 结果由 OnFriendChanged（成为好友）或 OnFriendRemoved（对方取消了）推给界面。
func (m *Manager) ConfirmFriend(ctx context.Context, session string, accept bool) error {
	m.mu.Lock()
	p, ok := m.pending[session]
	if ok && p.intent != lan.IntentFriend {
		ok = false
	}
	if ok {
		if accept {
			p.localDecision = 1
		} else {
			delete(m.pending, session)
		}
	}
	m.mu.Unlock()
	if !ok {
		return ErrSessionUnknown
	}
	if !accept {
		m.log.Info("用户没有添加好友", "peer", p.peer.ID)
		go m.sendConfirm(p.peer.ID, false, 3)
		return nil
	}
	if m.finalizeFriend(p) {
		return nil
	}
	go m.confirmLoop(session)
	return nil
}

// confirmLoop 反复告诉对方本端已添加，直到对方也决定了或会话过期。
func (m *Manager) confirmLoop(session string) {
	for {
		m.mu.RLock()
		p, ok := m.pending[session]
		m.mu.RUnlock()
		if !ok || time.Now().After(p.expiresAt) {
			return
		}
		m.sendConfirm(p.peer.ID, true, 1)
		time.Sleep(2 * time.Second)
	}
}

func (m *Manager) sendConfirm(to string, accepted bool, times int) {
	for i := 0; i < times; i++ {
		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		_ = m.sendSignal(ctx, to, &pb.SignalMessage{Payload: &pb.SignalMessage_FriendConfirm{
			FriendConfirm: &pb.FriendConfirm{Accepted: accepted}}})
		cancel()
		if i+1 < times {
			time.Sleep(time.Second)
		}
	}
}

func (m *Manager) handleFriendConfirm(from string, c *pb.FriendConfirm) {
	m.mu.Lock()
	var p *pendingPair
	for _, q := range m.pending {
		if q.peer.ID == from && q.intent == lan.IntentFriend {
			p = q
			break
		}
	}
	_, isFriend := m.contacts[from]
	if p != nil {
		if c.GetAccepted() {
			p.peerDecision = 1
		} else {
			delete(m.pending, p.session)
		}
	}
	m.mu.Unlock()
	switch {
	case p == nil && isFriend && c.GetAccepted():
		// 本端已经成为好友了，对方还没收到本端的确认
		go m.sendConfirm(from, true, 1)
	case p != nil && !c.GetAccepted():
		m.log.Info("对方没有添加好友", "peer", from)
		if m.onFriendRemoved != nil {
			m.onFriendRemoved(from)
		}
	case p != nil:
		if m.finalizeFriend(p) {
			go m.sendConfirm(from, true, 1)
		}
	}
}

// finalizeFriend 在两边都添加了以后保存好友，返回是否保存了。
func (m *Manager) finalizeFriend(p *pendingPair) bool {
	m.mu.Lock()
	if p.localDecision != 1 || p.peerDecision != 1 {
		m.mu.Unlock()
		return false
	}
	if _, still := m.pending[p.session]; !still {
		m.mu.Unlock()
		return false
	}
	delete(m.pending, p.session)
	card := cleanCard(p.peerCard)
	c := store.Contact{
		ID: p.peer.ID, PublicKey: p.peer.PublicKey, DisplayName: card.GetDisplayName(),
		DeviceName: card.GetDeviceName(), Platform: p.peer.Platform, Service: card.GetService(),
		ServerHash: card.GetCustomServerHash(), AddedAt: time.Now(),
	}
	if c.DeviceName == "" {
		c.DeviceName = p.peer.Name
	}
	if card.GetPlatform() != "" {
		c.Platform = card.GetPlatform()
	}
	m.contacts[c.ID] = c
	delete(m.notices, c.ID)
	m.mu.Unlock()
	if err := m.store.PutContact(c); err != nil {
		m.log.Warn("保存好友失败", "device", c.ID, "err", err)
	}
	_ = m.store.DeletePendingNotice(c.ID)
	m.log.Info("已加为好友", "device", c.ID, "name", c.DisplayName)
	if len(p.addrs) > 0 {
		m.lan.Remember(c.ID, p.addrs)
	}
	m.lan.PeersChanged()
	if m.client.Connected() {
		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		_ = m.client.RefreshPaired(ctx)
		cancel()
	}
	m.notifyFriend(c.ID)
	m.replaySignals(c.ID)
	// 连上一次，交换功能声明和名片、头像；空闲后自动断开
	go m.ConnectFriend(c.ID)
	return true
}

// ─────────────────────── 好友列表 ───────────────────────

func (m *Manager) Friends() []*pb.Friend {
	m.mu.RLock()
	defer m.mu.RUnlock()
	out := make([]*pb.Friend, 0, len(m.contacts))
	for _, c := range m.contacts {
		out = append(out, m.friendLocked(c))
	}
	slices.SortFunc(out, func(a, b *pb.Friend) int { return int(a.GetAddedAtUnix() - b.GetAddedAtUnix()) })
	return out
}

func (m *Manager) Friend(id string) (*pb.Friend, bool) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	c, ok := m.contacts[id]
	if !ok {
		return nil, false
	}
	return m.friendLocked(c), true
}

// FriendContact 返回好友的存储记录（隔空传送取名字用）
func (m *Manager) FriendContact(id string) (store.Contact, bool) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	c, ok := m.contacts[id]
	return c, ok
}

func (m *Manager) friendLocked(c store.Contact) *pb.Friend {
	online := m.isOnlineLocked(c.ID)
	conn := pb.ConnectionKind_CONNECTION_KIND_OFFLINE
	if online {
		conn = m.conn[c.ID].Proto()
	}
	f, declared := m.features[c.ID]
	var last int64
	if !c.LastActivity.IsZero() {
		last = c.LastActivity.Unix()
	}
	return &pb.Friend{
		Id:               c.ID,
		DisplayName:      c.DisplayName,
		DeviceName:       c.DeviceName,
		Platform:         c.Platform,
		Online:           online,
		Connection:       conn,
		LanReachable:     online && m.lan.Reachable(c.ID),
		FeaturesKnown:    declared || m.legacy[c.ID],
		ReceivesFiles:    f[FeatureSendAsk] && f[FeatureSendFiles],
		ReceiveDisabled:  f[FeatureSendFilesOff],
		AppVersion:       m.peerVersion[c.ID],
		AutoAccept:       c.AutoAccept,
		AddedAtUnix:      c.AddedAt.Unix(),
		LastActivityUnix: last,
		Reachability:     m.reachabilityLocked(c, online),
		HasAvatar:        c.AvatarPath != "",
		AvatarHash:       c.AvatarHash,
		Fingerprint:      deviceid.Fingerprint(c.PublicKey),
	}
}

// reachabilityLocked 是好友不在线时连不上的可能原因，见 design/friends-send.md 第 9.2 节。
// 在线、或者两边用的是同一种服务（对方只是没开机）时为空
func (m *Manager) reachabilityLocked(c store.Contact, online bool) string {
	if online {
		return ""
	}
	cfg := m.loadConfig()
	mine := serviceOf(cfg)
	switch {
	case mine == "lan":
		return "self_no_service"
	case c.Service == "lan":
		return "peer_no_service"
	case c.Service == "":
		return "" // 还没收到过对方的名片
	case mine != c.Service:
		return "different_server"
	case mine == "custom" && !bytes.Equal(ServiceHash(cfg.EffectiveSignalingURL()), c.ServerHash):
		return "different_server"
	}
	return ""
}

func serviceOf(cfg config.Config) string {
	switch {
	case cfg.Official():
		return "official"
	case cfg.EffectiveSignalingURL() != "":
		return "custom"
	}
	return "lan"
}

// SetFriendAutoAccept 打开或关掉自动接收某个好友的文件
func (m *Manager) SetFriendAutoAccept(id string, auto bool) (*pb.Friend, error) {
	if err := m.store.SetContactAutoAccept(id, auto); err != nil {
		if errors.Is(err, store.ErrNoContact) {
			return nil, ErrNotFriend
		}
		return nil, err
	}
	m.mu.Lock()
	c, ok := m.contacts[id]
	if ok {
		c.AutoAccept = auto
		m.contacts[id] = c
	}
	m.mu.Unlock()
	m.notifyFriend(id)
	f, _ := m.Friend(id)
	return f, nil
}

// TouchFriend 记下和好友最近一次传输的时间
func (m *Manager) TouchFriend(id string) {
	now := time.Now()
	m.mu.Lock()
	c, ok := m.contacts[id]
	if ok {
		c.LastActivity = now
		m.contacts[id] = c
	}
	m.mu.Unlock()
	if ok {
		_ = m.store.TouchContact(id, now)
		m.notifyFriend(id)
	}
}

func (m *Manager) notifyFriend(id string) {
	if m.onFriendChanged == nil {
		return
	}
	if f, ok := m.Friend(id); ok {
		m.onFriendChanged(f)
	}
}

// ─────────────────────── 删除好友 ───────────────────────

// RemoveFriend 删除好友：两边都删。对方不在线时记下来，连上再告诉它（最多 30 天）。
func (m *Manager) RemoveFriend(ctx context.Context, id string) error {
	m.mu.Lock()
	c, ok := m.contacts[id]
	if ok {
		delete(m.contacts, id)
		delete(m.features, id)
		m.notices[id] = c.PublicKey
	}
	m.mu.Unlock()
	if !ok {
		return ErrNotFriend
	}
	if err := m.store.DeleteContact(id); err != nil {
		return err
	}
	_ = m.store.PutPendingNotice(id, c.PublicKey, time.Now())
	m.p2p.Disconnect(id)
	m.mu.Lock()
	delete(m.conn, id)
	m.mu.Unlock()
	m.lan.PeersChanged()
	if m.client.Connected() {
		_ = m.client.RefreshPaired(ctx)
	}
	m.log.Info("已删除好友", "device", id)
	if m.onFriendRemoved != nil {
		m.onFriendRemoved(id)
	}
	go m.noticeLoop(id)
	return nil
}

// noticeLoop 删除好友后的头 15 秒里每秒补发一次，直到收到回执；之后靠对方上线时和每 30 秒的巡检补发
func (m *Manager) noticeLoop(id string) {
	for i := 0; i < 15; i++ {
		m.mu.RLock()
		_, pending := m.notices[id]
		m.mu.RUnlock()
		if !pending {
			return
		}
		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		_ = m.sendSignal(ctx, id, &pb.SignalMessage{Payload: &pb.SignalMessage_FriendRemove{
			FriendRemove: &pb.FriendRemove{AtUnix: time.Now().Unix()}}})
		cancel()
		time.Sleep(time.Second)
	}
}

// sendNotices 给还没收到删除通知、此刻找得到的对方补发一次
func (m *Manager) sendNotices() {
	// 找不到对方时 sendSignal 直接返回错误，不必先判断在不在线
	m.mu.RLock()
	var ids []string
	for id := range m.notices {
		ids = append(ids, id)
	}
	m.mu.RUnlock()
	for _, id := range ids {
		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		_ = m.sendSignal(ctx, id, &pb.SignalMessage{Payload: &pb.SignalMessage_FriendRemove{
			FriendRemove: &pb.FriendRemove{AtUnix: time.Now().Unix()}}})
		cancel()
	}
}

func (m *Manager) handleFriendRemove(from string, r *pb.FriendRemove) {
	if r.GetAck() {
		m.mu.Lock()
		_, had := m.notices[from]
		delete(m.notices, from)
		m.mu.Unlock()
		if had {
			_ = m.store.DeletePendingNotice(from)
			m.lan.PeersChanged()
			m.log.Info("对方已收到删除好友的通知", "device", from)
		}
		return
	}
	m.mu.Lock()
	_, isFriend := m.contacts[from]
	if isFriend {
		delete(m.contacts, from)
		delete(m.features, from)
	}
	m.mu.Unlock()
	if isFriend {
		_ = m.store.DeleteContact(from)
		m.p2p.Disconnect(from)
		m.mu.Lock()
		delete(m.conn, from)
		m.mu.Unlock()
		m.lan.PeersChanged()
		m.log.Info("对方删除了好友", "device", from)
		if m.onFriendRemoved != nil {
			m.onFriendRemoved(from)
		}
	}
	// 回执：本端还认得对方的公钥（签名已经验过），对方收到就不再补发
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	_ = m.sendSignal(ctx, from, &pb.SignalMessage{Payload: &pb.SignalMessage_FriendRemove{
		FriendRemove: &pb.FriendRemove{AtUnix: time.Now().Unix(), Ack: true}}})
}

// ─────────────────────── 连接 ───────────────────────

// ConnectFriend 建立与好友（或陌生设备）的连接：发文件、交换名片时用。
// 本端是应答方时请对方来连（RetryDirect 信令）。
func (m *Manager) ConnectFriend(id string) {
	if m.Role(id) == "" {
		return
	}
	m.touch(id)
	if st := m.p2p.State(id); st != p2p.StateOffline {
		return
	}
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()
	var err error
	if m.identity.DeviceID < id {
		err = m.p2p.Connect(ctx, id)
	} else {
		err = m.p2p.RetryDirect(ctx, id)
	}
	if err != nil {
		m.log.Debug("连接好友失败", "device", id, "err", err)
	}
}

// dropIdleOthers 断开空闲的好友与陌生设备：只在要发文件时连着。
func (m *Manager) dropIdleOthers() {
	now := time.Now()
	m.mu.RLock()
	var idle []string
	for id, st := range m.conn {
		role := m.roleLocked(id)
		if role == RoleSelf || !connected(st) {
			continue
		}
		if now.Sub(m.lastUse[id]) > friendIdle && (m.inUse == nil || !m.inUse(id)) {
			idle = append(idle, id)
		}
	}
	m.mu.RUnlock()
	for _, id := range idle {
		m.log.Info("好友的连接空闲，断开", "device", id)
		m.p2p.Disconnect(id)
		m.mu.Lock()
		delete(m.conn, id)
		m.mu.Unlock()
		m.notifyFriend(id)
	}
}

// loadContacts 在启动时读回好友和待补发的删除通知。
func (m *Manager) loadContacts() error {
	contacts, err := m.store.ListContacts()
	if err != nil {
		return fmt.Errorf("读取好友: %w", err)
	}
	for _, c := range contacts {
		m.contacts[c.ID] = c
		if len(c.Features) > 0 {
			m.features[c.ID] = featureSet(c.Features)
			m.peerVersion[c.ID] = c.AppVersion
		}
	}
	notices, err := m.store.PendingNotices(time.Now().Add(-noticeKeep))
	if err != nil {
		return fmt.Errorf("读取删除好友的通知: %w", err)
	}
	for _, n := range notices {
		m.notices[n.ID] = n.PublicKey
	}
	return nil
}
