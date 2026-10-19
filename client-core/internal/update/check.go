package update

import (
	"context"
	"crypto/ed25519"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"time"
)

// Source 是一个提供更新清单的地址；签名在同一地址加 .sig。
type Source struct {
	Name     string `json:"name"`
	Manifest string `json:"manifest"`
}

// DefaultSources 同时请求，谁先返回有效清单用谁：国内用户通常是 Gitee 先到，
// 之后也先从 Gitee 下载安装包。
var DefaultSources = []Source{
	{Name: "github", Manifest: "https://raw.githubusercontent.com/baiyuze/pasteferry/main/updates/latest.json"},
	{Name: "gitee", Manifest: "https://gitee.com/baiyuze/pasteferry/raw/main/updates/latest.json"},
}

// testSourcesFile 放在数据目录里时取代默认地址，只用于发版前的端到端测试。
// 清单照样要用编进程序的公钥验签，所以它改变不了会安装什么。
const testSourcesFile = "update-sources.json"

// LoadSources 返回要请求的清单地址。
func LoadSources(dataDir string) []Source {
	raw, err := os.ReadFile(filepath.Join(dataDir, testSourcesFile))
	if err != nil {
		return DefaultSources
	}
	var s []Source
	if json.Unmarshal(raw, &s) != nil || len(s) == 0 {
		return DefaultSources
	}
	return s
}

// maxManifest 限制清单与签名的大小，免得一个出错的地址把内存吃满。
const maxManifest = 1 << 20

// Found 是一次检查拿到的已验签清单。
type Found struct {
	Manifest *Manifest
	Source   string
	At       time.Time
}

// Checker 请求各个地址的清单并验签。
type Checker struct {
	HTTP    *http.Client
	Sources []Source
	Keys    []ed25519.PublicKey
	// Settle 是第一份有效清单到了之后，再等其他地址多久：两边版本不同时用新的那份
	Settle time.Duration
}

func NewHTTPClient() *http.Client {
	return &http.Client{Timeout: 30 * time.Second}
}

// Check 返回版本最新的有效清单。所有地址都失败时返回最后一个错误。
func (c *Checker) Check(ctx context.Context) (*Found, error) {
	ctx, cancel := context.WithTimeout(ctx, 25*time.Second)
	defer cancel()
	type result struct {
		found *Found
		err   error
	}
	results := make(chan result, len(c.Sources))
	for _, s := range c.Sources {
		go func(s Source) {
			m, err := c.fetch(ctx, s)
			if err != nil {
				results <- result{err: fmt.Errorf("%s: %w", s.Name, err)}
				return
			}
			results <- result{found: &Found{Manifest: m, Source: s.Name, At: time.Now()}}
		}(s)
	}
	var best *Found
	var lastErr error
	settle := c.Settle
	if settle == 0 {
		settle = 2 * time.Second
	}
	var deadline <-chan time.Time
	for pending := len(c.Sources); pending > 0; pending-- {
		select {
		case r := <-results:
			if r.err != nil {
				lastErr = r.err
				continue
			}
			if best == nil {
				deadline = time.After(settle)
				best = r.found
				continue
			}
			a, _ := ParseVersion(best.Manifest.Latest)
			b, _ := ParseVersion(r.found.Manifest.Latest)
			if b.Compare(a) > 0 {
				best = r.found
			}
		case <-deadline:
			return best, nil
		case <-ctx.Done():
			if best != nil {
				return best, nil
			}
			return nil, ctx.Err()
		}
	}
	if best == nil {
		if lastErr == nil {
			lastErr = errors.New("没有可用的更新地址")
		}
		return nil, lastErr
	}
	return best, nil
}

func (c *Checker) fetch(ctx context.Context, s Source) (*Manifest, error) {
	raw, err := c.get(ctx, s.Manifest)
	if err != nil {
		return nil, err
	}
	sig, err := c.get(ctx, s.Manifest+".sig")
	if err != nil {
		return nil, err
	}
	if err := Verify(raw, sig, c.Keys); err != nil {
		return nil, err
	}
	return Parse(raw)
}

func (c *Checker) get(ctx context.Context, url string) ([]byte, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, err
	}
	// 只是一次普通的下载：不带设备 ID、版本号之类的任何标识
	req.Header.Set("User-Agent", "PasteFerry")
	resp, err := c.HTTP.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("HTTP %d", resp.StatusCode)
	}
	raw, err := io.ReadAll(io.LimitReader(resp.Body, maxManifest+1))
	if err != nil {
		return nil, err
	}
	if len(raw) > maxManifest {
		return nil, errors.New("更新清单太大")
	}
	return raw, nil
}
