import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pasteferry_ui/icons.dart';
import 'package:pasteferry_ui/pixel_theme.dart';
import 'package:pasteferry_ui/theme.dart';
import 'package:pasteferry_ui/widgets/common.dart';

/// 直角、无投影、逐帧动画的主题：检查页面与控件跟着主题走，而不是写死默认值
const _square = AppThemeSpec(
  id: 'square',
  light: AppPalette.light,
  dark: AppPalette.dark,
  shape: AppShape(sm: 0, md: 0, lg: 0, shadow: ShadowStyle.none),
  motion: AppMotion(style: MotionStyle.stepped, steps: 4),
);

void main() {
  test('默认主题保持原来的配色与圆角', () {
    for (final b in Brightness.values) {
      final t = buildTheme(b);
      final p = t.extension<AppPalette>()!;
      expect(p, same(b == Brightness.dark ? AppPalette.dark : AppPalette.light));
      expect(t.colorScheme.onPrimary, Colors.white);
      expect(t.snackBarTheme.backgroundColor, b == Brightness.dark ? const Color(0xFF3A3A3C) : const Color(0xFF2C2C2E));
      expect(t.dialogTheme.elevation, 18);
      expect(t.extension<AppShape>()!.md, Radii.md);
      final shape = t.filledButtonTheme.style!.shape!.resolve({}) as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(Radii.sm));
    }
  });

  test('默认主题的投影与动效原样返回', () {
    const shape = AppShape.standard;
    expect(shape.scaled(3), 3);
    expect(shape.shadows(const Color(0x14000000), blur: 8, offset: const Offset(0, 2)),
        [const BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))]);
    const motion = AppMotion.standard;
    expect(motion.curve(Curves.easeOut), same(Curves.easeOut));
    expect(motion.duration(const Duration(milliseconds: 120)), const Duration(milliseconds: 120));
  });

  test('直角主题：控件圆角为 0，没有投影', () {
    final t = buildTheme(Brightness.light, spec: _square);
    final shape = t.filledButtonTheme.style!.shape!.resolve({}) as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.zero);
    expect(t.dialogTheme.elevation, 0);
    expect(_square.shape.scaled(9), 0);
    expect(_square.shape.shadows(const Color(0x14000000), blur: 8, offset: const Offset(0, 2)), isEmpty);
  });

  test('逐帧动画把曲线量化成几档，起点终点不变', () {
    final c = _square.motion.curve(Curves.linear);
    expect(c.transform(0), 0);
    expect(c.transform(0.3), 0.25);
    expect(c.transform(0.6), 0.5);
    expect(c.transform(1), 1);
    expect(const AppMotion(style: MotionStyle.reduced).duration(const Duration(milliseconds: 260)), Duration.zero);
  });

  test('主题之间可以过渡', () {
    final mid = AppShape.standard.lerp(_square.shape, 0.5);
    expect(mid.md, Radii.md / 2);
    expect(mid.shadow, ShadowStyle.none);
    final p = AppPalette.light.lerp(AppPalette.dark, 1);
    expect(p.inverse, AppPalette.dark.inverse);
  });

  testWidgets('分段控件按主题画圆角与投影', (tester) async {
    Future<BoxDecoration> selectedDecoration(AppThemeSpec spec) async {
      await tester.pumpWidget(MaterialApp(
        theme: buildTheme(Brightness.light, spec: spec),
        home: Scaffold(
          body: Segmented<int>(value: 0, segments: const [(0, 'A'), (1, 'B')], onChanged: (_) {}),
        ),
      ));
      await tester.pumpAndSettle();
      final box = tester.widget<AnimatedContainer>(find.ancestor(of: find.text('A'), matching: find.byType(AnimatedContainer)));
      return box.decoration! as BoxDecoration;
    }

    final standard = await selectedDecoration(AppThemeSpec.standard);
    expect(standard.borderRadius, BorderRadius.circular(5));
    expect(standard.boxShadow, hasLength(1));

    final square = await selectedDecoration(_square);
    expect(square.borderRadius, BorderRadius.zero);
    expect(square.boxShadow, isEmpty);
  });

  test('像素主题：点阵字体、切角粗边、硬投影', () {
    final t = buildTheme(Brightness.light, spec: pixelTheme);
    expect(t.textTheme.bodyMedium!.fontFamily, 'FusionPixel');
    expect(t.extension<AppTypography>()!.mono, 'FusionPixelMono');
    final shape = t.filledButtonTheme.style!.shape!.resolve({});
    expect(shape, isA<PixelBorder>());
    expect(t.dividerTheme.thickness, 2);
  });

  test('像素主题：按钮凸起、按下凹进，只有浮层有投影', () {
    final t = buildTheme(Brightness.dark, spec: pixelTheme);
    final p = pixelTheme.dark;
    final shape = t.filledButtonTheme.style!.shape!;
    final up = shape.resolve({}) as PixelBorder;
    final down = shape.resolve({WidgetState.pressed}) as PixelBorder;
    expect((up.topLeft, up.bottomRight), (p.bevelLight, p.bevelDark));
    expect((down.topLeft, down.bottomRight), (p.bevelDark, p.bevelLight));
    expect((t.dialogTheme.shape! as PixelBorder).drop, p.shadow);
    // 悬停预览这类大投影是错开两格的实心投影，按钮、节点的小投影不画
    final s = t.extension<AppShape>()!;
    final big = s.shadows(const Color(0x26000000), blur: 16, offset: const Offset(0, 4)).single;
    expect((big.blurRadius, big.offset, big.color), (0, const Offset(4, 4), p.shadow));
    expect(s.shadows(const Color(0x14000000), blur: 8, offset: const Offset(0, 2)), isEmpty);
    // 默认主题：强边框就是普通边框，没有斜面
    expect(AppPalette.dark.borderStrong, AppPalette.dark.border);
  });

  test('字号吸附到点阵字号上，系统缩放先算进去', () {
    const s = SnapTextScaler(TextScaler.noScaling, [12, 24]);
    expect(s.scale(11), 12);
    expect(s.scale(15), 12);
    expect(s.scale(22), 24);
    expect(const SnapTextScaler(TextScaler.linear(2), [12, 24]).scale(13), 24);
  });

  test('像素角切掉台阶，放不下时少切几级', () {
    const rect = Rect.fromLTWH(0, 0, 40, 20);
    final one = const PixelBorder(unit: 2).getOuterPath(rect);
    expect(one.contains(const Offset(0.5, 0.5)), isFalse); // 角上缺一格
    expect(one.contains(const Offset(2.5, 2.5)), isTrue);
    final three = const PixelBorder(unit: 2, steps: 3).getOuterPath(rect);
    expect(three.contains(const Offset(2.5, 2.5)), isFalse);
    expect(three.contains(const Offset(6.5, 6.5)), isTrue);
    // 6px 的点只够切一级
    final dot = const PixelBorder(unit: 2, steps: 3).getOuterPath(const Rect.fromLTWH(0, 0, 6, 6));
    expect(dot.contains(const Offset(2.5, 2.5)), isTrue);
  });

  test('图标随主题换成像素图标', () {
    addTearDown(() => AppIcons.pixel = false);
    final normal = AppIcons.gear;
    AppIcons.pixel = true;
    expect(AppIcons.gear, PixelIcons.gear);
    expect(AppIcons.gear, isNot(normal));
  });
}
