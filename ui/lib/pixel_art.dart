import 'dart:math' as math;

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'icons.dart';
import 'theme.dart';

// 像素主题的画面与动效：页眉场景、侧边栏的营地、空状态插画、菜单光标、四格加载、星星迸开、
// 上下跳、纸飞机、扫描线。设计见 design/pixel-theme.md 第 12 节，样稿 design/pixel-theme-art-mockup.html。
//
// 都由程序按规则画，不打包图片：山脊是几条正弦叠加，星星、树按坐标算伪随机数，插画用方块拼。
// 只在像素主题里出现；系统开了「减少动态效果」时只画静止的一帧。

/// 画面里一格是几个逻辑像素
const _u = 2.0;

/// 按坐标算的伪随机数，同一个位置每次都一样，窗口大小变了也不会闪
int _hash(int v) {
  var x = (v ^ 0x5bd1e995) & 0x7fffffff;
  x = ((x ^ (x >> 15)) * 0x2c1b3c6d) & 0x7fffffff;
  x = ((x ^ (x >> 12)) * 0x297a2d39) & 0x7fffffff;
  return x ^ (x >> 15);
}

double _rand(int seed) => (_hash(seed) % 10000) / 10000;

/// 4×4 的 Bayer 抖动矩阵：场景底部按它一格一格渐隐进背景色
const _bayer = [
  [0, 8, 2, 10],
  [12, 4, 14, 6],
  [3, 11, 1, 9],
  [15, 7, 13, 5],
];

void _cell(Canvas c, double x, double y, double w, double h, Color color) =>
    c.drawRect(Rect.fromLTWH(x * _u, y * _u, w * _u, h * _u), Paint()..color = color);

bool _still(BuildContext context) => MediaQuery.maybeDisableAnimationsOf(context) ?? false;

/// 按固定帧率走的计数器：场景里的星星、萤火虫、篝火都用它，[fps] 帧每秒。
/// 减少动态效果时停在第 0 帧。
mixin _Frames<T extends StatefulWidget> on State<T>, SingleTickerProviderStateMixin<T> {
  final frame = ValueNotifier<int>(0);
  Ticker? _ticker;

  int get fps;

  void syncTicker(bool run) {
    if (run && _ticker == null) {
      _ticker = createTicker((d) => frame.value = d.inMilliseconds * fps ~/ 1000)..start();
    } else if (!run && _ticker != null) {
      _ticker!.dispose();
      _ticker = null;
      frame.value = 0;
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    frame.dispose();
    super.dispose();
  }
}

// ───────────────────────────── 页眉场景 ─────────────────────────────

/// 内容区顶部的场景：深色是夜里的远山、松树、月亮、星星和萤火虫，浅色是太阳、方块云与丘陵。
/// 底部渐隐进背景色，标题叠在上面照样清楚。只在像素主题里画。
class PixelScene extends StatefulWidget {
  const PixelScene({super.key, this.height = 180});

  final double height;

  @override
  State<PixelScene> createState() => _PixelSceneState();
}

class _PixelSceneState extends State<PixelScene> with SingleTickerProviderStateMixin, _Frames {
  @override
  int get fps => 2;

  @override
  Widget build(BuildContext context) {
    final shape = context.shape;
    syncTicker(shape.pixel && !_still(context) && TickerMode.valuesOf(context).enabled);
    if (!shape.pixel) return const SizedBox.shrink();
    final night = Theme.of(context).brightness == Brightness.dark;
    final bg = context.palette.background;
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 不动的部分单独一层，只在窗口大小或配色变了时重画
          RepaintBoundary(child: CustomPaint(painter: _SceneStatic(night, bg))),
          CustomPaint(painter: _SceneLive(night, frame)),
        ],
      ),
    );
  }
}

class _ScenePalette {
  const _ScenePalette(this.sky, this.far, this.mid, this.near, this.tree);

