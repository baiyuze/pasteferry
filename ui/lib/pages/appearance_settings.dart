import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_state.dart';
import '../i18n.dart';
import '../icons.dart';
import '../main.dart';
import '../theme.dart';
import '../theme_controller.dart';
import '../widgets/common.dart';

/// 设置页的「外观」：主题管理（软件自带的与自定义的）、浅色与深色、像素主题的扫描线。
/// 见 design/themes.md 第 6 节。
///
/// 主题存在后台服务里，主窗口、快捷粘贴窗口、手机 App 一起换，不同步到其他设备。
/// 自定义主题可以复制自带主题得到、从文件导入，或者让 AI 通过 MCP 做（design/mcp.md）。
class AppearanceSection extends StatelessWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppScope.of(context).theme;
    return ListenableBuilder(
      listenable: theme,
      builder: (context, _) {
        final l = context.l10n;
        final p = context.palette;
        final builtin = theme.themes.where((t) => t.builtin).toList();
        final custom = theme.themes.where((t) => !t.builtin).toList();
        Widget cards(List<ThemeChoice> list) => Wrap(
              spacing: Insets.lg,
              runSpacing: Insets.lg,
              children: [
                for (final t in list) _ThemeCard(choice: t, selected: t.id == theme.id),
              ],
            );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GroupSection(title: l.themeBuiltinGroup, child: cards(builtin)),
            GroupSection(
              title: l.themeCustomGroup,
              footnote: l.themeFootnote,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (custom.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Insets.md),
                      child: Text(l.themeCustomEmpty, style: context.text.bodySmall),
                    )
                  else ...[
                    cards(custom),
                    const SizedBox(height: Insets.lg),
                  ],
                  Wrap(
                    spacing: Insets.sm,
                    runSpacing: Insets.sm,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _import(context, theme),
                        icon: Icon(AppIcons.download, size: 14),
                        label: Text(l.themeImport),
                      ),
                      TextButton.icon(
                        onPressed: () => showDialog<void>(context: context, builder: (_) => const _AskAiDialog()),
                        icon: Icon(AppIcons.questionCircle, size: 14, color: p.accent),
                        label: Text(l.themeAskAi),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GroupSection(
              title: '',
              child: GroupBox(
                children: [
                  SettingRow(
                    title: l.themeMode,
                    child: Segmented<ThemeMode>(
                      value: theme.mode,
                      segments: [
                        (ThemeMode.system, l.themeModeSystem),
                        (ThemeMode.light, l.themeModeLight),
                        (ThemeMode.dark, l.themeModeDark),
                      ],
                      onChanged: (m) => _run(context, () => theme.setMode(m)),
                    ),
                  ),
                  if (theme.spec.shape.pixel)
                    SettingRow(
                      title: l.themeScanlines,
                      description: l.themeScanlinesDesc,
                      child: SmallSwitch(
                        value: theme.scanlines,
                        onChanged: (v) => _run(context, () => theme.setScanlines(v)),
                      ),
                    ),
                ],
              ),
            ),
            _SceneSection(theme: theme),
            _BackgroundSection(theme: theme),
          ],
        );
      },
    );
  }

  static Future<void> _import(BuildContext context, ThemeController theme) async {
    final l = context.l10n;
    final file = await openFile(acceptedTypeGroups: const [
      XTypeGroup(label: 'theme', extensions: ['json']),
    ]);
    if (file == null || !context.mounted) return;
    try {
      final res = await theme.save(await file.readAsString());
      await theme.select(res.id);
      if (!context.mounted) return;
      final name = theme.themes.where((t) => t.id == res.id).firstOrNull?.displayName(l) ?? res.id;
      showToast(
        context,
        res.warnings.isEmpty ? l.themeImported(name) : l.themeImportedWarn(name, res.warnings.length),
        error: res.warnings.isNotEmpty,
      );
    } catch (e) {
      if (context.mounted) showToast(context, AppState.describeError(e), error: true);
    }
  }
}

/// 改主题出错时给个提示（后台服务没连上、主题被别处删了）
Future<void> _run(BuildContext context, Future<void> Function() action) async {
  try {
    await action();
  } catch (e) {
    if (context.mounted) showToast(context, AppState.describeError(e), error: true);
  }
}

/// 「风景」：页面顶部的宽图与侧边栏底部的小图换成自己的图（design/themes.md 第 7.6 节），
/// 像素主题默认是像素风景与营地；也可以整个关掉
class _SceneSection extends StatelessWidget {
  const _SceneSection({required this.theme});

  final ThemeController theme;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brightness = Theme.of(context).brightness;
    final scene = theme.spec.scene;

