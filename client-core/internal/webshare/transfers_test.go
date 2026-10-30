package webshare

import (
	"bytes"
	"context"
	"encoding/json"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestBrowserTransfersAreSeparatePersistentAndSessionScoped(t *testing.T) {
	f := newFixture(t)
	c := f.claim(t, "Phone")
	other := f.claim(t, "Other")
	// Equal names, a multi-chunk file and an empty file must all survive.
	contents := [][]byte{bytes.Repeat([]byte("batch"), chunkSize/5+100), []byte("another"), {}}
	var paths []string
	for i, data := range contents {
		dir := t.TempDir()
		name := "same.txt"
		if i == 2 {
			name = "empty.txt"
		}
		p := filepath.Join(dir, name)
		if err := os.WriteFile(p, data, 0600); err != nil {
			t.Fatal(err)
		}
		paths = append(paths, p)
	}
	queued, err := f.srv.QueueFiles(context.Background(), c.sid, paths)
	if err != nil {
		t.Fatal(err)
	}
	queued.Id = strings.TrimPrefix(queued.Id, "web:"+c.sid+":")
	// Host sources changing or disappearing cannot change the queued snapshot.
	_ = os.WriteFile(paths[0], []byte("changed"), 0600)
	_ = os.Remove(paths[1])
	var list struct {
		Transfers []webTransfer `json:"transfers"`
	}
	if code := c.rpc("transfers", nil, &list); code != "" || len(list.Transfers) != 1 {
		t.Fatalf("list: %s %+v", code, list)
	}
	if code := other.rpc("transfers", nil, &list); code != "" || len(list.Transfers) != 0 {
		t.Fatalf("other list: %s %+v", code, list)
	}
	for _, method := range []string{"transfer_file_info", "transfer_downloaded", "transfer_delete"} {
		if code := other.rpc(method, map[string]any{"id": queued.Id, "item": 0}, nil); code != "gone" {
			t.Errorf("%s leaked: %s", method, code)
		}
	}
	if _, code := other.fetch("transfer_chunk", map[string]any{"transfer": queued.Id, "item": 0, "n": 0}); code != "gone" {
		t.Fatal(code)
	}
	for i, want := range contents {
		var info struct {
			Name   string `json:"name"`
			Size   int64  `json:"size"`
			Chunks int    `json:"chunks"`
		}
		if code := c.rpc("transfer_file_info", map[string]any{"id": queued.Id, "item": i}, &info); code != "" {
			t.Fatal(code)
		}
		var got []byte
		for n := 0; n < info.Chunks; n++ {
			b, code := c.fetch("transfer_chunk", map[string]any{"transfer": queued.Id, "item": i, "n": n})
			if code != "" {
				t.Fatal(code)
			}
			got = append(got, b...)
		}
		if !bytes.Equal(got, want) {
			t.Fatalf("item %d differs", i)
		}
		if _, code := c.fetch("transfer_chunk", map[string]any{"transfer": queued.Id, "item": i, "n": 1 << 62}); code != "bad_request" {
			t.Fatal(code)
		}
		if code := c.rpc("transfer_downloaded", map[string]any{"id": queued.Id, "item": i}, nil); code != "" {
			t.Fatal(code)
		}
	}
	// Restart the server wrapper with the same store: history and snapshots remain.
	restarted := New(f.srv.opts)
	sess, err := restarted.sessionByID(c.sid)
	if err != nil {
		t.Fatal(err)
	}
	out, err := restarted.transferRPC(sess, "transfers", "", 0)
	if err != nil {
		t.Fatal(err)
	}
	b, _ := json.Marshal(out)
	if strings.Contains(string(b), f.srv.opts.WorkDir) || !strings.Contains(string(b), `"status":"done"`) {
		t.Fatalf("DTO exposes paths or lost status: %s", b)
	}
	if len(f.engine.submitted) != 0 {
		t.Fatal("transfer touched clipboard engine")
	}
	if code := c.rpc("transfer_delete", map[string]any{"id": queued.Id}, nil); code != "" {
		t.Fatal(code)
	}
	if _, err := os.Stat(f.srv.transferDir(c.sid, queued.Id)); !os.IsNotExist(err) {
		t.Fatal("snapshot not cleaned")
	}
}

func TestBrowserUploadsAreAtomicIdempotentAndNeverClipboardItems(t *testing.T) {
	f := newFixture(t)
	c := f.claim(t, "Phone")
	other := f.claim(t, "Other")
	var ids []string
	for _, data := range [][]byte{[]byte("one"), []byte("two"), {}} {
		var up struct {
			Upload string `json:"upload"`
		}
		if code := c.rpc("upload_start", map[string]any{"name": "same.txt", "size": len(data)}, &up); code != "" {
			t.Fatal(code)
		}
		if len(data) > 0 {
			if code := c.chunk(up.Upload, 0, data); code != "" {
				t.Fatal(code)
			}
		}
		ids = append(ids, up.Upload)
	}
	args := map[string]any{"uploads": ids, "batch": "unique-batch-0123456789"}
	if code := other.rpc("transfer_upload_done", args, nil); code != "upload_gone" {
		t.Fatal(code)
	}
	var result webTransfer
	if code := c.rpc("transfer_upload_done", args, &result); code != "" {
		t.Fatal(code)
	}
	if code := c.rpc("transfer_upload_done", args, &result); code != "" {
		t.Fatalf("retry finalization: %s", code)
	}
	if len(result.Items) != 3 || result.Status != "done" {
		t.Fatalf("result: %+v", result)
	}
	stored, err := f.db.WebTransfer(c.sid, result.ID)
	if err != nil {
		t.Fatal(err)
	}
	// An attacker choosing the same finalization ID cannot overwrite another session.
	var collision struct {
		Upload string `json:"upload"`
	}
	other.rpc("upload_start", map[string]any{"name": "other.txt", "size": 1}, &collision)
	other.chunk(collision.Upload, 0, []byte("x"))
	if code := other.rpc("transfer_upload_done", map[string]any{"uploads": []string{collision.Upload}, "batch": result.ID}, nil); code != "" {
		t.Fatal(code)
	}
	unchanged, err := f.db.WebTransfer(c.sid, result.ID)
	if err != nil || len(unchanged.Items) != 3 || unchanged.Items[0].Name != stored.Items[0].Name {
		t.Fatal("another session overwrote the batch")
	}
	for i, want := range []string{"one", "two", ""} {
		got, err := os.ReadFile(stored.Paths[i])
		if err != nil || string(got) != want {
			t.Fatalf("item %d: %q %v", i, got, err)
		}
	}
	if len(f.engine.submitted) != 0 {
		t.Fatal("upload touched clipboard engine")
	}
	if code := c.rpc("transfer_delete", map[string]any{"id": result.ID}, nil); code != "" {
		t.Fatal(code)
	}
	if _, err := os.Stat(stored.Paths[0]); err != nil {
		t.Fatal("deleting history deleted a received file")
	}
	var up struct {
		Upload string `json:"upload"`
	}
	c.rpc("upload_start", map[string]any{"name": "cancel.txt", "size": 1}, &up)
	c.rpc("upload_cancel", map[string]any{"upload": up.Upload}, nil)
	if code := c.chunk(up.Upload, 0, []byte("x")); code != "upload_gone" {
		t.Fatal(code)
	}
	if code := c.rpc("transfer_upload_done", map[string]any{"uploads": []string{up.Upload}, "batch": "cancelled-batch-12345"}, nil); code != "upload_gone" {
		t.Fatal(code)
	}
	list, _ := f.db.WebTransfers(c.sid)
	if len(list) != 0 {
		t.Fatal("cancelled upload left history")
	}
	// Revoking access removes both metadata and owned download snapshots.
	p := filepath.Join(t.TempDir(), "file")
	os.WriteFile(p, []byte("x"), 0600)
	queued, err := f.srv.QueueFiles(context.Background(), c.sid, []string{p})
	if err != nil {
		t.Fatal(err)
	}
	queued.Id = strings.TrimPrefix(queued.Id, "web:"+c.sid+":")
	if err := f.srv.RemoveSession(c.sid); err != nil {
		t.Fatal(err)
	}
	if _, err := os.Stat(f.srv.transferDir(c.sid, queued.Id)); !os.IsNotExist(err) {
		t.Fatal("revoked snapshot remains")
	}
	if _, code := c.fetch("transfer_chunk", map[string]any{"transfer": queued.Id, "item": 0, "n": 0}); !strings.Contains(code, "unknown_session") {
		t.Fatal(code)
	}
}
