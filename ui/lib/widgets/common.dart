import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';
import '../i18n.dart';
import '../icons.dart';

/// 页面统一的标题区。保证各页视觉节奏一致。
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.backLabel,
    this.onBack,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;

  /// 二级页：标题上方的「‹ 上一级」
  final String? backLabel;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final back = onBack != null;
    return Padding(
      // 顶部留出 macOS 红绿灯所在的标题栏高度；二级页的返回链接占掉其中一部分
      padding: EdgeInsets.fromLTRB(Insets.xl, back ? 18 : 44, Insets.xl, Insets.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (back) _BackLink(label: backLabel ?? '', onTap: onBack!),
                Text(title, style: context.text.headlineSmall),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: context.text.bodySmall),
                ],
              ],
            ),
          ),
          for (final a in actions) ...[const SizedBox(width: Insets.sm), a],
        ],
      ),
    );
  }
}

class _BackLink extends StatelessWidget {
  const _BackLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.palette.accent;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            height: 22,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(AppIcons.chevronLeft, size: 13, color: color),
                const SizedBox(width: 2),
                Text(label, style: context.text.bodyMedium?.copyWith(color: color)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 分组容器：白底、细边框，内部各行之间用缩进的细线分隔。
/// 与「系统设置」的分组列表同一种做法——用分隔线而不是一张张独立卡片。
class GroupBox extends StatelessWidget {
  const GroupBox({super.key, required this.children, this.dividerIndent = Insets.lg});

  final List<Widget> children;
  final double dividerIndent;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) Divider(indent: dividerIndent),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// 分组的标题与脚注。
class GroupSection extends StatelessWidget {
  const GroupSection({super.key, required this.title, required this.child, this.footnote});

  final String title;
  final String? footnote;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: Insets.sm),
              child: Text(title, style: context.text.titleSmall),
            ),
          child,
          if (footnote != null)
            Padding(
              padding: const EdgeInsets.only(left: 2, top: Insets.sm, right: Insets.xl),
              child: Text(footnote!, style: context.text.bodySmall),
            ),
        ],
      ),
    );
  }
}

/// 设置项行：左侧标题与说明，右侧控件。
class SettingRow extends StatelessWidget {
  const SettingRow({super.key, required this.title, required this.child, this.description, this.descriptionColor});

  final String title;
  final String? description;
  final Widget child;

  /// 说明文字的颜色，出错时用红色；不给时用默认的次要文字色
  final Color? descriptionColor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: context.text.labelLarge),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(description!, style: context.text.bodySmall?.copyWith(color: descriptionColor)),
                  ],
                ],
              ),
            ),
            const SizedBox(width: Insets.lg),
            child,
          ],
        ),
      ),
    );
  }
}

/// macOS 尺寸的开关：Material 默认的开关对桌面来说太大。
class SmallSwitch extends StatelessWidget {
  const SmallSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: FittedBox(
        child: Switch(value: value, onChanged: onChanged),
      ),
    );
  }
}

/// 分段控件，对应 macOS 的 NSSegmentedControl：浅灰轨道，选中段浮起为白色。
class Segmented<T> extends StatelessWidget {
  const Segmented({
    super.key,
    required this.value,
    required this.segments,
    required this.onChanged,
  });

