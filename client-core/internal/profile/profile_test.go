package profile

import (
	"bytes"
	"image"
	"image/color"
	"image/jpeg"
	"image/png"
	"os"
	"path/filepath"
	"testing"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
)

func newProfile(t *testing.T) (*Profile, *config.Config) {
	t.Helper()
	cfg := config.Default()
	p := New(t.TempDir(), func() config.Config { return cfg }, func(c config.Config) error { cfg = c; return nil })
	return p, &cfg
}

func testImage(w, h int) []byte {
	img := image.NewRGBA(image.Rect(0, 0, w, h))
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			img.Set(x, y, color.RGBA{uint8(x), uint8(y), 128, 255})
		}
	}
	var buf bytes.Buffer
	_ = png.Encode(&buf, img)
	return buf.Bytes()
}

func TestDisplayName(t *testing.T) {
	p, cfg := newProfile(t)
	if p.DisplayName() == "" {
		t.Fatal("没设置时应当用系统的用户名")
	}
	if err := p.SetDisplayName("  光光 "); err != nil {
		t.Fatal(err)
	}
	if p.DisplayName() != "光光" || cfg.DisplayName != "光光" {
		t.Fatalf("名字不对: %q", p.DisplayName())
	}
	if err := p.SetDisplayName("a\nb"); err != ErrBadName {
		t.Fatalf("有换行的名字应当被拒: %v", err)
	}
	if err := p.SetDisplayName(string(bytes.Repeat([]byte("长"), 33))); err != ErrBadName {
		t.Fatalf("太长的名字应当被拒: %v", err)
	}
}

func TestAvatar(t *testing.T) {
	p, _ := newProfile(t)
	if p.Avatar() != nil {
		t.Fatal("一开始没有头像")
	}
	if err := p.SetAvatar(testImage(1200, 800), "", 0, 0, 0); err != nil {
		t.Fatal(err)
	}
	data := p.Avatar()
	if len(data) == 0 || len(data) > MaxAvatar {
		t.Fatalf("头像大小不对: %d", len(data))
	}
	img, err := jpeg.Decode(bytes.NewReader(data))
	if err != nil {
		t.Fatal(err)
	}
	if b := img.Bounds(); b.Dx() != AvatarSize || b.Dy() != AvatarSize {
		t.Fatalf("头像应当是 %d×%d，得到 %v", AvatarSize, AvatarSize, b)
	}
	if card := p.Card(); len(card.GetAvatarHash()) == 0 {
		t.Fatal("名片里应当有头像的哈希")
	}
	if err := p.SetAvatar([]byte("不是图片"), "", 0, 0, 0); err != ErrNotImage {
		t.Fatalf("不是图片应当被拒: %v", err)
	}
	if err := p.ResetAvatar(); err != nil || p.Avatar() != nil {
		t.Fatalf("恢复默认头像: %v", err)
	}
}

func TestFriendAvatarAndThumbnail(t *testing.T) {
	p, _ := newProfile(t)
	if err := p.SetAvatar(testImage(300, 300), "", 0, 0, 0); err != nil {
		t.Fatal(err)
	}
	path, err := p.SaveFriendAvatar("abc", p.Avatar())
	if err != nil {
		t.Fatal(err)
	}
	if len(p.FriendAvatar(path)) == 0 {
		t.Fatal("读不回好友的头像")
	}
	if p.FriendAvatar("/etc/passwd") != nil {
		t.Fatal("只能读头像目录里的文件")
	}
	if _, err := p.SaveFriendAvatar("../x", p.Avatar()); err == nil {
		t.Fatal("设备 ID 里有路径时应当拒绝")
	}
	if _, err := p.SaveFriendAvatar("abc", []byte("坏数据")); err == nil {
		t.Fatal("坏数据应当拒绝")
	}

	img := filepath.Join(t.TempDir(), "照片.png")
	if err := os.WriteFile(img, testImage(1000, 500), 0o600); err != nil {
		t.Fatal(err)
	}
	thumb := p.Thumbnail(img)
	if thumb == "" {
		t.Fatal("没生成缩略图")
	}
	f, err := os.Open(thumb)
	if err != nil {
		t.Fatal(err)
	}
	defer f.Close()
	cfg, err := png.DecodeConfig(f)
	if err != nil || cfg.Width != thumbSize || cfg.Height != thumbSize/2 {
		t.Fatalf("缩略图尺寸不对: %v %v", cfg, err)
	}
	txt := filepath.Join(t.TempDir(), "a.txt")
	_ = os.WriteFile(txt, []byte("x"), 0o600)
	if p.Thumbnail(txt) != "" {
		t.Fatal("不是图片不该有缩略图")
	}
}
