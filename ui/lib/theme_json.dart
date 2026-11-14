import 'dart:convert';

import 'package:flutter/material.dart';

import 'theme.dart';

// 主题的 JSON 格式（design/themes.md 第 3 节）与 AppThemeSpec 之间的转换。
//
// 后台服务负责校验、合并 base 链；这里拿到的可能是完整主题，也可能只写了要改的字段：
// 没写的一律从 base（内置主题）补齐，所以只改一个强调色也能用。

/// 颜色角色的名字，与 AppPalette 的字段一一对应
const paletteRoles = [
  'accent', 'background', 'sidebar', 'surface', 'border', 'borderStrong', 'separator', 'text', 'textDim',
  'textFaint', 'selection', 'hover', 'fill', 'online', 'warning', 'danger', 'onAccent', 'inverse', 'onInverse',
  'bevelLight', 'bevelDark', 'shadow',
];

/// 主题可以用的字体：App 自带的，或者跟随系统（null）
const _fonts = {'FusionPixel': 'FusionPixelMono', 'SpaceGrotesk': null};
const _headingFonts = {'FusionPixel', 'BarlowCondensed', 'SpaceGrotesk', 'ArchivoBlack'};

/// 解析一份主题。[json] 可以是字符串或已经解码的 Map；没写的字段从 [base] 补齐，
/// [base] 为空时按 JSON 里的 `base` 取内置主题。格式不对时抛 FormatException。
AppThemeSpec parseTheme(Object json, {AppThemeSpec? base}) {
  final m = (json is String ? jsonDecode(json) : json) as Map<String, dynamic>;
  final b = base ?? AppThemeSpec.byId(m['base'] as String? ?? 'default');
  final modes = (m['modes'] as Map?)?.cast<String, dynamic>() ?? const {};
  final shape = (m['shape'] as Map?)?.cast<String, dynamic>() ?? const {};
  final radius = (shape['radius'] as Map?)?.cast<String, dynamic>() ?? const {};
  final typo = (m['typography'] as Map?)?.cast<String, dynamic>() ?? const {};
  final motion = m['motion'];

  double? num_(Object? v) => (v as num?)?.toDouble();
  T pick<T extends Enum>(List<T> values, Object? name, T fallback) =>
      values.where((v) => v.name == name).firstOrNull ?? fallback;

  // 'system' 与 null 都表示跟随系统
  String? font(Object? v) => v == null || v == 'system' ? null : v as String;
  final family = typo.containsKey('family') ? font(typo['family']) : b.typography.family;
  final heading = typo.containsKey('heading') ? font(typo['heading']) : b.typography.heading;
  if (heading != null && !_headingFonts.contains(heading)) throw FormatException('不认识的标题字体：$heading');
  if (family != null && !_fonts.containsKey(family)) throw FormatException('不认识的字体：$family');
  final sizes = (typo['sizes'] as List?)?.map((e) => (e as num).toDouble()).toList() ?? b.typography.sizes;
  final motionMap = motion is Map ? motion.cast<String, dynamic>() : const <String, dynamic>{};
  final motionStyle = motion is String ? motion : motionMap['style'];

  return AppThemeSpec(
    id: m['id'] as String? ?? b.id,
    light: _palette(modes['light'], b.light),
    dark: _palette(modes['dark'], b.dark),
    shape: AppShape(
      sm: num_(radius['sm']) ?? b.shape.sm,
      md: num_(radius['md']) ?? b.shape.md,
      lg: num_(radius['lg']) ?? b.shape.lg,
      shadow: pick(ShadowStyle.values, shape['shadow'], b.shape.shadow),
      corner: pick(CornerStyle.values, shape['corner'], b.shape.corner),
      borderWidth: num_(shape['borderWidth']) ?? b.shape.borderWidth,
      unit: num_(shape['unit']) ?? b.shape.unit,
    ),
    typography: AppTypography(
      family: family,
      heading: heading,
      mono: typo.containsKey('mono')
          ? font(typo['mono'])
          : (family == b.typography.family ? b.typography.mono : _fonts[family]),
      sizes: sizes,
    ),
    motion: AppMotion(
      style: pick(MotionStyle.values, motionStyle, b.motion.style),
      steps: (motionMap['steps'] as num?)?.toInt() ?? b.motion.steps,
    ),
    pixelIcons: m.containsKey('icons') ? m['icons'] == 'pixel' : b.pixelIcons,
    artwork: pick(ArtworkStyle.values, m['artwork'], b.artwork),
    scenery: m['scenery'] as bool? ?? b.scenery,
    scene: m.containsKey('scene') ? _scene(m['scene']) : b.scene,
    background: m.containsKey('background') ? _background(m['background']) : b.background,
  );
}

