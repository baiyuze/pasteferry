import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_state.dart';
import '../i18n.dart';
import '../icons.dart';
import '../main.dart' show AppScope;
import '../theme.dart';
import 'host.dart';

/// 手机 App 的界面部件。样子与手机网页传输（web/phone/src/ui.tsx、App.tsx）一一对应，
/// 配色、圆角、间距用桌面的设计系统（theme.dart）：两边只是功能多少不同，看起来是同一个产品。

/// 次要按钮：浅灰底、正文色，对应网页的 `Button kind="secondary"`。
ButtonStyle secondaryButtonStyle(BuildContext context) {
  final p = context.palette;
  return FilledButton.styleFrom(
    backgroundColor: p.fill,
    foregroundColor: p.text,
    disabledBackgroundColor: p.fill.withValues(alpha: 0.4),
    disabledForegroundColor: p.text.withValues(alpha: 0.4),
    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
  );
}

/// 页头：上面一行是连接的电脑与状态，下面是大标题，对应网页的 header。
class MobileHeader extends StatelessWidget {
  const MobileHeader({super.key, required this.title, this.trailing});

  final String title;

  /// 右上角的圆形按钮
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.lg, Insets.md, Insets.lg, Insets.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 36,
            child: Row(
              children: [
                const Expanded(child: ConnectionLine()),
                ?trailing,
              ],
            ),
          ),
          const SizedBox(height: Insets.sm),
          Text(title, style: context.text.headlineMedium),
        ],
      ),
    );
  }
}

/// 页头右上角 36×36 的圆形按钮，浅灰底。
class HeaderButton extends StatelessWidget {
  const HeaderButton({super.key, required this.icon, required this.tooltip, required this.onTap});

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: p.fill,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox.square(dimension: 36, child: Icon(icon, size: 20, color: p.text)),
        ),
      ),
    );
  }
}

/// 连接状态：电脑图标、在线的电脑名、状态点与文字。和网页页头第一行一样。
class ConnectionLine extends StatelessWidget {
  const ConnectionLine({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = context.palette;
    final l = context.l10n;
    final online = state.peers.where((d) => d.online).map((d) => d.name).toList();
    final String? device = switch (state.link) {
      LinkState.online when online.isNotEmpty => online.join('、'),
      LinkState.online when state.peers.isNotEmpty => state.peers.first.name,
      _ => null,
    };
    final (color, status) = switch (state.link) {
      LinkState.connecting => (p.textDim, l.linkConnecting),
      LinkState.offline => (p.danger, state.error ?? l.linkServiceNotRunning),
      LinkState.online when online.isNotEmpty => (p.online, l.online),
      LinkState.online when state.peers.isEmpty => (p.textDim, l.mNoPairedDevices),
      LinkState.online => (p.textDim, l.offline),
    };
    return Row(
      children: [
        Icon(AppIcons.deviceLaptop, size: 18, color: p.textDim),
        const SizedBox(width: Insets.sm),
        if (device != null) ...[
          Flexible(
            child: Text(
              device,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: Insets.sm),
        ],
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13, color: color),
          ),
        ),
      ],
    );
  }
}

/// 搜索框：40 高、浅灰底，对应网页的 SearchField。
class MobileSearchField extends StatefulWidget {
  const MobileSearchField({super.key, required this.hint, required this.onChanged});

  final String hint;
  final ValueChanged<String> onChanged;

  @override
  State<MobileSearchField> createState() => _MobileSearchFieldState();
}

class _MobileSearchFieldState extends State<MobileSearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      decoration: BoxDecoration(color: p.fill, borderRadius: BorderRadius.circular(Radii.md)),
      child: Row(
        children: [
          Icon(AppIcons.search, size: 18, color: p.textDim),
          const SizedBox(width: Insets.sm),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (v) {
                setState(() {});
                widget.onChanged(v);
              },
              textInputAction: TextInputAction.search,
              style: context.text.bodyLarge,
              decoration: InputDecoration(
                hintText: widget.hint,
                filled: false,
                isCollapsed: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();
                setState(() {});
                widget.onChanged('');
              },
              child: Icon(FluentIcons.dismiss_circle_20_filled, size: 18, color: p.textFaint),
            ),
        ],
      ),
    );
  }
}

