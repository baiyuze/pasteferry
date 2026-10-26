package send

// 好友与陌生设备发来的文件要本机的用户点「接受」（2.6.0），见 design/friends-send.md 第 7 节。
// 接收方先回 SendAnswer{reason: "pending"}，用户决定后再回最终结果；60 秒没有回应算拒绝。

import (
	"strings"
	"time"
	"unicode"
	"unicode/utf8"

	"github.com/baiyuze/pasteferry/client-core/internal/store"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// 用户的决定
const (
	askAccept    = "accept"
	askDeclined  = "declined"
	askCancelled = "cancelled" // 发送方取消了
)

// CleanNote 检查备注：最多 MaxNote 个字符、一行、没有控制字符。两头的空白去掉。
func CleanNote(note string) (string, bool) {
	note = strings.TrimSpace(note)
	if !utf8.ValidString(note) || utf8.RuneCountInString(note) > MaxNote {
		return "", false
	}
	for _, r := range note {
		if unicode.IsControl(r) || r == ' ' || r == ' ' {
			return "", false
		}
	}
	return note, true
}

// askUser 记下一批等用户接受的，通知界面，等用户的决定、发送方取消或超时。
// 返回 askAccept、askDeclined、askCancelled 或 "timeout"。
func (e *Engine) askUser(t store.Transfer) string {
	ch := make(chan string, 1)
	e.mu.Lock()
	e.asks[t.ID] = ch
	e.mu.Unlock()
	defer func() {
		e.mu.Lock()
		delete(e.asks, t.ID)
		e.mu.Unlock()
	}()
	e.save(t)
	e.notice(NoticeAsk, t)
	timer := time.NewTimer(e.opts.AskTimeout)
	defer timer.Stop()
	select {
	case d := <-ch:
		return d
	case <-timer.C:
		return "timeout"
	case <-e.ctx.Done():
		return askCancelled
	}
}

// Answer 是用户在接收弹窗里点了「接受」或「拒绝」。返回发来的设备和它的角色（「以后自动接收」用）。
func (e *Engine) Answer(id string, accept bool) (deviceID, role string, err error) {
	e.mu.Lock()
	ch := e.asks[id]
	e.mu.Unlock()
	if ch == nil {
		return "", "", ErrNotAsking
	}
	t, err := e.opts.Store.GetTransfer(id)
	if err != nil {
		return "", "", ErrNotFound
	}
	d := askDeclined
	if accept {
		d = askAccept
	}
	select {
	case ch <- d:
	default:
	}
	return t.DeviceID, t.PeerRole, nil
}

// cancelAsk：发送方在本机用户决定之前取消了。返回 false 表示这一批不在等用户
func (e *Engine) cancelAsk(id, from string) bool {
	e.mu.Lock()
	ch := e.asks[id]
	e.mu.Unlock()
	if ch == nil {
		return false
	}
	if t, err := e.opts.Store.GetTransfer(id); err != nil || t.DeviceID != from {
		return false
	}
	select {
	case ch <- askCancelled:
	default:
	}
	return true
}

// declined 记下用户拒绝了这台电脑一次；一分钟内拒绝 3 次，之后 10 分钟它的请求直接拒绝
func (e *Engine) declined(from string) {
	now := e.opts.Now()
	e.mu.Lock()
	defer e.mu.Unlock()
	recent := e.declines[from][:0]
	for _, at := range e.declines[from] {
		if now.Sub(at) < declineWindow {
			recent = append(recent, at)
		}
	}
	recent = append(recent, now)
	e.declines[from] = recent
	if len(recent) >= declineLimit {
		e.muted[from] = now.Add(declineMute)
		delete(e.declines, from)
		e.log.Info("一分钟内拒绝了 3 次，10 分钟内不再提示", "device", from)
	}
}

func (e *Engine) isMuted(from string) bool {
	e.mu.Lock()
	defer e.mu.Unlock()
	until, ok := e.muted[from]
	if !ok {
		return false
	}
	if e.opts.Now().After(until) {
		delete(e.muted, from)
		return false
	}
	return true
}

// Busy 报告与某台电脑之间是否还有传输在进行或等待（好友的连接空闲时才断开）
func (e *Engine) Busy(deviceID string) bool {
	e.mu.Lock()
	defer e.mu.Unlock()
	for _, o := range e.out {
		if o.device == deviceID {
			return true
		}
	}
	for _, in := range e.in {
		if in.device == deviceID {
			return true
		}
	}
	if e.workers[deviceID] {
		return true
	}
	for id := range e.asks {
		if t, err := e.opts.Store.GetTransfer(id); err == nil && t.DeviceID == deviceID {
			return true
		}
	}
	return false
}

// thumbnails 为收到的顶层图片生成缩略图（本机重新编码），与 items 一一对应，不是图片的为空。
func (e *Engine) thumbnails(items []store.Item, paths []string) []string {
	if e.opts.Thumbnail == nil {
		return nil
	}
	out := make([]string, len(items))
	found := false
	for i, it := range items {
		if it.IsDir || i >= len(paths) {
			continue
		}
		if out[i] = e.opts.Thumbnail(paths[i]); out[i] != "" {
			found = true
		}
	}
	if !found {
		return nil
	}
	return out
}

// askResult 把用户的决定换成给发送方的回答与本机记录的结果
func askResult(d string) (answer *pb.SendAnswer, status, code string) {
	switch d {
	case askDeclined:
		return &pb.SendAnswer{Reason: "declined"}, store.TransferDeclined, "declined"
	case askCancelled:
		return nil, store.TransferCancelled, "peer_cancelled"
	}
	return &pb.SendAnswer{Reason: "timeout"}, store.TransferDeclined, "timeout"
}
