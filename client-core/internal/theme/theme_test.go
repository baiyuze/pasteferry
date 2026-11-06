package theme

import (
	"bytes"
	"encoding/binary"
	"encoding/json"
	"errors"
	"image"
	"image/color"
	"image/jpeg"
	"image/png"
	"os"
	"strings"
	"testing"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
)

func newStore(t *testing.T) *Store {
	t.Helper()
	return NewStore(config.PathsUnder(t.TempDir()))
}

func put(t *testing.T, s *Store, js string) []Warning {
	t.Helper()
	_, w, err := s.Put([]byte(js))
	if err != nil {
		t.Fatalf("Put(%s): %v", js, err)
	}
	return w
}

func isInvalid(err error) bool {
	var inv *InvalidError
	return errors.As(err, &inv)
}

func TestBuiltinsParse(t *testing.T) {
	for _, id := range builtinIDs {
		th, _, err := builtin(id)
		if err != nil {
			t.Fatal(id, err)
		}
		for _, m := range Modes {
			for _, r := range Roles {
				if _, err := ParseColor(th.Modes[m][r]); err != nil {
					t.Errorf("%s.%s.%s: %v", id, m, r, err)
				}
			}
		}
	}
}

func TestParseRejectsBadFormat(t *testing.T) {
	for name, js := range map[string]string{
		"不是 JSON":   `{`,
		"缺 schema":  `{"id":"a"}`,
		"schema 太新": `{"schema":2,"id":"a"}`,
	} {
		if _, err := Parse([]byte(js)); !isInvalid(err) {
			t.Errorf("%s: 应当报格式错误，得到 %v", name, err)
		}
	}
}

func TestValidate(t *testing.T) {
	s := newStore(t)
	for name, js := range map[string]string{
		"id 有大写":   `{"schema":1,"id":"Mine"}`,
		"覆盖内置主题":   `{"schema":1,"id":"pixel"}`,
		"颜色写错":     `{"schema":1,"id":"a","modes":{"light":{"accent":"red"}}}`,
		"没有这个角色":   `{"schema":1,"id":"a","modes":{"light":{"glow":"#FFFFFF"}}}`,
		"多出一种模式":   `{"schema":1,"id":"a","modes":{"sepia":{"accent":"#FFFFFF"}}}`,
		"角的样式不认识":  `{"schema":1,"id":"a","shape":{"corner":"notch"}}`,
		"字体不是自带的":  `{"schema":1,"id":"a","typography":{"family":"Comic Sans"}}`,
		"base 不存在": `{"schema":1,"id":"a","base":"nope"}`,
		"继承自己":     `{"schema":1,"id":"a","base":"a"}`,
		"背景图没导入":   `{"schema":1,"id":"a","background":{"image":"user:` + strings.Repeat("a", 64) + `"}}`,
		"遮罩超出范围":   `{"schema":1,"id":"a","background":{"surfaceOpacity":0.2}}`,
	} {
		if _, _, err := s.Put([]byte(js)); !isInvalid(err) {
			t.Errorf("%s: 应当报格式错误，得到 %v", name, err)
		}
	}
}

