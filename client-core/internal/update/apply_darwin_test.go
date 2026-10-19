package update

import (
	"fmt"
	"io"
	"log/slog"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

// fakeBundle 建一个带签名的最小 App：可执行文件借用系统的 /usr/bin/true，重新做临时签名。
func fakeBundle(t *testing.T, dir, version, id string) string {
	t.Helper()
	app := filepath.Join(dir, "PasteFerry.app")
	os.MkdirAll(filepath.Join(app, "Contents", "MacOS"), 0o755)
	plist := fmt.Sprintf(`<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>PasteFerry</string>
<key>CFBundleIdentifier</key><string>%s</string>
<key>CFBundleShortVersionString</key><string>%s</string>
<key>CFBundlePackageType</key><string>APPL</string>
</dict></plist>`, id, version)
	os.WriteFile(filepath.Join(app, "Contents", "Info.plist"), []byte(plist), 0o644)
	raw, err := os.ReadFile("/usr/bin/true")
	if err != nil {
		t.Skip(err)
	}
	os.WriteFile(filepath.Join(app, "Contents", "MacOS", "PasteFerry"), raw, 0o755)
	if out, err := exec.Command("codesign", "--force", "-s", "-", app).CombinedOutput(); err != nil {
		t.Skipf("codesign: %v %s", err, out)
	}
	return app
}

func TestMacPrepareAndSwap(t *testing.T) {
	if testing.Short() {
		t.Skip("builds a DMG")
	}
	root := t.TempDir()
	apps := filepath.Join(root, "Applications")
	os.MkdirAll(apps, 0o755)
	current := fakeBundle(t, apps, "2.3.0", "com.pasteferry.test")
	src := filepath.Join(root, "dmg-src")
	os.MkdirAll(src, 0o755)
	fakeBundle(t, src, "2.3.1", "com.pasteferry.test")
	dmg := filepath.Join(root, "new.dmg")
	if out, err := exec.Command("hdiutil", "create", "-quiet", "-srcfolder", src, "-format", "UDZO", dmg).CombinedOutput(); err != nil {
		t.Skipf("hdiutil: %v %s", err, out)
	}
	work := filepath.Join(root, "work")
	os.MkdirAll(work, 0o700)

	// 版本号对不上的 DMG 在界面退出前就被拒绝，也不留下复制的东西
	if _, err := Prepare(Target{Kind: KindMacApp, App: current}, dmg, "2.3.0", "2.3.2", work, 0); err == nil {
		t.Fatal("accepted a DMG with the wrong version")
	}
	if left, _ := filepath.Glob(filepath.Join(apps, ".PasteFerry-*")); len(left) != 0 {
		t.Fatalf("staged copy left after rejection: %v", left)
	}

	p, err := Prepare(Target{Kind: KindMacApp, App: current}, dmg, "2.3.0", "2.3.1", work, 0)
	if err != nil {
		t.Fatal(err)
	}
	if filepath.Dir(p.Staged) != apps {
		t.Fatalf("staged outside the app's folder: %s", p.Staged)
	}
	if err := apply(p, slog.New(slog.NewTextHandler(io.Discard, nil))); err != nil {
		t.Fatal(err)
	}
	if got := plistValue(current, "CFBundleShortVersionString"); got != "2.3.1" {
		t.Fatalf("installed version %q", got)
	}
	if _, err := os.Stat(oldBundle(p)); err != nil {
		t.Fatalf("old bundle should wait for relaunch to be removed: %v", err)
	}
	if out, _ := exec.Command("hdiutil", "info").Output(); strings.Contains(string(out), filepath.Join(work, "mnt")) {
		t.Fatal("DMG still mounted")
	}
}
