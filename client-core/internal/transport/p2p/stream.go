package p2p

import (
	"io"
	"sync"

	"github.com/pion/webrtc/v4"
)

// 队列深度约 256 个分片（≈15 MiB）。足以吸收消费侧（解压+落盘）的抖动，
// 又不至于让内存失控；满了之后回调自然阻塞，背压经 SCTP 传导回发送方。
const streamQueueDepth = 256

// Stream 包住一条用于传输内容的 DataChannel，解决两个致命问题。
//
// 其一是时序：pion 的 DataChannel.OnMessage 只是记下一个 handler，在它被
// 设置之前到达的消息会被直接丢弃、不做缓冲。而 OnDataChannel 回调返回后，
// 上层还要查表、建管道才能挂上接收逻辑——这中间的几毫秒足以让一个小文件的
// 全部内容凭空消失（实测：发送方 202 字节，接收方 0 字节）。
//
// 其二是顺序：任何"先缓冲、后回放"的写法都要小心，一旦回放期间有新消息
// 直抵 handler，就会排到旧消息前面，把 zstd 流彻底搞乱。
//
// 这里用一个队列同时解决两者：OnMessage 在 OnDataChannel 回调中当场挂上，
// 只负责入队；消费者从队列按序取用。入队顺序即到达顺序，不存在插队。
//
// 本端主动关闭（Close）时，pion 可能正在回调里往队列送新到的分片：
// 先关 stop 让卡在队列上的回调退出，再在写锁下关队列；回调在读锁下、确认没关过才送，
// 不会往已关闭的队列里写（那会 panic，整个后台服务跟着退出）。
type Stream struct {
	dc    *webrtc.DataChannel
	queue chan []byte
	stop  chan struct{}

	mu        sync.RWMutex
	closed    bool
	closeOnce sync.Once
}

// NewStream 立即开始接收消息。必须在 OnDataChannel 回调中同步调用。
func NewStream(dc *webrtc.DataChannel) *Stream {
	s := &Stream{
		dc:    dc,
		queue: make(chan []byte, streamQueueDepth),
		stop:  make(chan struct{}),
	}

	dc.OnMessage(func(msg webrtc.DataChannelMessage) {
		// 必须复制：pion 复用底层缓冲，留着原切片会被后续消息覆盖
		chunk := make([]byte, len(msg.Data))
		copy(chunk, msg.Data)
		s.mu.RLock()
		defer s.mu.RUnlock()
		if s.closed {
			return
		}
		select {
		case s.queue <- chunk:
		case <-s.stop: // 本端已经不要了
		}
	})

	dc.OnClose(func() { s.finish() })

	return s
}

// Chunks 返回按到达顺序排列的数据分片。
// 通道在对端关闭数据流后关闭，消费者据此得知传输结束。
func (s *Stream) Chunks() <-chan []byte { return s.queue }

// Reader 把分片拼回连续的字节流。对端关闭数据流后读到 io.EOF；
// 消费者自己判断内容是否完整（隔空传送靠帧流末尾的 end 帧）。
func (s *Stream) Reader() io.Reader { return &streamReader{chunks: s.queue} }

type streamReader struct {
	chunks <-chan []byte
	buf    []byte
}

func (r *streamReader) Read(p []byte) (int, error) {
	for len(r.buf) == 0 {
		chunk, ok := <-r.chunks
		if !ok {
			return 0, io.EOF
		}
		r.buf = chunk
	}
	n := copy(p, r.buf)
	r.buf = r.buf[n:]
	return n, nil
}

func (s *Stream) Label() string { return s.dc.Label() }

func (s *Stream) ReadyState() webrtc.DataChannelState { return s.dc.ReadyState() }

// Close 关闭底层通道。队列会在 OnClose 中随之关闭。
func (s *Stream) Close() error {
	err := s.dc.Close()
	s.finish()
	return err
}

func (s *Stream) finish() {
	s.closeOnce.Do(func() {
		close(s.stop)
		s.mu.Lock()
		s.closed = true
		close(s.queue)
		s.mu.Unlock()
	})
}
