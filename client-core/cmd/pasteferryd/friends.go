package main

import (
	"context"
	"strings"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/peers"
	"github.com/baiyuze/pasteferry/client-core/internal/profile"
	"github.com/baiyuze/pasteferry/client-core/internal/rpc"
	"github.com/baiyuze/pasteferry/client-core/internal/send"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// friendsAPI 把好友（peers.Manager）与本机名片、头像（profile.Profile）拼成界面用的接口，见 rpc.Friends。
type friendsAPI struct {
	peers    *peers.Manager
	profile  *profile.Profile
	db       *store.Store
	deviceID string
	// changed 在名字或头像变了以后调用：推给界面、告诉连着的好友
	changed func()
}

func (f *friendsAPI) Profile() *pb.Profile { return f.profile.Proto(f.deviceID) }

func (f *friendsAPI) SetDisplayName(name string) (*pb.Profile, error) {
	if err := f.profile.SetDisplayName(name); err != nil {
		return nil, err
	}
	f.changed()
	return f.Profile(), nil
}

func (f *friendsAPI) SetAvatar(req *pb.SetAvatarRequest) (*pb.Profile, error) {
	if err := f.profile.SetAvatar(req.GetImage(), req.GetPath(), req.GetCropX(), req.GetCropY(), req.GetCropSize()); err != nil {
		return nil, err
	}
	f.changed()
	return f.Profile(), nil
}

func (f *friendsAPI) ResetAvatar() (*pb.Profile, error) {
	if err := f.profile.ResetAvatar(); err != nil {
		return nil, err
	}
	f.changed()
	return f.Profile(), nil
}

func (f *friendsAPI) Avatar(deviceID string) *pb.Avatar {
	if deviceID == "" || deviceID == f.deviceID {
		data := f.profile.Avatar()
		return &pb.Avatar{Jpeg: data, AvatarHash: peers.AvatarHash(data)}
	}
	c, ok := f.peers.FriendContact(deviceID)
	if !ok {
		return &pb.Avatar{}
	}
	return &pb.Avatar{Jpeg: f.profile.FriendAvatar(c.AvatarPath), AvatarHash: c.AvatarHash}
}

func (f *friendsAPI) CreateFriendCode(ctx context.Context) (string, time.Time, []string, error) {
	return f.peers.CreateFriendCode(ctx)
}

func (f *friendsAPI) RedeemFriendCode(ctx context.Context, code, address string) (*pb.FriendRequest, error) {
	return f.peers.RedeemFriendCode(ctx, code, address)
}

func (f *friendsAPI) ConfirmFriend(ctx context.Context, session string, accept bool) error {
	return f.peers.ConfirmFriend(ctx, session, accept)
}

func (f *friendsAPI) Friends() []*pb.Friend { return f.peers.Friends() }

func (f *friendsAPI) RemoveFriend(ctx context.Context, id string) error {
	return f.peers.RemoveFriend(ctx, id)
}

func (f *friendsAPI) SetFriendAutoAccept(id string, auto bool) (*pb.Friend, error) {
	return f.peers.SetFriendAutoAccept(id, auto)
}

func (f *friendsAPI) BlockDevice(id string) error { return f.peers.BlockDevice(id) }

func (f *friendsAPI) WatchStrangers(ctx context.Context, send func(*pb.Strangers) error) error {
	return f.peers.WatchStrangers(ctx, send)
}

var _ rpc.Friends = (*friendsAPI)(nil)

// transfersAPI 是隔空传送的界面接口：发给「所有人」模式下的陌生设备（lan:实例名）时，
// 先向它要公钥，换成设备 ID
type transfersAPI struct {
	*send.Engine
	peers *peers.Manager
}

func (t transfersAPI) SendFiles(deviceID string, paths []string, allowRelay bool, note string) (*pb.Transfer, error) {
	if strings.HasPrefix(deviceID, peers.StrangerPrefix) {
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		id, err := t.peers.ResolveStranger(ctx, deviceID)
		if err != nil {
			return nil, send.ErrOffline
		}
		// 连上并收到对方的功能声明后才知道它能不能收
		deadline := time.Now().Add(8 * time.Second)
		for time.Now().Before(deadline) && !t.peers.HasFeature(id, peers.FeatureSendAsk) {
			time.Sleep(200 * time.Millisecond)
		}
		deviceID = id
	}
	return t.Engine.SendFiles(deviceID, paths, allowRelay, note)
}

// sendPeer 是隔空传送看到的某台电脑：自己的设备或好友、陌生设备。
func sendPeer(peerMgr *peers.Manager, deviceID string) send.Peer {
	state := peerMgr.ConnState(deviceID)
	connected := state.Proto() == pb.ConnectionKind_CONNECTION_KIND_DIRECT || state.Proto() == pb.ConnectionKind_CONNECTION_KIND_RELAY
	relayed := state.Proto() == pb.ConnectionKind_CONNECTION_KIND_RELAY
	switch peerMgr.Role(deviceID) {
	case peers.RoleSelf:
		_, list := peerMgr.Devices()
		for _, d := range list {
			if d.GetId() == deviceID {
				return send.Peer{
					Known: true, Name: d.GetName(), Online: d.GetOnline(), Role: peers.RoleSelf,
					Connected: connected, Relayed: relayed,
					Supported: d.GetReceivesFiles(), Disabled: d.GetReceiveDisabled(),
					Ask: peerMgr.HasFeature(deviceID, peers.FeatureSendAsk),
				}
			}
		}
	case peers.RoleFriend:
		if fr, ok := peerMgr.Friend(deviceID); ok {
			name := fr.GetDisplayName()
			if fr.GetDeviceName() != "" {
				name += " · " + fr.GetDeviceName()
			}
			return send.Peer{
				Known: true, Name: name, Online: fr.GetOnline(), Role: peers.RoleFriend,
				Connected: connected, Relayed: relayed,
				Supported: fr.GetReceivesFiles() || fr.GetReceiveDisabled(), Disabled: fr.GetReceiveDisabled(),
				Ask: peerMgr.HasFeature(deviceID, peers.FeatureSendAsk),
			}
		}
	case peers.RoleStranger:
		if st, ok := peerMgr.Stranger(deviceID); ok {
			return send.Peer{
				Known: true, Name: st.GetDisplayName(), Online: true, Role: peers.RoleStranger,
				Connected: connected, Relayed: relayed,
				Supported: peerMgr.HasFeature(deviceID, peers.FeatureSendFiles) || peerMgr.HasFeature(deviceID, peers.FeatureSendFilesOff),
				Disabled:  peerMgr.HasFeature(deviceID, peers.FeatureSendFilesOff),
				Ask:       peerMgr.HasFeature(deviceID, peers.FeatureSendAsk),
			}
		}
	}
	return send.Peer{}
}

// admit 决定收不收某台电脑发来的文件：自己的设备看「接收文件」开关，别人看「允许这些人给我发文件」，
// 被屏蔽的陌生设备一律不收；打开了自动接收的好友不用问
func admit(peerMgr *peers.Manager, db *store.Store, deviceID string) send.Admission {
	role := peerMgr.Role(deviceID)
	if role == peers.RoleSelf {
		return send.Admission{Allowed: peerMgr.ReceivesFrom(deviceID), AutoAccept: true}
	}
	if db.IsBlocked(deviceID) {
		return send.Admission{}
	}
	a := send.Admission{Allowed: peerMgr.ReceivesFrom(deviceID)}
	if c, ok := peerMgr.FriendContact(deviceID); ok && role == peers.RoleFriend {
		a.AutoAccept = c.AutoAccept
	}
	return a
}
