package webshare

import (
	"context"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/rpc"
	"github.com/baiyuze/pasteferry/client-core/internal/send"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// Exercise the encrypted browser HTTP API and the exact desktop RPC list/events,
// rather than merely asserting that the downloaded file exists.
func TestBrowserTransfersReachDesktopHistory(t *testing.T) {
	f := newFixture(t)
	c := f.claim(t, "Phone browser")
	engine := send.New(send.Options{Store: f.db})
	defer engine.Close()
	desktop := rpc.NewServer(rpc.Deps{Store: f.db, Transfers: engine, WebShare: f.srv}, rpc.NewHub(), "test")
	ctx := context.Background()
	var up struct {
		Upload string `json:"upload"`
	}
	if code := c.rpc("upload_start", map[string]any{"name": "record.txt", "size": 3}, &up); code != "" {
		t.Fatal(code)
	}
	if code := c.chunk(up.Upload, 0, []byte("abc")); code != "" {
		t.Fatal(code)
	}
	args := map[string]any{"uploads": []string{up.Upload}, "batch": "history-batch-123456"}
	if code := c.rpc("transfer_upload_done", args, nil); code != "" {
		t.Fatal(code)
	}
	incoming, err := desktop.ListTransfers(ctx, &pb.ListTransfersRequest{Direction: pb.TransferDirection_TRANSFER_DIRECTION_INCOMING})
	if err != nil || len(incoming.Transfers) != 1 {
		t.Fatalf("desktop received: %v %v", incoming, err)
	}
	received := incoming.Transfers[0]
	if received.Status != "done" || received.DeviceName != "Phone browser" || received.TotalBytes != 3 || received.DoneBytes != 3 || len(received.Items) != 1 || len(received.Present) != 1 || !received.Present[0] || received.Seen {
		t.Fatalf("received: %v", received)
	}
	if event := <-f.transfers; event.Id != received.Id || !event.Present[0] {
		t.Fatalf("event: %v", event)
	}
	if b, err := os.ReadFile(received.Paths[0]); err != nil || string(b) != "abc" {
		t.Fatalf("bytes: %q %v", b, err)
	}
	if _, err := desktop.MarkTransfersSeen(ctx, &pb.Empty{}); err != nil {
		t.Fatal(err)
	}
	if code := c.rpc("transfer_upload_done", args, nil); code != "" {
		t.Fatal(code)
	}
	row, _ := f.db.GetTransfer(received.Id)
	if !row.Seen {
		t.Fatal("retry reset seen")
	}
	if _, err := desktop.DeleteTransfers(ctx, &pb.DeleteTransfersRequest{Ids: []string{received.Id}}); err != nil {
		t.Fatal(err)
	}
	if code := c.rpc("transfer_upload_done", args, nil); code != "" {
		t.Fatal(code)
	}
	New(f.srv.opts)
	if _, err := f.db.GetTransfer(received.Id); !store.IsNotFound(err) {
		t.Fatal("deleted record resurrected")
	}
	if _, err := os.Stat(received.Paths[0]); err != nil {
		t.Fatal("history deletion removed received file")
	}

	// Two files become done only when both are handed off to the browser.
	p := filepath.Join(t.TempDir(), "source.txt")
	if err := os.WriteFile(p, []byte("12345"), 0600); err != nil {
		t.Fatal(err)
	}
	queued, err := desktop.SendFiles(ctx, &pb.SendFilesRequest{DeviceId: "web:" + c.sid, Paths: []string{p, p}})
	if err != nil {
		t.Fatal(err)
	}
	if queued.Status != "waiting" || len(queued.Items) != 2 || len(queued.Paths) != 2 || queued.Paths[0] != p {
		t.Fatalf("queued: %v", queued)
	}
	id := strings.TrimPrefix(queued.Id, "web:"+c.sid+":")
	for i := 0; i < 2; i++ {
		if code := c.rpc("transfer_downloaded", map[string]any{"id": id, "item": i}, nil); code != "" {
			t.Fatal(code)
		}
		row, _ := f.db.GetTransfer(queued.Id)
		if row.DoneBytes != int64((i+1)*5) || (row.Status == "done") != (i == 1) {
			t.Fatalf("partial/done: %+v", row)
		}
	}
	outgoing, err := desktop.ListTransfers(ctx, &pb.ListTransfersRequest{Direction: pb.TransferDirection_TRANSFER_DIRECTION_OUTGOING})
	if err != nil || len(outgoing.Transfers) != 1 || outgoing.Transfers[0].Status != "done" {
		t.Fatalf("desktop sent: %v %v", outgoing, err)
	}
	if _, err := desktop.DeleteTransfers(ctx, &pb.DeleteTransfersRequest{Ids: []string{queued.Id}}); err != nil {
		t.Fatal(err)
	}
	if code := c.rpc("transfer_downloaded", map[string]any{"id": id, "item": 0}, nil); code != "" {
		t.Fatal(code)
	}
	New(f.srv.opts)
	if _, err := f.db.GetTransfer(queued.Id); !store.IsNotFound(err) {
		t.Fatal("ack resurrected deleted sent record")
	}
	if len(f.engine.submitted) != 0 {
		t.Fatal("file transfer changed clipboard")
	}
}

func TestLegacyBrowserHistoryAndQueueLifecycle(t *testing.T) {
	f := newFixture(t)
	c := f.claim(t, "Legacy phone")
	other := f.claim(t, "Other")
	p := filepath.Join(t.TempDir(), "kept.txt")
	os.WriteFile(p, []byte("kept"), 0600)
	legacy := store.WebTransfer{ID: "same-batch-123456789", Session: c.sid, Direction: "upload", Status: "done", Items: []store.Item{{Name: "kept.txt", Size: 4}}, Paths: []string{p}, CreatedAt: f.srv.opts.Now().Add(-time.Hour).UnixMilli()}
	if err := f.db.PutWebTransfer(legacy); err != nil {
		t.Fatal(err)
	}
	legacy.Session = other.sid
	if err := f.db.PutWebTransfer(legacy); err != nil {
		t.Fatal(err)
	}
	New(f.srv.opts)
	list, _ := f.db.ListTransfers(store.Incoming, 100, time.Time{})
	if len(list) != 2 || list[0].ID == list[1].ID || list[0].CreatedAt.Unix() != time.UnixMilli(legacy.CreatedAt).Unix() {
		t.Fatalf("legacy: %+v", list)
	}
	New(f.srv.opts)
	list, _ = f.db.ListTransfers(store.Incoming, 100, time.Time{})
	if len(list) != 2 {
		t.Fatal("migration duplicated records")
	}
	engine := send.New(send.Options{Store: f.db})
	defer engine.Close()
	desktop := rpc.NewServer(rpc.Deps{Transfers: engine, WebShare: f.srv}, rpc.NewHub(), "test")
	for _, action := range []string{"desktop-cancel", "browser-delete", "revoke", "expire"} {
		client := f.claim(t, action)
		q, err := f.srv.QueueFiles(context.Background(), client.sid, []string{p})
		if err != nil {
			t.Fatal(err)
		}
		id := strings.TrimPrefix(q.Id, "web:"+client.sid+":")
		switch action {
		case "desktop-cancel":
			_, err = desktop.CancelTransfer(context.Background(), &pb.TransferRef{Id: q.Id})
		case "browser-delete":
			if code := client.rpc("transfer_delete", map[string]any{"id": id}, nil); code != "" {
				t.Fatal(code)
			}
		case "revoke":
			err = f.srv.RemoveSession(client.sid)
		case "expire":
			f.advance(sessionIdle + time.Hour)
			f.srv.expireSessions()
		}
		if err != nil {
			t.Fatal(err)
		}
		row, err := f.db.GetTransfer(q.Id)
		if err != nil || row.Status != "cancelled" {
			t.Fatalf("%s: %+v %v", action, row, err)
		}
		if _, err := os.Stat(f.srv.transferDir(client.sid, id)); !os.IsNotExist(err) {
			t.Fatal("snapshot retained")
		}
		if action == "desktop-cancel" {
			for _, method := range []string{"transfer_downloaded", "transfer_file_info"} {
				if code := client.rpc(method, map[string]any{"id": id, "item": 0}, nil); code == "" {
					t.Fatalf("cancelled queue accepted %s", method)
				}
			}
		}
	}
	if _, err := os.Stat(p); err != nil {
		t.Fatal("original file removed")
	}
}
