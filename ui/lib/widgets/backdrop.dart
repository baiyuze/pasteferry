import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../pixel_art.dart';
import '../theme.dart';
import '../theme_controller.dart';

/// 窗口最底下的背景图层（design/themes.md 第 7.5 节）：图片、遮罩，上面是内容。
///
/// 包在 MaterialApp 的 builder 里，主窗口、快捷粘贴窗口、手机 App 各一个。有背景图时
/// 页面底色（scaffoldBackgroundColor）换成透明，侧边栏与分组面板按 surfaceOpacity 半透明
/// （见 [BackdropContext.panel]）；对话框、菜单、悬停预览仍然不透明。
///
/// 模糊不在运行时做（Windows 与 Linux 上全窗口模糊很耗显卡）：后台服务导入时就算好一张模糊版，
/// blur 在 0 到 20 之间时把模糊版按比例叠在原图上。
class ThemedBackdrop extends StatelessWidget {
  const ThemedBackdrop({super.key, required this.controller, required this.window, required this.child});

  final ThemeController controller;

  /// main、picker 或 mobile，对应主题里 background.scope 的取值
  final String window;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final d = controller.backdrop(theme.brightness, window, context.palette);
    final scenery = controller.spec.scenery;
    if (d == null) return BackdropScope(backdrop: null, scenery: scenery, child: child);

    final bg = d.background;
    final scrim = bg.scrimColor ?? context.palette.background;
    // 遮罩只能比文字需要的更浓（d.minScrim，按主题的文字颜色算）
    final opacity = d.scrimOpacity;
    final mix = (bg.blur / 20).clamp(0.0, 1.0);

    return BackdropScope(
      backdrop: d,
      scenery: scenery,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (d.sharp != null) _BackdropImage(bytes: d.sharp!, background: bg),
          if (d.blurred != null) _BackdropImage(bytes: d.blurred!, background: bg, opacity: d.sharp == null ? 1 : mix),
          ColoredBox(color: scrim.withValues(alpha: scrim.a * opacity)),
          Theme(data: theme.copyWith(scaffoldBackgroundColor: Colors.transparent), child: child),
        ],
      ),
    );
  }
}

class _BackdropImage extends StatelessWidget {
  const _BackdropImage({required this.bytes, required this.background, this.opacity = 1});

  final Uint8List bytes;
  final ThemeBackground background;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final fade = opacity < 1 ? AlwaysStoppedAnimation(opacity) : null;
    if (background.fit == BackgroundFit.tile) {
      // 平铺的多是像素画：只按整数倍放大，不插值
      final n = math.max(1, dpr.round());
      return Image.memory(
        bytes,
        scale: dpr / n,
        repeat: ImageRepeat.repeat,
        alignment: background.align,
        filterQuality: FilterQuality.none,
        opacity: fade,
        gaplessPlayback: true,
      );
    }
    // 按窗口大小解码一次，不把 4K 原图整张放进内存；大小按 512 取整，拖动窗口时不反复解码
    final size = MediaQuery.sizeOf(context);
    final side = ((math.max(size.width, size.height) * dpr / 512).ceil() * 512).clamp(512, 4096);
    return Image(
      image: ResizeImage(MemoryImage(bytes), width: side, height: side, policy: ResizeImagePolicy.fit),
      fit: background.fit == BackgroundFit.contain ? BoxFit.contain : BoxFit.cover,
      alignment: background.align,
      filterQuality: FilterQuality.medium,
      opacity: fade,
      gaplessPlayback: true,
    );
  }
}

/// 把背景的状态传给下面的页面
class BackdropScope extends InheritedWidget {
  const BackdropScope({super.key, required this.backdrop, required this.scenery, required super.child});

  /// 正在显示的背景图；没有时为 null
  final Backdrop? backdrop;

  /// 主题允许画像素场景
  final bool scenery;

  static BackdropScope? maybeOf(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BackdropScope>();

  @override
  bool updateShouldNotify(BackdropScope old) => old.backdrop != backdrop || old.scenery != scenery;
}

extension BackdropContext on BuildContext {
  /// 侧边栏、分组面板这类大块底色：有背景图时按 surfaceOpacity 半透明，让图透出来
  Color panel(Color color) {
    final b = BackdropScope.maybeOf(this)?.backdrop;
    return b == null ? color : color.withValues(alpha: color.a * b.background.surfaceOpacity);
  }

  /// 风景（页面顶部的图与侧边栏底部的小图）：主题没关掉、也没有显示整窗背景图时才画。
  /// 画什么由 [SceneHeader]、[SceneSidebar] 决定
  bool get showScenery {
    final scope = BackdropScope.maybeOf(this);
    return scope == null || (scope.scenery && scope.backdrop == null);
  }
}

/// 页面顶部的风景：主题换了图（scene.header）就画图，否则像素主题画像素风景，其他主题不画。
/// 图的底部渐隐进页面；页面标题叠在上面，所以盖一层主题底色的遮罩，浓到文字看得清为止
class SceneHeader extends StatelessWidget {
  const SceneHeader({super.key, required this.controller, this.height = 180});

  final ThemeController controller;
  final double height;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final p = context.palette;
    final bytes = controller.sceneImage('header', brightness);
    final scrim = controller.sceneScrim(brightness, p);
    if (controller.spec.scene?.shaFor('header', brightness) == null) {
      return context.shape.pixel ? PixelScene(height: height) : const SizedBox.shrink();
    }
    if (bytes == null || scrim == null) return SizedBox(height: height);
    return SizedBox(
      height: height,
      width: double.infinity,
      child: _Fade(
        top: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _SceneImage(bytes: bytes),
            ColoredBox(color: p.background.withValues(alpha: scrim)),
          ],
        ),
      ),
    );
  }
}

/// 侧边栏底部的小图：主题换了图（scene.sidebar）就画图，否则像素主题画营地，其他主题不画。
/// 上面没有文字，不加遮罩，顶部渐隐进侧边栏
class SceneSidebar extends StatelessWidget {
  const SceneSidebar({super.key, required this.controller});

  final ThemeController controller;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (controller.spec.scene?.shaFor('sidebar', brightness) == null) {
      return context.shape.pixel ? const PixelCamp() : const SizedBox.shrink();
    }
    final bytes = controller.sceneImage('sidebar', brightness);
    if (bytes == null) return const SizedBox(height: 96);
    return SizedBox(height: 96, width: double.infinity, child: _Fade(top: true, child: _SceneImage(bytes: bytes)));
  }
}

class _SceneImage extends StatelessWidget {
  const _SceneImage({required this.bytes});

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final width = ((MediaQuery.sizeOf(context).width * dpr / 512).ceil() * 512).clamp(512, 4096);
    return Image(
      image: ResizeImage(MemoryImage(bytes), width: width, policy: ResizeImagePolicy.fit),
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
      gaplessPlayback: true,
    );
  }
}

/// 一头渐隐成透明：[top] 时上边渐隐，否则下边
class _Fade extends StatelessWidget {
  const _Fade({required this.top, required this.child});

  final bool top;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) => LinearGradient(
        begin: top ? Alignment.bottomCenter : Alignment.topCenter,
        end: top ? Alignment.topCenter : Alignment.bottomCenter,
        colors: const [Colors.white, Colors.white, Colors.transparent],
        stops: const [0, 0.55, 1],
      ).createShader(rect),
      child: child,
    );
  }
}
