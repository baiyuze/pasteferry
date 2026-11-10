import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'theme.dart';

// 像素主题：结构像素化，颜色现代化。设计说明见 design/pixel-theme.md。
//
// - 文字用缝合像素字体（12px 点阵），字号只有 12 与 24 两档；
// - 颜色是中性灰分层（深色「石墨」、浅色「纸」），强调色是像素绿，只用在主按钮、选中、进度、链接上；
// - 边框都是 2px、四角留空一格，分三级：容器淡边；按钮、输入框强边加斜面（按钮凸起、输入框凹下）；
//   只有浮层（对话框、菜单、悬停预览）有错开的实心投影；
// - 图标用 Pixelarticons，动画逐帧跳变。
//
// 字体与图标由 tools/pixel-theme/build_assets.py 生成，在 ui/assets/fonts/。

const pixelTheme = AppThemeSpec(
  id: 'pixel',
  // 「纸」：暖白底，按钮、输入框、浮层描深色边
  light: AppPalette(
    accent: Color(0xFF08875B),
    background: Color(0xFFF5F5F2),
    sidebar: Color(0xFFECECE7),
    surface: Color(0xFFFFFFFF),
    border: Color(0xFFDCDCD5),
    borderStrong: Color(0xFF1C1D20),
    separator: Color(0xFFE2E2DC),
    text: Color(0xFF1C1D20),
    textDim: Color(0xFF5E626A),
    textFaint: Color(0xFF9A9DA4),
    selection: Color(0xFFFAFAF8),
    hover: Color(0x0A1C1D20),
    fill: Color(0xFFEFEFEA),
    online: Color(0xFF15803D),
    warning: Color(0xFFB45309),
    danger: Color(0xFFDC2626),
    inverse: Color(0xFF1C1D20),
    onInverse: Color(0xFFF5F5F2),
    bevelLight: Color(0xB3FFFFFF),
    bevelDark: Color(0x2E000000),
    shadow: Color(0xE61C1D20),
  ),
  // 「石墨」：近黑的冷灰分三层，边框低对比
  dark: AppPalette(
    accent: Color(0xFF3DDC97),
    background: Color(0xFF111215),
    sidebar: Color(0xFF0C0D0F),
    surface: Color(0xFF17191D),
    border: Color(0xFF2A2D34),
    borderStrong: Color(0xFF3C414B),
    separator: Color(0xFF25282E),
    text: Color(0xFFE6E8EB),
    textDim: Color(0xFF9AA0AA),
    textFaint: Color(0xFF5F6570),
    selection: Color(0xFF1F2227),
    hover: Color(0x0AFFFFFF),
    fill: Color(0xFF0D0E11),
    online: Color(0xFF4ADE80),
    warning: Color(0xFFFBBF24),
    danger: Color(0xFFF87171),
    onAccent: Color(0xFF0C0D0F),
    inverse: Color(0xFFE6E8EB),
    onInverse: Color(0xFF111215),
    bevelLight: Color(0x14FFFFFF),
    bevelDark: Color(0x59000000),
    shadow: Color(0x80000000),
  ),
  shape: AppShape(
    sm: 0,
    md: 0,
    lg: 0,
    corner: CornerStyle.pixel,
    borderWidth: 2,
    unit: 2,
    shadow: ShadowStyle.hard,
  ),
  typography: AppTypography(family: 'FusionPixel', mono: 'FusionPixelMono', sizes: [12, 24]),
  motion: AppMotion(style: MotionStyle.stepped),
  pixelIcons: true,
);

/// 像素角：四角各切掉 [steps] 级台阶，每级 [unit] 见方。一级是点阵窗口的缺角，三级看起来像像素画的圆。
///
/// - [side] 只画外圈，里面的底是直角矩形，和点阵游戏里的窗口一样；
/// - [topLeft]、[bottomRight] 是边框里面一格宽的斜面：上亮下暗是凸起的按钮，反过来是凹下的输入框；
/// - [drop] 是向右下错开两格的实心投影，浮层才有。
class PixelBorder extends OutlinedBorder {
  const PixelBorder({super.side, this.unit = 2, this.steps = 1, this.topLeft, this.bottomRight, this.drop});

  final double unit;
  final int steps;
  final Color? topLeft;
  final Color? bottomRight;
  final Color? drop;

  /// 按下的按钮：斜面明暗互换
  PixelBorder get pressed => PixelBorder(side: side, unit: unit, steps: steps, topLeft: bottomRight, bottomRight: topLeft, drop: drop);