  final List<Color> sky;
  final Color far, mid, near, tree;

  static const night = _ScenePalette(
    [Color(0xFF0E1014), Color(0xFF101318), Color(0xFF12161C), Color(0xFF151A21)],
    Color(0xFF1B2131),
    Color(0xFF222A3B),
    Color(0xFF29334A),
    Color(0xFF313D57),
  );
  static const day = _ScenePalette(
    [Color(0xFFEEF3F4), Color(0xFFEAF0F2), Color(0xFFE5EDF0), Color(0xFFE0E9EC)],
    Color(0xFFD3DFDC),
    Color(0xFFC2D3CA),
    Color(0xFFB2C8BB),
    Color(0xFF9BB7A6),
  );
}

class _SceneStatic extends CustomPainter {
  _SceneStatic(this.night, this.background);

  final bool night;
  final Color background;

  @override
  void paint(Canvas canvas, Size size) {
    final w = (size.width / _u).ceil(), h = (size.height / _u).floor();
    if (w <= 0 || h <= 0) return;
    final p = night ? _ScenePalette.night : _ScenePalette.day;
    final skyH = (h * 0.7).floor();
    for (var i = 0; i < 4; i++) {
      _cell(canvas, 0, (skyH * i / 4).floorToDouble(), w.toDouble(), (skyH / 4).ceilToDouble() + 1, p.sky[i]);
    }
    _cell(canvas, 0, skyH.toDouble(), w.toDouble(), (h - skyH).toDouble(), p.sky[3]);

    // 月亮（弯月：一个圆被天色的圆挡掉一角）或太阳
    final mx = (w * 0.82).floorToDouble(), my = (h * 0.28).floorToDouble();
    _disc(canvas, mx, my, 7, night ? const Color(0xFFE9E5D2) : const Color(0xFFF3E3A6));
    if (night) _disc(canvas, mx + 3, my - 2, 6, p.sky[1]);
    if (!night) {
      for (final (fx, fy, cw) in const [(0.12, 0.18, 14.0), (0.42, 0.1, 10.0), (0.62, 0.3, 16.0)]) {
        final cx = (w * fx).floorToDouble(), cy = (h * fy).floorToDouble();
        _cell(canvas, cx, cy + 2, cw, 3, Colors.white);
        _cell(canvas, cx + 3, cy, cw - 6, 2, Colors.white);
        _cell(canvas, cx + 5, cy - 1, 4, 1, Colors.white);
        _cell(canvas, cx + 1, cy + 5, cw - 2, 1, const Color(0xFFE3ECEE));
      }
    }

    _ridge(canvas, w, h, h * 0.6, h * 0.16, 0.016, p.far, 3);
    _ridge(canvas, w, h, h * 0.47, h * 0.11, 0.028, p.mid, 5);
    _ridge(canvas, w, h, h * 0.36, h * 0.06, 0.05, p.near, 9);

    // 松树：近处山脊上稀稀拉拉的三角
    var i = 0, k = 0;
    while (i < w) {
      final r = _rand(k * 31 + 11);
      if (r >= 0.5) {
        final th = 4 + (_hash(k * 7 + 3) % 6);
        final ty = (h - h * 0.34 - _rand(k * 13) * 3).floorToDouble();
        for (var j = 0; j < th; j++) {
          final half = ((th - j) / 2.2).floor();
          _cell(canvas, (i - half).toDouble(), ty - j, half * 2 + 1, 1, p.tree);
        }
        _cell(canvas, i.toDouble(), ty + 1, 1, 2, p.tree);
      }
      i += 3 + (_hash(k * 17 + 5) % 9);
      k++;
    }

    // 底部抖动渐隐
    final fade = (h * 0.18).floor(), start = h - fade;
    final paint = Paint()..color = background;
    for (var y = start; y < h; y++) {
      final t = (y - start) / fade;
      for (var x = 0; x < w; x++) {
        if (_bayer[y % 4][x % 4] / 16 < t) canvas.drawRect(Rect.fromLTWH(x * _u, y * _u, _u, _u), paint);
      }
    }
    // 最后一行之下直接是背景色，不留缝
    canvas.drawRect(Rect.fromLTWH(0, h * _u, size.width, size.height - h * _u), paint);
  }

