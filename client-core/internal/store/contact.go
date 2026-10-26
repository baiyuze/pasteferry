package store

import (
	"database/sql"
	"errors"
	"fmt"
	"strings"
	"time"
)

// Contact 是一个好友：对方的一台电脑，见 design/friends-send.md 第 4 节。
//
// 好友和配对设备分开存：剪贴板同步、快捷粘贴、收藏都只读 devices，按结构就碰不到好友。
type Contact struct {
	ID          string
	PublicKey   []byte
	DisplayName string
	DeviceName  string
	Platform    string
	// Service 是对方用的服务：official / custom / lan；ServerHash 是它自建服务器地址的哈希
	Service    string
	ServerHash []byte
	// AvatarHash 是对方名片里的头像哈希，AvatarPath 是本机重新编码后存下的头像（可能还没取到）
	AvatarHash   []byte
	AvatarPath   string
	Features     []string
	AppVersion   string
	AutoAccept   bool
	AddedAt      time.Time
	LastActivity time.Time
}

const contactsSchema = `
CREATE TABLE IF NOT EXISTS contacts (
    device_id     TEXT PRIMARY KEY,
    public_key    BLOB NOT NULL,
    display_name  TEXT NOT NULL DEFAULT '',
    device_name   TEXT NOT NULL DEFAULT '',
    platform      TEXT NOT NULL DEFAULT '',
    service       TEXT NOT NULL DEFAULT '',
    server_hash   BLOB,
    avatar_hash   BLOB,
    avatar_path   TEXT NOT NULL DEFAULT '',
    features      TEXT NOT NULL DEFAULT '',
    app_version   TEXT NOT NULL DEFAULT '',
    auto_accept   INTEGER NOT NULL DEFAULT 0,
    added_at      INTEGER NOT NULL,
    last_activity INTEGER NOT NULL DEFAULT 0
);
-- 删除好友后要补发给对方的通知：对方不在线时排队，连上再发，最多 30 天
CREATE TABLE IF NOT EXISTS pending_notices (
    device_id  TEXT PRIMARY KEY,
    public_key BLOB NOT NULL,
    created_at INTEGER NOT NULL
);
-- 「所有人」模式下被屏蔽的陌生设备
CREATE TABLE IF NOT EXISTS blocked_devices (
    device_id TEXT PRIMARY KEY,
    at        INTEGER NOT NULL
);`

func (s *Store) migrateContacts() error {
	if _, err := s.db.Exec(contactsSchema); err != nil {
		return fmt.Errorf("建好友表: %w", err)
	}
	return nil
}

const contactColumns = `device_id, public_key, display_name, device_name, platform, service, server_hash,
    avatar_hash, avatar_path, features, app_version, auto_accept, added_at, last_activity`

func scanContact(row interface{ Scan(...any) error }) (Contact, error) {
	var c Contact
	var features string
	var auto int
	var added, last int64
	err := row.Scan(&c.ID, &c.PublicKey, &c.DisplayName, &c.DeviceName, &c.Platform, &c.Service,
		&c.ServerHash, &c.AvatarHash, &c.AvatarPath, &features, &c.AppVersion, &auto, &added, &last)
	if err != nil {
		return c, err
	}
	if features != "" {
		c.Features = strings.Split(features, ",")
	}
	c.AutoAccept = auto != 0
	c.AddedAt = time.Unix(added, 0)
	if last > 0 {
		c.LastActivity = time.Unix(last, 0)
	}
	return c, nil
}

// PutContact 新加或更新一个好友。更新时不动自动接收、加好友的时间和最近一次传输的时间
func (s *Store) PutContact(c Contact) error {
	if c.AddedAt.IsZero() {
		c.AddedAt = time.Now()
	}
	_, err := s.db.Exec(`
INSERT INTO contacts (`+contactColumns+`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)
ON CONFLICT(device_id) DO UPDATE SET
    public_key=excluded.public_key, display_name=excluded.display_name, device_name=excluded.device_name,
    platform=excluded.platform, service=excluded.service, server_hash=excluded.server_hash,
    avatar_hash=excluded.avatar_hash, avatar_path=excluded.avatar_path,
    features=excluded.features, app_version=excluded.app_version`,
		c.ID, c.PublicKey, c.DisplayName, c.DeviceName, c.Platform, c.Service, c.ServerHash,
		c.AvatarHash, c.AvatarPath, strings.Join(c.Features, ","), c.AppVersion, boolInt(c.AutoAccept),
		c.AddedAt.Unix(), unixOrZero(c.LastActivity))
	return err
}

