// Package theme 保存界面的主题与背景图，见 design/themes.md。
//
// 主题是一份 JSON：内置的 default、pixel 嵌在程序里（builtin/），自定义的存在数据目录的
// themes/<id>.json。自定义主题用 base 继承另一套主题，只写想改的字段。
// 界面、CLI、MCP 都经后台服务读写主题，校验统一在这里做。
package theme

import (
	"embed"
	"encoding/json"
	"fmt"
	"math"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

// Schema 是这个版本认识的主题格式版本
const Schema = 1

// 内置主题的 id。界面里的配色常量（ui/lib/theme.dart、ui/lib/pixel_theme.dart）要与 builtin/ 里的一致
const (
	DefaultID = "default"
	PixelID   = "pixel"
)

var builtinIDs = []string{DefaultID, PixelID}

//go:embed builtin/*.json
var builtinFS embed.FS

// Roles 是一种模式（浅色或深色）里的颜色角色，与界面 AppPalette 的字段同名
var Roles = []string{
	"accent", "background", "sidebar", "surface", "border", "borderStrong", "separator",
	"text", "textDim", "textFaint", "selection", "hover", "fill",
	"online", "warning", "danger", "onAccent", "inverse", "onInverse",
	"bevelLight", "bevelDark", "shadow",
}

var roleSet = func() map[string]bool {
	m := map[string]bool{}
	for _, r := range Roles {
		m[r] = true
	}
	return m
}()

// Modes 是浅色与深色
var Modes = []string{"light", "dark"}

// Theme 是一套主题。指针字段为空表示不覆盖 base 的值
type Theme struct {
	Schema     int                          `json:"schema"`
	ID         string                       `json:"id"`
	Name       map[string]string            `json:"name,omitempty"`
	Base       string                       `json:"base,omitempty"`
	Modes      map[string]map[string]string `json:"modes,omitempty"`
	Typography *Typography                  `json:"typography,omitempty"`
	Shape      *Shape                       `json:"shape,omitempty"`
	Motion     string                       `json:"motion,omitempty"` // smooth、stepped、reduced
	Icons      string                       `json:"icons,omitempty"`  // system、pixel
	// 页面顶部的风景与侧边栏底部的小图：像素边角的主题默认画像素风景，Scene 可以换成自己的图；
	// false 时都不画。显示整窗背景图时总是不画
	Scenery    *bool       `json:"scenery,omitempty"`
	Scene      *Scene      `json:"scene,omitempty"`
	Background *Background `json:"background,omitempty"`
}

type Typography struct {
	Family *string `json:"family,omitempty"` // system，或 App 自带的 FusionPixel
	Mono   *string `json:"mono,omitempty"`   // system，或 FusionPixelMono
	// 允许的字号；空数组表示不限（点阵字体要吸附到设计字号的整数倍）
	Sizes *[]float64 `json:"sizes,omitempty"`
}

type Radius struct {
	Sm *float64 `json:"sm,omitempty"`
	Md *float64 `json:"md,omitempty"`
	Lg *float64 `json:"lg,omitempty"`
}

type Shape struct {
	Radius      *Radius  `json:"radius,omitempty"`
	Corner      string   `json:"corner,omitempty"` // round、pixel
	BorderWidth *float64 `json:"borderWidth,omitempty"`
	Unit        *float64 `json:"unit,omitempty"`   // 像素角的一格
	Shadow      string   `json:"shadow,omitempty"` // soft、hard、none
}

type Scrim struct {
	Color   string   `json:"color,omitempty"`
	Opacity *float64 `json:"opacity,omitempty"`
}

// Scene 把风景换成导入的图（design/themes.md 第 7.6 节）：Header 铺在页面标题后面，
// Sidebar 在侧边栏底部。都写成 "user:<sha256>"；*Dark 是深色模式另用的一张
type Scene struct {
	Header      string `json:"header,omitempty"`
	HeaderDark  string `json:"headerDark,omitempty"`
	Sidebar     string `json:"sidebar,omitempty"`
	SidebarDark string `json:"sidebarDark,omitempty"`
}

func (c *Scene) images() []string {
	if c == nil {
		return nil
	}
	return []string{c.Header, c.HeaderDark, c.Sidebar, c.SidebarDark}
}

// Background 是背景图，见 design/themes.md 第 7 节
type Background struct {
	// "asset:<名字>" 是 App 自带的图，"user:<sha256>" 是 ImportBackground 导入的图
	Image string `json:"image,omitempty"`
	// 深色模式另用的一张；空时两种模式用同一张
	ImageDark       string   `json:"imageDark,omitempty"`
	Fit             string   `json:"fit,omitempty"`   // cover、contain、tile
	Align           string   `json:"align,omitempty"` // center、top、bottom、left、right、topLeft……
	Blur            *float64 `json:"blur,omitempty"`  // 0 到 40
	Scrim           *Scrim   `json:"scrim,omitempty"`
	SurfaceOpacity  *float64 `json:"surfaceOpacity,omitempty"` // 0.6 到 1
	Scope           []string `json:"scope,omitempty"`          // main、picker、mobile
	AccentFromImage *bool    `json:"accentFromImage,omitempty"`
}

// InvalidError 是主题写得不对：界面直接把它显示给用户
type InvalidError struct{ Msg string }

func (e *InvalidError) Error() string { return e.Msg }

func invalid(format string, a ...any) error { return &InvalidError{Msg: fmt.Sprintf(format, a...)} }

// IsBuiltin 报告 id 是不是内置主题
func IsBuiltin(id string) bool {
	for _, b := range builtinIDs {
		if id == b {
			return true
		}
	}
	return false
}

func builtin(id string) (Theme, []byte, error) {
	data, err := builtinFS.ReadFile("builtin/" + id + ".json")
	if err != nil {
		return Theme{}, nil, err
	}
	var t Theme
	if err := json.Unmarshal(data, &t); err != nil {
		return Theme{}, nil, err
	}
	return t, data, nil
}

// Parse 读一份主题 JSON。不认识的字段忽略；schema 比本机新时拒绝，提示升级
func Parse(data []byte) (Theme, error) {
	if len(data) > maxThemeBytes {
		return Theme{}, invalid("主题文件太大（超过 %d KB）", maxThemeBytes>>10)
	}
	var t Theme
	if err := json.Unmarshal(data, &t); err != nil {
		return Theme{}, invalid("主题不是有效的 JSON：%v", err)
	}
	switch {
	case t.Schema == 0:
		return Theme{}, invalid("缺少 schema（主题格式版本）")
	case t.Schema > Schema:
		return Theme{}, invalid("主题格式版本 %d 比这个版本的隔空贴新，请先升级", t.Schema)
	case t.Schema < 0:
		return Theme{}, invalid("schema 不对：%d", t.Schema)
	}
	return t, nil
}

const maxThemeBytes = 64 << 10

var (
	assetRef = regexp.MustCompile(`^asset:[a-z0-9-]{1,40}$`)
	userRef  = regexp.MustCompile(`^user:[0-9a-f]{64}$`)
)

// validate 检查自定义主题 t 本身的格式；base 是否存在、继承深度由 Store 检查
func validate(t Theme) error {
	if t.ID == "" {
		return invalid("缺少 id")
	}
	if !validID(t.ID) {
		return invalid("id 只能用小写字母、数字和连字符，最长 40 个字符：%q", t.ID)
	}
	if IsBuiltin(t.ID) {
		return invalid("%q 是内置主题，不能覆盖；换一个 id", t.ID)
	}
	if t.Base == t.ID {
		return invalid("主题不能继承自己")
	}
	if t.Base != "" && !validID(t.Base) {
		return invalid("base 不对：%q", t.Base)
	}
	for lang, name := range t.Name {
		if lang == "" || len(lang) > 20 {
			return invalid("名字的语言代码不对：%q", lang)
		}
		if n := len([]rune(name)); n == 0 || n > 40 {
			return invalid("名字要有 1 到 40 个字：%q", name)
		}
	}
	for mode, colors := range t.Modes {
		if mode != "light" && mode != "dark" {
			return invalid("modes 里只能有 light 与 dark，没有 %q", mode)
		}
		for role, c := range colors {
			if !roleSet[role] {
				return invalid("%s 里没有 %q 这个颜色角色", mode, role)
			}
			if _, err := ParseColor(c); err != nil {
				return invalid("%s.%s：%v", mode, role, err)
			}
		}
	}
	if ty := t.Typography; ty != nil {
		if ty.Family != nil && !oneOf(*ty.Family, "system", "FusionPixel") {
			return invalid("typography.family 只能是 system 或 FusionPixel，不能是 %q", *ty.Family)
		}
		if ty.Mono != nil && !oneOf(*ty.Mono, "system", "FusionPixelMono") {
			return invalid("typography.mono 只能是 system 或 FusionPixelMono，不能是 %q", *ty.Mono)
		}
		if ty.Sizes != nil {
			if len(*ty.Sizes) > 6 {
				return invalid("typography.sizes 最多 6 档")
			}
			for _, s := range *ty.Sizes {
				if err := inRange("typography.sizes", s, 8, 48); err != nil {
					return err
				}
			}
		}
	}
	if sh := t.Shape; sh != nil {
		if r := sh.Radius; r != nil {
			for name, v := range map[string]*float64{"sm": r.Sm, "md": r.Md, "lg": r.Lg} {
				if v != nil {
					if err := inRange("shape.radius."+name, *v, 0, 32); err != nil {
						return err
					}
				}
			}
		}
		if sh.Corner != "" && !oneOf(sh.Corner, "round", "pixel") {
			return invalid("shape.corner 只能是 round 或 pixel，不能是 %q", sh.Corner)
		}
		if sh.BorderWidth != nil {
			if err := inRange("shape.borderWidth", *sh.BorderWidth, 0, 4); err != nil {
				return err
			}
		}
		if sh.Unit != nil {
			if err := inRange("shape.unit", *sh.Unit, 1, 8); err != nil {
				return err
			}
		}
		if sh.Shadow != "" && !oneOf(sh.Shadow, "soft", "hard", "none") {
			return invalid("shape.shadow 只能是 soft、hard 或 none，不能是 %q", sh.Shadow)
		}
	}
	if t.Motion != "" && !oneOf(t.Motion, "smooth", "stepped", "reduced") {
		return invalid("motion 只能是 smooth、stepped 或 reduced，不能是 %q", t.Motion)
	}
	if t.Icons != "" && !oneOf(t.Icons, "system", "pixel") {
		return invalid("icons 只能是 system 或 pixel，不能是 %q", t.Icons)
	}
	for _, img := range t.Scene.images() {
		if img != "" && !userRef.MatchString(img) {
			return invalid("scene 里的图片要写成 user:<sha256>（先用 background_import 导入），不能是 %q", img)
		}
	}
	if b := t.Background; b != nil {
		for _, img := range []string{b.Image, b.ImageDark} {
			if img != "" && !assetRef.MatchString(img) && !userRef.MatchString(img) {
				return invalid("background 的图片要写成 asset:<名字> 或 user:<sha256>，不能是 %q", img)
			}
		}
		if b.Fit != "" && !oneOf(b.Fit, "cover", "contain", "tile") {
			return invalid("background.fit 只能是 cover、contain 或 tile，不能是 %q", b.Fit)
		}
		if b.Align != "" && !oneOf(b.Align, "center", "top", "bottom", "left", "right",
			"topLeft", "topRight", "bottomLeft", "bottomRight") {
			return invalid("background.align 不对：%q", b.Align)
		}
		if b.Blur != nil {
			if err := inRange("background.blur", *b.Blur, 0, 40); err != nil {
				return err
			}
		}
		if s := b.Scrim; s != nil {
			if s.Color != "" {
				if _, err := ParseColor(s.Color); err != nil {
					return invalid("background.scrim.color：%v", err)
				}
			}
			if s.Opacity != nil {
				if err := inRange("background.scrim.opacity", *s.Opacity, 0, 1); err != nil {
					return err
				}
			}
		}
		if b.SurfaceOpacity != nil {
			if err := inRange("background.surfaceOpacity", *b.SurfaceOpacity, 0.6, 1); err != nil {
				return err
			}
		}
		for _, s := range b.Scope {
			if !oneOf(s, "main", "picker", "mobile") {
				return invalid("background.scope 里只能有 main、picker、mobile，不能是 %q", s)
			}
		}
	}
	return nil
}

func validID(id string) bool {
	if id == "" || len(id) > 40 {
		return false
	}
	for _, r := range id {
		if !(r >= 'a' && r <= 'z' || r >= '0' && r <= '9' || r == '-') {
			return false
		}
	}
	return true
}

func oneOf(v string, allowed ...string) bool {
	for _, a := range allowed {
		if v == a {
			return true
		}
	}
	return false
}

func inRange(name string, v, lo, hi float64) error {
	if math.IsNaN(v) || v < lo || v > hi {
		return invalid("%s 要在 %g 到 %g 之间，不能是 %g", name, lo, hi, v)
	}
	return nil
}

// merge 把 child 叠在已经合并好的 base 上：child 写了的字段覆盖，没写的沿用 base
func merge(base, child Theme) Theme {
	out := base
	out.Schema = Schema
	out.ID = child.ID
	out.Base = child.Base
	if out.Base == "" {
		out.Base = DefaultID
	}
	if len(child.Name) > 0 {
		out.Name = child.Name
	}
	out.Modes = map[string]map[string]string{}
	for _, m := range Modes {
		colors := map[string]string{}
		for k, v := range base.Modes[m] {
			colors[k] = v
		}
		for k, v := range child.Modes[m] {
			colors[k] = v
		}
		out.Modes[m] = colors
	}
	if c := child.Typography; c != nil {
		t := Typography{}
		if base.Typography != nil {
			t = *base.Typography
		}
		if c.Family != nil {
			t.Family = c.Family
		}
		if c.Mono != nil {
			t.Mono = c.Mono
		}
		if c.Sizes != nil {
			t.Sizes = c.Sizes
		}
		out.Typography = &t
	}
	if c := child.Shape; c != nil {
		s := Shape{}
		if base.Shape != nil {
			s = *base.Shape
		}
		if c.Radius != nil {
			r := Radius{}
			if s.Radius != nil {
				r = *s.Radius
			}
			if c.Radius.Sm != nil {
				r.Sm = c.Radius.Sm
			}
			if c.Radius.Md != nil {
				r.Md = c.Radius.Md
			}
			if c.Radius.Lg != nil {
				r.Lg = c.Radius.Lg
			}
			s.Radius = &r
		}
		if c.Corner != "" {
			s.Corner = c.Corner
		}
		if c.BorderWidth != nil {
			s.BorderWidth = c.BorderWidth
		}
		if c.Unit != nil {
			s.Unit = c.Unit
		}
		if c.Shadow != "" {
			s.Shadow = c.Shadow
		}
		out.Shape = &s
	}
	if child.Motion != "" {
		out.Motion = child.Motion
	}
	if child.Icons != "" {
		out.Icons = child.Icons
	}
	if child.Scenery != nil {
		out.Scenery = child.Scenery
	}
	if c := child.Scene; c != nil {
		sc := Scene{}
		if base.Scene != nil {
			sc = *base.Scene
		}
		for _, f := range []struct {
			dst *string
			src string
		}{
			{&sc.Header, c.Header}, {&sc.HeaderDark, c.HeaderDark}, {&sc.Sidebar, c.Sidebar}, {&sc.SidebarDark, c.SidebarDark},
		} {
			if f.src != "" {
				*f.dst = f.src
			}
		}
		out.Scene = &sc
	}
	if c := child.Background; c != nil {
		b := Background{}
		if base.Background != nil {
			b = *base.Background
		}
		if c.Image != "" {
			b.Image = c.Image
		}
		if c.ImageDark != "" {
			b.ImageDark = c.ImageDark
		}
		if c.Fit != "" {
			b.Fit = c.Fit
		}
		if c.Align != "" {
			b.Align = c.Align
		}
		if c.Blur != nil {
			b.Blur = c.Blur
		}
		if c.Scrim != nil {
			b.Scrim = c.Scrim
		}
		if c.SurfaceOpacity != nil {
			b.SurfaceOpacity = c.SurfaceOpacity
		}
		if c.Scope != nil {
			b.Scope = c.Scope
		}
		if c.AccentFromImage != nil {
			b.AccentFromImage = c.AccentFromImage
		}
		out.Background = &b
	}
	return out
}

// ─────────────────────────── 颜色与对比度 ───────────────────────────

// RGBA 是 0 到 255 的颜色分量
type RGBA struct{ R, G, B, A uint8 }

// ParseColor 读 "#RRGGBB" 或 "#AARRGGBB"（与界面的 Color(0xAARRGGBB) 同序）
func ParseColor(s string) (RGBA, error) {
	if !strings.HasPrefix(s, "#") || (len(s) != 7 && len(s) != 9) {
		return RGBA{}, fmt.Errorf("颜色要写成 #RRGGBB 或 #AARRGGBB，不能是 %q", s)
	}
	v, err := strconv.ParseUint(s[1:], 16, 32)
	if err != nil {
		return RGBA{}, fmt.Errorf("颜色要写成 #RRGGBB 或 #AARRGGBB，不能是 %q", s)
	}
	if len(s) == 7 {
		v |= 0xFF000000
	}
	return RGBA{R: uint8(v >> 16), G: uint8(v >> 8), B: uint8(v), A: uint8(v >> 24)}, nil
}

// Hex 写成 "#RRGGBB"（不透明）或 "#AARRGGBB"
func (c RGBA) Hex() string {
	if c.A == 255 {
		return fmt.Sprintf("#%02X%02X%02X", c.R, c.G, c.B)
	}
	return fmt.Sprintf("#%02X%02X%02X%02X", c.A, c.R, c.G, c.B)
}

// over 把半透明的 c 叠在不透明的 bg 上
func (c RGBA) over(bg RGBA) RGBA {
	a := float64(c.A) / 255
	mix := func(f, b uint8) uint8 { return uint8(math.Round(float64(f)*a + float64(b)*(1-a))) }
	return RGBA{R: mix(c.R, bg.R), G: mix(c.G, bg.G), B: mix(c.B, bg.B), A: 255}
}

func channel(v uint8) float64 {
	c := float64(v) / 255
	if c <= 0.03928 {
		return c / 12.92
	}
	return math.Pow((c+0.055)/1.055, 2.4)
}

// Luminance 是 WCAG 的相对亮度，0 到 1
func (c RGBA) Luminance() float64 {
	return 0.2126*channel(c.R) + 0.7152*channel(c.G) + 0.0722*channel(c.B)
}

// Contrast 是 WCAG 对比度，1 到 21。半透明的前景先叠在背景上
func Contrast(fg, bg RGBA) float64 {
	bg.A = 255
	if fg.A < 255 {
		fg = fg.over(bg)
	}
	l1, l2 := fg.Luminance(), bg.Luminance()
	if l1 < l2 {
		l1, l2 = l2, l1
	}
	return (l1 + 0.05) / (l2 + 0.05)
}

// Warning 是一对颜色的对比度不够
type Warning struct {
	Mode       string
	Foreground string
	Background string
	Ratio      float64
	Minimum    float64
}

// contrastPairs 是 design/themes.md 第 8 节要求的几对颜色
var contrastPairs = []struct {
	fg, bg string
	min    float64
}{
	{"text", "background", 4.5},
	{"text", "surface", 4.5},
	{"textDim", "background", 4.5},
	{"textDim", "surface", 4.5},
	{"textFaint", "background", 3},
	{"textFaint", "surface", 3},
	{"onAccent", "accent", 4.5},
}

// checkContrast 检查合并好的主题 t。base 是合并好的 base 主题：两种颜色都和 base 一样的那一对不报，
// 免得只改了强调色的主题也因为 base 本来的配色收到一堆警告
func checkContrast(t, base Theme) []Warning {
	var out []Warning
	for _, mode := range Modes {
		colors, baseColors := t.Modes[mode], base.Modes[mode]
		for _, p := range contrastPairs {
			fgHex, bgHex := colors[p.fg], colors[p.bg]
			if fgHex == "" || bgHex == "" {
				continue
			}
			if strings.EqualFold(fgHex, baseColors[p.fg]) && strings.EqualFold(bgHex, baseColors[p.bg]) {
				continue
			}
			fg, err1 := ParseColor(fgHex)
			bg, err2 := ParseColor(bgHex)
			if err1 != nil || err2 != nil {
				continue
			}
			if r := Contrast(fg, bg); r < p.min {
				out = append(out, Warning{Mode: mode, Foreground: p.fg, Background: p.bg,
					Ratio: math.Round(r*100) / 100, Minimum: p.min})
			}
		}
	}
	sort.SliceStable(out, func(i, j int) bool { return out[i].Mode > out[j].Mode })
	return out
}
