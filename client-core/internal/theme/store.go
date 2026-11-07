package theme

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"sync"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
)

var (
	ErrNotFound = errors.New("没有这个主题")
	ErrBuiltin  = errors.New("内置主题不能修改或删除")
	// ErrIsBase 是要删的主题还被别的主题当作 base
	ErrIsBase = errors.New("还有主题继承它，先删掉或改掉那些主题")
	// ErrInUse 是要删的背景图还有主题在用
	ErrInUse = errors.New("还有主题在用这张背景图")
)

// maxDepth 是自定义主题最多往上继承几层自定义主题（再往上就是内置主题）
const maxDepth = 2

// Info 是主题列表里的一项
type Info struct {
	ID      string
	Name    map[string]string
	Builtin bool
	Base    string
}

// Store 读写数据目录里的自定义主题与背景图
type Store struct {
	mu          sync.Mutex
	dir         string
	backgrounds string
}

func NewStore(p config.Paths) *Store {
	return &Store{dir: p.Themes, backgrounds: p.Backgrounds}
}

func (s *Store) path(id string) string { return filepath.Join(s.dir, id+".json") }

// load 读一套主题的原样（未合并 base）
func (s *Store) load(id string) (Theme, []byte, error) {
	if id == "" {
		id = DefaultID
	}
	if IsBuiltin(id) {
		return builtin(id)
	}
	if !validID(id) {
		return Theme{}, nil, ErrNotFound
	}
	data, err := os.ReadFile(s.path(id))
	if errors.Is(err, os.ErrNotExist) {
		return Theme{}, nil, ErrNotFound
	}
	if err != nil {
		return Theme{}, nil, err
	}
	t, err := Parse(data)
	if err != nil {
		return Theme{}, nil, fmt.Errorf("主题 %s 的文件坏了：%w", id, err)
	}
	t.ID = id
	return t, data, nil
}

// resolve 合并 base，返回完整的主题。seen 防止继承成环
func (s *Store) resolve(t Theme, depth int, seen map[string]bool) (Theme, error) {
	if IsBuiltin(t.ID) {
		return t, nil
	}
	if depth > maxDepth {
		return Theme{}, invalid("继承太深：自定义主题最多往上继承 %d 层自定义主题", maxDepth)
	}
	if seen[t.ID] {
		return Theme{}, invalid("主题的继承关系成了环：%s", t.ID)
	}
	seen[t.ID] = true
	baseID := t.Base
	if baseID == "" {
		baseID = DefaultID
	}
	base, _, err := s.load(baseID)
	if errors.Is(err, ErrNotFound) {
		return Theme{}, invalid("base 主题 %q 不存在", baseID)
	}
	if err != nil {
		return Theme{}, err
	}
	resolved, err := s.resolve(base, depth+1, seen)
	if err != nil {
		return Theme{}, err
	}
	return merge(resolved, t), nil
}

// Exists 报告有没有这套主题（空字符串是默认主题）
func (s *Store) Exists(id string) bool {
	_, _, err := s.load(id)
	return err == nil
}

// List 返回内置主题与自定义主题，内置的在前
func (s *Store) List() ([]Info, error) {
	var out []Info
	for _, id := range builtinIDs {
		t, _, err := builtin(id)
		if err != nil {
			return nil, err
		}
		out = append(out, Info{ID: id, Name: t.Name, Builtin: true})
	}
	entries, err := os.ReadDir(s.dir)
	if err != nil && !errors.Is(err, os.ErrNotExist) {
		return nil, err
	}
	var custom []Info
	for _, e := range entries {
		id, ok := strings.CutSuffix(e.Name(), ".json")
		if !ok || e.IsDir() || !validID(id) || IsBuiltin(id) {
			continue
		}
		t, _, err := s.load(id)
		if err != nil {
			continue // 坏掉的文件不列出来，免得界面拿到一套用不了的主题
		}
		base := t.Base
		if base == "" {
			base = DefaultID
		}
		custom = append(custom, Info{ID: id, Name: t.Name, Base: base})
	}
	sort.Slice(custom, func(i, j int) bool { return custom[i].ID < custom[j].ID })
	return append(out, custom...), nil
}

// Get 返回一套主题的 JSON。resolved 时合并了 base，各项齐全；否则是保存时的样子
func (s *Store) Get(id string, resolved bool) ([]byte, error) {
	t, raw, err := s.load(id)
	if err != nil {
		return nil, err
	}
	if !resolved || IsBuiltin(t.ID) {
		return raw, nil
	}
	r, err := s.resolve(t, 0, map[string]bool{})
	if err != nil {
		return nil, err
	}
	return json.MarshalIndent(r, "", "  ")
}

