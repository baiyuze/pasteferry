package store

// 隔空传送的传输记录，见 design/send-files.md 第 8.1 节。与复制记录（clips）无关。

import (
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"
)

type Direction int32

const (
	Outgoing Direction = 1
	Incoming Direction = 2
)

// 传输的状态，与 daemon.proto 里 Transfer.status 的取值相同。
const (
	TransferQueued      = "queued"
	TransferScanning    = "scanning"
	TransferWaiting     = "waiting"
	TransferActive      = "active"
	TransferPaused      = "paused"
	TransferInterrupted = "interrupted"
	TransferDone        = "done"
	TransferFailed      = "failed"
	TransferCancelled   = "cancelled"
	TransferDeclined    = "declined"
	TransferExpired     = "expired"
)

// TransferFinished 表示这个状态不会再变。
func TransferFinished(status string) bool {
	switch status {
	case TransferDone, TransferFailed, TransferCancelled, TransferDeclined, TransferExpired:
		return true
	}
	return false
}

type Transfer struct {
	ID         string
	Direction  Direction
	DeviceID   string
	DeviceName string
	Status     string
	Items      []Item   // 顶层的文件和文件夹
	Paths      []string // 发出的：源路径；收到的：顶层项目的最终路径（与 Items 一一对应）
	TotalBytes int64
	DoneBytes  int64
	FileCount  int64
	DestDir    string // 收到的：当时的保存位置
	Error      string
	Shortfall  int64
	Seen       bool
	Relayed    bool
	AllowRelay bool // 发出的：用户已同意经官方服务中转
	Attempt    int  // 发出的：已经发起过几次
	Renamed    int64 // 收到的：名字在本机改过的文件数
	CreatedAt  time.Time
	UpdatedAt  time.Time
	FinishedAt time.Time
}

// TransferEntry 是一批里的一个条目：发出的是清单，收到的是已经开始接收的条目。
type TransferEntry struct {
	Index     int64
	Path      string // 对端看到的相对路径（正斜杠分隔）
	Size      int64
	IsDir     bool
	Mode      uint32
	MTime     int64
	Link      string
	Source    string // 发出的：本机的完整路径
	LocalPath string // 收到的：在临时目录里的相对路径（正斜杠分隔，Windows 上可能改过名）
	DoneBytes int64  // 收到的：已经写进磁盘并记下的字节数
	Complete  bool   // 收到的：已经收完并校验过
}

func (s *Store) migrateTransfers() error {
	_, err := s.db.Exec(`
CREATE TABLE IF NOT EXISTS transfers (
    id           TEXT PRIMARY KEY,
    direction    INTEGER NOT NULL,
    device_id    TEXT NOT NULL,
    device_name  TEXT NOT NULL DEFAULT '',
    status       TEXT NOT NULL,
    items        TEXT NOT NULL DEFAULT '[]',
    paths        TEXT NOT NULL DEFAULT '[]',
    total_bytes  INTEGER NOT NULL DEFAULT 0,
    done_bytes   INTEGER NOT NULL DEFAULT 0,
    file_count   INTEGER NOT NULL DEFAULT 0,
    dest_dir     TEXT NOT NULL DEFAULT '',
    error        TEXT NOT NULL DEFAULT '',
    shortfall    INTEGER NOT NULL DEFAULT 0,
    seen         INTEGER NOT NULL DEFAULT 0,
    relayed      INTEGER NOT NULL DEFAULT 0,
    allow_relay  INTEGER NOT NULL DEFAULT 0,
    attempt      INTEGER NOT NULL DEFAULT 0,
    created_at   INTEGER NOT NULL,
    updated_at   INTEGER NOT NULL,
    finished_at  INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_transfers_created ON transfers(direction, created_at DESC);

CREATE TABLE IF NOT EXISTS transfer_entries (
    transfer_id  TEXT NOT NULL REFERENCES transfers(id) ON DELETE CASCADE,
    idx          INTEGER NOT NULL,
    path         TEXT NOT NULL,
    size         INTEGER NOT NULL DEFAULT 0,
    is_dir       INTEGER NOT NULL DEFAULT 0,
    mode         INTEGER NOT NULL DEFAULT 0,
    mtime        INTEGER NOT NULL DEFAULT 0,
    link         TEXT NOT NULL DEFAULT '',
    source       TEXT NOT NULL DEFAULT '',
    local_path   TEXT NOT NULL DEFAULT '',
    done_bytes   INTEGER NOT NULL DEFAULT 0,
    complete     INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (transfer_id, idx)
);`)
	if err != nil {
		return fmt.Errorf("建隔空传送表: %w", err)
	}
	// 测试版建的表没有这一列
	return s.addColumnIfMissing("transfers", "renamed", "INTEGER NOT NULL DEFAULT 0")
}

