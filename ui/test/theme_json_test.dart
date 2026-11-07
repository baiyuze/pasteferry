import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pasteferry_ui/pixel_theme.dart';
import 'package:pasteferry_ui/theme.dart';
import 'package:pasteferry_ui/theme_json.dart';

void main() {
  test('内置主题导出再读回来不变', () {
    for (final spec in [AppThemeSpec.standard, pixelTheme]) {
      final back = parseTheme(jsonEncode(themeToJson(spec)), base: AppThemeSpec.standard);
      expect(back.light.accent, spec.light.accent);
      expect(back.dark.borderStrong, spec.dark.borderStrong);
      expect(back.dark.shadow, spec.dark.shadow);
      expect(back.shape.corner, spec.shape.corner);
      expect(back.shape.borderWidth, spec.shape.borderWidth);
      expect(back.typography.family, spec.typography.family);
      expect(back.typography.mono, spec.typography.mono);
      expect(back.typography.sizes, spec.typography.sizes);
      expect(back.motion.style, spec.motion.style);
      expect(back.pixelIcons, spec.pixelIcons);
    }
  });

  test('背景图与像素风景：读进来、导出再读回来不变', () {
    final sha = 'a' * 64;
    final s = parseTheme({
      'schema': 1,
      'id': 'photo',
      'base': 'pixel',
      'scenery': false,
      'background': {
        'image': 'user:$sha',
        'fit': 'tile',
        'align': 'bottomLeft',
        'blur': 50,
        'scrim': {'color': '#000000', 'opacity': 0.4},
        'surfaceOpacity': 0.7,
        'scope': ['main', 'picker'],
        'accentFromImage': true,
      },
    });
    final bg = s.background!;
    expect(s.scenery, isFalse);
    expect(bg.shaFor(Brightness.light), sha);
    expect(bg.shaFor(Brightness.dark), sha, reason: '没有 imageDark 时深色也用同一张');
    expect(bg.fit, BackgroundFit.tile);
    expect(bg.align, Alignment.bottomLeft);
    expect(bg.blur, 40, reason: '超出范围按 40 算');
    expect(bg.scrimColor, const Color(0xFF000000));
    expect(bg.scope, {'main', 'picker'});
    expect(bg.accentFromImage, isTrue);

    final back = parseTheme(jsonEncode(themeToJson(s)), base: AppThemeSpec.standard);
    expect(back.scenery, isFalse);
    expect(back.background!.image, 'user:$sha');
    expect(back.background!.alignName, 'bottomLeft');
    expect(back.background!.scrimOpacity, 0.4);
    expect(back.background!.surfaceOpacity, 0.7);

    expect(parseTheme({'schema': 1, 'id': 'x', 'background': {'fit': 'cover'}}).background, isNull,
        reason: '没写图片就是没有背景图');
    expect(pixelTheme.scenery, isTrue);
  });

  test('只改强调色：其余从 base 补齐', () {
    final s = parseTheme({
      'schema': 1,
      'id': 'mint',
      'base': 'pixel',
      'modes': {
        'dark': {'accent': '#FF8A5B'},
      },
    });
    expect(s.id, 'mint');
    expect(s.dark.accent, const Color(0xFFFF8A5B));
    expect(s.dark.background, pixelTheme.dark.background);
    expect(s.light.accent, pixelTheme.light.accent);
    expect(s.shape.corner, CornerStyle.pixel);
    expect(s.typography.family, 'FusionPixel');
  });

  test('改回系统字体时等宽字体也跟着回到系统的', () {
    final s = parseTheme({
      'base': 'pixel',
      'typography': {'family': null, 'sizes': []},
    });
    expect(s.typography.family, isNull);
    expect(s.typography.mono, monoFamily);
  });

  test('格式不对时报错', () {
    expect(() => parseColor('#12345'), throwsFormatException);
    expect(() => parseTheme({'typography': {'family': 'Comic Sans'}}), throwsFormatException);
    expect(parseColor('#80FFFFFF'), const Color(0x80FFFFFF));
    expect(formatColor(const Color(0x80FFFFFF)), '#80FFFFFF');
    expect(formatColor(const Color(0xFF3DDC97)), '#3DDC97');
  });
}
