package store

import (
	"database/sql"
	"encoding/json"
	"errors"
	"time"
)

// WebTransfer belongs to one browser session and never enters clipboard history.
// Paths stay on the host; only the webshare DTO is sent to the browser.
type WebTransfer struct {
	ID         string
	Session    string
	Direction  string // upload / download, from the browser's perspective
	Status     string
	Items      []Item
	Paths      []string
	Downloaded []bool
	// DesktopID is persisted even when desktop history is deleted, so retries
	// and upgrades never resurrect a record the user removed.
	DesktopID   string
	SourcePaths []string // original host paths, separate from download snapshots
	CreatedAt   int64
}

func (s *Store) PutWebTransfer(t WebTransfer) error {
	b, err := json.Marshal(t)
	if err != nil {
		return err
	}
	_, err = s.db.Exec(`INSERT INTO web_transfers(id,session,created_at,payload) VALUES(?,?,?,?)
ON CONFLICT(session,id) DO UPDATE SET payload=excluded.payload`, t.ID, t.Session, t.CreatedAt, b)
	return err
}

func (s *Store) WebTransfers(session string) ([]WebTransfer, error) {
	rows, err := s.db.Query(`SELECT payload FROM web_transfers WHERE session=? ORDER BY created_at DESC,id DESC LIMIT 100`, session)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := []WebTransfer{}
	for rows.Next() {
		var b []byte
		if err := rows.Scan(&b); err != nil {
			return nil, err
		}
		var t WebTransfer
		if err := json.Unmarshal(b, &t); err != nil {
			return nil, err
		}
		out = append(out, t)
	}
	return out, rows.Err()
}

func (s *Store) WebTransfer(session, id string) (WebTransfer, error) {
	var b []byte
	err := s.db.QueryRow(`SELECT payload FROM web_transfers WHERE session=? AND id=?`, session, id).Scan(&b)
	if errors.Is(err, sql.ErrNoRows) {
		return WebTransfer{}, ErrNotFound
	}
	if err != nil {
		return WebTransfer{}, err
	}
	var t WebTransfer
	err = json.Unmarshal(b, &t)
	return t, err
}

func (s *Store) DeleteWebTransfer(session, id string) error {
	_, err := s.db.Exec(`DELETE FROM web_transfers WHERE session=? AND id=?`, session, id)
	return err
}

// PutWebTransferHistory atomically saves browser state and its desktop history.
// A linked but deleted desktop row stays deleted. Seen is owned by the desktop.
func (s *Store) PutWebTransferHistory(w WebTransfer, t Transfer) (*Transfer, error) {
	tx, err := s.db.Begin()
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()
	first := w.DesktopID == ""
	w.DesktopID = t.ID
	var seen bool
	var finished int64
	err = tx.QueryRow(`SELECT seen, finished_at FROM transfers WHERE id=?`, t.ID).Scan(&seen, &finished)
	write := err == nil || (first && errors.Is(err, sql.ErrNoRows))
	if err != nil && !errors.Is(err, sql.ErrNoRows) {
		return nil, err
	}
	if write {
		t.Seen = seen
		if finished > 0 {
			t.FinishedAt = time.Unix(finished, 0)
		}
		if err := putTransfer(tx, t); err != nil {
			return nil, err
		}
	}
	b, err := json.Marshal(w)
	if err != nil {
		return nil, err
	}
	if _, err := tx.Exec(`INSERT INTO web_transfers(id,session,created_at,payload) VALUES(?,?,?,?)
ON CONFLICT(session,id) DO UPDATE SET payload=excluded.payload`, w.ID, w.Session, w.CreatedAt, b); err != nil {
		return nil, err
	}
	if err := tx.Commit(); err != nil {
		return nil, err
	}
	if !write {
		return nil, nil
	}
	return &t, nil
}

// PendingWebTransfers includes orphaned queues whose browser session was revoked.
func (s *Store) PendingWebTransfers() ([]Transfer, error) {
	return s.queryTransfers(`SELECT ` + transferColumns + ` FROM transfers
WHERE device_id LIKE 'web:%' AND status NOT IN ('done','failed','cancelled','declined','expired')`)
}
