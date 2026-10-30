package store

import (
	"path/filepath"
	"testing"
	"time"
)

func TestWebAndDesktopHistoryCommitTogether(t *testing.T) {
	s, err := Open(filepath.Join(t.TempDir(), "db"))
	if err != nil {
		t.Fatal(err)
	}
	defer s.Close()
	w := WebTransfer{ID: "batch", Session: "missing", Direction: "upload", Status: "done", CreatedAt: time.Now().UnixMilli()}
	tr := Transfer{ID: "web:missing:batch", DeviceID: "web:missing", Direction: Incoming, Status: TransferDone, CreatedAt: time.Now()}
	if _, err := s.PutWebTransferHistory(w, tr); err == nil {
		t.Fatal("missing session accepted")
	}
	if _, err := s.GetTransfer(tr.ID); !IsNotFound(err) {
		t.Fatalf("failed browser save left desktop history: %v", err)
	}
	if err := s.PutWebSession(WebSession{ID: "missing", Key: []byte("key"), CreatedAt: time.Now(), LastSeen: time.Now()}); err != nil {
		t.Fatal(err)
	}
	if _, err := s.PutWebTransferHistory(w, tr); err != nil {
		t.Fatal(err)
	}
	saved, err := s.WebTransfer(w.Session, w.ID)
	if err != nil || saved.DesktopID != tr.ID {
		t.Fatalf("link not persisted: %+v %v", saved, err)
	}
}
