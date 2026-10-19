package update

import (
	"archive/tar"
	"archive/zip"
	"bytes"
	"compress/gzip"
	"context"
	"crypto/ed25519"
	"crypto/rand"
	"crypto/sha256"
	"encoding/base64"
	"encoding/hex"
	"encoding/json"
	"io"
	"log/slog"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"runtime"
	"strings"
	"sync/atomic"
	"testing"
	"time"
)

func TestVersionCompare(t *testing.T) {
	cases := []struct {
		a, b string
		want int
	}{
		{"2.3.0", "2.2.9", 1}, {"2.3.0", "2.3.0", 0}, {"2.10.0", "2.9.9", 1},
		{"v2.3.0", "2.3.0", 0}, {"2.3.0-test", "2.3.0", -1}, {"2.3.1-test", "2.3.0", 1},
	}
	for _, c := range cases {
		a, err := ParseVersion(c.a)
		if err != nil {
			t.Fatal(err)
		}
		b, _ := ParseVersion(c.b)
		if got := a.Compare(b); got != c.want {
			t.Errorf("%s vs %s = %d, want %d", c.a, c.b, got, c.want)
		}
	}
	for _, bad := range []string{"", "2.3", "2.3.x", "-1.0.0", "1.2.3.4"} {
		if _, err := ParseVersion(bad); err == nil {
			t.Errorf("accepted %q", bad)
		}
	}
}

func TestLocalizedFallsBackByScript(t *testing.T) {
	r := Release{Notes: map[string]Notes{
		"en":         {Changes: []string{"en"}},
		"zh-Hans":    {Changes: []string{"简"}},
		"zh-Hant-TW": {Changes: []string{"台"}},
	}}
	for lang, want := range map[string]string{"zh-Hant-HK": "台", "zh-Hans": "简", "ja": "en", "fr": "en", "en": "en"} {
		if got := r.Localized(lang).Changes; len(got) != 1 || got[0] != want {
			t.Errorf("%s → %v, want %s", lang, got, want)
		}
	}
}

// fixture 建一个签过名的清单与对应的安装包。
type fixture struct {
	pub     ed25519.PublicKey
	priv    ed25519.PrivateKey
	payload []byte
}

func newFixture(t *testing.T) *fixture {
	pub, priv, err := ed25519.GenerateKey(rand.Reader)
	if err != nil {
		t.Fatal(err)
	}
	return &fixture{pub: pub, priv: priv, payload: bytes.Repeat([]byte("PasteFerry"), 5000)}
}

func (f *fixture) manifest(latest string, mirrors ...Mirror) []byte {
	sum := sha256.Sum256(f.payload)
	m := Manifest{Schema: Schema, Latest: latest, Date: "2026-10-20", Mirrors: mirrors,
		Assets: map[string]Asset{"test": {Name: "PasteFerry-test.bin", Size: int64(len(f.payload)), SHA256: hex.EncodeToString(sum[:])}},
		Releases: []Release{
			{Version: latest, Notes: map[string]Notes{"en": {Changes: []string{"new " + latest}}}},
			{Version: "2.2.0", Notes: map[string]Notes{"en": {Fixes: []string{"old"}}}},
		}}
	raw, _ := json.Marshal(m)
	return raw
}

func (f *fixture) sign(raw []byte) []byte {
	return []byte(base64.StdEncoding.EncodeToString(ed25519.Sign(f.priv, raw)) + "\n")
}

// serve 发布一个清单（及签名）与安装包；badPayload 为 true 时安装包内容被替换过。
func (f *fixture) serve(t *testing.T, manifest, sig []byte, badPayload bool) *httptest.Server {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch {
		case strings.HasSuffix(r.URL.Path, "latest.json"):
			w.Write(manifest)
		case strings.HasSuffix(r.URL.Path, "latest.json.sig"):
			w.Write(sig)
		case strings.HasSuffix(r.URL.Path, "PasteFerry-test.bin"):
			p := f.payload
			if badPayload {
				p = bytes.Repeat([]byte("Tampered!!"), 5000)
			}
			w.Write(p)
		default:
			http.NotFound(w, r)
		}
	}))
	t.Cleanup(srv.Close)
	return srv
}

