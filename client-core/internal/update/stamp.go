package update

import (
	"encoding/json"
	"net/url"
	"os"
	"runtime"
	"strings"
	"sync"
	"time"
)

// Stamp 记着上次检查更新的日期，生成请求官网服务器时附带的参数。
type Stamp struct {
	Path     string // 数据目录里的 update-state.json
	Identity string // identity.json：首次运行时写下，用它的时间作为安装日期
	Version  string
	Target   Target
	Lang     func() string
	Now      func() time.Time

	mu     sync.Mutex
	loaded bool
	state  stampFile
	fresh  bool // 状态文件还不存在
}

type stampFile struct {
	FirstRun  string `json:"first_run"`
	LastCheck string `json:"last_check"`
}

const dayLayout = "2006-01-02"

func (s *Stamp) now() time.Time {
	if s.Now != nil {
		return s.Now()
	}
	return time.Now()
}

func (s *Stamp) load(today string) {
	if s.loaded {
		return
	}
	s.loaded = true
	if raw, err := os.ReadFile(s.Path); err == nil && json.Unmarshal(raw, &s.state) == nil && s.state.FirstRun != "" {
		return
	}
	s.fresh = true
	s.state = stampFile{FirstRun: today}
	if st, err := os.Stat(s.Identity); err == nil {
		s.state.FirstRun = st.ModTime().In(time.Local).Format(dayLayout)
	}
}

func (s *Stamp) save() {
	raw, _ := json.Marshal(s.state)
	tmp := s.Path + ".tmp"
	if os.WriteFile(tmp, raw, 0o600) == nil {
		_ = os.Rename(tmp, s.Path)
	}
}

func isoWeek(t time.Time) [2]int {
	y, w := t.ISOWeek()
	return [2]int{y, w}
}

// Query 返回这次请求的参数。commit(true) 在请求成功后记下日期；commit(false) 撤销，
// 让下一次检查重新算。两次检查同时进行时，只有一次会带上「当天首次」。
func (s *Stamp) Query() (url.Values, func(ok bool)) {
	s.mu.Lock()
	defer s.mu.Unlock()
	now := s.now().In(time.Local)
	today := now.Format(dayLayout)
	s.load(today)
	prev, prevFresh := s.state, s.fresh

	flags := ""
	last, err := time.ParseInLocation(dayLayout, s.state.LastCheck, time.Local)
	switch {
	case s.state.LastCheck == "":
		flags = "dwm"
		if s.fresh && daysBetween(s.state.FirstRun, today) <= 1 {
			flags = "ndwm"
		}
	case err != nil || today < s.state.LastCheck:
		// 本机时钟被调回过：这次不算新的一天
	case today != s.state.LastCheck:
		flags = "d"
		if isoWeek(now) != isoWeek(last) {
			flags += "w"
		}
		if now.Format("2006-01") != last.Format("2006-01") {
			flags += "m"
		}
	}
	if flags != "" {
		s.state.LastCheck = today
	}
	s.fresh = false

	q := url.Values{}
	q.Set("v", s.Version)
	q.Set("os", runtime.GOOS)
	q.Set("arch", runtime.GOARCH)
	q.Set("pkg", packageKind(s.Target))
	if s.Lang != nil {
		q.Set("lang", langCode(s.Lang()))
	}
	q.Set("f", flags)
	q.Set("a", ageBucket(daysBetween(s.state.FirstRun, today)))
	return q, func(ok bool) {
		s.mu.Lock()
		defer s.mu.Unlock()
		if ok {
			s.save()
			return
		}
		if s.state.LastCheck == today && prev.LastCheck != today {
			s.state, s.fresh = prev, prevFresh
		}
	}
}

func daysBetween(a, b string) int {
	x, err1 := time.ParseInLocation(dayLayout, a, time.Local)
	y, err2 := time.ParseInLocation(dayLayout, b, time.Local)
	if err1 != nil || err2 != nil || y.Before(x) {
		return 0
	}
	return int(y.Sub(x).Hours()/24 + 0.5)
}

func ageBucket(days int) string {
	switch {
	case days <= 0:
		return "0"
	case days <= 7:
		return "1"
	case days <= 30:
		return "2"
	case days <= 90:
		return "3"
	}
	return "4"
}

func packageKind(t Target) string {
	if t.Blocker == BlockerDev {
		return "dev"
	}
	switch t.Kind {
	case KindMacApp:
		return "dmg"
	case KindWindowsSetup:
		return "exe"
	case KindWindowsPortable:
		return "zip"
	case KindLinuxDeb:
		return "deb"
	case KindLinuxTar:
		return "tar"
	}
	return "other"
}

func langCode(l string) string {
	switch {
	case strings.HasPrefix(l, "zh-Hant-HK") || strings.HasPrefix(l, "zh-HK"):
		return "zh-Hant-HK"
	case strings.HasPrefix(l, "zh-Hant") || strings.HasPrefix(l, "zh-TW"):
		return "zh-Hant-TW"
	case strings.HasPrefix(l, "zh"):
		return "zh-Hans"
	case strings.HasPrefix(l, "ja"):
		return "ja"
	case strings.HasPrefix(l, "en"):
		return "en"
	}
	return "other"
}