  /// 方块太小放不下这么多级台阶时少切几级
  int _fit(Rect r, int n) => math.max(0, math.min(n, (math.min(r.width, r.height) / (2 * unit)).floor()));

  Path _path(Rect r, int n) {
    n = _fit(r, n);
    if (n == 0) return Path()..addRect(r);
    // 左上角的台阶：从左边 (0, n) 走到上边 (n, 0)，其余三个角翻过去
    final stair = <Offset>[
      for (var i = 0; i < n; i++) ...[Offset(i * unit, (n - i) * unit), Offset((i + 1) * unit, (n - i) * unit)],
      Offset(n * unit, 0),
    ];
    return Path()
      ..addPolygon([
        for (final o in stair) Offset(r.left + o.dx, r.top + o.dy),
        for (final o in stair.reversed) Offset(r.right - o.dx, r.top + o.dy),
        for (final o in stair) Offset(r.right - o.dx, r.bottom - o.dy),
        for (final o in stair.reversed) Offset(r.left + o.dx, r.bottom - o.dy),
      ], true);
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => _path(rect, steps);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => _path(rect.deflate(side.width), steps - 1);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final outer = getOuterPath(rect);
    if (drop != null) {
      canvas.drawPath(
        Path.combine(PathOperation.difference, outer.shift(Offset(unit, unit) * 2), outer),
        Paint()..color = drop!,
      );
    }
    final inner = rect.deflate(side.width);
    if (topLeft != null && inner.width > 2 * unit && inner.height > 2 * unit) {
      final light = Paint()..color = topLeft!;
      final dark = Paint()..color = bottomRight ?? const Color(0x00000000);
      canvas
        ..drawRect(Rect.fromLTWH(inner.left, inner.top, inner.width, unit), light)
        ..drawRect(Rect.fromLTWH(inner.left, inner.top, unit, inner.height), light)
        ..drawRect(Rect.fromLTWH(inner.left, inner.bottom - unit, inner.width, unit), dark)
        ..drawRect(Rect.fromLTWH(inner.right - unit, inner.top, unit, inner.height), dark);
    }
    if (side.style == BorderStyle.none || side.width == 0) return;
    canvas.drawPath(Path.combine(PathOperation.difference, outer, getInnerPath(rect)), Paint()..color = side.color);
  }

  @override
  PixelBorder copyWith({BorderSide? side, double? unit, int? steps}) => PixelBorder(
        side: side ?? this.side,
        unit: unit ?? this.unit,
        steps: steps ?? this.steps,
        topLeft: topLeft,
        bottomRight: bottomRight,
        drop: drop,
      );

  @override
  ShapeBorder scale(double t) =>
      PixelBorder(side: side.scale(t), unit: unit * t, steps: steps, topLeft: topLeft, bottomRight: bottomRight, drop: drop);

  @override
  bool operator ==(Object other) =>
      other is PixelBorder &&
      other.side == side &&
      other.unit == unit &&
      other.steps == steps &&
      other.topLeft == topLeft &&
      other.bottomRight == bottomRight &&
      other.drop == drop;

  @override
  int get hashCode => Object.hash(side, unit, steps, topLeft, bottomRight, drop);
}

/// 输入框的像素边框：凹下去的槽（上、左暗，下、右亮），聚焦时边框换成强调色。
class PixelInputBorder extends InputBorder {
  const PixelInputBorder({super.borderSide, this.unit = 2, this.topLeft, this.bottomRight});

  final double unit;
  final Color? topLeft;
  final Color? bottomRight;

  PixelBorder get _border => PixelBorder(side: borderSide, unit: unit, topLeft: topLeft, bottomRight: bottomRight);

  @override
  bool get isOutline => true;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(borderSide.width);

  @override
  PixelInputBorder copyWith({BorderSide? borderSide}) =>
      PixelInputBorder(borderSide: borderSide ?? this.borderSide, unit: unit, topLeft: topLeft, bottomRight: bottomRight);

