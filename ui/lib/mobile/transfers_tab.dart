import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';

import '../app_state.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../main.dart' show AppScope;
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/send_dialog.dart';
import 'host.dart';
import 'send_tab.dart' show showFileConfirmSheet;
import 'ui.dart';

/// 手机上的隔空传送（design/android-send-files.md）：挑一台设备发文件，看收发进度，
/// 收到的文件保存到「下载」或分享出去。
///
/// 桌面那页是给大屏和拖拽设计的，手机上重做：设备一行一个「选择文件」，
/// 下面按时间倒序列出发出的和收到的。进度、状态文案、取消按钮复用 desktop 的
/// [TransferBatchRow]，两边说的是一套话。
class TransfersTab extends StatefulWidget {
  const TransfersTab({super.key, this.onPair});

  /// 还没有可以发的设备时，「去配对」切到设备页
  final VoidCallback? onPair;

  @override
  State<TransfersTab> createState() => _TransfersTabState();
}

class _TransfersTabState extends State<TransfersTab> {
  bool _picking = false;

  Future<void> _send(AppState state, Device device) async {
    if (_picking) return;
    final l = context.l10n;
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
      await sendFilesTo(context, device, [for (final p in picked) p.$1]);
    } catch (e) {
      if (mounted) showToast(context, l.mSendFailed(AppState.describeError(e)), error: true);
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _save(Transfer t) async {
    final l = context.l10n;
    try {
      await Host.save(t.paths.where((p) => p.isNotEmpty).toList());
      if (mounted) showToast(context, l.mSaved);
    } catch (e) {
      if (mounted) showToast(context, l.mSaveMediaFailed, error: true);
    }
  }

  Future<void> _share(Transfer t) async {
    final l = context.l10n;
    try {
      await Host.share(t.paths.where((p) => p.isNotEmpty).toList());
    } catch (e) {
      if (mounted) showToast(context, l.mShareMediaFailed, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;

    // 能收文件的设备才列出来：其余的在设备页里管
    final devices = state.peers
        .where((d) => d.online && d.receivesFiles && !d.receiveDisabled)
        .toList(growable: false);
    final rows = [
      ...state.transfers(TransferDirection.TRANSFER_DIRECTION_INCOMING),
      ...state.transfers(TransferDirection.TRANSFER_DIRECTION_OUTGOING),
    ]..sort((a, b) => b.createdAtUnix.compareTo(a.createdAtUnix));

    return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: Insets.xl),
        children: [
          MobileHeader(title: l.navSend),
          MobileGroup(
            title: l.navDevices,
            footer: devices.isEmpty ? l.mNoOnlineDevices : null,
            children: [
              for (final d in devices)
                MobileTile(
                  title: d.name,
                  subtitle: routeLabel(l, state, d),
                  trailing: TextButton(
                    onPressed: _picking ? null : () => _send(state, d),
                    child: Text(l.sendChooseFiles),
                  ),
                ),
              if (devices.isEmpty && widget.onPair != null)
                MobileTile(title: l.addDevice, onTap: widget.onPair),
            ],
          ),
          if (rows.isNotEmpty)
            MobileGroup(
              title: l.friendHistory,
              children: [
                for (final t in rows)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(Insets.lg, Insets.md, Insets.lg, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TransferBatchRow(transfer: t),
                        _actions(t),
                        const SizedBox(height: Insets.sm),
                      ],
                    ),
                  ),
              ],
            ),
        ],
    );
  }

  /// 一排按钮：收到的问「接不接受」，收到的完成后可以保存/分享，中断的可以继续，任何一条都能删。
  Widget _actions(Transfer t) {
    final l = context.l10n;
    final state = AppScope.read(context);
    final done = t.status == 'done';
    final resumable = t.direction == TransferDirection.TRANSFER_DIRECTION_OUTGOING && (t.status == 'interrupted' || t.status == 'paused');
    final finished = const {'done', 'failed', 'declined', 'cancelled', 'expired'}.contains(t.status);
    final buttons = <Widget>[
      if (done && t.direction == TransferDirection.TRANSFER_DIRECTION_INCOMING) ...[
        TextButton(onPressed: () => _save(t), child: Text(l.save)),
        TextButton(onPressed: () => _share(t), child: Text(l.mShare)),
      ],
      if (resumable)
        TextButton(onPressed: () => state.resumeTransfer(t.id), child: Text(l.continueAction)),
      if (finished || resumable || done)
        TextButton(
          onPressed: () => state.deleteTransfers(ids: [t.id]),
          child: Text(l.mDelete),
        ),
    ];
    if (buttons.isEmpty) return const SizedBox(height: Insets.xs);
    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(spacing: Insets.xs, children: buttons),
    );
  }
}
