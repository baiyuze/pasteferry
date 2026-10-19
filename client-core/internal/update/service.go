package update

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"time"
)

// 自动检查的节奏：启动一分钟后查一次，之后每 24 小时一次。
const (
	firstCheckDelay = time.Minute
	checkInterval   = 24 * time.Hour
	// resultFresh 内界面显示「已更新到 X」，之后不再提
	resultFresh = 15 * time.Minute
)

// Service 是后台服务里的更新功能：定时检查、下载、交给更新助手安装。
type Service struct {
	Current Version
	Root    string // 数据目录；下载放在 Root/updates/<版本>/ 里
	Target  Target
	Checker *Checker
	HTTP    *http.Client
	// AutoCheck 为 false 时不自动检查（设置里关掉了）；Skipped 是用户选择跳过的版本
	AutoCheck func() bool
	Skipped   func() string
	// Changed 在检查结果变化时调用，让界面刷新状态
	Changed func()
	Log     *slog.Logger

	mu        sync.Mutex
	found     *Found
	checkedAt time.Time
	lastAuto  time.Time
	files     map[string]string // 版本 → 已下载并校验过的安装包
	result    *Result
}

// NewService 读出上一次安装的结果（如果有）。
func NewService(current, root string, log *slog.Logger) (*Service, error) {
	v, err := ParseVersion(current)
	if err != nil {
		return nil, err
	}
	client := NewHTTPClient()
	s := &Service{
		Current: v, Root: root, Target: DetectTarget(), HTTP: client, Log: log,
		Checker: &Checker{HTTP: client, Sources: LoadSources(root), Keys: PublicKeys()},
		files:   map[string]string{},
	}
	s.result = ReadResult(root)
	return s, nil
}

// Run 按节奏自动检查，直到 ctx 结束。
func (s *Service) Run(ctx context.Context) {
	timer := time.NewTimer(firstCheckDelay)
	defer timer.Stop()
	for {
		select {
		case <-ctx.Done():
			return
		case <-timer.C:
		}
		s.cleanup()
		if s.AutoCheck == nil || s.AutoCheck() {
			s.mu.Lock()
			due := time.Since(s.lastAuto) >= checkInterval
			s.mu.Unlock()
			if due {
				if _, err := s.Check(ctx); err != nil {
					s.Log.Info("自动检查更新失败", "err", err)
				}
				s.mu.Lock()
				s.lastAuto = time.Now()
				s.mu.Unlock()
			}
		}
		timer.Reset(time.Hour)
	}
}

// Check 立即检查一次。
func (s *Service) Check(ctx context.Context) (*Found, error) {
	found, err := s.Checker.Check(ctx)
	if err != nil {
		return nil, err
	}
	s.mu.Lock()
	changed := s.found == nil || s.found.Manifest.Latest != found.Manifest.Latest
	s.found, s.checkedAt = found, time.Now()
	s.mu.Unlock()
	if changed && s.Changed != nil {
		s.Changed()
	}
	return found, nil
}

// Latest 是最近一次检查拿到的清单与检查时间。
func (s *Service) Latest() (*Found, time.Time) {
	s.mu.Lock()
	defer s.mu.Unlock()
	return s.found, s.checkedAt
}

// Notice 是要在界面上提示的新版本：比当前新、没被跳过、自动检查开着。没有返回空字符串。
func (s *Service) Notice() string {
	s.mu.Lock()
	found := s.found
	s.mu.Unlock()
	if found == nil || (s.AutoCheck != nil && !s.AutoCheck()) {
		return ""
	}
	v, err := ParseVersion(found.Manifest.Latest)
	if err != nil || v.Compare(s.Current) <= 0 {
		return ""
	}
	if s.Skipped != nil && s.Skipped() == v.String() {
		return ""
	}
	return v.String()
}

// LastResult 是刚完成的那次安装的结果，过了 resultFresh 就不再提。
func (s *Service) LastResult() *Result {
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.result == nil || time.Since(time.Unix(s.result.At, 0)) > resultFresh {
		return nil
	}
	return s.result
}

// Asset 是这台电脑要下载的安装包。
func (s *Service) Asset(m *Manifest) (Asset, bool) {
	a, ok := m.Assets[s.Target.Asset]
	return a, ok && s.Target.Asset != ""
}

func (s *Service) workDir(version string) string {
	return filepath.Join(s.Root, "updates", version)
}

// Download 下载并校验 version 的安装包。只能下载最近一次检查到的最新版本。
func (s *Service) Download(ctx context.Context, version string, progress func(done, total int64)) error {
	found, _ := s.Latest()
	if found == nil || found.Manifest.Latest != version {
		return errors.New("先检查更新")
	}
	if s.Target.Blocker != "" {
		return fmt.Errorf("这种安装方式不能自动更新（%s）", s.Target.Blocker)
	}
	a, ok := s.Asset(found.Manifest)
	if !ok {
		return errors.New("没有这台电脑可用的安装包")
	}
	s.removeOtherDownloads(version)
	path, err := Download(ctx, s.HTTP, found.Manifest, found.Source, a, s.workDir(version), progress)
	if err != nil {
		return err
	}
	s.mu.Lock()
	s.files[version] = path
	s.mu.Unlock()
	return nil
}

// Install 准备好新版本并启动更新助手。返回 nil 后界面应当立即退出，助手等它退出后替换文件并重新打开。
func (s *Service) Install(version string, uiPID int) error {
	s.mu.Lock()
	path := s.files[version]
	s.mu.Unlock()
	if path == "" {
		return errors.New("安装包还没有下载好")
	}
	work := s.workDir(version)
	p, err := Prepare(s.Target, path, s.Current.String(), version, work, uiPID)
	if err != nil {
		return err
	}
	p.Daemons = []int{os.Getpid(), os.Getppid()}
	if err := Start(p, work); err != nil {
		return err
	}
	s.Log.Info("已启动更新助手", "from", p.From, "to", p.To, "kind", p.Kind)
	return nil
}

// removeOtherDownloads 只保留正在下载的版本，旧的安装包不占地方。
func (s *Service) removeOtherDownloads(keep string) {
	entries, _ := os.ReadDir(filepath.Join(s.Root, "updates"))
	for _, e := range entries {
		if e.IsDir() && e.Name() != keep {
			_ = os.RemoveAll(filepath.Join(s.Root, "updates", e.Name()))
		}
	}
}

// cleanup 删掉已经装上的版本的下载，以及上次替换时没删干净的旧程序。
func (s *Service) cleanup() {
	entries, _ := os.ReadDir(filepath.Join(s.Root, "updates"))
	for _, e := range entries {
		if v, err := ParseVersion(e.Name()); err == nil && e.IsDir() && v.Compare(s.Current) <= 0 {
			_ = os.RemoveAll(filepath.Join(s.Root, "updates", e.Name()))
		}
	}
	if s.Target.App == "" {
		return
	}
	leftovers, _ := filepath.Glob(filepath.Join(filepath.Dir(s.Target.App), ".PasteFerry-*"))
	for _, l := range leftovers {
		// 刚准备好、正等界面退出的新版本不能动
		if st, err := os.Stat(l); err != nil || time.Since(st.ModTime()) < 10*time.Minute {
			continue
		}
		name := filepath.Base(l)
		if strings.HasSuffix(name, ".old") || strings.HasSuffix(name, ".app.old") ||
			strings.HasPrefix(name, ".PasteFerry-update-") || strings.HasSuffix(name, ".app") {
			_ = os.RemoveAll(l)
		}
	}
}
