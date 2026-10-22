package send

import (
	"context"
	"errors"
	"io"
	"sync"
	"time"

	"github.com/pion/webrtc/v4"

	"github.com/baiyuze/pasteferry/client-core/internal/transport/p2p"
)

// 文件数据走的管道有两种：WebRTC 数据通道（一直都有），和局域网 TCP 快速通道（2.5.1，见 lantcp）。
// 帧流只认读写，换管道时组帧、续传、校验、进度都不用动；控制消息始终走控制通道。

// lanDialTimeout 是试局域网 TCP 的时限，超过就退回数据通道
const lanDialTimeout = 2 * time.Second

// sendPipe 是发送方写帧流的管道。
type sendPipe interface {
	io.Writer
	// finish 在写完结束帧后调用，保证数据都送到了对方
	finish(ctx context.Context) error
	Close() error
}

// dcPipe 是数据通道：写入经 ChunkWriter 分块并按发送缓冲限速。
type dcPipe struct {
	dc *webrtc.DataChannel
	cw *p2p.ChunkWriter
}

func (p *dcPipe) Write(b []byte) (int, error) { return p.cw.Write(b) }

func (p *dcPipe) finish(ctx context.Context) error {
	if err := p.cw.Flush(); err != nil {
		return err
	}
	// 等发送缓冲排空再关通道，否则尾部数据会被丢掉
	return p.cw.WaitDrained(ctx, time.Minute)
}

func (p *dcPipe) Close() error { return p.dc.Close() }

// tcpPipe 是局域网 TCP：内核负责送达，写完以后关掉写方向即可。
type tcpPipe struct {
	io.WriteCloser
}

func (p *tcpPipe) finish(context.Context) error {
	if cw, ok := p.WriteCloser.(interface{ CloseWrite() error }); ok {
		return cw.CloseWrite()
	}
	return nil
}

// openPipe 开这次尝试的管道：对方给了局域网地址就先试 TCP，不行再开数据通道。
func (e *Engine) openPipe(ctx context.Context, t sendTarget, lanAddr string) (sendPipe, error) {
	if lanAddr != "" && e.opts.DialLAN != nil {
		dctx, cancel := context.WithTimeout(ctx, lanDialTimeout)
		c, err := e.opts.DialLAN(dctx, t.device, lanAddr, t.label)
		cancel()
		if err == nil {
			e.log.Info("隔空传送走局域网快速通道", "transfer", t.id, "addr", lanAddr)
			return &tcpPipe{c}, nil
		}
		if ctx.Err() != nil {
			return nil, ctx.Err()
		}
		e.log.Info("局域网快速通道连不上，改用数据通道", "transfer", t.id, "addr", lanAddr, "err", err)
	}
	return e.openDataChannel(ctx, t)
}

// sendTarget 是开管道需要的信息。
type sendTarget struct {
	id, device, label string
}

// openDataChannel 开一条数据通道并等它打开。
func (e *Engine) openDataChannel(ctx context.Context, t sendTarget) (sendPipe, error) {
	dc, err := e.opts.OpenStream(t.device, t.label)
	if err != nil {
		return nil, err
	}
	opened := make(chan struct{})
	var once sync.Once
	dc.OnOpen(func() { once.Do(func() { close(opened) }) })
	if dc.ReadyState() == webrtc.DataChannelStateOpen {
		once.Do(func() { close(opened) })
	}
	select {
	case <-opened:
	case <-ctx.Done():
		_ = dc.Close()
		return nil, ctx.Err()
	case <-time.After(e.opts.AnswerTimeout):
		_ = dc.Close()
		return nil, errors.New("数据流打开超时")
	}
	return &dcPipe{dc: dc, cw: p2p.NewChunkWriter(dc, nil)}, nil
}

// dcStream 把收到的数据通道包成接收方要的读取接口。
type dcStream struct {
	st *p2p.Stream
	r  io.Reader
}

func newDCStream(st *p2p.Stream) *dcStream { return &dcStream{st: st, r: st.Reader()} }

func (s *dcStream) Read(b []byte) (int, error) { return s.r.Read(b) }
func (s *dcStream) Close() error               { return s.st.Close() }

// listenLAN 在条件满足时为这次尝试开局域网 TCP 端口，返回写进应答里的地址；不满足时返回空。
// 端口只接一次连接，最晚在应答超时后关掉；先到的是数据通道也没关系，后到的那条会被丢弃。
func (e *Engine) listenLAN(in *incoming) string {
	if e.opts.ListenLAN == nil {
		return ""
	}
	addr, accept, ok := e.opts.ListenLAN(in.device)
	if !ok {
		return ""
	}
	ctx, cancel := context.WithTimeout(in.ctx, e.opts.AnswerTimeout)
	e.wg.Add(1)
	go func() {
		defer e.wg.Done()
		defer cancel()
		c, label, err := accept(ctx)
		if err != nil {
			return
		}
		e.deliverStream(in.device, label, c)
	}()
	return addr
}