// PutTransfer 新建或整体更新一条传输记录。
func (s *Store) PutTransfer(t Transfer) error {
	items, err := json.Marshal(nonNilItems(t.Items))
	if err != nil {
		return err
	}
	if t.Paths == nil {
		t.Paths = []string{}
	}
	paths, err := json.Marshal(t.Paths)
	if err != nil {
		return err
	}
	var finished int64
	if !t.FinishedAt.IsZero() {
		finished = t.FinishedAt.Unix()
	}
	if t.UpdatedAt.IsZero() {
		t.UpdatedAt = time.Now()
	}
	_, err = s.db.Exec(`
INSERT INTO transfers (id, direction, device_id, device_name, status, items, paths,
                       total_bytes, done_bytes, file_count, dest_dir, error, shortfall,
                       seen, relayed, allow_relay, attempt, created_at, updated_at, finished_at, renamed)
VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
ON CONFLICT(id) DO UPDATE SET
    device_name=excluded.device_name, status=excluded.status, items=excluded.items,
    paths=excluded.paths, total_bytes=excluded.total_bytes, done_bytes=excluded.done_bytes,
    file_count=excluded.file_count, dest_dir=excluded.dest_dir, error=excluded.error,
    shortfall=excluded.shortfall, seen=excluded.seen, relayed=excluded.relayed,
    allow_relay=excluded.allow_relay, attempt=excluded.attempt,
    updated_at=excluded.updated_at, finished_at=excluded.finished_at, renamed=excluded.renamed`,
		t.ID, t.Direction, t.DeviceID, t.DeviceName, t.Status, string(items), string(paths),
		t.TotalBytes, t.DoneBytes, t.FileCount, t.DestDir, t.Error, t.Shortfall,
		t.Seen, t.Relayed, t.AllowRelay, t.Attempt, t.CreatedAt.Unix(), t.UpdatedAt.Unix(), finished, t.Renamed)
	if err != nil {
		return fmt.Errorf("写入传输记录: %w", err)
	}
	return nil
}

func nonNilItems(items []Item) []Item {
	if items == nil {
		return []Item{}
	}
	return items
}

const transferColumns = `id, direction, device_id, device_name, status, items, paths,
       total_bytes, done_bytes, file_count, dest_dir, error, shortfall,
       seen, relayed, allow_relay, attempt, created_at, updated_at, finished_at, renamed`

func (s *Store) GetTransfer(id string) (Transfer, error) {
	list, err := s.queryTransfers(`SELECT `+transferColumns+` FROM transfers WHERE id=?`, id)
	if err != nil {
		return Transfer{}, err
	}
	if len(list) == 0 {
		return Transfer{}, ErrNotFound
	}
	return list[0], nil
}

// ListTransfers 按时间倒序列出一类（direction 为 0 时两类都要）。
func (s *Store) ListTransfers(direction Direction, limit int, before time.Time) ([]Transfer, error) {
	if limit <= 0 {
		limit = 100
	}
	q := `SELECT ` + transferColumns + ` FROM transfers WHERE 1=1`
	var args []any
	if direction != 0 {
		q += ` AND direction = ?`
		args = append(args, direction)
	}
	if !before.IsZero() {
		q += ` AND created_at < ?`
		args = append(args, before.Unix())
	}
	q += ` ORDER BY created_at DESC, rowid DESC LIMIT ?`
	args = append(args, limit)
	return s.queryTransfers(q, args...)
}

