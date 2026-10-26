package rpc

import (
	"context"
	"errors"
	"time"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/baiyuze/pasteferry/client-core/internal/peers"
	"github.com/baiyuze/pasteferry/client-core/internal/profile"
	"github.com/baiyuze/pasteferry/client-core/internal/send"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// Friends 是好友，见 design/friends-send.md。由 daemon 把 peers.Manager 与 profile.Profile 拼起来提供。
type Friends interface {
	Profile() *pb.Profile
	SetDisplayName(name string) (*pb.Profile, error)
	SetAvatar(req *pb.SetAvatarRequest) (*pb.Profile, error)
	ResetAvatar() (*pb.Profile, error)
	Avatar(deviceID string) *pb.Avatar
	CreateFriendCode(ctx context.Context) (code string, expiresAt time.Time, lanAddrs []string, err error)
	RedeemFriendCode(ctx context.Context, code, address string) (*pb.FriendRequest, error)
	ConfirmFriend(ctx context.Context, session string, accept bool) error
	Friends() []*pb.Friend
	RemoveFriend(ctx context.Context, deviceID string) error
	SetFriendAutoAccept(deviceID string, auto bool) (*pb.Friend, error)
	BlockDevice(deviceID string) error
	WatchStrangers(ctx context.Context, send func(*pb.Strangers) error) error
	PasteFiles(ctx context.Context) (*pb.PasteFilesResponse, error)
}

func EventFriendChanged(f *pb.Friend) *pb.Event {
	return &pb.Event{Payload: &pb.Event_FriendChanged{FriendChanged: f}}
}

func EventFriendRemoved(id string) *pb.Event {
	return &pb.Event{Payload: &pb.Event_FriendRemoved{FriendRemoved: id}}
}

func EventFriendRequest(r *pb.FriendRequest) *pb.Event {
	return &pb.Event{Payload: &pb.Event_FriendRequest{FriendRequest: r}}
}

func EventProfileChanged(p *pb.Profile) *pb.Event {
	return &pb.Event{Payload: &pb.Event_ProfileChanged{ProfileChanged: p}}
}

func (s *Server) friends() (Friends, error) {
	if s.deps.Friends == nil {
		return nil, status.Error(codes.Unimplemented, "好友不可用")
	}
	return s.deps.Friends, nil
}

// friendError 把好友相关的错误转成状态码。加好友的错误与配对的相同（「原因: 说明」），界面按原因显示文案
func friendError(err error) error {
	switch {
	case errors.Is(err, peers.ErrNotFriend), errors.Is(err, peers.ErrSessionUnknown):
		return status.Error(codes.NotFound, err.Error())
	case errors.Is(err, profile.ErrBadName), errors.Is(err, profile.ErrNotImage):
		return status.Error(codes.InvalidArgument, err.Error())
	}
	return pairingStatus(err)
}

func (s *Server) GetProfile(context.Context, *pb.Empty) (*pb.Profile, error) {
	f, err := s.friends()
	if err != nil {
		return nil, err
	}
	return f.Profile(), nil
}

func (s *Server) SetDisplayName(_ context.Context, req *pb.SetDisplayNameRequest) (*pb.Profile, error) {
	f, err := s.friends()
	if err != nil {
		return nil, err
	}
	p, err := f.SetDisplayName(req.GetName())
	if err != nil {
		return nil, friendError(err)
	}
	return p, nil
}

func (s *Server) SetAvatar(_ context.Context, req *pb.SetAvatarRequest) (*pb.Profile, error) {
	f, err := s.friends()
	if err != nil {
		return nil, err
	}
	p, err := f.SetAvatar(req)
	if err != nil {
		return nil, friendError(err)
	}
	return p, nil
}

func (s *Server) ResetAvatar(context.Context, *pb.Empty) (*pb.Profile, error) {
	f, err := s.friends()
	if err != nil {
		return nil, err
	}
	p, err := f.ResetAvatar()
	if err != nil {
		return nil, friendError(err)
	}
	return p, nil
}

func (s *Server) GetAvatar(_ context.Context, req *pb.GetAvatarRequest) (*pb.Avatar, error) {
	f, err := s.friends()
	if err != nil {
		return nil, err
	}
	return f.Avatar(req.GetDeviceId()), nil
}

func (s *Server) CreateFriendCode(ctx context.Context, _ *pb.Empty) (*pb.CreatePairingCodeResponse, error) {
	f, err := s.friends()
	if err != nil {
		return nil, err
	}
	code, expires, addrs, err := f.CreateFriendCode(ctx)
	if err != nil {
		return nil, friendError(err)
	}
	return &pb.CreatePairingCodeResponse{Code: code, ExpiresAtUnix: expires.Unix(), LanAddresses: addrs}, nil
}

func (s *Server) RedeemFriendCode(ctx context.Context, req *pb.RedeemPairingCodeRequest) (*pb.FriendRequest, error) {
	f, err := s.friends()
	if err != nil {
		return nil, err
	}
	r, err := f.RedeemFriendCode(ctx, req.GetCode(), req.GetAddress())
	if err != nil {
		return nil, friendError(err)
	}
	return r, nil
}

func (s *Server) ConfirmFriend(ctx context.Context, req *pb.ConfirmPairingRequest) (*pb.Empty, error) {
	f, err := s.friends()
	if err != nil {
		return nil, err
	}
	if err := f.ConfirmFriend(ctx, req.GetPairingSession(), req.GetAccept()); err != nil {
		return nil, friendError(err)
	}
	return &pb.Empty{}, nil
}

func (s *Server) ListFriends(context.Context, *pb.Empty) (*pb.ListFriendsResponse, error) {
	f, err := s.friends()
	if err != nil {
		return nil, err
	}
	return &pb.ListFriendsResponse{Friends: f.Friends()}, nil
}

func (s *Server) RemoveFriend(ctx context.Context, req *pb.FriendRef) (*pb.Empty, error) {
	f, err := s.friends()
	if err != nil {
		return nil, err
	}
	if err := f.RemoveFriend(ctx, req.GetDeviceId()); err != nil {
		return nil, friendError(err)
	}
	return &pb.Empty{}, nil
}

func (s *Server) SetFriendAutoAccept(_ context.Context, req *pb.SetFriendAutoAcceptRequest) (*pb.Friend, error) {
	f, err := s.friends()
	if err != nil {
		return nil, err
	}
	out, err := f.SetFriendAutoAccept(req.GetDeviceId(), req.GetAutoAccept())
	if err != nil {
		return nil, friendError(err)
	}
	return out, nil
}

func (s *Server) BlockDevice(_ context.Context, req *pb.FriendRef) (*pb.Empty, error) {
	f, err := s.friends()
	if err != nil {
		return nil, err
	}
	if err := f.BlockDevice(req.GetDeviceId()); err != nil {
		return nil, friendError(err)
	}
	return &pb.Empty{}, nil
}

func (s *Server) WatchStrangers(_ *pb.Empty, stream pb.DaemonService_WatchStrangersServer) error {
	f, err := s.friends()
	if err != nil {
		return err
	}
	return f.WatchStrangers(stream.Context(), stream.Send)
}

func (s *Server) PasteFiles(ctx context.Context, _ *pb.Empty) (*pb.PasteFilesResponse, error) {
	f, err := s.friends()
	if err != nil {
		return nil, err
	}
	out, err := f.PasteFiles(ctx)
	if err != nil {
		return nil, status.Error(codes.FailedPrecondition, err.Error())
	}
	return out, nil
}

// AnswerIncoming 是接收弹窗里的「接受」「拒绝」；勾了「以后自动接收」时对这个好友打开自动接收
func (s *Server) AnswerIncoming(_ context.Context, req *pb.AnswerIncomingRequest) (*pb.Empty, error) {
	t, err := s.transfers()
	if err != nil {
		return nil, err
	}
	deviceID, role, err := t.Answer(req.GetTransferId(), req.GetAccept())
	if err != nil {
		if errors.Is(err, send.ErrNotAsking) {
			return nil, status.Error(codes.FailedPrecondition, err.Error())
		}
		return nil, transferError(err)
	}
	if req.GetAccept() && req.GetAlways() && role == peers.RoleFriend && s.deps.Friends != nil {
		if _, err := s.deps.Friends.SetFriendAutoAccept(deviceID, true); err != nil {
			return nil, friendError(err)
		}
	}
	return &pb.Empty{}, nil
}
