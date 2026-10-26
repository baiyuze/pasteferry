package profile

import (
	"bytes"
	"errors"
	"image"
	"image/color"
	_ "image/gif" // 注册 GIF 解码器
	"image/jpeg"
	"image/png"
	"io"
	"os"
	"path/filepath"
	"strings"

	"github.com/baiyuze/pasteferry/client-core/internal/imagepreview"
)

// 解码别人发来的图片只用 Go 自带的解码器（内存安全），界面只显示这里重新编码过的结果。
// 能解的：PNG、JPEG、GIF；HEIC、TIFF 在 Mac 上先由系统转成 PNG（imagepreview）。

// maxDecodePixels 是愿意解码的最大像素数，挡住「小文件、超大尺寸」的图片把内存撑爆
const maxDecodePixels = 64 << 20

var ErrNotImage = errors.New("不是能处理的图片")

// decodeLimited 先读尺寸，太大就不解
func decodeLimited(data []byte) (image.Image, error) {
	cfg, _, err := image.DecodeConfig(bytes.NewReader(data))
	if err != nil {
		return nil, ErrNotImage
	}
	if cfg.Width <= 0 || cfg.Height <= 0 || int64(cfg.Width)*int64(cfg.Height) > maxDecodePixels {
		return nil, ErrNotImage
	}
	img, _, err := image.Decode(bytes.NewReader(data))
	if err != nil {
		return nil, ErrNotImage
	}
	return img, nil
}

// readImageFile 读一张图片文件；Go 解不了的格式（HEIC 等）先让系统转成 PNG
func readImageFile(path string, limit int64) ([]byte, error) {
	if !imagepreview.Previewable(path) {
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
	data, err := io.ReadAll(io.LimitReader(f, limit+1))
	if err != nil {
		return nil, err
	}
	if int64(len(data)) > limit {
		return nil, ErrNotImage
	}
	return data, nil
}

// cropSquare 按比例裁出正方形：x、y、size 是 0 到 1；size 为 0 时取中间最大的正方形
func cropSquare(img image.Image, x, y, size float64) image.Rectangle {
	b := img.Bounds()
	w, h := b.Dx(), b.Dy()
	side := w
	if h < side {
		side = h
	}
	if size > 0 && size <= 1 {
		s := int(size * float64(max(w, h)))
		if s > 0 && s < side {
			side = s
		}
	}
	var x0, y0 int
	if size > 0 {
		x0, y0 = int(x*float64(w)), int(y*float64(h))
	} else {
		x0, y0 = (w-side)/2, (h-side)/2
	}
	x0 = min(max(x0, 0), w-side)
	y0 = min(max(y0, 0), h-side)
	return image.Rect(b.Min.X+x0, b.Min.Y+y0, b.Min.X+x0+side, b.Min.Y+y0+side)
}

// scale 把 src 里的 r 区域缩放到 w×h：缩小时按区域取平均（盒式滤波），放大时取最近的像素。
func scale(src image.Image, r image.Rectangle, w, h int) *image.RGBA {
	dst := image.NewRGBA(image.Rect(0, 0, w, h))
	sw, sh := r.Dx(), r.Dy()
	for dy := 0; dy < h; dy++ {
		y0 := r.Min.Y + dy*sh/h
		y1 := r.Min.Y + (dy+1)*sh/h
		if y1 <= y0 {
			y1 = y0 + 1
		}
		for dx := 0; dx < w; dx++ {
			x0 := r.Min.X + dx*sw/w
			x1 := r.Min.X + (dx+1)*sw/w
			if x1 <= x0 {
				x1 = x0 + 1
			}
			// 区域太大时隔几个取一个，缩略图看不出差别
			step := 1
			if n := (x1 - x0) * (y1 - y0); n > 64 {
				step = 2
			}
			var rs, gs, bs, as, n uint64
			for yy := y0; yy < y1; yy += step {
				for xx := x0; xx < x1; xx += step {
					cr, cg, cb, ca := src.At(xx, yy).RGBA()
					rs, gs, bs, as = rs+uint64(cr), gs+uint64(cg), bs+uint64(cb), as+uint64(ca)
					n++
				}
			}
			dst.SetRGBA(dx, dy, color.RGBA{uint8(rs / n >> 8), uint8(gs / n >> 8), uint8(bs / n >> 8), uint8(as / n >> 8)})
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

// encodeJPEG 编码成不超过 limit 字节的 JPEG，质量从高往低试
func encodeJPEG(img image.Image, limit int) ([]byte, error) {
	for _, q := range []int{88, 80, 70, 60, 50, 40} {
		var buf bytes.Buffer
		if err := jpeg.Encode(&buf, img, &jpeg.Options{Quality: q}); err != nil {
			return nil, err
		}
		if buf.Len() <= limit {
			return buf.Bytes(), nil
		}
	}
	return nil, errors.New("图片压不到大小上限以内")
}

func encodePNG(img image.Image) ([]byte, error) {
	var buf bytes.Buffer
	if err := png.Encode(&buf, img); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}
