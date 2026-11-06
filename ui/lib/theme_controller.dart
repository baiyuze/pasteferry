import 'dart:convert';

import 'package:flutter/material.dart';

import 'gen/pasteferry/v1/daemon.pb.dart' as pb;
import 'gen/pasteferry/v1/daemon.pbgrpc.dart' show DaemonServiceClient;
import 'icons.dart';
import 'l10n/app_localizations.dart';
import 'theme.dart';
import 'theme_json.dart';

/// 「外观」里的一项主题：软件自带的或自定义的
class ThemeChoice {
  const ThemeChoice({required this.id, required this.names, required this.builtin, required this.spec});

  final String id;

  /// 界面语言代码到名字，比如 {'zh-Hans': '像素', 'en': 'Pixel'}
  final Map<String, String> names;
  final bool builtin;
  final AppThemeSpec spec;

  String displayName(AppLocalizations l) {
    if (id == 'default') return l.themeDefault;
    if (id == 'pixel') return l.themePixel;
    final lang = l.localeName.replaceAll('_', '-');
    return names[lang] ??
        names[lang == 'zh' ? 'zh-Hans' : lang] ??
        names[lang.split('-').first] ??
        names['en'] ??
        names.values.firstOrNull ??
        id;
  }
}

/// 现在用的主题与主题列表。主窗口、快捷粘贴窗口、手机 App 各有一个，数据都来自后台服务：
/// 配置里的 theme_id、theme_mode、theme_scanlines 决定用哪套，自定义主题的内容按需取来解析。
///
/// 配置变了（configChanged）或主题内容变了（themesChanged）时刷新，所有窗口一起换。
class ThemeController extends ChangeNotifier {
  DaemonServiceClient? _client;
  String _id = '';
  pb.ThemeMode _mode = pb.ThemeMode.THEME_MODE_UNSPECIFIED;
  bool _scanlines = false;
  List<ThemeChoice> _themes = [
    for (final e in AppThemeSpec.builtins.entries) ThemeChoice(id: e.key, names: const {}, builtin: true, spec: e.value),
  ];
  final _custom = <String, AppThemeSpec>{};

  /// 每换一次主题加一；界面按它决定要不要重建缓存的 ThemeData
  int revision = 0;

  /// 现在的主题 id；默认主题是 'default'
  String get id => _id.isEmpty ? 'default' : _id;

  AppThemeSpec get spec => AppThemeSpec.builtins[id] ?? _custom[id] ?? AppThemeSpec.standard;

