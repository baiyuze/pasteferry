import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../icons.dart';
import '../main.dart';
import '../theme.dart';
import 'avatar.dart';
import 'common.dart';
import 'friends_dialog.dart';
import 'send_dialog.dart';

// 发给好友或「所有人」模式下附近的陌生设备：先选好文件（拖入、选择、粘贴），可以写一句备注，点「发送」。
// 对方点「接受」后才开始传。见 design/friends-send.md 第 6 节。

/// 发送的对象：好友，或者附近开着「所有人」的陌生设备（ID 是 lan:实例名）
class SendTarget {
  const SendTarget({
    required this.id,
    required this.name,
    this.deviceName = '',
    this.avatarHash = const [],
    this.stranger = false,
  });

  factory SendTarget.friend(Friend f) =>
      SendTarget(id: f.id, name: f.displayName, deviceName: f.deviceName, avatarHash: f.avatarHash);

  factory SendTarget.stranger(Stranger s) => SendTarget(id: s.id, name: s.displayName, stranger: true);

  final String id;
  final String name;
  final String deviceName;
  final List<int> avatarHash;
  final bool stranger;

  String get title => deviceName.isEmpty ? name : '$name · $deviceName';
}

Future<void> showFriendSendDialog(BuildContext context, SendTarget target, {List<String> paths = const []}) =>
    showDialog<void>(context: context, builder: (_) => FriendSendDialog(target: target, initial: paths));

class FriendSendDialog extends StatefulWidget {
  const FriendSendDialog({super.key, required this.target, this.initial = const []});

  final SendTarget target;
  final List<String> initial;

  @override
  State<FriendSendDialog> createState() => _FriendSendDialogState();
}

class _FriendSendDialogState extends State<FriendSendDialog> {
  final List<String> _staged = [];
  final Map<String, int?> _sizes = {};
  final _note = TextEditingController();
  final _focus = FocusNode();
  bool _dragging = false;
  bool _sending = false;

  /// 这个窗口里发出的批次
  final List<String> _sent = [];

  @override
  void initState() {
    super.initState();
    _add(widget.initial);
  }

