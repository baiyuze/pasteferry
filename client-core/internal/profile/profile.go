// Package profile 是好友看到的本机信息：显示名和头像，以及好友发来的头像、收到的图片的缩略图。
// 见 design/friends-send.md 第 4.3、4.4、6.3 节。
package profile

import (
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"os"
	"os/user"
	"path/filepath"
	"runtime"
	"strings"
	"sync"
	"time"
	"unicode/utf8"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/peers"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

const (
	// AvatarSize 是头像的边长，MaxAvatar 是头像 JPEG 最大多大
	AvatarSize = 256
	MaxAvatar  = 64 << 10
	// 头像的原图、收到的图片最多读多大
	maxSourceBytes = 64 << 20
	// thumbSize 是缩略图的长边
	thumbSize = 320
	// thumbKeep 是缩略图保留多久（传输记录也是 30 天）
	thumbKeep = 31 * 24 * time.Hour
)

var ErrBadName = errors.New("名字太长或有不能用的字符")

type Profile struct {
	root string // 数据目录
	load func() config.Config
	save func(config.Config) error

	mu sync.Mutex
}

func New(root string, load func() config.Config, save func(config.Config) error) *Profile {
	return &Profile{root: root, load: load, save: save}
}

func (p *Profile) avatarPath() string { return filepath.Join(p.root, "avatar.jpg") }
func (p *Profile) friendsDir() string { return filepath.Join(p.root, "avatars") }
func (p *Profile) thumbsDir() string  { return filepath.Join(p.root, "thumbs") }

// DefaultName 是系统的用户全名，取不到时用登录名。
func DefaultName() string {
	u, err := user.Current()
	if err != nil {
		return ""
	}
	name := strings.TrimSpace(u.Name)
	// Windows 上可能是「域\用户」
	if i := strings.LastIndex(name, `\`); i >= 0 {
		name = name[i+1:]
	}
	// Linux 的 GECOS 是逗号分隔的几项，第一项是全名
	if i := strings.Index(name, ","); i >= 0 {
		name = name[:i]
	}
	if name == "" {
		name = u.Username
		if i := strings.LastIndex(name, `\`); i >= 0 {
			name = name[i+1:]
		}
	}
	return name
}

// DisplayName 是好友看到的名字：设置过的，或者系统的用户全名
func (p *Profile) DisplayName() string {
	if n := strings.TrimSpace(p.load().DisplayName); n != "" {
		return n
	}
	if n := DefaultName(); n != "" {
		return n
	}
	return p.load().DeviceName
}

// SetDisplayName 改名字；空字符串表示恢复成系统的用户全名
func (p *Profile) SetDisplayName(name string) error {
	name = strings.TrimSpace(name)
	if !utf8.ValidString(name) || utf8.RuneCountInString(name) > 32 || strings.ContainsFunc(name, func(r rune) bool { return r < 0x20 || r == 0x7f }) {
		return ErrBadName
	}
	c := p.load()
	c.DisplayName = name
	return p.save(c)
}

// Avatar 返回本机头像（JPEG），没有设置时为空
func (p *Profile) Avatar() []byte {
	data, err := os.ReadFile(p.avatarPath())
	if err != nil || len(data) > MaxAvatar {
		return nil
	}
	return data
}

// SetAvatar 把一张图片裁成正方形、缩到 256×256、编码成不超过 64 KB 的 JPEG 存下来。
// 重新编码会去掉 EXIF 等元数据（拍摄地点不会发给别人）。data 为空时读 path
func (p *Profile) SetAvatar(data []byte, path string, x, y, size float64) error {
	if len(data) == 0 {
		var err error
		if data, err = readImageFile(path, maxSourceBytes); err != nil {
			return err
		}
	}
	if len(data) > maxSourceBytes {
		return ErrNotImage
	}
	img, err := decodeLimited(data)
	if err != nil {
		return err
	}
	r := cropSquare(img, x, y, size)
	out, err := encodeJPEG(onWhite(scale(img, r, AvatarSize, AvatarSize)), MaxAvatar)
	if err != nil {
		return err
	}
	p.mu.Lock()
	defer p.mu.Unlock()
	return writeAtomic(p.avatarPath(), out)
}

func (p *Profile) ResetAvatar() error {
	err := os.Remove(p.avatarPath())
	if errors.Is(err, os.ErrNotExist) {
		return nil
	}
	return err
}

// Card 是发给好友的名片
func (p *Profile) Card() *pb.FriendCard {
	cfg := p.load()
	service := "lan"
	var hash []byte
	switch {
	case cfg.Official():
		service = "official"
	case cfg.EffectiveSignalingURL() != "":
		service = "custom"
		hash = peers.ServiceHash(cfg.EffectiveSignalingURL())
	}
	return &pb.FriendCard{
		DisplayName:      p.DisplayName(),
		DeviceName:       cfg.DeviceName,
		Platform:         runtime.GOOS,
		Service:          service,
		CustomServerHash: hash,
		AvatarHash:       peers.AvatarHash(p.Avatar()),
	}
}

func (p *Profile) Proto(deviceID string) *pb.Profile {
	avatar := p.Avatar()
	return &pb.Profile{DisplayName: p.DisplayName(), DeviceId: deviceID, HasAvatar: len(avatar) > 0, AvatarHash: peers.AvatarHash(avatar)}
}

// SaveFriendAvatar 把好友发来的头像重新解码、编码后存下，返回存放的路径。
func (p *Profile) SaveFriendAvatar(deviceID string, jpeg []byte) (string, error) {
	if len(jpeg) > MaxAvatar || strings.ContainsAny(deviceID, `/\.`) || deviceID == "" {
		return "", ErrNotImage
	}
	img, err := decodeLimited(jpeg)
	if err != nil {
		return "", err
	}
	b := img.Bounds()
	w, h := fitInside(b.Dx(), b.Dy(), AvatarSize)
	out, err := encodeJPEG(onWhite(scale(img, b, w, h)), MaxAvatar)
	if err != nil {
		return "", err
	}
	path := filepath.Join(p.friendsDir(), deviceID+".jpg")
	if err := writeAtomic(path, out); err != nil {
		return "", err
	}
	return path, nil
}

// FriendAvatar 读好友的头像（已经是重新编码过的）
func (p *Profile) FriendAvatar(path string) []byte {
	if path == "" || filepath.Dir(path) != p.friendsDir() {
		return nil
	}
	data, err := os.ReadFile(path)
	if err != nil || len(data) > MaxAvatar {
		return nil
	}
	return data
}

// Thumbnail 为收到的一张图片生成缩略图（PNG），返回路径；不是能处理的图片时为空。
func (p *Profile) Thumbnail(path string) string {
	data, err := readImageFile(path, maxSourceBytes)
	if err != nil {
		return ""
	}
	img, err := decodeLimited(data)
	if err != nil {
		return ""
	}
	b := img.Bounds()
	w, h := fitInside(b.Dx(), b.Dy(), thumbSize)
	out, err := encodePNG(scale(img, b, w, h))
	if err != nil {
		return ""
	}
	sum := sha256.Sum256([]byte(fmt.Sprintf("%s|%d", path, time.Now().UnixNano())))
	dst := filepath.Join(p.thumbsDir(), hex.EncodeToString(sum[:10])+".png")
	if err := writeAtomic(dst, out); err != nil {
		return ""
	}
	return dst
}

// CleanThumbs 删掉过期的缩略图
func (p *Profile) CleanThumbs() {
	entries, err := os.ReadDir(p.thumbsDir())
	if err != nil {
		return
	}
	for _, e := range entries {
		if info, err := e.Info(); err == nil && time.Since(info.ModTime()) > thumbKeep {
			_ = os.Remove(filepath.Join(p.thumbsDir(), e.Name()))
		}
	}
}

func writeAtomic(path string, data []byte) error {
	if err := os.MkdirAll(filepath.Dir(path), 0o700); err != nil {
		return err
	}
	tmp := path + ".tmp"
	if err := os.WriteFile(tmp, data, 0o600); err != nil {
		return err
	}
	return os.Rename(tmp, path)
}