func TestMergeWithBase(t *testing.T) {
	s := newStore(t)
	put(t, s, `{"schema":1,"id":"mint","name":{"zh-Hans":"薄荷"},"base":"pixel","modes":{"dark":{"accent":"#7CF2C2"}}}`)

	raw, err := s.Get("mint", false)
	if err != nil {
		t.Fatal(err)
	}
	if strings.Contains(string(raw), "borderStrong") {
		t.Errorf("未合并的主题不该带上 base 的颜色：%s", raw)
	}

	data, err := s.Get("mint", true)
	if err != nil {
		t.Fatal(err)
	}
	var r Theme
	if err := json.Unmarshal(data, &r); err != nil {
		t.Fatal(err)
	}
	if got := r.Modes["dark"]["accent"]; got != "#7CF2C2" {
		t.Errorf("强调色没有覆盖：%s", got)
	}
	if got := r.Modes["dark"]["background"]; got != "#111215" {
		t.Errorf("没写的颜色应当沿用 pixel：%s", got)
	}
	if r.Shape == nil || r.Shape.Corner != "pixel" || *r.Typography.Family != "FusionPixel" || r.Icons != "pixel" {
		t.Errorf("形状、字体、图标应当沿用 pixel：%+v", r)
	}
	if r.Name["zh-Hans"] != "薄荷" || r.Base != "pixel" {
		t.Errorf("名字、base 不对：%v %s", r.Name, r.Base)
	}

	infos, err := s.List()
	if err != nil {
		t.Fatal(err)
	}
	if len(infos) != 3 || infos[0].ID != DefaultID || infos[1].ID != PixelID || infos[2].ID != "mint" || infos[2].Base != "pixel" {
		t.Errorf("列表不对：%+v", infos)
	}
}

func TestInheritanceDepthAndCycle(t *testing.T) {
	s := newStore(t)
	put(t, s, `{"schema":1,"id":"a"}`)
	put(t, s, `{"schema":1,"id":"b","base":"a"}`)
	put(t, s, `{"schema":1,"id":"c","base":"b"}`)
	if _, _, err := s.Put([]byte(`{"schema":1,"id":"d","base":"c"}`)); !isInvalid(err) {
		t.Errorf("往上三层自定义主题应当拒绝，得到 %v", err)
	}
	if _, _, err := s.Put([]byte(`{"schema":1,"id":"a","base":"b"}`)); !isInvalid(err) {
		t.Errorf("继承成环应当拒绝，得到 %v", err)
	}
	// a 改成继承 pixel 没问题，b、c 跟着变
	put(t, s, `{"schema":1,"id":"a","base":"pixel"}`)
	data, _ := s.Get("c", true)
	if !strings.Contains(string(data), `"corner": "pixel"`) {
		t.Errorf("c 应当经 b、a 继承到 pixel 的形状：%s", data)
	}
}

func TestContrastWarnings(t *testing.T) {
	if r := Contrast(RGBA{0, 0, 0, 255}, RGBA{255, 255, 255, 255}); r < 20.9 || r > 21.1 {
		t.Errorf("黑白对比度应当是 21，得到 %v", r)
	}
	s := newStore(t)
	// 只改了强调色：base 本来的配色（默认主题浅色的 textFaint 只有 2.4）不报
	if w := put(t, s, `{"schema":1,"id":"blue","modes":{"light":{"accent":"#2255CC"}}}`); len(w) != 0 {
		t.Errorf("只改强调色不该有警告：%+v", w)
	}
	w := put(t, s, `{"schema":1,"id":"low","modes":{"light":{"text":"#BBBBBB","accent":"#FFE066"}}}`)
	got := map[string]bool{}
	for _, x := range w {
		got[x.Mode+":"+x.Foreground+"/"+x.Background] = true
		if x.Ratio >= x.Minimum {
			t.Errorf("警告的比值应当低于要求：%+v", x)
		}
	}
	for _, want := range []string{"light:text/background", "light:text/surface", "light:onAccent/accent"} {
		if !got[want] {
			t.Errorf("缺少警告 %s，得到 %+v", want, w)
		}
	}
	if got["dark:text/background"] {
		t.Errorf("深色没改，不该报")
	}
}

func TestDelete(t *testing.T) {
	s := newStore(t)
	if err := s.Delete("pixel"); !errors.Is(err, ErrBuiltin) {
		t.Errorf("内置主题不能删：%v", err)
	}
	put(t, s, `{"schema":1,"id":"a"}`)
	put(t, s, `{"schema":1,"id":"b","base":"a"}`)
	if err := s.Delete("a"); !errors.Is(err, ErrIsBase) {
		t.Errorf("被继承的主题不能删：%v", err)
	}
	if err := s.Delete("b"); err != nil {
		t.Fatal(err)
	}
	if err := s.Delete("a"); err != nil {
		t.Fatal(err)
	}
	if s.Exists("a") || !s.Exists("") || !s.Exists("pixel") {
		t.Errorf("删除后存在与否不对")
	}
	if err := s.Delete("a"); !errors.Is(err, ErrNotFound) {
		t.Errorf("删不存在的主题：%v", err)
	}
}