func TestCheckerVerifiesAndPrefersNewest(t *testing.T) {
	f := newFixture(t)
	older := f.manifest("2.3.0", Mirror{Source: "a", Base: "https://example.invalid/"})
	newer := f.manifest("2.3.1", Mirror{Source: "b", Base: "https://example.invalid/"})
	a := f.serve(t, older, f.sign(older), false)
	b := f.serve(t, newer, f.sign(newer), false)
	// 被篡改的清单：内容改了，签名还是原来的
	tampered := f.serve(t, bytes.Replace(newer, []byte("2.3.1"), []byte("9.9.9"), 1), f.sign(newer), false)
	c := &Checker{HTTP: NewHTTPClient(), Keys: []ed25519.PublicKey{f.pub}, Settle: 500 * time.Millisecond, Sources: []Source{
		{Name: "a", Manifest: a.URL + "/latest.json"},
		{Name: "b", Manifest: b.URL + "/latest.json"},
		{Name: "x", Manifest: tampered.URL + "/latest.json"},
	}}
	found, err := c.Check(context.Background())
	if err != nil {
		t.Fatal(err)
	}
	if found.Manifest.Latest != "2.3.1" || found.Source != "b" {
		t.Fatalf("got %s from %s", found.Manifest.Latest, found.Source)
	}
	cur, _ := ParseVersion("2.2.0")
	if n := found.Manifest.Newer(cur); len(n) != 1 || n[0].Version != "2.3.1" {
		t.Fatalf("newer releases: %+v", n)
	}
	// 只有被篡改的源时检查失败，而不是采信它
	c.Sources = []Source{{Name: "x", Manifest: tampered.URL + "/latest.json"}}
	if _, err := c.Check(context.Background()); err == nil || !strings.Contains(err.Error(), "签名") {
		t.Fatalf("tampered manifest accepted: %v", err)
	}
}

func TestDownloadFallsBackAndVerifies(t *testing.T) {
	f := newFixture(t)
	bad := f.serve(t, nil, nil, true)
	good := f.serve(t, nil, nil, false)
	var m Manifest
	json.Unmarshal(f.manifest("2.3.1",
		Mirror{Source: "bad", Base: bad.URL + "/"}, Mirror{Source: "good", Base: good.URL + "/"}), &m)
	dir := t.TempDir()
	var last int64
	path, err := Download(context.Background(), NewHTTPClient(), &m, "bad", m.Assets["test"], dir,
		func(done, total int64) { last = done })
	if err != nil {
		t.Fatal(err)
	}
	if got, _ := os.ReadFile(path); !bytes.Equal(got, f.payload) || last != int64(len(f.payload)) {
		t.Fatal("downloaded file differs from the manifest")
	}
	if _, err := os.Stat(path + ".part"); !os.IsNotExist(err) {
		t.Fatal("partial file left behind")
	}
	// 只有内容被替换过的镜像时下载失败，不留下文件
	m.Mirrors = m.Mirrors[:1]
	os.Remove(path)
	if _, err := Download(context.Background(), NewHTTPClient(), &m, "bad", m.Assets["test"], dir, nil); err == nil {
		t.Fatal("tampered package accepted")
	}
	if entries, _ := os.ReadDir(dir); len(entries) != 0 {
		t.Fatalf("files left after a failed download: %v", entries)
	}
}

func TestDownloadReusesVerifiedFile(t *testing.T) {
	f := newFixture(t)
	var hits atomic.Int32
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		hits.Add(1)
		w.Write(f.payload)
	}))
	defer srv.Close()
	var m Manifest
	json.Unmarshal(f.manifest("2.3.1", Mirror{Source: "s", Base: srv.URL + "/"}), &m)
	dir := t.TempDir()
	for i := 0; i < 2; i++ {
		if _, err := Download(context.Background(), NewHTTPClient(), &m, "s", m.Assets["test"], dir, nil); err != nil {
			t.Fatal(err)
		}
	}
	if hits.Load() != 1 {
		t.Fatalf("downloaded %d times", hits.Load())
	}
}

func TestSafeJoinRejectsEscapes(t *testing.T) {
	root := t.TempDir()
	for _, bad := range []string{"../x", "a/../../x", "/etc/passwd", `..\x`, `PasteFerry\..\..\x`, ".."} {
		if _, err := safeJoin(root, bad); err == nil {
			t.Errorf("accepted %q", bad)
		}
	}
	got, err := safeJoin(root, `PasteFerry\data\app.so`)
	if err != nil || got != filepath.Join(root, "PasteFerry", "data", "app.so") {
		t.Fatalf("backslash path → %q, %v", got, err)
	}
}

