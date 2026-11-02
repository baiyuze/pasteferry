#!/usr/bin/env bash
#
# 更新 Formula/pasteferry-cli.rb，让 `brew upgrade pasteferry-cli` 能拿到新版本。
#
# Homebrew 的公式指向固定的源码 tarball（url + sha256）。上游发新版后，
# 重新跑这个脚本，它会下载新提交/新 tag 的源码、算出 sha256，并把公式里
# 的 version / url / sha256 三处一起改好，最后 `brew style` 自检。
#
# 用法：
#   tools/brew/update-formula.sh 2.8.4            # 用 tag v2.8.4
#   tools/brew/update-formula.sh 2.8.4 <commit>   # 用指定 commit（PR 合并后的提交）
#   tools/brew/update-formula.sh                  # 不传版本，只校验当前公式
#
# 注意：公式指向普通 GitHub 仓库时，tarball 地址是
#   https://github.com/baiyuze/pasteferry/archive/<ref>.tar.gz
# 用 tag 时 ref 要写 `refs/tags/vX.Y.Z`，否则 GitHub 会 404。
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FORMULA="$ROOT/Formula/pasteferry-cli.rb"

if [[ ! -f "$FORMULA" ]]; then
  echo "找不到公式：$FORMULA" >&2
  exit 1
fi

VERSION="${1:-}"
REF="${2:-}"

if [[ -z "$VERSION" ]]; then
  echo "=== 校验当前公式 ==="
  brew style "$FORMULA"
  exit 0
fi

if [[ -z "$REF" ]]; then
  REF="refs/tags/v$VERSION"
fi

URL="https://github.com/baiyuze/pasteferry/archive/$REF.tar.gz"

TMP="$(mktemp -d)"
trap 'command rm -rf "$TMP"' EXIT

echo "下载 $URL"
curl -fSL -o "$TMP/src.tar.gz" "$URL"
SHA256="$(shasum -a 256 "$TMP/src.tar.gz" | awk '{print $1}')"
echo "sha256: $SHA256"

# 确认新源码里确实带 version 子命令，否则 test do 会失败。
tar xzf "$TMP/src.tar.gz" -C "$TMP"
SRC="$(find "$TMP" -maxdepth 1 -type d -name 'pasteferry-*' | head -1)"
if ! grep -q 'if cmd == "version"' "$SRC/client-core/cmd/pasteferry-cli/main.go" 2>/dev/null; then
  echo "警告：新源码没有 version 子命令，brew 的 test do 会失败。" >&2
fi

# 三处一起替换：version / url / sha256
python3 - "$FORMULA" "$VERSION" "$URL" "$SHA256" <<'PY'
import re, sys
path, version, url, sha = sys.argv[1:5]
text = open(path, encoding="utf-8").read()
text = re.sub(r'(?m)^(\s*)version "[^"]*"', r'\g<1>version "%s"' % version, text, count=1)
text = re.sub(r'(?m)^(\s*)url "[^"]*"', r'\g<1>url "%s"' % url, text, count=1)
text = re.sub(r'(?m)^(\s*)sha256 "[^"]*"', r'\g<1>sha256 "%s"' % sha, text, count=1)
open(path, "w", encoding="utf-8").write(text)
print("已更新公式：version=%s" % version)
PY

brew style "$FORMULA"
echo "提交改动：git add Formula/pasteferry-cli.rb && git commit -m 'brew: bump pasteferry-cli to $VERSION'"
