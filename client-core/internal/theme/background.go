package theme

import (
	"bytes"
	"crypto/sha256"
	"encoding/binary"
	"encoding/hex"
	"errors"
	"image"
	"image/color"
	"image/draw"
	_ "image/gif" // 注册 GIF 解码器：动图只取第一帧
	"image/jpeg"
	"image/png"
	"io"
	"math"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"

	"github.com/baiyuze/pasteferry/client-core/internal/imagepreview"
)

// 背景图（design/themes.md 第 7 节）。只用 Go 自带的解码器（内存安全）：PNG、JPEG、GIF；
// HEIC、TIFF 在 Mac 上先由系统转成 PNG。重新编码时 EXIF 等元数据都不写回去——照片里常有 GPS 坐标，
// 分享主题时不能把位置带出去；拍摄方向先按 EXIF 转正。

const (
	maxBackgroundSource = 20 << 20 // 输入最大 20 MB
	maxBackgroundPixels = 64 << 20 // 愿意解码的最大像素数
	maxBackgroundSide   = 3840     // 存下来的长边上限
	blurredSide         = 960      // 模糊版的长边
	tileSide            = 512      // 不超过这么大的 PNG 当作平铺小图（像素画），原样保留 PNG
)

var ErrNotImage = errors.New("不是能处理的图片（支持 PNG、JPEG、GIF）")

var shaRef = regexp.MustCompile(`^[0-9a-f]{64}$`)

// BackgroundInfo 是导入后的背景图与它的分析结果
type BackgroundInfo struct {
	SHA256          string
	Width, Height   int
	Format          string // jpeg、png
	Luminance       float64
	LuminanceSpread float64
	Colors          []string
	MinScrimDark    float64
	MinScrimLight   float64
}

// ImportBackground 导入一张背景图：data 为空时读 path。同一张图导入两次得到同一个 sha256
func (s *Store) ImportBackground(data []byte, path string) (BackgroundInfo, error) {
	if len(data) == 0 {
		var err error
		if data, err = readImageFile(path); err != nil {
			return BackgroundInfo{}, err
		}
	}
	if len(data) > maxBackgroundSource {
		return BackgroundInfo{}, ErrNotImage
	}
	cfg, format, err := image.DecodeConfig(bytes.NewReader(data))
	if err != nil || cfg.Width <= 0 || cfg.Height <= 0 || int64(cfg.Width)*int64(cfg.Height) > maxBackgroundPixels {
		return BackgroundInfo{}, ErrNotImage
	}
	src, _, err := image.Decode(bytes.NewReader(data))
	if err != nil {
		return BackgroundInfo{}, ErrNotImage
	}
	img := toRGBA(src)
	if format == "jpeg" {
		img = orient(img, jpegOrientation(data))
	}

	var main []byte
	outFormat := "jpeg"
	w, h := img.Rect.Dx(), img.Rect.Dy()
	if format == "png" && w <= tileSide && h <= tileSide {
		outFormat = "png"
		if main, err = encodePNG(img); err != nil {
			return BackgroundInfo{}, err
		}
	} else {
		if w, h = fitInside(w, h, maxBackgroundSide); w != img.Rect.Dx() || h != img.Rect.Dy() {
			img = scale(img, w, h)
		}
		if main, err = encodeJPEG(onWhite(img), 88); err != nil {
			return BackgroundInfo{}, err
		}
	}
	sum := sha256.Sum256(main)
	sha := hex.EncodeToString(sum[:])

	bw, bh := fitInside(w, h, blurredSide)
	blurred := blur(onWhite(scale(img, bw, bh)), max(2, bw/80))
	blurData, err := encodeJPEG(blurred, 80)
	if err != nil {
		return BackgroundInfo{}, err
	}

	s.mu.Lock()
	defer s.mu.Unlock()
	if err := os.MkdirAll(s.backgrounds, 0o700); err != nil {
		return BackgroundInfo{}, err
	}
	if err := writeAtomic(s.backgroundPath(sha, outFormat, false), main); err != nil {
		return BackgroundInfo{}, err
	}
	if err := writeAtomic(s.backgroundPath(sha, "jpeg", true), blurData); err != nil {
		return BackgroundInfo{}, err
	}
	info := analyze(img)
	info.SHA256, info.Width, info.Height, info.Format = sha, w, h, outFormat
	return info, nil
}

func (s *Store) backgroundPath(sha, format string, blurred bool) string {
	switch {
	case blurred:
		return filepath.Join(s.backgrounds, sha+".blur.jpg")
	case format == "png":
		return filepath.Join(s.backgrounds, sha+".png")
	default:
		return filepath.Join(s.backgrounds, sha+".jpg")
	}
}

