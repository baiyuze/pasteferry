# PasteFerry 2.1 portrait launch film

A 25.5-second, 1080×1920, 30 fps video with Chinese narration, burned-in captions,
a matching SRT, a portrait cover and original synthesized music. No external
media or model service is used. The computer screens are labeled motion demos,
not recordings of a user's clipboard. All information uses the public website;
no administrative hostname, test identity or credential is included.

The opening immediately shows a cross-network copy/paste result. The next cuts
show the official-service switch, direct-first routing, the current relay
allowance and the official download address. Text stays above the bottom
platform overlay area and clear of the right action rail. Do not claim unlimited
relay or that private production storage is proven by the public source.

Requirements: macOS with the Tingting voice (`say`), Chrome, Node.js,
`puppeteer-core`, Python 3 with NumPy, and FFmpeg with libx264. Set `NODE_PATH` to
the puppeteer installation, and optionally `NODE_BIN`, `PYTHON_BIN`, `CHROME`.

```bash
./tools/shorts/build.sh /absolute/output/path
```

Each film lives in its own directory with `story.json` and `video.html`; pass it
as the second argument (the 2.1 film in this directory is the default). The 2.10
themes film is in `themes-2.10/`; its `prepare.sh` renders the app screenshots it
needs with `ui/tool/screenshots`, so it also needs Flutter and fonttools.

```bash
./tools/shorts/build.sh dist/shorts-2.10 tools/shorts/themes-2.10
```

The narration voice is set by `tts` in `story.json`. Without it, the local macOS
Tingting voice is used. The themes film uses `{"engine": "edge"}`: a Microsoft
neural voice (`zh-CN-YunxiNeural`, the young male voice common on Douyin;
`zh-CN-YunjianNeural` is a calm mature male voice) through the
`edge-tts` Python package, which sends the narration text to Microsoft's online
service. Override the voice for one render with `TTS_VOICE`. Check the voice's
terms before commercial use.

Use `node tools/shorts/render.js /output/path stills` to inspect the key frames
before rendering. `story.json` owns the narration, timings and captions. Visuals
in `video.html` use the same deterministic timeline. Refresh both when editing.
Build outputs stay outside the 15 release attachments, and outside `dist/`,
which `scripts/build.sh` clears.