// Put 校验并保存一套自定义主题，返回它的 id 与对比度警告。格式不对时返回 *InvalidError
func (s *Store) Put(data []byte) (string, []Warning, error) { return s.put(data, false) }

// Check 与 Put 做同样的校验、算同样的警告，但不保存（AI 改主题前先试一遍）
func (s *Store) Check(data []byte) (string, []Warning, error) { return s.put(data, true) }

func (s *Store) put(data []byte, dryRun bool) (string, []Warning, error) {
	t, err := Parse(data)
	if err != nil {
		return "", nil, err
	}
	if err := validate(t); err != nil {
		return "", nil, err
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	for _, img := range s.userImages(t) {
		if !s.hasBackground(img) {
			return "", nil, invalid("背景图 user:%s 不存在，先导入", img)
		}
	}
	resolved, err := s.resolve(t, 0, map[string]bool{})
	if err != nil {
		return "", nil, err
	}
	// 改一套已有主题时，继承它的主题也要还能合并（不成环、不超深度）
	if err := s.checkChildren(t); err != nil {
		return "", nil, err
	}
	baseID := t.Base
	if baseID == "" {
		baseID = DefaultID
	}
	baseRaw, _, _ := s.load(baseID)
	base, err := s.resolve(baseRaw, 1, map[string]bool{t.ID: true})
	if err != nil {
		return "", nil, err
	}
	if dryRun {
		return t.ID, checkContrast(resolved, base), nil
	}
	out, err := json.MarshalIndent(t, "", "  ")
	if err != nil {
		return "", nil, err
	}
	if err := os.MkdirAll(s.dir, 0o700); err != nil {
		return "", nil, err
	}
	if err := writeAtomic(s.path(t.ID), out); err != nil {
		return "", nil, err
	}
	return t.ID, checkContrast(resolved, base), nil
}

// checkChildren 假设 t 已经保存，检查所有自定义主题还能合并
func (s *Store) checkChildren(t Theme) error {
	entries, err := os.ReadDir(s.dir)
	if err != nil {
		return nil
	}
	for _, e := range entries {
		id, ok := strings.CutSuffix(e.Name(), ".json")
		if !ok || id == t.ID || !validID(id) {
			continue
		}
		other, _, err := s.load(id)
		if err != nil {
			continue
		}
		if err := s.resolveWith(other, t); err != nil {
			return invalid("这样改后，继承它的主题 %s 用不了了：%v", id, err)
		}
	}
	return nil
}

// resolveWith 合并 other，其中 id 为 replaced.ID 的那一层用 replaced 代替磁盘上的版本
func (s *Store) resolveWith(other, replaced Theme) error {
	seen := map[string]bool{}
	cur := other
	for depth := 0; !IsBuiltin(cur.ID); depth++ {
		if depth > maxDepth {
			return invalid("继承太深")
		}
		if seen[cur.ID] {
			return invalid("继承成了环")
		}
		seen[cur.ID] = true
		next := cur.Base
		if next == "" {
			next = DefaultID
		}
		if next == replaced.ID {
			cur = replaced
			continue
		}
		t, _, err := s.load(next)
		if err != nil {
			return err
		}
		cur = t
	}
	return nil
}

// Delete 删一套自定义主题
func (s *Store) Delete(id string) error {
	if IsBuiltin(id) || id == "" {
		return ErrBuiltin
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	if _, _, err := s.load(id); err != nil {
		return err
	}
	infos, err := s.List()
	if err != nil {
		return err
	}
	for _, info := range infos {
		if !info.Builtin && info.ID != id && info.Base == id {
			return ErrIsBase
		}
	}
	return os.Remove(s.path(id))
}

// userImages 是主题 t 自己引用的导入背景图的 sha256
func (s *Store) userImages(t Theme) []string {
	refs := t.Scene.images()
	if t.Background != nil {
		refs = append(refs, t.Background.Image, t.Background.ImageDark)
	}
	var out []string
	for _, img := range refs {
		if sha, ok := strings.CutPrefix(img, "user:"); ok {
			out = append(out, sha)
		}
	}
	return out
}

func writeAtomic(path string, data []byte) error {
	tmp := path + ".tmp"
	if err := os.WriteFile(tmp, data, 0o600); err != nil {
		return err
	}
	return os.Rename(tmp, path)
}
