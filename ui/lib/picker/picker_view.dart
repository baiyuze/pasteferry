import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../icons.dart';
import '../records.dart';
import '../theme.dart';
import '../widgets/common.dart' show committedText, humanBytes, relativeTime;
import '../widgets/record_hover.dart';
import 'picker_state.dart';

/// 快捷粘贴窗口。窗口本身由原生外壳创建（Mac 上是不抢焦点的 NSPanel），大小固定，这里画满整个窗口。
/// 见 design/quick-paste-and-favorites.md 第 2.6 节的示意图。
class PickerApp extends StatelessWidget {
  const PickerApp({super.key, required this.state});

  final PickerState state;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: state.language,
      builder: (context, language, _) {
        final locale = localeFromSetting(language);
        final tag = (locale ?? resolveLocale(WidgetsBinding.instance.platformDispatcher.locales)).toLanguageTag();
        ThemeData theme(Brightness b) => buildTheme(b, language: tag).copyWith(
              // 窗口是透明的，圆角外面要透出桌面（Mac）
              scaffoldBackgroundColor: Colors.transparent,
              canvasColor: Colors.transparent,
            );
        return MaterialApp(
          title: 'PasteFerry',
          debugShowCheckedModeBanner: false,
          color: Colors.transparent,
          theme: theme(Brightness.light),
          darkTheme: theme(Brightness.dark),
          locale: locale,
          supportedLocales: supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          localeListResolutionCallback: (preferred, _) => resolveLocale(preferred),
          builder: (context, child) {
            appL10n = context.l10n;
            return child!;
          },
          home: PickerView(state: state),
        );
      },
    );
  }
}

class PickerView extends StatefulWidget {
  const PickerView({super.key, required this.state});

  final PickerState state;

  /// 每一行的高度
  static const rowHeight = 36.0;

  @override
  State<PickerView> createState() => _PickerViewState();
}

class _PickerViewState extends State<PickerView> {
  final _search = TextEditingController();
  final _focus = FocusNode();
  final _scroll = ScrollController();

  PickerState get s => widget.state;
  static final bool _mac = Platform.isMacOS;

  @override
  void initState() {
    super.initState();
    s.shown.addListener(_onShown);
    s.addListener(_followSelection);
    _search.addListener(_onSearch);
  }

