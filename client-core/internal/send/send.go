// Package send 是隔空传送：把文件或文件夹直接发给某一台已配对的设备，见 design/send-files.md。
//
// 它与复制同步（sync 包）共用设备之间的加密连接，但各管各的：收到的文件存到用户的保存位置，
// 不进复制记录，也不碰剪贴板。一次发的一批文件叫一个传输（transfer），断了能从断点继续。
//
// 一个传输的过程：
//
//	发送方 SendOffer → 接收方检查后 SendAnswer（接受并给出续传位置，或回绝）→
//	发送方新开数据通道 "send:<id>:<attempt>"，发帧流（pack/frames.go）→
//	接收方写进临时目录、逐个校验，全部收完后移到保存位置，回 SendResult。
package send

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"errors"
	"io"
	"log/slog"
	"strings"
	"sync"
	"time"

	"github.com/pion/webrtc/v4"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// 对外接口返回的错误。rpc 层按它们给出状态码，界面按代码显示文案。
var (
	ErrUnknownDevice    = errors.New("unknown_device")
	ErrOffline          = errors.New("offline")
	ErrUnsupported      = errors.New("unsupported")
	ErrPeerDisabled     = errors.New("disabled")
	ErrNeedRelayConsent = errors.New("relay")
	ErrNoPaths          = errors.New("no_paths")
	ErrNotFound         = errors.New("not_found")
	ErrNotResumable     = errors.New("not_resumable")
)

const (
	// 等对方应答 SendOffer、等对方打开数据流的时间
	defaultAnswerTimeout = 30 * time.Second
	// 发完以后等对方回 SendResult 的时间：最后一个文件校验完、移到保存位置要一会儿
	resultTimeout = 2 * time.Minute
	// 连接断了以后多久之内重新连上会自动续传；超过就等用户点「继续」
	autoResumeWindow = 30 * time.Minute
	// 接收方没收完的部分保留多久
	partialTTL = 7 * 24 * time.Hour
	// 传输记录保留多久、每类最多多少条
	recordTTL  = 30 * 24 * time.Hour
	recordKeep = 500
	// 进度事件的节流间隔；当前文件名换得更慢一点，文件很小时不至于闪得看不清
	progressInterval    = 200 * time.Millisecond
	currentFileInterval = 500 * time.Millisecond
	// 接收方隔多久把写到哪里记进数据库：断了以后从这里接着收
	checkpointBytes    = 8 << 20
	checkpointInterval = 2 * time.Second
	// 要求剩余空间比要收的内容多出这么多，给系统留点余地
	spaceReserve = 200 << 20
	// 传输开始后多久估算一次剩余时间，超过 bigTransfer 才发「正在发来」的通知
	startNoticeDelay = 3 * time.Second
	bigTransfer      = 30 * time.Second

	streamPrefix = "send:"
	partialDir   = ".pasteferry-partial"
)

// Peer 是某台设备此刻的状态，由 peers.Manager 提供。
type Peer struct {
	Known     bool // 已配对
	Name      string
	Online    bool
	Connected bool // P2P 连接已建立
	Relayed   bool // 连接经中转
	Supported bool // 对方声明能接收隔空传送
	Disabled  bool // 对方关闭了接收
}

// NoticeKind 是要发给用户的系统通知。
type NoticeKind int

const (
	NoticeIncoming NoticeKind = iota // 较大的传输开始了
	NoticeReceived                   // 收完了
	NoticeFailed                     // 没收完
)

type Options struct {
	Logger     *slog.Logger
	Store      *store.Store
	LoadConfig func() config.Config

	Send       func(deviceID string, msg *pb.PeerMessage) error
	OpenStream func(deviceID, label string) (*webrtc.DataChannel, error)
	Peer       func(deviceID string) Peer
	// RelayQuotaExhausted 表示官方服务今天的中转额度用完了（经官方中转的传输断了时据此暂停）
	RelayQuotaExhausted func() bool
	// Inhibit 阻止系统空闲睡眠，返回解除的函数。有传输在进行时持有
	Inhibit func() (release func())

	// 局域网快速通道（2.5.1），两个都可以为空，为空时只用数据通道。
	// ListenLAN 为对方这次发来的一批开一个临时 TCP 端口，返回给对方拨号的地址和等连接的函数
	// （accept 只接一次，ctx 结束时放弃）；对方不支持、不是局域网直连或开不了端口时 ok 为 false。
	ListenLAN func(deviceID string) (addr string, accept func(ctx context.Context) (io.ReadCloser, string, error), ok bool)
	// DialLAN 连到对方给的地址，并写上数据流标签
	DialLAN func(ctx context.Context, deviceID, addr, label string) (io.WriteCloser, error)

	OnChange  func(*pb.Transfer)
	OnRemoved func(id string)
	OnNotice  func(NoticeKind, *pb.Transfer)

	// 测试用
	AnswerTimeout time.Duration
	ResultTimeout time.Duration
	Now           func() time.Time
}

