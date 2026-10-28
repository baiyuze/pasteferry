// Package webshare 是手机网页传输：手机扫电脑上的二维码，用浏览器和电脑互传文字、照片、文件，
// 看电脑上的复制记录。设计见 design/phone-sync.md 第 2 节。
//
// 网页由后台服务直接提供，只在局域网里用，走 http。内容在网页里用 secretbox 加密，
// 同一网络里旁听看不到内容；防不住有人主动篡改网页（2.4.3 节），界面上照实说明。
//
// 一张二维码只登记一台手机：二维码里是「邀请」，手机第一次连上时换成它专属的会话 ID 与密钥，
// 邀请随即作废。网页把新的会话写回地址栏的 # 后面，添加到主屏幕时一起存下来。
package webshare

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"net"
	"net/http"
	"net/netip"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"sync"
	"time"
	"unicode"
	"unicode/utf8"

	"github.com/baiyuze/pasteferry/client-core/internal/clipboard"
	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/qrcode"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

const (
	// DefaultPort 是网页的固定端口。被占用时退回随机端口，以前收藏的网址就打不开了
	DefaultPort = 8790
	// inviteTTL 是一张二维码没被扫时的有效期
	inviteTTL = 10 * time.Minute
	// sessionIdle 内没用过的手机自动移除
	sessionIdle = 30 * 24 * time.Hour
	// touchEvery 内同一台手机只更新一次最后使用时间，省得每个请求都写库
	touchEvery = time.Minute
	maxNameLen = 40
)

// Engine 是网页传输要用到的同步引擎能力，见 sync.Engine。
type Engine interface {
	SubmitLocal(ctx context.Context, content clipboard.Content, via string, applyLocal bool) (store.Clip, error)
	LocalPaths(clipID string) ([]string, error)
	ImagePreview(ctx context.Context, clipID string, index int) (path, name string, count int, err error)
	// SearchHistory 按文字与文件名搜索复制记录，支持拼音，与桌面上的搜索框相同
	SearchHistory(query string, limit int, f store.Filter) ([]store.Clip, error)
	// NoteOwnCopy 把网页刚做的这次复制记为自发写入，不再记成一条新记录
	NoteOwnCopy(ctx context.Context) error
}

type Options struct {
	Logger     *slog.Logger
	Store      *store.Store
	Engine     Engine
	LoadConfig func() config.Config
	// DeviceName 是本机的名字，网页顶部显示「已连接 ×××」
	DeviceName func() string
	// Subscribe 订阅后台服务的事件（rpc.Hub.Subscribe），新记录据此推给网页
	Subscribe func() (<-chan *pb.Event, func())
	// Thumbnail 把一张能解码的图片缩成缩略图，返回缩略图的路径，失败时返回空串（profile.Profile.Thumbnail）
	Thumbnail func(path string) string
	// LocalAddrs 是本机的局域网地址，默认路由所在的网卡排第一（transport/lan.LocalAddrs）
	LocalAddrs func() []netip.Addr
	// Protect / Unprotect 加解密落盘的会话密钥（identity.ProtectSecret），为 nil 时原样存
	Protect   func([]byte) ([]byte, error)
	Unprotect func([]byte) ([]byte, error)
	// OnChanged 在开关、监听状态、登记的手机变化时调用，界面据此刷新
	OnChanged func(*pb.WebShareStatus)
	// WorkDir 放上传到一半的文件与打包下载的 zip，退出时清空
	WorkDir string
	// Port 为 0 时用 DefaultPort；测试里用 -1 表示随机端口
	Port int
	Now  func() time.Time
}

type Server struct {
	opts   Options
	log    *slog.Logger
	guard  *replayGuard
	limits *failLimiter

	mu        sync.Mutex
	enabled   bool
	listener  net.Listener
	httpSrv   *http.Server
	port      int
	fallback  bool
	listenErr string
	invites   map[string]*invite
	sessions  map[string]*session // 读过的会话缓存，键是会话 ID
	stopBG    context.CancelFunc

	uploads *uploads
	zips    *zipCache
	events  *broadcaster
	thumbs  thumbCache
}

type invite struct {
	id      string
	key     key
	expires time.Time
}

type session struct {
	id      string
	name    string
	key     key
	touched time.Time
}