  void _disc(Canvas c, double cx, double cy, int r, Color color) {
    for (var y = -r; y <= r; y++) {
      for (var x = -r; x <= r; x++) {
        if (x * x + y * y <= r * r + r * 0.8) _cell(c, cx + x, cy + y, 1, 1, color);
      }
    }
  }

  void _ridge(Canvas c, int w, int h, double base, double amp, double freq, Color color, int seed) {
    final ph = [_rand(seed) * 10, _rand(seed + 1) * 10, _rand(seed + 2) * 10];
    for (var x = 0; x < w; x++) {
      final hh = base +
          amp *
              (math.sin(x * freq + ph[0]) * 0.6 +
                  math.sin(x * freq * 2.3 + ph[1]) * 0.3 +
                  math.sin(x * freq * 5.1 + ph[2]) * 0.1);
      _cell(c, x.toDouble(), (h - hh).floorToDouble(), 1, hh.ceilToDouble(), color);
    }
  }

  @override
  bool shouldRepaint(_SceneStatic old) => old.night != night || old.background != background;
}

/// 会动的部分：星星一颗颗地闪，萤火虫一明一灭（深色）
class _SceneLive extends CustomPainter {
  _SceneLive(this.night, this.frame) : super(repaint: frame);

  final bool night;
  final ValueListenable<int> frame;

  @override
  void paint(Canvas canvas, Size size) {
    if (!night) return;
    final w = (size.width / _u).ceil(), h = (size.height / _u).floor();
    final f = frame.value;
    const star = [Color(0xFFC9D1E0), Color(0xFF8C96A8), Color(0xFF3DDC97)];
    final n = (w * h * 0.45 / 260).round();
    for (var i = 0; i < n; i++) {
      if ((f + i) % 7 == 0) continue;
      final sx = (_rand(i * 3 + 1) * w).floorToDouble(), sy = (_rand(i * 3 + 2) * h * 0.45).floorToDouble();
      final k = _rand(i * 3 + 3);
      final c = k < 0.08 ? star[2] : (k < 0.4 ? star[0] : star[1]);
      _cell(canvas, sx, sy, 1, 1, c);
      if (k > 0.97) {
        _cell(canvas, sx - 1, sy, 3, 1, c);
        _cell(canvas, sx, sy - 1, 1, 3, c);
      }
    }
    for (var i = 0; i < 14; i++) {
      if ((f + i) % 3 == 0) continue;
      _cell(canvas, (_rand(i * 5 + 101) * w).floorToDouble(), (h * 0.5 + _rand(i * 5 + 102) * h * 0.2).floorToDouble(), 1, 1,
          const Color(0xFF3DDC97));
    }
  }

  @override
  bool shouldRepaint(_SceneLive old) => old.night != night;
}

// ───────────────────────────── 侧边栏营地 ─────────────────────────────

/// 侧边栏底下的一小块地：深色是草地、帐篷和篝火（火苗会跳），浅色是草地、小房子和花
class PixelCamp extends StatefulWidget {
  const PixelCamp({super.key, this.height = 64});

  final double height;

  @override
  State<PixelCamp> createState() => _PixelCampState();
}

class _PixelCampState extends State<PixelCamp> with SingleTickerProviderStateMixin, _Frames {
  @override
  int get fps => 4;

  @override
  Widget build(BuildContext context) {
    final night = Theme.of(context).brightness == Brightness.dark;
    syncTicker(night && !_still(context) && TickerMode.valuesOf(context).enabled);
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: CustomPaint(painter: _CampPainter(night, frame)),
    );
  }
}

