package store

import (
	"database/sql"
	"errors"
	"fmt"
	"time"
)

// WebSession 是手机网页传输里登记过的一台手机（design/phone-sync.md 2.3 节）。
// Key 是这台手机与本机之间的 secretbox 密钥，落盘前由调用方加密（Windows 上用 DPAPI），
// 这里只原样存取。
type WebSession struct {
	ID        string
	Name      string
	Key       []byte
	CreatedAt time.Time
	LastSeen  time.Time
}

const webSessionsSchema = `
CREATE TABLE IF NOT EXISTS web_sessions (
    id         TEXT PRIMARY KEY,
    name       TEXT NOT NULL DEFAULT '',
    key        BLOB NOT NULL,
    created_at INTEGER NOT NULL,
    last_seen  INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS web_transfers (
    id TEXT NOT NULL,
    session TEXT NOT NULL REFERENCES web_sessions(id) ON DELETE CASCADE,
    created_at INTEGER NOT NULL,
    payload BLOB NOT NULL,
    PRIMARY KEY(session,id)
);
CREATE INDEX IF NOT EXISTS idx_web_transfers_session ON web_transfers(session,created_at DESC);`

func (s *Store) migrateWebSessions() error {
	if _, err := s.db.Exec(webSessionsSchema); err != nil {
		return fmt.Errorf("建网页传输会话表: %w", err)
	}
	return nil
}

// PutWebSession 新增或更新一台手机。
func (s *Store) PutWebSession(w WebSession) error {
	_, err := s.db.Exec(`
INSERT INTO web_sessions (id, name, key, created_at, last_seen) VALUES (?,?,?,?,?)
ON CONFLICT(id) DO UPDATE SET name=excluded.name, key=excluded.key, last_seen=excluded.last_seen`,
		w.ID, w.Name, w.Key, w.CreatedAt.Unix(), w.LastSeen.Unix())
	return err
}

// WebSession 读出一台手机；不存在时返回 ErrNotFound。
func (s *Store) WebSession(id string) (WebSession, error) {
	var w WebSession
	var created, seen int64
	err := s.db.QueryRow(`SELECT id, name, key, created_at, last_seen FROM web_sessions WHERE id=?`, id).
		Scan(&w.ID, &w.Name, &w.Key, &created, &seen)
	if errors.Is(err, sql.ErrNoRows) {
		return WebSession{}, ErrNotFound
	}
	if err != nil {
		return WebSession{}, err
	}
	w.CreatedAt, w.LastSeen = time.Unix(created, 0), time.Unix(seen, 0)
	return w, nil
}

// WebSessions 按最后使用时间倒序列出所有手机。
func (s *Store) WebSessions() ([]WebSession, error) {
	rows, err := s.db.Query(`SELECT id, name, key, created_at, last_seen FROM web_sessions ORDER BY last_seen DESC`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []WebSession
	for rows.Next() {
		var w WebSession
		var created, seen int64
		if err := rows.Scan(&w.ID, &w.Name, &w.Key, &created, &seen); err != nil {
			return nil, err
		}
		w.CreatedAt, w.LastSeen = time.Unix(created, 0), time.Unix(seen, 0)
		out = append(out, w)
	}
	return out, rows.Err()
}

// TouchWebSession 记下这台手机刚用过。
func (s *Store) TouchWebSession(id string, at time.Time) error {
	_, err := s.db.Exec(`UPDATE web_sessions SET last_seen=? WHERE id=?`, at.Unix(), id)
	return err
}

// RemoveWebSession 移除一台手机，不存在时也不报错。
func (s *Store) RemoveWebSession(id string) error {
	_, err := s.db.Exec(`DELETE FROM web_sessions WHERE id=?`, id)
	return err
}

// RemoveWebSessionsIdleSince 移除 before 之后没再用过的手机，返回被移除的 ID。
func (s *Store) RemoveWebSessionsIdleSince(before time.Time) ([]string, error) {
	rows, err := s.db.Query(`SELECT id FROM web_sessions WHERE last_seen < ?`, before.Unix())
	if err != nil {
		return nil, err
	}
	var ids []string
	for rows.Next() {
		var id string
		if err := rows.Scan(&id); err != nil {
			rows.Close()
			return nil, err
		}
		ids = append(ids, id)
	}
	err = rows.Err()
	rows.Close() // 只有一个数据库连接，先放掉再写
	if err != nil {
		return nil, err
	}
	for _, id := range ids {
		if err := s.RemoveWebSession(id); err != nil {
			return nil, err
		}
	}
	return ids, nil
}