type Engine struct {
	opts Options
	log  *slog.Logger
	ctx  context.Context
	stop context.CancelFunc
	wg   sync.WaitGroup

	mu sync.Mutex
	// 进行中的发送与接收，按传输 ID
	out map[string]*outgoing
	in  map[string]*incoming
	// 每台设备一个发送工作者，按顺序一批一批地发
	workers map[string]bool
	// 正在传输的批次，非空时阻止系统睡眠
	busy    map[string]bool
	release func()
	// 进度事件的节流
	progress map[string]*meter
}

func New(opts Options) *Engine {
	log := opts.Logger
	if log == nil {
		log = slog.Default()
	}
	if opts.AnswerTimeout <= 0 {
		opts.AnswerTimeout = defaultAnswerTimeout
	}
	if opts.ResultTimeout <= 0 {
		opts.ResultTimeout = resultTimeout
	}
	if opts.Now == nil {
		opts.Now = time.Now
	}
	ctx, stop := context.WithCancel(context.Background())
	return &Engine{
		opts: opts, log: log.With("模块", "隔空传送"), ctx: ctx, stop: stop,
		out: map[string]*outgoing{}, in: map[string]*incoming{},
		workers: map[string]bool{}, busy: map[string]bool{}, progress: map[string]*meter{},
	}
}

// Start 恢复上次退出时没结束的传输，并开始定期清理。
func (e *Engine) Start() {
	e.recover()
	e.wg.Add(1)
	go func() {
		defer e.wg.Done()
		e.janitor()
		t := time.NewTicker(time.Hour)
		defer t.Stop()
		for {
			select {
			case <-e.ctx.Done():
				return
			case <-t.C:
				e.janitor()
			}
		}
	}()
}

// Close 停下所有传输。进行中的会在下次启动时标为中断，之后可以续传。
func (e *Engine) Close() {
	e.stop()
	e.mu.Lock()
	for _, o := range e.out {
		o.abort(errShutdown)
	}
	for _, in := range e.in {
		in.abort(errShutdown)
	}
	e.mu.Unlock()
	e.wg.Wait()
	e.mu.Lock()
	if e.release != nil {
		e.release()
		e.release = nil
	}
	e.mu.Unlock()
}

var errShutdown = errors.New("后台服务正在退出")

// recover 处理上次退出时没结束的传输：统计中的重新统计，传输中的标为中断。
func (e *Engine) recover() {
	list, err := e.opts.Store.UnfinishedTransfers()
	if err != nil {
		e.log.Warn("读取未完成的传输失败", "err", err)
		return
	}
	now := e.opts.Now()
	for _, t := range list {
		switch {
		case t.Direction == store.Outgoing && t.Status == store.TransferScanning:
			e.wg.Add(1)
			go func() {
				defer e.wg.Done()
				e.scan(t)
			}()
		case t.Direction == store.Outgoing && t.Status == store.TransferQueued:
			// 等对方连上（PeerReady）再发
		case t.Status == store.TransferWaiting || t.Status == store.TransferActive:
			t.Status = store.TransferInterrupted
			t.UpdatedAt = now
			e.save(t)
		}
	}
}

// PeerReady 在与某台设备的连接建立或恢复时调用：排队的开始发，最近中断的自动续传。
func (e *Engine) PeerReady(deviceID string) {
	list, err := e.opts.Store.UnfinishedTransfers()
	if err != nil {
		return
	}
	now := e.opts.Now()
	kick := false
	for _, t := range list {
		if t.Direction != store.Outgoing || t.DeviceID != deviceID {
			continue
		}
		switch t.Status {
		case store.TransferQueued:
			kick = true
		case store.TransferPaused:
			t.Status, t.Error = store.TransferQueued, ""
			e.save(t)
			kick = true
		case store.TransferInterrupted:
			if now.Sub(t.UpdatedAt) <= autoResumeWindow {
				t.Status, t.Error = store.TransferQueued, ""
				e.save(t)
				kick = true
			}
		}
	}
	if kick {
		e.kick(deviceID)
	}
}

// HandleMessage 处理对端发来的隔空传送控制消息，返回 false 表示不是隔空传送的消息。
func (e *Engine) HandleMessage(from string, msg *pb.PeerMessage) bool {
	switch m := msg.GetPayload().(type) {
	case *pb.PeerMessage_SendOffer:
		go e.handleOffer(from, m.SendOffer)
	case *pb.PeerMessage_SendAnswer:
		e.handleAnswer(from, m.SendAnswer)
	case *pb.PeerMessage_SendCancel:
		e.handleCancel(from, m.SendCancel)
	case *pb.PeerMessage_SendResult:
		e.handleResult(from, m.SendResult)
	default:
		return false
	}
	return true
}

