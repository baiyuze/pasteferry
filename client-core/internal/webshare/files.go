package webshare

import (
	"archive/zip"
	"context"
	"errors"
	"fmt"
	"io"
	"io/fs"
	"mime"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"time"
	"unicode"

	"github.com/baiyuze/pasteferry/client-core/internal/clipboard"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
)

const (
	// uploadIdle 内没有新数据的上传作废
	uploadIdle = 30 * time.Minute
	// maxUploadsPerSession 是一台手机同时进行的上传数
	maxUploadsPerSession = 64
	// zipKeep 是打包好的文件夹没人再下载时保留多久
	zipKeep = 15 * time.Minute
	// maxThumbs 是内存里缓存的缩略图数
	maxThumbs = 256
)

// ── 上传 ──

type upload struct {
	id       string
	session  string
	name     string
	size     int64
	chunks   int64
	received []bool
	got      int64
	path     string
	file     *os.File
	updated  time.Time
}

type uploads struct {
	dir  string
	mu   sync.Mutex
	byID map[string]*upload
}

func newUploads(dir string) *uploads { return &uploads{dir: dir, byID: make(map[string]*upload)} }

func (u *uploads) start(session, name string, size int64, now time.Time) (string, error) {
	u.mu.Lock()
	defer u.mu.Unlock()
	n := 0
	for _, up := range u.byID {
		if up.session == session {
			n++
		}
	}
	if n >= maxUploadsPerSession {
		return "", errCode("busy", "同时上传的文件太多")
	}
	if err := os.MkdirAll(u.dir, 0o700); err != nil {
		return "", err
	}
	id := randomID(12)
	path := filepath.Join(u.dir, id+".part")
	f, err := os.OpenFile(path, os.O_CREATE|os.O_EXCL|os.O_RDWR, 0o600)
	if err != nil {
		return "", err
	}
	chunks := (size + chunkSize - 1) / chunkSize
	u.byID[id] = &upload{
		id: id, session: session, name: safeFileName(name), size: size, chunks: chunks,
		received: make([]bool, chunks), path: path, file: f, updated: now,
	}
	return id, nil
}

// write 写入一块。块号决定位置，同一块收到两次只算一次；除最后一块外每块都必须是 chunkSize。
func (u *uploads) write(session, id string, index int64, data []byte, now time.Time) error {
	u.mu.Lock()
	up, ok := u.byID[id]
	u.mu.Unlock()
	if !ok || up.session != session {
		return errCode("upload_gone", "这次上传已经作废，请重新选择文件")
	}
	if index < 0 || index >= up.chunks {
		return errBadRequest
	}
	want := int64(chunkSize)
	if index == up.chunks-1 {
		want = up.size - index*chunkSize
	}
	if int64(len(data)) != want {
		return errBadRequest
	}
	if _, err := up.file.WriteAt(data, index*chunkSize); err != nil {
		return err
	}
	u.mu.Lock()
	if !up.received[index] {
		up.received[index] = true
		up.got++
	}
	up.updated = now
	u.mu.Unlock()
	return nil
}

// take 取出一次收齐了的上传，关掉文件，交给调用方处理。没收齐时原样留着，网页可以补传。
func (u *uploads) take(session, id string) (*upload, error) {
	u.mu.Lock()
	defer u.mu.Unlock()
	up, ok := u.byID[id]
	if !ok || up.session != session {
		return nil, errCode("upload_gone", "这次上传已经作废，请重新选择文件")
	}
	if up.got != up.chunks {
		return nil, errCode("incomplete", fmt.Sprintf("还差 %d 块没传完", up.chunks-up.got))
	}
	delete(u.byID, id)
	if err := up.file.Close(); err != nil {
		_ = os.Remove(up.path)
		return nil, err
	}
	return up, nil
}

func (u *uploads) cancel(session, id string) {
	u.mu.Lock()
	up, ok := u.byID[id]
	if ok && up.session == session {
		delete(u.byID, id)
	}
	u.mu.Unlock()
	if ok && up.session == session {
		up.discard()
	}
}

func (up *upload) discard() {
	_ = up.file.Close()
	_ = os.Remove(up.path)
}

