package p2p

import (
	"context"
	"errors"
	"sync"
	"time"

	"github.com/pion/webrtc/v4"
)

// 文件传输的数据流（复制同步与隔空传送共用）：分片的大小与发送缓冲的水位。
const (
	// DataChannel 单条消息的上限。SCTP 对过大的消息支持参差，
	// 64 KiB 是各实现都稳妥的取值。
	ChunkSize = 60 * 1024
	// 发送缓冲超过此值就暂停读取源文件，等它降下来再继续。
	// 没有背压的话，传大文件会把内存吃光。
	bufferHighWater = 1 << 20 // 1 MiB
)

// ChunkWriter 把连续字节流切成 DataChannel 能承受的小块并施加背压。
//
// 两件事缺一不可：
//  1. 分片——SCTP 对超大消息的支持在各实现间差异很大，60 KiB 是稳妥值；
//  2. 背压——不管发送缓冲直接灌数据，传大文件会把内存吃光。
//     缓冲超过高水位时暂停读取源文件，等它回落再继续。
type ChunkWriter struct {
	dc         *webrtc.DataChannel
	onProgress func(sent int64)

	buf  []byte
	sent int64

	mu  sync.Mutex
	err error
}

// NewChunkWriter 包住一条刚打开的数据通道。onProgress 在每发出一个分片后收到累计字节数，可以为 nil。
func NewChunkWriter(dc *webrtc.DataChannel, onProgress func(int64)) *ChunkWriter {
	w := &ChunkWriter{
		dc:         dc,
		onProgress: onProgress,
		buf:        make([]byte, 0, ChunkSize),
	}
	dc.OnError(func(err error) {
		w.mu.Lock()
		w.err = err
		w.mu.Unlock()
	})
	return w
}

func (w *ChunkWriter) Write(p []byte) (int, error) {
	total := len(p)
	for len(p) > 0 {
		space := ChunkSize - len(w.buf)
		n := min(space, len(p))
		w.buf = append(w.buf, p[:n]...)
		p = p[n:]

		if len(w.buf) >= ChunkSize {
			if err := w.flushChunk(); err != nil {
				return total - len(p), err
			}
		}
	}
	return total, nil
}

func (w *ChunkWriter) Flush() error {
	if len(w.buf) == 0 {
		return nil
	}
	return w.flushChunk()
}

func (w *ChunkWriter) flushChunk() error {
	if err := w.waitForBuffer(); err != nil {
		return err
	}
	if w.dc.ReadyState() != webrtc.DataChannelStateOpen {
		return errors.New("数据通道已关闭")
	}
	if err := w.dc.Send(w.buf); err != nil {
		return err
	}
	w.sent += int64(len(w.buf))
	w.buf = w.buf[:0]

	if w.onProgress != nil {
		w.onProgress(w.sent)
	}
	return nil
}

// waitForBuffer 在发送缓冲积压过多时等待它回落。
//
// 刻意用轮询而非 OnBufferedAmountLow 回调：那个回调是边沿触发的，
// 若缓冲在等待方进入 Wait 之前就已降到阈值以下，回调早已发生过，
// 等待就再也等不到唤醒——传 20 MB 文件时实测会卡死在 786 KB 处。
// 2 ms 的轮询间隔对文件传输而言开销可忽略，却彻底消除了丢失唤醒。
func (w *ChunkWriter) waitForBuffer() error {
	const (
		pollInterval = 2 * time.Millisecond
		maxWait      = 2 * time.Minute
	)
	deadline := time.Now().Add(maxWait)

	for w.dc.BufferedAmount() >= bufferHighWater {
		w.mu.Lock()
		err := w.err
		w.mu.Unlock()
		if err != nil {
			return err
		}
		if w.dc.ReadyState() != webrtc.DataChannelStateOpen {
			return errors.New("数据通道在传输中被关闭")
		}
		if time.Now().After(deadline) {
			return errors.New("等待发送缓冲排空超时")
		}
		time.Sleep(pollInterval)
	}
	return nil
}

// WaitDrained 等待发送缓冲彻底排空。
//
// 数据通道一关，尚未发出的数据就丢了；关闭前必须确认本地缓冲已清空。
// 排不空说明对端没在接收（连接多半已经断了），返回错误，不能当作发送成功。
func (w *ChunkWriter) WaitDrained(ctx context.Context, timeout time.Duration) error {
	deadline := time.Now().Add(timeout)
	for {
		if w.dc.BufferedAmount() == 0 {
			return nil
		}
		if w.dc.ReadyState() != webrtc.DataChannelStateOpen {
			return nil // 对端收完后可能先关通道，此时缓冲计数未必已归零
		}
		if time.Now().After(deadline) {
			return errors.New("对端迟迟没有收完，连接可能已经中断")
		}
		select {
		case <-ctx.Done():
			return ctx.Err()
		case <-time.After(5 * time.Millisecond):
		}
	}
}

func (w *ChunkWriter) Sent() int64 { return w.sent }