  @override
  void dispose() {
    s.shown.removeListener(_onShown);
    s.removeListener(_followSelection);
    _search.dispose();
    _focus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  /// 用输入法打拼音时不拿拼音去搜，选字上屏后再搜（见 [committedText]）
  void _onSearch() {
    final q = committedText(_search.value);
    if (q != s.query) s.setQuery(q);
  }

  void _onShown() {
    _search.clear();
    if (_scroll.hasClients) _scroll.jumpTo(0);
    _focus.requestFocus();
  }

  /// 用键盘上下移动时，选中的那一行要留在视野里。
  void _followSelection() {
    if (!_scroll.hasClients) return;
    final top = s.selected * PickerView.rowHeight;
    final view = _scroll.position.viewportDimension;
    if (top < _scroll.offset) {
      _scroll.jumpTo(top);
    } else if (top + PickerView.rowHeight > _scroll.offset + view) {
      _scroll.jumpTo(top + PickerView.rowHeight - view);
    }
  }

  bool get _composing => committedText(_search.value) != _search.text;

  /// 修饰键：Mac 上是 ⌘，其他平台是 Ctrl（序号用 Alt）
  bool get _cmd => _mac ? HardwareKeyboard.instance.isMetaPressed : HardwareKeyboard.instance.isControlPressed;

  KeyEventResult _onKey(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent && e is! KeyRepeatEvent) return KeyEventResult.ignored;
    // 正在用输入法打字：数字选候选、回车上屏，都交给输入法
    if (_composing) return KeyEventResult.ignored;
    final kb = HardwareKeyboard.instance;
    final k = e.logicalKey;
    final list = s.visible;
    final current = s.selected < list.length ? list[s.selected] : null;

    if (k == LogicalKeyboardKey.escape) {
      if (_search.text.isNotEmpty) {
        _search.clear();
      } else {
        s.close();
      }
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowDown || (_mac && kb.isControlPressed && k == LogicalKeyboardKey.keyN)) {
      s.moveSelection(1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowUp || (_mac && kb.isControlPressed && k == LogicalKeyboardKey.keyP)) {
      s.moveSelection(-1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.tab) {
      s.cycleTab(kb.isShiftPressed ? -1 : 1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.enter || k == LogicalKeyboardKey.numpadEnter) {
      if (e is KeyRepeatEvent || current == null) return KeyEventResult.handled;
      s.choose(current, plain: kb.isShiftPressed, copyOnly: _cmd);
      return KeyEventResult.handled;
    }
    if (_cmd && k == LogicalKeyboardKey.keyD && current != null) {
      s.toggleFavorite(current);
      return KeyEventResult.handled;
    }
    final delete = (_mac && kb.isMetaPressed && k == LogicalKeyboardKey.backspace) ||
        (!_mac && kb.isShiftPressed && k == LogicalKeyboardKey.delete);
    if (delete && current != null && s.tab != PickerTab.favorites) {
      s.delete(current);
      return KeyEventResult.handled;
    }
    // 序号：搜索框为空时直接按数字；任何时候按住 ⌘（Mac）或 Alt（Windows、Linux）
    final digit = _digit(e);
    if (digit != null && e is KeyDownEvent) {
      final withModifier = _mac ? kb.isMetaPressed : kb.isAltPressed;
      if (withModifier || (_search.text.isEmpty && !kb.isControlPressed && !kb.isMetaPressed && !kb.isAltPressed)) {
        s.chooseIndex(digit - 1);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  static int? _digit(KeyEvent e) {
    final u = e.physicalKey.usbHidUsage;
    final one = PhysicalKeyboardKey.digit1.usbHidUsage;
    if (u >= one && u <= PhysicalKeyboardKey.digit9.usbHidUsage) return 1 + u - one;
    final pad = PhysicalKeyboardKey.numpad1.usbHidUsage;
    if (u >= pad && u <= PhysicalKeyboardKey.numpad9.usbHidUsage) return 1 + u - pad;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Material(
      type: MaterialType.transparency,
      child: Focus(
        onKeyEvent: _onKey,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: p.surface,
            // Mac 上窗口透明，自己画圆角；Windows 11 的圆角由系统画，Linux 用直角
            borderRadius: _mac ? BorderRadius.circular(Radii.lg) : null,
            border: Border.all(color: p.border),
          ),
          child: ListenableBuilder(
            listenable: s,
            builder: (context, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _searchBar(context),
                _tabs(context),
                Divider(height: 1, color: p.separator),
                Expanded(child: _list(context)),
                Divider(height: 1, color: p.separator),
                _footer(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          const SizedBox(width: Insets.md),
          Icon(AppIcons.search, size: 16, color: p.textFaint),
          const SizedBox(width: Insets.sm),
          Expanded(
            child: TextField(
              controller: _search,
              focusNode: _focus,
              autofocus: true,
              style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                hintText: l.pickerSearch,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: Insets.md),
        ],
      ),
    );
  }

  Widget _tabs(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    String label(PickerTab t) => t.filter?.label(l) ?? l.navFavorites;
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          const SizedBox(width: Insets.sm),
          for (final t in PickerTab.values)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  s.setTab(t);
                  _focus.requestFocus();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: t == s.tab ? p.fill : Colors.transparent,
                    borderRadius: BorderRadius.circular(Radii.sm),
                  ),
                  child: Text(
                    label(t),
                    style: context.text.labelMedium?.copyWith(
                      color: t == s.tab ? p.text : p.textDim,
                      fontWeight: t == s.tab ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _list(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    if (!s.connected) return _empty(context, l.linkServiceNotRunning);
    final list = s.visible;
    if (list.isEmpty) {
      final q = s.query.trim();
      return _empty(
        context,
        q.isNotEmpty
            ? l.searchEmptyTitle(q)
            : s.tab == PickerTab.favorites
                ? l.favoritesEmptyTitle
                : s.tab == PickerTab.all
                    ? l.historyEmptyTitle
                    : l.historyEmptyFilteredTitle,
      );
    }
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.symmetric(vertical: Insets.xs),
      itemExtent: PickerView.rowHeight,
      itemCount: list.length,
      itemBuilder: (context, i) => _PickerRow(
        key: ValueKey(list[i].id),
        state: s,
        record: list[i],
        index: i,
        selected: i == s.selected,
        number: i < 9 ? (s.query.trim().isEmpty ? '${i + 1}' : (_mac ? '⌘${i + 1}' : 'Alt+${i + 1}')) : null,
        favoritesTab: s.tab == PickerTab.favorites,
        dim: p.textFaint,
      ),
    );
  }

  Widget _empty(BuildContext context, String text) => Center(
        child: Padding(
          padding: const EdgeInsets.all(Insets.xl),
          child: Text(text, style: context.text.bodyMedium?.copyWith(color: context.palette.textDim), textAlign: TextAlign.center),
        ),
      );

  Widget _footer(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final style = context.text.bodySmall?.copyWith(color: p.textDim);
    final Widget content;
    final pasteKey = _mac ? '⌘V' : 'Ctrl+V';
    if (s.error != null) {
      content = Text(s.error!, style: style?.copyWith(color: p.danger), maxLines: 1, overflow: TextOverflow.ellipsis);
    } else if (s.pendingId != null) {
      content = Text(l.pickerDownloading, style: style);
    } else if (!s.canPaste) {
      final notTrusted = s.pasteBlockedReason == 'not_trusted';
      content = Row(
        children: [
          Flexible(
            child: Text(
              [l.pickerPasteManually(pasteKey), if (notTrusted) l.pickerGrantHint].join(' · '),
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (notTrusted) ...[
            const SizedBox(width: Insets.sm),
            TextButton(
              onPressed: s.host.requestPermission,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
                minimumSize: const Size(0, 22),
              ),
              child: Text(l.quickPasteAllow),
            ),
          ],
        ],
      );
    } else {
      // 按键画成小键帽，与系统菜单里快捷键的写法一致：Mac 用 ⇧ ⌘ 符号，其他平台写键名
      const enter = _Key.enter();
      final shift = _Key(_mac ? '⇧' : 'Shift');
      final cmd = _Key(_mac ? '⌘' : 'Ctrl');
      final fav = s.tab == PickerTab.favorites ? l.pickerUnfavoriteHint : l.favoriteAction;
      content = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            _KeyHint(keys: const [enter], label: l.pickerPaste),
            if (s.tab != PickerTab.favorites) _KeyHint(keys: [shift, enter], label: l.pickerPlainText),
            _KeyHint(keys: [cmd, enter], label: l.pickerCopyOnly),
            _KeyHint(keys: [cmd, const _Key('D')], label: fav),
            _KeyHint(keys: [_Key(_mac ? 'esc' : 'Esc')], label: l.close),
          ],
        ),
      );
    }
    return SizedBox(
      height: 30,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.md),
        child: Align(alignment: Alignment.centerLeft, child: content),
      ),
    );
  }
}

/// 一个按键：文字，或者回车键的图标。
class _Key {
  const _Key(this.text) : enter = false;
  const _Key.enter()
      : text = '',
        enter = true;
  final String text;
  final bool enter;
}

/// 底栏的一条按键提示：几个小键帽，后面跟着说明。
class _KeyHint extends StatelessWidget {
  const _KeyHint({required this.keys, required this.label});

  final List<_Key> keys;
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final capStyle = context.text.labelSmall?.copyWith(color: p.textDim, fontSize: 10.5, height: 1.0);
    return Padding(
      padding: const EdgeInsets.only(right: Insets.md),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final k in keys)
            Container(
              height: 16,
              constraints: const BoxConstraints(minWidth: 16),
              margin: const EdgeInsets.only(right: 2),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: p.fill,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: p.border, width: 0.5),
              ),
              child: k.enter ? Icon(AppIcons.returnKey, size: 10, color: p.textDim) : Text(k.text, style: capStyle),
            ),
          const SizedBox(width: 3),
          Text(label, style: context.text.bodySmall?.copyWith(color: p.textDim)),
        ],
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    super.key,
    required this.state,
    required this.record,
    required this.index,
    required this.selected,
    required this.number,
    required this.favoritesTab,
    required this.dim,
  });

