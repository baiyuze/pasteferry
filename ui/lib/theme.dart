import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';

import 'pixel_theme.dart';
import 'style_themes.dart';

/// PasteFerry 的设计系统。
///
/// 这是一个常驻后台的系统工具，界面要像 macOS 自带的应用一样安静：
/// 大面积中性的石墨灰，强调色只出现在按钮、选中态和链接上。
/// 不用渐变、不用彩色图标底、不用发光——这些都会让工具显得像一个营销页面。
abstract final class AppColors {
  // 强调色：比系统蓝略深，白底上的文字对比度达到 WCAG AA
  static const accent = Color(0xFF0A66D8);
  static const accentDark = Color(0xFF3B8BEB);
}

/// 间距阶梯。全应用只用这几个值，避免出现 7px、13px 这类随手写的数字，
/// 那是界面显得"不够整齐"的主要来源。
abstract final class Insets {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

/// 默认主题的圆角：控件小、分组容器中、对话框大。
/// 页面里不直接用它们，用 `context.shape`：换了主题，圆角跟着变。
abstract final class Radii {
  static const sm = 6.0;
  static const md = 10.0;
  static const lg = 14.0;
}

/// 一套主题：浅色、深色两种配色，加上形状、文字与动效。默认主题是 [AppThemeSpec.standard]。
///
/// 页面只读 `context.palette`、`context.shape`、`context.typography`、`context.motion`，
/// 不判断当前是哪一套主题。格式与分期见 design/themes.md。
@immutable
class AppThemeSpec {
  const AppThemeSpec({
    required this.id,
    required this.light,
    required this.dark,
    this.shape = AppShape.standard,
    this.typography = AppTypography.standard,
    this.motion = AppMotion.standard,
    this.pixelIcons = false,
    this.artwork = ArtworkStyle.none,
    this.scenery = true,
    this.scene,
    this.background,
  });

  final String id;
  final AppPalette light;
  final AppPalette dark;
  final AppShape shape;
  final AppTypography typography;
  final AppMotion motion;

  /// 用像素图标（[AppIcons] 里的 Pixelarticons），而不是系统风格的图标
  final bool pixelIcons;

  final ArtworkStyle artwork;

  /// 页面顶部的风景与侧边栏底部的小图（像素主题默认是像素风景与营地）；显示背景图时总是不画
  final bool scenery;

  /// 换成导入的图的风景；null 时像素主题画像素风景，其他主题不画
  final ThemeScene? scene;

  /// 铺在窗口最底下的背景图（design/themes.md 第 7 节）；null 表示没有
  final ThemeBackground? background;

  AppPalette palette(Brightness brightness) => brightness == Brightness.dark ? dark : light;

  static const standard = AppThemeSpec(id: 'default', light: AppPalette.light, dark: AppPalette.dark);

  /// 软件自带的主题，按在「外观」里的顺序。加一套自带主题：在这里登记，
  /// 再把同样的定义写进 client-core/internal/theme/builtin/ 下以 id 命名的 JSON（后台服务据此校验与合并），
  /// test/builtin_themes_test.dart 会核对两边一致。
  static const builtins = {'default': standard, 'pixel': pixelTheme, ...styleThemes};

  /// 内置主题，按 id 取；不认识的 id 用默认主题
  static AppThemeSpec byId(String id) => builtins[id] ?? standard;
}

/// 风景换成的图（design/themes.md 第 7.6 节），都写成 `user:<sha256>`
@immutable
class ThemeScene {
  const ThemeScene({this.header, this.headerDark, this.sidebar, this.sidebarDark});

  final String? header;
  final String? headerDark;
  final String? sidebar;
  final String? sidebarDark;

  bool get isEmpty => header == null && headerDark == null && sidebar == null && sidebarDark == null;

  /// [part] 是 header 或 sidebar；这个模式下用的图的 sha256，没有时为 null
  String? shaFor(String part, Brightness b) {
    final light = part == 'header' ? header : sidebar;
    final dark = part == 'header' ? headerDark : sidebarDark;
    final ref = b == Brightness.dark ? (dark ?? light) : light;
    return ref != null && ref.startsWith('user:') ? ref.substring(5) : null;
  }
}

/// 背景图怎么铺满窗口
enum BackgroundFit { cover, contain, tile }

/// 主题里的背景图（design/themes.md 第 7.1 节）。图片存在后台服务里，[image] 写成 `user:<sha256>`。
@immutable
class ThemeBackground {
  const ThemeBackground({
    this.image,
    this.imageDark,
    this.fit = BackgroundFit.cover,
    this.align = Alignment.center,
    this.alignName = 'center',
    this.blur = 0,
    this.scrimColor,
    this.scrimOpacity,
    this.surfaceOpacity = defaultSurfaceOpacity,
    this.scope = const {'main', 'mobile'},
    this.accentFromImage = false,
  });