/// 分段选择：浅灰轨道，选中的一段是白底、加粗、带一点阴影，对应网页的 Segmented 与桌面的 Segmented。
class MobileSegmented<T> extends StatelessWidget {
  const MobileSegmented({super.key, required this.value, required this.segments, required this.onChanged});

  final T value;
  final List<(T, String)> segments;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(color: p.fill, borderRadius: BorderRadius.circular(Radii.md)),
      child: Row(
        children: [
          for (final (v, label) in segments)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(v),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: v == value ? (dark ? p.border : p.surface) : Colors.transparent,
                    borderRadius: BorderRadius.circular(7),
                    boxShadow: v == value
                        ? const [BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 1))]
                        : null,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: v == value ? FontWeight.w600 : FontWeight.w400,
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

/// 白底圆角的一组，行与行之间是从文字处开始的分隔线，对应网页的 Group 与 Separator。
class MobileGroup extends StatelessWidget {
  const MobileGroup({super.key, required this.children, this.title, this.footer, this.inset = Insets.lg});

  final List<Widget> children;
  final String? title;
  final String? footer;

  /// 分隔线左边的缩进：行首有图标时对齐到文字
  final double inset;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.lg, 0, Insets.lg, Insets.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(Insets.xs, 0, Insets.xs, Insets.sm),
              child: Text(title!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: p.textDim)),
            ),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: BorderRadius.circular(Radii.lg),
              border: Border.all(color: p.border),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0) Divider(indent: inset, height: 1),
                    children[i],
                  ],
                ],
              ),
            ),
          ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(Insets.xs, Insets.sm, Insets.xs, 0),
              child: Text(footer!, style: context.text.bodySmall),
            ),
        ],
      ),
    );
  }
}

/// 组里的一行：标题、说明、右边的开关或按钮。
class MobileTile extends StatelessWidget {
  const MobileTile({super.key, required this.title, this.subtitle, this.trailing, this.leading, this.onTap});

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: Insets.md)],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: context.text.bodyLarge?.copyWith(fontSize: 16, height: 1.35)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: context.text.bodySmall),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: Insets.md), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}

/// 底部标签栏：半透明底、顶上一条细线，选中的标签换成实心图标、用强调色，对应网页的 TabBar。
class MobileTabBar extends StatelessWidget {
  const MobileTabBar({super.key, required this.index, required this.items, required this.onSelect});

  final int index;

  /// (线框图标, 实心图标, 文字)
  final List<(IconData, IconData, String)> items;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: p.background.withValues(alpha: 0.94),
        border: Border(top: BorderSide(color: p.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: i == index,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onSelect(i),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(i == index ? items[i].$2 : items[i].$1, size: 24, color: i == index ? p.accent : p.textDim),
                          const SizedBox(height: 2),
                          Text(
                            items[i].$3,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: i == index ? p.accent : p.textDim,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 不在 Wi-Fi 上时页面顶部的提示：一期只在局域网里同步。
class LanNotice extends StatefulWidget {
  const LanNotice({super.key});

  @override
  State<LanNotice> createState() => _LanNoticeState();
}

class _LanNoticeState extends State<LanNotice> with WidgetsBindingObserver {
  bool _onLan = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (s == AppLifecycleState.resumed) _check();
  }

  Future<void> _check() async {
    try {
      final on = await Host.onLan();
      if (mounted && on != _onLan) setState(() => _onLan = on);
    } on MissingPluginException {
      // 测试里没有宿主
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_onLan) return const SizedBox.shrink();
    final l = context.l10n;
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.lg, 0, Insets.lg, Insets.md),
      child: Container(
        padding: const EdgeInsets.all(Insets.lg),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(color: p.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(AppIcons.wifiOff, size: 22, color: p.warning),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.mNotOnLanTitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(l.mNotOnLanBody, style: context.text.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