func (u *uploads) dropSession(session string) {
	u.mu.Lock()
	var drop []*upload
	for id, up := range u.byID {
		if up.session == session {
			drop = append(drop, up)
			delete(u.byID, id)
		}
	}
	u.mu.Unlock()
	for _, up := range drop {
		up.discard()
	}
}

func (u *uploads) expire(now time.Time) {
	u.mu.Lock()
	var drop []*upload
	for id, up := range u.byID {
		if now.Sub(up.updated) > uploadIdle {
			drop = append(drop, up)
			delete(u.byID, id)
		}
	}
	u.mu.Unlock()
	for _, up := range drop {
		up.discard()
	}
}

func (u *uploads) clear() {
	u.mu.Lock()
	all := u.byID
	u.byID = make(map[string]*upload)
	u.mu.Unlock()
	for _, up := range all {
		up.discard()
	}
	_ = os.RemoveAll(u.dir)
}

// finishUploads 把收齐的文件挪进隔空传送的保存位置，作为一条文件记录提交：
// 进复制记录、按设置写进本机剪贴板、发给其他已配对的设备。
func (s *Server) finishUploads(ctx context.Context, sess *session, ids []string) (any, error) {
	if len(ids) == 0 || len(ids) > maxUploadsPerSession {
		return nil, errBadRequest
	}
	var done []*upload
	for _, id := range ids {
		up, err := s.uploads.take(sess.id, id)
		if err != nil {
			for _, d := range done {
				d.discard()
			}
			return nil, err
		}
		done = append(done, up)
	}
	dir := s.opts.LoadConfig().EffectiveReceiveDir()
	if err := os.MkdirAll(dir, 0o755); err != nil {
		for _, d := range done {
			d.discard()
		}
		return nil, fmt.Errorf("没法创建保存位置 %s: %w", dir, err)
	}
	var paths []string
	for i, up := range done {
		dst, err := moveInto(up.path, dir, up.name)
		if err != nil {
			for _, d := range done[i:] {
				d.discard()
			}
			return nil, err
		}
		paths = append(paths, dst)
	}
	name := s.sessionName(sess)
	clip, err := s.opts.Engine.SubmitLocal(ctx, clipboard.Content{Kind: clipboard.KindFile, Files: paths}, name, true)
	if err != nil {
		return nil, err
	}
	s.log.Info("网页传输收到文件", "from", name, "count", len(paths), "dir", dir)
	return s.toWeb(clip, name), nil
}

// moveInto 把 src 挪进 dir，重名时按隔空传送的规则改成「名字 (n).扩展名」。跨磁盘时复制再删。
func moveInto(src, dir, name string) (string, error) {
	ext := filepath.Ext(name)
	stem := strings.TrimSuffix(name, ext)
	for n := 0; n < 1000; n++ {
		candidate := filepath.Join(dir, name)
		if n > 0 {
			candidate = filepath.Join(dir, fmt.Sprintf("%s (%d)%s", stem, n, ext))
		}
		if _, err := os.Lstat(candidate); err == nil {
			continue
		}
		if err := os.Link(src, candidate); err == nil {
			_ = os.Remove(src)
			// 临时文件是 0600；放进「下载」后与隔空传送收到的文件一样，别的程序也能打开
			_ = os.Chmod(candidate, 0o644)
			return candidate, nil
		} else if errors.Is(err, fs.ErrExist) {
			continue
		}
		// 不支持硬链接或跨磁盘：独占创建目标后复制，仍然不会覆盖别人的文件
		if err := copyNew(src, candidate); err != nil {
			if errors.Is(err, fs.ErrExist) {
				continue
			}
			return "", err
		}
		_ = os.Remove(src)
		return candidate, nil
	}
	return "", errors.New("同名文件太多")
}

func copyNew(src, dst string) error {
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()
	out, err := os.OpenFile(dst, os.O_CREATE|os.O_EXCL|os.O_WRONLY, 0o644)
	if err != nil {
		return err
	}
	if _, err := io.Copy(out, in); err != nil {
		out.Close()
		_ = os.Remove(dst)
		return err
	}
	return out.Close()
}