func New(opts Options) *Server {
	if opts.Logger == nil {
		opts.Logger = slog.Default()
	}
	if opts.Now == nil {
		opts.Now = time.Now
	}
	if opts.Port == 0 {
		opts.Port = DefaultPort
	}
	if opts.Protect == nil {
		opts.Protect = func(b []byte) ([]byte, error) { return b, nil }
	}
	if opts.Unprotect == nil {
		opts.Unprotect = func(b []byte) ([]byte, error) { return b, nil }
	}
	s := &Server{
		opts:     opts,
		log:      opts.Logger.With("component", "webshare"),
		guard:    newReplayGuard(),
		limits:   newFailLimiter(),
		invites:  make(map[string]*invite),
		sessions: make(map[string]*session),
	}
	s.uploads = newUploads(filepath.Join(opts.WorkDir, "uploads"))
	s.zips = newZipCache(filepath.Join(opts.WorkDir, "zips"))
	s.events = newBroadcaster()
	return s
}

// SetEnabled 打开或关闭网页传输。打开时开始监听端口，关闭时停止监听、断开所有网页；
// 已登记的手机保留，重新打开后照常能用。
func (s *Server) SetEnabled(on bool) {
	s.mu.Lock()
	if on == s.enabled && (on == (s.listener != nil) || s.listenErr != "") {
		s.mu.Unlock()
		return
	}
	s.enabled = on
	if on {
		s.startLocked()
	} else {
		s.stopLocked()
	}
	s.mu.Unlock()
	s.changed("")
}

func (s *Server) startLocked() {
	if s.listener != nil {
		return
	}
	s.listenErr, s.fallback = "", false
	port := s.opts.Port
	if port < 0 {
		port = 0
	}
	l, err := net.Listen("tcp", ":"+strconv.Itoa(port))
	if err != nil && port != 0 {
		s.log.Info("网页传输的固定端口被占用，改用随机端口", "port", port, "err", err)
		l, err = net.Listen("tcp", ":0")
		s.fallback = err == nil
	}
	if err != nil {
		s.listenErr = err.Error()
		s.log.Warn("网页传输没能开始监听", "err", err)
		return
	}
	s.listener = l
	s.port = l.Addr().(*net.TCPAddr).Port
	s.httpSrv = &http.Server{
		Handler:           s.Handler(),
		ReadHeaderTimeout: 10 * time.Second,
		IdleTimeout:       2 * time.Minute,
		ErrorLog:          slog.NewLogLogger(s.log.Handler(), slog.LevelDebug),
	}
	ctx, cancel := context.WithCancel(context.Background())
	s.stopBG = cancel
	go func(srv *http.Server, l net.Listener) {
		if err := srv.Serve(l); err != nil && !errors.Is(err, http.ErrServerClosed) {
			s.log.Warn("网页传输停止服务", "err", err)
		}
	}(s.httpSrv, l)
	go s.background(ctx)
	s.log.Info("网页传输开始监听", "port", s.port, "fallback", s.fallback)
}

func (s *Server) stopLocked() {
	if s.stopBG != nil {
		s.stopBG()
		s.stopBG = nil
	}
	if s.httpSrv != nil {
		_ = s.httpSrv.Close() // 事件流是长连接，不等它们结束
		s.httpSrv = nil
	}
	s.listener = nil
	s.port = 0
	s.fallback = false
	s.listenErr = ""
	s.invites = make(map[string]*invite)
	s.events.closeAll()
	s.uploads.clear()
	s.zips.clear()
}

// Close 在后台服务退出时调用。
func (s *Server) Close() {
	s.mu.Lock()
	s.stopLocked()
	s.mu.Unlock()
	_ = os.RemoveAll(s.opts.WorkDir)
}

// background 在监听期间运行：把新记录推给网页，定期清理过期的东西。
func (s *Server) background(ctx context.Context) {
	if s.opts.Subscribe != nil {
		ch, unsubscribe := s.opts.Subscribe()
		defer unsubscribe()
		go s.forwardEvents(ctx, ch)
	}
	s.expireSessions()
	t := time.NewTicker(time.Minute)
	defer t.Stop()
	for {
		select {
		case <-ctx.Done():
			return
		case <-t.C:
			now := s.opts.Now()
			s.mu.Lock()
			expired := false
			for id, inv := range s.invites {
				if now.After(inv.expires) {
					delete(s.invites, id)
					expired = true
				}
			}
			s.mu.Unlock()
			if expired {
				s.changed("")
			}
			s.uploads.expire(now)
			s.zips.expire(now)
			if now.Minute() == 0 {
				s.expireSessions()
			}
		}
	}
}

func (s *Server) expireSessions() {
	ids, err := s.opts.Store.RemoveWebSessionsIdleSince(s.opts.Now().Add(-sessionIdle))
	if err != nil {
		s.log.Warn("清理不用的手机失败", "err", err)
		return
	}
	if len(ids) == 0 {
		return
	}
	s.mu.Lock()
	for _, id := range ids {
		delete(s.sessions, id)
	}
	s.mu.Unlock()
	for _, id := range ids {
		s.events.closeSession(id)
	}
	s.changed("")
}