// IsStream 判断一条数据通道是不是隔空传送的。
func IsStream(label string) bool { return strings.HasPrefix(label, streamPrefix) }

// ─────────────────────── 对外接口 ───────────────────────

// List 按时间倒序列出传输记录。
func (e *Engine) List(dir pb.TransferDirection, limit int, before time.Time) ([]*pb.Transfer, error) {
	list, err := e.opts.Store.ListTransfers(store.Direction(dir), limit, before)
	if err != nil {
		return nil, err
	}
	out := make([]*pb.Transfer, 0, len(list))
	for _, t := range list {
		out = append(out, e.toProto(t))
	}
	return out, nil
}

// Delete 删除记录，不删文件。进行中的跳过。
func (e *Engine) Delete(ids []string, all bool, dir pb.TransferDirection) error {
	if all {
		var err error
		if ids, err = e.opts.Store.FinishedTransferIDs(store.Direction(dir)); err != nil {
			return err
		}
	}
	var gone []string
	for _, id := range ids {
		t, err := e.opts.Store.GetTransfer(id)
		if err != nil || !store.TransferFinished(t.Status) {
			continue
		}
		gone = append(gone, id)
	}
	if err := e.opts.Store.DeleteTransfers(gone); err != nil {
		return err
	}
	for _, id := range gone {
		e.removed(id)
	}
	return nil
}

// MarkSeen 把收到的都标为看过。
func (e *Engine) MarkSeen() error {
	ids, err := e.opts.Store.MarkTransfersSeen()
	if err != nil {
		return err
	}
	for _, id := range ids {
		if t, err := e.opts.Store.GetTransfer(id); err == nil {
			e.changed(t)
		}
	}
	return nil
}

// Cancel 取消一批，发出的、收到的都可以。两边都停下，接收方删掉没收完的部分。
func (e *Engine) Cancel(id string) error {
	t, err := e.opts.Store.GetTransfer(id)
	if err != nil {
		return ErrNotFound
	}
	if store.TransferFinished(t.Status) {
		return nil
	}
	e.mu.Lock()
	o, in := e.out[id], e.in[id]
	e.mu.Unlock()
	if o != nil {
		o.abort(errCancelled)
		return nil
	}
	if in != nil {
		in.abort(errCancelled)
		return nil
	}
	// 没在进行（排队、中断、暂停）：直接结束，并告诉对方清掉没收完的部分
	_ = e.opts.Send(t.DeviceID, &pb.PeerMessage{Payload: &pb.PeerMessage_SendCancel{
		SendCancel: &pb.SendCancel{TransferId: id, Reason: "cancelled"}}})
	if t.Direction == store.Incoming {
		e.removePartial(t)
	}
	e.finish(t, store.TransferCancelled, "cancelled")
	return nil
}

var errCancelled = errors.New("cancelled")

func newID() string {
	b := make([]byte, 16)
	_, _ = rand.Read(b)
	return hex.EncodeToString(b)
}

// ─────────────────────── 状态与事件 ───────────────────────

func (e *Engine) save(t store.Transfer) {
	t.UpdatedAt = e.opts.Now()
	if err := e.opts.Store.PutTransfer(t); err != nil {
		e.log.Warn("保存传输记录失败", "transfer", t.ID, "err", err)
	}
	e.changed(t)
}

// finish 把一批标为结束：记下结果、清掉条目、释放「传输中」。
func (e *Engine) finish(t store.Transfer, status, code string) {
	t.Status = status
	t.Error = code
	t.FinishedAt = e.opts.Now()
	e.setBusy(t.ID, false)
	e.mu.Lock()
	delete(e.progress, t.ID)
	e.mu.Unlock()
	e.save(t)
	if err := e.opts.Store.DeleteTransferEntries(t.ID); err != nil {
		e.log.Debug("清理条目失败", "transfer", t.ID, "err", err)
	}
}

func (e *Engine) changed(t store.Transfer) {
	if e.opts.OnChange != nil {
		e.opts.OnChange(e.toProto(t))
	}
}

func (e *Engine) removed(id string) {
	if e.opts.OnRemoved != nil {
		e.opts.OnRemoved(id)
	}
}

func (e *Engine) notice(kind NoticeKind, t store.Transfer) {
	if e.opts.OnNotice != nil {
		e.opts.OnNotice(kind, e.toProto(t))
	}
}

// setBusy 记下哪些批次正在传：有就阻止系统空闲睡眠，都结束了就放开。
func (e *Engine) setBusy(id string, on bool) {
	e.mu.Lock()
	defer e.mu.Unlock()
	if on {
		e.busy[id] = true
	} else {
		delete(e.busy, id)
	}
	switch {
	case len(e.busy) > 0 && e.release == nil && e.opts.Inhibit != nil:
		e.release = e.opts.Inhibit()
	case len(e.busy) == 0 && e.release != nil:
		e.release()
		e.release = nil
	}
}