  final PickerState state;
  final ClipRecord record;
  final int index;
  final bool selected;
  final String? number;
  final bool favoritesTab;
  final Color dim;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final r = record;
    final enabled = PickerState.selectable(r);
    final onAccent = selected && enabled;
    final fg = !enabled ? p.textFaint : (onAccent ? Colors.white : p.text);
    final sub = onAccent ? Colors.white.withValues(alpha: 0.8) : p.textFaint;
    final pending = state.pendingId == r.id;
    final isImage = r.kind == ClipKind.CLIP_KIND_IMAGE || (r.kind == ClipKind.CLIP_KIND_FILE && r.imageCount == 1 && r.items.length == 1);
    if (isImage) state.loadThumbnail(r);
    final thumb = isImage ? state.thumbnailOf(r.id) : null;
    final meta = [
      if (r.status == ClipStatus.CLIP_STATUS_REMOTE_ONLY) humanBytes(r.totalSize.toInt()),
      if (!r.outgoing) r.originDeviceName,
      if (r.favorite) appL10n.favoritedAt(shortDate(favoritedTime(r))) else relativeTime(recordTime(r)),
    ].join(' · ');

    return RecordHover(
      record: r,
      details: state,
      child: MouseRegion(
        // 只认鼠标移动：键盘上下移动时列表滚动，不能让鼠标下面的那一行把选中抢走
        onHover: (_) => state.select(index),
        cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => state.chooseIndex(index),
          onSecondaryTapUp: (d) => _menu(context, d.globalPosition),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: Insets.xs),
            padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
            decoration: BoxDecoration(
              color: onAccent ? p.accent : (selected ? p.hover : Colors.transparent),
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: Platform.isMacOS ? 26 : 40,
                  child: number == null
                      ? null
                      : Text(number!, style: context.text.labelMedium?.copyWith(color: onAccent ? Colors.white : dim)),
                ),
                SizedBox(
                  width: 22,
                  height: 22,
                  child: thumb != null && thumb.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.file(File(thumb), fit: BoxFit.cover, cacheWidth: 64,
                              errorBuilder: (_, _, _) => Icon(kindIcon(r), size: 16, color: sub)),
                        )
                      : Icon(r.status == ClipStatus.CLIP_STATUS_REMOTE_ONLY ? AppIcons.arrowDownCircle : kindIcon(r),
                          size: 16, color: onAccent ? Colors.white : p.textDim),
                ),
                const SizedBox(width: Insets.sm),
                Expanded(
                  child: Text(
                    recordTitle(r, query: state.query.trim().isEmpty ? null : state.query.trim()),
                    style: context.text.bodyMedium?.copyWith(color: fg),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!favoritesTab && r.favorited) ...[
                  const SizedBox(width: Insets.xs),
                  Icon(AppIcons.starFill, size: 12, color: onAccent ? Colors.white : p.accent),
                ],
                const SizedBox(width: Insets.sm),
                if (pending)
                  SizedBox(
                    width: 60,
                    child: LinearProgressIndicator(minHeight: 3, value: state.progressOf(r.id)),
                  )
                else
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 190),
                    child: Text(meta, style: context.text.bodySmall?.copyWith(color: sub), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _menu(BuildContext context, Offset at) async {
    final l = context.l10n;
    final r = record;
    final favorited = r.favorite || r.favorited;
    final choice = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(at.dx, at.dy, at.dx, at.dy),
      items: [
        if (PickerState.selectable(r)) PopupMenuItem(value: 'copy', height: 30, child: Text(l.pickerCopyOnly)),
        PopupMenuItem(value: 'favorite', height: 30, child: Text(favorited ? l.unfavoriteAction : l.favoriteAction)),
        if (!r.favorite) PopupMenuItem(value: 'delete', height: 30, child: Text(l.deleteRecord)),
      ],
    );
    switch (choice) {
      case 'copy':
        await state.choose(r, copyOnly: true);
      case 'favorite':
        await state.toggleFavorite(r);
      case 'delete':
        await state.delete(r);
    }
  }
}
