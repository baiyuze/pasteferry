package rpc

import (
	"context"
	"errors"
	"io"
	"sync"

	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"

	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// quickPaste 记着快捷粘贴窗口的连接：它在 QuickPasteSession 里往上报状态、往下收命令。
// 界面与快捷窗口之间不直接通信，设置页读状态、发命令都经过这里。
type quickPaste struct {
	mu     sync.Mutex
	id     int // 当前连接的编号，0 表示没有连接
	nextID int
	cmds   chan *pb.QuickPasteCommand
	status *pb.QuickPasteStatus
}

// attach 登记一条新的连接。快捷窗口重启时新连接可能先于旧连接断开到达，以新的为准。
func (q *quickPaste) attach() (int, chan *pb.QuickPasteCommand) {
	q.mu.Lock()
	defer q.mu.Unlock()
	q.nextID++
	q.id = q.nextID
	q.cmds = make(chan *pb.QuickPasteCommand, 8)
	q.status = &pb.QuickPasteStatus{Running: true}
	return q.id, q.cmds
}

// update 记下连接 id 报上来的状态，返回是否有变化。旧连接报的不算。
func (q *quickPaste) update(id int, st *pb.QuickPasteStatus) (*pb.QuickPasteStatus, bool) {
	q.mu.Lock()
	defer q.mu.Unlock()
	if id != q.id {
		return nil, false
	}
	st = proto.Clone(st).(*pb.QuickPasteStatus)
	st.Running = true
	if proto.Equal(st, q.status) {
		return nil, false
	}
	q.status = st
	return proto.Clone(st).(*pb.QuickPasteStatus), true
}

// detach 在连接 id 断开时调用，返回快捷窗口是否因此算作没在运行。
func (q *quickPaste) detach(id int) bool {
	q.mu.Lock()
	defer q.mu.Unlock()
	if id != q.id {
		return false
	}
	q.id, q.cmds, q.status = 0, nil, nil
	return true
}

func (q *quickPaste) current() *pb.QuickPasteStatus {
	q.mu.Lock()
	defer q.mu.Unlock()
	if q.status == nil {
		return &pb.QuickPasteStatus{}
	}
	return proto.Clone(q.status).(*pb.QuickPasteStatus)
}

func (q *quickPaste) send(c *pb.QuickPasteCommand) bool {
	q.mu.Lock()
	defer q.mu.Unlock()
	if q.cmds == nil {
		return false
	}
	select {
	case q.cmds <- c:
		return true
	default:
		return false // 快捷窗口一直没取走命令，多半卡住了
	}
}

func EventQuickPasteChanged(s *pb.QuickPasteStatus) *pb.Event {
	return &pb.Event{Payload: &pb.Event_QuickPasteChanged{QuickPasteChanged: s}}
}

func EventConfigChanged(c *pb.Config) *pb.Event {
	return &pb.Event{Payload: &pb.Event_ConfigChanged{ConfigChanged: c}}
}

// QuickPasteSession 由快捷窗口进程调用，一直保持到它退出。
func (s *Server) QuickPasteSession(stream grpc.BidiStreamingServer[pb.QuickPasteStatus, pb.QuickPasteCommand]) error {
	id, cmds := s.quickPaste.attach()
	s.hub.Publish(EventQuickPasteChanged(s.quickPaste.current()))
	defer func() {
		if s.quickPaste.detach(id) {
			s.hub.Publish(EventQuickPasteChanged(&pb.QuickPasteStatus{}))
		}
	}()

	recvErr := make(chan error, 1)
	go func() {
		for {
			st, err := stream.Recv()
			if err != nil {
				recvErr <- err
				return
			}
			if changed, ok := s.quickPaste.update(id, st); ok {
				s.hub.Publish(EventQuickPasteChanged(changed))
			}
		}
	}()

	for {
		select {
		case <-stream.Context().Done():
			return nil
		case err := <-recvErr:
			if errors.Is(err, io.EOF) {
				return nil
			}
			return err
		case c := <-cmds:
			if err := stream.Send(c); err != nil {
				return err
			}
		}
	}
}

func (s *Server) GetQuickPasteStatus(_ context.Context, _ *pb.Empty) (*pb.QuickPasteStatus, error) {
	return s.quickPaste.current(), nil
}

func (s *Server) SendQuickPasteCommand(_ context.Context, c *pb.QuickPasteCommand) (*pb.Empty, error) {
	if !s.quickPaste.send(c) {
		return nil, status.Error(codes.FailedPrecondition, "快捷粘贴窗口没有运行")
	}
	return &pb.Empty{}, nil
}
