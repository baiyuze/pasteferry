package main

import (
	"context"
	"errors"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/clipboard"

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
	// readClipboard 读本机剪贴板（粘贴文件、图片用）；pasteDir 存放粘贴的图片
	readClipboard func(ctx context.Context) (clipboard.Content, error)
	pasteDir      string
}

// errNothingToPaste：剪贴板里既没有文件也没有图片
var errNothingToPaste = errors.New("nothing_to_paste")

// PasteFiles 是发送窗口、头像里的「粘贴」：剪贴板里的文件原样返回路径，图片存成 PNG 再返回
func (f *friendsAPI) PasteFiles(ctx context.Context) (*pb.PasteFilesResponse, error) {
	if f.readClipboard == nil {
		return nil, errNothingToPaste
	}
	c, err := f.readClipboard(ctx)
	if err != nil {
		return nil, errNothingToPaste
	}
	switch {
	case c.Kind == clipboard.KindFile && len(c.Files) > 0:
		return &pb.PasteFilesResponse{Paths: c.Files}, nil
	case c.Kind == clipboard.KindImage && len(c.Image) > 0:
		if err := os.MkdirAll(f.pasteDir, 0o700); err != nil {
			return nil, err
		}
		// 名字会被对方看到：只用时间，不带本机信息
		name := "Image " + time.Now().Format("2006-01-02 15.04.05") + ".png"
		path := filepath.Join(f.pasteDir, name)
		if err := os.WriteFile(path, c.Image, 0o600); err != nil {
			return nil, err
		}
		cleanPasteDir(f.pasteDir)
		return &pb.PasteFilesResponse{Paths: []string{path}, Image: true}, nil
	}
	return nil, errNothingToPaste
}

// cleanPasteDir 删掉一天前粘贴的图片：发出去以后就用不着了
func cleanPasteDir(dir string) {
	entries, _ := os.ReadDir(dir)
	for _, e := range entries {
		if info, err := e.Info(); err == nil && time.Since(info.ModTime()) > 24*time.Hour {
			_ = os.Remove(filepath.Join(dir, e.Name()))
		}
	}
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
