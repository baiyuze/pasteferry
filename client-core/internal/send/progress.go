package send

import (
	"os"
	"sync"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/store"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// meter 记一批正在传（或正在统计）的进度，按节流推给界面。
type meter struct {
	e  *Engine
	mu sync.Mutex
	t  store.Transfer

	base, sent int64
	startAt    time.Time
	samples    []sample // 最近几秒的进度，算速度用
	bps        float64

	current        string
	ordinal        int64
	currentAt      time.Time
	pendingCurrent string
	pendingOrdinal int64

	scanned  int64
	lastEmit time.Time
	noticed  bool // 已经判断过要不要发「正在发来」的通知
}

type sample struct {
	at   time.Time
	done int64
}

func (e *Engine) meterFor(t store.Transfer) *meter {
	e.mu.Lock()
	defer e.mu.Unlock()
	m := e.progress[t.ID]
	if m == nil {
		m = &meter{e: e}
		e.progress[t.ID] = m
	}
	m.mu.Lock()
	m.t = t
	m.mu.Unlock()
	return m
}

// start 从 base 字节处开始计（续传时 base 是已经传过的部分）。
func (m *meter) start(base int64) {
	m.mu.Lock()
	m.base, m.sent, m.startAt = base, 0, time.Now()
	m.samples = []sample{{m.startAt, base}}
	m.bps = 0
	m.mu.Unlock()
}

func (m *meter) add(n int64) {
	m.mu.Lock()
	m.sent += n
	m.mu.Unlock()
	m.maybeEmit()
}

func (m *meter) doneBytes() int64 {
	m.mu.Lock()
	defer m.mu.Unlock()
	return m.base + m.sent
}

func (m *meter) setCurrent(path string, ordinal int64) {
	m.mu.Lock()
	m.pendingCurrent, m.pendingOrdinal = path, ordinal
	if m.current == "" || time.Since(m.currentAt) >= currentFileInterval {
		m.current, m.ordinal, m.currentAt = path, ordinal, time.Now()
	}
	m.mu.Unlock()
}

func (m *meter) setScanned(files int64) {
	m.mu.Lock()
	m.scanned = files
	m.mu.Unlock()
	m.maybeEmit()
}

// maybeEmit 距上次推送超过节流间隔时推一次；接收方传了 3 秒后估算剩余时间，
// 还要很久的话发一条「正在发来」的通知。
func (m *meter) maybeEmit() {
	now := time.Now()
	m.mu.Lock()
	if now.Sub(m.lastEmit) < progressInterval {
		m.mu.Unlock()
		return
	}
	m.lastEmit = now
	done := m.base + m.sent
	m.samples = append(m.samples, sample{now, done})
	for len(m.samples) > 2 && now.Sub(m.samples[1].at) > 3*time.Second {
		m.samples = m.samples[1:]
	}
	if first := m.samples[0]; now.Sub(first.at) > 300*time.Millisecond {
		m.bps = float64(done-first.done) / now.Sub(first.at).Seconds()
	}
	if m.pendingCurrent != m.current && now.Sub(m.currentAt) >= currentFileInterval {
		m.current, m.ordinal, m.currentAt = m.pendingCurrent, m.pendingOrdinal, now
	}
	t := m.t
	notice := false
	if t.Direction == store.Incoming && !m.noticed && !m.startAt.IsZero() && now.Sub(m.startAt) >= startNoticeDelay {
		m.noticed = true
		if m.bps > 0 && float64(t.TotalBytes-done)/m.bps > bigTransfer.Seconds() {
			notice = true
		}
	}
	m.mu.Unlock()
	m.e.changed(t)
	if notice {
		m.e.notice(NoticeIncoming, t)
	}
}

// live 把内存里的进度填进界面看到的记录。
func (m *meter) live(p *pb.Transfer) {
	m.mu.Lock()
	defer m.mu.Unlock()
	if p.Status == store.TransferScanning {
		p.ScannedFiles = m.scanned
		return
	}
	if p.Status != store.TransferActive {
		return
	}
	p.DoneBytes = m.base + m.sent
	p.BytesPerSecond = m.bps
	p.CurrentFile = m.current
	p.CurrentIndex = m.ordinal
}

// toProto 转成界面用的格式。正在传的带上实时进度；收完的顺便看看文件还在不在原处。
func (e *Engine) toProto(t store.Transfer) *pb.Transfer {
	p := &pb.Transfer{
		Id: t.ID, Direction: pb.TransferDirection(t.Direction), DeviceId: t.DeviceID, DeviceName: t.DeviceName,
		Status: t.Status, Paths: t.Paths, TotalBytes: t.TotalBytes, DoneBytes: t.DoneBytes,
		FileCount: t.FileCount, Error: t.Error, ShortfallBytes: t.Shortfall, Relayed: t.Relayed,
		Seen: t.Seen, CreatedAtUnix: t.CreatedAt.Unix(),
	}
	if !t.FinishedAt.IsZero() {
		p.FinishedAtUnix = t.FinishedAt.Unix()
	}
	for _, it := range t.Items {
		p.Items = append(p.Items, &pb.ClipItem{Name: it.Name, Size: it.Size, IsDir: it.IsDir})
	}
	e.mu.Lock()
	m := e.progress[t.ID]
	e.mu.Unlock()
	if m != nil {
		m.live(p)
	}
	if t.Direction == store.Incoming && t.Status == store.TransferDone {
		for _, path := range t.Paths {
			_, err := os.Lstat(path)
			p.Present = append(p.Present, err == nil)
		}
	}
	return p
}

// janitor 定期清理：过期没续上的半成品、太旧或太多的记录。
func (e *Engine) janitor() {
	now := e.opts.Now()
	if list, err := e.opts.Store.UnfinishedTransfers(); err == nil {
		for _, t := range list {
			e.mu.Lock()
			running := e.out[t.ID] != nil || e.in[t.ID] != nil || e.progress[t.ID] != nil
			e.mu.Unlock()
			if running {
				continue
			}
			stale := now.Sub(t.UpdatedAt)
			switch {
			case t.Direction == store.Incoming && t.Status == store.TransferInterrupted && stale > partialTTL:
				e.removePartial(t)
				e.finish(t, store.TransferExpired, "")
			case stale > recordTTL && t.Status != store.TransferScanning:
				e.removePartial(t)
				e.finish(t, store.TransferExpired, "")
			}
		}
	}
	ids, err := e.opts.Store.StaleTransferIDs(now.Add(-recordTTL), recordKeep)
	if err != nil || len(ids) == 0 {
		return
	}
	if err := e.opts.Store.DeleteTransfers(ids); err == nil {
		for _, id := range ids {
			e.removed(id)
		}
	}
}

// CheckDir 检查保存位置能不能写入：path 为空时检查当前设置的位置。
// 在 macOS 上，第一次写「下载」「文稿」「桌面」时系统会弹窗请用户允许，所以要在用户看着界面时调用。
func (e *Engine) CheckDir(path string) *pb.CheckReceiveDirResponse {
	if path == "" {
		path = e.opts.LoadConfig().EffectiveReceiveDir()
	}
	resp := &pb.CheckReceiveDirResponse{Path: path}
	info, err := os.Stat(path)
	switch {
	case err != nil && os.IsNotExist(err):
		resp.Error = "not_found"
		return resp
	case err != nil && os.IsPermission(err):
		resp.Error = "permission_denied"
		return resp
	case err != nil:
		resp.Error = "not_writable"
		return resp
	case !info.IsDir():
		resp.Error = "not_directory"
		return resp
	}
	probe, err := os.CreateTemp(path, ".pasteferry-check-*")
	if err != nil {
		resp.Error = "not_writable"
		if os.IsPermission(err) {
			resp.Error = "permission_denied"
		}
		return resp
	}
	probe.Close()
	_ = os.Remove(probe.Name())
	resp.Ok = true
	if free, err := freeSpace(path); err == nil {
		resp.FreeBytes = free
	}
	return resp
}