  static const defaultSurfaceOpacity = 0.85;

  final String? image;
  final String? imageDark;
  final BackgroundFit fit;
  final Alignment align;
  final String alignName;

  /// 0 到 40；0 是原图，20 及以上全用后台服务预先算好的模糊版
  final double blur;

  /// 遮罩颜色，null 时用主题的 background
  final Color? scrimColor;

  /// 遮罩浓度，null 时取图片分析给出的下限（至少 0.3）；比下限淡时按下限显示
  final double? scrimOpacity;

  /// 侧边栏与分组面板的不透明度，0.6 到 1
  final double surfaceOpacity;

  /// 哪些窗口显示：main（主窗口）、picker（快捷粘贴）、mobile（手机）
  final Set<String> scope;

  /// 用图片的主色作强调色
  final bool accentFromImage;

  /// 这个模式下用的图（`user:<sha256>` 里的 sha256），没有时为 null
  String? shaFor(Brightness b) {
    final ref = b == Brightness.dark ? (imageDark ?? image) : image;
    return ref != null && ref.startsWith('user:') ? ref.substring(5) : null;
  }
}

/// 语义化的颜色角色。页面代码只用这些名字，不判断亮暗模式。
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.accent,
    required this.background,
    required this.sidebar,
    required this.surface,
    required this.border,
    required this.separator,
    required this.text,
    required this.textDim,
    required this.textFaint,
    required this.selection,
    required this.hover,
    required this.fill,
    required this.online,
    required this.warning,
    required this.danger,
    this.onAccent = Colors.white,
    required this.inverse,
    this.onInverse = Colors.white,
    this._borderStrong,
    this.bevelLight = const Color(0x00000000),
    this.bevelDark = const Color(0x00000000),
    this.shadow = const Color(0x40000000),
  });

  final Color accent;
  final Color background; // 内容区底色
  final Color sidebar;
  final Color surface; // 分组容器、对话框
  final Color border; // 容器外框
  final Color separator; // 容器内的行分隔线
  final Color text;
  final Color textDim;
  final Color textFaint;
  final Color selection; // 侧边栏选中项
  final Color hover;
  final Color fill; // 分段控件轨道、代码块等浅色填充
  final Color online;
  final Color warning;
  final Color danger;
  final Color onAccent; // 强调色底上的文字、图标
  final Color inverse; // 提示条、工具提示这类反色的底
  final Color onInverse;
  final Color? _borderStrong;
  final Color bevelLight; // 凸起控件上、左两边的亮边；凹槽是下、右两边。默认主题没有斜面
  final Color bevelDark; // 凸起控件下、右两边的暗边；凹槽是上、左两边
  final Color shadow; // 浮层（对话框、菜单、悬停预览）的硬投影

  /// 按钮、输入框、浮层的边框，比容器的 [border] 醒目。默认主题与 [border] 相同
  Color get borderStrong => _borderStrong ?? border;

  static const light = AppPalette(
    accent: AppColors.accent,
    background: Color(0xFFF5F5F4),
    sidebar: Color(0xFFEBEBE9),
    surface: Color(0xFFFFFFFF),
    border: Color(0xFFE0E0DD),
    separator: Color(0xFFECECEA),
    text: Color(0xFF1D1D1F),
    textDim: Color(0xFF6E6E73),
    textFaint: Color(0xFFA1A1A6),
    selection: Color(0xFFDCDCD9),
    hover: Color(0x0A000000),
    fill: Color(0xFFEEEEEC),
    // 状态色取 Apple 的深色变体：浅底上作为文字也清晰可读
    online: Color(0xFF248A3D),
    warning: Color(0xFFB25000),
    danger: Color(0xFFD70015),
    inverse: Color(0xFF2C2C2E),
  );

  static const dark = AppPalette(
    accent: AppColors.accentDark,
    background: Color(0xFF1C1C1E),
    sidebar: Color(0xFF232325),
    surface: Color(0xFF2A2A2C),
    border: Color(0xFF3A3A3C),
    separator: Color(0xFF333335),
    text: Color(0xFFF5F5F7),
    textDim: Color(0xFF98989D),
    textFaint: Color(0xFF636366),
    selection: Color(0xFF3A3A3C),
    hover: Color(0x0FFFFFFF),
    fill: Color(0xFF323234),
    online: Color(0xFF32D74B),
    warning: Color(0xFFFF9F0A),
    danger: Color(0xFFFF453A),
    inverse: Color(0xFF3A3A3C),
  );

  @override
  AppPalette copyWith() => this;

  /// 换掉强调色与它上面的文字色，其余不变（「用图片配色」）
  AppPalette withAccent(Color accent, Color onAccent) => AppPalette(
        accent: accent,
        onAccent: onAccent,
        background: background,
        sidebar: sidebar,
        surface: surface,
        border: border,
        separator: separator,
        text: text,
        textDim: textDim,
        textFaint: textFaint,
        selection: selection,
        hover: hover,
        fill: fill,
        online: online,
        warning: warning,
        danger: danger,
        inverse: inverse,
        onInverse: onInverse,
        borderStrong: _borderStrong,
        bevelLight: bevelLight,
        bevelDark: bevelDark,
        shadow: shadow,
      );

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      accent: l(accent, other.accent),
      background: l(background, other.background),
      sidebar: l(sidebar, other.sidebar),
      surface: l(surface, other.surface),
      border: l(border, other.border),
      separator: l(separator, other.separator),
      text: l(text, other.text),
      textDim: l(textDim, other.textDim),
      textFaint: l(textFaint, other.textFaint),
      selection: l(selection, other.selection),
      hover: l(hover, other.hover),
      fill: l(fill, other.fill),
      online: l(online, other.online),
      warning: l(warning, other.warning),
      danger: l(danger, other.danger),
      onAccent: l(onAccent, other.onAccent),
      inverse: l(inverse, other.inverse),
      borderStrong: l(borderStrong, other.borderStrong),
      bevelLight: l(bevelLight, other.bevelLight),
      bevelDark: l(bevelDark, other.bevelDark),
      shadow: l(shadow, other.shadow),
      onInverse: l(onInverse, other.onInverse),
    );
  }
}