    Widget row(String part, String title, String description) {
      final bytes = theme.sceneImage(part, brightness);
      final set = scene?.shaFor(part, brightness) != null;
      return SettingRow(
        title: title,
        description: description,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (bytes != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: Insets.md),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(context.shape.pixel ? 0 : context.shape.sm),
                  child: Image.memory(bytes, width: 64, height: 40, fit: BoxFit.cover, cacheWidth: 128, gaplessPlayback: true),
                ),
              ),
            OutlinedButton(
              onPressed: () => _choose(context, part),
              child: Text(set ? l.themeBackgroundChange : l.themeBackgroundChoose),
            ),
            if (set) ...[
              const SizedBox(width: Insets.sm),
              TextButton(
                onPressed: () => _run(context, () => theme.resetSceneImage(part)),
                child: Text(l.themeSceneReset),
              ),
            ],
          ],
        ),
      );
    }

    return GroupSection(
      title: l.themeSceneGroup,
      footnote: l.themeSceneFootnote,
      child: GroupBox(
        children: [
          SettingRow(
            title: l.themeScenery,
            description: l.themeSceneryDesc,
            child: SmallSwitch(
              value: theme.spec.scenery,
              onChanged: (v) => _run(context, () async {
                final copied = await theme.setScenery(v, l);
                if (copied != null && context.mounted) showToast(context, l.themeCopiedForEdit(copied));
              }),
            ),
          ),
          if (theme.spec.scenery) ...[
            row('header', l.themeSceneHeader, l.themeSceneHeaderDesc),
            row('sidebar', l.themeSceneSidebar, l.themeSceneSidebarDesc),
          ],
        ],
      ),
    );
  }

  Future<void> _choose(BuildContext context, String part) async {
    final l = context.l10n;
    final file = await openFile(acceptedTypeGroups: const [
      XTypeGroup(label: 'images', extensions: ['jpg', 'jpeg', 'png', 'gif']),
    ]);
    if (file == null || !context.mounted) return;
    await _run(context, () async {
      final copied = await theme.setSceneImage(part, file.path, l);
      if (copied != null && context.mounted) showToast(context, l.themeCopiedForEdit(copied));
    });
  }
}

/// 「背景图」：给当前主题选一张图铺在窗口底下，调模糊、遮罩、面板透明度（design/themes.md 第 7 节）。
/// 档位是几个固定值；AI 通过 MCP 可以写任意值，这里显示最接近的一档
class _BackgroundSection extends StatelessWidget {
  const _BackgroundSection({required this.theme});

  final ThemeController theme;

  static const _blurs = [0.0, 8.0, 24.0];
  static const _panels = [0.7, ThemeBackground.defaultSurfaceOpacity, 1.0];

  static double _nearest(List<double> options, double v) =>
      options.reduce((a, b) => (a - v).abs() <= (b - v).abs() ? a : b);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final bg = theme.background;
    final brightness = Theme.of(context).brightness;
    final thumb = theme.backdrop(brightness, 'main', p) ?? theme.backdrop(brightness, 'picker', p);

    // 遮罩「自动」是文字看得清所需的最低浓度，「更浓」「很浓」在它上面加
    final auto = thumb?.minScrim ?? 0.0;
    final scrimLevel = switch ((bg?.scrimOpacity ?? auto) - auto) {
      < 0.075 => 0,
      < 0.225 => 1,
      _ => 2,
    };

    Future<void> edit(void Function(Map<String, dynamic> bg) f) => _run(context, () => theme.editBackground(f));

