import 'package:flutter/material.dart';

import '../app_state.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../icons.dart';
import '../main.dart' show AppScope;
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/send_dialog.dart';
import 'host.dart';
import 'file_picker.dart';
import 'ui.dart';

/// 手机上的隔空传送（design/android-send-files.md）：挑一台设备发文件，看收发进度，
/// 收到的文件保存到「下载」或分享出去。
///
/// 桌面那页是给大屏和拖拽设计的，手机上重做：设备一行一个「选择文件」，
/// 下面按时间倒序列出发出的和收到的；状态文案与桌面共用，排版按触屏设计。
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
      final picked = await pickFilesForSend(context);
      if (picked == null || !mounted) return;
      await sendFilesTo(context, device, [for (final file in picked) file.path]);
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
                Padding(
                  padding: const EdgeInsets.all(Insets.lg),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Row(children: [
                      Icon(AppIcons.deviceLaptop, size: 24, color: context.palette.textDim),
                      const SizedBox(width: Insets.md),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(d.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: context.text.bodyLarge),
                        Text(routeLabel(l, state, d), style: context.text.bodySmall),
                      ])),
                    ]),
                    const SizedBox(height: Insets.md),
                    FilledButton.icon(
                      style: secondaryButtonStyle(context),
                      onPressed: _picking ? null : () => _send(state, d),
                      icon: Icon(AppIcons.plus, size: 18),
                      label: Text(l.sendChooseFiles),
                    ),
                  ]),
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
                    child: MobileTransferCard(transfer: t, actions: _actions(t)),
                  ),
              ],
            ),
        ],
    );
  }

  /// 一排按钮：收到的问「接不接受」，收到的完成后可以保存/分享，中断的可以继续，任何一条都能删。
  List<Widget> _actions(Transfer t) {
    final l = context.l10n;
    final state = AppScope.read(context);
    final done = t.status == 'done';
    final resumable = t.direction == TransferDirection.TRANSFER_DIRECTION_OUTGOING && (t.status == 'interrupted' || t.status == 'paused');
    final finished = const {'done', 'failed', 'declined', 'cancelled', 'expired'}.contains(t.status);
    final buttons = <Widget>[
      if (done && t.direction == TransferDirection.TRANSFER_DIRECTION_INCOMING) ...[
        FilledButton.icon(style: secondaryButtonStyle(context), onPressed: () => _save(t), icon: Icon(AppIcons.download, size: 18), label: Text(l.save)),
        OutlinedButton.icon(onPressed: () => _share(t), icon: Icon(AppIcons.share, size: 18), label: Text(l.mShare)),
      ],
      if (resumable)
        FilledButton.icon(style: secondaryButtonStyle(context), onPressed: () => state.resumeTransfer(t.id), icon: Icon(AppIcons.arrowClockwise, size: 18), label: Text(l.continueAction)),
      if (const {'scanning', 'queued', 'waiting', 'asking', 'active', 'paused', 'interrupted'}.contains(t.status))
        OutlinedButton.icon(onPressed: () => state.cancelTransfer(t.id), icon: Icon(AppIcons.xmark, size: 18), label: Text(t.status == 'queued' ? l.sendRemoveQueued : l.cancel)),
      if (finished || resumable || done)
        TextButton(
          onPressed: () => state.deleteTransfers(ids: [t.id]),
          style: TextButton.styleFrom(foregroundColor: context.palette.textDim),
          child: Text(l.mDelete),
        ),
    ];
    return buttons;
  }
}

/// Mobile filenames, metadata and actions each get their own row.
class MobileTransferCard extends StatelessWidget {
  const MobileTransferCard({super.key, required this.transfer, this.actions = const []});
  final Transfer transfer;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final t = transfer;
    final l = context.l10n;
    final p = context.palette;
    final incoming = t.direction == TransferDirection.TRANSFER_DIRECTION_INCOMING;
    final active = t.status == 'active';
    final bad = const {'failed', 'declined', 'interrupted'}.contains(t.status);
    final status = t.status == 'done' ? l.sendDelivered : transferStatusText(l, t);
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.lg),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: p.fill, borderRadius: BorderRadius.circular(Radii.md)),
            child: Icon(transferIcon(t), size: 22, color: p.textDim),
          ),
          const SizedBox(width: Insets.md),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(transferTitle(l, t), maxLines: 2, overflow: TextOverflow.ellipsis,
              style: context.text.bodyLarge?.copyWith(fontWeight: FontWeight.w600, height: 1.35)),
            const SizedBox(height: Insets.xs),
            Text([incoming ? l.transferFrom(t.deviceName) : l.transferTo(t.deviceName),
              if (t.totalBytes > 0) humanBytes(t.totalBytes.toInt())].join(' · '),
              maxLines: 2, overflow: TextOverflow.ellipsis, style: context.text.bodySmall),
          ])),
        ]),
        const SizedBox(height: Insets.md),
        if (active) ...[
          LinearProgressIndicator(minHeight: 4, borderRadius: BorderRadius.circular(2),
            value: t.totalBytes > 0 ? (t.doneBytes.toDouble() / t.totalBytes.toDouble()).clamp(0, 1) : null),
          const SizedBox(height: Insets.sm),
          Text(progressLabel(l, t), style: context.text.bodySmall),
          if (t.currentFile.isNotEmpty)
            Text(t.currentFile.split('/').last, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.bodySmall),
        ] else
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(t.status == 'done' ? AppIcons.checkmarkCircle : bad ? AppIcons.exclamationmarkCircle : AppIcons.clock,
              size: 16, color: t.status == 'done' ? p.online : bad ? p.danger : p.textDim),
            const SizedBox(width: 6),
            Expanded(child: Text(status, style: context.text.bodySmall?.copyWith(color: bad ? p.danger : p.textDim))),
          ]),
        if (actions.isNotEmpty) ...[
          const SizedBox(height: Insets.md),
          Wrap(spacing: Insets.sm, runSpacing: Insets.sm, crossAxisAlignment: WrapCrossAlignment.center, children: actions),
        ],
      ]),
    );
  }
}