  final T value;
  final List<(T, String)> segments;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: p.fill,
        borderRadius: BorderRadius.circular(Radii.sm + 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (v, label) in segments)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => onChanged(v),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: 4),
                  decoration: BoxDecoration(
                    color: v == value ? p.surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(Radii.sm - 1),
                    boxShadow: v == value
                        ? const [
                            BoxShadow(
                                color: Color(0x1A000000), blurRadius: 2, offset: Offset(0, 1)),
                          ]
                        : null,
                  ),
                  child: Text(
                    label,
                    style: context.text.labelMedium?.copyWith(
                      color: v == value ? p.text : p.textDim,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 输入框里已经确定的文字：输入法正在组字时，组字的部分（比如拼音 hui）不算，选字上屏后才算。
String committedText(TextEditingValue value) {
  final composing = value.composing;
  if (!composing.isValid || composing.isCollapsed) return value.text;
  return composing.textBefore(value.text) + composing.textAfter(value.text);
}

/// 搜索框，对应 macOS 的 NSSearchField：浅灰底、左边放大镜，输入后右边出现清除按钮。
/// 按 Esc 时有字就清空，没字就交出焦点。不给 [width] 时占满父级给的宽度。
/// 高度定为 28，与旁边的 [Segmented] 一样高；不跟着字体变，否则换个系统字体就高低不齐。
/// [onChanged] 收到的是 [committedText]：用输入法打拼音时不拿拼音去搜。
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.clearTooltip,
    required this.onChanged,
    this.focusNode,
    this.width,
  });

  final TextEditingController controller;
  final String hint;
  final String clearTooltip;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;
  final double? width;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late String _reported = committedText(widget.controller.value);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_report);
  }

  @override
  void didUpdateWidget(SearchField old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(_report);
      widget.controller.addListener(_report);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_report);
    super.dispose();
  }

  /// 组字结束时文字可能没变（输入法直接上屏英文），所以监听整个输入框，而不是 TextField.onChanged
  void _report() {
    final text = committedText(widget.controller.value);
    if (text == _reported) return;
    _reported = text;
    widget.onChanged(text);
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final focusNode = widget.focusNode;
    final p = context.palette;
    final round = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Radii.sm),
      borderSide: BorderSide.none,
    );
    return SizedBox(
      width: widget.width,
      height: 28,
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.escape): () {
            if (controller.text.isNotEmpty) {
              controller.clear();
            } else {
              focusNode?.unfocus();
            }
          },
        },
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) => TextField(
            controller: controller,
            focusNode: focusNode,
            style: context.text.bodyMedium,
            expands: true,
            maxLines: null,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: widget.hint,
              fillColor: p.fill,
              contentPadding: EdgeInsets.zero,
              border: round,
              enabledBorder: round,
              focusedBorder: round.copyWith(borderSide: BorderSide(color: p.accent, width: 1.5)),
              prefixIcon: Icon(AppIcons.search, size: 14, color: p.textFaint),
              prefixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 0),
              suffixIcon: controller.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: controller.clear,
                      tooltip: widget.clearTooltip,
                      icon: Icon(AppIcons.clearField, size: 14, color: p.textFaint),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 28, minHeight: 0),
                      style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    ),
              suffixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 0),
            ),
          ),
        ),
      ),
    );
  }
}

/// 空状态。给出下一步该做什么，而不是只说"暂无数据"。
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: context.palette.textFaint),
            const SizedBox(height: Insets.lg),
            Text(title, style: context.text.titleMedium, textAlign: TextAlign.center),
            if (description != null) ...[
              const SizedBox(height: 6),
              Text(description!, style: context.text.bodySmall, textAlign: TextAlign.center),
            ],
            if (action != null) ...[
              const SizedBox(height: Insets.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// 行内提示条：说明问题，并给出解决它的按钮。
class Notice extends StatelessWidget {
  const Notice({
    super.key,
    required this.title,
    required this.message,
    this.action,
    this.icon,
    this.iconColor,
  });

  final String title;
  final String message;
  final Widget? action;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final icon = this.icon ?? AppIcons.exclamationmarkCircle;
    return Container(
      padding: const EdgeInsets.fromLTRB(Insets.lg, Insets.md, Insets.md, Insets.md),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: p.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor ?? p.warning),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.text.labelLarge),
                const SizedBox(height: 2),
                Text(message, style: context.text.bodySmall),
              ],
            ),
          ),
          if (action != null) ...[const SizedBox(width: Insets.md), action!],
        ],
      ),
    );
  }
}

/// 状态圆点 + 文字。设备在线状态、连接状态都用它，保持一致。
class StatusDot extends StatelessWidget {
  const StatusDot({super.key, required this.color, required this.label, this.labelColor});

  final Color color;
  final String label;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: context.text.bodySmall?.copyWith(color: labelColor)),
      ],
    );
  }
}

/// App 图标。侧边栏、欢迎页、关于里都用同一张图，而不是另画一个符号。
class AppMark extends StatelessWidget {
  const AppMark({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/app_icon.png',
      width: size,
      height: size,
      filterQuality: FilterQuality.medium,
    );
  }
}

/// 可点击的图标按钮，悬停时出现浅色底。
class IconAction extends StatefulWidget {
  const IconAction({super.key, required this.icon, required this.tooltip, this.onTap, this.color});

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  /// 图标的颜色；不给时用次要文字色，悬停时变深。亮着的星标用强调色
  final Color? color;

  @override
  State<IconAction> createState() => _IconActionState();
}

class _IconActionState extends State<IconAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _hovered ? p.hover : Colors.transparent,
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Icon(widget.icon, size: 16, color: widget.color ?? (_hovered ? p.text : p.textDim)),
          ),
        ),
      ),
    );
  }
}

/// 字节数的可读形式。
String humanBytes(int n) {
  if (n < 1024) return '$n B';
  const units = ['KB', 'MB', 'GB', 'TB'];
  var v = n / 1024;
  var i = 0;
  while (v >= 1024 && i < units.length - 1) {
    v /= 1024;
    i++;
  }
  return '${v.toStringAsFixed(v >= 100 ? 0 : 1)} ${units[i]}';
}

