"""生成像素主题打包进 App 的字体与图标，写到 ui/assets/fonts/。

    python3 tools/pixel-theme/build_assets.py <fusion-pixel 比例字体目录> <fusion-pixel 等宽字体目录> <pixelarticons 目录>

来源（解压后把目录传进来，不要在这些目录里运行脚本）：

- 缝合像素字体 Fusion Pixel Font 2026.10.25，OFL-1.1：
  https://github.com/TakWolf/fusion-pixel-font/releases
  fusion-pixel-font-12px-proportional-otf 与 fusion-pixel-font-12px-monospaced-otf 两个 zip
- Pixelarticons 2.4.2，MIT：https://www.npmjs.com/package/pixelarticons（npm 包的 package/ 目录）

产出：

- FusionPixel12.otf：简体中文的比例字体。正文都用它，12px 时一个字形像素正好是一个逻辑像素。
- FusionPixel12Mono.otf：等宽字体，只留拉丁字母、数字和常用符号（配对码、指纹、地址），几 KB。

两个字体的字重都标成 700（字形不变）：点阵字体没有粗体，界面里要粗体的地方
Flutter 会把笔画描粗一圈，点阵就糊了。标成粗体后，任何字重都直接用原字形。
- PixelIcons.ttf：界面用到的图标。原字体 16px 时一格是 1.33 个逻辑像素，画出来发虚；
  这里把字形缩到 0.75 倍，并让格子落在整数位置上，16px 时一格正好一个逻辑像素。
- 两份许可证。

需要 fonttools：pip install fonttools
"""

import os
import re
import shutil
import sys

from fontTools import subset
from fontTools.pens.transformPen import TransformPen
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.ttLib import TTFont

# AppIcons 里用到的 Pixelarticons 图标，名字见 pixelart-icons-font.css
ICONS = [
    "archive", "arrow-down", "arrow-down-circle", "arrow-up", "article", "cellular-signal-0", "check",
    "checkbox-on", "chevron-down", "chevron-left", "chevron-right", "chevrons-vertical", "circle-info",
    "circle-question", "clipboard-note", "clock", "close", "copy", "corner-down-left", "download", "file",
    "files", "filter", "folder", "gear", "globe", "image", "keyboard", "laptop", "link", "monitor",
    "more-horizontal", "pencil", "plus", "qr-code", "refresh", "reload", "search", "send", "share", "shield",
    "smartphone", "star", "target", "text-align-left", "trash", "user", "user-plus", "users",
    "warning-diamond", "x-solid", "cloud", "brush", "apple", "android", "app-windows", "linux",
]

# 等宽字体保留的字符
MONO_TEXT = "".join(chr(c) for c in range(0x20, 0x7F)) + "".join(chr(c) for c in range(0xA0, 0x100)) + "·•…—–‘’“”←↑→↓"


def build_icons(src_dir, out_dir):
    css = open(os.path.join(src_dir, "fonts", "pixelart-icons-font.css"), encoding="utf-8").read()
    codepoints = {
        name: int(cp, 16)
        for name, cp in re.findall(r'\.pixelart-icons-font-([a-z0-9-]+)::before \{ content: "\\([0-9a-f]+)"; \}', css)
    }
    missing = [n for n in ICONS if n not in codepoints]
    if missing:
        sys.exit(f"Pixelarticons 里没有这些图标：{missing}")

    font = TTFont(os.path.join(src_dir, "fonts", "pixelart-icons-font.ttf"))
    em = font["head"].unitsPerEm  # 1000：24 格的 SVG 网格，一个像素是 2 格
    cell = em / 12
    scale = 0.75
    # 原图标从 cell 处开始；缩放后让它从 3/16 em 开始，16px 时落在第 3 个逻辑像素上
    shift = 3 * em / 16 - cell * scale
    glyphs = font.getGlyphSet()
    cmap = font.getBestCmap()
    for cp in (codepoints[n] for n in ICONS):
        name = cmap[cp]
        pen = TTGlyphPen(glyphs)
        glyphs[name].draw(TransformPen(pen, (scale, 0, 0, scale, shift, shift)))
        font["glyf"][name] = pen.glyph()

    options = subset.Options()
    options.notdef_outline = True
    options.recalc_bounds = True
    sub = subset.Subsetter(options)
    sub.populate(unicodes=[codepoints[n] for n in ICONS])
    sub.subset(font)
    font.save(os.path.join(out_dir, "PixelIcons.ttf"))
    shutil.copy(os.path.join(src_dir, "LICENSE"), os.path.join(out_dir, "PixelIcons-LICENSE.txt"))
    for n in sorted(ICONS):
        print(f"  {n}: 0x{codepoints[n]:x}")


def mark_bold(path):
    font = TTFont(path)
    font["OS/2"].usWeightClass = 700
    font.save(path)


def main():
    if len(sys.argv) != 4:
        sys.exit(__doc__)
    prop, mono, icons = sys.argv[1:]
    out = os.path.join(os.path.dirname(__file__), "..", "..", "ui", "assets", "fonts")
    os.makedirs(out, exist_ok=True)

    shutil.copy(os.path.join(prop, "fusion-pixel-12px-proportional-zh_hans.otf"), os.path.join(out, "FusionPixel12.otf"))
    mark_bold(os.path.join(out, "FusionPixel12.otf"))
    shutil.copy(os.path.join(prop, "OFL.txt"), os.path.join(out, "FusionPixel-OFL.txt"))

    options = subset.Options()
    options.layout_features = ["*"]
    font = TTFont(os.path.join(mono, "fusion-pixel-12px-monospaced-latin.otf"))
    sub = subset.Subsetter(options)
    sub.populate(text=MONO_TEXT)
    sub.subset(font)
    font.save(os.path.join(out, "FusionPixel12Mono.otf"))
    mark_bold(os.path.join(out, "FusionPixel12Mono.otf"))

    build_icons(icons, out)


if __name__ == "__main__":
    main()