/// 投影的画法：[soft] 是现在的柔和投影；[hard] 是不模糊、向右下错开的实心投影（像素主题）；
/// [none] 不画投影，只靠边框区分层级。
enum ShadowStyle { soft, hard, none }

/// 角的画法：[round] 是圆角；[pixel] 是像素角，四角切掉台阶状的方格，见 [PixelBorder]。
enum CornerStyle { round, pixel, bevel }

/// A decorative visual language shared by the main window and theme previews.
enum ArtworkStyle { none, jazz, space, memphis, y2k, americana, arcade, retro }

@immutable
class AppArtwork extends ThemeExtension<AppArtwork> {
  const AppArtwork(this.style);
  final ArtworkStyle style;
  @override
  AppArtwork copyWith({ArtworkStyle? style}) => AppArtwork(style ?? this.style);
  @override
  AppArtwork lerp(AppArtwork? other, double t) => t < .5 || other == null ? this : other;
}

/// 圆角、边框与投影。
@immutable
class AppShape extends ThemeExtension<AppShape> {
  const AppShape({
    this.sm = Radii.sm,
    this.md = Radii.md,
    this.lg = Radii.lg,
    this.shadow = ShadowStyle.soft,
    this.corner = CornerStyle.round,
    this.borderWidth = 1,
    this.unit = 2,
    this.hardShadowColor = const Color(0xFF000000),
  });

  final double sm; // 控件
  final double md; // 分组容器、卡片
  final double lg; // 对话框、大面板
  final ShadowStyle shadow;
  final CornerStyle corner;
  final double borderWidth; // 容器、按钮、输入框的边框
  final double unit; // 像素角的一格，也是硬投影错开的距离
  final Color hardShadowColor;

  bool get pixel => corner == CornerStyle.pixel;

  bool get beveled => pixel || corner == CornerStyle.bevel;

  static const standard = AppShape();