// withOrientation 在 JPEG 的开头插一段只有拍摄方向的 EXIF
func withOrientation(t *testing.T, jpg []byte, o uint16) []byte {
	t.Helper()
	var tiff bytes.Buffer
	tiff.WriteString("MM\x00\x2a")
	binary.Write(&tiff, binary.BigEndian, uint32(8))
	binary.Write(&tiff, binary.BigEndian, uint16(1))
	binary.Write(&tiff, binary.BigEndian, []uint16{0x0112, 3})
	binary.Write(&tiff, binary.BigEndian, uint32(1))
	binary.Write(&tiff, binary.BigEndian, []uint16{o, 0})
	binary.Write(&tiff, binary.BigEndian, uint32(0))
	// 再塞一段假的 GPS 信息，检查重新编码后没有留下来
	tiff.WriteString("GPS-SECRET")
	seg := append([]byte("Exif\x00\x00"), tiff.Bytes()...)
	var out bytes.Buffer
	out.Write(jpg[:2])
	out.Write([]byte{0xFF, 0xE1})
	binary.Write(&out, binary.BigEndian, uint16(len(seg)+2))
	out.Write(seg)
	out.Write(jpg[2:])
	return out.Bytes()
}

func solid(w, h int, c color.RGBA) *image.RGBA {
	img := image.NewRGBA(image.Rect(0, 0, w, h))
	for i := 0; i < len(img.Pix); i += 4 {
		img.Pix[i], img.Pix[i+1], img.Pix[i+2], img.Pix[i+3] = c.R, c.G, c.B, c.A
	}
	return img
}

func TestImportBackgroundStripsExifAndRotates(t *testing.T) {
	s := newStore(t)
	var buf bytes.Buffer
	if err := jpeg.Encode(&buf, solid(40, 20, color.RGBA{250, 250, 250, 255}), nil); err != nil {
		t.Fatal(err)
	}
	src := withOrientation(t, buf.Bytes(), 6)
	if jpegOrientation(src) != 6 {
		t.Fatal("测试数据里的方向没写对")
	}
	info, err := s.ImportBackground(src, "")
	if err != nil {
		t.Fatal(err)
	}
	if info.Width != 20 || info.Height != 40 || info.Format != "jpeg" {
		t.Errorf("方向 6 应当转成竖图：%+v", info)
	}
	data, format, err := s.Background(info.SHA256, false)
	if err != nil || format != "jpeg" {
		t.Fatal(err, format)
	}
	if bytes.Contains(data, []byte("Exif")) || bytes.Contains(data, []byte("GPS-SECRET")) {
		t.Error("重新编码后不该留下 EXIF")
	}
	if blurred, _, err := s.Background(info.SHA256, true); err != nil || len(blurred) == 0 {
		t.Errorf("应当有模糊版：%v", err)
	}
	if info.Luminance < 0.9 || info.MinScrimDark < 0.7 || info.MinScrimLight != 0 {
		t.Errorf("近白的图：亮度高，白字要很浓的黑遮罩，黑字不用遮罩：%+v", info)
	}
	if len(info.Colors) < 1 || len(info.Colors) > 5 {
		t.Errorf("主色数量不对：%v", info.Colors)
	}
}

