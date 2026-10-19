// Package update 检查、下载并安装新版本。
//
// 更新清单 updates/latest.json 放在 GitHub 仓库里，随发版提交更新，Gitee 镜像同步一份；
// 本地只下载、验签、解析。清单用 Ed25519 签名（updates/latest.json.sig），公钥编进程序：
// 镜像或 CDN 被篡改时，程序不会安装被替换的安装包。每个安装包再按清单里的 SHA-256 校验。
// 设计见 design/auto-update.md。
package update

import (
	"crypto/ed25519"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"strconv"
	"strings"
)

// Schema 是清单格式的版本。不认识的格式一律当作没有更新，不去猜。
const Schema = 1

// Manifest 是 updates/latest.json 的内容。
type Manifest struct {
	Schema int    `json:"schema"`
	Latest string `json:"latest"`
	Date   string `json:"date"`
	// Mirrors 是最新版安装包所在的目录，文件名见 Assets。source 与 Source.Name 对应：
	// 从哪个源拿到的清单，就先从同一个源下载
	Mirrors []Mirror         `json:"mirrors"`
	Assets  map[string]Asset `json:"assets"`
	// Releases 按版本从新到旧，最多保留最近 10 个版本的更新日志
	Releases []Release `json:"releases"`
}

type Mirror struct {
	Source string `json:"source"`
	Base   string `json:"base"`
}

type Asset struct {
	Name   string `json:"name"`
	Size   int64  `json:"size"`
	SHA256 string `json:"sha256"`
}

type Release struct {
	Version string `json:"version"`
	Date    string `json:"date"`
	// Notes 的键是界面语言：en、zh-Hans、zh-Hant-TW、zh-Hant-HK、ja
	Notes map[string]Notes `json:"notes"`
}

type Notes struct {
	Changes []string `json:"changes,omitempty"`
	Fixes   []string `json:"fixes,omitempty"`
}

// Languages 是更新日志必须齐全的语言，与界面支持的语言一致。
var Languages = []string{"en", "zh-Hans", "zh-Hant-TW", "zh-Hant-HK", "ja"}

// fallback 是缺某种语言时依次尝试的语言：香港用台湾的繁体，繁体都没有时用简体，最后用英文。
var fallback = map[string][]string{
	"zh-Hant-HK": {"zh-Hant-HK", "zh-Hant-TW", "zh-Hans", "en"},
	"zh-Hant-TW": {"zh-Hant-TW", "zh-Hant-HK", "zh-Hans", "en"},
	"zh-Hans":    {"zh-Hans", "zh-Hant-TW", "en"},
	"ja":         {"ja", "en"},
	"en":         {"en"},
}

// Localized 按界面语言挑出这一版的更新日志。
func (r Release) Localized(lang string) Notes {
	order, ok := fallback[lang]
	if !ok {
		order = fallback["en"]
	}
	for _, l := range order {
		if n, ok := r.Notes[l]; ok && (len(n.Changes) > 0 || len(n.Fixes) > 0) {
			return n
		}
	}
	return Notes{}
}

// Verify 用编进程序的公钥验证清单签名。sig 是 base64，允许末尾的换行。
func Verify(raw, sig []byte, keys []ed25519.PublicKey) error {
	s, err := base64.StdEncoding.DecodeString(strings.TrimSpace(string(sig)))
	if err != nil || len(s) != ed25519.SignatureSize {
		return errors.New("更新清单的签名格式不对")
	}
	for _, k := range keys {
		if ed25519.Verify(k, raw, s) {
			return nil
		}
	}
	return errors.New("更新清单的签名不对")
}

// Parse 解析已验签的清单，并检查它自洽：最新版本有安装包、有下载地址。
func Parse(raw []byte) (*Manifest, error) {
	var m Manifest
	if err := json.Unmarshal(raw, &m); err != nil {
		return nil, fmt.Errorf("解析更新清单: %w", err)
	}
	if m.Schema != Schema {
		return nil, fmt.Errorf("不认识的更新清单格式 %d", m.Schema)
	}
	if _, err := ParseVersion(m.Latest); err != nil {
		return nil, err
	}
	if len(m.Mirrors) == 0 || len(m.Assets) == 0 {
		return nil, errors.New("更新清单里没有安装包")
	}
	for key, a := range m.Assets {
		if a.Name == "" || strings.ContainsAny(a.Name, `/\`) || a.Size <= 0 || len(a.SHA256) != 64 {
			return nil, fmt.Errorf("更新清单里的安装包 %s 不完整", key)
		}
	}
	return &m, nil
}

// Newer 返回比 current 新的各版更新日志，从新到旧。
func (m *Manifest) Newer(current Version) []Release {
	var out []Release
	for _, r := range m.Releases {
		if v, err := ParseVersion(r.Version); err == nil && v.Compare(current) > 0 {
			out = append(out, r)
		}
	}
	return out
}

// Version 是 X.Y.Z，可以带 -后缀（开发与测试构建）。带后缀的比同号的正式版旧。
type Version struct {
	Major, Minor, Patch int
	Pre                 string
}

func ParseVersion(s string) (Version, error) {
	core, pre, _ := strings.Cut(strings.TrimPrefix(strings.TrimSpace(s), "v"), "-")
	parts := strings.Split(core, ".")
	if len(parts) != 3 {
		return Version{}, fmt.Errorf("版本号 %q 不是 X.Y.Z", s)
	}
	var n [3]int
	for i, p := range parts {
		v, err := strconv.Atoi(p)
		if err != nil || v < 0 {
			return Version{}, fmt.Errorf("版本号 %q 不是 X.Y.Z", s)
		}
		n[i] = v
	}
	return Version{n[0], n[1], n[2], pre}, nil
}

func (v Version) Compare(o Version) int {
	for _, d := range [][2]int{{v.Major, o.Major}, {v.Minor, o.Minor}, {v.Patch, o.Patch}} {
		if d[0] != d[1] {
			if d[0] < d[1] {
				return -1
			}
			return 1
		}
	}
	switch {
	case v.Pre == o.Pre:
		return 0
	case v.Pre == "":
		return 1
	case o.Pre == "":
		return -1
	case v.Pre < o.Pre:
		return -1
	default:
		return 1
	}
}

func (v Version) String() string {
	s := fmt.Sprintf("%d.%d.%d", v.Major, v.Minor, v.Patch)
	if v.Pre != "" {
		s += "-" + v.Pre
	}
	return s
}
