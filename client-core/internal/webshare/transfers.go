package webshare

import (
	"context"
	"fmt"
	"io"
	"mime"
	"os"
	"path/filepath"
	"strings"

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
	t := store.WebTransfer{ID: id, Session: sessionID, Direction: "download", Status: "ready", CreatedAt: s.opts.Now().UnixMilli()}
	var total int64
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
		total += n
	}
	if err := s.opts.Store.PutWebTransfer(t); err != nil {
		return nil, err
	}
	ok = true
	return &pb.Transfer{Id: id, DeviceId: "web:" + sessionID, DeviceName: s.sessionName(sess), Status: "waiting", Direction: pb.TransferDirection_TRANSFER_DIRECTION_OUTGOING, TotalBytes: total, FileCount: int64(len(paths))}, nil
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
	if err := s.opts.Store.PutWebTransfer(t); err != nil {
		return nil, err
	}
	ok = true
	return transferWeb(t), nil
}

func (s *Server) transferFile(sess *session, id string, item int) (downloadFile, error) {
	t, err := s.opts.Store.WebTransfer(sess.id, id)
	if err != nil || t.Direction != "download" || item < 0 || item >= len(t.Paths) {
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
		if t.Direction != "download" || item < 0 || item >= len(t.Downloaded) {
			return nil, errBadRequest
		}
		t.Downloaded[item] = true
		t.Status = "done"
		for _, done := range t.Downloaded {
			if !done {
				t.Status = "ready"
			}
		}
		err = s.opts.Store.PutWebTransfer(t)
		return transferWeb(t), err
	case "transfer_delete":
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
