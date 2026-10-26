package send

import (
	"context"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"sync"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/pack"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// outgoing 是一批正在发的文件。
type outgoing struct {
	id, device string
	ctx        context.Context
	cancel     context.CancelCauseFunc

	mu      sync.Mutex
	attempt uint32
	answer  chan *pb.SendAnswer
	result  chan *pb.SendResult
	pipe    sendPipe
	done    chan struct{} // runOutgoing 返回时关闭
}

func (o *outgoing) abort(cause error) {
	o.cancel(cause)
	o.mu.Lock()
	p := o.pipe
	o.mu.Unlock()
	if p != nil {
		_ = p.Close() // 让卡在发送缓冲上的写入立刻返回
	}
}

// peerCancel 是对方取消了这一批。
type peerCancel struct{ reason string }

func (p *peerCancel) Error() string { return "对方取消了：" + p.reason }

// SendFiles 把 paths 发给一台设备。立即返回这一批的记录：先统计，统计完排队，轮到了就发。
func (e *Engine) SendFiles(deviceID string, paths []string, allowRelay bool, note string) (*pb.Transfer, error) {
	p := e.opts.Peer(deviceID)
	other := p.Role != "" && p.Role != store.RoleSelf
	switch {
	case !p.Known:
		return nil, ErrUnknownDevice
	case !p.Online:
		return nil, ErrOffline
	case !p.Supported, other && !p.Ask:
		// 旧版本收到会直接接收，绕过对方用户的确认，所以不发
		return nil, ErrUnsupported
	case p.Disabled:
		return nil, ErrPeerDisabled
	case len(paths) == 0:
		return nil, ErrNoPaths
	}
	note, ok := CleanNote(note)
	if !ok {
		return nil, ErrBadNote
	}
	clean := make([]string, 0, len(paths))
	items := make([]store.Item, 0, len(paths))
	for _, path := range paths {
		abs, err := filepath.Abs(path)
		if err != nil {
			return nil, fmt.Errorf("%w: %s", ErrNoPaths, path)
		}
		info, err := os.Stat(abs)
		if err != nil {
			return nil, fmt.Errorf("%w: %s", ErrNoPaths, path)
		}
		clean = append(clean, abs)
		items = append(items, store.Item{Name: filepath.Base(abs), Size: info.Size(), IsDir: info.IsDir()})
	}
	if p.Relayed && e.opts.LoadConfig().Official() && !allowRelay {
		return nil, ErrNeedRelayConsent
	}
	now := e.opts.Now()
	t := store.Transfer{
		ID: newID(), Direction: store.Outgoing, DeviceID: deviceID, DeviceName: p.Name,
		Status: store.TransferScanning, Items: items, Paths: clean, AllowRelay: allowRelay,
		Relayed: p.Relayed, CreatedAt: now, PeerRole: p.Role, Note: note,
	}
	e.save(t)
	if other && !p.Connected && e.opts.Connect != nil {
		// 好友不常连：现在连上，连上后（PeerReady）开始发
		go e.opts.Connect(deviceID)
	}
	e.wg.Add(1)
	go func() {
		defer e.wg.Done()
		e.scan(t)
	}()
	return e.toProto(t), nil
}

// scan 统计要发的文件，把清单记进数据库，然后排队。
func (e *Engine) scan(t store.Transfer) {
	m := e.meterFor(t)
	entries, tops, err := pack.BuildManifest(e.ctx, t.Paths, func(files int64) {
		m.setScanned(files)
	})
	if e.ctx.Err() != nil {
		return
	}
	// 统计期间用户可能已经取消了
	if cur, gerr := e.opts.Store.GetTransfer(t.ID); gerr != nil || cur.Status != store.TransferScanning {
		return
	}
	if err != nil {
		code := "read_error"
		if errors.Is(err, pack.ErrSourceMissing) {
			code = "source_missing"
		}
		e.log.Warn("统计要发的文件失败", "transfer", t.ID, "err", err)
		e.finish(t, store.TransferFailed, code)
		return
	}
	rows := make([]store.TransferEntry, len(entries))
	var total, files int64
	for i, en := range entries {
		rows[i] = store.TransferEntry{Index: int64(i), Path: en.Path, Size: en.Size, IsDir: en.IsDir,
			Mode: en.Mode, MTime: en.MTime, Link: en.Link, Source: en.Source}
		if !en.IsDir && en.Link == "" {
			total += en.Size
			files++
		}
	}
	if err := e.opts.Store.PutTransferEntries(t.ID, rows); err != nil {
		e.log.Warn("保存清单失败", "transfer", t.ID, "err", err)
		e.finish(t, store.TransferFailed, "read_error")
		return
	}
	t.Items = t.Items[:0]
	for _, top := range tops {
		t.Items = append(t.Items, store.Item{Name: top.Name, Size: top.Size, IsDir: top.IsDir})
	}
	t.TotalBytes, t.FileCount, t.Status = total, files, store.TransferQueued
	e.mu.Lock()
	delete(e.progress, t.ID)
	e.mu.Unlock()
	e.save(t)
	e.kick(t.DeviceID)
}

// Resume 让中断或暂停的一批从断点继续。
func (e *Engine) Resume(id string) error {
	t, err := e.opts.Store.GetTransfer(id)
	if err != nil {
		return ErrNotFound
	}
	if t.Direction != store.Outgoing || (t.Status != store.TransferInterrupted && t.Status != store.TransferPaused) {
		return ErrNotResumable
	}
	t.Status, t.Error = store.TransferQueued, ""
	e.save(t)
	e.kick(t.DeviceID)
	return nil
}

// kick 确保这台设备有一个发送工作者在跑。
func (e *Engine) kick(deviceID string) {
	e.mu.Lock()
	if e.workers[deviceID] || e.ctx.Err() != nil {
		e.mu.Unlock()
		return
	}
	e.workers[deviceID] = true
	e.mu.Unlock()
	e.wg.Add(1)
	go func() {
		defer e.wg.Done()
		e.runDevice(deviceID)
	}()
}

// runDevice 按先后顺序一批一批地发给一台设备。连接断了就停下，等 PeerReady 再来。
func (e *Engine) runDevice(deviceID string) {
	// 重连可能早于旧尝试的应答超时：PeerReady 看不到稍后才标为中断的批次。
	// 每批补试一次；持续失败仍等下一次重连或用户点「继续」，不循环重发。
	var retried string
	for e.ctx.Err() == nil {
		t, ok := e.nextQueued(deviceID)
		if !ok || !e.opts.Peer(deviceID).Connected {
			break
		}
		e.runOutgoing(t)
		if retried != t.ID {
			if cur, err := e.opts.Store.GetTransfer(t.ID); err == nil && cur.Status == store.TransferInterrupted && e.opts.Peer(deviceID).Connected {
				retried = t.ID
				e.retryInterrupted(cur)
			}
		}
	}
	e.mu.Lock()
	delete(e.workers, deviceID)
	e.mu.Unlock()
	// 停下的同时可能有新的一批排进来了
	if _, ok := e.nextQueued(deviceID); ok && e.opts.Peer(deviceID).Connected && e.ctx.Err() == nil {
		e.kick(deviceID)
	}
}

// retryInterrupted 给对方重启留一点时间，等待期间的取消、手动继续和退出优先。
func (e *Engine) retryInterrupted(t store.Transfer) {
	timer := time.NewTimer(3 * time.Second)
	defer timer.Stop()
	select {
	case <-e.ctx.Done():
		return
	case <-timer.C:
	}
	cur, err := e.opts.Store.GetTransfer(t.ID)
	if err != nil || cur.Status != store.TransferInterrupted || cur.Attempt != t.Attempt || !e.opts.Peer(t.DeviceID).Connected {
		return
	}
	cur.Status, cur.Error = store.TransferQueued, ""
	e.save(cur)
}

func (e *Engine) nextQueued(deviceID string) (store.Transfer, bool) {
	list, err := e.opts.Store.UnfinishedTransfers()
	if err != nil {
		return store.Transfer{}, false
	}
	for _, t := range list {
		if t.Direction == store.Outgoing && t.DeviceID == deviceID && t.Status == store.TransferQueued {
			return t, true
		}
	}
	return store.Transfer{}, false
}

// runOutgoing 发一批：发起、等应答、发帧流、等结果。
func (e *Engine) runOutgoing(t store.Transfer) {
	ctx, cancel := context.WithCancelCause(e.ctx)
	defer cancel(nil)
	o := &outgoing{id: t.ID, device: t.DeviceID, ctx: ctx, cancel: cancel,
		answer: make(chan *pb.SendAnswer, 2), result: make(chan *pb.SendResult, 1), done: make(chan struct{})}
	e.mu.Lock()
	e.out[t.ID] = o
	e.mu.Unlock()
	defer func() {
		e.mu.Lock()
		delete(e.out, t.ID)
		e.mu.Unlock()
		close(o.done)
	}()

	fresh := t.Attempt == 0 // 对方从没收到过这一批
	retried := false
	for {
		t.Attempt++
		o.mu.Lock()
		o.attempt = uint32(t.Attempt)
		o.mu.Unlock()
		peer := e.opts.Peer(t.DeviceID)
		t.Status, t.Error, t.Shortfall, t.Relayed = store.TransferWaiting, "", 0, peer.Relayed
		e.save(t)

		largest, _ := e.opts.Store.LargestTransferEntry(t.ID)
		items := make([]*pb.ClipItem, len(t.Items))
		for i, it := range t.Items {
			items[i] = &pb.ClipItem{Name: it.Name, Size: it.Size, IsDir: it.IsDir}
		}
		offer := &pb.SendOffer{TransferId: t.ID, Attempt: uint32(t.Attempt), Items: items,
			TotalBytes: t.TotalBytes, FileCount: t.FileCount, LargestFile: largest,
			CreatedAtUnix: t.CreatedAt.Unix(), Resume: !fresh, Note: t.Note}
		if err := e.opts.Send(t.DeviceID, &pb.PeerMessage{Payload: &pb.PeerMessage_SendOffer{SendOffer: offer}}); err != nil {
			e.interrupt(t)
			return
		}

		var answer *pb.SendAnswer
		wait := time.NewTimer(e.opts.AnswerTimeout)
	waitAnswer:
		for {
			select {
			case answer = <-o.answer:
				if !answer.GetAccepted() && answer.GetReason() == "pending" {
					// 对方在等它的用户接受：多等一会儿
					t.Status = store.TransferAsking
					e.save(t)
					wait.Reset(e.opts.AskTimeout + askSlack)
					continue
				}
				break waitAnswer
			case <-ctx.Done():
				wait.Stop()
				e.stopped(t, context.Cause(ctx))
				return
			case <-wait.C:
				if t.Status == store.TransferAsking {
					e.log.Info("对方的用户没有回应", "transfer", t.ID)
					_ = e.opts.Send(t.DeviceID, &pb.PeerMessage{Payload: &pb.PeerMessage_SendCancel{
						SendCancel: &pb.SendCancel{TransferId: t.ID, Reason: "timeout"}}})
					e.finish(t, store.TransferDeclined, "timeout")
					return
				}
				e.log.Info("对方没有应答", "transfer", t.ID)
				e.interrupt(t)
				return
			}
		}
		wait.Stop()
		if !answer.GetAccepted() {
			if answer.GetReason() == "already_done" {
				// 上次其实已经收完了，只是结果没传回来（比如走局域网快速通道时控制通道恰好断了）
				t.DoneBytes = t.TotalBytes
				e.finish(t, store.TransferDone, "")
				e.log.Info("隔空传送已送达（对方上次已收完）", "transfer", t.ID, "to", t.DeviceID)
				return
			}
			if answer.GetReason() == "unknown_transfer" && !fresh {
				// 对方已经清掉了没收完的部分（或者换了电脑重装过），从头再发
				fresh = true
				t.DoneBytes = 0
				continue
			}
			t.Shortfall = answer.GetShortfallBytes()
			e.finish(t, store.TransferDeclined, answer.GetReason())
			return
		}
		fresh = false

		base, filesBefore, err := e.opts.Store.TransferEntryTotals(t.ID, answer.GetResumeIndex())
		if err != nil {
			e.interrupt(t)
			return
		}
		t.DoneBytes = base + answer.GetResumeOffset()
		t.Status = store.TransferActive
		e.save(t)
		e.setBusy(t.ID, true)

		err = e.stream(ctx, o, t, answer.GetResumeIndex(), answer.GetResumeOffset(), filesBefore, answer.GetLanAddr())
		if err != nil {
			if ctx.Err() != nil {
				e.stopped(t, context.Cause(ctx))
				return
			}
			if code := sourceErrorCode(err); code != "" {
				e.log.Warn("读源文件失败", "transfer", t.ID, "err", err)
				_ = e.opts.Send(t.DeviceID, &pb.PeerMessage{Payload: &pb.PeerMessage_SendCancel{
					SendCancel: &pb.SendCancel{TransferId: t.ID, Reason: code}}})
				e.finish(t, store.TransferFailed, code)
				return
			}
			e.log.Info("发送中断", "transfer", t.ID, "err", err)
			e.interrupt(e.withProgress(t))
			return
		}

		var result *pb.SendResult
		select {
		case result = <-o.result:
		case <-ctx.Done():
			e.stopped(t, context.Cause(ctx))
			return
		case <-time.After(e.opts.ResultTimeout):
			e.interrupt(e.withProgress(t))
			return
		}
		if result.GetOk() {
			t.DoneBytes = t.TotalBytes
			e.finish(t, store.TransferDone, "")
			if t.PeerRole == store.RoleFriend && e.opts.Delivered != nil {
				e.opts.Delivered(t.DeviceID)
			}
			e.log.Info("隔空传送已送达", "transfer", t.ID, "to", t.DeviceID, "字节", t.TotalBytes)
			return
		}
		if result.GetError() == "hash_mismatch" && !retried {
			// 对方已经删掉了校验不对的那个文件，从它开始再发一次
			retried = true
			e.setBusy(t.ID, false)
			continue
		}
		e.finish(e.withProgress(t), store.TransferFailed, result.GetError())
		return
	}
}

// stream 开这次尝试的管道（局域网 TCP 或数据通道），从第 index 个条目的 offset 处开始发帧流。
func (e *Engine) stream(ctx context.Context, o *outgoing, t store.Transfer, index, offset, filesBefore int64, lanAddr string) error {
	label := fmt.Sprintf("%s%s:%d", streamPrefix, t.ID, t.Attempt)
	p, err := e.openPipe(ctx, sendTarget{id: t.ID, device: t.DeviceID, label: label}, lanAddr)
	if err != nil {
		if ctx.Err() != nil {
			return ctx.Err()
		}
		return fmt.Errorf("打开数据流: %w", err)
	}
	o.mu.Lock()
	o.pipe = p
	o.mu.Unlock()
	defer p.Close()

	m := e.meterFor(t)
	m.start(t.DoneBytes)
	fw, err := pack.NewFrameWriter(p, m.add)
	if err != nil {
		return err
	}
	ordinal := filesBefore
	for from := index; ; {
		batch, err := e.opts.Store.TransferEntries(t.ID, from, 1000)
		if err != nil {
			fw.Close()
			return err
		}
		if len(batch) == 0 {
			break
		}
		for _, en := range batch {
			if err := ctx.Err(); err != nil {
				fw.Close()
				return err
			}
			off := int64(0)
			if en.Index == index {
				off = offset
			}
			if !en.IsDir && en.Link == "" {
				ordinal++
				m.setCurrent(en.Path, ordinal)
			}
			entry := pack.Entry{Path: en.Path, Source: en.Source, Size: en.Size, IsDir: en.IsDir,
				Mode: en.Mode, MTime: en.MTime, Link: en.Link}
			if err := fw.WriteEntry(en.Index, entry, off); err != nil {
				fw.Close()
				return err
			}
		}
		from = batch[len(batch)-1].Index + 1
	}
	if err := fw.Finish(); err != nil {
		return err
	}
	return p.finish(ctx)
}

// sourceErrorCode 把读源文件的错误转成发给对方、显示给用户的代码；不是源文件的问题时返回空。
func sourceErrorCode(err error) string {
	var re *pack.ReadError
	switch {
	case errors.Is(err, pack.ErrSourceChanged):
		return "source_changed"
	case errors.Is(err, pack.ErrSourceMissing):
		return "source_missing"
	case errors.As(err, &re):
		return "read_error"
	}
	return ""
}

// interrupt 把一批标为中断：连上以后自动续传。经官方服务中转、而今天的额度用完了时标为暂停。
func (e *Engine) interrupt(t store.Transfer) {
	e.setBusy(t.ID, false)
	t.Status = store.TransferInterrupted
	t.Error = ""
	if t.Relayed && e.opts.LoadConfig().Official() && e.opts.RelayQuotaExhausted != nil && e.opts.RelayQuotaExhausted() {
		t.Status, t.Error = store.TransferPaused, "relay_quota"
	}
	e.mu.Lock()
	delete(e.progress, t.ID)
	e.mu.Unlock()
	e.save(t)
}

// stopped 处理被取消的一批：用户取消、对方取消，或者后台服务正在退出。
func (e *Engine) stopped(t store.Transfer, cause error) {
	t = e.withProgress(t)
	var pc *peerCancel
	switch {
	case errors.Is(cause, errCancelled):
		_ = e.opts.Send(t.DeviceID, &pb.PeerMessage{Payload: &pb.PeerMessage_SendCancel{
			SendCancel: &pb.SendCancel{TransferId: t.ID, Reason: "cancelled"}}})
		e.finish(t, store.TransferCancelled, "cancelled")
	case errors.As(cause, &pc):
		e.finish(t, store.TransferCancelled, "peer_cancelled")
	default:
		e.interrupt(t)
	}
}

// withProgress 把内存里的进度写回记录。
func (e *Engine) withProgress(t store.Transfer) store.Transfer {
	e.mu.Lock()
	m := e.progress[t.ID]
	e.mu.Unlock()
	if m != nil {
		t.DoneBytes = m.doneBytes()
	}
	return t
}

func (e *Engine) handleAnswer(from string, a *pb.SendAnswer) {
	e.mu.Lock()
	o := e.out[a.GetTransferId()]
	e.mu.Unlock()
	if o == nil || o.device != from {
		return
	}
	o.mu.Lock()
	match := a.GetAttempt() == o.attempt
	o.mu.Unlock()
	if !match {
		return
	}
	select {
	case o.answer <- a:
	default:
	}
}

func (e *Engine) handleResult(from string, r *pb.SendResult) {
	e.mu.Lock()
	o := e.out[r.GetTransferId()]
	e.mu.Unlock()
	if o == nil || o.device != from {
		return
	}
	o.mu.Lock()
	match := r.GetAttempt() == o.attempt
	o.mu.Unlock()
	if !match {
		return
	}
	select {
	case o.result <- r:
	default:
	}
}

// handleCancel 处理对方的取消：正在进行的停下，没在进行的直接结束。
//
// 正在进行的那一批可能恰好刚因为数据流断了而判为中断、还没退出，取消就落空了。
// 所以停下它以后等它退出，再按记录补做一次；它自己已经处理过取消的话，记录已经结束，不会重复。
func (e *Engine) handleCancel(from string, c *pb.SendCancel) {
	id := c.GetTransferId()
	if e.cancelAsk(id, from) {
		return
	}
	cause := &peerCancel{reason: c.GetReason()}
	e.mu.Lock()
	o, in := e.out[id], e.in[id]
	e.mu.Unlock()
	var running chan struct{}
	switch {
	case o != nil && o.device == from:
		o.abort(cause)
		running = o.done
	case in != nil && in.device == from:
		in.abort(cause)
		running = in.done
	}
	if running == nil {
		e.applyPeerCancel(from, c)
		return
	}
	e.wg.Add(1)
	go func() {
		defer e.wg.Done()
		select {
		case <-running:
		case <-time.After(10 * time.Second):
		}
		e.applyPeerCancel(from, c)
	}()
}

// applyPeerCancel 按记录处理对方的取消：还没结束的一批直接结束，收到的删掉没收完的部分。
func (e *Engine) applyPeerCancel(from string, c *pb.SendCancel) {
	id := c.GetTransferId()
	t, err := e.opts.Store.GetTransfer(id)
	if err != nil || t.DeviceID != from || store.TransferFinished(t.Status) {
		return
	}
	if t.Direction == store.Incoming {
		e.removePartial(t)
		code := "peer_cancelled"
		if r := c.GetReason(); r == "source_changed" || r == "source_missing" || r == "read_error" {
			e.finish(t, store.TransferFailed, r)
			e.notice(NoticeFailed, t)
			return
		}
		e.finish(t, store.TransferCancelled, code)
		return
	}
	e.finish(t, store.TransferCancelled, "peer_cancelled")
}
