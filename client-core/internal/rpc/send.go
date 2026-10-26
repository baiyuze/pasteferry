package rpc

import (
	"context"
	"errors"
	"time"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/baiyuze/pasteferry/client-core/internal/send"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// Transfers 是隔空传送，见 internal/send。
type Transfers interface {
	SendFiles(deviceID string, paths []string, allowRelay bool, note string) (*pb.Transfer, error)
	// Answer 是本机用户接受或拒绝别人发来的一批，返回发来的设备与它的角色
	Answer(id string, accept bool) (deviceID, role string, err error)
	Cancel(id string) error
	Resume(id string) error
	List(dir pb.TransferDirection, limit int, before time.Time) ([]*pb.Transfer, error)
	Delete(ids []string, all bool, dir pb.TransferDirection) error
	MarkSeen() error
	CheckDir(path string) *pb.CheckReceiveDirResponse
}

func EventTransferChanged(t *pb.Transfer) *pb.Event {
	return &pb.Event{Payload: &pb.Event_TransferChanged{TransferChanged: t}}
}

func EventTransferRemoved(id string) *pb.Event {
	return &pb.Event{Payload: &pb.Event_TransferRemoved{TransferRemoved: id}}
}

// transferError 把隔空传送的错误转成状态码；消息是固定代码，界面按它显示文案。
func transferError(err error) error {
	switch {
	case errors.Is(err, send.ErrNoPaths), errors.Is(err, send.ErrBadNote):
		return status.Error(codes.InvalidArgument, err.Error())
	case errors.Is(err, send.ErrNotFound), errors.Is(err, send.ErrUnknownDevice):
		return status.Error(codes.NotFound, err.Error())
	case errors.Is(err, send.ErrOffline), errors.Is(err, send.ErrUnsupported), errors.Is(err, send.ErrPeerDisabled),
		errors.Is(err, send.ErrNeedRelayConsent), errors.Is(err, send.ErrNotResumable):
		return status.Error(codes.FailedPrecondition, err.Error())
	}
	return status.Error(codes.Internal, err.Error())
}

func (s *Server) transfers() (Transfers, error) {
	if s.deps.Transfers == nil {
		return nil, status.Error(codes.Unimplemented, "隔空传送不可用")
	}
	return s.deps.Transfers, nil
}

func (s *Server) SendFiles(_ context.Context, req *pb.SendFilesRequest) (*pb.Transfer, error) {
	t, err := s.transfers()
	if err != nil {
		return nil, err
	}
	out, err := t.SendFiles(req.GetDeviceId(), req.GetPaths(), req.GetAllowRelay(), req.GetNote())
	if err != nil {
		return nil, transferError(err)
	}
	return out, nil
}

func (s *Server) CancelTransfer(_ context.Context, req *pb.TransferRef) (*pb.Empty, error) {
	t, err := s.transfers()
	if err != nil {
		return nil, err
	}
	if err := t.Cancel(req.GetId()); err != nil {
		return nil, transferError(err)
	}
	return &pb.Empty{}, nil
}

func (s *Server) ResumeTransfer(_ context.Context, req *pb.TransferRef) (*pb.Empty, error) {
	t, err := s.transfers()
	if err != nil {
		return nil, err
	}
	if err := t.Resume(req.GetId()); err != nil {
		return nil, transferError(err)
	}
	return &pb.Empty{}, nil
}

func (s *Server) ListTransfers(_ context.Context, req *pb.ListTransfersRequest) (*pb.ListTransfersResponse, error) {
	t, err := s.transfers()
	if err != nil {
		return nil, err
	}
	var before time.Time
	if req.GetBeforeUnix() > 0 {
		before = time.Unix(req.GetBeforeUnix(), 0)
	}
	list, err := t.List(req.GetDirection(), int(req.GetLimit()), before)
	if err != nil {
		return nil, transferError(err)
	}
	return &pb.ListTransfersResponse{Transfers: list}, nil
}

func (s *Server) DeleteTransfers(_ context.Context, req *pb.DeleteTransfersRequest) (*pb.Empty, error) {
	t, err := s.transfers()
	if err != nil {
		return nil, err
	}
	if err := t.Delete(req.GetIds(), req.GetAll(), req.GetDirection()); err != nil {
		return nil, transferError(err)
	}
	return &pb.Empty{}, nil
}

func (s *Server) MarkTransfersSeen(context.Context, *pb.Empty) (*pb.Empty, error) {
	t, err := s.transfers()
	if err != nil {
		return nil, err
	}
	if err := t.MarkSeen(); err != nil {
		return nil, transferError(err)
	}
	return &pb.Empty{}, nil
}

func (s *Server) CheckReceiveDir(_ context.Context, req *pb.CheckReceiveDirRequest) (*pb.CheckReceiveDirResponse, error) {
	t, err := s.transfers()
	if err != nil {
		return nil, err
	}
	return t.CheckDir(req.GetPath()), nil
}