/// 时长：整天的按天说，否则按小时。
String durationLabel(AppLocalizations l, int seconds) => seconds % 86400 == 0
    ? l.durationDays(seconds ~/ 86400)
    : l.durationHours((seconds / 3600).round());

/// 相对时间。刚刚发生的事用"刚刚"比"14:03:22"更符合直觉。
String relativeTime(DateTime t, {DateTime? now}) {
  final d = (now ?? DateTime.now()).difference(t);
  final l = appL10n;
  if (d.inSeconds < 10) return l.justNow;
  if (d.inMinutes < 1) return l.secondsAgo(d.inSeconds);
  if (d.inHours < 1) return l.minutesAgo(d.inMinutes);
  if (d.inDays < 1) return l.hoursAgo(d.inHours);
  if (d.inDays < 7) return l.daysAgo(d.inDays);
  return l.monthDay(t.month, t.day);
}

/// 底部的提示条。给了 [actionLabel] 时右边多一个按钮，比如取消收藏后的「撤销」。
///
/// 放在根 Overlay 的最上层，不用 ScaffoldMessenger 的 SnackBar：SnackBar 画在页面里，
/// 开着对话框时（比如在「反馈问题」里拷贝报告）会被对话框和它的遮罩盖住。
void showToast(
  BuildContext context,
  String message, {
  bool error = false,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) return;
  _toast?.remove();
  final p = context.palette;
  final hasAction = actionLabel != null && onAction != null;
  late final OverlayEntry entry;
  void dismiss() {
    if (_toast != entry) return;
    _toast = null;
    entry.remove();
  }

  entry = OverlayEntry(
    builder: (_) => _Toast(
      icon: Icon(
        error ? AppIcons.exclamationmarkCircle : AppIcons.checkmarkCircle,
        size: 16,
        color: error
            ? PaletteColors.onDark(p.danger)
            : PaletteColors.onDark(p.online),
      ),
      message: message,
      actionLabel: hasAction ? actionLabel : null,
      onAction: hasAction
          ? () {
              dismiss();
              onAction();
            }
          : null,
      // 出错的提示常带着原因，要多看一会儿
      duration: Duration(seconds: hasAction || error ? 6 : 3),
      onDone: dismiss,
    ),
  );
  _toast = entry;
  overlay.insert(entry);
}

OverlayEntry? _toast;

class _Toast extends StatefulWidget {
  const _Toast({
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.duration,
    required this.onDone,
  });

  final Widget icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration duration;
  final VoidCallback onDone;

  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> with SingleTickerProviderStateMixin {
  late final _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  )..forward();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, () async {
      await _fade.reverse();
      widget.onDone();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).snackBarTheme;
    final style =
        theme.contentTextStyle ??
        const TextStyle(fontSize: 13, color: Colors.white);
    return Positioned(
      left: 0,
      right: 0,
      bottom: 16,
      child: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: theme.backgroundColor,
            elevation: theme.elevation ?? 6,
            shape: theme.shape,
            child: SizedBox(
              width: 360,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  14,
                  widget.actionLabel == null ? 16 : 8,
                  14,
                ),
                child: DefaultTextStyle(
                  style: style,
                  child: Row(
                    children: [
                      widget.icon,
                      const SizedBox(width: Insets.sm),
                      Expanded(child: Text(widget.message)),
                      if (widget.actionLabel != null)
                        TextButton(
                          onPressed: widget.onAction,
                          style: TextButton.styleFrom(
                            foregroundColor:
                                theme.actionTextColor ??
                                Theme.of(context).colorScheme.inversePrimary,
                          ),
                          child: Text(widget.actionLabel!),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 提示条是深色底，浅色模式下的深绿、深红在上面看不清，换成亮色版本。
abstract final class PaletteColors {
  static Color onDark(Color c) {
    if (c == AppPalette.light.online) return AppPalette.dark.online;
    if (c == AppPalette.light.danger) return AppPalette.dark.danger;
    return c;
  }
}

/// 菜单里带勾的一行：勾的位置固定在左边，没选中时留空，文字对齐
Widget menuCheckRow(BuildContext context, String title, bool checked) => Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    SizedBox(
      width: 20,
      child: checked ? Icon(AppIcons.checkmark, size: 13, color: context.palette.accent) : null,
    ),
    Text(title),
  ],
);

/// 菜单里带说明的选择项：左边是勾，标题下面一行小字说明
Widget menuChoiceRow(BuildContext context, String title, String description, bool checked, {double width = 280}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            child: checked
                ? Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(AppIcons.checkmark, size: 13, color: context.palette.accent),
                  )
                : null,
          ),
          SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: context.text.labelLarge),
                const SizedBox(height: 2),
                Text(description, style: context.text.bodySmall?.copyWith(color: context.palette.textDim)),
              ],
            ),
          ),
        ],
      ),
    );