    return GroupSection(
      title: l.themeBackground,
      footnote: l.themeBackgroundFootnote,
      child: GroupBox(
        children: [
          SettingRow(
            title: l.themeBackground,
            description: l.themeBackgroundDesc,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (thumb != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: Insets.md),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(context.shape.pixel ? 0 : context.shape.sm),
                      child: Image.memory(
                        thumb.sharp ?? thumb.blurred!,
                        width: 64,
                        height: 40,
                        fit: BoxFit.cover,
                        cacheWidth: 128,
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                OutlinedButton(
                  onPressed: () => _choose(context),
                  child: Text(bg == null ? l.themeBackgroundChoose : l.themeBackgroundChange),
                ),
                if (bg != null) ...[
                  const SizedBox(width: Insets.sm),
                  TextButton(
                    onPressed: () => _run(context, theme.removeBackground),
                    child: Text(l.themeBackgroundRemove),
                  ),
                ],
              ],
            ),
          ),
          if (bg != null) ...[
            SettingRow(
              title: l.themeBlur,
              child: Segmented<double>(
                value: _nearest(_blurs, bg.blur),
                segments: [(_blurs[0], l.themeBlurNone), (_blurs[1], l.themeBlurLight), (_blurs[2], l.themeBlurStrong)],
                onChanged: (v) => edit((b) => b['blur'] = v),
              ),
            ),
            SettingRow(
              title: l.themeScrim,
              description: l.themeScrimDesc,
              child: Segmented<int>(
                value: scrimLevel,
                segments: [(0, l.themeScrimAuto), (1, l.themeScrimMore), (2, l.themeScrimMost)],
                onChanged: (v) => edit((b) {
                  final scrim = (b['scrim'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
                  if (v == 0) {
                    scrim.remove('opacity');
                  } else {
                    scrim['opacity'] = double.parse(math.min(1.0, auto + 0.15 * v).toStringAsFixed(2));
                  }
                  if (scrim.isEmpty) {
                    b.remove('scrim');
                  } else {
                    b['scrim'] = scrim;
                  }
                }),
              ),
            ),
            SettingRow(
              title: l.themePanels,
              description: l.themePanelsDesc,
              child: Segmented<double>(
                value: _nearest(_panels, bg.surfaceOpacity),
                segments: [
                  (_panels[0], l.themePanelsClear),
                  (_panels[1], l.themePanelsMedium),
                  (_panels[2], l.themePanelsSolid),
                ],
                onChanged: (v) => edit((b) => b['surfaceOpacity'] = v),
              ),
            ),
            SettingRow(
              title: l.themeAccentFromImage,
              description: l.themeAccentFromImageDesc,
              child: SmallSwitch(
                value: bg.accentFromImage,
                onChanged: (v) => edit((b) => b['accentFromImage'] = v),
              ),
            ),
            SettingRow(
              title: l.themeBackgroundPicker,
              child: SmallSwitch(
                value: bg.scope.contains('picker'),
                onChanged: (v) => edit((b) {
                  final scope = {...bg.scope};
                  v ? scope.add('picker') : scope.remove('picker');
                  b['scope'] = scope.toList();
                }),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _choose(BuildContext context) async {
    final l = context.l10n;
    final file = await openFile(acceptedTypeGroups: const [
      XTypeGroup(label: 'images', extensions: ['jpg', 'jpeg', 'png', 'gif']),
    ]);
    if (file == null || !context.mounted) return;
    await _run(context, () async {
      final copied = await theme.setBackgroundImage(file.path, l);
      if (copied != null && context.mounted) showToast(context, l.themeCopiedForEdit(copied));
    });
  }
}

/// 一张主题卡片：上面是用这套主题真实渲染的缩略界面，下面是名字；悬停时右边出现「⋯」菜单
class _ThemeCard extends StatefulWidget {
  const _ThemeCard({required this.choice, required this.selected});

  final ThemeChoice choice;
  final bool selected;

  @override
  State<_ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<_ThemeCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final s = context.shape;
    final l = context.l10n;
    final theme = AppScope.of(context).theme;
    final t = widget.choice;
    final brightness = Theme.of(context).brightness;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => _run(context, () => theme.select(t.id)),
        child: SizedBox(
          width: 188,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: s.box(
                  color: Colors.transparent,
                  border: widget.selected ? p.accent : (_hover ? p.borderStrong : p.border),
                  radius: s.md + 3,
                ),
                child: ThemePreview(spec: t.spec, brightness: brightness),
              ),
              const SizedBox(height: Insets.sm),
              Row(
                children: [
                  if (widget.selected) ...[
                    Icon(AppIcons.checkmark, size: 13, color: p.accent),
                    const SizedBox(width: 4),
                  ],
                  Expanded(
                    child: Text(
                      t.displayName(l),
                      style: context.text.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 22,
                    height: 18,
                    child: Opacity(opacity: _hover ? 1 : 0, child: _menu(context, theme, t)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menu(BuildContext context, ThemeController theme, ThemeChoice t) {
    final l = context.l10n;
    return PopupMenuButton<String>(
      tooltip: '',
      padding: EdgeInsets.zero,
      iconSize: 16,
      style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap, visualDensity: VisualDensity.compact),
      icon: Icon(AppIcons.ellipsis, size: 16, color: context.palette.textDim),
      onSelected: (v) => switch (v) {
        'use' => _run(context, () => theme.select(t.id)),
        'duplicate' => _run(context, () async {
            final id = await theme.duplicate(t, l.themeCopyName, l);
            await theme.select(id);
          }),
        'export' => _export(context, theme, t),
        'delete' => _delete(context, theme, t),
        _ => null,
      },
      itemBuilder: (_) => [
        if (!widget.selected) PopupMenuItem(value: 'use', height: 34, child: Text(l.themeUse)),
        PopupMenuItem(value: 'duplicate', height: 34, child: Text(l.themeDuplicate)),
        PopupMenuItem(value: 'export', height: 34, child: Text(l.themeExport)),
        if (!t.builtin) ...[
          const PopupMenuDivider(height: 9),
          PopupMenuItem(value: 'delete', height: 34, child: Text(l.themeDelete)),
        ],
      ],
    );
  }

  Future<void> _export(BuildContext context, ThemeController theme, ThemeChoice t) async {
    final l = context.l10n;
    final location = await getSaveLocation(suggestedName: '${t.id}.pasteferry-theme.json');
    if (location == null || !context.mounted) return;
    await _run(context, () async {
      await File(location.path).writeAsString(await theme.exportJson(t.id));
      if (context.mounted) showToast(context, l.themeExported);
    });
  }

  Future<void> _delete(BuildContext context, ThemeController theme, ThemeChoice t) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.themeDeleteConfirm(t.displayName(l))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.themeDelete)),
        ],
      ),
    );
    if (ok == true && context.mounted) await _run(context, () => theme.delete(t.id));
  }
}

/// 「让 AI 帮你做主题」：MCP 服务的配置，复制到 Claude、Cursor 等应用里
class _AskAiDialog extends StatelessWidget {
  const _AskAiDialog();

  /// 本机的 pasteferry-cli：Mac 在 App 包的 Helpers 里，Windows 与 Linux 在程序旁边；找不到时假定在命令路径里
  static String cliPath() {
    final exe = File(Platform.resolvedExecutable);
    final candidates = [
      if (Platform.isMacOS) '${exe.parent.parent.path}/Helpers/pasteferry-cli',
      if (Platform.isWindows) '${exe.parent.path}\\pasteferry-cli.exe',
      if (Platform.isLinux) '${exe.parent.path}/pasteferry-cli',
    ];
    return candidates.where((c) => File(c).existsSync()).firstOrNull ?? 'pasteferry-cli';
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final config = const JsonEncoder.withIndent('  ').convert({
      'mcpServers': {
        'pasteferry': {
          'command': cliPath(),
          'args': ['mcp'],
        },
      },
    });
    return AlertDialog(
      title: Text(l.themeAskAi),
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.themeAskAiBody),
            const SizedBox(height: Insets.md),
            Container(
              padding: const EdgeInsets.all(Insets.md),
              decoration: context.shape.box(color: p.fill, border: p.border, radius: context.shape.sm),
              child: SelectableText(
                config,
                style: TextStyle(fontFamily: context.typography.mono, fontSize: 12, color: p.text, height: 1.5),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.close)),
        FilledButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: config));
            showToast(context, l.themeAskAiCopied);
          },
          child: Text(l.themeAskAiCopy),
        ),
      ],
    );
  }
}

