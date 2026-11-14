import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'gen/pasteferry/v1/daemon.pb.dart' as pb;
import 'gen/pasteferry/v1/daemon.pbgrpc.dart' show DaemonServiceClient;
import 'icons.dart';
import 'l10n/app_localizations.dart';
import 'theme.dart';
import 'scrim.dart';
import 'theme_json.dart';
import 'style_themes.dart';

/// 一个窗口要画的背景：设置、取到的图片与分析结果
class Backdrop {
  const Backdrop({
    required this.background,
    required this.sharp,
    required this.blurred,
    required this.info,
    required this.minScrim,
  });

  final ThemeBackground background;
  final Uint8List? sharp;
  final Uint8List? blurred;
  final pb.BackgroundInfo info;

  /// 遮罩至少多浓，文字才看得清（见 scrim.dart）；遮罩「自动」就用它
  final double minScrim;

  /// 实际显示的遮罩浓度：比 [minScrim] 淡时按 [minScrim]
  double get scrimOpacity => math.max(background.scrimOpacity ?? minScrim, minScrim).clamp(0.0, 1.0);

  @override
  bool operator ==(Object other) =>
      other is Backdrop &&
      identical(other.background, background) &&
      identical(other.sharp, sharp) &&
      identical(other.blurred, blurred) &&
      identical(other.info, info) &&
      other.minScrim == minScrim;

