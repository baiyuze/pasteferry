#!/usr/bin/env bash
# 宣传片要用的界面截图：默认主题、像素主题（深浅色）、AI 做的「落日像素」自定义主题。
# 用 ui/tool/screenshots 渲染（演示数据，不连接后台服务），写到 $1。需要 macOS、Flutter、fonttools。
set -euo pipefail
cd "$(dirname "$0")/../../.."
OUT=$(mkdir -p "$1" && cd "$1" && pwd)
FONTS=$(mktemp -d)
trap 'rm -rf "$FONTS"' EXIT
python3 tools/screenshots/prepare_fonts.py "$FONTS" >/dev/null

shoot() { # 主题参数, 输出前缀, 要留的截图...
  local env=$1 prefix=$2; shift 2
  local shots="$FONTS/shots-$prefix"
  (cd ui && env $env SCREENSHOT_OUT="$shots" SCREENSHOT_FONTS="$FONTS" SCREENSHOT_LANG=zh flutter test tool/screenshots/screenshots_test.dart >/dev/null)
  for n in "$@"; do cp "$shots/$n.png" "$OUT/$prefix$n.png"; done
}
shoot "SCREENSHOT_THEME=default" default- history
shoot "SCREENSHOT_THEME=pixel" pixel- history history-dark send-dark appearance-dark
shoot "SCREENSHOT_THEME_FILE=$PWD/tools/shorts/themes-2.10/sunset-pixel.json" sunset- history-dark
echo "截图已写到 $OUT"