/// 缩略界面：侧边栏、一个分组、一个主按钮，都用 [spec] 自己的颜色、形状与字体画。
/// 「外观」的主题卡片与宣传截图都用它
class ThemePreview extends StatelessWidget {
  const ThemePreview({super.key, required this.spec, required this.brightness, this.width = 176, this.height = 104});

  final AppThemeSpec spec;
  final Brightness brightness;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    // 用系统字体的主题：沿用外面的字体回退顺序（像素主题把原来的字体放在回退里）
    final fallback = Theme.of(context).textTheme.bodyMedium?.fontFamilyFallback ?? const [];
    final system = spec.typography.family == null && fallback.isNotEmpty;
    return Theme(
      data: buildTheme(
        brightness,
        spec: spec,
        fontFamily: system ? fallback.first : null,
        fontFamilyFallback: system ? fallback.skip(1).toList() : null,
      ),
      child: Builder(
        builder: (context) {
          final p = context.palette;
          final s = context.shape;
          Widget line(double w, Color c) => Container(width: w, height: 4, color: c);
          // 「Aa」用这套主题自己的字体，不继承外面的
          return DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium!,
            child: ClipRect(
              child: SizedBox(
                width: width,
                height: height,
                child: Row(
                  children: [
                    Container(
                      width: width / 4,
                      color: p.sidebar,
                      padding: const EdgeInsets.fromLTRB(6, 10, 6, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 10,
                            decoration: s.box(color: p.selection, radius: s.sm),
                            padding: const EdgeInsetsDirectional.only(start: 3),
                            alignment: AlignmentDirectional.centerStart,
                            child: line(width / 11, p.accent),
                          ),
                          const SizedBox(height: 6),
                          line(width / 8, p.textFaint),
                          const SizedBox(height: 6),
                          line(width / 10, p.textFaint),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: p.background,
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Aa', style: TextStyle(fontSize: 12, height: 1, color: p.text)),
                            const SizedBox(height: 6),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(6),
                                decoration: s.box(color: p.surface, border: p.border, radius: s.sm),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    line(width / 3, p.text),
                                    const SizedBox(height: 4),
                                    line(width / 4.4, p.textDim),
                                    const Spacer(),
                                    Align(
                                      alignment: AlignmentDirectional.bottomEnd,
                                      child: Container(
                                        width: 34,
                                        height: 12,
                                        decoration: s.box(
                                          color: p.accent,
                                          border: s.pixel ? p.borderStrong : null,
                                          radius: s.sm,
                                          bevel: (p.bevelLight, p.bevelDark),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
