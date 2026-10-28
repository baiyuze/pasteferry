package sync

// 收藏：另存一份、不会过期，取消时放回复制记录。见 design/quick-paste-and-favorites.md 第 3 节。
//
// 收藏和复制记录存在同一张表里，各占独立的一行（store.Clip.Favorite）。图片与文件另存到
// 收藏目录：从缓存来的用硬链接，本机的原文件先试写时复制（APFS clonefile、Linux reflink），
// 都不行再整份复制。只有元数据的大文件先在后台下载（不覆盖剪贴板），下完再另存。

import (
	"context"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/store"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// ErrCannotFavorite 表示这条记录的内容已经不在本机，收藏不了。
var ErrCannotFavorite = errors.New("内容已不在本机，不能收藏")

// saveWait 是收藏图片、文件时最多等另存完成多久再返回。硬链接与写时复制几乎瞬间完成，
// 返回时就是已收好的状态；整份复制大文件则先返回「正在保存」，完成后再推送更新。
const saveWait = 500 * time.Millisecond

// SetFavorite 收藏（favorite 为 true）或取消收藏 id 这一条。收藏时 id 是复制记录；
// 取消时 id 是收藏或它的原记录都可以。返回收藏后的那条收藏，或取消后放回复制记录的那一条。
func (e *Engine) SetFavorite(ctx context.Context, id string, favorite bool) (store.Clip, error) {
	e.favMu.Lock()
	defer e.favMu.Unlock()
	clip, err := e.store.GetClip(id)
	if err != nil {
		return store.Clip{}, err
	}
	if !favorite {
		return e.unfavorite(clip)
	}
	if clip.Favorite {
		if clip.Status == store.StatusReady {
			return e.touchFavorite(clip, clip.SourceClipID)
		}
		return e.retryFavorite(ctx, clip)
	}
	if existing, err := e.store.FavoriteOf(clip.ID); err == nil {
		return e.touchFavorite(existing, clip.ID)
	}

	switch clip.Kind {
	case store.KindText, store.KindHTML:
		// 同样的文字不重复收藏，只把已有的那条挪到最上面
		if existing, err := e.store.FavoriteWithText(clip.Kind, clip.TextContent); err == nil {
			return e.touchFavorite(existing, clip.ID)
		}
		fav := newFavorite(clip)
		fav.Status = store.StatusReady
		return e.putFavorite(fav)
	}

	switch clip.Status {
	case store.StatusReady:
		fav := newFavorite(clip)
		fav.Status = store.StatusFetching // 界面上显示「正在保存」
		if _, err := e.putFavorite(fav); err != nil {
			return store.Clip{}, err
		}
		return e.saveAndWait(fav, clip), nil
	case store.StatusRemoteOnly, store.StatusFetching:
		fav := newFavorite(clip)
		fav.Status = store.StatusFetching
		if _, err := e.putFavorite(fav); err != nil {
			return store.Clip{}, err
		}
		if clip.Status == store.StatusRemoteOnly {
			// 下载失败时 failReceive 会把这条收藏一起标成失败
			_ = e.FetchForPreview(ctx, clip.ID)
		}
		return e.store.GetClip(fav.ID)
	default:
		return store.Clip{}, ErrCannotFavorite
	}
}

// maxAlias 是别名最多多少个字：列表里一行放得下，再长也看不全
const maxAlias = 100

// SetAlias 给收藏 id 起个别名，alias 为空表示去掉。换行压成空格，首尾空白去掉，超长的截断。
func (e *Engine) SetAlias(id, alias string) (store.Clip, error) {
	e.favMu.Lock()
	defer e.favMu.Unlock()
	alias = strings.Join(strings.Fields(alias), " ")
	if r := []rune(alias); len(r) > maxAlias {
		alias = string(r[:maxAlias])
	}
	if err := e.store.SetAlias(id, alias); err != nil {
		if errors.Is(err, store.ErrNotFound) {
			return store.Clip{}, errors.New("只有收藏可以重命名")
		}
		return store.Clip{}, err
	}
	return e.emitStored(id, "")
}

// newFavorite 由复制记录 src 生成一条收藏：新的 ID，保留原来的复制时间与来源。
func newFavorite(src store.Clip) store.Clip {
	fav := src
	fav.ID = newID()
	fav.Favorite = true
	fav.FavoritedAt = time.Now()
	fav.SourceClipID = src.ID
	fav.Favorited = false
	fav.ExpiresAt = store.FavoriteExpiry
	fav.CachePath = ""
	fav.Error = ""
	return fav
}

func (e *Engine) putFavorite(fav store.Clip) (store.Clip, error) {
	if err := e.store.PutClip(fav); err != nil {
		return store.Clip{}, err
	}
	return e.emitStored(fav.ID, fav.SourceClipID)
}

// touchFavorite 把已有的收藏挪到收藏的最上面。
func (e *Engine) touchFavorite(fav store.Clip, sourceID string) (store.Clip, error) {
	if err := e.store.TouchFavorite(fav.ID, sourceID, time.Now()); err != nil {
		return store.Clip{}, err
	}
	return e.emitStored(fav.ID, sourceID)
}

// emitStored 重新读出 id 并推送给界面；原记录 sourceID 的星标随之变化，也推一次。
func (e *Engine) emitStored(id, sourceID string) (store.Clip, error) {
	if sourceID != "" {
		if src, err := e.store.GetClip(sourceID); err == nil {
			e.emitRecord(src)
		}
	}
	clip, err := e.store.GetClip(id)
	if err != nil {
		return store.Clip{}, err
	}
	e.emitRecord(clip)
	return clip, nil
}

// retryFavorite 重新另存一条失败了的收藏。
func (e *Engine) retryFavorite(ctx context.Context, fav store.Clip) (store.Clip, error) {
	if fav.Status == store.StatusFetching {
		return fav, nil
	}
	src, err := e.store.GetClip(fav.SourceClipID)
	if err != nil || src.Favorite {
		// 原记录已经没了：本机复制的文件还能从原来的位置再存一次
		if !fav.Outgoing || fav.Kind != store.KindFile {
			return store.Clip{}, errors.New("原记录已不在本机，无法重新保存")
		}
		src = fav
		src.Favorite, src.CachePath = false, ""
	}
	if err := e.store.SetClipStatus(fav.ID, store.StatusFetching, ""); err != nil {
		return store.Clip{}, err
	}
	fav.Status, fav.Error = store.StatusFetching, ""
	switch src.Status {
	case store.StatusReady:
		return e.saveAndWait(fav, src), nil
	case store.StatusRemoteOnly, store.StatusFailed:
		_ = e.FetchForPreview(ctx, src.ID)
	case store.StatusFetching:
	default:
		e.failFavorite(fav.ID, ErrCannotFavorite)
	}
	return e.emitStored(fav.ID, "")
}

// saveAndWait 在后台把 src 的内容另存给收藏 fav，最多等 saveWait。
func (e *Engine) saveAndWait(fav, src store.Clip) store.Clip {
	done := make(chan store.Clip, 1)
	go func() { done <- e.saveFavorite(fav, src) }()
	select {
	case c := <-done:
		return c
	case <-time.After(saveWait):
		if c, err := e.store.GetClip(fav.ID); err == nil {
			return c
		}
		return fav
	}
}

// saveFavorite 把复制记录 src 的图片或文件另存到收藏目录，完成后把收藏标成就绪并推送给界面。
func (e *Engine) saveFavorite(fav, src store.Clip) store.Clip {
	rel, err := e.copyToFavorites(fav.ID, src)
	if err != nil {
		e.log.Warn("另存收藏失败", "clip", fav.ID, "err", err)
		e.failFavorite(fav.ID, err)
	} else if err := e.store.SetClipCache(fav.ID, rel, fav.TotalSize); err != nil {
		_ = e.favorites.Remove(rel)
		e.failFavorite(fav.ID, err)
	}
	c, err := e.emitStored(fav.ID, src.ID)
	if err != nil {
		return fav
	}
	return c
}

func (e *Engine) failFavorite(id string, failure error) {
	_ = e.store.SetClipStatus(id, store.StatusFailed, failure.Error())
}

// copyToFavorites 把 src 的全部内容复制进收藏目录里属于 favID 的子目录，返回它的相对路径。
func (e *Engine) copyToFavorites(favID string, src store.Clip) (string, error) {
	if e.favorites == nil {
		return "", errors.New("收藏目录不可用")
	}
	paths, err := e.localPaths(src)
	if err != nil {
		return "", ErrCannotFavorite
	}
	rel, abs, err := e.favorites.Dir(favID)
	if err != nil {
		return "", err
	}
	for _, p := range paths {
		dst := uniquePath(filepath.Join(abs, filepath.Base(p)))
		// 缓存里的是隔空贴自己的文件，不会被用户改动，可以硬链接；
		// 本机的原文件用户随时可能改，要另存一份
		if err := copyEntry(p, dst, e.inCache(p)); err != nil {
			_ = e.favorites.Remove(rel)
			return "", fmt.Errorf("另存 %s: %w", filepath.Base(p), err)
		}
	}
	return rel, nil
}

func (e *Engine) inCache(p string) bool {
	root := filepath.Clean(e.cache.Root()) + string(filepath.Separator)
	return strings.HasPrefix(filepath.Clean(p), root)
}

// uniquePath 在 p 已经存在时（来自不同文件夹的同名文件）加上序号。
func uniquePath(p string) string {
	if _, err := os.Lstat(p); err != nil {
		return p
	}
	ext := filepath.Ext(p)
	base := strings.TrimSuffix(p, ext)
	for i := 2; ; i++ {
		c := fmt.Sprintf("%s (%d)%s", base, i, ext)
		if _, err := os.Lstat(c); err != nil {
			return c
		}
	}
}

// completePendingFavorites 在复制记录 src 下载完成后，另存等着它的收藏。
func (e *Engine) completePendingFavorites(src store.Clip) {
	pending, err := e.store.PendingFavorites(src.ID)
	if err != nil {
		return
	}
	for _, fav := range pending {
		if fav.Status == store.StatusFetching {
			go e.saveFavorite(fav, src)
		}
	}
}

// failPendingFavorites 在复制记录 sourceID 下载失败时，把等着它的收藏也标成失败。
func (e *Engine) failPendingFavorites(sourceID string, failure error) {
	pending, err := e.store.PendingFavorites(sourceID)
	if err != nil {
		return
	}
	for _, fav := range pending {
		e.failFavorite(fav.ID, failure)
		if c, err := e.store.GetClip(fav.ID); err == nil {
			e.emitRecord(c)
		}
	}
}

// unfavorite 取消收藏：把收藏放回复制记录的最上面，保留期从现在重新算。
// 原记录还在的话先删掉它，免得出现两条一样的。
func (e *Engine) unfavorite(clip store.Clip) (store.Clip, error) {
	fav := clip
	if !clip.Favorite {
		var err error
		if fav, err = e.store.FavoriteOf(clip.ID); err != nil {
			return clip, nil // 本来就没收藏
		}
	}
	src, srcErr := e.store.GetClip(fav.SourceClipID)
	hasSource := srcErr == nil && !src.Favorite

	if fav.Status != store.StatusReady && hasSource {
		// 还没另存好：原记录就是它，直接去掉这条收藏
		if fav.CachePath != "" && e.favorites != nil {
			_ = e.favorites.Remove(fav.CachePath)
		}
		if err := e.store.DeleteClips([]string{fav.ID}); err != nil {
			return store.Clip{}, err
		}
		e.emitRemoved(fav.ID)
		return e.emitStored(src.ID, "")
	}

	rel := ""
	if fav.CachePath != "" && e.favorites != nil && e.favorites.Exists(fav.CachePath) {
		var err error
		if rel, err = e.moveToCache(fav.CachePath); err != nil {
			return store.Clip{}, err
		}
	}
	if hasSource {
		if src.CachePath != "" {
			_ = e.cache.Remove(src.CachePath)
		}
		if err := e.store.DeleteClips([]string{src.ID}); err != nil {
			return store.Clip{}, err
		}
		e.emitRemoved(src.ID)
	}
	now := time.Now()
	if err := e.store.Unfavorite(fav.ID, now, now.Add(e.loadConfig().HistoryTTL.Std()), rel); err != nil {
		return store.Clip{}, err
	}
	return e.emitStored(fav.ID, "")
}

// moveToCache 把收藏目录里的 rel 挪进缓存目录（两者在同一块磁盘上，改名即可），返回它在缓存目录里的相对路径。
func (e *Engine) moveToCache(rel string) (string, error) {
	from := e.favorites.Abs(rel)
	to := e.cache.Abs(rel)
	if _, err := os.Lstat(to); err == nil {
		return "", fmt.Errorf("缓存目录里已有 %s", rel)
	}
	if err := os.Rename(from, to); err != nil {
		// 数据目录被挪到了别处、两个目录不在同一块磁盘上：复制一份再删掉
		if err := copyEntry(from, to, false); err != nil {
			_ = os.RemoveAll(to)
			return "", err
		}
		_ = e.favorites.Remove(rel)
	}
	return rel, nil
}

func (e *Engine) emitRemoved(id string) {
	if e.onRemoved != nil {
		e.onRemoved(id)
	}
}

// ClipDetail 返回悬停提示框要显示的完整内容。
func (e *Engine) ClipDetail(id string) (*pb.ClipDetail, error) {
	clip, err := e.store.GetClip(id)
	if err != nil {
		return nil, err
	}
	const maxRunes = 4000
	d := &pb.ClipDetail{}
	if clip.Kind == store.KindText || clip.Kind == store.KindHTML {
		r := []rune(plainText(clip))
		d.TextLength = int32(len(r))
		if len(r) > maxRunes {
			r = r[:maxRunes]
		}
		d.Text = string(r)
	}
	if clip.Kind == store.KindFile && clip.Outgoing {
		d.SourcePaths = clip.SourcePaths
	}
	if (clip.Kind == store.KindFile || clip.Kind == store.KindImage) && clip.Status == store.StatusReady {
		d.LocalPaths, _ = e.localPaths(clip)
	}
	return d, nil
}
