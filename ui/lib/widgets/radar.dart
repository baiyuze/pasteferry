import 'package:flutter/material.dart';

import '../pages/devices_page.dart' show platformIcon;
import '../platform.dart';
import '../theme.dart';

// 雷达：「搜索附近设备」与隔空传送页共用的底图和中间的本机。

/// 雷达的底：几圈很淡的同心圆，两道波纹错开半个周期从本机向外扩散、逐渐变淡。
///
/// 给了 [orbits]（每圈的横向、纵向半径）时，按它们画椭圆，与设备所在的轨道重合，
/// 波纹扩散到最外一圈；没给时画三圈正圆，铺满短边。
class RadarPainter extends CustomPainter {
  RadarPainter({required this.pulse, required this.ring, required this.wave, this.orbits})
      : super(repaint: pulse);

  final Animation<double> pulse;
  final Color ring;
  final Color wave;
  final List<Size>? orbits;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final maxR = size.shortestSide / 2;
    final rings = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = ring;
    final orbits = this.orbits ?? [for (final f in const [0.36, 0.68, 1.0]) Size(maxR * f, maxR * f)];
    for (final o in orbits) {
      canvas.drawOval(Rect.fromCenter(center: c, width: o.width * 2, height: o.height * 2), rings);
    }
    final outer = orbits.last;
    for (final offset in const [0.0, 0.5]) {
      final t = (pulse.value + offset) % 1.0;
      final k = Curves.easeOut.transform(t);
      final rx = 28 + (outer.width - 28) * k;
      final ry = 28 + (outer.height - 28) * k;
      canvas.drawOval(
        Rect.fromCenter(center: c, width: rx * 2, height: ry * 2),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = wave.withValues(alpha: 0.3 * (1 - t)),
      );
    }
  }

  @override
  bool shouldRepaint(RadarPainter old) => old.ring != ring || old.wave != wave || old.orbits != orbits;
}

/// 雷达中间的本机。
class RadarSelfNode extends StatelessWidget {
  const RadarSelfNode({super.key, required this.platform, required this.size});

  final String platform;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: p.surface,
            border: Border.all(color: p.accent, width: 1.5),
          ),
          child: Icon(platformIcon(platform), size: 22, color: p.accent),
        ),
        const SizedBox(height: 6),
        Text(
          Wording.thisDevice,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: context.text.labelMedium,
        ),
      ],
    );
  }
}