  /// 进度条、角标这类小装饰写死的圆角 [r]，按 [sm] 与默认值的比例缩放：直角主题里一起变成直角。
  double scaled(double r) => r * sm / Radii.sm;

  /// 一层投影。默认主题原样返回，[ShadowStyle.none] 时没有投影。
  /// 硬投影只给浮层（[blur] 不小于 12 的大投影，比如悬停预览）：错开两格、不模糊；
  /// 按钮、设备节点这类小投影在硬投影的主题里不画，立体感交给斜面。
  List<BoxShadow> shadows(Color color, {required double blur, required Offset offset}) => switch (shadow) {
        ShadowStyle.soft => [BoxShadow(color: color, blurRadius: blur, offset: offset)],
        ShadowStyle.hard when blur >= 12 => [BoxShadow(color: hardShadowColor, offset: Offset(unit, unit) * 2)],
        ShadowStyle.hard || ShadowStyle.none => const [],
      };

  /// 按钮、对话框、菜单的外形。[radius] 默认是 [sm]。
  /// 像素主题里可以加斜面 [bevel]（上左、下右两色）和浮层投影 [drop]；默认主题忽略它们
  OutlinedBorder outline({BorderSide side = BorderSide.none, double? radius, (Color, Color)? bevel, Color? drop}) => beveled
      ? PixelBorder(side: side, unit: unit, steps: pixel ? 1 : 0, topLeft: bevel?.$1, bottomRight: bevel?.$2, drop: drop)
      : RoundedRectangleBorder(side: side, borderRadius: BorderRadius.circular(radius ?? sm));

  /// 容器的底、边框与投影。默认主题是带圆角 [radius]（默认 [md]）的 BoxDecoration，
  /// 像素主题换成切角、粗边框的 ShapeDecoration，可以加斜面 [bevel]（上左、下右两色）。
  Decoration box({Color? color, Color? border, double? radius, List<BoxShadow>? shadows, (Color, Color)? bevel}) => beveled
      ? ShapeDecoration(
          color: color,
          shadows: shadows,
          shape: PixelBorder(
            side: border == null ? BorderSide.none : BorderSide(color: border, width: borderWidth),
            unit: unit,
            steps: pixel ? 1 : 0,
            topLeft: bevel?.$1,
            bottomRight: bevel?.$2,
          ),
        )
      : BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius ?? md),
          border: border == null ? null : Border.all(color: border, width: borderWidth),
          boxShadow: shadows,
        );

  /// 圆形的底（设备节点、状态点）。像素主题里是切掉三级台阶的方块，看起来像像素画的圆。
  Decoration circle({Color? color, Color? border, double borderWidth = 1, List<BoxShadow>? shadows}) => pixel
      ? ShapeDecoration(
          color: color,
          shadows: shadows,
          shape: PixelBorder(
            side: border == null ? BorderSide.none : BorderSide(color: border, width: math.max(borderWidth, this.borderWidth)),
            unit: unit,
            steps: 3,
          ),
        )
      : BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: border == null ? null : Border.all(color: border, width: borderWidth),
          boxShadow: shadows,
        );

  @override
  AppShape copyWith({double? sm, double? md, double? lg, ShadowStyle? shadow, Color? hardShadowColor}) => AppShape(
        sm: sm ?? this.sm,
        md: md ?? this.md,
        lg: lg ?? this.lg,
        shadow: shadow ?? this.shadow,
        corner: corner,
        borderWidth: borderWidth,
        unit: unit,
        hardShadowColor: hardShadowColor ?? this.hardShadowColor,
      );

  @override
  AppShape lerp(AppShape? other, double t) {
    if (other == null) return this;
    double l(double a, double b) => a + (b - a) * t;
    return AppShape(
      sm: l(sm, other.sm),
      md: l(md, other.md),
      lg: l(lg, other.lg),
      shadow: t < 0.5 ? shadow : other.shadow,
      corner: t < 0.5 ? corner : other.corner,
      borderWidth: l(borderWidth, other.borderWidth),
      unit: t < 0.5 ? unit : other.unit,
      hardShadowColor: Color.lerp(hardShadowColor, other.hardShadowColor, t)!,
    );
  }
}

