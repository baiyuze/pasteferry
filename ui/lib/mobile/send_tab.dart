import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';

import '../app_state.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../records.dart';
import '../i18n.dart';
import '../icons.dart';
import '../main.dart' show AppScope;
import '../theme.dart';
import '../widgets/common.dart';
import 'record_actions.dart';
import 'records_tab.dart' show showRecordSheet;
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

  /// 选照片或文件：先让用户看清会发哪些，确认了才发（支持多选）。
  Future<void> _pickFiles() async {
    final l = context.l10n;
    if (_picking) return;
    setState(() => _picking = true);
    try {
      final files = await openFiles();
      if (files.isEmpty || !mounted) return;
      final picked = <(String, String, int)>[];
      for (final f in files) {
        var size = 0;
        try {
          size = await f.length();
        } catch (_) {}
        picked.add((f.path, f.name, size));
      }
      if (!mounted) return;
      final ok = await showFileConfirmSheet(context, picked);
      if (ok != true || !mounted) return;
      await AppScope.read(context).submitFiles([for (final p in picked) p.$1]);
      if (mounted) showToast(context, l.mFilesSent(picked.length));
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
                  const SizedBox(height: Insets.xl),
                  _SentRecords(),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 文件大小的简短写法，和网页、桌面一致。
String _sizeLabel(int n) {
  if (n < 1024) return '$n B';
  const units = ['KB', 'MB', 'GB'];
  var v = n.toDouble();
  for (final u in units) {
    v /= 1024;
    if (v < 1024 || u == 'GB') return v < 10 ? '${v.toStringAsFixed(1)} $u' : '${v.round()} $u';
  }
  return '$n B';
}

/// 选完照片或文件后的确认弹层：先看清发什么、多大，再决定发不发。
Future<bool?> showFileConfirmSheet(BuildContext context, List<(String, String, int)> files) {
  final l = context.l10n;
  final p = context.palette;
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Insets.lg, 0, Insets.lg, Insets.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l.mSendConfirmTitle(files.length),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Insets.md),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final f in files)
                      Padding(
                        padding: const EdgeInsets.only(bottom: Insets.md),
                        child: Row(
                          children: [
                            Icon(AppIcons.folder, size: 20, color: p.textDim),
                            const SizedBox(width: Insets.md),
                            Expanded(
                              child: Text(f.$2,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 15)),
                            ),
                            const SizedBox(width: Insets.md),
                            Text(_sizeLabel(f.$3), style: TextStyle(fontSize: 13, color: p.textDim)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Insets.md),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    style: secondaryButtonStyle(context),
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(l.cancel),
                  ),
                ),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(l.mSendAction),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// 发送记录：本机发出去的内容，只显示最近 3 天，高度固定，不挤压上面的发送区。
class _SentRecords extends StatelessWidget {
  static const _days = 3;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final p = context.palette;
    final since = DateTime.now().subtract(const Duration(days: _days));
    final sent = state.records
        .where((r) => r.outgoing && recordTime(r).isAfter(since))
        .toList();
    if (sent.isEmpty) return const SizedBox.shrink();
    final shown = sent.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(l.mSentRecords, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: p.textDim)),
            const Spacer(),
            TextButton(
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: Insets.xs)),
              onPressed: () => showSentRecordsSheet(context, sent),
              child: Text(l.mViewAll),
            ),
          ],
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(color: p.border),
          ),
          child: Column(
            children: [
              for (var i = 0; i < shown.length; i++) ...[
                if (i > 0) const Divider(height: 1, indent: 52),
                ListTile(
                  dense: true,
                  leading: Icon(isMedia(shown[i]) ? AppIcons.folder : AppIcons.docOnClipboard, size: 20, color: p.textDim),
                  title: Text(contentTitle(shown[i]),
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15)),
                  subtitle: Text(relativeTime(recordTime(shown[i])), style: TextStyle(fontSize: 12, color: p.textDim)),
                  onTap: () => showRecordSheet(context, shown[i]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// 查看全部发送记录，可以一直往上翻；右上角能清空。
Future<void> showSentRecordsSheet(BuildContext context, List<ClipRecord> sent) {
  final state = AppScope.read(context);
  final l = context.l10n;
  final p = context.palette;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetCtx) => ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(sheetCtx).height * 0.85),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Insets.lg, Insets.md, Insets.sm, 0),
            child: Row(
              children: [
                Text(l.mSentRecords, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: p.danger),
                  onPressed: () async {
                    final ids = [for (final r in sent) r.id];
                    try {
                      await state.deleteRecords(ids: ids);
                      if (sheetCtx.mounted) Navigator.pop(sheetCtx);
                    } catch (_) {}
                  },
                  child: Text(l.mClearCache),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: sent.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 52),
              itemBuilder: (_, i) {
                final r = sent[i];
                return ListTile(
                  leading: Icon(isMedia(r) ? AppIcons.folder : AppIcons.docOnClipboard, size: 20, color: p.textDim),
                  title: Text(contentTitle(r), maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(relativeTime(recordTime(r)), style: TextStyle(fontSize: 12, color: p.textDim)),
                  onTap: () => showRecordSheet(context, r),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