class _CampPainter extends CustomPainter {
  _CampPainter(this.night, this.frame) : super(repaint: frame);

  final bool night;
  final ValueListenable<int> frame;

  @override
  void paint(Canvas canvas, Size size) {
    final w = (size.width / _u).ceil(), h = (size.height / _u).floor();
    final grass = night
        ? const [Color(0xFF1D2A24), Color(0xFF22332B), Color(0xFF18231E)]
        : const [Color(0xFFCFDCCB), Color(0xFFC2D3BE), Color(0xFFB6CAB1)];
    final dirt = night
        ? const [Color(0xFF1A1712), Color(0xFF211C16), Color(0xFF15120E)]
        : const [Color(0xFFD9CDB8), Color(0xFFCFC2AB), Color(0xFFE2D7C4)];
    final ground = h - 10;
    for (var x = 0; x < w; x++) {
      final top = ground + _hash(x * 7) % 2;
      for (var y = top; y < h; y++) {
        _cell(canvas, x.toDouble(), y.toDouble(), 1, 1, (y < top + 3 ? grass : dirt)[_hash(x * 131 + y * 17) % 3]);
      }
      if (_hash(x * 29) % 4 == 0) _cell(canvas, x.toDouble(), top - 1.0 - _hash(x) % 2, 1, 1, grass[1]);
    }
    if (night) {
      // 帐篷
      final tx = (w * 0.28).floorToDouble(), ty = ground.toDouble();
      for (var k = 0; k < 8; k++) {
        _cell(canvas, tx - k, ty - 8 + k, 2.0 * k + 1, 1, k.isOdd ? const Color(0xFF2B3A52) : const Color(0xFF33456A));
      }
      _cell(canvas, tx, ty - 4, 1, 4, const Color(0xFF141A26));
      // 篝火：两根柴，火苗每帧换一个样子，火星往上飘
      final fx = (w * 0.64).floorToDouble(), fy = ground - 1.0;
      final f = frame.value;
      _cell(canvas, fx - 3, fy + 1, 7, 1, const Color(0xFF5A3A22));
      _cell(canvas, fx - 2, fy, 5, 1, const Color(0xFF6E4A2C));
      final sway = f.isOdd ? 1.0 : 0.0;
      for (final (dx, dy) in const [(0, -1), (1, -1), (-1, -1), (0, -2), (1, -2), (0, -3)]) {
        _cell(canvas, fx + dx + (dy < -1 ? sway : 0), fy + dy, 1, 1, const Color(0xFFFFB547));
      }
      for (final (dx, dy) in const [(-1, 0), (0, 0), (1, 0), (0, -1)]) {
        _cell(canvas, fx + dx, fy + dy, 1, 1, const Color(0xFFFF6B3D));
      }
      _cell(canvas, fx, fy - 1, 1, 1, const Color(0xFFFFE48A));
      for (var i = 0; i < 3; i++) {
        _cell(canvas, fx + (i - 1) * 2, fy - 5 - (f + i * 3) % 8, 1, 1, const Color(0xFFFFB547));
      }
    } else {
      // 小房子和花
      final tx = (w * 0.3).floorToDouble(), ty = ground.toDouble();
      _cell(canvas, tx - 6, ty - 7, 13, 7, const Color(0xFFF1E6D3));
      for (var k = 0; k < 5; k++) {
        _cell(canvas, tx - 7 + k, ty - 8 - k, 15.0 - 2 * k, 1, const Color(0xFFC9785A));
      }
      _cell(canvas, tx - 1, ty - 4, 3, 4, const Color(0xFF8C5A43));
      _cell(canvas, tx + 3, ty - 6, 2, 2, const Color(0xFF9CC9F0));
      const petals = [Color(0xFFF2A7B5), Color(0xFFF6D06B), Color(0xFF9CC9F0)];
      for (var i = 0; i < 7; i++) {
        final x = 4 + (_rand(i * 9 + 1) * (w - 8)).floorToDouble();
        if ((x - tx).abs() < 9) continue;
        _cell(canvas, x, ty - 2, 1, 2, const Color(0xFF7FA77A));
        _cell(canvas, x, ty - 3, 1, 1, petals[i % 3]);
      }
    }
  }

