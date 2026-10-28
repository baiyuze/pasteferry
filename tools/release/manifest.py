"""生成并签名更新清单 updates/latest.json 与 updates/latest.json.sig。

    python3 tools/release/manifest.py 2.3.0

在 GitHub Release 与 Gitee 发行版的附件都传好之后运行，再单独提交推送：清单一出现，
已安装的 App 就会提示更新，这时安装包必须已经能下载。

检查五种语言的更新日志都齐全、release/ 里正好是发布的 14 个文件且与 SHA256SUMS 一致、
版本号与 tools/site/build.py 一致。签名用 client-core/cmd/updatesign，私钥在 macOS 钥匙串里。

端到端测试时把安装包放在本地的测试服务器上，清单写到别处，不碰 updates/：

    python3 tools/release/manifest.py 2.3.1 --release-dir /tmp/next --test-notes \\
        --mirror test=http://10.211.55.2:8765/pkg/ --out /tmp/next-site/updates

设计见 design/auto-update.md。
"""

import argparse
import hashlib
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(Path(__file__).parent))
from notes import MAX_RELEASES, RELEASES  # noqa: E402

# 清单里安装包的键 → 文件名。键与客户端 internal/update 里 Target.Asset 一致
ASSETS = {
    "mac-arm64": "PasteFerry-mac-apple-silicon.dmg",
    "mac-x64": "PasteFerry-mac-intel.dmg",
    "mac-universal": "PasteFerry.dmg",
    "windows-setup": "PasteFerry-Setup.exe",
    "windows-portable": "PasteFerry-windows-x64.zip",
    "linux-amd64-deb": "PasteFerry-linux-amd64.deb",
    "linux-arm64-deb": "PasteFerry-linux-arm64.deb",
    "linux-amd64-tar": "PasteFerry-linux-amd64.tar.gz",
    "linux-arm64-tar": "PasteFerry-linux-arm64.tar.gz",
}
# 与 Release 一起发布的全部文件：客户端用不到服务器包，但它们在 SHA256SUMS 里。
# 2.7.0 起加了一个 Android APK（15 个），它不是自动更新的安装包，所以不在上面的 ASSETS 里。
RELEASE_FILES = 15

# notes.py 每一条的语言顺序 → 清单里的语言代码
LANGS = ["en", "zh-Hans", "ja", "zh-Hant-TW", "zh-Hant-HK"]

TEST_NOTES = ("Test build for checking automatic updates.", "用于验证自动更新的测试版本。",
              "自動アップデート検証用のテストビルドです。", "用於驗證自動更新的測試版本。", "用於驗證自動更新的測試版本。")


def die(msg: str) -> None:
    print("✗", msg, file=sys.stderr)
    sys.exit(1)


def localized(items: list[tuple]) -> dict[str, list[str]]:
    out = {lang: [] for lang in LANGS}
    for item in items:
        if len(item) != len(LANGS) or any(not s.strip() for s in item):
            die(f"更新日志缺少某种语言：{item[0][:60]!r}")
        for lang, text in zip(LANGS, item):
            out[lang].append(text)
    return out


def release_entry(r: dict) -> dict:
    changes, fixes = localized(r["changes"]), localized(r["fixes"])
    if not r["changes"] and not r["fixes"]:
        die(f"{r['version']} 没有更新日志")
    notes = {}
    for lang in LANGS:
        n = {}
        if changes[lang]:
            n["changes"] = changes[lang]
        if fixes[lang]:
            n["fixes"] = fixes[lang]
        notes[lang] = n
    return {"version": r["version"], "date": r["date"], "notes": notes}


def version_key(v: str) -> tuple:
    core, _, pre = v.partition("-")
    return tuple(int(x) for x in core.split(".")) + ((1, "") if not pre else (0, pre))


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("version")
    ap.add_argument("--release-dir", default=str(ROOT / "release"))
    ap.add_argument("--out", default=str(ROOT / "updates"))
    ap.add_argument("--mirror", action="append", default=[], help="source=base，可重复；默认是 Gitee 与 GitHub")
    ap.add_argument("--test-notes", action="store_true", help="用一条测试说明代替 notes.py（端到端测试）")
    args = ap.parse_args()
    version = args.version
    if not re.fullmatch(r"\d+\.\d+\.\d+(-[0-9A-Za-z.]+)?", version):
        die(f"版本号 {version} 不是 X.Y.Z")

    test = args.test_notes or args.mirror
    if not test:
        site = (ROOT / "tools/site/build.py").read_text(encoding="utf-8")
        m = re.search(r'^VERSION = "([^"]+)"', site, re.M)
        if not m or m.group(1) != version:
            die(f"tools/site/build.py 的 VERSION 是 {m and m.group(1)}，不是 {version}")

    # 安装包：与 SHA256SUMS 逐个核对
    rel = Path(args.release_dir)
    files = sorted(p.name for p in rel.iterdir() if p.is_file())
    if len(files) != RELEASE_FILES:
        die(f"{rel} 里应当正好有 {RELEASE_FILES} 个文件，现在是 {len(files)} 个")
    sums = {}
    for line in (rel / "SHA256SUMS").read_text().splitlines():
        digest, _, name = line.partition("  ")
        sums[name.strip()] = digest.strip()
    assets = {}
    for key, name in ASSETS.items():
        path = rel / name
        if not path.is_file():
            die(f"缺少 {name}")
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        if sums.get(name) != digest:
            die(f"{name} 与 SHA256SUMS 不一致")
        assets[key] = {"name": name, "size": path.stat().st_size, "sha256": digest}

    # 更新日志：最新版本必须有，最多保留 MAX_RELEASES 个
    if args.test_notes:
        entries = [release_entry({"version": version, "date": "", "changes": [TEST_NOTES], "fixes": []})]
    else:
        entries = [release_entry(r) for r in RELEASES if version_key(r["version"]) <= version_key(version)]
        if not entries or entries[0]["version"] != version:
            die(f"tools/release/notes.py 里没有 {version} 的更新日志（要写在最前面）")
    entries = entries[:MAX_RELEASES]

    if args.mirror:
        mirrors = []
        for m in args.mirror:
            source, _, base = m.partition("=")
            if not source or not base.endswith("/"):
                die(f"--mirror 应当是 source=base/，现在是 {m}")
            mirrors.append({"source": source, "base": base})
    else:
        mirrors = [
            {"source": "gitee", "base": f"https://gitee.com/baiyuze/pasteferry/releases/download/v{version}/"},
            {"source": "github", "base": f"https://github.com/baiyuze/pasteferry/releases/download/v{version}/"},
        ]

    manifest = {"schema": 1, "latest": version, "date": entries[0]["date"], "mirrors": mirrors,
                "assets": assets, "releases": entries}
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    path = out / "latest.json"
    path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    # 签名，并用 App 内置的公钥回验
    core = ROOT / "client-core"
    for flag in ("-sign", "-verify"):
        r = subprocess.run(["go", "run", "./cmd/updatesign", flag, str(path.resolve())], cwd=core,
                           capture_output=True, text=True)
        if r.returncode != 0:
            die(f"updatesign {flag} 失败：{r.stderr.strip() or r.stdout.strip()}")
    print(f"✓ {path}（{len(entries)} 个版本的更新日志，{len(assets)} 个安装包）与 latest.json.sig")


if __name__ == "__main__":
    main()
