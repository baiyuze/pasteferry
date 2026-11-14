import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'theme.dart';

/// Small, deterministic illustrations. No timers, network images or hit targets.
/// The left half stays clear so translated page titles retain their contrast.
class DesignArtwork extends StatelessWidget {
  const DesignArtwork({super.key, this.height = 180, this.sidebar = false});

  final double height;
  final bool sidebar;

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: ExcludeSemantics(
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: RepaintBoundary(
              child: ShaderMask(
                blendMode: BlendMode.dstIn,
                shaderCallback: (r) => LinearGradient(
                  begin: sidebar ? Alignment.topCenter : Alignment.centerLeft,
                  end: sidebar ? Alignment.bottomCenter : Alignment.centerRight,
                  colors: const [Colors.transparent, Colors.black],
                  stops: sidebar ? const [0, .5] : const [.35, .78],
                ).createShader(r),
                child: CustomPaint(painter: _DesignPainter(context.artwork, context.palette)),
              ),
            ),
          ),
        ),
      );
}

class _DesignPainter extends CustomPainter {
  const _DesignPainter(this.style, this.p);

  final ArtworkStyle style;
  final AppPalette p;

  @override
  void paint(Canvas canvas, Size size) {
    if (style == ArtworkStyle.none || size.isEmpty) return;
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    final scale = size.height / 180;
    canvas.translate(math.max(0, size.width - 340 * scale), 0);
    canvas.scale(scale);
    final accent = p.accent;
    final ink = p.text;
    void rect(Rect r, Color color) => canvas.drawRect(r, Paint()..color = color);
    void circle(Offset c, double r, Color color) => canvas.drawCircle(c, r, Paint()..color = color);
    void line(Offset a, Offset b, Color color, [double width = 1]) =>
        canvas.drawLine(a, b, Paint()..color = color..strokeWidth = width);
    switch (style) {
      case ArtworkStyle.jazz:
        rect(const Rect.fromLTWH(72, 0, 270, 180), accent.withValues(alpha: .13));
        circle(const Offset(250, 90), 99, ink.withValues(alpha: .2));
        for (var r = 34.0; r < 96; r += 5) {
          canvas.drawCircle(const Offset(250, 90), r,
              Paint()..color = ink.withValues(alpha: .17)..style = PaintingStyle.stroke);
        }
        circle(const Offset(250, 90), 28, accent.withValues(alpha: .65));
        circle(const Offset(250, 90), 5, p.background);
        canvas.save();
        canvas.translate(90, 132);
        canvas.rotate(-.37);
        rect(const Rect.fromLTWH(0, 0, 320, 20), p.surface.withValues(alpha: .7));
        canvas.restore();
      case ArtworkStyle.space:
        final orb = const Rect.fromLTWH(177, 14, 144, 144);
        canvas.drawOval(orb, Paint()..shader = RadialGradient(
          center: const Alignment(-.5, -.6),
          colors: [p.surface, p.border, p.textDim, p.surface],
          stops: const [0, .35, .75, 1],
        ).createShader(orb)..color = p.surface.withValues(alpha: .5));
        canvas.save();
        canvas.translate(249, 86);
        canvas.rotate(-.45);
        canvas.drawOval(const Rect.fromLTWH(-105, -35, 210, 70),
            Paint()..color = accent.withValues(alpha: .65)..strokeWidth = 8..style = PaintingStyle.stroke);
        canvas.restore();
        for (var x = 80.0; x < 340; x += 24) {
          line(Offset(x, 0), Offset(x, 180), p.border.withValues(alpha: .13));
        }
      case ArtworkStyle.memphis:
        circle(const Offset(280, 45), 65, accent.withValues(alpha: .24));
        canvas.drawPath(Path()..moveTo(158, 110)..lineTo(213, 25)..lineTo(242, 133)..close(),
            Paint()..color = p.fill);
        for (var i = 0; i < 9; i++) {
          line(Offset(270.0 + i * 8, 105), Offset(241.0 + i * 8, 159), ink.withValues(alpha: .25), 3);
        }
        final wave = Path()..moveTo(78, 53);
        for (var i = 0; i < 5; i++) {
          final x = 78.0 + i * 22;
          wave.cubicTo(x + 6, 20, x + 15, 83, x + 22, 53);
        }
        canvas.drawPath(wave, Paint()..color = ink.withValues(alpha: .3)..style = PaintingStyle.stroke..strokeWidth = 3);
      case ArtworkStyle.y2k:
        final star = Path();
        for (var i = 0; i < 16; i++) {
          final a = i * math.pi / 8 - math.pi / 2;
          final r = i.isEven ? 70.0 : 26.0;
          final point = Offset(259 + math.cos(a) * r, 77 + math.sin(a) * r);
          if (i == 0) { star.moveTo(point.dx, point.dy); } else { star.lineTo(point.dx, point.dy); }
        }
        star.close();
        canvas.drawPath(star, Paint()..shader = LinearGradient(
          colors: [p.surface, accent.withValues(alpha: .65), p.surface, p.borderStrong],
          stops: const [0, .36, .5, 1],
        ).createShader(const Rect.fromLTWH(180, 0, 150, 150)));
        canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(86, 102, 228, 43), const Radius.circular(23)),
            Paint()..color = accent.withValues(alpha: .15));
        for (var x = 100.0; x < 340; x += 28) {
          line(Offset(x, 0), Offset(x, 180), accent.withValues(alpha: .08));
        }
      case ArtworkStyle.americana:
        for (var x = 90.0; x < 340; x += 8) {
          for (var y = 4.0; y < 170; y += 8) {
            circle(Offset(x, y), .8, ink.withValues(alpha: .17));
          }
        }
        canvas.save();
        canvas.translate(210, 80);
        canvas.rotate(.12);
        final ticket = RRect.fromRectAndRadius(const Rect.fromLTWH(-70, -55, 170, 100), const Radius.circular(6));
        canvas.drawRRect(ticket, Paint()..color = p.fill);
        canvas.drawRRect(ticket.deflate(7), Paint()..color = accent.withValues(alpha: .45)
          ..strokeWidth = 1.5..style = PaintingStyle.stroke);
        for (var y = -25.0; y < 25; y += 14) {
          line(Offset(-43, y), Offset(70, y), ink.withValues(alpha: .25), 3);
        }
        canvas.restore();
        circle(const Offset(305, 30), 24, accent.withValues(alpha: .35));
      case ArtworkStyle.arcade:
        for (var i = 0; i < 12; i++) {
          final x = 100.0 + i * 20;
          final h = 14.0 + (i * 37 % 78);
          rect(Rect.fromLTWH(x, 180 - h, 14, h), accent.withValues(alpha: .14));
          rect(Rect.fromLTWH(x, 180 - h, 14, 4), accent.withValues(alpha: .3));
        }
        for (var i = 0; i < 18; i++) {
          final x = 96.0 + (i * 43 % 234), y = 10.0 + (i * 29 % 112);
          rect(Rect.fromLTWH(x, y, i.isEven ? 4 : 2, 2), accent.withValues(alpha: .45));
        }
        for (var i = 0; i < 5; i++) {
          rect(Rect.fromLTWH(214.0 + i * 9, 54 + (i - 2).abs() * 9, 9, 9), accent.withValues(alpha: .6));
        }
      case ArtworkStyle.retro:
        final outer = const Rect.fromLTWH(160, 23, 165, 122);
        rect(outer.translate(5, 5), ink.withValues(alpha: .13));
        rect(outer, p.sidebar);
        line(outer.topLeft, outer.topRight, p.bevelLight, 2);
        line(outer.topLeft, outer.bottomLeft, p.bevelLight, 2);
        line(outer.bottomLeft, outer.bottomRight, p.bevelDark, 2);
        line(outer.topRight, outer.bottomRight, p.bevelDark, 2);
        rect(const Rect.fromLTWH(164, 27, 157, 16), accent.withValues(alpha: .5));
        for (var i = 0; i < 3; i++) {
          rect(Rect.fromLTWH(285.0 + i * 11, 30, 8, 9), p.surface);
        }
        rect(const Rect.fromLTWH(171, 52, 142, 82), p.surface);
        for (var i = 0; i < 4; i++) {
          rect(Rect.fromLTWH(178, 61.0 + i * 16, 8, 10), accent.withValues(alpha: .3));
          rect(Rect.fromLTWH(193, 64.0 + i * 16, 85 - i * 8.0, 3), ink.withValues(alpha: .2));
        }
      case ArtworkStyle.none:
        break;
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_DesignPainter old) => old.style != style || old.p != p;
}