// Background 返回背景图的字节与格式
func (s *Store) Background(sha string, blurred bool) ([]byte, string, error) {
	if !shaRef.MatchString(sha) {
		return nil, "", ErrNotFound
	}
	if blurred {
		data, err := os.ReadFile(s.backgroundPath(sha, "jpeg", true))
		if errors.Is(err, os.ErrNotExist) {
			return nil, "", ErrNotFound
		}
		return data, "jpeg", err
	}
	for _, f := range []string{"jpeg", "png"} {
		data, err := os.ReadFile(s.backgroundPath(sha, f, false))
		if err == nil {
			return data, f, nil
		}
		if !errors.Is(err, os.ErrNotExist) {
			return nil, "", err
		}
	}
	return nil, "", ErrNotFound
}

// AnalyzeBackground 重新分析一张已导入的背景图。分析的是保存下来的文件（重新编码过），
// 结果与导入时的可能差一点点
func (s *Store) AnalyzeBackground(sha string) (BackgroundInfo, error) {
	data, format, err := s.Background(sha, false)
	if err != nil {
		return BackgroundInfo{}, err
	}
	src, _, err := image.Decode(bytes.NewReader(data))
	if err != nil {
		return BackgroundInfo{}, ErrNotImage
	}
	img := toRGBA(src)
	info := analyze(img)
	info.SHA256, info.Width, info.Height, info.Format = sha, img.Rect.Dx(), img.Rect.Dy(), format
	return info, nil
}

func (s *Store) hasBackground(sha string) bool {
	for _, f := range []string{"jpeg", "png"} {
		if _, err := os.Stat(s.backgroundPath(sha, f, false)); err == nil {
			return true
		}
	}
	return false
}

// DeleteBackground 删掉一张背景图；还有自定义主题引用它时返回 ErrInUse
func (s *Store) DeleteBackground(sha string) error {
	if !shaRef.MatchString(sha) {
		return ErrNotFound
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	if !s.hasBackground(sha) {
		return ErrNotFound
	}
	infos, err := s.List()
	if err != nil {
		return err
	}
	for _, info := range infos {
		if info.Builtin {
			continue
		}
		t, _, err := s.load(info.ID)
		if err != nil {
			continue
		}
		for _, img := range s.userImages(t) {
			if img == sha {
				return ErrInUse
			}
		}
	}
	for _, p := range []string{s.backgroundPath(sha, "jpeg", false), s.backgroundPath(sha, "png", false), s.backgroundPath(sha, "jpeg", true)} {
		if err := os.Remove(p); err != nil && !errors.Is(err, os.ErrNotExist) {
			return err
		}
	}
	return nil
}

// ─────────────────────────── 图片处理 ───────────────────────────

func readImageFile(path string) ([]byte, error) {
	if path == "" || !imagepreview.Previewable(path) {
		return nil, ErrNotImage
	}
	src, err := imagepreview.Prepare(path)
	if err != nil {
		return nil, ErrNotImage
	}
	switch strings.ToLower(filepath.Ext(src)) {
	case ".png", ".jpg", ".jpeg", ".gif":
	default:
		return nil, ErrNotImage
	}
	f, err := os.Open(src)
	if err != nil {
		return nil, err
	}
	defer f.Close()
	data, err := io.ReadAll(io.LimitReader(f, maxBackgroundSource+1))
	if err != nil {
		return nil, err
	}
	if len(data) > maxBackgroundSource {
		return nil, ErrNotImage
	}
	return data, nil
}

func toRGBA(src image.Image) *image.RGBA {
	b := src.Bounds()
	dst := image.NewRGBA(image.Rect(0, 0, b.Dx(), b.Dy()))
	draw.Draw(dst, dst.Rect, src, b.Min, draw.Src)
	return dst
}

// jpegOrientation 读 JPEG 里 EXIF 的拍摄方向（1 到 8），读不到时是 1
func jpegOrientation(data []byte) int {
	if len(data) < 4 || data[0] != 0xFF || data[1] != 0xD8 {
		return 1
	}
	i := 2
	for i+4 <= len(data) {
		if data[i] != 0xFF {
			return 1
		}
		marker := data[i+1]
		if marker == 0xDA || marker == 0xD9 { // 图像数据开始了，后面不会再有 EXIF
			return 1
		}
		size := int(binary.BigEndian.Uint16(data[i+2:]))
		if size < 2 || i+2+size > len(data) {
			return 1
		}
		seg := data[i+4 : i+2+size]
		if marker == 0xE1 && len(seg) > 14 && string(seg[:6]) == "Exif\x00\x00" {
			return tiffOrientation(seg[6:])
		}
		i += 2 + size
	}
	return 1
}

func tiffOrientation(t []byte) int {
	if len(t) < 8 {
		return 1
	}
	var bo binary.ByteOrder
	switch string(t[:2]) {
	case "II":
		bo = binary.LittleEndian
	case "MM":
		bo = binary.BigEndian
	default:
		return 1
	}
	off := int(bo.Uint32(t[4:]))
	if off+2 > len(t) {
		return 1
	}
	n := int(bo.Uint16(t[off:]))
	for k := 0; k < n; k++ {
		e := off + 2 + k*12
		if e+12 > len(t) {
			return 1
		}
		if bo.Uint16(t[e:]) == 0x0112 {
			if v := int(bo.Uint16(t[e+8:])); v >= 1 && v <= 8 {
				return v
			}
			return 1
		}
	}
	return 1
}

// orient 按 EXIF 方向把图转正
func orient(src *image.RGBA, o int) *image.RGBA {
	if o <= 1 || o > 8 {
		return src
	}
	w, h := src.Rect.Dx(), src.Rect.Dy()
	dw, dh := w, h
	if o >= 5 {
		dw, dh = h, w
	}
	dst := image.NewRGBA(image.Rect(0, 0, dw, dh))
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			var dx, dy int
			switch o {
			case 2:
				dx, dy = w-1-x, y
			case 3:
				dx, dy = w-1-x, h-1-y
			case 4:
				dx, dy = x, h-1-y
			case 5:
				dx, dy = y, x
			case 6:
				dx, dy = h-1-y, x
			case 7:
				dx, dy = h-1-y, w-1-x
			case 8:
				dx, dy = y, w-1-x
			}
			dst.SetRGBA(dx, dy, src.RGBAAt(x, y))
		}
	}
	return dst
}