func TestStageFolderFromZipAndTar(t *testing.T) {
	dir := t.TempDir()
	// Windows 便携版的 zip 用反斜杠
	zipPath := filepath.Join(dir, "p.zip")
	var zb bytes.Buffer
	zw := zip.NewWriter(&zb)
	for _, name := range []string{`PasteFerry\PasteFerry.exe`, `PasteFerry\pasteferryd.exe`, `PasteFerry\data\flutter_assets\x`} {
		w, _ := zw.Create(name)
		w.Write([]byte(name))
	}
	zw.Close()
	os.WriteFile(zipPath, zb.Bytes(), 0o600)
	app := filepath.Join(dir, "PasteFerry")
	p := &Plan{App: app, To: "2.3.1", Package: zipPath}
	if err := stageFolder(p, unzip, "PasteFerry.exe", "pasteferryd.exe"); err != nil {
		t.Fatal(err)
	}
	if _, err := os.Stat(filepath.Join(p.Staged, "data", "flutter_assets", "x")); err != nil {
		t.Fatal(err)
	}

	tgz := filepath.Join(dir, "p.tar.gz")
	var tb bytes.Buffer
	gz := gzip.NewWriter(&tb)
	tw := tar.NewWriter(gz)
	for _, h := range []*tar.Header{
		{Name: "PasteFerry/", Typeflag: tar.TypeDir, Mode: 0o755},
		{Name: "PasteFerry/pasteferry", Typeflag: tar.TypeReg, Mode: 0o755, Size: 2},
		{Name: "PasteFerry/pasteferryd", Typeflag: tar.TypeReg, Mode: 0o755, Size: 2},
		{Name: "PasteFerry/lib/libapp.so.1", Typeflag: tar.TypeSymlink, Linkname: "libapp.so"},
	} {
		tw.WriteHeader(h)
		if h.Size > 0 {
			tw.Write([]byte("ok"))
		}
	}
	tw.Close()
	gz.Close()
	os.WriteFile(tgz, tb.Bytes(), 0o600)
	p = &Plan{App: app, To: "2.3.2", Package: tgz}
	if err := stageFolder(p, untar, "pasteferry", "pasteferryd"); err != nil {
		t.Fatal(err)
	}
	st, err := os.Stat(filepath.Join(p.Staged, "pasteferryd"))
	if err != nil {
		t.Fatal(err)
	}
	// Windows 没有可执行位；tar.gz 只在 Linux 上用
	if runtime.GOOS != "windows" && st.Mode().Perm()&0o100 == 0 {
		t.Fatalf("executable bit lost: %v", st.Mode())
	}
	// 缺少必需的文件时不留下解压的东西
	p = &Plan{App: app, To: "2.3.3", Package: tgz}
	if err := stageFolder(p, untar, "pasteferry", "missing"); err == nil {
		t.Fatal("accepted a package without required files")
	}
	if _, err := os.Stat(filepath.Join(dir, ".PasteFerry-update-2.3.3")); !os.IsNotExist(err) {
		t.Fatal("staging folder left behind")
	}
}

func TestSwapDirRestoresOnFailure(t *testing.T) {
	dir := t.TempDir()
	app := filepath.Join(dir, "PasteFerry")
	os.MkdirAll(app, 0o755)
	os.WriteFile(filepath.Join(app, "v"), []byte("old"), 0o600)
	// 新版本不存在：改名失败，旧版本必须原样回到原处
	if err := swapDir(app, filepath.Join(dir, "missing"), filepath.Join(dir, ".old")); err == nil {
		t.Fatal("swap with a missing staged folder succeeded")
	}
	if got, _ := os.ReadFile(filepath.Join(app, "v")); string(got) != "old" {
		t.Fatal("old version was not restored")
	}
	staged := filepath.Join(dir, "new")
	os.MkdirAll(staged, 0o755)
	os.WriteFile(filepath.Join(staged, "v"), []byte("new"), 0o600)
	if err := swapDir(app, staged, filepath.Join(dir, ".old")); err != nil {
		t.Fatal(err)
	}
	if got, _ := os.ReadFile(filepath.Join(app, "v")); string(got) != "new" {
		t.Fatal("new version not in place")
	}
}

func TestServiceNoticeRespectsSettings(t *testing.T) {
	f := newFixture(t)
	raw := f.manifest("2.3.1", Mirror{Source: "s", Base: "https://example.invalid/"})
	srv := f.serve(t, raw, f.sign(raw), false)
	s, err := NewService("2.3.0", t.TempDir(), slog.New(slog.NewTextHandler(io.Discard, nil)))
	if err != nil {
		t.Fatal(err)
	}
	s.Checker = &Checker{HTTP: NewHTTPClient(), Keys: []ed25519.PublicKey{f.pub}, Sources: []Source{{Name: "s", Manifest: srv.URL + "/latest.json"}}}
	auto, skipped := true, ""
	s.AutoCheck = func() bool { return auto }
	s.Skipped = func() string { return skipped }
	changed := 0
	s.Changed = func() { changed++ }
	if _, err := s.Check(context.Background()); err != nil {
		t.Fatal(err)
	}
	if s.Notice() != "2.3.1" || changed != 1 {
		t.Fatalf("notice %q, changed %d", s.Notice(), changed)
	}
	skipped = "2.3.1"
	if s.Notice() != "" {
		t.Fatal("skipped version still noticed")
	}
	skipped, auto = "", false
	if s.Notice() != "" {
		t.Fatal("noticed with automatic checks off")
	}
	s.Current, _ = ParseVersion("2.3.1")
	auto = true
	if s.Notice() != "" {
		t.Fatal("noticed the version already installed")
	}
}

func TestReadResultOnce(t *testing.T) {
	root := t.TempDir()
	os.MkdirAll(filepath.Join(root, "updates"), 0o700)
	raw, _ := json.Marshal(Result{From: "2.3.0", To: "2.3.1", OK: true, At: time.Now().Unix()})
	os.WriteFile(filepath.Join(root, "updates", "result.json"), raw, 0o600)
	if r := ReadResult(root); r == nil || !r.OK || r.To != "2.3.1" {
		t.Fatalf("result: %+v", r)
	}
	if ReadResult(root) != nil {
		t.Fatal("result read twice")
	}
}

func TestPublicKeyIsValid(t *testing.T) {
	if len(PublicKeys()) == 0 {
		t.Fatal("no valid public key compiled in")
	}
}