  @override
  int get hashCode => Object.hash(background, sharp, blurred, info, minScrim);
}

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
    final translated = names.isEmpty ? styleThemeNames[id] ?? names : names;
    return translated[lang] ??
        translated[lang == 'zh' ? 'zh-Hans' : lang] ??
        translated[lang.split('-').first] ??
        translated['en'] ??
        translated.values.firstOrNull ??
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

  AppThemeSpec get spec {
    final s = AppThemeSpec.builtins[id] ?? _custom[id] ?? AppThemeSpec.standard;
    final bg = s.background;
    if (bg == null || !bg.accentFromImage) return s;
    AppPalette pick(AppPalette p, Brightness b) {
      final colors = _infos[bg.shaFor(b)]?.colors ?? const <String>[];
      if (colors.isEmpty) return p;
      final accent = parseColor(colors.first);
      // 强调色上的字取黑或白，哪个对比度高用哪个
      final l = accent.computeLuminance();
      return p.withAccent(accent, (l + 0.05) / 0.05 > 1.05 / (l + 0.05) ? Colors.black : Colors.white);
    }

    return AppThemeSpec(
      id: s.id,
      light: pick(s.light, Brightness.light),
      dark: pick(s.dark, Brightness.dark),
      shape: s.shape,
      typography: s.typography,
      motion: s.motion,
      pixelIcons: s.pixelIcons,
      artwork: s.artwork,
      scenery: s.scenery,
      scene: s.scene,
      background: bg,
    );
  }

  ThemeMode get mode => switch (_mode) {
        pb.ThemeMode.THEME_MODE_LIGHT => ThemeMode.light,
        pb.ThemeMode.THEME_MODE_DARK => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  bool get scanlines => _scanlines;

  // ── 背景图（design/themes.md 第 7 节）：图片和分析结果按 sha256 从后台服务取来缓存 ──

  final _images = <String, Uint8List>{};
  final _infos = <String, pb.BackgroundInfo>{};
  final _fetching = <String>{};

  /// 当前主题的背景设置；没有背景图时为 null
  ThemeBackground? get background => spec.background;

  /// 已导入的图片的分析结果；还没取到时为 null（会去取）
  pb.BackgroundInfo? backgroundInfo(String sha) {
    final info = _infos[sha];
    if (info == null) _fetch(sha, blurred: false);
    return info;
  }

  /// [window]（main、picker、mobile）在 [brightness] 模式下要画的背景；没有背景图、
  /// 这个窗口不显示、或者图片还没取到时为 null
  Backdrop? backdrop(Brightness brightness, String window, AppPalette palette) {
    final bg = background;
    if (bg == null || !bg.scope.contains(window)) return null;
    final sha = bg.shaFor(brightness);
    if (sha == null) return null;
    // 模糊不在运行时做：0 是原图，20 及以上是后台服务算好的模糊版，中间两张叠起来渐变
    final sharp = bg.blur < 20 ? _image(sha, blurred: false) : null;
    final blurred = bg.blur > 0 ? _image(sha, blurred: true) : null;
    final info = backgroundInfo(sha);
    if ((bg.blur < 20 && sharp == null) || (bg.blur > 0 && blurred == null) || info == null) return null;
    // 按显示出来的那张算：有原图用原图（细节最多），全模糊时用模糊版
    final shown = sharp != null ? sha : '$sha.blur';
    final sample = _samples[shown];
    if (sample == null) {
      _sample(shown, (sharp ?? blurred)!);
      return null;
    }
    final scrim = bg.scrimColor ?? palette.background;
    final key = '$shown ${scrim.toARGB32()} ${palette.text.toARGB32()} ${palette.textDim.toARGB32()} '
        '${palette.surface.toARGB32()} ${palette.sidebar.toARGB32()} ${bg.surfaceOpacity}';
    final min = _minScrims[key] ??=
        minScrim(sample, scrim: scrim, palette: palette, surfaceOpacity: bg.surfaceOpacity);
    return Backdrop(background: bg, sharp: sharp, blurred: blurred, info: info, minScrim: min);
  }

  /// 风景换成的图（[part] 是 header 或 sidebar）；没换、或者还没取到时为 null
  Uint8List? sceneImage(String part, Brightness brightness) {
    final sha = spec.scene?.shaFor(part, brightness);
    return sha == null ? null : _image(sha, blurred: false);
  }

  /// 页眉图上的遮罩至少多浓，页面标题、说明才看得清；图片还没取到时为 null
  double? sceneScrim(Brightness brightness, AppPalette palette) {
    final sha = spec.scene?.shaFor('header', brightness);
    final bytes = sha == null ? null : _images[sha];
    if (bytes == null) return null;
    final sample = _samples[sha];
    if (sample == null) {
      _sample(sha!, bytes);
      return null;
    }
    final key = 'scene $sha ${palette.background.toARGB32()} ${palette.text.toARGB32()} ${palette.textDim.toARGB32()}';
    return _minScrims[key] ??= minScrim(sample, scrim: palette.background, palette: palette, surfaceOpacity: 1);
  }

  final _samples = <String, Uint8List>{};
  final _minScrims = <String, double>{};

  void _sample(String key, Uint8List bytes) {
    if (!_fetching.add('sample $key')) return;
    sampleImage(bytes).then((s) {
      _samples[key] = s;
      notifyListeners();
    }).catchError((Object _) {}).whenComplete(() => _fetching.remove('sample $key'));
  }

  Uint8List? _image(String sha, {required bool blurred}) {
    final img = _images[blurred ? '$sha.blur' : sha];
    if (img == null) _fetch(sha, blurred: blurred);
    return img;
  }

  void _fetch(String sha, {required bool blurred}) {
    final client = _client;
    final key = blurred ? '$sha.blur' : sha;
    if (client == null || !_fetching.add(key)) return;
    () async {
      try {
        if (!_infos.containsKey(sha)) _infos[sha] = await client.analyzeBackground(pb.BackgroundRef(sha256: sha));
        if (!_images.containsKey(key)) {
          final res = await client.getBackground(pb.GetBackgroundRequest(sha256: sha, blurred: blurred));
          _images[key] = Uint8List.fromList(res.data);
        }
        // 「用图片配色」要等分析结果：强调色变了，ThemeData 要重建
        if (spec.background?.accentFromImage ?? false) revision++;
        notifyListeners();
      } catch (_) {
        // 图片被删了或后台服务没连上：不显示背景，下次再试
      } finally {
        _fetching.remove(key);
      }
    }();
  }

  /// 导入一张图片作背景，返回它的分析结果（sha256 在里面）
  Future<pb.BackgroundInfo> importBackground(String path) async {
    final info = await _client!.importBackground(pb.ImportBackgroundRequest(path: path));
    _infos[info.sha256] = info;
    return info;
  }

  /// 改当前这套自定义主题的背景与场景：[edit] 拿到主题的原始 JSON（没合并 base）就地修改，
  /// 改完保存。换下来的旧图没有主题再用时一并删掉
  Future<pb.PutThemeResponse> editCurrent(void Function(Map<String, dynamic> json) edit) async {
    final m = jsonDecode(await exportJson(id, resolved: false)) as Map<String, dynamic>;
    final before = _refs(m);
    edit(m);
    final res = await save(jsonEncode(m));
    _custom.remove(id);
    await _load(id);
    _changed();
    for (final sha in before.difference(_refs(m))) {
      try {
        await _client!.deleteBackground(pb.BackgroundRef(sha256: sha));
      } catch (_) {
        // 别的主题还在用这张图
      }
    }
    return res;
  }

  /// 改背景、场景前调用：正在用的是自带主题（不能改）时先复制一份并换上，返回副本的名字；
  /// 本来就是自定义主题时返回 null
  Future<String?> ensureEditable(AppLocalizations l) async {
    final current = _themes.where((t) => t.id == id).firstOrNull;
    if (current != null && !current.builtin) return null;
    final from = current ?? _themes.first;
    final newId = await duplicate(from, l.themeCopyName, l);
    await select(newId);
    return _themes.where((t) => t.id == newId).firstOrNull?.displayName(l) ?? newId;
  }

  /// 用 [path] 这张图作当前主题的背景（两种模式同一张），返回 [ensureEditable] 的结果
  Future<String?> setBackgroundImage(String path, AppLocalizations l) async {
    final info = await importBackground(path);
    final copied = await ensureEditable(l);
    await editCurrent((m) {
      final bg = (m['background'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
      bg['image'] = 'user:${info.sha256}';
      bg.remove('imageDark');
      m['background'] = bg;
    });
    return copied;
  }

  /// 改当前主题的 background 里的几项（模糊、遮罩、面板、范围……）
  Future<void> editBackground(void Function(Map<String, dynamic> bg) edit) => editCurrent((m) {
        final bg = (m['background'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
        edit(bg);
        m['background'] = bg;
      });

  Future<void> removeBackground() => editCurrent((m) => m.remove('background'));

  /// 用 [path] 这张图换掉风景的 [part]（header 或 sidebar），两种模式同一张；返回 [ensureEditable] 的结果
  Future<String?> setSceneImage(String part, String path, AppLocalizations l) async {
    final info = await importBackground(path);
    final copied = await ensureEditable(l);
    await editCurrent((m) {
      final scene = (m['scene'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
      scene[part] = 'user:${info.sha256}';
      scene.remove('${part}Dark');
      m['scene'] = scene;
      m['scenery'] = true;
    });
    return copied;
  }

  /// 风景的 [part] 恢复成主题原来的样子（像素主题是像素风景）
  Future<void> resetSceneImage(String part) => editCurrent((m) {
        final scene = (m['scene'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
        scene
          ..remove(part)
          ..remove('${part}Dark');
        scene.isEmpty ? m.remove('scene') : m['scene'] = scene;
      });

  /// 像素风景开关，返回 [ensureEditable] 的结果
  Future<String?> setScenery(bool on, AppLocalizations l) async {
    final copied = await ensureEditable(l);
    await editCurrent((m) => m['scenery'] = on);
    return copied;
  }

  static Set<String> _refs(Map<String, dynamic> theme) {
    final bg = (theme['background'] as Map?) ?? const {};
    final scene = (theme['scene'] as Map?) ?? const {};
    return {
      for (final v in [bg['image'], bg['imageDark'], ...scene.values])
        if (v is String && v.startsWith('user:')) v.substring(5),
    };
  }

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

  /// 测试与截图用：直接填入背景图与分析结果。要真的解码图片，在测试里放进 tester.runAsync
  @visibleForTesting
  Future<void> debugSeedBackground(String sha, Uint8List image, pb.BackgroundInfo info, {Uint8List? blurred}) async {
    _images[sha] = image;
    _images['$sha.blur'] = blurred ?? image;
    _infos[sha] = info;
    _samples[sha] = await sampleImage(image);
    _samples['$sha.blur'] = await sampleImage(blurred ?? image);
    revision++;
    notifyListeners();
  }

  Future<void> delete(String themeId) async {
    await _client!.deleteTheme(pb.ThemeRef(id: themeId));
    _custom.remove(themeId);
    await refreshList();
  }
}
