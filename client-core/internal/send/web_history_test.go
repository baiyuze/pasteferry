package send

import (
	"path/filepath"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/store"
)

func TestNativeRecoveryLeavesBrowserQueuesToWebShare(t *testing.T) {
	db, err := store.Open(filepath.Join(t.TempDir(), "db"))
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()
	now := time.Now()
	pending := store.Transfer{ID: "web:session:batch", DeviceID: "web:session", Direction: store.Outgoing, Status: store.TransferWaiting, CreatedAt: now.Add(-recordTTL - time.Hour), UpdatedAt: now.Add(-recordTTL - time.Hour)}
	if err := db.PutTransfer(pending); err != nil {
		t.Fatal(err)
	}
	e := New(Options{Store: db, Now: func() time.Time { return now }})
	defer e.Close()
	e.recover()
	e.janitor()
	got, err := db.GetTransfer(pending.ID)
	if err != nil || got.Status != store.TransferWaiting {
		t.Fatalf("native recovery changed browser queue: %+v %v", got, err)
	}
	if err := e.Resume(pending.ID); err != ErrNotResumable {
		t.Fatalf("native resume accepted browser queue: %v", err)
	}
}