func (s *Store) ListContacts() ([]Contact, error) {
	rows, err := s.db.Query(`SELECT ` + contactColumns + ` FROM contacts ORDER BY added_at`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []Contact
	for rows.Next() {
		c, err := scanContact(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, c)
	}
	return out, rows.Err()
}

// ErrNoContact 表示没有这个好友
var ErrNoContact = errors.New("没有这个好友")

func (s *Store) GetContact(id string) (Contact, error) {
	c, err := scanContact(s.db.QueryRow(`SELECT `+contactColumns+` FROM contacts WHERE device_id=?`, id))
	if errors.Is(err, sql.ErrNoRows) {
		return c, ErrNoContact
	}
	return c, err
}

func (s *Store) DeleteContact(id string) error {
	_, err := s.db.Exec(`DELETE FROM contacts WHERE device_id=?`, id)
	return err
}

func (s *Store) SetContactAutoAccept(id string, auto bool) error {
	res, err := s.db.Exec(`UPDATE contacts SET auto_accept=? WHERE device_id=?`, boolInt(auto), id)
	if err != nil {
		return err
	}
	if n, _ := res.RowsAffected(); n == 0 {
		return ErrNoContact
	}
	return nil
}

func (s *Store) TouchContact(id string, at time.Time) error {
	_, err := s.db.Exec(`UPDATE contacts SET last_activity=? WHERE device_id=?`, at.Unix(), id)
	return err
}

// PutPendingNotice 记下要补发给 id 的删除好友通知
func (s *Store) PutPendingNotice(id string, publicKey []byte, at time.Time) error {
	_, err := s.db.Exec(`INSERT INTO pending_notices (device_id, public_key, created_at) VALUES (?,?,?)
ON CONFLICT(device_id) DO UPDATE SET created_at=excluded.created_at`, id, publicKey, at.Unix())
	return err
}

type PendingNotice struct {
	ID        string
	PublicKey []byte
	CreatedAt time.Time
}

// PendingNotices 返回还没送出的删除好友通知，顺便清掉 since 之前的（太久没连上，不再补发）
func (s *Store) PendingNotices(since time.Time) ([]PendingNotice, error) {
	if _, err := s.db.Exec(`DELETE FROM pending_notices WHERE created_at < ?`, since.Unix()); err != nil {
		return nil, err
	}
	rows, err := s.db.Query(`SELECT device_id, public_key, created_at FROM pending_notices`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []PendingNotice
	for rows.Next() {
		var n PendingNotice
		var at int64
		if err := rows.Scan(&n.ID, &n.PublicKey, &at); err != nil {
			return nil, err
		}
		n.CreatedAt = time.Unix(at, 0)
		out = append(out, n)
	}
	return out, rows.Err()
}

func (s *Store) DeletePendingNotice(id string) error {
	_, err := s.db.Exec(`DELETE FROM pending_notices WHERE device_id=?`, id)
	return err
}

func (s *Store) BlockDevice(id string, at time.Time) error {
	_, err := s.db.Exec(`INSERT OR REPLACE INTO blocked_devices (device_id, at) VALUES (?,?)`, id, at.Unix())
	return err
}

func (s *Store) IsBlocked(id string) bool {
	var n int
	_ = s.db.QueryRow(`SELECT COUNT(*) FROM blocked_devices WHERE device_id=?`, id).Scan(&n)
	return n > 0
}

func boolInt(b bool) int {
	if b {
		return 1
	}
	return 0
}

func unixOrZero(t time.Time) int64 {
	if t.IsZero() {
		return 0
	}
	return t.Unix()
}