// fitInside 是把 w×h 缩到长边不超过 limit 后的尺寸（不放大）
func fitInside(w, h, limit int) (int, int) {
	if w <= limit && h <= limit {
		return w, h
	}
	if w >= h {
		return limit, max(1, h*limit/w)
	}
	return max(1, w*limit/h), limit
}

// scale 缩放到 w×h：缩小时按区域取平均（盒式滤波），放大时取最近的像素
func scale(src *image.RGBA, w, h int) *image.RGBA {
	r := src.Rect
	dst := image.NewRGBA(image.Rect(0, 0, w, h))
	sw, sh := r.Dx(), r.Dy()
	for dy := 0; dy < h; dy++ {
		y0, y1 := dy*sh/h, (dy+1)*sh/h
		if y1 <= y0 {
			y1 = y0 + 1
		}
		for dx := 0; dx < w; dx++ {
			x0, x1 := dx*sw/w, (dx+1)*sw/w
			if x1 <= x0 {
				x1 = x0 + 1
			}
			var rs, gs, bs, as, n uint32
			for yy := y0; yy < y1; yy++ {
				for xx := x0; xx < x1; xx++ {
					c := src.RGBAAt(xx, yy)
					rs, gs, bs, as = rs+uint32(c.R), gs+uint32(c.G), bs+uint32(c.B), as+uint32(c.A)
					n++
				}
			}
			dst.SetRGBA(dx, dy, color.RGBA{uint8(rs / n), uint8(gs / n), uint8(bs / n), uint8(as / n)})
		}
	}
	return dst
}

// blur 三遍盒式模糊，接近高斯模糊
func blur(img *image.RGBA, radius int) *image.RGBA {
	for range 3 {
		img = boxBlur(img, radius, true)
		img = boxBlur(img, radius, false)
	}
	return img
}

func boxBlur(src *image.RGBA, r int, horizontal bool) *image.RGBA {
	w, h := src.Rect.Dx(), src.Rect.Dy()
	dst := image.NewRGBA(src.Rect)
	lines, length := h, w
	if !horizontal {
		lines, length = w, h
	}
	at := func(line, i int) color.RGBA {
		i = min(max(i, 0), length-1)
		if horizontal {
			return src.RGBAAt(i, line)
		}
		return src.RGBAAt(line, i)
	}
	n := uint32(2*r + 1)
	for line := 0; line < lines; line++ {
		var rs, gs, bs, as uint32
		for i := -r; i <= r; i++ {
			c := at(line, i)
			rs, gs, bs, as = rs+uint32(c.R), gs+uint32(c.G), bs+uint32(c.B), as+uint32(c.A)
		}
		for i := 0; i < length; i++ {
			out := color.RGBA{uint8(rs / n), uint8(gs / n), uint8(bs / n), uint8(as / n)}
			if horizontal {
				dst.SetRGBA(i, line, out)
			} else {
				dst.SetRGBA(line, i, out)
			}
			in, gone := at(line, i+r+1), at(line, i-r)
			rs += uint32(in.R) - uint32(gone.R)
			gs += uint32(in.G) - uint32(gone.G)
			bs += uint32(in.B) - uint32(gone.B)
			as += uint32(in.A) - uint32(gone.A)
		}
	}
	return dst
}

