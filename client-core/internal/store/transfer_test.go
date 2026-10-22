package store

import (
	"path/filepath"
	"testing"
	"time"
)

func TestTransfersPersistAndClean(t *testing.T) {
	path := filepath.Join(t.TempDir(), "db.sqlite")
	s, err := Open(path)
	if err != nil {
		t.Fatal(err)
	}
	now := time.Now()
	old := Transfer{ID: "old", Direction: Incoming, DeviceID: "d", Status: TransferDone, CreatedAt: now.Add(-40 * 24 * time.Hour)}
	recent := Transfer{ID: "new", Direction: Incoming, DeviceID: "d", Status: TransferDone, CreatedAt: now,
		Items: []Item{{Name: "a.txt", Size: 3}}, Paths: []string{"/x/a.txt"}}
	running := Transfer{ID: "run", Direction: Outgoing, DeviceID: "d", Status: TransferActive, CreatedAt: now.Add(-40 * 24 * time.Hour)}
	for _, tr := range []Transfer{old, recent, running} {
		if err := s.PutTransfer(tr); err != nil {
			t.Fatal(err)
		}
	}
	if err := s.PutTransferEntries("run", []TransferEntry{{Index: 0, Path: "a", Size: 10}, {Index: 1, Path: "b", Size: 5}, {Index: 2, Path: "dir", IsDir: true}}); err != nil {
		t.Fatal(err)
	}
	if bytes, files, err := s.TransferEntryTotals("run", 2); err != nil || bytes != 15 || files != 2 {
		t.Fatalf("续传前的统计不对：%d %d %v", bytes, files, err)
	}
	s.Close()

	// 重新打开：表已经在了，建表不能出错，记录都还在
	s, err = Open(path)
	if err != nil {
		t.Fatal(err)
	}
	defer s.Close()
	got, err := s.GetTransfer("new")
	if err != nil || len(got.Items) != 1 || got.Paths[0] != "/x/a.txt" || got.Seen {
		t.Fatalf("读回的记录不对：%+v %v", got, err)
	}
	if ids, _ := s.MarkTransfersSeen(); len(ids) != 2 {
		t.Fatalf("收到的两条都该标为看过：%v", ids)
	}
	if list, _ := s.UnfinishedTransfers(); len(list) != 1 || list[0].ID != "run" {
		t.Fatalf("未结束的只有 run：%v", list)
	}
	// 太旧的、已结束的才清理；进行中的再旧也不动
	ids, err := s.StaleTransferIDs(now.Add(-30*24*time.Hour), 500)
	if err != nil || len(ids) != 1 || ids[0] != "old" {
		t.Fatalf("要清理的应该只有 old：%v %v", ids, err)
	}
	if ids, _ := s.StaleTransferIDs(now.Add(-60*24*time.Hour), 1); len(ids) != 1 || ids[0] != "old" {
		t.Fatalf("每类只留 1 条时，收到的里面清掉较旧的那条：%v", ids)
	}
	if err := s.DeleteTransfers([]string{"run"}); err != nil {
		t.Fatal(err)
	}
	if rows, _ := s.TransferEntries("run", 0, 10); len(rows) != 0 {
		t.Fatal("删除记录时条目应一起删掉")
	}
}