  @override
  ShapeBorder scale(double t) =>
      PixelInputBorder(borderSide: borderSide.scale(t), unit: unit * t, topLeft: topLeft, bottomRight: bottomRight);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => _border.getInnerPath(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => _border.getOuterPath(rect);

  @override
  void paint(Canvas canvas, Rect rect,
          {double? gapStart, double gapExtent = 0.0, double gapPercentage = 0.0, TextDirection? textDirection}) =>
      _border.paint(canvas, rect);

  @override
  bool operator ==(Object other) =>
      other is PixelInputBorder &&
      other.borderSide == borderSide &&
      other.unit == unit &&
      other.topLeft == topLeft &&
      other.bottomRight == bottomRight;

  @override
  int get hashCode => Object.hash(borderSide, unit, topLeft, bottomRight);
}

/// 列表、分组里行与行之间的分隔线。默认主题就是 Divider；像素主题是隔一格画一格的点线
class ThemedDivider extends StatelessWidget {
  const ThemedDivider({super.key, this.height, this.indent, this.endIndent, this.color});

  final double? height;
  final double? indent;
  final double? endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final s = context.shape;
    if (!s.pixel) return Divider(height: height, indent: indent, endIndent: endIndent, color: color);
    return SizedBox(
      height: math.max(height ?? s.borderWidth, s.borderWidth),
      child: Center(
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: indent ?? 0, end: endIndent ?? 0),
          child: SizedBox(
            height: s.borderWidth,
            width: double.infinity,
            child: CustomPaint(painter: _DashPainter(color ?? context.palette.separator, s.unit)),
          ),
        ),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  const _DashPainter(this.color, this.unit);

