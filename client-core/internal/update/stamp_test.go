package update

import (
	"context"
	"crypto/ed25519"
	"crypto/rand"
	"encoding/base64"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"testing"
	"time"
)

func newStamp(t *testing.T, installed time.Time) (*Stamp, *time.Time) {
	t.Helper()
	dir := t.TempDir()
	id := filepath.Join(dir, "identity.json")
	if err := os.WriteFile(id, []byte("{}"), 0o600); err != nil {
		t.Fatal(err)
	}
	if err := os.Chtimes(id, installed, installed); err != nil {
		t.Fatal(err)
	}
	now := installed
	return &Stamp{Path: filepath.Join(dir, "update-state.json"), Identity: id, Version: "2.6.1",
		Target: Target{Kind: KindMacApp}, Lang: func() string { return "zh-Hans" }, Now: func() time.Time { return now }}, &now
}

func check(t *testing.T, s *Stamp, ok bool) (string, string) {
	t.Helper()
	q, commit := s.Query()
	commit(ok)
	return q.Get("f"), q.Get("a")
}

func TestStampNewInstallAndDays(t *testing.T) {
	day := func(s string) time.Time {
		v, _ := time.ParseInLocation("2006-01-02 15:04", s, time.Local)
		return v
	}
	s, now := newStamp(t, day("2026-10-28 09:00")) // a Wednesday
	if f, a := check(t, s, true); f != "ndwm" || a != "0" {
		t.Fatalf("first check %q %q", f, a)
	}
	q, commit := s.Query()
	commit(true)
	if q.Get("f") != "" || q.Get("v") != "2.6.1" || q.Get("pkg") != "dmg" || q.Get("lang") != "zh-Hans" || q.Get("os") == "" || q.Get("arch") == "" {
		t.Fatalf("same day %v", q)
	}
	*now = day("2026-10-29 08:00") // same week
	if f, a := check(t, s, true); f != "d" || a != "1" {
		t.Fatalf("next day %q %q", f, a)
	}
	*now = day("2026-11-02 08:00") // Monday, new week and month
	if f, _ := check(t, s, true); f != "dwm" {
		t.Fatalf("new week and month %q", f)
	}
	*now = day("2026-11-09 08:00")
	if f, _ := check(t, s, true); f != "dw" {
		t.Fatalf("new week %q", f)
	}
	// Clock turned back: not a new day.
	*now = day("2026-11-05 08:00")
	if f, _ := check(t, s, true); f != "" {
		t.Fatalf("clock back %q", f)
	}
	// A failed request is not remembered.
	*now = day("2026-11-10 08:00")
	if f, _ := check(t, s, false); f != "d" {
		t.Fatalf("failed %q", f)
	}
	if f, _ := check(t, s, true); f != "d" {
		t.Fatalf("retry after failure %q", f)
	}
	*now = day("2027-03-01 08:00")
	if _, a := check(t, s, true); a != "4" {
		t.Fatalf("age bucket %q", a)
	}
}

func TestStampUpgradeIsNotAnInstall(t *testing.T) {
	installed := time.Now().AddDate(0, 0, -40)
	s, now := newStamp(t, installed)
	*now = time.Now()
	if f, a := check(t, s, true); f != "dwm" || a != "3" {
		t.Fatalf("upgrade %q %q", f, a)
	}
	// The state survives a restart.
	s2 := &Stamp{Path: s.Path, Identity: s.Identity, Version: "2.6.1", Now: s.Now}
	if f, _ := check(t, s2, true); f != "" {
		t.Fatalf("after restart %q", f)
	}
}

func TestStampConcurrentChecksCountOnce(t *testing.T) {
	s, _ := newStamp(t, time.Now().AddDate(0, 0, -3))
	var mu sync.Mutex
	daily := 0
	var wg sync.WaitGroup
	for i := 0; i < 8; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			q, commit := s.Query()
			if strings.Contains(q.Get("f"), "d") {
				mu.Lock()
				daily++
				mu.Unlock()
			}
			commit(true)
		}()
	}
	wg.Wait()
	if daily != 1 {
		t.Fatalf("counted %d times", daily)
	}
}

func TestOnlyParamSourceCarriesParams(t *testing.T) {
	pub, priv, _ := ed25519.GenerateKey(rand.Reader)
	body := `{"latest":"9.9.9"}`
	sig := base64.StdEncoding.EncodeToString(ed25519.Sign(priv, []byte(body)))
	var mu sync.Mutex
	var seen []string
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		mu.Lock()
		seen = append(seen, r.URL.String())
		mu.Unlock()
		if strings.HasSuffix(r.URL.Path, ".sig") {
			_, _ = w.Write([]byte(sig))
			return
		}
		_, _ = w.Write([]byte(body))
	}))
	defer srv.Close()
	s, _ := newStamp(t, time.Now())
	c := &Checker{HTTP: srv.Client(), Keys: []ed25519.PublicKey{pub}, Stamp: s, Sources: []Source{
		{Name: "pasteferry", Manifest: srv.URL + "/a/latest.json", Params: true},
		{Name: "github", Manifest: srv.URL + "/b/latest.json"},
	}}
	for _, src := range c.Sources {
		_, _ = c.fetch(context.Background(), src)
	}
	want := map[string]bool{}
	for _, u := range seen {
		want[u] = true
		if strings.Contains(u, "?") && !strings.HasPrefix(u, "/a/latest.json?") {
			t.Fatalf("params on %s", u)
		}
	}
	if !want["/a/latest.json.sig"] || !want["/b/latest.json"] || !want["/b/latest.json.sig"] {
		t.Fatalf("requests %v", seen)
	}
	found := false
	for u := range want {
		if strings.HasPrefix(u, "/a/latest.json?") && strings.Contains(u, "v=2.6.1") && strings.Contains(u, "f=ndwm") {
			found = true
		}
	}
	if !found {
		t.Fatalf("no parameters on the first source: %v", seen)
	}
}

func TestLangCodeAndPackage(t *testing.T) {
	for in, want := range map[string]string{"zh-Hans": "zh-Hans", "zh": "zh-Hans", "zh-Hant-TW": "zh-Hant-TW", "zh-Hant-HK": "zh-Hant-HK", "ja": "ja", "en": "en", "fr": "other"} {
		if got := langCode(in); got != want {
			t.Errorf("%s → %s", in, got)
		}
	}
	if packageKind(Target{Kind: KindMacApp, Blocker: BlockerDev}) != "dev" || packageKind(Target{Kind: KindLinuxTar}) != "tar" {
		t.Fatal("package kind")
	}
}
