import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_state.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../hotkey.dart';
import '../i18n.dart';
import '../main.dart';
import '../quick_paste_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// 设置页的「快捷粘贴」一节：开关、快捷键、选中后直接粘贴还是只复制，以及各平台要用户处理的事
/// （Mac 的辅助功能权限、Linux Wayland 的系统快捷键）。见 design/quick-paste-and-favorites.md 第 9 节。
class QuickPasteSection extends StatelessWidget {
  const QuickPasteSection({super.key, required this.config, required this.onUpdate});

  final Config config;
  final Future<void> Function(Config next) onUpdate;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final p = context.palette;
    final enabled = !config.quickPasteDisabled;
    final qp = state.quickPaste;
    final hotkey = Hotkey.parse(config.quickPasteHotkey) ?? Hotkey.fallback;
    // 旧版后台服务没有快捷窗口，qp 为 null：不提示「没在运行」
    final notRunning = enabled && qp != null && !qp.running && state.isOnline;
    final portal = qp?.hotkeySource == 'portal';
    final systemShortcut = qp?.hotkeySource == 'system_shortcut';

    return GroupSection(
      title: l.quickPaste,
      child: GroupBox(
        children: [
          SettingRow(
            title: l.quickPasteWindow,
            description: notRunning ? l.quickPasteNotRunning : l.quickPasteWindowDesc,
            child: SmallSwitch(
              value: enabled,
              onChanged: (v) => onUpdate(config.deepCopy()..quickPasteDisabled = !v),
            ),
          ),
          if (enabled && portal)
            SettingRow(
              title: l.quickPasteShortcut,
              description: l.quickPastePortalKey,
              child: _KeyCap(text: qp!.hotkey.isEmpty ? '—' : (Hotkey.parse(qp.hotkey)?.display() ?? qp.hotkey)),
            )
          else if (enabled)
            _ShortcutRow(
              hotkey: hotkey,
              error: _hotkeyError(l, qp, hotkey),
              onChanged: (h) => onUpdate(config.deepCopy()..quickPasteHotkey = h.setting),
            ),
          if (enabled && systemShortcut) _SystemShortcutRow(hotkey: hotkey),
          if (enabled)
            SettingRow(
              title: l.quickPasteAfterPick,
              description: Platform.isLinux && (qp?.pasteUnavailableReason == 'wayland') ? l.quickPasteWaylandDesc : null,
              child: Segmented<bool>(
                value: !config.quickPasteCopyOnly,
                segments: [(true, l.quickPastePasteIt), (false, l.quickPasteCopyIt)],
                onChanged: (paste) => onUpdate(config.deepCopy()..quickPasteCopyOnly = !paste),
              ),
            ),
          if (enabled && Platform.isMacOS && qp != null && qp.running && !config.quickPasteCopyOnly)
            SettingRow(
              title: l.quickPasteAccessibility,
              description: l.quickPasteAccessibilityDesc,
              child: qp.pasteUnavailableReason == 'not_trusted'
                  ? OutlinedButton(
                      onPressed: () async {
                        try {
                          await state.sendQuickPasteCommand('request_permission');
                        } catch (e) {
                          if (context.mounted) showToast(context, AppState.describeError(e), error: true);
                        }
                      },
                      child: Text(l.quickPasteAllow),
                    )
                  : Text(l.quickPasteAllowed, style: context.text.bodyMedium?.copyWith(color: p.textDim)),
            ),
        ],
      ),
    );
  }

  static String? _hotkeyError(AppLocalizations l, QuickPasteStatus? qp, Hotkey hotkey) {
    final err = qp?.hotkeyError ?? '';
    if (err.isEmpty || qp?.running != true) return null;
    // 快捷窗口报的是它实际在用的那个；设置刚改过、它还没重新注册时不显示旧的错误
    if (qp!.hotkey.isNotEmpty && qp.hotkey != hotkey.canonical) return null;
    if (err == 'in_use') return l.quickPasteInUse(hotkey.display());
    return l.quickPasteHotkeyFailed(hotkey.display(), err);
  }
}

/// 快捷键的样子：一个带边框的小方块。
class _KeyCap extends StatelessWidget {
  const _KeyCap({required this.text, this.active = false});