  @override
  bool shouldRepaint(_CampPainter old) => old.night != night;
}

// ───────────────────────────── 插画 ─────────────────────────────

/// 空状态、引导、出错时的像素插画
enum PixelArtKind {
  clipboard,
  devices,
  plane,
  chest,
  cloud,
  friends,
  laptop,
  desktop,
  phone;

  /// 空状态原来用的图标对应哪张插画；没有对应的返回 null，照旧显示图标
  static PixelArtKind? forIcon(IconData icon) {
    if (icon == AppIcons.clock || icon == AppIcons.star || icon == AppIcons.starFill || icon == AppIcons.docOnClipboard) {
      return clipboard;
    }
    if (icon == AppIcons.deviceLaptop || icon == AppIcons.desktopComputer || icon == AppIcons.radar) return devices;
    if (icon == AppIcons.send) return plane;
    if (icon == AppIcons.people || icon == AppIcons.personAdd || icon == AppIcons.person) return friends;
    if (icon == AppIcons.wifiOff || icon == AppIcons.exclamationmarkCircle || icon == AppIcons.cloud) return cloud;
    if (icon == AppIcons.phone) return phone;
    return null;
  }
}

/// 一张像素插画，每格 [scale] 个逻辑像素
class PixelArt extends StatelessWidget {
  const PixelArt(this.kind, {super.key, this.scale = 4});

  final PixelArtKind kind;
  final double scale;

  static const _sizes = {
    PixelArtKind.clipboard: Size(24, 26),
    PixelArtKind.devices: Size(28, 16),
    PixelArtKind.plane: Size(24, 14),
    PixelArtKind.chest: Size(24, 20),
    PixelArtKind.cloud: Size(24, 18),
    PixelArtKind.friends: Size(23, 14),
    PixelArtKind.laptop: Size(18, 12),
    PixelArtKind.desktop: Size(18, 15),
    PixelArtKind.phone: Size(16, 16),
  };

  @override
  Widget build(BuildContext context) {
    final s = _sizes[kind]!;
    final p = context.palette;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: s.width * scale,
      height: s.height * scale,
      child: CustomPaint(painter: _ArtPainter(kind, scale, p, dark)),
    );
  }
}

class _ArtPainter extends CustomPainter {
  _ArtPainter(this.kind, this.scale, this.p, this.dark);

  final PixelArtKind kind;
  final double scale;
  final AppPalette p;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final k = dark ? const Color(0xFF0A0B0D) : const Color(0xFF1C1D20);
    const paper = Color(0xFFF4F4F1), gray = Color(0xFFC9CCD2), gold = Color(0xFFF6C744), wood = Color(0xFF8C6A4A);
    void r(double x, double y, double w, double h, Color c) =>
        canvas.drawRect(Rect.fromLTWH(x * scale, y * scale, w * scale, h * scale), Paint()..color = c);
    void box(double x, double y, double w, double h, Color fill) {
      r(x, y, w, h, k);
      r(x + 1, y + 1, w - 2, h - 2, fill);
    }

