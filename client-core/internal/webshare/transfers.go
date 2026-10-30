package webshare

import (
	"context"
	"fmt"
	"io"
	"mime"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/send"

	"github.com/baiyuze/pasteferry/client-core/internal/store"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

type webTransfer struct {
	ID         string    `json:"id"`
	Direction  string    `json:"direction"`
	Status     string    `json:"status"`
	Items      []webItem `json:"items"`
	Downloaded []bool    `json:"downloaded"`
	At         int64     `json:"at"`
}

func transferWeb(t store.WebTransfer) webTransfer {
	w := webTransfer{ID: t.ID, Direction: t.Direction, Status: t.Status, At: t.CreatedAt, Downloaded: t.Downloaded, Items: []webItem{}}
	for _, i := range t.Items {
		w.Items = append(w.Items, webItem{Name: i.Name, Size: i.Size})
	}
	return w
}

// QueueFiles snapshots files explicitly selected on the host for this browser.
// A browser never supplies a local path and cannot see another session's queue.
func (s *Server) QueueFiles(ctx context.Context, sessionID string, paths []string) (*pb.Transfer, error) {
	s.transferMu.Lock()
	defer s.transferMu.Unlock()
	sess, err := s.sessionByID(sessionID)
	if err != nil {
		return nil, err
	}
	if len(paths) == 0 || len(paths) > maxUploadsPerSession {
		return nil, errBadRequest
	}
	old, err := s.opts.Store.WebTransfers(sessionID)
	if err != nil {
		return nil, err
	}
	if len(old) >= 100 {
		return nil, errCode("busy", "请先清理网页传输记录")
	}
	id := randomID(16)
	dir := s.transferDir(sessionID, id)
	if err := os.MkdirAll(dir, 0700); err != nil {
		return nil, err
	}
	ok := false
	defer func() {
		if !ok {
			_ = os.RemoveAll(dir)
		}
	}()
	t := store.WebTransfer{ID: id, Session: sessionID, Direction: "download", Status: "ready", CreatedAt: s.opts.Now().UnixMilli(), SourcePaths: append([]string(nil), paths...)}
	for index, path := range paths {
		if err := ctx.Err(); err != nil {
			return nil, err
		}
		f, err := os.Open(path)
		if err != nil {
			return nil, err
		}
		info, err := f.Stat()
		if err != nil {
			f.Close()
			return nil, err
		}
		if !info.Mode().IsRegular() || info.Size() > maxDownloadBytes {
			f.Close()
			return nil, errTooLarge
		}
		// Each selected file has its own directory so equal display names survive.
		parent := filepath.Join(dir, fmt.Sprint(index))
		if err := os.Mkdir(parent, 0700); err != nil {
			f.Close()
			return nil, err
		}
		dst := filepath.Join(parent, info.Name())
		out, err := os.OpenFile(dst, os.O_CREATE|os.O_EXCL|os.O_WRONLY, 0600)
		if err != nil {
			f.Close()
			return nil, err
		}
		n, copyErr := io.Copy(out, io.LimitReader(f, maxDownloadBytes+1))
		closeErr := out.Close()
		f.Close()
		if copyErr != nil {
			return nil, copyErr
		}
		if closeErr != nil {
			return nil, closeErr
		}
		if n != info.Size() {
			return nil, errCode("source_changed", "文件已变化，请重新选择")
		}
		t.Items = append(t.Items, store.Item{Name: info.Name(), Size: n})
		t.Paths = append(t.Paths, dst)
		t.Downloaded = append(t.Downloaded, false)
	}
	record, err := s.saveTransfer(t, s.sessionName(sess))
	if err != nil {
		return nil, err
	}
	ok = true
	return send.TransferProto(*record), nil
}

func (s *Server) transferDir(session, id string) string {
	return filepath.Join(s.opts.WorkDir, "transfers", session, id)
}

func (s *Server) finishTransferUploads(sess *session, ids []string, batch string) (any, error) {
	s.transferMu.Lock()
	defer s.transferMu.Unlock()
	if len(batch) < 16 || len(batch) > 64 || strings.Trim(batch, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_") != "" {
		return nil, errBadRequest
	}
	if old, err := s.opts.Store.WebTransfer(sess.id, batch); err == nil {
		if old.Direction != "upload" {
			return nil, errBadRequest
		}
		return transferWeb(old), nil
	}
	if len(ids) == 0 || len(ids) > maxUploadsPerSession {
		return nil, errBadRequest
	}
	old, err := s.opts.Store.WebTransfers(sess.id)
	if err != nil {
		return nil, err
	}
	if len(old) >= 100 {
		return nil, errCode("busy", "请先清理网页传输记录")
	}
	var uploads []*upload
	defer func() {
		for _, u := range uploads {
			u.discard()
		}
	}()
	for _, id := range ids {
		u, err := s.uploads.take(sess.id, id)
		if err != nil {
			return nil, err
		}
		uploads = append(uploads, u)
	}
	dir := s.opts.LoadConfig().EffectiveReceiveDir()
	if err := os.MkdirAll(dir, 0755); err != nil {
		return nil, err
	}
	t := store.WebTransfer{ID: batch, Session: sess.id, Direction: "upload", Status: "done", CreatedAt: s.opts.Now().UnixMilli()}
	ok := false
	defer func() {
		if !ok {
			for _, p := range t.Paths {
				_ = os.Remove(p)
			}
		}
	}()
	for _, u := range uploads {
		p, err := moveInto(u.path, dir, u.name)
		if err != nil {
			return nil, err
		}
		t.Paths = append(t.Paths, p)
		t.Items = append(t.Items, store.Item{Name: filepath.Base(p), Size: u.size})
	}
	if _, err := s.saveTransfer(t, s.sessionName(sess)); err != nil {
		return nil, err
	}
	ok = true
	return transferWeb(t), nil
}

func (s *Server) transferFile(sess *session, id string, item int) (downloadFile, error) {
	t, err := s.opts.Store.WebTransfer(sess.id, id)
	if err != nil || (t.Status != "ready" && t.Status != "done") || t.Direction != "download" || item < 0 || item >= len(t.Paths) {
		return downloadFile{}, errGone
	}
	f := downloadFile{path: t.Paths[item], name: t.Items[item].Name, size: t.Items[item].Size, mime: mime.TypeByExtension(filepath.Ext(t.Items[item].Name))}
	info, err := os.Stat(f.path)
	if err != nil || !info.Mode().IsRegular() || info.Size() != f.size {
		return downloadFile{}, errGone
	}
	return f, nil
}

func (s *Server) transferRPC(sess *session, method, id string, item int) (any, error) {
	s.transferMu.Lock()
	defer s.transferMu.Unlock()
	if method == "transfers" {
		list, err := s.opts.Store.WebTransfers(sess.id)
		out := []webTransfer{}
		for _, t := range list {
			out = append(out, transferWeb(t))
		}
		return map[string]any{"transfers": out}, err
	}
	t, err := s.opts.Store.WebTransfer(sess.id, id)
	if err != nil {
		return nil, errGone
	}
	switch method {
	case "transfer_file_info":
		f, err := s.transferFile(sess, id, item)
		if err != nil {
			return nil, err
		}
		return map[string]any{"name": f.name, "size": f.size, "chunks": (f.size + chunkSize - 1) / chunkSize, "mime": f.mime}, nil
	case "transfer_downloaded":
		if (t.Status != "ready" && t.Status != "done") || t.Direction != "download" || item < 0 || item >= len(t.Downloaded) {
			return nil, errBadRequest
		}
		t.Downloaded[item] = true
		t.Status = "done"
		for _, done := range t.Downloaded {
			if !done {
				t.Status = "ready"
			}
		}
		_, err = s.saveTransfer(t, s.sessionName(sess))
		return transferWeb(t), err
	case "transfer_delete":
		if t.Status == "ready" {
			t.Status = "cancelled"
			if _, err := s.saveTransfer(t, s.sessionName(sess)); err != nil {
				return nil, err
			}
		}
		if err := s.opts.Store.DeleteWebTransfer(sess.id, id); err != nil {
			return nil, err
		}
		if t.Direction == "download" {
			_ = os.RemoveAll(s.transferDir(sess.id, id))
		}
		return map[string]bool{}, nil
	}
	return nil, errBadRequest
}

// saveTransfer uses a session-qualified ID: browser-generated IDs are not global.
func (s *Server) saveTransfer(w store.WebTransfer, name string) (*store.Transfer, error) {
	created := time.UnixMilli(w.CreatedAt)
	t := store.Transfer{ID: "web:" + w.Session + ":" + w.ID, DeviceID: "web:" + w.Session,
		DeviceName: name, Items: w.Items, Paths: w.Paths, FileCount: int64(len(w.Items)),
		CreatedAt: created, UpdatedAt: s.opts.Now(), PeerRole: store.RoleSelf,
		Direction: store.Outgoing, Status: store.TransferWaiting}
	if len(w.SourcePaths) != 0 {
		t.Paths = w.SourcePaths
	}
	if w.Direction == "upload" {
		t.Direction = store.Incoming
		if len(w.Paths) > 0 {
			t.DestDir = filepath.Dir(w.Paths[0])
		}
	}
	for i, item := range w.Items {
		t.TotalBytes += item.Size
		if w.Direction == "upload" || (i < len(w.Downloaded) && w.Downloaded[i]) {
			t.DoneBytes += item.Size
		}
	}
	if w.Status == "done" {
		t.Status = store.TransferDone
	}
	if w.Status == "cancelled" {
		t.Status = store.TransferCancelled
	}
	if store.TransferFinished(t.Status) {
		t.FinishedAt = s.opts.Now()
	}
	saved, err := s.opts.Store.PutWebTransferHistory(w, t)
	if err == nil && saved != nil && s.opts.OnTransferChanged != nil {
		s.opts.OnTransferChanged(send.TransferProto(*saved))
	}
	return saved, err
}

// restoreTransferHistory imports 2.8.1 records once, without retransferring files.
func (s *Server) restoreTransferHistory() {
	sessions, err := s.opts.Store.WebSessions()
	if err != nil {
		s.log.Warn("读取网页传输历史失败", "err", err)
		return
	}
	for _, registered := range sessions {
		list, err := s.opts.Store.WebTransfers(registered.ID)
		if err != nil {
			s.log.Warn("读取网页传输历史失败", "err", err)
			continue
		}
		for _, w := range list {
			if w.DesktopID != "" {
				continue
			}
			if _, err := s.saveTransfer(w, s.sessionName(&session{name: registered.Name})); err != nil {
				s.log.Warn("恢复网页传输记录失败", "err", err)
			}
		}
	}
	// A crash between session removal and queue cancellation must not leave a
	// permanently waiting desktop row.
	pending, err := s.opts.Store.PendingWebTransfers()
	if err != nil {
		s.log.Warn("读取网页待传记录失败", "err", err)
		return
	}
	for _, t := range pending {
		if _, err := s.opts.Store.WebSession(strings.TrimPrefix(t.DeviceID, "web:")); store.IsNotFound(err) {
			s.cancelHistory(t)
		}
	}
}

func (s *Server) cancelHistory(t store.Transfer) {
	t.Status, t.UpdatedAt, t.FinishedAt = store.TransferCancelled, s.opts.Now(), s.opts.Now()
	if err := s.opts.Store.PutTransfer(t); err != nil {
		s.log.Warn("取消网页传输记录失败", "err", err)
		return
	}
	if s.opts.OnTransferChanged != nil {
		s.opts.OnTransferChanged(send.TransferProto(t))
	}
}

func (s *Server) cancelSessionTransfers(id string) {
	list, err := s.opts.Store.PendingWebTransfers()
	if err != nil {
		s.log.Warn("读取网页待传记录失败", "err", err)
		return
	}
	for _, t := range list {
		if t.DeviceID == "web:"+id {
			s.cancelHistory(t)
		}
	}
}

// CancelTransfer cancels a host queue and removes only its private snapshot.
func (s *Server) CancelTransfer(id string) error {
	s.transferMu.Lock()
	defer s.transferMu.Unlock()
	t, err := s.opts.Store.GetTransfer(id)
	if err != nil {
		return send.ErrNotFound
	}
	if store.TransferFinished(t.Status) {
		return nil
	}
	parts := strings.Split(id, ":")
	if len(parts) != 3 || parts[0] != "web" {
		return send.ErrNotFound
	}
	w, err := s.opts.Store.WebTransfer(parts[1], parts[2])
	if err != nil {
		return send.ErrNotFound
	}
	w.Status = "cancelled"
	if _, err := s.saveTransfer(w, t.DeviceName); err != nil {
		return err
	}
	_ = os.RemoveAll(s.transferDir(w.Session, w.ID))
	return nil
}