// safeFileName 只留文件名本身：去掉路径、控制字符和 Windows 不允许的字符，空的叫 file。
func safeFileName(name string) string {
	name = strings.ReplaceAll(name, `\`, "/")
	name = name[strings.LastIndex(name, "/")+1:]
	var b strings.Builder
	for _, r := range name {
		if unicode.IsControl(r) || strings.ContainsRune(`<>:"|?*`, r) {
			b.WriteRune('_')
			continue
		}
		b.WriteRune(r)
	}
	name = strings.Trim(strings.TrimSpace(b.String()), ".")
	if name == "" {
		return "file"
	}
	if len(name) > 200 {
		ext := filepath.Ext(name)
		if len(ext) > 20 {
			ext = ""
		}
		name = string([]rune(name[:200-len(ext)])) + ext
	}
	return name
}

// ── 下载 ──

type downloadFile struct {
	path string
	name string
	size int64
	zip  bool
	mime string
}

// downloadable 找到一条记录里第 item 项在本机的文件；文件夹先打包成 zip。
func (s *Server) downloadable(clipID string, item int) (downloadFile, error) {
	c, err := s.opts.Store.GetClip(clipID)
	if err != nil || c.Favorite {
		return downloadFile{}, errGone
	}
	if c.Kind != store.KindImage && c.Kind != store.KindFile {
		return downloadFile{}, errBadRequest
	}
	if c.Status != store.StatusReady {
		return downloadFile{}, errNotReady
	}
	paths, err := s.opts.Engine.LocalPaths(clipID)
	if err != nil || len(paths) == 0 {
		return downloadFile{}, errGone
	}
	var path, name string
	switch {
	case c.Kind == store.KindImage:
		path, name = paths[0], "image.png"
	case item >= 0 && item < len(c.Items):
		name = c.Items[item].Name
		for _, p := range paths {
			if filepath.Base(p) == name {
				path = p
				break
			}
		}
	}
	if path == "" {
		return downloadFile{}, errGone
	}
	info, err := os.Stat(path)
	if err != nil {
		return downloadFile{}, errGone
	}
	if info.IsDir() {
		zp, size, err := s.zips.get(clipID, item, path)
		if err != nil {
			return downloadFile{}, err
		}
		if size > maxDownloadBytes {
			return downloadFile{}, errTooLarge
		}
		return downloadFile{path: zp, name: name + ".zip", size: size, zip: true, mime: "application/zip"}, nil
	}
	if !info.Mode().IsRegular() {
		return downloadFile{}, errGone
	}
	if info.Size() > maxDownloadBytes {
		return downloadFile{}, errTooLarge
	}
	mt := mime.TypeByExtension(strings.ToLower(filepath.Ext(name)))
	if mt == "" {
		mt = "application/octet-stream"
	}
	return downloadFile{path: path, name: name, size: info.Size(), mime: mt}, nil
}

func (s *Server) readChunk(clipID string, item int, index int64) ([]byte, error) {
	f, err := s.downloadable(clipID, item)
	if err != nil {
		return nil, err
	}
	return readFileChunk(f, index)
}

func readFileChunk(f downloadFile, index int64) ([]byte, error) {
	if index < 0 || index > f.size/chunkSize || index*chunkSize >= f.size && !(index == 0 && f.size == 0) {
		return nil, errBadRequest
	}
	file, err := os.Open(f.path)
	if err != nil {
		return nil, errGone
	}
	defer file.Close()
	buf := make([]byte, chunkSize)
	n, err := file.ReadAt(buf, index*chunkSize)
	if err != nil && !errors.Is(err, io.EOF) {
		return nil, err
	}
	return buf[:n], nil
}

// zipCache 把要下载的文件夹打包成 zip 放在工作目录里，同一个文件夹分块下载时只打包一次。
type zipCache struct {
	dir   string
	mu    sync.Mutex
	byKey map[string]*zipEntry
}

type zipEntry struct {
	path string
	size int64
	used time.Time
	mu   sync.Mutex // 同一个文件夹同时只打包一次
}

func newZipCache(dir string) *zipCache { return &zipCache{dir: dir, byKey: make(map[string]*zipEntry)} }

func (z *zipCache) get(clipID string, item int, root string) (string, int64, error) {
	k := fmt.Sprintf("%s-%d", clipID, item)
	z.mu.Lock()
	e, ok := z.byKey[k]
	if !ok {
		e = &zipEntry{}
		z.byKey[k] = e
	}
	z.mu.Unlock()

	e.mu.Lock()
	defer e.mu.Unlock()
	e.used = time.Now()
	if e.path != "" {
		return e.path, e.size, nil
	}
	if err := os.MkdirAll(z.dir, 0o700); err != nil {
		return "", 0, err
	}
	path := filepath.Join(z.dir, k+".zip")
	size, err := writeZip(path, root)
	if err != nil {
		_ = os.Remove(path)
		z.mu.Lock()
		delete(z.byKey, k)
		z.mu.Unlock()
		return "", 0, err
	}
	e.path, e.size = path, size
	return path, size, nil
}

