#!/usr/bin/env bash
# 官网浅色外观用的截图：只拍过深色（名字以 -dark 结尾）的那些，补拍一张浅色的，名字去掉 -dark。
# 官网生成时自动把同名的深色、浅色两张配对，按访问者的外观显示其中一张。
# 只写新补的浅色截图，已有的截图不动。各语言输出到 docs/assets/screenshots/（及 zh-tw/、zh-hk/、en/、ja/）。
#
#   ./tools/screenshots/render-light.sh
#
# 需要的环境与 render.sh 相同。
set -euo pipefail
cd "$(dirname "$0")/../.."

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
python3 tools/screenshots/prepare_fonts.py "$TMP/fonts" >/dev/null
BG=$PWD/tools/screenshots/background

# 默认主题下只有深色版、官网又用到的截图（测试名，浅色补拍时去掉 -dark）
PLAIN="incoming-dark card-picker-dark favorites-dark hover-dark settings-lan-dark settings-cloud-dark
pairing-join-dark pairing-join-ts-dark official-settings-dark official-usage-dark"

for lang in zh zh-tw zh-hk en ja; do
  out=docs/assets/screenshots
  [ "$lang" = zh ] || out="$out/$lang"
  mkdir -p "$out"

  # 环境变量, 测试名（空格分开）, 输出前缀；拍完加窗口外框，按前缀加名字（去掉 -dark）存进 $out
  shoot() {
    local env=$1 names=$2 prefix=$3
    local pattern
    pattern="^($(echo $names | tr ' ' '|'))\$"
    rm -rf "$TMP/raw" "$TMP/framed"
    (cd ui && env $env SCREENSHOT_OUT="$TMP/raw" SCREENSHOT_FONTS="$TMP/fonts" SCREENSHOT_LANG="$lang" \
      flutter test tool/screenshots/screenshots_test.dart --name "$pattern" 2>&1 | tail -1)
    swift tools/screenshots/frame.swift "$TMP/raw" "$TMP/framed" >/dev/null
    for n in $names; do
      local light=${n%-dark}
      cp "$TMP/framed/$light.png" "$out/$prefix$light.png"
    done
  }

  echo "▶ 浅色截图（${lang}）"
  shoot "SCREENSHOT_LIGHT_PASS=1" "$PLAIN" ""
  # 像素主题的隔空传送：测试里本来就有浅色的 send
  shoot "SCREENSHOT_THEME=pixel" "send" "pixel-"
  # 背景图主题（见 render-background.sh）：浅色的 history、appearance-background 本来就有
  shoot "SCREENSHOT_THEME_FILE=$BG/theme.json SCREENSHOT_BACKGROUND=$BG" "history appearance-background" "bg-"
  shoot "SCREENSHOT_THEME_FILE=$BG/scene-theme.json SCREENSHOT_BACKGROUND=$BG" "history" "bg-scene-"
done
