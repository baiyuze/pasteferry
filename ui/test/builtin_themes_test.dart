import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:pasteferry_ui/theme.dart';
import 'package:pasteferry_ui/theme_json.dart';

/// 自带主题在两处定义：界面里的 AppThemeSpec.builtins，与后台服务校验、合并用的
/// client-core/internal/theme/builtin/ 下的 JSON。两边必须一致，改了一边就要改另一边。
void main() {
  final dir = Directory('../client-core/internal/theme/builtin');

  test('每个自带主题两边都有', () {
    final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));
    final ids = files.map((f) => f.uri.pathSegments.last.replaceAll('.json', '')).toSet();
    expect(ids, AppThemeSpec.builtins.keys.toSet());
  });

  for (final MapEntry(key: id, value: spec) in AppThemeSpec.builtins.entries) {
    test('自带主题 $id 与后台服务的定义一致', () {
      final json = File('${dir.path}/$id.json').readAsStringSync();
      // 用一个和谁都不一样的底，确保每个字段都是 JSON 里写的
      final parsed = parseTheme(json, base: AppThemeSpec.standard);
      final want = themeToJson(spec);
      final got = themeToJson(parsed);
      expect(got['modes'], want['modes'], reason: '颜色');
      expect(got['shape'], want['shape'], reason: '形状');
      expect(got['typography'], want['typography'], reason: '字体');
      expect(got['motion'], want['motion'], reason: '动效');
      expect(got['icons'], want['icons'], reason: '图标');
    });
  }
}