// writeZip 把 root 打包进 path，压缩包里的路径以 root 的名字开头。不跟随符号链接，
// 打包到一半总大小超过下载上限就停下。
func writeZip(path, root string) (int64, error) {
	out, err := os.OpenFile(path, os.O_CREATE|os.O_TRUNC|os.O_WRONLY, 0o600)
	if err != nil {
		return 0, err
	}
	zw := zip.NewWriter(out)
	base := filepath.Base(root)
	var total int64
	walkErr := filepath.WalkDir(root, func(p string, d fs.DirEntry, err error) error {
		if err != nil {
			return nil // 读不了的子目录跳过
		}
		if d.Type()&fs.ModeSymlink != 0 {
			return nil
		}
		rel, err := filepath.Rel(root, p)
		if err != nil {
			return nil
		}
		name := filepath.ToSlash(filepath.Join(base, rel))
		if d.IsDir() {
			if rel == "." {
				return nil
			}
			_, err := zw.Create(name + "/")
			return err
		}
		if !d.Type().IsRegular() {
			return nil
		}
		info, err := d.Info()
		if err != nil {
			return nil
		}
		if total += info.Size(); total > maxDownloadBytes {
			return errTooLarge
		}
		hdr, err := zip.FileInfoHeader(info)
		if err != nil {
			return err
		}
		hdr.Name, hdr.Method = name, zip.Deflate
		w, err := zw.CreateHeader(hdr)
		if err != nil {
			return err
		}
		f, err := os.Open(p)
		if err != nil {
			return nil
		}
		_, err = io.Copy(w, f)
		f.Close()
		return err
	})
	if err := zw.Close(); err != nil && walkErr == nil {
		walkErr = err
	}
	if err := out.Close(); err != nil && walkErr == nil {
		walkErr = err
	}
	if walkErr != nil {
		return 0, walkErr
	}
	info, err := os.Stat(path)
	if err != nil {
		return 0, err
	}
	return info.Size(), nil
}

func (z *zipCache) expire(now time.Time) {
	z.mu.Lock()
	defer z.mu.Unlock()
	for k, e := range z.byKey {
		if e.mu.TryLock() {
			if e.path != "" && now.Sub(e.used) > zipKeep {
				_ = os.Remove(e.path)
				delete(z.byKey, k)
			}
			e.mu.Unlock()
		}
	}
}

func (z *zipCache) clear() {
	z.mu.Lock()
	z.byKey = make(map[string]*zipEntry)
	z.mu.Unlock()
	_ = os.RemoveAll(z.dir)
}

// ── 缩略图 ──

// thumbCache 缓存缩略图：记录滚动回来时不必再缩一遍。超过 maxThumbs 张就整个清掉重来。
type thumbCache struct {
	mu   sync.Mutex
	byID map[string][]byte
}

func (s *Server) thumbnail(ctx context.Context, clipID string) ([]byte, error) {
	s.thumbs.mu.Lock()
	if data, ok := s.thumbs.byID[clipID]; ok {
		s.thumbs.mu.Unlock()
		return data, nil
	}
	s.thumbs.mu.Unlock()
	if s.opts.Thumbnail == nil {
		return nil, errNotReady
	}
	path, _, _, err := s.opts.Engine.ImagePreview(ctx, clipID, 0)
	if err != nil {
		return nil, errNotReady
	}
	thumb := s.opts.Thumbnail(path)
	if thumb == "" {
		return nil, errNotReady
	}
	data, err := os.ReadFile(thumb)
	_ = os.Remove(thumb)
	if err != nil {
		return nil, err
	}
	s.thumbs.mu.Lock()
	if s.thumbs.byID == nil || len(s.thumbs.byID) >= maxThumbs {
		s.thumbs.byID = make(map[string][]byte)
	}
	s.thumbs.byID[clipID] = data
	s.thumbs.mu.Unlock()
	return data, nil
}