const _alignments = {
  'center': Alignment.center,
  'top': Alignment.topCenter,
  'bottom': Alignment.bottomCenter,
  'left': Alignment.centerLeft,
  'right': Alignment.centerRight,
  'topLeft': Alignment.topLeft,
  'topRight': Alignment.topRight,
  'bottomLeft': Alignment.bottomLeft,
  'bottomRight': Alignment.bottomRight,
};

/// `background` 字段；没有图片时为 null
ThemeBackground? _background(Object? json) {
  final m = (json as Map?)?.cast<String, dynamic>();
  if (m == null || (m['image'] == null && m['imageDark'] == null)) return null;
  final scrim = (m['scrim'] as Map?)?.cast<String, dynamic>() ?? const {};
  final align = m['align'] as String? ?? 'center';
  return ThemeBackground(
    image: m['image'] as String?,
    imageDark: m['imageDark'] as String?,
    fit: BackgroundFit.values.where((f) => f.name == m['fit']).firstOrNull ?? BackgroundFit.cover,
    align: _alignments[align] ?? Alignment.center,
    alignName: _alignments.containsKey(align) ? align : 'center',
    blur: ((m['blur'] as num?)?.toDouble() ?? 0).clamp(0, 40),
    scrimColor: scrim['color'] == null ? null : parseColor(scrim['color'] as String),
    scrimOpacity: (scrim['opacity'] as num?)?.toDouble().clamp(0, 1),
    surfaceOpacity:
        ((m['surfaceOpacity'] as num?)?.toDouble() ?? ThemeBackground.defaultSurfaceOpacity).clamp(0.6, 1),
    scope: (m['scope'] as List?)?.cast<String>().toSet() ?? const {'main', 'mobile'},
    accentFromImage: m['accentFromImage'] as bool? ?? false,
  );
}

ThemeScene? _scene(Object? json) {
  final m = (json as Map?)?.cast<String, dynamic>() ?? const {};
  final s = ThemeScene(
    header: m['header'] as String?,
    headerDark: m['headerDark'] as String?,
    sidebar: m['sidebar'] as String?,
    sidebarDark: m['sidebarDark'] as String?,
  );
  return s.isEmpty ? null : s;
}

/// [themeToJson] 里的 `background`
Map<String, Object?> backgroundToJson(ThemeBackground b) => {
      if (b.image != null) 'image': b.image,
      if (b.imageDark != null) 'imageDark': b.imageDark,
      'fit': b.fit.name,
      'align': b.alignName,
      'blur': b.blur,
      if (b.scrimColor != null || b.scrimOpacity != null)
        'scrim': {
          if (b.scrimColor != null) 'color': formatColor(b.scrimColor!),
          if (b.scrimOpacity != null) 'opacity': b.scrimOpacity,
        },
      'surfaceOpacity': b.surfaceOpacity,
      'scope': b.scope.toList(),
      'accentFromImage': b.accentFromImage,
    };

