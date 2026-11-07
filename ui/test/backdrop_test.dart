import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart' as pb;
import 'package:pasteferry_ui/pixel_art.dart';
import 'package:pasteferry_ui/pixel_theme.dart';
import 'package:pasteferry_ui/scrim.dart';
import 'package:pasteferry_ui/theme.dart';
import 'package:pasteferry_ui/theme_controller.dart';
import 'package:pasteferry_ui/theme_json.dart';
import 'package:pasteferry_ui/widgets/backdrop.dart';

// 1×1 的 PNG
final _png = Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0xF8,
  0xCF,
  0xC0,
  0xF0,
  0x1F,
  0x00,
  0x05,
  0x00,
  0x01,
  0xFF,
  0x89,
  0x99,
  0x3D,
  0x1D,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

final _sha = 'b' * 64;

AppThemeSpec _photo({double blur = 0, List<String> scope = const ['main', 'mobile'], bool accent = false}) =>
    parseTheme({
      'schema': 1,
      'id': 'photo',
      'base': 'pixel',
      'background': {
        'image': 'user:$_sha',
        'blur': blur,
        'surfaceOpacity': 0.7,
        'scope': scope,
        'accentFromImage': accent,
      },
    });

Future<ThemeController> _controller(WidgetTester? tester, AppThemeSpec spec) async {
  final c = ThemeController()
    ..debugSeed(
      themes: [ThemeChoice(id: spec.id, names: const {}, builtin: false, spec: spec)],
      id: spec.id,
    );
  final info = pb.BackgroundInfo(sha256: _sha, colors: ['#FFE066']);
  tester == null
      ? await c.debugSeedBackground(_sha, _png, info)
      : await tester.runAsync(() => c.debugSeedBackground(_sha, _png, info));
  return c;
}

Widget _app(ThemeController c, String window, Widget child) => MaterialApp(
  theme: buildTheme(Brightness.dark, spec: c.spec),
  home: ThemedBackdrop(controller: c, window: window, child: child),
);

void main() {
  testWidgets('有背景图：铺图、加遮罩，面板半透明，像素风景不画', (tester) async {
    final c = await _controller(tester, _photo());
    late BuildContext inner;
    await tester.pumpWidget(
      _app(
        c,
        'main',
        Builder(
          builder: (context) {
            inner = context;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(find.byType(Image), findsOneWidget);
    // 图是纯白，深色主题的浅色字要靠遮罩压暗：遮罩是 background 色，浓度是算出来的下限
    final scrim = tester.widget<ColoredBox>(
      find.descendant(of: find.byType(ThemedBackdrop), matching: find.byType(ColoredBox)).first,
    );
    final min = c.backdrop(Brightness.dark, 'main', pixelTheme.dark)!.minScrim;
    expect(min, greaterThan(0.5));
    expect(scrim.color.a, closeTo(min, 0.01));
    expect(inner.panel(const Color(0xFF202020)).a, closeTo(0.7, 0.01));
    expect(inner.showScenery, isFalse);
    expect(Theme.of(inner).scaffoldBackgroundColor, Colors.transparent);
  });

  testWidgets('模糊在 0 到 20 之间：原图上叠模糊版', (tester) async {
    await tester.pumpWidget(_app(await _controller(tester, _photo(blur: 10)), 'main', const SizedBox()));
    expect(find.byType(Image), findsNWidgets(2));
    await tester.pumpWidget(_app(await _controller(tester, _photo(blur: 30)), 'main', const SizedBox()));
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('scope 里没有这个窗口时不显示，像素风景照常', (tester) async {
    late BuildContext inner;
    await tester.pumpWidget(
      _app(
        await _controller(tester, _photo()),
        'picker',
        Builder(
          builder: (context) {
            inner = context;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(find.byType(Image), findsNothing);
    expect(inner.panel(const Color(0xFF202020)).a, 1);
    expect(inner.showScenery, isTrue);
  });

  testWidgets('用图片配色：强调色取图片主色，上面的字取对比度高的黑或白', (tester) async {
    final p = (await _controller(tester, _photo(accent: true))).spec.dark;
    expect(p.accent, const Color(0xFFFFE066));
    expect(p.onAccent, Colors.black);
    expect(p.background, pixelTheme.dark.background);
  });

  test('遮罩下限：深色图上浅色主题的字要靠浅色遮罩，同色系的图不用遮罩', () {
    final light = pixelTheme.light;
    final dark = pixelTheme.dark;
    final onDark = minScrim(_solid(30, 20, 50), scrim: light.background, palette: light, surfaceOpacity: 0.85);
    expect(onDark, greaterThan(0.7));
    expect(minScrim(_solid(250, 250, 248), scrim: light.background, palette: light, surfaceOpacity: 0.85), 0);
    expect(minScrim(_solid(17, 18, 21), scrim: dark.background, palette: dark, surfaceOpacity: 0.85), 0);
    // 遮罩颜色和字一样深，铺满也看不清
    expect(minScrim(_solid(20, 20, 20), scrim: light.text, palette: light, surfaceOpacity: 1), 1);
  });

  testWidgets('风景换成自己的图：页眉画图加遮罩，没换的侧边栏仍是像素营地', (tester) async {
    final spec = parseTheme({
      'schema': 1,
      'id': 'scene',
      'base': 'pixel',
      'scene': {'header': 'user:$_sha'},
    });
    final c = await _controller(tester, spec);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(Brightness.dark, spec: c.spec),
        home: Column(
          children: [
            SceneHeader(controller: c),
            SceneSidebar(controller: c),
          ],
        ),
      ),
    );
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(PixelScene), findsNothing);
    expect(find.byType(PixelCamp), findsOneWidget);
  });
}

Uint8List _solid(int r, int g, int b) => Uint8List.fromList([
  for (var i = 0; i < 16; i++) ...[r, g, b, 255],
]);
