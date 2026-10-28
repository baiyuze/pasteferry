import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';

import '../app_state.dart';
import '../i18n.dart';
import '../icons.dart';
import '../main.dart' show AppScope;
import '../theme.dart';
import '../widgets/common.dart';
import 'ui.dart';

/// 发送页（design/phone-sync.md 3.2.3 节）：手机上的文字发给在线的设备。
///
/// Android 10 起后台读不到剪贴板，手机上复制的内容不会自动发出，要粘贴到这里。
/// 「粘贴剪贴板里的文字」只在剪贴板里有文字时出现：判断用的是 [Clipboard.hasStrings]，
/// 只查剪贴板的类型，系统不会弹「已粘贴」的提示；点了才真正读取。
class SendTab extends StatefulWidget {
  const SendTab({super.key, this.onPair});

  /// 还没有配对的设备时，「去配对」切到设备页
  final VoidCallback? onPair;

  @override
  State<SendTab> createState() => _SendTabState();
}

class _SendTabState extends State<SendTab> with WidgetsBindingObserver {
  final _text = TextEditingController();
  bool _clipboardHasText = false;
  bool _sending = false;
  bool _picking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _text.addListener(() => setState(() {}));
    _checkClipboard();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _text.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (s == AppLifecycleState.resumed) _checkClipboard();
  }

  Future<void> _checkClipboard() async {
    final has = await Clipboard.hasStrings();
    if (mounted && has != _clipboardHasText) setState(() => _clipboardHasText = has);
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text ?? '';
    if (!mounted) return;
    if (text.isEmpty) {
      setState(() => _clipboardHasText = false);
      showToast(context, context.l10n.mClipboardNoText, error: true);
      return;
    }
    final v = _text.value;
    final start = v.selection.isValid ? v.selection.start : v.text.length;
    final end = v.selection.isValid ? v.selection.end : v.text.length;
    _text.value = TextEditingValue(
      text: v.text.replaceRange(start, end, text),
      selection: TextSelection.collapsed(offset: start + text.length),
    );
  }

  /// 选照片或文件发到电脑。file_selector 在 Android 上会把选中的内容拷到应用缓存，
  /// 后台服务和 App 在同一个进程里，直接读得到这些路径。
  Future<void> _pickFiles() async {
    final l = context.l10n;
    if (_picking) return;
    setState(() => _picking = true);
    try {
      final files = await openFiles();
      if (files.isEmpty || !mounted) return;
      final paths = [for (final f in files) f.path];
      await AppScope.read(context).submitFiles(paths);
      if (mounted) showToast(context, l.mFilesSent(paths.length));
    } catch (e) {
      if (mounted) showToast(context, l.mSendFailed(AppState.describeError(e)), error: true);
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _send() async {
    final text = _text.text;
    if (text.trim().isEmpty || _sending) return;
    final l = context.l10n;
    setState(() => _sending = true);
    try {
      await AppScope.read(context).submitText(text);
      _text.clear();
      if (mounted) showToast(context, l.mSent);
    } catch (e) {
      if (mounted) showToast(context, l.mSendFailed(AppState.describeError(e)), error: true);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final p = context.palette;
    final online = state.peers.where((d) => d.online).map((d) => d.name).toList();
    final canSend = online.isNotEmpty && _text.text.trim().isNotEmpty && !_sending;

    return SafeArea(
      bottom: false,
      child: GestureDetector(
        // 点空白处收起键盘
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            MobileHeader(title: l.mSendTitle),
            const LanNotice(),
            Padding(
              padding: const EdgeInsets.fromLTRB(Insets.lg, 0, Insets.lg, Insets.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 输入框和网页一样：白底圆角的一块，聚焦时边框变成强调色
                  TextField(
                    controller: _text,
                    minLines: 6,
                    maxLines: 12,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                    decoration: InputDecoration(
                      hintText: l.mSendHint,
                      fillColor: p.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Radii.lg),
                        borderSide: BorderSide(color: p.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Radii.lg),
                        borderSide: BorderSide(color: p.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Radii.lg),
                        borderSide: BorderSide(color: p.accent),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
                    ),
                  ),
                  if (_clipboardHasText)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: Insets.xs)),
                        onPressed: _paste,
                        icon: Icon(AppIcons.docOnClipboard, size: 18),
                        label: Text(l.mPaste),
                      ),
                    ),
                  const SizedBox(height: Insets.md),
                  Row(
                    children: [
                      // 和网页一样：左边选照片或文件，右边发文字
                      Expanded(
                        child: FilledButton.icon(
                          style: secondaryButtonStyle(context),
                          onPressed: _picking ? null : _pickFiles,
                          icon: Icon(AppIcons.folder, size: 20),
                          label: Text(l.mPhotosFiles),
                        ),
                      ),
                      const SizedBox(width: Insets.md),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: canSend ? _send : null,
                          icon: _sending
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Icon(AppIcons.send, size: 20),
                          label: Text(l.mSendAction),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Insets.md),
                  if (state.peers.isEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: Insets.xs)),
                        onPressed: widget.onPair,
                        child: Text(l.mNoPairedDevices),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Insets.xs),
                      child: Text(
                        online.isEmpty ? l.mNoOnlineDevices : l.mSendTo(online.join('、')),
                        style: TextStyle(fontSize: 13, color: online.isEmpty ? p.warning : p.textDim),
                      ),
                    ),
                  const SizedBox(height: Insets.sm),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Insets.xs),
                    child: Text(l.mSendFootnote, style: TextStyle(fontSize: 13, height: 1.5, color: p.textDim)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