  final Color color;
  final double unit;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (var x = 0.0; x < size.width; x += unit * 2) {
      canvas.drawRect(Rect.fromLTWH(x, 0, unit, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) => old.color != color || old.unit != unit;
}

/// 按 [unit] 见方的点画椭圆：雷达的圈与波纹在像素主题里都用它。
///
/// [gaps] 里的几段不画（起始角度、跨过的角度，弧度，顺时针从正右方算，与 Canvas.drawArc 相同）；
/// [dashed] 时隔一格画一格，像点阵游戏里的虚线。
void drawPixelOval(Canvas canvas, Rect oval, Color color, double unit,
    {List<(double, double)> gaps = const [], bool dashed = false}) {
  final c = oval.center;
  final rx = oval.width / 2, ry = oval.height / 2;
  final paint = Paint()..color = color;
  final seen = <(int, int)>{};
  bool inGap(double a) => gaps.any((g) {
        final d = ((a - g.$1) % (2 * math.pi) + 2 * math.pi) % (2 * math.pi);
        return d < g.$2;
      });
  // 相邻两个采样点不超过半格，圈上不会断开
  final n = math.max(16, (math.pi * (rx + ry) / (unit / 2)).ceil());
  var drawn = 0;
  for (var i = 0; i < n; i++) {
    final a = 2 * math.pi * i / n;
    final gx = ((c.dx + rx * math.cos(a)) / unit).floor();
    final gy = ((c.dy + ry * math.sin(a)) / unit).floor();
    if (!seen.add((gx, gy)) || inGap(a)) continue;
    if (!dashed || drawn.isEven) canvas.drawRect(Rect.fromLTWH(gx * unit, gy * unit, unit, unit), paint);
    drawn++;
  }
}

/// 把子组件裁成圆形；像素主题里裁成切掉三级台阶的方块（头像）
class ThemedClipOval extends StatelessWidget {
  const ThemedClipOval({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final s = context.shape;
    if (!s.pixel) return ClipOval(child: child);
    return ClipPath(clipper: ShapeBorderClipper(shape: PixelBorder(unit: s.unit, steps: 3)), child: child);
  }
}

/// 进度条。默认主题就是 LinearProgressIndicator；像素主题里是凹槽里一格一格点亮的方块，
/// 不知道进度时三格亮块一跳一跳地往右走。
class ThemedProgressBar extends StatefulWidget {
  const ThemedProgressBar({super.key, this.value, this.minHeight, this.color, this.backgroundColor, this.borderRadius});

  final double? value;
  final double? minHeight;
  final Color? color;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;

  @override
  State<ThemedProgressBar> createState() => _ThemedProgressBarState();
}

class _ThemedProgressBarState extends State<ThemedProgressBar> with SingleTickerProviderStateMixin {
  AnimationController? _march;

  @override
  void dispose() {
    _march?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.shape;
    if (!s.pixel) {
      return LinearProgressIndicator(
        value: widget.value,
        minHeight: widget.minHeight,
        color: widget.color,
        backgroundColor: widget.backgroundColor,
        borderRadius: widget.borderRadius,
      );
    }
    final p = context.palette;
    final indeterminate = widget.value == null;
    if (indeterminate) {
      _march ??= AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat();
    } else {
      _march?.dispose();
      _march = null;
    }
    // 边框本身就让出了 borderWidth 的内边距
    return Container(
      height: s.borderWidth * 2 + s.unit * 5,
      decoration: s.box(color: widget.backgroundColor ?? p.fill, border: p.borderStrong, bevel: (p.bevelDark, p.bevelLight)),
      child: CustomPaint(
        size: Size.infinite,
        painter: _CellsPainter(
          value: widget.value,
          march: _march,
          color: widget.color ?? p.accent,
          unit: s.unit,
        ),
      ),
    );
  }
}

class _CellsPainter extends CustomPainter {
  _CellsPainter({required this.value, required this.march, required this.color, required this.unit})
      : super(repaint: march);

  final double? value;
  final Animation<double>? march;
  final Color color;
  final double unit;

  @override
  void paint(Canvas canvas, Size size) {
    // 每格 3 个单位宽，格间空 1 个单位；整条从里面留出 1 个单位的边
    final cell = unit * 3, gap = unit;
    final inner = Rect.fromLTWH(unit, unit, size.width - 2 * unit, size.height - 2 * unit);
    if (inner.width <= 0 || inner.height <= 0) return;
    final n = math.max(1, ((inner.width + gap) / (cell + gap)).floor());
    final paint = Paint()..color = color;
    void lit(int i) => canvas.drawRect(Rect.fromLTWH(inner.left + i * (cell + gap), inner.top, cell, inner.height), paint);
    if (value != null) {
      final on = (value!.clamp(0.0, 1.0) * n).round();
      for (var i = 0; i < on; i++) {
        lit(i);
      }
      return;
    }
    final head = ((march?.value ?? 0) * (n + 3)).floor();
    for (var i = head - 3; i < head; i++) {
      if (i >= 0 && i < n) lit(i);
    }
  }

  @override
  bool shouldRepaint(_CellsPainter old) => old.value != value || old.color != color || old.unit != unit;
}

/// 像素版的 App 图标：16×16 的点阵画，和正式图标一样是一页纸叠在另一页上，前面那页用强调色。
/// 只按整数倍放大，画在 [size] 见方的格子正中。
class PixelAppMark extends StatelessWidget {
  const PixelAppMark({super.key, required this.size});

  final double size;

  // O 底板的描边，T 底板，S 前页的投影，K 后页的轮廓与文字，W 后页的纸，A 前页，H 前页上的文字，. 透明
  static const _sprite = [
    '.OOOOOOOOOOOOOO.',
    'OTTTTTTTTTTTTTTO',
    'OTKKKKKKKTTTTTTO',
    'OTKWWWWWKTTTTTTO',
    'OTKWKKKWKTTTTTTO',
    'OTKWWWWWKTTTTTTO',
    'OTKWKKAAAAAAATTO',
    'OTKWWWAHHHHAATTO',
    'OTKWKKAAAAAAATTO',
    'OTKWWWAHHHAAATTO',
    'OTKWWWAAAAAAATTO',
    'OTKKKKAHHAAAATTO',
    'OTTTTTAAAAAAATTO',
    'OTTTTTTSSSSSSSTO',
    'OTTTTTTTTTTTTTTO',
    '.OOOOOOOOOOOOOO.',
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final colors = {
      'O': p.borderStrong,
      'T': const Color(0xFFF2F2EF),
      'S': const Color(0xFFC9C9C4),
      'K': const Color(0xFF2B2C30),
      'W': const Color(0xFFFFFFFF),
      'A': p.accent,
      'H': p.onAccent,
    };
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _SpritePainter(_sprite, colors)),
    );
  }
}

class _SpritePainter extends CustomPainter {
  _SpritePainter(this.rows, this.colors);

  final List<String> rows;
  final Map<String, Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final n = rows.length;
    final cell = math.max(1, (size.shortestSide / n).floor()).toDouble();
    final origin = Offset(((size.width - cell * n) / 2).roundToDouble(), ((size.height - cell * n) / 2).roundToDouble());
    final paint = Paint();
    for (var y = 0; y < n; y++) {
      for (var x = 0; x < rows[y].length; x++) {
        final c = colors[rows[y][x]];
        if (c == null) continue;
        paint.color = c;
        canvas.drawRect(Rect.fromLTWH(origin.dx + x * cell, origin.dy + y * cell, cell, cell), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SpritePainter old) => old.colors.toString() != colors.toString();
}
