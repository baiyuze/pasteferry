package pack

import (
	"bytes"
	"context"
	"crypto/rand"
	"crypto/sha256"
	"errors"
	"os"
	"path/filepath"
	"testing"
)

func TestFramesResumeFromOffset(t *testing.T) {
	dir := t.TempDir()
	data := make([]byte, 300<<10)
	if _, err := rand.Read(data); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(dir, "a.bin"), data, 0o644); err != nil {
		t.Fatal(err)
	}
	entries, tops, err := BuildManifest(context.Background(), []string{filepath.Join(dir, "a.bin")}, nil)
	if err != nil || len(entries) != 1 || len(tops) != 1 || tops[0].Size != int64(len(data)) {
		t.Fatalf("清单不对：%v %v %v", entries, tops, err)
	}

	var buf bytes.Buffer
	var sent int64
	fw, err := NewFrameWriter(&buf, func(n int64) { sent += n })
	if err != nil {
		t.Fatal(err)
	}
	const offset = 100 << 10
	if err := fw.WriteEntry(0, entries[0], offset); err != nil {
		t.Fatal(err)
	}
	if err := fw.Finish(); err != nil {
		t.Fatal(err)
	}
	if sent != int64(len(data)-offset) {
		t.Fatalf("续传只应发后面的 %d 字节，实际 %d", len(data)-offset, sent)
	}

	fr, err := NewFrameReader(&buf)
	if err != nil {
		t.Fatal(err)
	}
	defer fr.Close()
	f, err := fr.Next()
	if err != nil || f.GetFile().GetOffset() != offset || f.GetFile().GetPath() != "a.bin" {
		t.Fatalf("第一帧不对：%v %v", f, err)
	}
	h := sha256.New()
	h.Write(data[:offset])
	var got bytes.Buffer
	if _, err := fr.CopyContent(&got, h, int64(len(data)-offset)); err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(got.Bytes(), data[offset:]) {
		t.Fatal("内容不对")
	}
	end, err := fr.Next()
	if err != nil || !bytes.Equal(end.GetFileEnd().GetSha256(), h.Sum(nil)) {
		t.Fatal("整个文件的哈希对不上")
	}
	if f, err := fr.Next(); err != nil || f.GetEnd() == nil {
		t.Fatalf("应当是结束帧：%v %v", f, err)
	}
}

func TestFramesDetectChangedSource(t *testing.T) {
	path := filepath.Join(t.TempDir(), "a.txt")
	if err := os.WriteFile(path, []byte("one"), 0o644); err != nil {
		t.Fatal(err)
	}
	entries, _, err := BuildManifest(context.Background(), []string{path}, nil)
	if err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(path, []byte("longer now"), 0o644); err != nil {
		t.Fatal(err)
	}
	fw, err := NewFrameWriter(&bytes.Buffer{}, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer fw.Close()
	if err := fw.WriteEntry(0, entries[0], 0); !errors.Is(err, ErrSourceChanged) {
		t.Fatalf("应当报源文件被改，实际 %v", err)
	}
}

func TestFramesTruncatedStream(t *testing.T) {
	var buf bytes.Buffer
	fw, _ := NewFrameWriter(&buf, nil)
	path := filepath.Join(t.TempDir(), "a.txt")
	_ = os.WriteFile(path, []byte("hello"), 0o644)
	entries, _, _ := BuildManifest(context.Background(), []string{path}, nil)
	_ = fw.WriteEntry(0, entries[0], 0)
	_ = fw.enc.Flush()
	fr, _ := NewFrameReader(bytes.NewReader(buf.Bytes()))
	defer fr.Close()
	f, _ := fr.Next()
	h := sha256.New()
	_, _ = fr.CopyContent(&bytes.Buffer{}, h, f.GetFile().GetSize())
	_, _ = fr.Next() // file_end
	// 没有结束帧就断了：一定要报错，不能当作收完。zstd 在流中途截断时给的错误因版本而异，只查有没有错
	if f, err := fr.Next(); err == nil {
		t.Fatalf("没有结束帧时应当报数据流中断，实际读到 %v", f)
	}
}

func TestNamesRejectTraversal(t *testing.T) {
	n := NewNames()
	for _, bad := range []string{"../x", "/etc/passwd", "a/../../x", "..", "a\\b"} {
		if _, err := n.Rel(bad, false); err == nil {
			t.Errorf("%q 应当被拒绝", bad)
		}
	}
	if got, err := n.Rel("top/sub/file.txt", false); err != nil || got != "top/sub/file.txt" {
		t.Fatalf("普通路径：%q %v", got, err)
	}
}

func TestManifestDedupesTopNames(t *testing.T) {
	a, b := t.TempDir(), t.TempDir()
	for _, d := range []string{a, b} {
		if err := os.WriteFile(filepath.Join(d, "notes.txt"), []byte("x"), 0o644); err != nil {
			t.Fatal(err)
		}
	}
	_, tops, err := BuildManifest(context.Background(), []string{filepath.Join(a, "notes.txt"), filepath.Join(b, "notes.txt")}, nil)
	if err != nil || len(tops) != 2 || tops[1].Name != "notes (2).txt" {
		t.Fatalf("同名的顶层项目应当改名：%v %v", tops, err)
	}
}