  @override
  void dispose() {
    _note.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _add(Iterable<String> paths) {
    for (final p in paths) {
      if (p.isEmpty || _staged.contains(p)) continue;
      _staged.add(p);
      estimateSize([p]).then((n) {
        if (mounted) setState(() => _sizes[p] = n);
      });
    }
    if (mounted) setState(() {});
  }

  Future<void> _paste() async {
    final l = context.l10n;
    try {
      final r = await AppScope.read(context).pasteFiles();
      if (!mounted) return;
      if (r.paths.isEmpty) {
        showToast(context, l.sendPasteNothing, error: true);
        return;
      }
      _add(r.paths);
    } catch (_) {
      if (mounted) showToast(context, l.sendPasteNothing, error: true);
    }
  }

  Future<void> _send() async {
    if (_staged.isEmpty || _sending) return;
    setState(() => _sending = true);
    final t = await sendFilesById(context, widget.target.id, widget.target.name, List.of(_staged), note: _note.text);
    if (!mounted) return;
    setState(() {
      _sending = false;
      if (t != null) {
        _sent.add(t.id);
        _staged.clear();
        _note.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final p = context.palette;
    final target = widget.target;
    final friend = target.stranger ? null : state.friendById(target.id);
    if (!target.stranger && friend == null) {
      // 好友在窗口开着时被删了
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
      return const SizedBox.shrink();
    }
    final batches = [
      for (final id in _sent)
        ?state.transfers(TransferDirection.TRANSFER_DIRECTION_OUTGOING).where((t) => t.id == id).firstOrNull,
    ];
    final route = friend != null ? friendStatus(l, state, friend) : l.strangerNearby;
    final pasteKey = Platform.isMacOS ? '⌘V' : 'Ctrl+V';
    final total = _staged.fold<int>(0, (n, path) => n + (_sizes[path] ?? 0));

    return CallbackShortcuts(
      bindings: {
        SingleActivator(LogicalKeyboardKey.keyV, meta: Platform.isMacOS, control: !Platform.isMacOS): _paste,
      },
      child: Focus(
        autofocus: true,
        focusNode: _focus,
        child: Dialog(
          child: SizedBox(
            width: 540,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Insets.xl, Insets.lg, Insets.md, Insets.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      PersonAvatar(
                        deviceId: target.id,
                        name: target.name,
                        hash: target.avatarHash,
                        size: 36,
                        dashed: target.stranger,
                      ),
                      const SizedBox(width: Insets.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l.sendToTitle(target.title), style: context.text.titleMedium),
                            Text(route, style: context.text.bodySmall),
                          ],
                        ),
                      ),
                      IconAction(icon: AppIcons.xmark, tooltip: l.close, onTap: () => Navigator.pop(context)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: Insets.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (batches.isNotEmpty) ...[
                          const SizedBox(height: Insets.lg),
                          for (final t in batches.reversed) TransferBatchRow(transfer: t),
                        ],
                        const SizedBox(height: Insets.lg),
                        if (_staged.isNotEmpty) ...[
                          for (final path in _staged) _StagedRow(
                            path: path,
                            size: _sizes[path],
                            onRemove: () => setState(() => _staged.remove(path)),
                          ),
                          const SizedBox(height: Insets.sm),
                        ],
                        DropTarget(
                          onDragEntered: (_) => setState(() => _dragging = true),
                          onDragExited: (_) => setState(() => _dragging = false),
                          onDragDone: (details) {
                            setState(() => _dragging = false);
                            _add(droppedPaths(details));
                          },
                          child: CustomPaint(
                            painter: DropZonePainter(
                              color: _dragging ? p.accent : p.textFaint,
                              dashed: !_dragging,
                              fill: _dragging ? p.accent.withValues(alpha: 0.06) : Colors.transparent,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Insets.xl,
                                vertical: _staged.isEmpty ? 32 : Insets.md,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    _staged.isEmpty ? l.sendDropOrPaste(pasteKey) : l.sendDropMorePaste,
                                    style: context.text.titleSmall?.copyWith(color: _dragging ? p.accent : null),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: Insets.md),
                                  Wrap(
                                    spacing: Insets.sm,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () async {
                                          final files = await openFiles();
                                          _add([for (final f in files) f.path]);
                                        },
                                        child: Text(l.sendChooseFiles),
                                      ),
                                      OutlinedButton(
                                        onPressed: () async {
                                          final dir = await getDirectoryPath();
                                          if (dir != null) _add([dir]);
                                        },
                                        child: Text(l.sendChooseFolder),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: Insets.lg),
                        Text(l.noteLabel, style: context.text.labelLarge),
                        const SizedBox(height: Insets.xs),
                        TextField(
                          controller: _note,
                          enabled: _staged.isNotEmpty,
                          maxLength: 200,
                          maxLines: 1,
                          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[\r\n\t]'))],
                          decoration: InputDecoration(
                            hintText: _staged.isEmpty ? l.noteHintEmpty : l.noteHint,
                            isDense: true,
                          ),
                          onSubmitted: (_) => _send(),
                        ),
                        const SizedBox(height: Insets.sm),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                batches.isEmpty ? l.sendFriendSaved(target.name) : l.sendCloseKeeps,
                                style: context.text.bodySmall,
                              ),
                            ),
                            if (_staged.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(right: Insets.md),
                                child: Text(
                                  l.sendItemsSummary('${_staged.length}', humanBytes(total)),
                                  style: context.text.bodySmall,
                                ),
                              ),
                            FilledButton(
                              onPressed: _staged.isEmpty || _sending ? null : _send,
                              child: _sending
                                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                                  : Text(l.sendAction),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StagedRow extends StatelessWidget {
  const _StagedRow({required this.path, required this.size, required this.onRemove});

  final String path;
  final int? size;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;
    final isDir = FileSystemEntity.isDirectorySync(path);
    final name = path.split(Platform.pathSeparator).where((s) => s.isNotEmpty).lastOrNull ?? path;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(isDir ? AppIcons.folder : AppIcons.doc, size: 16, color: p.textDim),
          const SizedBox(width: Insets.sm),
          Expanded(child: Text(name, style: context.text.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
          if (size != null) Text(humanBytes(size!), style: context.text.bodySmall),
          const SizedBox(width: Insets.sm),
          IconAction(icon: AppIcons.xmark, tooltip: l.sendRemoveItem, onTap: onRemove),
        ],
      ),
    );
  }
}