// onWhite 把透明的部分垫上白色（JPEG 没有透明）
func onWhite(img *image.RGBA) *image.RGBA {
	for i := 0; i+3 < len(img.Pix); i += 4 {
		a := uint32(img.Pix[i+3])
		if a == 255 {
			continue
		}
		for c := 0; c < 3; c++ {
			img.Pix[i+c] = uint8((uint32(img.Pix[i+c])*a + 255*(255-a)) / 255)
		}
		img.Pix[i+3] = 255
	}
	return img
}

func encodeJPEG(img image.Image, quality int) ([]byte, error) {
	var buf bytes.Buffer
	if err := jpeg.Encode(&buf, img, &jpeg.Options{Quality: quality}); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}

func encodePNG(img image.Image) ([]byte, error) {
	var buf bytes.Buffer
	if err := png.Encode(&buf, img); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}

// ─────────────────────────── 分析 ───────────────────────────

// analyze 在缩成长边 64 的小图上算亮度与主色
func analyze(img *image.RGBA) BackgroundInfo {
	w, h := fitInside(img.Rect.Dx(), img.Rect.Dy(), 64)
	small := onWhite(scale(img, w, h))
	lums := make([]float64, 0, w*h)
	var sum float64
	type bucket struct {
		r, g, b, n int
	}
	buckets := map[int]*bucket{}
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			c := small.RGBAAt(x, y)
			l := RGBA{c.R, c.G, c.B, 255}.Luminance()
			lums = append(lums, l)
			sum += l
			// 每个通道分 8 档，同一档的颜色算一种
			key := int(c.R>>5)<<6 | int(c.G>>5)<<3 | int(c.B>>5)
			bk := buckets[key]
			if bk == nil {
				bk = &bucket{}
				buckets[key] = bk
			}
			bk.r, bk.g, bk.b, bk.n = bk.r+int(c.R), bk.g+int(c.G), bk.b+int(c.B), bk.n+1
		}
	}
	n := float64(len(lums))
	mean := sum / n
	var variance float64
	for _, l := range lums {
		variance += (l - mean) * (l - mean)
	}
	sort.Float64s(lums)
	p10, p90 := lums[int(0.1*(n-1))], lums[int(0.9*(n-1))]

	list := make([]*bucket, 0, len(buckets))
	for _, b := range buckets {
		list = append(list, b)
	}
	sort.Slice(list, func(i, j int) bool { return list[i].n > list[j].n })
	var colors []string
	var picked []RGBA
	for _, b := range list {
		c := RGBA{uint8(b.r / b.n), uint8(b.g / b.n), uint8(b.b / b.n), 255}
		close := false
		for _, p := range picked {
			if colorDistance(c, p) < 48 {
				close = true
				break
			}
		}
		if close {
			continue
		}
		picked = append(picked, c)
		colors = append(colors, c.Hex())
		if len(colors) == 5 {
			break
		}
	}
	// 相近的颜色合并后不到 3 种：图本来就很单一，按占比补齐
	for _, b := range list {
		if len(colors) >= 3 {
			break
		}
		hex := RGBA{uint8(b.r / b.n), uint8(b.g / b.n), uint8(b.b / b.n), 255}.Hex()
		if !contains(colors, hex) {
			colors = append(colors, hex)
		}
	}
	return BackgroundInfo{
		Luminance:       round3(mean),
		LuminanceSpread: round3(math.Sqrt(variance / n)),
		Colors:          colors,
		MinScrimDark:    round3(scrimForWhiteText(p90)),
		MinScrimLight:   round3(scrimForBlackText(p10)),
	}
}

// scrimForWhiteText：黑色遮罩浓度 a 让亮度 l 降到 l·(1−a)，白字要达到 4.5:1，即 l·(1−a) ≤ 1.05/4.5 − 0.05
func scrimForWhiteText(l float64) float64 {
	limit := 1.05/4.5 - 0.05
	if l <= limit {
		return 0
	}
	return 1 - limit/l
}

// scrimForBlackText：白色遮罩浓度 a 让亮度变成 l + (1−l)·a，黑字要达到 4.5:1，即至少 4.5·0.05 − 0.05
func scrimForBlackText(l float64) float64 {
	limit := 4.5*0.05 - 0.05
	if l >= limit {
		return 0
	}
	return (limit - l) / (1 - l)
}

func colorDistance(a, b RGBA) float64 {
	dr, dg, db := float64(a.R)-float64(b.R), float64(a.G)-float64(b.G), float64(a.B)-float64(b.B)
	return math.Sqrt(dr*dr + dg*dg + db*db)
}

func contains(list []string, v string) bool {
	for _, s := range list {
		if s == v {
			return true
		}
	}
	return false
}

func round3(v float64) float64 { return math.Round(v*1000) / 1000 }
