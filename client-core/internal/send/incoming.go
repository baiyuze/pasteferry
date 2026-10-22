package send

import (
	"context"
	"crypto/sha256"
	"errors"
	"fmt"
	"io"
	"os"
	"path"
	"path/filepath"
	"runtime"
	"strconv"
	"strings"
	"sync"
	"sync/atomic"
	"syscall"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/pack"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/p2p"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// incoming 是一批正在收的文件。
type incoming struct {
	id, device string
	attempt    uint32
	offer      *pb.SendOffer
	dest       string // 保存位置
	partial    string // 临时目录：<保存位置>/.pasteferry-partial/<id>
	tops       map[string]bool
	names      *pack.Names

	resumeIndex, resumeOffset int64
	doneBefore, filesBefore   int64 // 续传点之前已经收完的字节数与文件数

	ctx      context.Context
	cancel   context.CancelCauseFunc
	streamCh chan *p2p.Stream
	done     chan struct{}
	active   atomic.Int64 // 最近一次收到数据的时间（UnixNano），看门狗用

	mu     sync.Mutex
	stream *p2p.Stream
}

func (in *incoming) abort(cause error) {
	in.cancel(cause)
	in.mu.Lock()
	st := in.stream
	in.mu.Unlock()
	if st != nil {
		_ = st.Close()
	}
}

var (
	errSuperseded = errors.New("对方重新发起了这一批")
	errIdle       = errors.New("数据流很久没有动静")
)

// failure 是收的过程中出的、要回给发送方的错误。
type failure struct {
	code  string // hash_mismatch / write_failed / dest_unavailable / bad_stream / no_space
	index int64
	err   error
}

func (f *failure) Error() string { return f.code + ": " + fmt.Sprint(f.err) }

func badStream(index int64, format string, args ...any) error {
	return &failure{code: "bad_stream", index: index, err: fmt.Errorf(format, args...)}
}

// writeFailure 包住写磁盘时的错误，与数据流本身断了区分开。
type writeFailure struct{ err error }

func (w *writeFailure) Error() string { return w.err.Error() }
func (w *writeFailure) Unwrap() error { return w.err }

func writeCode(err error) string {
	switch {
	case errors.Is(err, syscall.ENOSPC):
		return "no_space"
	case errors.Is(err, os.ErrNotExist), errors.Is(err, os.ErrPermission):
		return "dest_unavailable"
	}
	return "write_failed"
}

// handleOffer 决定收不收：检查开关、保存位置、空间，接受时给出从哪里开始。
func (e *Engine) handleOffer(from string, offer *pb.SendOffer) {
	p := e.opts.Peer(from)
	if !p.Known {
		return
	}
	id := offer.GetTransferId()
	answer := func(a *pb.SendAnswer) {
		a.TransferId, a.Attempt = id, offer.GetAttempt()
		_ = e.opts.Send(from, &pb.PeerMessage{Payload: &pb.PeerMessage_SendAnswer{SendAnswer: a}})
	}
	if err := validOffer(offer); err != nil {
		e.log.Warn("收到无效的隔空传送请求", "from", from, "err", err)
		answer(&pb.SendAnswer{Reason: "bad_offer"})
		return
	}
	cfg := e.opts.LoadConfig()
	if cfg.ReceiveDisabled {
		answer(&pb.SendAnswer{Reason: "disabled"})
		return
	}

	// 同一台设备一次只发一批：还挂着的旧接收一定是过时的（对方重启过或者重新发起了）
	e.mu.Lock()
	var stale []*incoming
	for _, in := range e.in {
		if in.device == from {
			stale = append(stale, in)
		}
	}
	e.mu.Unlock()
	for _, in := range stale {
		in.abort(errSuperseded)
		select {
		case <-in.done:
		case <-time.After(10 * time.Second):
		}
	}

	now := e.opts.Now()
	existing, getErr := e.opts.Store.GetTransfer(id)
	var t store.Transfer
	in := &incoming{id: id, device: from, attempt: offer.GetAttempt(), offer: offer,
		tops: map[string]bool{}, names: pack.NewNames(),
		streamCh: make(chan *p2p.Stream, 1), done: make(chan struct{})}
	for _, it := range offer.GetItems() {
		in.tops[it.GetName()] = true
	}

	switch {
	case offer.GetResume():
		if getErr != nil || existing.Direction != store.Incoming || existing.DeviceID != from ||
			store.TransferFinished(existing.Status) {
			answer(&pb.SendAnswer{Reason: "unknown_transfer"})
			return
		}
		t = existing
		in.dest = t.DestDir
		in.partial = filepath.Join(t.DestDir, partialDir, id)
		if _, err := os.Stat(in.partial); err != nil {
			e.finish(t, store.TransferExpired, "")
			answer(&pb.SendAnswer{Reason: "unknown_transfer"})
			return
		}
		if err := e.resumePoint(in); err != nil {
			e.log.Warn("计算续传位置失败", "transfer", id, "err", err)
			e.removePartial(t)
			e.finish(t, store.TransferExpired, "")
			answer(&pb.SendAnswer{Reason: "unknown_transfer"})
			return
		}
	default:
		if getErr == nil {
			if existing.Direction != store.Incoming || existing.DeviceID != from {
				answer(&pb.SendAnswer{Reason: "bad_offer"})
				return
			}
			// 对方从头再发同一批：丢掉以前收的
			e.removePartial(existing)
			_ = e.opts.Store.DeleteTransferEntries(id)
		}
		t = store.Transfer{ID: id, Direction: store.Incoming, DeviceID: from, CreatedAt: now}
		in.dest = cfg.EffectiveReceiveDir()
		in.partial = filepath.Join(in.dest, partialDir, id)
	}
	t.DeviceName = p.Name
	t.Items = itemsFromOffer(offer)
	t.TotalBytes, t.FileCount, t.DestDir = offer.GetTotalBytes(), offer.GetFileCount(), in.dest
	t.Relayed = p.Relayed

	// 保存位置、空间、单个文件的上限。保存位置的问题要让本机的用户也知道
	reject := func(code string, shortfall int64) {
		answer(&pb.SendAnswer{Reason: code, ShortfallBytes: shortfall})
		t.Shortfall = shortfall
		e.finish(t, store.TransferDeclined, code)
		e.notice(NoticeFailed, t)
	}
	if info, err := os.Stat(in.dest); err != nil || !info.IsDir() {
		reject("dest_unavailable", 0)
		return
	}
	if err := os.MkdirAll(in.partial, 0o755); err != nil {
		reject("dest_unavailable", 0)
		return
	}
	hideDir(filepath.Join(in.dest, partialDir))
	remaining := t.TotalBytes - in.doneBefore - in.resumeOffset
	if free, err := freeSpace(in.dest); err == nil && free < remaining+spaceReserve {
		if !offer.GetResume() {
			e.removePartial(t)
		}
		reject("no_space", remaining+spaceReserve-free)
		return
	}
	if offer.GetLargestFile() >= 4<<30 && fat32(in.dest) {
		if !offer.GetResume() {
			e.removePartial(t)
		}
		reject("file_too_large", 0)
		return
	}

	t.Status, t.Error, t.Shortfall = store.TransferWaiting, "", 0
	t.DoneBytes = in.doneBefore + in.resumeOffset
	t.FinishedAt = time.Time{}
	e.save(t)

	ctx, cancel := context.WithCancelCause(e.ctx)
	in.ctx, in.cancel = ctx, cancel
	e.mu.Lock()
	e.in[id] = in
	e.mu.Unlock()
	e.wg.Add(1)
	go func() {
		defer e.wg.Done()
		e.runIncoming(in, t)
	}()
	answer(&pb.SendAnswer{Accepted: true, ResumeIndex: in.resumeIndex, ResumeOffset: in.resumeOffset})
}

func validOffer(o *pb.SendOffer) error {
	id := o.GetTransferId()
	if len(id) == 0 || len(id) > 64 || strings.ContainsAny(id, `/\.:`) {
		return errors.New("传输 ID 不合法")
	}
	if o.GetTotalBytes() < 0 || o.GetFileCount() < 0 || o.GetAttempt() == 0 {
		return errors.New("大小不合法")
	}
	if n := len(o.GetItems()); n == 0 || n > 10000 {
		return errors.New("项目个数不合法")
	}
	for _, it := range o.GetItems() {
		name := it.GetName()
		if name == "" || name == "." || name == ".." || strings.ContainsAny(name, "/\x00") || len(name) > 1024 {
			return fmt.Errorf("名字不合法: %q", name)
		}
	}
	return nil
}

func itemsFromOffer(o *pb.SendOffer) []store.Item {
	items := make([]store.Item, len(o.GetItems()))
	for i, it := range o.GetItems() {
		items[i] = store.Item{Name: it.GetName(), Size: it.GetSize(), IsDir: it.GetIsDir()}
	}
	return items
}

// resumePoint 从记下的条目里找出第一个没收完的，核对磁盘上的实际大小，算出从哪里接着收。
func (e *Engine) resumePoint(in *incoming) error {
	var from int64
	for {
		batch, err := e.opts.Store.TransferEntries(in.id, from, 1000)
		if err != nil {
			return err
		}
		if len(batch) == 0 {
			in.resumeIndex = from
			return nil
		}
		for _, en := range batch {
			if en.Complete {
				in.names.Restore(en.Path, en.LocalPath, en.IsDir)
				if !en.IsDir && en.Link == "" {
					in.doneBefore += en.Size
					in.filesBefore++
				}
				continue
			}
			// 第一个没收完的条目：从它接着收，它后面不该再有记录
			in.resumeIndex = en.Index
			in.names.Restore(en.Path, en.LocalPath, en.IsDir)
			if !en.IsDir && en.Link == "" && en.LocalPath != "" {
				target, err := pack.SafeJoin(in.partial, filepath.FromSlash(en.LocalPath))
				if err != nil {
					return err
				}
				offset := en.DoneBytes
				if info, err := os.Stat(target); err != nil {
					offset = 0
				} else if info.Size() < offset {
					offset = info.Size()
				}
				if offset > en.Size {
					offset = 0
				}
				if err := os.Truncate(target, offset); err != nil && !errors.Is(err, os.ErrNotExist) {
					return err
				}
				in.resumeOffset = offset
			}
			return e.opts.Store.DeleteTransferEntriesFrom(in.id, en.Index+1)
		}
		from = batch[len(batch)-1].Index + 1
	}
}

// HandleStream 接管对端为隔空传送新开的数据通道。
func (e *Engine) HandleStream(from, label string, st *p2p.Stream) {
	rest := strings.TrimPrefix(label, streamPrefix)
	id, attempt, ok := strings.Cut(rest, ":")
	n, err := strconv.ParseUint(attempt, 10, 32)
	e.mu.Lock()
	in := e.in[id]
	e.mu.Unlock()
	if !ok || err != nil || in == nil || in.device != from || uint32(n) != in.attempt {
		e.log.Debug("收到对不上的隔空传送数据流，已丢弃", "label", label, "from", from)
		_ = st.Close()
		return
	}
	select {
	case in.streamCh <- st:
	default:
		_ = st.Close()
	}
}

// runIncoming 等数据流到来，收完整批，再按结果收尾。
func (e *Engine) runIncoming(in *incoming, t store.Transfer) {
	defer close(in.done)
	defer func() {
		e.mu.Lock()
		if e.in[in.id] == in {
			delete(e.in, in.id)
		}
		e.mu.Unlock()
	}()

	var st *p2p.Stream
	select {
	case st = <-in.streamCh:
	case <-in.ctx.Done():
		e.incomingStopped(in, t, context.Cause(in.ctx))
		return
	case <-time.After(e.opts.AnswerTimeout):
		e.interruptIncoming(in, t)
		return
	}
	in.mu.Lock()
	in.stream = st
	in.mu.Unlock()
	if in.ctx.Err() != nil {
		_ = st.Close()
		e.incomingStopped(in, t, context.Cause(in.ctx))
		return
	}

	t.Status = store.TransferActive
	e.save(t)
	e.setBusy(t.ID, true)

	// 看门狗：数据流很久没有新内容（连接悄悄断了）就当作中断
	in.active.Store(time.Now().UnixNano())
	watch := make(chan struct{})
	defer close(watch)
	go func() {
		tick := time.NewTicker(10 * time.Second)
		defer tick.Stop()
		for {
			select {
			case <-watch:
				return
			case <-tick.C:
				if time.Since(time.Unix(0, in.active.Load())) > 2*time.Minute {
					in.abort(errIdle)
					return
				}
			}
		}
	}()

	err := e.receive(in, t, st)
	_ = st.Close()
	if err == nil {
		return
	}
	if in.ctx.Err() != nil {
		e.incomingStopped(in, t, context.Cause(in.ctx))
		return
	}
	var f *failure
	if errors.As(err, &f) {
		e.log.Warn("接收失败", "transfer", t.ID, "err", err)
		_ = e.opts.Send(in.device, &pb.PeerMessage{Payload: &pb.PeerMessage_SendResult{SendResult: &pb.SendResult{
			TransferId: t.ID, Attempt: in.attempt, Error: f.code, FailedIndex: f.index}}})
		if f.code == "hash_mismatch" {
			// 发送方会从这个文件开始再发一次
			e.interruptIncoming(in, t)
			return
		}
		e.removePartial(t)
		e.finish(e.withProgress(t), store.TransferFailed, f.code)
		e.notice(NoticeFailed, t)
		return
	}
	e.log.Info("接收中断", "transfer", t.ID, "err", err)
	e.interruptIncoming(in, t)
}

func (e *Engine) interruptIncoming(in *incoming, t store.Transfer) {
	e.setBusy(t.ID, false)
	t = e.withProgress(t)
	t.Status = store.TransferInterrupted
	e.mu.Lock()
	delete(e.progress, t.ID)
	e.mu.Unlock()
	e.save(t)
}

func (e *Engine) incomingStopped(in *incoming, t store.Transfer, cause error) {
	var pc *peerCancel
	switch {
	case errors.Is(cause, errCancelled):
		_ = e.opts.Send(in.device, &pb.PeerMessage{Payload: &pb.PeerMessage_SendCancel{
			SendCancel: &pb.SendCancel{TransferId: t.ID, Reason: "cancelled"}}})
		e.removePartial(t)
		e.finish(e.withProgress(t), store.TransferCancelled, "cancelled")
	case errors.As(cause, &pc):
		e.removePartial(t)
		if r := pc.reason; r == "source_changed" || r == "source_missing" || r == "read_error" {
			e.finish(e.withProgress(t), store.TransferFailed, r)
			e.notice(NoticeFailed, t)
			return
		}
		e.finish(e.withProgress(t), store.TransferCancelled, "peer_cancelled")
	case errors.Is(cause, errSuperseded):
		e.setBusy(t.ID, false) // 新的一次接着用这条记录
	default:
		e.interruptIncoming(in, t)
	}
}

// receive 读帧流，把条目写进临时目录，读到结束帧后收尾。
func (e *Engine) receive(in *incoming, t store.Transfer, st *p2p.Stream) error {
	fr, err := pack.NewFrameReader(st.Reader())
	if err != nil {
		return err
	}
	defer fr.Close()

	m := e.meterFor(t)
	m.start(in.doneBefore + in.resumeOffset)
	next := in.resumeIndex
	declared := in.doneBefore + in.resumeOffset
	files := in.filesBefore
	safeDirs := map[string]bool{}
	for {
		f, err := fr.Next()
		if err != nil {
			return err
		}
		in.active.Store(time.Now().UnixNano())
		switch p := f.GetPayload().(type) {
		case *pb.SendFrame_End:
			return e.finalize(in, t)
		case *pb.SendFrame_File:
			fs := p.File
			if fs.GetIndex() != next {
				return badStream(next, "条目序号 %d，应为 %d", fs.GetIndex(), next)
			}
			wantOffset := int64(0)
			if next == in.resumeIndex {
				wantOffset = in.resumeOffset
			}
			if fs.GetOffset() != wantOffset || fs.GetSize() < 0 || fs.GetOffset() > fs.GetSize() {
				return badStream(next, "条目 %d 的位置不对", next)
			}
			top, _, _ := strings.Cut(fs.GetPath(), "/")
			if !in.tops[top] {
				return badStream(next, "条目 %q 不属于这一批", fs.GetPath())
			}
			// 收到的内容不能超出接受时对方声明的总量：空间是按它检查的
			if !fs.GetIsDir() && fs.GetLinkTarget() == "" {
				declared += fs.GetSize() - fs.GetOffset()
				files++
				if declared > in.offer.GetTotalBytes() || files > in.offer.GetFileCount() {
					return badStream(next, "内容超出了对方声明的大小")
				}
			}
			if err := e.receiveEntry(in, fr, fs, m, files, safeDirs); err != nil {
				return err
			}
			next++
		default:
			return badStream(next, "意外的帧")
		}
	}
}

// receiveEntry 落盘一个条目。
func (e *Engine) receiveEntry(in *incoming, fr *pack.FrameReader, fs *pb.SendFileStart, m *meter, ordinal int64, safeDirs map[string]bool) error {
	idx := fs.GetIndex()
	regular := !fs.GetIsDir() && fs.GetLinkTarget() == ""
	if pack.Skip(fs.GetPath()) {
		// Windows 上不落盘 .DS_Store 这类文件，但内容要读掉
		if regular {
			if err := e.discard(in, fr, fs, idx); err != nil {
				return err
			}
		}
		return e.opts.Store.PutReceivedEntry(in.id, store.TransferEntry{Index: idx, Path: fs.GetPath(),
			Size: fs.GetSize(), IsDir: fs.GetIsDir(), Complete: true})
	}

	local := ""
	if idx == in.resumeIndex {
		if rows, err := e.opts.Store.TransferEntries(in.id, idx, 1); err == nil && len(rows) == 1 && rows[0].Index == idx {
			local = rows[0].LocalPath
		}
	}
	if local == "" {
		var err error
		if local, err = in.names.Rel(fs.GetPath(), fs.GetIsDir()); err != nil {
			return badStream(idx, "%v", err)
		}
	}
	target, err := pack.SafeJoin(in.partial, filepath.FromSlash(local))
	if err != nil {
		return badStream(idx, "%v", err)
	}
	// 前面收到的符号链接不能被当成目录借道：a/link → /etc 之后再来 a/link/passwd
	if err := noLinkParents(in.partial, filepath.Dir(target), safeDirs); err != nil {
		return badStream(idx, "%v", err)
	}
	entry := store.TransferEntry{Index: idx, Path: fs.GetPath(), Size: fs.GetSize(), IsDir: fs.GetIsDir(),
		Mode: fs.GetMode(), MTime: fs.GetMtimeUnix(), Link: fs.GetLinkTarget(), LocalPath: local, DoneBytes: fs.GetOffset()}
	if err := e.opts.Store.PutReceivedEntry(in.id, entry); err != nil {
		return &failure{code: "write_failed", index: idx, err: err}
	}

	switch {
	case fs.GetIsDir():
		if err := os.MkdirAll(target, 0o755); err != nil {
			return &failure{code: writeCode(err), index: idx, err: err}
		}
	case fs.GetLinkTarget() != "":
		if runtime.GOOS != "windows" { // 普通用户在 Windows 上建不了符号链接，跳过这一个
			if err := os.MkdirAll(filepath.Dir(target), 0o755); err != nil {
				return &failure{code: writeCode(err), index: idx, err: err}
			}
			_ = os.Remove(target)
			if err := os.Symlink(fs.GetLinkTarget(), target); err != nil {
				e.log.Debug("建符号链接失败，跳过", "path", local, "err", err)
			}
		}
	default:
		m.setCurrent(fs.GetPath(), ordinal)
		if err := e.receiveFile(in, fr, fs, target, m); err != nil {
			return err
		}
		return nil // receiveFile 自己记下完成
	}
	return e.opts.Store.SetEntryProgress(in.id, idx, 0, true)
}

func (e *Engine) discard(in *incoming, fr *pack.FrameReader, fs *pb.SendFileStart, idx int64) error {
	if _, err := fr.CopyContent(io.Discard, sha256.New(), fs.GetSize()-fs.GetOffset()); err != nil {
		return err
	}
	end, err := fr.Next()
	if err != nil {
		return err
	}
	if end.GetFileEnd() == nil {
		return badStream(idx, "缺少文件结束帧")
	}
	return nil
}

// receiveFile 写一个普通文件，边写边算哈希，定期记下写到了哪里，最后核对整个文件的哈希。
func (e *Engine) receiveFile(in *incoming, fr *pack.FrameReader, fs *pb.SendFileStart, target string, m *meter) error {
	idx, offset, size := fs.GetIndex(), fs.GetOffset(), fs.GetSize()
	if err := os.MkdirAll(filepath.Dir(target), 0o755); err != nil {
		return &failure{code: writeCode(err), index: idx, err: err}
	}
	h := sha256.New()
	var f *os.File
	var err error
	if offset > 0 {
		// 续传：哈希要覆盖整个文件，已经收到的那一段从磁盘再读一遍
		rf, err := os.Open(target)
		if err != nil {
			return &failure{code: writeCode(err), index: idx, err: err}
		}
		_, err = io.CopyN(h, rf, offset)
		rf.Close()
		if err != nil {
			return &failure{code: "write_failed", index: idx, err: err}
		}
		f, err = os.OpenFile(target, os.O_WRONLY, 0)
		if err == nil {
			_, err = f.Seek(offset, io.SeekStart)
		}
	} else {
		perm := os.FileMode(fs.GetMode()).Perm()&^0o022 | 0o600
		f, err = os.OpenFile(target, os.O_CREATE|os.O_WRONLY|os.O_TRUNC, perm)
	}
	if err != nil {
		if f != nil {
			f.Close()
		}
		return &failure{code: writeCode(err), index: idx, err: err}
	}

	written := int64(0)
	checkpoint, lastCheck := int64(0), time.Now()
	w := &progressWriter{f: f, onWrite: func(n int) {
		written += int64(n)
		m.add(int64(n))
		in.active.Store(time.Now().UnixNano())
		if written-checkpoint >= checkpointBytes || time.Since(lastCheck) >= checkpointInterval {
			checkpoint, lastCheck = written, time.Now()
			_ = e.opts.Store.SetEntryProgress(in.id, idx, offset+written, false)
		}
	}}
	_, err = fr.CopyContent(w, h, size-offset)
	if err != nil {
		f.Close()
		_ = e.opts.Store.SetEntryProgress(in.id, idx, offset+written, false)
		var wf *writeFailure
		if errors.As(err, &wf) {
			return &failure{code: writeCode(wf.err), index: idx, err: wf.err}
		}
		return err
	}
	if err := f.Close(); err != nil {
		return &failure{code: writeCode(err), index: idx, err: err}
	}
	end, err := fr.Next()
	if err != nil {
		_ = e.opts.Store.SetEntryProgress(in.id, idx, size, false)
		return err
	}
	fe := end.GetFileEnd()
	if fe == nil {
		return badStream(idx, "缺少文件结束帧")
	}
	if got := h.Sum(nil); string(got) != string(fe.GetSha256()) {
		_ = os.Remove(target)
		_ = e.opts.Store.SetEntryProgress(in.id, idx, 0, false)
		return &failure{code: "hash_mismatch", index: idx, err: fmt.Errorf("%s 的校验和不对", fs.GetPath())}
	}
	if mt := fs.GetMtimeUnix(); mt > 0 {
		_ = os.Chtimes(target, time.Now(), time.Unix(mt, 0))
	}
	return e.opts.Store.SetEntryProgress(in.id, idx, size, true)
}

type progressWriter struct {
	f       *os.File
	onWrite func(int)
}

func (w *progressWriter) Write(p []byte) (int, error) {
	n, err := w.f.Write(p)
	if n > 0 {
		w.onWrite(n)
	}
	if err != nil {
		return n, &writeFailure{err}
	}
	return n, nil
}

// noLinkParents 确认从 base 到 dir 的每一级都不是符号链接。
func noLinkParents(base, dir string, checked map[string]bool) error {
	rel, err := filepath.Rel(base, dir)
	if err != nil || rel == "." {
		return err
	}
	cur := base
	for _, part := range strings.Split(rel, string(filepath.Separator)) {
		cur = filepath.Join(cur, part)
		if checked[cur] {
			continue
		}
		info, err := os.Lstat(cur)
		if err != nil {
			if errors.Is(err, os.ErrNotExist) {
				return nil // 还没建，下面也不会有链接
			}
			return err
		}
		if info.Mode()&os.ModeSymlink != 0 {
			return fmt.Errorf("路径经过符号链接: %s", cur)
		}
		checked[cur] = true
	}
	return nil
}

// finalize 把收完的顶层项目从临时目录移到保存位置（重名就改名），回告对方。
func (e *Engine) finalize(in *incoming, t store.Transfer) error {
	var tops []store.TransferEntry
	for from := int64(0); ; {
		batch, err := e.opts.Store.TransferEntries(in.id, from, 1000)
		if err != nil {
			return &failure{code: "write_failed", err: err}
		}
		if len(batch) == 0 {
			break
		}
		for _, en := range batch {
			if !en.Complete {
				return badStream(en.Index, "%s 没有收完", en.Path)
			}
			if !strings.Contains(en.Path, "/") && en.LocalPath != "" {
				tops = append(tops, en)
			}
		}
		from = batch[len(batch)-1].Index + 1
	}

	sizes := map[string]int64{}
	for _, it := range in.offer.GetItems() {
		sizes[it.GetName()] = it.GetSize()
	}
	var items []store.Item
	var finals []string
	for _, top := range tops {
		src := filepath.Join(in.partial, filepath.FromSlash(top.LocalPath))
		dst := claimDest(in.dest, path.Base(top.LocalPath), top.IsDir)
		if err := os.Rename(src, dst); err != nil {
			return &failure{code: writeCode(err), index: top.Index, err: err}
		}
		markQuarantine(dst)
		finals = append(finals, dst)
		items = append(items, store.Item{Name: filepath.Base(dst), Size: sizes[top.Path], IsDir: top.IsDir})
	}
	_ = os.RemoveAll(in.partial)
	_ = os.Remove(filepath.Join(in.dest, partialDir)) // 空了才删得掉

	t = e.withProgress(t)
	t.Items, t.Paths, t.DoneBytes = items, finals, t.TotalBytes
	e.finish(t, store.TransferDone, "")
	_ = e.opts.Send(in.device, &pb.PeerMessage{Payload: &pb.PeerMessage_SendResult{SendResult: &pb.SendResult{
		TransferId: t.ID, Attempt: in.attempt, Ok: true}}})
	e.log.Info("隔空传送已收到", "transfer", t.ID, "from", in.device, "字节", t.TotalBytes, "到", in.dest)
	e.notice(NoticeReceived, t)
	return nil
}

// claimDest 在保存位置里找一个不重名的名字：「报告.pdf」已有就用「报告 (2).pdf」。
func claimDest(dir, name string, isDir bool) string {
	ext := filepath.Ext(name)
	stem := strings.TrimSuffix(name, ext)
	if isDir || stem == "" {
		stem, ext = name, ""
	}
	candidate := filepath.Join(dir, name)
	for n := 2; ; n++ {
		if _, err := os.Lstat(candidate); errors.Is(err, os.ErrNotExist) {
			return candidate
		}
		candidate = filepath.Join(dir, fmt.Sprintf("%s (%d)%s", stem, n, ext))
	}
}

// removePartial 删掉一批没收完的部分。
func (e *Engine) removePartial(t store.Transfer) {
	if t.Direction != store.Incoming || t.DestDir == "" {
		return
	}
	_ = os.RemoveAll(filepath.Join(t.DestDir, partialDir, t.ID))
	_ = os.Remove(filepath.Join(t.DestDir, partialDir))
}
