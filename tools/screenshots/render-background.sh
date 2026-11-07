#!/usr/bin/env bash
# 官网主题教程里「背景图」「风景」两节的截图：像素主题加一张图（background/ 里程序画的落日山景），
# 铺满整个窗口或只换掉风景。各语言输出到 docs/assets/screenshots/（及 zh-tw/、zh-hk/、en/、ja/）
# 下的 bg-*.png。
#
#   ./tools/screenshots/render-background.sh
#
# 需要的环境与 render.sh 相同。
set -euo pipefail
cd "$(dirname "$0")/../.."

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
python3 tools/screenshots/prepare_fonts.py "$TMP/fonts" >/dev/null
BG=$PWD/tools/screenshots/background

for lang in zh zh-tw zh-hk en ja; do
  out=docs/assets/screenshots
  [ "$lang" = zh ] || out="$out/$lang"
  echo "▶ 背景图截图（${lang}）"
  rm -rf "$TMP/raw" "$TMP/framed"
  # theme.json：整窗背景图；scene-theme.json：只把风景（页眉与侧边栏底部）换成这张图
  shoot() { # 主题文件, 截图名, 输出前缀
    rm -rf "$TMP/raw" "$TMP/framed"
    (cd ui && SCREENSHOT_THEME_FILE="$BG/$1" SCREENSHOT_BACKGROUND="$BG" SCREENSHOT_OUT="$TMP/raw" \
      SCREENSHOT_FONTS="$TMP/fonts" SCREENSHOT_LANG="$lang" \
      flutter test tool/screenshots/screenshots_test.dart --plain-name "$2" 2>&1 | tail -1)
    swift tools/screenshots/frame.swift "$TMP/raw" "$TMP/framed" >/dev/null
    mkdir -p "$out"
    cp "$TMP/framed/$2.png" "$out/$3$2.png"
  }
  shoot theme.json history-dark bg-
  shoot theme.json appearance-background-dark bg-
  shoot scene-theme.json history-dark bg-scene-
done