/// 等宽字体：配对码、指纹、服务器地址这类需要逐字符核对的内容。
/// Windows 没有 Menlo，找不到时会退回 Segoe UI，数字就不等宽了。Linux 上交给 fontconfig 的 monospace 别名，
/// 各发行版会解析成自己的等宽字体（DejaVu Sans Mono 等）。
final monoFamily = Platform.isWindows
    ? 'Consolas'
    : Platform.isLinux
        ? 'monospace'
        : 'Menlo';

/// 主题指定的字体。正文字体 [family] 由 [buildTheme] 写进 TextTheme；页面要单独取的是等宽字体 [mono]。
@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({this.family, this.heading, this._mono, this.sizes = const []});

  /// 正文字体。为空时跟随系统
  final String? family;

  final String? heading;

  final String? _mono;

  /// 允许的字号。不为空时，界面上所有文字的字号都吸附到其中最近的一个（见 [ThemeTextScale]）：
  /// 点阵字体只有在设计字号的整数倍上才清晰。
  final List<double> sizes;

  /// 主题没指定时用系统的等宽字体 [monoFamily]
  String get mono => _mono ?? monoFamily;

  static const standard = AppTypography();

  @override
  AppTypography copyWith({String? family, String? heading, String? mono, List<double>? sizes}) =>
      AppTypography(family: family ?? this.family, heading: heading ?? this.heading, mono: mono ?? _mono, sizes: sizes ?? this.sizes);

  @override
  AppTypography lerp(AppTypography? other, double t) => t < 0.5 || other == null ? this : other;
}

/// 动画的节奏：[smooth] 是现在的平滑过渡；[stepped] 逐帧跳变（像素主题）；[reduced] 不做动画。
enum MotionStyle { smooth, stepped, reduced }

/// 动效。页面里的过渡动画经 [duration] 与 [curve] 取值，换主题时节奏跟着变。
@immutable
class AppMotion extends ThemeExtension<AppMotion> {
  const AppMotion({this.style = MotionStyle.smooth, this.steps = 4});

  final MotionStyle style;

  /// [MotionStyle.stepped] 时一段动画分几帧
  final int steps;

  static const standard = AppMotion();

  Duration duration(Duration d) => style == MotionStyle.reduced ? Duration.zero : d;

  Curve curve(Curve c) => style == MotionStyle.stepped ? _SteppedCurve(c, steps) : c;

  @override
  AppMotion copyWith({MotionStyle? style, int? steps}) =>
      AppMotion(style: style ?? this.style, steps: steps ?? this.steps);

  @override
  AppMotion lerp(AppMotion? other, double t) => t < 0.5 || other == null ? this : other;
}

/// 把 [base] 量化成 [steps] 档：动画一格一格地跳，不连续过渡。
class _SteppedCurve extends Curve {
  const _SteppedCurve(this.base, this.steps);

  final Curve base;
  final int steps;

  @override
  double transformInternal(double t) => (base.transform(t) * steps).floorToDouble() / steps;
}

/// 把字号吸附到 [sizes] 里最近的一个，系统的文字缩放先算进去。
class SnapTextScaler extends TextScaler {
  const SnapTextScaler(this.base, this.sizes);

  final TextScaler base;
  final List<double> sizes;

  @override
  double scale(double fontSize) {
    final s = base.scale(fontSize);
    return sizes.reduce((a, b) => (s - a).abs() <= (s - b).abs() ? a : b);
  }

  @override
  // ignore: deprecated_member_use
  double get textScaleFactor => base.textScaleFactor;

  @override
  bool operator ==(Object other) =>
      other is SnapTextScaler && other.base == base && listEquals(other.sizes, sizes);

  @override
  int get hashCode => Object.hash(base, Object.hashAll(sizes));
}

/// 主题规定了字号阶梯时（像素字体），给下面的文字换上 [SnapTextScaler]。
/// 放在 MaterialApp.builder 里，主窗口、快捷粘贴窗口、手机都要放。
class ThemeTextScale extends StatelessWidget {
  const ThemeTextScale({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final sizes = context.typography.sizes;
    if (sizes.isEmpty) return child;
    final mq = MediaQuery.of(context);
    return MediaQuery(data: mq.copyWith(textScaler: SnapTextScaler(mq.textScaler, sizes)), child: child);
  }
}

extension PaletteAccess on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
  TextTheme get text => Theme.of(this).textTheme;
  AppShape get shape => Theme.of(this).extension<AppShape>()!;
  AppTypography get typography => Theme.of(this).extension<AppTypography>()!;
  AppMotion get motion => Theme.of(this).extension<AppMotion>()!;
  ArtworkStyle get artwork => Theme.of(this).extension<AppArtwork>()?.style ?? ArtworkStyle.none;
}