// Status 是界面上显示的状态。
func (s *Server) Status() *pb.WebShareStatus {
	s.mu.Lock()
	st := &pb.WebShareStatus{
		Enabled:      s.enabled,
		Listening:    s.listener != nil,
		Port:         int32(s.port),
		PortFallback: s.fallback,
		Error:        s.listenErr,
	}
	s.mu.Unlock()
	for _, a := range s.addrs() {
		st.Addresses = append(st.Addresses, a.String())
	}
	list, err := s.opts.Store.WebSessions()
	if err != nil {
		s.log.Warn("读取登记的手机失败", "err", err)
	}
	for _, w := range list {
		st.Sessions = append(st.Sessions, &pb.WebSession{
			Id: w.ID, Name: w.Name, CreatedAtUnix: w.CreatedAt.Unix(), LastSeenUnix: w.LastSeen.Unix(),
		})
	}
	return st
}

func (s *Server) changed(inviteUsed string) {
	if s.opts.OnChanged == nil {
		return
	}
	st := s.Status()
	st.InviteUsed = inviteUsed
	s.opts.OnChanged(st)
}

func (s *Server) addrs() []netip.Addr {
	if s.opts.LocalAddrs == nil {
		return nil
	}
	return s.opts.LocalAddrs()
}

// NewInvite 生成一张新的二维码。address 为空时用默认地址。
func (s *Server) NewInvite(address string) (*pb.WebShareInvite, error) {
	host := address
	if host == "" {
		if list := s.addrs(); len(list) > 0 {
			host = list[0].String()
		}
	}
	ip, err := netip.ParseAddr(host)
	if err != nil {
		return nil, fmt.Errorf("没有可用的局域网地址")
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.listener == nil {
		return nil, errors.New("网页传输没有打开")
	}
	now := s.opts.Now()
	inv := &invite{id: randomID(16), key: newKey(), expires: now.Add(inviteTTL)}
	s.invites[inv.id] = inv
	url := fmt.Sprintf("http://%s/#i=%s&k=%s", netip.AddrPortFrom(ip, uint16(s.port)), inv.id, b64(inv.key[:]))
	size, modules, err := qrcode.Encode(url)
	if err != nil {
		return nil, err
	}
	return &pb.WebShareInvite{Id: inv.id, Url: url, ExpiresAtUnix: inv.expires.Unix(), QrSize: int32(size), QrModules: modules}, nil
}

// CloseInvite 在二维码窗口关闭时作废还没被用过的二维码。
func (s *Server) CloseInvite(id string) {
	s.mu.Lock()
	delete(s.invites, id)
	s.mu.Unlock()
}

// RemoveSession 移除一台手机，它的网页立即失效。
func (s *Server) RemoveSession(id string) error {
	if err := s.opts.Store.RemoveWebSession(id); err != nil {
		return err
	}
	s.mu.Lock()
	delete(s.sessions, id)
	s.mu.Unlock()
	s.events.closeSession(id)
	s.uploads.dropSession(id)
	s.changed("")
	return nil
}

// claim 把一张二维码换成一台手机专属的会话，二维码随即作废。
func (s *Server) claim(inv *invite, name string) (*session, error) {
	s.mu.Lock()
	if cur, ok := s.invites[inv.id]; !ok || cur != inv {
		s.mu.Unlock()
		return nil, errInviteUsed
	}
	delete(s.invites, inv.id)
	s.mu.Unlock()

	now := s.opts.Now()
	sess := &session{id: randomID(16), name: cleanName(name), key: newKey(), touched: now}
	sealed, err := s.opts.Protect(sess.key[:])
	if err != nil {
		return nil, err
	}
	if err := s.opts.Store.PutWebSession(store.WebSession{
		ID: sess.id, Name: sess.name, Key: sealed, CreatedAt: now, LastSeen: now,
	}); err != nil {
		return nil, err
	}
	s.mu.Lock()
	s.sessions[sess.id] = sess
	s.mu.Unlock()
	s.log.Info("网页传输登记了一台手机", "session", sess.id, "name", sess.name)
	s.changed(inv.id)
	return sess, nil
}

var (
	errInviteUsed     = errors.New("二维码已经用过或过期了")
	errUnknownSession = errors.New("这台手机没有登记，或已被移除")
)

func (s *Server) inviteByID(id string) (*invite, bool) {
	s.mu.Lock()
	defer s.mu.Unlock()
	inv, ok := s.invites[id]
	if ok && s.opts.Now().After(inv.expires) {
		delete(s.invites, id)
		return nil, false
	}
	return inv, ok
}

func (s *Server) sessionByID(id string) (*session, error) {
	s.mu.Lock()
	sess, ok := s.sessions[id]
	s.mu.Unlock()
	if ok {
		return sess, nil
	}
	w, err := s.opts.Store.WebSession(id)
	if errors.Is(err, store.ErrNotFound) {
		return nil, errUnknownSession
	}
	if err != nil {
		return nil, err
	}
	raw, err := s.opts.Unprotect(w.Key)
	if err != nil {
		return nil, err
	}
	k, ok := keyFromBytes(raw)
	if !ok {
		return nil, errUnknownSession
	}
	sess = &session{id: w.ID, name: w.Name, key: k, touched: w.LastSeen}
	s.mu.Lock()
	if cur, ok := s.sessions[id]; ok {
		sess = cur
	} else {
		s.sessions[id] = sess
	}
	s.mu.Unlock()
	return sess, nil
}

// touch 记下手机刚用过，最多每分钟写一次库。
func (s *Server) touch(sess *session) {
	now := s.opts.Now()
	s.mu.Lock()
	stale := now.Sub(sess.touched) >= touchEvery
	if stale {
		sess.touched = now
	}
	s.mu.Unlock()
	if stale {
		if err := s.opts.Store.TouchWebSession(sess.id, now); err != nil {
			s.log.Debug("记录手机使用时间失败", "err", err)
		}
	}
}

func (s *Server) rename(sess *session, name string) {
	name = cleanName(name)
	s.mu.Lock()
	same := name == sess.name
	sess.name = name
	s.mu.Unlock()
	if same {
		return
	}
	w, err := s.opts.Store.WebSession(sess.id)
	if err != nil {
		return
	}
	w.Name = name
	if err := s.opts.Store.PutWebSession(w); err == nil {
		s.changed("")
	}
}

func (s *Server) sessionName(sess *session) string {
	s.mu.Lock()
	defer s.mu.Unlock()
	return sess.name
}

// cleanName 整理手机起的名字：去掉控制字符和首尾空白，限制长度，空的叫「手机」。
func cleanName(name string) string {
	var b strings.Builder
	n := 0
	for _, r := range strings.TrimSpace(name) {
		if unicode.IsControl(r) || r == utf8.RuneError {
			continue
		}
		b.WriteRune(r)
		if n++; n >= maxNameLen {
			break
		}
	}
	if s := strings.TrimSpace(b.String()); s != "" {
		return s
	}
	return "手机"
}

// ── 来源地址与限速 ──

// privateNets 是网页传输接受的来源：局域网、Tailscale、链路本地，以及本机自己（测试与在电脑上打开）。
var privateNets = []netip.Prefix{
	netip.MustParsePrefix("10.0.0.0/8"),
	netip.MustParsePrefix("172.16.0.0/12"),
	netip.MustParsePrefix("192.168.0.0/16"),
	netip.MustParsePrefix("100.64.0.0/10"),
	netip.MustParsePrefix("169.254.0.0/16"),
	netip.MustParsePrefix("127.0.0.0/8"),
	netip.MustParsePrefix("fc00::/7"),
	netip.MustParsePrefix("fe80::/10"),
	netip.MustParsePrefix("::1/128"),
}

func remoteIP(r *http.Request) (netip.Addr, bool) {
	ap, err := netip.ParseAddrPort(r.RemoteAddr)
	if err != nil {
		return netip.Addr{}, false
	}
	return ap.Addr().Unmap().WithZone(""), true
}

func allowedSource(ip netip.Addr) bool {
	for _, p := range privateNets {
		if p.Contains(ip) {
			return true
		}
	}
	return false
}

// failLimiter 挡住乱猜：同一个来源一分钟内解密失败 20 次，之后五分钟一律拒绝。
type failLimiter struct {
	mu   sync.Mutex
	byIP map[netip.Addr]*failCount
}

type failCount struct {
	n       int
	window  time.Time
	blocked time.Time
}

func newFailLimiter() *failLimiter { return &failLimiter{byIP: make(map[netip.Addr]*failCount)} }

func (l *failLimiter) blocked(ip netip.Addr, now time.Time) bool {
	l.mu.Lock()
	defer l.mu.Unlock()
	c := l.byIP[ip]
	return c != nil && now.Before(c.blocked)
}

func (l *failLimiter) fail(ip netip.Addr, now time.Time) {
	l.mu.Lock()
	defer l.mu.Unlock()
	if len(l.byIP) > 1024 {
		l.byIP = make(map[netip.Addr]*failCount)
	}
	c := l.byIP[ip]
	if c == nil || now.Sub(c.window) > time.Minute {
		c = &failCount{window: now}
		l.byIP[ip] = c
	}
	c.n++
	if c.n >= 20 {
		c.blocked = now.Add(5 * time.Minute)
	}
}