/// 只写了部分颜色时，其余取 [base]
AppPalette _palette(Object? json, AppPalette base) {
  final m = (json as Map?)?.cast<String, dynamic>() ?? const {};
  Color c(String role, Color fallback) {
    final v = m[role];
    return v == null ? fallback : parseColor(v as String);
  }

  return AppPalette(
    accent: c('accent', base.accent),
    background: c('background', base.background),
    sidebar: c('sidebar', base.sidebar),
    surface: c('surface', base.surface),
    border: c('border', base.border),
    borderStrong: c('borderStrong', base.borderStrong),
    separator: c('separator', base.separator),
    text: c('text', base.text),
    textDim: c('textDim', base.textDim),
    textFaint: c('textFaint', base.textFaint),
    selection: c('selection', base.selection),
    hover: c('hover', base.hover),
    fill: c('fill', base.fill),
    online: c('online', base.online),
    warning: c('warning', base.warning),
    danger: c('danger', base.danger),
    onAccent: c('onAccent', base.onAccent),
    inverse: c('inverse', base.inverse),
    onInverse: c('onInverse', base.onInverse),
    bevelLight: c('bevelLight', base.bevelLight),
    bevelDark: c('bevelDark', base.bevelDark),
    shadow: c('shadow', base.shadow),
  );
}

/// `#RRGGBB` 或 `#AARRGGBB`
Color parseColor(String s) {
  final hex = s.startsWith('#') ? s.substring(1) : s;
  final v = int.tryParse(hex, radix: 16);
  if (v == null || (hex.length != 6 && hex.length != 8)) throw FormatException('颜色格式不对：$s');
  return Color(hex.length == 6 ? 0xFF000000 | v : v);
}

String formatColor(Color c) {
  final argb = c.toARGB32();
  return c.a == 1
      ? '#${(argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}'
      : '#${argb.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}

/// 完整的 JSON：导出、交给 AI 改写时用
Map<String, Object?> themeToJson(AppThemeSpec s, {Map<String, String> name = const {}}) {
  Map<String, String> palette(AppPalette p) => {
        'accent': formatColor(p.accent),
        'background': formatColor(p.background),
        'sidebar': formatColor(p.sidebar),
        'surface': formatColor(p.surface),
        'border': formatColor(p.border),
        'borderStrong': formatColor(p.borderStrong),
        'separator': formatColor(p.separator),
        'text': formatColor(p.text),
        'textDim': formatColor(p.textDim),
        'textFaint': formatColor(p.textFaint),
        'selection': formatColor(p.selection),
        'hover': formatColor(p.hover),
        'fill': formatColor(p.fill),
        'online': formatColor(p.online),
        'warning': formatColor(p.warning),
        'danger': formatColor(p.danger),
        'onAccent': formatColor(p.onAccent),
        'inverse': formatColor(p.inverse),
        'onInverse': formatColor(p.onInverse),
        'bevelLight': formatColor(p.bevelLight),
        'bevelDark': formatColor(p.bevelDark),
        'shadow': formatColor(p.shadow),
      };
  return {
    'schema': 1,
    'id': s.id,
    if (name.isNotEmpty) 'name': name,
    'modes': {'light': palette(s.light), 'dark': palette(s.dark)},
    'typography': {
      'family': s.typography.family ?? 'system',
      if (s.typography.heading != null) 'heading': s.typography.heading,
      'mono': s.typography.mono == 'FusionPixelMono' ? 'FusionPixelMono' : 'system',
      'sizes': s.typography.sizes,
    },
    'shape': {
      'radius': {'sm': s.shape.sm, 'md': s.shape.md, 'lg': s.shape.lg},
      'corner': s.shape.corner.name,
      'borderWidth': s.shape.borderWidth,
      'unit': s.shape.unit,
      'shadow': s.shape.shadow.name,
    },
    'motion': s.motion.style.name,
    'icons': s.pixelIcons ? 'pixel' : 'system',
    if (s.artwork != ArtworkStyle.none) 'artwork': s.artwork.name,
    'scenery': s.scenery,
    if (s.scene != null)
      'scene': {
        if (s.scene!.header != null) 'header': s.scene!.header,
        if (s.scene!.headerDark != null) 'headerDark': s.scene!.headerDark,
        if (s.scene!.sidebar != null) 'sidebar': s.scene!.sidebar,
        if (s.scene!.sidebarDark != null) 'sidebarDark': s.scene!.sidebarDark,
      },
    if (s.background != null) 'background': backgroundToJson(s.background!),
  };
}
