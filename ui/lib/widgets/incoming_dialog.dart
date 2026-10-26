import 'dart:async';

import 'package:flutter/material.dart';

import '../app_state.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../main.dart';
import '../theme.dart';
import 'avatar.dart';
import 'common.dart';
import 'send_dialog.dart';

// 好友或「所有人」模式下的陌生设备发来文件，等用户接受。见 design/friends-send.md 第 7 节。
// 60 秒不处理由后台服务算作拒绝；这里的倒计时只是提示。

const _askSeconds = 60;

Future<void> showIncomingDialog(BuildContext context, Transfer t) => showDialog<void>(
  context: context,
  barrierDismissible: false,
  builder: (_) => IncomingDialog(transferId: t.id),
);

class IncomingDialog extends StatefulWidget {
  const IncomingDialog({super.key, required this.transferId});

  final String transferId;

  @override
  State<IncomingDialog> createState() => _IncomingDialogState();
}

class _IncomingDialogState extends State<IncomingDialog> {
  bool _always = false;
  bool _busy = false;
  bool _closed = false;
  late final Timer _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick.cancel();
    super.dispose();
  }

  Future<void> _answer(bool accept) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await AppScope.read(context).answerIncoming(widget.transferId, accept, always: _always && accept);
    } catch (e) {
      if (mounted) showToast(context, AppState.describeError(e), error: true);
    }
    _close();
  }

  /// 只关一次，而且只关这个对话框：倒计时每秒重建，请求结束后的几次重建和点按钮都会走到这里，
  /// 多 pop 一次会把主界面弹掉（窗口变黑）
  void _close() {
    if (_closed || !mounted) return;
    final route = ModalRoute.of(context);
    if (route == null || !route.isActive) return;
    _closed = true;
    _tick.cancel();
    if (route.isCurrent) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).removeRoute(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final p = context.palette;
    final t = state.transfers(TransferDirection.TRANSFER_DIRECTION_INCOMING).where((x) => x.id == widget.transferId).firstOrNull;
    if (t == null || t.status != 'asking') {
      // 对方取消了、超时了，或者在别处处理过了
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_busy) _close();
      });
      return const SizedBox.shrink();
    }
    final friend = t.peerRole == 'friend' ? state.friendById(t.deviceId) : null;
    final stranger = t.peerRole == 'stranger';
    final name = friend?.displayName ?? t.deviceName;
    final left = _askSeconds - (DateTime.now().millisecondsSinceEpoch ~/ 1000 - t.createdAtUnix.toInt());
    return Dialog(
      child: SizedBox(
        width: 420,
        child: Padding(
          padding: const EdgeInsets.all(Insets.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PersonAvatar(
                    deviceId: t.deviceId,
                    name: name,
                    hash: friend?.avatarHash ?? const [],
                    size: 44,
                    dashed: stranger,
                  ),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.incomingTitle(friend != null && friend.deviceName.isNotEmpty
                              ? '$name · ${friend.deviceName}'
                              : name),
                          style: context.text.titleMedium,
                        ),
                        if (stranger) Text(l.incomingStranger, style: context.text.bodySmall),
                        const SizedBox(height: Insets.sm),
                        Text(
                          [transferTitle(l, t), if (t.totalBytes > 0) humanBytes(t.totalBytes.toInt())].join(' · '),
                          style: context.text.bodyMedium,
                        ),
                        if (t.note.isNotEmpty) ...[
                          const SizedBox(height: Insets.xs),
                          Text(l.noteLine(t.note), style: context.text.bodyMedium?.copyWith(color: p.textDim)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (friend != null) ...[
                const SizedBox(height: Insets.lg),
                InkWell(
                  onTap: () => setState(() => _always = !_always),
                  child: Row(
                    children: [
                      Checkbox(value: _always, onChanged: (v) => setState(() => _always = v ?? false)),
                      Expanded(child: Text(l.incomingAlways, style: context.text.bodyMedium)),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: Insets.lg),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      left > 0 ? l.incomingCountdown('$left') : '',
                      style: context.text.bodySmall?.copyWith(color: p.textFaint),
                    ),
                  ),
                  TextButton(onPressed: _busy ? null : () => _answer(false), child: Text(l.incomingDecline)),
                  const SizedBox(width: Insets.sm),
                  FilledButton(onPressed: _busy ? null : () => _answer(true), child: Text(l.incomingAccept)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