  ThemeMode get mode => switch (_mode) {
        pb.ThemeMode.THEME_MODE_LIGHT => ThemeMode.light,
        pb.ThemeMode.THEME_MODE_DARK => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  bool get scanlines => _scanlines;

  List<ThemeChoice> get themes => _themes;

  /// 连上后台服务后调用：取主题列表，配置里指定的自定义主题也取来
  Future<void> attach(DaemonServiceClient client, pb.Config config) async {
    _client = client;
    await refreshList();
    await applyConfig(config);
  }

  void detach() => _client = null;

  /// 配置变了：换主题、深浅模式或扫描线
  Future<void> applyConfig(pb.Config config) async {
    final changed = config.themeId != _id || config.themeMode != _mode || config.themeScanlines != _scanlines;
    _id = config.themeId;
    _mode = config.themeMode;
    _scanlines = config.themeScanlines;
    if (!AppThemeSpec.builtins.containsKey(id) && !_custom.containsKey(id)) await _load(id);
    if (changed) _changed();
  }

  /// 有主题被保存或删掉：重新取列表，正在用的那套内容也重新取
  Future<void> onThemesChanged(pb.ThemesChanged ev) async {
    for (final i in ev.ids) {
      _custom.remove(i);
    }
    await refreshList();
    if (ev.ids.contains(id) || ev.ids.isEmpty) _changed();
  }

  Future<void> refreshList() async {
    final client = _client;
    if (client == null) return;
    try {
      final res = await client.listThemes(pb.Empty());
      final list = <ThemeChoice>[];
      for (final t in res.themes) {
        final spec = AppThemeSpec.builtins[t.id] ?? _custom[t.id] ?? await _load(t.id);
        if (spec == null) continue;
        list.add(ThemeChoice(id: t.id, names: Map.of(t.name), builtin: t.builtin, spec: spec));
      }
      if (list.isNotEmpty) _themes = list;
      notifyListeners();
    } catch (_) {
      // 旧版后台服务没有主题接口：只有自带的主题
    }
  }

  Future<AppThemeSpec?> _load(String themeId) async {
    final client = _client;
    if (client == null || AppThemeSpec.builtins.containsKey(themeId)) return AppThemeSpec.builtins[themeId];
    try {
      final res = await client.getTheme(pb.GetThemeRequest(id: themeId, resolved: true));
      return _custom[themeId] = parseTheme(res.json, base: AppThemeSpec.standard);
    } catch (_) {
      return null;
    }
  }

  void _changed() {
    revision++;
    final icons = spec.pixelIcons;
    notifyListeners();
    if (AppIcons.pixel != icons) {
      AppIcons.pixel = icons;
      // 图标是页面直接取的，不随 Theme 变：整棵树重建一遍，页面状态（当前在哪一页）不丢
      WidgetsBinding.instance.addPostFrameCallback((_) {
        void mark(Element e) {
          e.markNeedsBuild();
          e.visitChildren(mark);
        }

        WidgetsBinding.instance.rootElement?.visitChildren(mark);
      });
    }
  }

  // ── 修改：都经后台服务，结果由事件推回来 ──

  Future<pb.Config> _update(pb.Config Function(pb.Config) edit) async {
    final client = _client!;
    final cfg = await client.getConfig(pb.Empty());
    return client.updateConfig(edit(cfg));
  }

  Future<void> select(String themeId) async {
    final cfg = await _update((c) => c..themeId = themeId == 'default' ? '' : themeId);
    await applyConfig(cfg);
  }

  Future<void> setMode(ThemeMode m) async {
    final cfg = await _update((c) => c
      ..themeMode = switch (m) {
        ThemeMode.light => pb.ThemeMode.THEME_MODE_LIGHT,
        ThemeMode.dark => pb.ThemeMode.THEME_MODE_DARK,
        ThemeMode.system => pb.ThemeMode.THEME_MODE_UNSPECIFIED,
      });
    await applyConfig(cfg);
  }

  Future<void> setScanlines(bool on) async {
    final cfg = await _update((c) => c..themeScanlines = on);
    await applyConfig(cfg);
  }

  /// 保存一份主题 JSON，返回它的 id 与对比度警告。格式不对时后台服务报错，消息可以直接给用户看
  Future<pb.PutThemeResponse> save(String json) async {
    final res = await _client!.putTheme(pb.PutThemeRequest(json: json));
    _custom.remove(res.id);
    await refreshList();
    return res;
  }

  /// 主题的原始 JSON（导出用）。[resolved] 时合并 base，得到能单独使用的完整主题
  Future<String> exportJson(String themeId, {bool resolved = true}) async {
    final res = await _client!.getTheme(pb.GetThemeRequest(id: themeId, resolved: resolved));
    return const JsonEncoder.withIndent('  ').convert(jsonDecode(res.json));
  }

  /// 以 [from] 为底新建一份自定义主题，返回新主题的 id
  Future<String> duplicate(ThemeChoice from, String Function(String name) copyName, AppLocalizations l) async {
    final taken = _themes.map((t) => t.id).toSet();
    var n = 1;
    String newId() => n == 1 ? '${from.id}-copy' : '${from.id}-copy-$n';
    while (taken.contains(newId())) {
      n++;
    }
    final m = jsonDecode(await exportJson(from.id)) as Map<String, dynamic>;
    final name = copyName(from.displayName(l));
    m
      ..['id'] = newId()
      ..['base'] = from.builtin ? from.id : (m['base'] ?? 'default')
      ..['name'] = {for (final lang in const ['zh-Hans', 'zh-Hant-TW', 'zh-Hant-HK', 'en', 'ja']) lang: name};
    await save(jsonEncode(m));
    return newId();
  }

  /// 测试与截图用：直接填入主题列表与当前主题，不连接后台服务
  @visibleForTesting
  void debugSeed({List<ThemeChoice>? themes, String? id}) {
    if (themes != null) {
      _themes = themes;
      for (final t in themes) {
        if (!t.builtin) _custom[t.id] = t.spec;
      }
    }
    if (id != null) _id = id == 'default' ? '' : id;
    notifyListeners();
  }

  Future<void> delete(String themeId) async {
    await _client!.deleteTheme(pb.ThemeRef(id: themeId));
    _custom.remove(themeId);
    await refreshList();
  }
}
