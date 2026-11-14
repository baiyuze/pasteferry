package main

import (
	"encoding/json"
	"net/url"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestPrepareSharePreservesURICharactersAndDeduplicates(t *testing.T) {
	root := t.TempDir()
	name := "quote' space 中文 % line\nname.txt"
	if os.PathSeparator == '\\' {
		name = "quote' space 中文 % name.txt"
	}
	file := filepath.Join(root, name)
	if err := os.WriteFile(file, []byte("test"), 0600); err != nil {
		t.Fatal(err)
	}
	uriPath := filepath.ToSlash(file)
	if os.PathSeparator == '\\' {
		uriPath = "/" + uriPath
	}
	u := (&url.URL{Scheme: "file", Path: uriPath}).String()
	id, err := prepareShare(root, []string{"--uri-list", u + "\n" + u + "\n"})
	if err != nil {
		t.Fatal(err)
	}
	body, err := os.ReadFile(filepath.Join(root, "share-inbox", id+".json"))
	if err != nil {
		t.Fatal(err)
	}
	var got struct {
		ID    string   `json:"id"`
		Paths []string `json:"paths"`
	}
	if err := json.Unmarshal(body, &got); err != nil {
		t.Fatal(err)
	}
	if got.ID != id || len(got.Paths) != 1 || got.Paths[0] != file {
		t.Fatalf("wrong batch: %+v", got)
	}
}

func TestPrepareShareRejectsNonLocalURIsAndMissingFiles(t *testing.T) {
	for _, value := range []string{"https://example.com/x", "file://remotehost/private", "file:///tmp/x?command=bad"} {
		if _, err := prepareShare(t.TempDir(), []string{"--uri-list", value}); err == nil {
			t.Fatalf("accepted %q", value)
		}
	}
	if _, err := prepareShare(t.TempDir(), []string{"/nonexistent/pasteferry-share-test"}); err == nil {
		t.Fatal("accepted missing file")
	}
}

func TestPrepareShareBatchesHundredFilesAndFolder(t *testing.T) {
	root := t.TempDir()
	paths := []string{root}
	for i := 0; i < 100; i++ {
		file := filepath.Join(root, strings.Repeat("a", i+1)+".txt")
		if err := os.WriteFile(file, nil, 0600); err != nil {
			t.Fatal(err)
		}
		paths = append(paths, file)
	}
	if _, err := prepareShare(root, paths); err != nil {
		t.Fatal(err)
	}
	entries, err := os.ReadDir(filepath.Join(root, "share-inbox"))
	if err != nil || len(entries) != 1 || !strings.HasSuffix(entries[0].Name(), ".json") {
		t.Fatalf("non-atomic inbox: %v %v", entries, err)
	}
}

func TestShareMenusQuoteExecutableAndProtectUnrelatedFiles(t *testing.T) {
	data := t.TempDir()
	cli := "/opt/Paste Ferry/'quote$%`/pasteferry-cli"
	if err := installShareMenus(cli, data, false); err != nil {
		t.Fatal(err)
	}
	script := filepath.Join(data, "nautilus", "scripts", "Send with PasteFerry")
	body, _ := os.ReadFile(script)
	if !strings.Contains(string(body), `'"'"'`) || !strings.Contains(string(body), `"${NAUTILUS_SCRIPT_SELECTED_URIS:-}"`) {
		t.Fatalf("unsafe script: %s", body)
	}
	menu, _ := os.ReadFile(filepath.Join(data, "kio", "servicemenus", "pasteferry-send.desktop"))
	if !strings.Contains(string(menu), "%%") || !strings.Contains(string(menu), " share %F") {
		t.Fatalf("unsafe menu: %s", menu)
	}
	if err := installShareMenus(cli, data, true); err != nil {
		t.Fatal(err)
	}
	if _, err := os.Stat(script); !os.IsNotExist(err) {
		t.Fatalf("menu not removed: %v", err)
	}
	if err := os.WriteFile(script, []byte("custom user script"), 0600); err != nil {
		t.Fatal(err)
	}
	if err := installShareMenus(cli, data, false); err == nil {
		t.Fatal("replaced unrelated script")
	}
	if err := installShareMenus(cli, data, true); err == nil {
		t.Fatal("removed unrelated script")
	}
}