    switch (kind) {
      case PixelArtKind.clipboard:
        box(2, 3, 20, 22, wood);
        box(4, 6, 16, 17, paper);
        box(8, 1, 8, 5, gray);
        r(10, 2, 4, 1, p.textFaint);
        for (final (y, w) in const [(10.0, 10.0), (13.0, 8.0), (16.0, 10.0), (19.0, 5.0)]) {
          r(7, y, w, 1, gray);
        }
        r(20, 15, 1, 3, p.accent);
        r(19, 16, 3, 1, p.accent);
        r(22, 9, 1, 1, gold);
      case PixelArtKind.devices:
        for (final x in const [0.0, 17.0]) {
          box(x, 4, 11, 8, p.surface);
          r(x + 2, 6, 7, 4, p.textDim);
          r(x + 4, 12, 3, 2, k);
          r(x + 2, 14, 7, 1, k);
        }
        for (var x = 12.0; x < 17; x += 2) {
          r(x, 8, 1, 1, p.accent);
        }
        r(13, 2, 2, 1, gold);
        r(13, 1, 1, 1, gold);
      case PixelArtKind.plane:
        const rows = [
          '..............kk',
          '...........kkkwk',
          '........kkkwwwk.',
          '.....kkkwwwwwk..',
          '..kkkwwwwwwwk...',
          'kkwwwwwwwaak....',
          '..kkkwwwaak.....',
          '.....kkaak......',
          '.......kak......',
          '........k.......',
        ];
        for (var y = 0; y < rows.length; y++) {
          for (var x = 0; x < rows[y].length; x++) {
            final ch = rows[y][x];
            if (ch != '.') r(x + 8.0, y + 2.0, 1, 1, ch == 'k' ? k : (ch == 'a' ? p.accent : paper));
          }
        }
        for (var x = 0.0; x < 8; x += 2) {
          r(x, x > 3 ? 10 : 9, 1, 1, p.textFaint);
        }
      case PixelArtKind.chest:
        box(2, 8, 20, 12, wood);
        box(2, 4, 20, 6, const Color(0xFFA57E57));
        r(3, 9, 18, 1, k);
        box(10, 7, 4, 5, gold);
        r(11, 9, 2, 1, k);
        for (final (x, y) in const [(1.0, 1.0), (6.0, 0.0), (18.0, 0.0), (23.0, 2.0), (0.0, 5.0)]) {
          r(x, y, 1, 1, gold);
        }
        r(12, 0, 1, 2, p.accent);
      case PixelArtKind.cloud:
        r(4, 4, 14, 6, k);
        r(2, 6, 20, 6, k);
        r(7, 2, 8, 3, k);
        r(5, 5, 12, 5, gray);
        r(3, 7, 18, 4, gray);
        r(8, 3, 6, 2, gray);
        for (final (x, y) in const [(9.0, 13.0), (10.0, 14.0), (11.0, 15.0), (12.0, 16.0), (13.0, 17.0), (13.0, 13.0), (12.0, 14.0), (10.0, 16.0), (9.0, 17.0)]) {
          r(x, y, 1, 1, p.danger);
        }
      case PixelArtKind.friends:
        for (final (x, shirt) in [(0.0, p.accent), (13.0, const Color(0xFF7AA2F7))]) {
          box(x + 2, 0, 6, 6, const Color(0xFFF2C9A0));
          r(x + 3, 2, 1, 1, k);
          r(x + 6, 2, 1, 1, k);
          box(x, 6, 10, 8, shirt);
        }
        r(11, 3, 2, 2, p.danger);
      case PixelArtKind.laptop:
        box(2, 0, 14, 10, p.surface);
        r(4, 2, 10, 6, p.textDim);
        r(0, 10, 18, 2, k);
        r(1, 10, 16, 1, gray);
      case PixelArtKind.desktop:
        box(0, 0, 18, 12, p.surface);
        r(2, 2, 14, 8, p.textDim);
        r(7, 12, 4, 2, k);
        r(5, 14, 8, 1, k);
      case PixelArtKind.phone:
        box(3, 0, 10, 16, p.surface);
        r(5, 2, 6, 10, p.textDim);
        r(7, 13, 2, 1, k);
    }
  }

  @override
  bool shouldRepaint(_ArtPainter old) => old.kind != kind || old.scale != scale || old.p != p || old.dark != dark;
}

// ───────────────────────────── 动效 ─────────────────────────────