/// Windows 上汉字（以及韩文）用哪些字体，按界面语言 [language] 排先后。
/// Segoe UI 本身含拉丁、西里尔、越南文与阿拉伯文，这些语言不用另外指定。
///
/// Flutter 在 Windows 上默认只认 Segoe UI，汉字交给系统逐字回退：中日共用的字常落到
/// 日文字体，简体独有的字落到雅黑或宋体，同一行里字形参差不齐。把回退顺序定死，
/// 汉字就统一用同一套字体，和系统自带的应用一致。繁体用微软正黑体，字形是繁体的写法。
List<String> windowsFontFallback(String language) => switch (language) {
      'ja' => const ['Yu Gothic UI', 'Meiryo UI', 'Microsoft YaHei UI'],
      'ko' => const ['Malgun Gothic', 'Microsoft YaHei UI', 'Yu Gothic UI'],
      'zh-Hant-TW' || 'zh-Hant-HK' => const ['Microsoft JhengHei UI', 'Microsoft JhengHei', 'Microsoft YaHei UI'],
      _ => const ['Microsoft YaHei UI', 'Microsoft YaHei', 'Yu Gothic UI'],
    };

/// Linux 上汉字用哪些字体，按界面语言 [language] 排先后。主字体跟随系统（fontconfig 默认的无衬线字体），
/// 汉字指定字体，理由与 [windowsFontFallback] 相同。列的都是各发行版常见的开源字体，没装的会被跳过。
List<String> linuxFontFallback(String language) => switch (language) {
      'ja' => const ['Noto Sans CJK JP', 'Source Han Sans JP', 'IPAexGothic', 'Noto Sans CJK SC'],
      'ko' => const ['Noto Sans CJK KR', 'Source Han Sans KR', 'NanumGothic', 'Noto Sans CJK SC'],
      // 阿拉伯文先用 Noto 的阿拉伯字体，没装时 fontconfig 会另找一个能显示的
      'ar' => const ['Noto Sans Arabic', 'Noto Naskh Arabic', 'Noto Sans CJK SC', 'WenQuanYi Micro Hei'],
      'zh-Hant-TW' => const ['Noto Sans CJK TC', 'Source Han Sans TC', 'Noto Sans CJK SC', 'WenQuanYi Micro Hei'],
      'zh-Hant-HK' => const ['Noto Sans CJK HK', 'Source Han Sans HK', 'Noto Sans CJK TC', 'Noto Sans CJK SC'],
      _ => const ['Noto Sans CJK SC', 'Source Han Sans SC', 'WenQuanYi Micro Hei', 'Droid Sans Fallback'],
    };

