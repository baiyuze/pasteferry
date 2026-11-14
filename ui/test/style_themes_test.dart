import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasteferry_ui/style_themes.dart';
import 'package:pasteferry_ui/theme.dart';
import 'package:pasteferry_ui/theme_artwork.dart';
import 'package:pasteferry_ui/theme_json.dart';
import 'package:pasteferry_ui/mobile/mobile_app.dart';

void main() {
  for (final entry in styleThemes.entries) {
    test('exporting ${entry.key} retains its design and valid system fonts', () {
      final data = themeToJson(entry.value);
      final typography = data['typography']! as Map;
      expect(typography['mono'], anyOf('system', 'FusionPixelMono'));
      final copy = parseTheme(jsonEncode(data));
      expect(copy.artwork, entry.value.artwork);
      expect(copy.typography.heading, entry.value.typography.heading);
      expect(copy.shape.corner, entry.value.shape.corner);
    });

    for (final brightness in Brightness.values) {
      testWidgets('${entry.key} $brightness retains its design on Android', (tester) async {
        final theme = buildMobileTheme(brightness, spec: entry.value);
        await tester.pumpWidget(MaterialApp(theme: theme,
          home: Scaffold(body: Column(children: [
            Text('Settings / 设置 / الإعدادات', style: theme.textTheme.headlineMedium),
            const DesignArtwork(height: 112),
            const TextField(),
            FilledButton(onPressed: () {}, child: const Text('Paste / 粘贴')),
          ])),
        ));
        await tester.pump();
        expect(theme.extension<AppArtwork>()!.style, entry.value.artwork);
        expect(theme.textTheme.headlineMedium!.fontFamily, entry.value.typography.heading);
        expect(tester.takeException(), isNull);
      });
      testWidgets('${entry.key} $brightness renders controls and artwork', (tester) async {
        await tester.pumpWidget(MaterialApp(
          theme: buildTheme(brightness, spec: entry.value),
          home: Scaffold(body: Column(children: [
            const DesignArtwork(height: 180),
            const TextField(),
            FilledButton(onPressed: () {}, child: const Text('Paste / 粘贴')),
          ])),
        ));
        await tester.pump();
        await tester.tap(find.byType(FilledButton));
        await tester.pump();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
