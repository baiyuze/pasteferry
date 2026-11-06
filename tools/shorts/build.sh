#!/usr/bin/env bash
# Reproducible 1080x1920, 30 fps launch film. All output stays outside release/.
#
#   ./tools/shorts/build.sh [output-dir] [film-dir]
#
# film-dir defaults to tools/shorts (the 2.1 film). A film directory holds story.json and
# video.html; if it also has prepare.sh, that runs first and writes the film's images
# into <output-dir>/assets.
set -euo pipefail
cd "$(dirname "$0")/../.."
SHORTS_OUT=${1:-dist/shorts-2.1}
export FILM=$(cd "${2:-tools/shorts}" && pwd)
NODE_BIN=${NODE_BIN:-node}
PYTHON_BIN=${PYTHON_BIN:-python3}
mkdir -p "$SHORTS_OUT"
if [ -x "$FILM/prepare.sh" ]; then
  "$FILM/prepare.sh" "$SHORTS_OUT/assets"
  export ASSETS="$SHORTS_OUT/assets"
fi
NAME=$("$PYTHON_BIN" -c 'import json,sys;print(json.load(open(sys.argv[1])).get("name","PasteFerry-2.1-douyin"))' "$FILM/story.json")
DURATION=$("$PYTHON_BIN" -c 'import json,sys;print(json.load(open(sys.argv[1]))["duration"])' "$FILM/story.json")
"$NODE_BIN" tools/shorts/render.js "$SHORTS_OUT" stills
"$PYTHON_BIN" tools/shorts/audio.py "$SHORTS_OUT"
"$NODE_BIN" tools/shorts/render.js "$SHORTS_OUT/frames" frames
ffmpeg -y -hide_banner -loglevel warning -framerate 30 -i "$SHORTS_OUT/frames/frame-%05d.jpg" -i "$SHORTS_OUT/mix.wav" \
  -vf 'scale=out_color_matrix=bt709:out_range=tv,format=yuv420p' \
  -c:v libx264 -preset medium -crf 18 -g 60 -colorspace bt709 -color_primaries bt709 -color_trc bt709 \
  -af 'loudnorm=I=-16:TP=-1.5:LRA=7' -c:a aac -b:a 192k -ar 48000 -t "$DURATION" -movflags +faststart \
  "$SHORTS_OUT/$NAME-1080x1920.mp4"