// UnfinishedTransfers 列出所有还没结束的传输，按创建顺序。
func (s *Store) UnfinishedTransfers() ([]Transfer, error) {
	return s.queryTransfers(`SELECT ` + transferColumns + ` FROM transfers
WHERE status NOT IN ('done','failed','cancelled','declined','expired') ORDER BY created_at, rowid`)
}

func (s *Store) queryTransfers(q string, args ...any) ([]Transfer, error) {
	rows, err := s.db.Query(q, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []Transfer
	for rows.Next() {
		var t Transfer
		var items, paths string
		var created, updated, finished int64
		if err := rows.Scan(&t.ID, &t.Direction, &t.DeviceID, &t.DeviceName, &t.Status, &items, &paths,
			&t.TotalBytes, &t.DoneBytes, &t.FileCount, &t.DestDir, &t.Error, &t.Shortfall,
			&t.Seen, &t.Relayed, &t.AllowRelay, &t.Attempt, &created, &updated, &finished, &t.Renamed); err != nil {
			return nil, err
		}
		_ = json.Unmarshal([]byte(items), &t.Items)
		_ = json.Unmarshal([]byte(paths), &t.Paths)
		t.CreatedAt = time.Unix(created, 0)
		t.UpdatedAt = time.Unix(updated, 0)
		if finished > 0 {
			t.FinishedAt = time.Unix(finished, 0)
		}
		out = append(out, t)
	}
	return out, rows.Err()
}

// DeleteTransfers 删除记录（连同条目），不碰文件。
func (s *Store) DeleteTransfers(ids []string) error {
	if len(ids) == 0 {
		return nil
	}
	q := `DELETE FROM transfers WHERE id IN (?` + strings.Repeat(",?", len(ids)-1) + `)`
	args := make([]any, len(ids))
	for i, id := range ids {
		args[i] = id
	}
	_, err := s.db.Exec(q, args...)
	return err
}

// FinishedTransferIDs 列出已经结束的记录，direction 为 0 时两类都要。
func (s *Store) FinishedTransferIDs(direction Direction) ([]string, error) {
	q := `SELECT id FROM transfers WHERE status IN ('done','failed','cancelled','declined','expired')`
	var args []any
	if direction != 0 {
		q += ` AND direction = ?`
		args = append(args, direction)
	}
	return s.queryIDs(q, args...)
}

// StaleTransferIDs 列出要清理的已结束记录：比 before 早的，以及每类最近 keep 条之外的。
func (s *Store) StaleTransferIDs(before time.Time, keep int) ([]string, error) {
	return s.queryIDs(`
SELECT id FROM transfers WHERE status IN ('done','failed','cancelled','declined','expired') AND (
    created_at < ? OR id NOT IN (
        SELECT id FROM transfers t2 WHERE t2.direction = transfers.direction
        ORDER BY created_at DESC, rowid DESC LIMIT ?))`, before.Unix(), keep)
}

func (s *Store) queryIDs(q string, args ...any) ([]string, error) {
	rows, err := s.db.Query(q, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var ids []string
	for rows.Next() {
		var id string
		if err := rows.Scan(&id); err != nil {
			return nil, err
		}
		ids = append(ids, id)
	}
	return ids, rows.Err()
}

// MarkTransfersSeen 把收到的都标为看过，返回这次改动的记录。
func (s *Store) MarkTransfersSeen() ([]string, error) {
	ids, err := s.queryIDs(`SELECT id FROM transfers WHERE direction = ? AND seen = 0`, Incoming)
	if err != nil || len(ids) == 0 {
		return nil, err
	}
	_, err = s.db.Exec(`UPDATE transfers SET seen = 1 WHERE direction = ? AND seen = 0`, Incoming)
	return ids, err
}

// PutTransferEntries 写入发送方的清单，整批在一个事务里。
func (s *Store) PutTransferEntries(id string, entries []TransferEntry) error {
	tx, err := s.db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()
	if _, err := tx.Exec(`DELETE FROM transfer_entries WHERE transfer_id=?`, id); err != nil {
		return err
	}
	stmt, err := tx.Prepare(`
INSERT INTO transfer_entries (transfer_id, idx, path, size, is_dir, mode, mtime, link, source)
VALUES (?,?,?,?,?,?,?,?,?)`)
	if err != nil {
		return err
	}
	defer stmt.Close()
	for _, e := range entries {
		if _, err := stmt.Exec(id, e.Index, e.Path, e.Size, e.IsDir, e.Mode, e.MTime, e.Link, e.Source); err != nil {
			return fmt.Errorf("写入清单: %w", err)
		}
	}
	return tx.Commit()
}

// PutReceivedEntry 记下接收方开始接收的一个条目。
func (s *Store) PutReceivedEntry(id string, e TransferEntry) error {
	_, err := s.db.Exec(`
INSERT INTO transfer_entries (transfer_id, idx, path, size, is_dir, mode, mtime, link, local_path, done_bytes, complete)
VALUES (?,?,?,?,?,?,?,?,?,?,?)
ON CONFLICT(transfer_id, idx) DO UPDATE SET
    path=excluded.path, size=excluded.size, is_dir=excluded.is_dir, mode=excluded.mode,
    mtime=excluded.mtime, link=excluded.link, local_path=excluded.local_path,
    done_bytes=excluded.done_bytes, complete=excluded.complete`,
		id, e.Index, e.Path, e.Size, e.IsDir, e.Mode, e.MTime, e.Link, e.LocalPath, e.DoneBytes, e.Complete)
	return err
}

// SetEntryProgress 记下接收方一个条目已经写进磁盘的字节数。
func (s *Store) SetEntryProgress(id string, index, done int64, complete bool) error {
	_, err := s.db.Exec(`UPDATE transfer_entries SET done_bytes=?, complete=? WHERE transfer_id=? AND idx=?`,
		done, complete, id, index)
	return err
}

// TransferEntries 按序号读出一段条目：从 from 开始，最多 limit 个。
func (s *Store) TransferEntries(id string, from int64, limit int) ([]TransferEntry, error) {
	rows, err := s.db.Query(`
SELECT idx, path, size, is_dir, mode, mtime, link, source, local_path, done_bytes, complete
FROM transfer_entries WHERE transfer_id=? AND idx >= ? ORDER BY idx LIMIT ?`, id, from, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []TransferEntry
	for rows.Next() {
		var e TransferEntry
		if err := rows.Scan(&e.Index, &e.Path, &e.Size, &e.IsDir, &e.Mode, &e.MTime, &e.Link,
			&e.Source, &e.LocalPath, &e.DoneBytes, &e.Complete); err != nil {
			return nil, err
		}
		out = append(out, e)
	}
	return out, rows.Err()
}

// DeleteTransferEntries 删掉一批的全部条目。结束后条目就没用了，十万个文件的文件夹也不会一直占着数据库。
func (s *Store) DeleteTransferEntries(id string) error {
	_, err := s.db.Exec(`DELETE FROM transfer_entries WHERE transfer_id=?`, id)
	return err
}

// IsNotFound 判断是不是记录不存在。
func IsNotFound(err error) bool {
	return errors.Is(err, ErrNotFound) || errors.Is(err, sql.ErrNoRows)
}

// TransferEntryTotals 统计序号小于 before 的普通文件：总字节数与个数。续传时用来算已经发了多少。
func (s *Store) TransferEntryTotals(id string, before int64) (bytes, files int64, err error) {
	err = s.db.QueryRow(`
SELECT COALESCE(SUM(size), 0), COUNT(*) FROM transfer_entries
WHERE transfer_id=? AND idx < ? AND is_dir=0 AND link=''`, id, before).Scan(&bytes, &files)
	return
}

// LargestTransferEntry 返回一批里最大的单个文件。
func (s *Store) LargestTransferEntry(id string) (int64, error) {
	var n int64
	err := s.db.QueryRow(`SELECT COALESCE(MAX(size), 0) FROM transfer_entries WHERE transfer_id=?`, id).Scan(&n)
	return n, err
}

// DeleteTransferEntriesFrom 删掉序号不小于 from 的条目（续传时丢弃半截之后不该存在的记录）。
func (s *Store) DeleteTransferEntriesFrom(id string, from int64) error {
	_, err := s.db.Exec(`DELETE FROM transfer_entries WHERE transfer_id=? AND idx >= ?`, id, from)
	return err
}
