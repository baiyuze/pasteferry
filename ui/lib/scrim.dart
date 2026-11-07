import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';

import 'theme.dart';

// 背景图上的遮罩至少要多浓（design/themes.md 第 7.2 节）。
//
// 后台服务的分析结果是按纯黑、纯白文字算的；页面上的字是主题的 text、textDim（灰色，要求更高），
// 还要叠在半透明的面板上。所以界面拿缩小的图自己算：遮罩按 sRGB 数值叠上去（与 Flutter 画的一样），
// 每个小块都试一遍，取 95% 的小块都够用的浓度——零星的星星、高光不算。

/// 把图缩到 64 宽，取出 RGBA 像素，给 [minScrim] 用
Future<Uint8List> sampleImage(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes, targetWidth: 64);
  final frame = await codec.getNextFrame();
  try {
    final data = await frame.image.toByteData(format: ui.ImageByteFormat.rawRgba);
    return data!.buffer.asUint8List();
  } finally {
    frame.image.dispose();
    codec.dispose();
  }
}

/// 遮罩颜色 [scrim] 至少多浓（0 到 1），正文与次要文字才在图上、侧边栏上、面板上都达到 4.5:1。
/// 遮罩铺满了也不够（遮罩颜色本身和字太像）时返回 1
double minScrim(
  Uint8List rgba, {
  required Color scrim,
  required AppPalette palette,
  required double surfaceOpacity,
}) {
  final texts = [_rgb(palette.text), _rgb(palette.textDim)];
  final panels = [_rgb(palette.surface), _rgb(palette.sidebar)];
  final s = _rgb(scrim);

  bool readable(List<double> c) {
    for (final t in texts) {
      if (_contrast(t, c) < 4.5) return false;
      for (final p in panels) {
        if (_contrast(t, _mix(c, p, surfaceOpacity)) < 4.5) return false;
      }
    }
    return true;
  }

  final need = <double>[];
  for (var i = 0; i + 3 < rgba.length; i += 4) {
    if (rgba[i + 3] == 0) continue;
    final px = [rgba[i].toDouble(), rgba[i + 1].toDouble(), rgba[i + 2].toDouble()];
    var lo = 0.0, hi = 1.0;
    if (readable(px)) {
      hi = 0;
    } else if (!readable(_mix(px, s, 1))) {
      need.add(1);
      continue;
    }
    for (var k = 0; k < 12 && hi > 0; k++) {
      final mid = (lo + hi) / 2;
      readable(_mix(px, s, mid)) ? hi = mid : lo = mid;
    }
    need.add(hi);
  }
  if (need.isEmpty) return 0;
  need.sort();
  return need[((need.length - 1) * 0.95).floor()];
}

List<double> _rgb(Color c) => [c.r * 255, c.g * 255, c.b * 255];

List<double> _mix(List<double> a, List<double> b, double t) =>
    [a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t, a[2] + (b[2] - a[2]) * t];

double _channel(double v) {
  final c = v / 255;
  return c <= 0.04045 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
}

double _luminance(List<double> c) => 0.2126 * _channel(c[0]) + 0.7152 * _channel(c[1]) + 0.0722 * _channel(c[2]);

double _contrast(List<double> a, List<double> b) {
  final la = _luminance(a), lb = _luminance(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}