/// 菜单光标：一个一闪一闪的 ▶，像游戏里的选项光标
class PixelCursor extends StatefulWidget {
  const PixelCursor({super.key, this.color});

  final Color? color;

  @override
  State<PixelCursor> createState() => _PixelCursorState();
}

class _PixelCursorState extends State<PixelCursor> with SingleTickerProviderStateMixin, _Frames {
  @override
  int get fps => 2;

  @override
  Widget build(BuildContext context) {
    syncTicker(!_still(context));
    final color = widget.color ?? context.palette.accent;
    return ValueListenableBuilder<int>(
      valueListenable: frame,
      builder: (_, f, _) => SizedBox(
        width: 6,
        height: 10,
        child: f.isOdd ? null : CustomPaint(painter: _ArrowPainter(color)),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  const _ArrowPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (var i = 0; i < 3; i++) {
      canvas.drawRect(Rect.fromLTWH(i * 2.0, i * 2.0, 2, 10 - i * 4.0), paint);
    }
  }

  @override
  bool shouldRepaint(_ArrowPainter old) => old.color != color;
}

/// 加载中。默认主题是转圈；像素主题是四个方格依次点亮。给了 [value] 时照旧画进度环
class ThemedSpinner extends StatefulWidget {
  const ThemedSpinner({super.key, this.strokeWidth, this.color, this.value});

  final double? strokeWidth;
  final Color? color;
  final double? value;

  @override
  State<ThemedSpinner> createState() => _ThemedSpinnerState();
}

class _ThemedSpinnerState extends State<ThemedSpinner> with SingleTickerProviderStateMixin, _Frames {
  @override
  int get fps => 6;

  @override
  Widget build(BuildContext context) {
    final pixel = context.shape.pixel && widget.value == null;
    syncTicker(pixel && !_still(context));
    if (!pixel) {
      return CircularProgressIndicator(strokeWidth: widget.strokeWidth, color: widget.color, value: widget.value);
    }
    final on = widget.color ?? context.palette.accent;
    final off = context.palette.textFaint.withValues(alpha: 0.35);
    return LayoutBuilder(
      builder: (context, c) {
        final side = math.min(c.maxWidth.isFinite ? c.maxWidth : 16.0, c.maxHeight.isFinite ? c.maxHeight : 16.0);
        return Center(
          child: SizedBox.square(
            dimension: side,
            child: ValueListenableBuilder<int>(
              valueListenable: frame,
              builder: (_, f, _) => CustomPaint(painter: _FourSquares(f % 4, on, off)),
            ),
          ),
        );
      },
    );
  }
}

class _FourSquares extends CustomPainter {
  const _FourSquares(this.lit, this.on, this.off);

  final int lit;
  final Color on;
  final Color off;

  @override
  void paint(Canvas canvas, Size size) {
    // 每格是边长的 3/7，取整到 2 的倍数，格间留一格的空
    final cell = math.max(2.0, (size.width * 3 / 7 / 2).floorToDouble() * 2);
    final gap = math.max(2.0, size.width - cell * 2);
    final o = (size.width - cell * 2 - gap) / 2;
    const order = [(0, 0), (1, 0), (1, 1), (0, 1)]; // 顺时针
    for (var i = 0; i < 4; i++) {
      final (x, y) = order[i];
      canvas.drawRect(
        Rect.fromLTWH(o + x * (cell + gap), o + y * (cell + gap), cell, cell),
        Paint()..color = i == lit ? on : off,
      );
    }
  }

  @override
  bool shouldRepaint(_FourSquares old) => old.lit != lit || old.on != on || old.off != off;
}

/// 一圈像素星星从中间迸开，放一遍就停（传送完成、配对成功）
class PixelBurst extends StatefulWidget {
  const PixelBurst({super.key, required this.size});

  final double size;

  @override
  State<PixelBurst> createState() => _PixelBurstState();
}

class _PixelBurstState extends State<PixelBurst> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_still(context)) return const SizedBox.shrink();
    return IgnorePointer(
      child: SizedBox.square(
        dimension: widget.size,
        child: CustomPaint(painter: _BurstPainter(_c, context.palette.accent)),
      ),
    );
  }
}