/// [fontFamily] 只给截图渲染用：App 本身不指定。Mac 上跟随系统字体（SF Pro 与苹方），
/// Windows 上用 Segoe UI，汉字按 [language] 用 [windowsFontFallback] 里的字体；
/// Linux 上主字体跟随系统，汉字用 [linuxFontFallback] 里的字体。
///
/// 桌面主窗口、快捷粘贴窗口、手机（在它上面调整字号与触控尺寸）都由这里按同一套主题 [spec] 生成。
ThemeData buildTheme(Brightness brightness,
    {AppThemeSpec spec = AppThemeSpec.standard,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String language = 'zh'}) {
  if (fontFamily == null && fontFamilyFallback == null) {
    if (Platform.isWindows) {
      fontFamily = 'Segoe UI';
      fontFamilyFallback = windowsFontFallback(language);
    } else if (Platform.isLinux) {
      fontFamilyFallback = linuxFontFallback(language);
    }
  }
  // 主题自带的字体（像素字体）优先；它没有的字形（⌥ 这类符号、emoji）交给原来的字体
  final themeFamily = spec.typography.family;
  if (themeFamily != null) {
    fontFamilyFallback = [?fontFamily, ...?fontFamilyFallback];
    fontFamily = themeFamily;
  }
  final dark = brightness == Brightness.dark;
  final p = spec.palette(brightness);
  // 浮层的硬投影跟着亮暗模式取色
  final shape = spec.shape.copyWith(hardShadowColor: p.shadow);
  final flat = shape.shadow != ShadowStyle.soft;
  // 像素主题：按钮、输入框、浮层描强边框；按钮凸起（上左亮、下右暗），输入框凹下，浮层有错开的投影。
  // 默认主题里 borderStrong 就是 border，斜面与投影都不画
  final strong = BorderSide(color: p.borderStrong, width: shape.borderWidth);
  final raised = (p.bevelLight, p.bevelDark);
  final drop = shape.beveled ? p.shadow : null;

  final scheme = ColorScheme.fromSeed(seedColor: p.accent, brightness: brightness).copyWith(
    primary: p.accent,
    onPrimary: p.onAccent,
    surface: p.background,
    onSurface: p.text,
    error: p.danger,
  );

  // 字号偏小、字重克制：桌面工具的信息密度应当高于移动应用。
  // 层级靠字号与字重区分，不靠颜色。
  var textTheme = TextTheme(
    headlineSmall: TextStyle(
        fontSize: 22, fontWeight: FontWeight.w600, color: p.text, letterSpacing: -0.4),
    titleMedium: TextStyle(
        fontSize: 15, fontWeight: FontWeight.w600, color: p.text, letterSpacing: -0.2),
    titleSmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: p.text),
    // 输入框默认用 bodyLarge，不定义的话会是移动端的 16px，比周围的字大一号
    bodyLarge: TextStyle(fontSize: 13, color: p.text),
    bodyMedium: TextStyle(fontSize: 13, color: p.text, height: 1.45),
    bodySmall: TextStyle(fontSize: 12, color: p.textDim, height: 1.4),
    labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: p.text),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: p.textDim),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: p.textDim),
  );
  if (spec.typography.sizes.isNotEmpty) {
    // 点阵字体：字号只有阶梯里的几档（ThemeTextScale 负责吸附），字距为 0，行高取整数像素。
    // 层级靠字号与颜色区分
    final big = spec.typography.sizes.last;
    final base = spec.typography.sizes.first;
    textTheme = TextTheme(
      headlineSmall: TextStyle(fontSize: big, color: p.text, height: 1.25),
      titleMedium: TextStyle(fontSize: base, fontWeight: FontWeight.w600, color: p.text, height: 1.5),
      titleSmall: TextStyle(fontSize: base, fontWeight: FontWeight.w600, color: p.text, height: 1.5),
      bodyLarge: TextStyle(fontSize: base, color: p.text, height: 1.5),
      bodyMedium: TextStyle(fontSize: base, color: p.text, height: 1.5),
      bodySmall: TextStyle(fontSize: base, color: p.textDim, height: 1.5),
      labelLarge: TextStyle(fontSize: base, color: p.text),
      labelMedium: TextStyle(fontSize: base, color: p.textDim),
      labelSmall: TextStyle(fontSize: base, color: p.textDim),
    );
  }
  if (fontFamily != null || fontFamilyFallback != null) {
    textTheme = textTheme.apply(fontFamily: fontFamily, fontFamilyFallback: fontFamilyFallback);
  }
  if (spec.typography.heading case final String heading) {
    TextStyle? display(TextStyle? style) => style?.copyWith(fontFamily: heading,
        fontFamilyFallback: [?fontFamily, ...?fontFamilyFallback], letterSpacing: 0);
    textTheme = textTheme.copyWith(headlineSmall: display(textTheme.headlineSmall),
        titleMedium: display(textTheme.titleMedium), titleSmall: display(textTheme.titleSmall));
  }

  final controlShape = shape.outline();
  const controlPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 9);

  /// 像素主题的按钮是凸起的，按下时斜面明暗互换、文字下沉 2px，像按下一个实体按键
  ButtonStyle pressable(ButtonStyle style) {
    if (!shape.beveled) return style;
    final up = shape.outline(side: strong, bevel: raised) as PixelBorder;
    final sink = EdgeInsets.only(top: shape.unit, bottom: -shape.unit);
    return style.copyWith(
      shape: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.pressed) ? up.pressed : up),
      padding: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.pressed) ? controlPadding + sink : controlPadding),
    );
  }

  /// 输入框的边框：像素主题是凹下去的槽
  InputBorder field(Color color, {double? width}) => shape.beveled
      ? PixelInputBorder(
          borderSide: BorderSide(color: color, width: shape.borderWidth),
          unit: shape.unit,
          steps: shape.pixel ? 1 : 0,
          topLeft: p.bevelDark,
          bottomRight: p.bevelLight,
        )
      : OutlineInputBorder(
          borderRadius: BorderRadius.circular(shape.sm),
          borderSide: BorderSide(color: color, width: width ?? shape.borderWidth),
        );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: p.background,
    canvasColor: p.surface,
    textTheme: textTheme,
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    extensions: [p, shape, spec.typography, spec.motion, AppArtwork(spec.artwork)],
    splashFactory: NoSplash.splashFactory, // 桌面端没有触摸涟漪
    highlightColor: Colors.transparent,
    hoverColor: p.hover,
    dividerTheme: DividerThemeData(color: p.separator, thickness: shape.borderWidth, space: shape.borderWidth),
    iconTheme: IconThemeData(color: p.textDim, size: 16),
    filledButtonTheme: FilledButtonThemeData(
      style: pressable(FilledButton.styleFrom(
        backgroundColor: p.accent,
        foregroundColor: p.onAccent,
        disabledBackgroundColor: p.fill,
        disabledForegroundColor: p.textFaint,
        shape: controlShape,
        side: shape.beveled ? strong : null,
        padding: controlPadding,
        minimumSize: const Size(0, 32),
        textStyle: textTheme.labelLarge,
        elevation: 0,
      )),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: pressable(OutlinedButton.styleFrom(
        foregroundColor: p.text,
        backgroundColor: shape.pixel ? p.selection : p.surface,
        shape: controlShape,
        padding: controlPadding,
        minimumSize: const Size(0, 32),
        textStyle: textTheme.labelLarge,
        side: strong,
      )),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: p.accent,
        shape: controlShape,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        minimumSize: const Size(0, 30),
        textStyle: textTheme.labelLarge,
      ).copyWith(
        // 像素主题：文字按钮没有边框，悬停时出现一条点线下划线
        textStyle: shape.pixel
            ? WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.hovered)
                ? textTheme.labelLarge?.copyWith(
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dotted,
                    decorationThickness: shape.borderWidth,
                  )
                : textTheme.labelLarge)
            : null,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: shape.pixel ? p.fill : p.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      border: field(p.borderStrong),
      enabledBorder: field(p.borderStrong),
      focusedBorder: field(p.accent, width: 1.5),
      hintStyle: textTheme.bodyMedium?.copyWith(color: p.textFaint),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(p.onAccent),
      trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.accent : p.selection),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    // Material 3 的对话框与菜单默认没有阴影，只靠颜色区分层级；
    // macOS 的弹窗和菜单都有明显的投影，这里补上
    dialogTheme: DialogThemeData(
      backgroundColor: p.surface,
      surfaceTintColor: Colors.transparent,
      elevation: flat ? 0 : 18,
      shadowColor: Color(dark ? 0x99000000 : 0x40000000),
      shape: shape.outline(radius: shape.lg, side: shape.beveled ? strong : BorderSide.none, bevel: raised, drop: drop),
      titleTextStyle: textTheme.titleMedium,
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: p.textDim),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: p.surface,
      surfaceTintColor: Colors.transparent,
      elevation: flat ? 0 : 8,
      shadowColor: Color(dark ? 0x99000000 : 0x33000000),
      textStyle: textTheme.bodyMedium,
      shape: shape.outline(radius: shape.md, side: strong, drop: drop),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: p.inverse,
      contentTextStyle: TextStyle(fontSize: 13, color: p.onInverse),
      elevation: flat ? 0 : 6,
      shape: shape.outline(radius: shape.md, drop: drop),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: shape.box(color: p.inverse, radius: shape.sm),
      textStyle: TextStyle(fontSize: 12, color: p.onInverse),
      waitDuration: const Duration(milliseconds: 500),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: p.accent,
      linearTrackColor: p.fill,
      circularTrackColor: Colors.transparent,
    ),
    scrollbarTheme: ScrollbarThemeData(
      thickness: WidgetStatePropertyAll(shape.pixel ? 8 : 6),
      radius: Radius.circular(shape.scaled(3)),
      thumbColor: WidgetStatePropertyAll(p.textFaint.withValues(alpha: 0.5)),
    ),
  );
}
