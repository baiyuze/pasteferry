package rpc

import (
	"context"
	"strings"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// WebShare 是手机网页传输，见 internal/webshare 与 design/phone-sync.md 第 2 节。
type WebShare interface {
	Status() *pb.WebShareStatus
	NewInvite(address string) (*pb.WebShareInvite, error)
	CloseInvite(id string)
	RemoveSession(id string) error
}

func EventWebShareChanged(st *pb.WebShareStatus) *pb.Event {
	return &pb.Event{Payload: &pb.Event_WebShareChanged{WebShareChanged: st}}
}

func (s *Server) webShare() (WebShare, error) {
	if s.deps.WebShare == nil {
		return nil, status.Error(codes.Unimplemented, "web share unavailable")
	}
	return s.deps.WebShare, nil
}

func (s *Server) GetWebShare(context.Context, *pb.Empty) (*pb.WebShareStatus, error) {
	w, err := s.webShare()
	if err != nil {
		return nil, err
	}
	return w.Status(), nil
}

// SetWebShare 改的是配置里的开关；daemon 保存配置时据此开始或停止监听（见 SaveConfig）。
func (s *Server) SetWebShare(_ context.Context, req *pb.SetWebShareRequest) (*pb.WebShareStatus, error) {
	w, err := s.webShare()
	if err != nil {
		return nil, err
	}
	cfg := s.deps.LoadConfig()
	if cfg.WebShareEnabled != req.GetEnabled() {
		cfg.WebShareEnabled = req.GetEnabled()
		if err := s.deps.SaveConfig(cfg); err != nil {
			return nil, status.Error(codes.Internal, err.Error())
		}
	}
	return w.Status(), nil
}

func (s *Server) NewWebShareInvite(_ context.Context, req *pb.NewWebShareInviteRequest) (*pb.WebShareInvite, error) {
	w, err := s.webShare()
	if err != nil {
		return nil, err
	}
	inv, err := w.NewInvite(req.GetAddress())
	if err != nil {
		return nil, status.Error(codes.FailedPrecondition, err.Error())
	}
	return inv, nil
}

func (s *Server) CloseWebShareInvite(_ context.Context, req *pb.WebShareInviteRef) (*pb.Empty, error) {
	w, err := s.webShare()
	if err != nil {
		return nil, err
	}
	w.CloseInvite(req.GetId())
	return &pb.Empty{}, nil
}

func (s *Server) RemoveWebSession(_ context.Context, req *pb.WebSessionRef) (*pb.WebShareStatus, error) {
	w, err := s.webShare()
	if err != nil {
		return nil, err
	}
	if err := w.RemoveSession(req.GetId()); err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}
	return w.Status(), nil
}

func (s *Server) SubmitText(ctx context.Context, req *pb.SubmitTextRequest) (*pb.ClipRecord, error) {
	if s.deps.SubmitText == nil {
		return nil, status.Error(codes.Unimplemented, "submit text unavailable")
	}
	if strings.TrimSpace(req.GetText()) == "" {
		return nil, status.Error(codes.InvalidArgument, "没有要发送的文字")
	}
	clip, err := s.deps.SubmitText(ctx, req.GetText())
	if err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}
	return clipToProto(clip), nil
}