  final String text;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      constraints: const BoxConstraints(minWidth: 64),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(Radii.sm),
        border: Border.all(color: active ? p.accent : p.border, width: active ? 1.5 : 1),
      ),
      child: Text(text, textAlign: TextAlign.center, style: context.text.labelLarge),
    );
  }
}

/// 快捷键一行：点一下进入录制，按下新的组合就保存；Esc 或点别处取消。
/// 录制期间请快捷窗口暂停全局快捷键，否则按下当前的快捷键会把快捷窗口叫出来。
class _ShortcutRow extends StatefulWidget {
  const _ShortcutRow({required this.hotkey, required this.error, required this.onChanged});

  final Hotkey hotkey;
  final String? error;
  final Future<void> Function(Hotkey) onChanged;

  @override
  State<_ShortcutRow> createState() => _ShortcutRowState();
}

class _ShortcutRowState extends State<_ShortcutRow> {
  final _focus = FocusNode();
  bool _recording = false;
  String? _hint;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus && _recording) _stop();
    });
  }

  @override
  void dispose() {
    if (_recording) _command('resume_hotkey');
    _focus.dispose();
    super.dispose();
  }

  void _command(String c) {
    // 快捷窗口没在运行时发不出去，无所谓
    AppScope.read(context).sendQuickPasteCommand(c).catchError((_) {});
  }

  void _start() {
    setState(() {
      _recording = true;
      _hint = null;
    });
    _command('suspend_hotkey');
    _focus.requestFocus();
  }

  void _stop() {
    if (!_recording) return;
    setState(() => _recording = false);
    _command('resume_hotkey');
  }

  KeyEventResult _onKey(FocusNode _, KeyEvent e) {
    if (!_recording || e is! KeyDownEvent) return KeyEventResult.ignored;
    if (e.logicalKey == LogicalKeyboardKey.escape) {
      _stop();
      _focus.unfocus();
      return KeyEventResult.handled;
    }
    final h = Hotkey.fromKey(e.logicalKey, e.physicalKey, Hotkey.pressedModifiers());
    if (h == null) return KeyEventResult.handled; // 修饰键本身，等下一个键
    if (!h.usable) {
      final l = context.l10n;
      setState(() => _hint = Platform.isMacOS ? l.quickPasteNeedsModifier : l.quickPasteNeedsModifierPc);
      return KeyEventResult.handled;
    }
    _stop();
    _focus.unfocus();
    widget.onChanged(h);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final message = _recording ? _hint : widget.error;
    return SettingRow(
      title: l.quickPasteShortcut,
      description: message ?? (_recording ? l.quickPasteRecording : l.quickPasteRecord),
      descriptionColor: message != null ? p.danger : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_recording && widget.hotkey != Hotkey.fallback) ...[
            TextButton(onPressed: () => widget.onChanged(Hotkey.fallback), child: Text(l.quickPasteUseDefault)),
            const SizedBox(width: Insets.xs),
          ],
          Focus(
            focusNode: _focus,
            onKeyEvent: _onKey,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _recording ? null : _start,
                child: _KeyCap(
                  text: _recording ? '…' : widget.hotkey.display(),
                  active: _recording || message != null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Linux Wayland 上没有全局快捷键门户时：GNOME 上一键写入系统的自定义快捷键，其他桌面给出命令让用户自己加。
class _SystemShortcutRow extends StatelessWidget {
  const _SystemShortcutRow({required this.hotkey});

  final Hotkey hotkey;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (!GnomeShortcut.supported) {
      return SettingRow(
        title: l.quickPasteAddShortcut,
        description: l.quickPasteShortcutManual(GnomeShortcut.command),
        child: const SizedBox.shrink(),
      );
    }
    return SettingRow(
      title: l.quickPasteAddShortcut,
      description: l.quickPasteWaylandDesc,
      child: OutlinedButton(
        onPressed: () async {
          try {
            await GnomeShortcut.install(hotkey);
            if (context.mounted) showToast(context, l.quickPasteShortcutAdded(hotkey.display()));
          } catch (e) {
            if (context.mounted) showToast(context, AppState.describeError(e), error: true);
          }
        },
        child: Text(l.quickPasteAddShortcut),
      ),
    );
  }
}
