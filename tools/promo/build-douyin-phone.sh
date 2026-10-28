#!/usr/bin/env bash
# 生成抖音竖屏短片（跨平台的手机同步 · 安卓与网页版（2.7））：1080×1920、60 fps，逐帧渲染画面、合成配乐与音效、编码成 MP4，另出竖屏封面。
#
#   ./tools/promo/build-douyin-phone.sh
#
# 产物在 tools/promo/out/：
#   PasteFerry-douyin-phone.mp4            带配乐，直接发
#   PasteFerry-douyin-phone-sfx-only.mp4   只有音效，在抖音里另选音乐时用
#   PasteFerry-douyin-phone-cover.png      竖屏封面
# 配乐与音效沿用 audio-douyin.py（按 cues.json 里的 build、drop、section、finale 作曲），渲染沿用 render.js。
# 需要 Google Chrome、ffmpeg（含 libx264）、Node 与 python3；第一次运行会在 /tmp/cs-promo 里装 puppeteer-core、numpy、scipy。
set -euo pipefail
cd "$(dirname "$0")"

WORK=${WORK:-/tmp/cs-promo}
FRAMES=$WORK/frames-douyin-phone
OUT=out
NAME=PasteFerry-douyin-phone
FPS=${FPS:-60}
export PAGE=video-douyin-phone.html VW=1080 VH=1920
mkdir -p "$WORK" "$OUT"

if [ ! -d "$WORK/node_modules/puppeteer-core" ]; then
  echo "▶ 安装 puppeteer-core"
  (cd "$WORK" && npm init -y >/dev/null && npm install puppeteer-core@23 --no-audit --no-fund >/dev/null)
fi
if [ ! -x "$WORK/venv/bin/python" ]; then
  echo "▶ 安装 numpy、scipy"
  python3 -m venv "$WORK/venv"
  "$WORK/venv/bin/pip" install -q numpy scipy
fi
export NODE_PATH="$WORK/node_modules"

# SKIP_FRAMES=1 时沿用上次渲染的帧，只重做声音与编码
if [ -z "${SKIP_FRAMES:-}" ]; then
  echo "▶ 渲染画面（${FPS} fps）"
  rm -rf "$FRAMES"
  node render.js frames "$FRAMES" "$FPS" "${WORKERS:-8}"
fi

echo "▶ 合成配乐与音效"
"$WORK/venv/bin/python" audio-douyin.py "$FRAMES/cues.json" "$WORK/douyin-phone-mix.wav" "$WORK/douyin-phone-sfx.wav"

# 响度：带配乐的统一到 -14 LUFS（短视频平台常见的响度），只有音效的 -16 LUFS，给另配的音乐留空间
norm() {
  local stats
  stats=$(ffmpeg -hide_banner -nostats -i "$1" -af "loudnorm=I=$2:TP=-1.5:LRA=11:print_format=json" -f null - 2>&1 | sed -n '/^{/,/^}/p')
  get() { python3 -c "import json,sys; print(json.loads(sys.argv[1])['$1'])" "$stats"; }
  echo "loudnorm=I=$2:TP=-1.5:LRA=11:linear=true:measured_I=$(get input_i):measured_TP=$(get input_tp):measured_LRA=$(get input_lra):measured_thresh=$(get input_thresh):offset=$(get target_offset)"
}

encode() {
  ffmpeg -hide_banner -loglevel warning -stats -y \
    -framerate "$FPS" -i "$FRAMES/f%05d.png" -i "$1" \
    -vf "scale=out_color_matrix=bt709:out_range=tv,format=yuv420p" \
    -c:v libx264 -profile:v high -preset slow -crf 12 -tune animation -g "$FPS" -x264-params colorprim=bt709:transfer=bt709:colormatrix=bt709 \
    -colorspace bt709 -color_primaries bt709 -color_trc bt709 -color_range tv \
    -af "$2,aresample=48000" -c:a aac -b:a 320k \
    -movflags +faststart -shortest "$3"
}

echo "▶ 编码（带配乐）"
encode "$WORK/douyin-phone-mix.wav" "$(norm "$WORK/douyin-phone-mix.wav" -14)" "$OUT/$NAME.mp4"
echo "▶ 编码（只有音效）"
encode "$WORK/douyin-phone-sfx.wav" "$(norm "$WORK/douyin-phone-sfx.wav" -16)" "$OUT/$NAME-sfx-only.mp4"

echo "▶ 封面"
node render.js cover "$OUT/$NAME-cover.png" 1920

ls -lh "$OUT/$NAME"*