func TestImportBackgroundScalesAndKeepsTiles(t *testing.T) {
	s := newStore(t)
	var big bytes.Buffer
	jpeg.Encode(&big, solid(5000, 50, color.RGBA{20, 30, 40, 255}), nil)
	info, err := s.ImportBackground(big.Bytes(), "")
	if err != nil {
		t.Fatal(err)
	}
	if info.Width != maxBackgroundSide || info.Height != 38 {
		t.Errorf("长边应当缩到 %d：%dx%d", maxBackgroundSide, info.Width, info.Height)
	}
	if info.MinScrimDark != 0 || info.MinScrimLight < 0.1 {
		t.Errorf("很暗的图：白字不用遮罩，黑字要白遮罩：%+v", info)
	}

	var tile bytes.Buffer
	png.Encode(&tile, solid(16, 16, color.RGBA{61, 220, 151, 255}))
	info, err = s.ImportBackground(tile.Bytes(), "")
	if err != nil {
		t.Fatal(err)
	}
	if info.Format != "png" || info.Width != 16 {
		t.Errorf("小 PNG 应当原样保留成 PNG：%+v", info)
	}
	if _, err := s.ImportBackground([]byte("not an image"), ""); !errors.Is(err, ErrNotImage) {
		t.Errorf("不是图片：%v", err)
	}
}

func TestDeleteBackgroundInUse(t *testing.T) {
	s := newStore(t)
	var buf bytes.Buffer
	png.Encode(&buf, solid(8, 8, color.RGBA{0, 0, 0, 255}))
	info, err := s.ImportBackground(buf.Bytes(), "")
	if err != nil {
		t.Fatal(err)
	}
	put(t, s, `{"schema":1,"id":"bg","background":{"image":"user:`+info.SHA256+`","fit":"tile"}}`)
	if err := s.DeleteBackground(info.SHA256); !errors.Is(err, ErrInUse) {
		t.Errorf("还在用的背景图不能删：%v", err)
	}
	if err := s.Delete("bg"); err != nil {
		t.Fatal(err)
	}
	if err := s.DeleteBackground(info.SHA256); err != nil {
		t.Fatal(err)
	}
	if _, _, err := s.Background(info.SHA256, false); !errors.Is(err, ErrNotFound) {
		t.Errorf("删掉后不该还读得到：%v", err)
	}
	entries, _ := os.ReadDir(s.backgrounds)
	if len(entries) != 0 {
		t.Errorf("模糊版也要删掉，还剩 %d 个文件", len(entries))
	}
}

func TestCheckDoesNotSave(t *testing.T) {
	s := newStore(t)
	id, warnings, err := s.Check([]byte(`{"schema":1,"id":"dim","modes":{"dark":{"textDim":"#3A3A3C"}}}`))
	if err != nil || id != "dim" {
		t.Fatal(id, err)
	}
	if len(warnings) == 0 {
		t.Error("textDim 和背景几乎一样，应当有对比度警告")
	}
	if s.Exists("dim") {
		t.Error("只校验时不该保存")
	}
	if _, _, err := s.Check([]byte(`{"schema":1,"id":"pixel"}`)); !isInvalid(err) {
		t.Errorf("内置主题的 id 校验时也要拒绝：%v", err)
	}
}

func TestAnalyzeBackground(t *testing.T) {
	s := newStore(t)
	var buf bytes.Buffer
	png.Encode(&buf, solid(16, 16, color.RGBA{10, 10, 10, 255}))
	info, err := s.ImportBackground(buf.Bytes(), "")
	if err != nil {
		t.Fatal(err)
	}
	again, err := s.AnalyzeBackground(info.SHA256)
	if err != nil {
		t.Fatal(err)
	}
	if again.SHA256 != info.SHA256 || again.Width != 16 || again.Format != "png" || again.Luminance != info.Luminance {
		t.Errorf("重新分析应当与导入时一致：%+v vs %+v", again, info)
	}
	if _, err := s.AnalyzeBackground(strings.Repeat("0", 64)); !errors.Is(err, ErrNotFound) {
		t.Errorf("没有这张图：%v", err)
	}
}