class _BurstPainter extends CustomPainter {
  _BurstPainter(this.t, this.accent) : super(repaint: t);

  final Animation<double> t;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    if (t.value >= 1) return;
    final step = (t.value * 6).floor(); // 6 帧
    final c = size.center(Offset.zero);
    final colors = [const Color(0xFFF6C744), accent, const Color(0xFFF4F4F1)];
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final d = size.width * 0.18 + step * size.width * 0.06;
      final x = ((c.dx + math.cos(a) * d) / 2).roundToDouble() * 2, y = ((c.dy + math.sin(a) * d) / 2).roundToDouble() * 2;
      final paint = Paint()..color = colors[i % 3];
      canvas.drawRect(Rect.fromLTWH(x, y, 4, 4), paint);
      if (step < 3) {
        canvas
          ..drawRect(Rect.fromLTWH(x - 2, y + 1, 8, 2), paint)
          ..drawRect(Rect.fromLTWH(x + 1, y - 2, 2, 8), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => old.accent != accent;
}

/// 一格一格上下跳：拖着文件经过的设备，等你松手
class PixelBounce extends StatefulWidget {
  const PixelBounce({super.key, required this.active, required this.child});

  final bool active;
  final Widget child;

  @override
  State<PixelBounce> createState() => _PixelBounceState();
}

class _PixelBounceState extends State<PixelBounce> with SingleTickerProviderStateMixin, _Frames {
  @override
  int get fps => 3;

  @override
  Widget build(BuildContext context) {
    syncTicker(widget.active && !_still(context));
    return ValueListenableBuilder<int>(
      valueListenable: frame,
      builder: (_, f, child) => Transform.translate(offset: Offset(0, widget.active && f.isOdd ? -4 : 0), child: child),
      child: widget.child,
    );
  }
}

/// 发送中的纸飞机：在设备左上方一格一格往设备飞，到了再从头飞
class PixelPlane extends StatefulWidget {
  const PixelPlane({super.key});

  @override
  State<PixelPlane> createState() => _PixelPlaneState();
}

class _PixelPlaneState extends State<PixelPlane> with SingleTickerProviderStateMixin, _Frames {
  @override
  int get fps => 6;

  @override
  Widget build(BuildContext context) {
    syncTicker(!_still(context));
    return IgnorePointer(
      child: ValueListenableBuilder<int>(
        valueListenable: frame,
        builder: (_, f, child) {
          final step = f % 8;
          return Transform.translate(offset: Offset(step * 4.0, step * 2.0), child: Opacity(opacity: step < 7 ? 1 : 0, child: child));
        },
        child: const PixelArt(PixelArtKind.plane, scale: 1),
      ),
    );
  }
}

/// 像素主题里打开了扫描线时，在 [child] 上叠一层（设置 › 外观；默认关）
class PixelScanlinesLayer extends StatelessWidget {
  const PixelScanlinesLayer({super.key, required this.on, required this.child});

  final bool on;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!on || !context.shape.pixel) return child;
    return Stack(children: [child, const Positioned.fill(child: PixelScanlines())]);
  }
}

/// 整窗叠一层很淡的 CRT 扫描线
class PixelScanlines extends StatelessWidget {
  const PixelScanlines({super.key});

  @override
  Widget build(BuildContext context) => const IgnorePointer(child: CustomPaint(painter: _ScanlinePainter(), size: Size.infinite));
}

class _ScanlinePainter extends CustomPainter {
  const _ScanlinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x14000000);
    for (var y = 0.0; y < size.height; y += 3) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), paint);
    }
  }

  @override
  bool shouldRepaint(_ScanlinePainter old) => false;
}
