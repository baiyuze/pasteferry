import 'dart:async';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';

import '../app_state.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../icons.dart';
import '../main.dart';
import '../theme.dart';
import 'common.dart';

// 隔空传送的发送：点设备弹出的窗口，以及隔空传送页与窗口共用的发送逻辑。见 design/send-files.md 第 2 节。
// 用到拖放与文件选择插件的代码只放在主窗口里，快捷粘贴窗口不引用这个文件（它没有注册插件）。

/// 今天已经同意经官方服务中转发给哪些设备：设备 ID → 日期。只记在内存里，重开 App 后再问一次
final _relayConsent = <String, String>{};

String _today() {
  final n = DateTime.now();
  return '${n.year}-${n.month}-${n.day}';
}

/// 把 [paths] 发给 [device]。要经官方服务中转时先问一次；出错时弹出提示。成功返回这一批。
Future<Transfer?> sendFilesTo(BuildContext context, Device device, List<String> paths) =>
    sendFilesById(context, device.id, device.name, paths);

/// 与 [sendFilesTo] 相同，按设备 ID 发：自己的设备、好友，或者「所有人」模式下的陌生设备（lan:实例名）。
/// [note] 是备注（只给好友、陌生设备）
Future<Transfer?> sendFilesById(BuildContext context, String id, String name, List<String> paths,
    {String note = ''}) async {
  final l = context.l10n;
  final state = AppScope.read(context);
  if (paths.isEmpty) {
    showToast(context, l.sendCannotDrop, error: true);
    return null;
  }
  var allowRelay = _relayConsent[id] == _today();
  for (;;) {
    try {
      return await state.sendFiles(id, paths, allowRelay: allowRelay, note: note);
    } on GrpcError catch (e) {
      if (!context.mounted) return null;
      switch (AppState.sendFailure(e)) {
        case SendFailure.needRelayConsent when !allowRelay:
          if (!await confirmRelay(context, id, name, paths)) return null;
          allowRelay = true;
          continue;
        case SendFailure.offline:
          showToast(context, l.sendErrOffline(name), error: true);
        case SendFailure.unsupported:
          showToast(context, l.sendNeedsUpdateTip(name), error: true);
        case SendFailure.disabled:
          showToast(context, l.sendErrDisabled(name), error: true);
        case SendFailure.noPaths:
          showToast(context, l.sendErrMissing, error: true);
        default:
          showToast(context, AppState.describeError(e), error: true);
      }
      return null;
    } catch (e) {
      if (context.mounted) showToast(context, AppState.describeError(e), error: true);
      return null;
    }
  }
}

/// 经官方服务中转之前问一次：速度、今天剩下的额度，这些文件会不会超出。
Future<bool> confirmRelay(BuildContext context, String id, String name, List<String> paths) async {
  final l = context.l10n;
  final usage = AppScope.read(context).officialUsage;
  final left = usage?.remainingBytes.toInt() ?? 0;
  final exhausted = usage == null || !usage.available || left <= 0;
  final size = await _estimateSize(paths);
  if (!context.mounted) return false;
  var dontAsk = false;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text(l.relayConfirmTitle),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (exhausted)
                Text(l.relayExhausted)
              else ...[
                Text(l.relayConfirmBody(name, humanBytes(left))),
                const SizedBox(height: Insets.md),
                // 经中转的加密数据比文件本身大约多 6%
                if (size != null && size * 1.06 > left)
                  Text(l.relayConfirmOver(humanBytes(size)))
                else if (size != null)
                  Text(l.relayConfirmWithin(humanBytes((size * 1.06).round()))),
                const SizedBox(height: Insets.md),
                InkWell(
                  onTap: () => setState(() => dontAsk = !dontAsk),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(value: dontAsk, onChanged: (v) => setState(() => dontAsk = v ?? false)),
                      Text(l.relayDontAskToday, style: context.text.bodyMedium),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(exhausted ? l.close : l.cancel)),
          if (!exhausted) FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.relaySendAnyway)),
        ],
      ),
    ),
  );
  if (ok == true && dontAsk) _relayConsent[id] = _today();
  return ok == true;
}

/// 估算要发的总大小，最多花 0.8 秒；大文件夹数不完时返回 null，确认框里就不比较额度。
Future<int?> estimateSize(List<String> paths) => _estimateSize(paths);

Future<int?> _estimateSize(List<String> paths) async {
  final watch = Stopwatch()..start();
  var total = 0;
  for (final p in paths) {
    final type = FileSystemEntity.typeSync(p);
    if (type == FileSystemEntityType.file) {
      total += File(p).lengthSync();
      continue;
    }
    if (type != FileSystemEntityType.directory) continue;
    await for (final e in Directory(p).list(recursive: true, followLinks: false)) {
      if (watch.elapsedMilliseconds > 800) return null;
      if (e is File) total += await e.length();
    }
  }
  return total;
}

/// 拖放进来的项目在本机的路径。照片 App、邮件附件这类「承诺文件」由插件先存到临时目录，也有路径。
List<String> droppedPaths(DropDoneDetails details) =>
    [for (final f in details.files) if (f.path.isNotEmpty) f.path];

/// 「在访达中显示」按各平台的叫法。
String revealLabel(AppLocalizations l) => Platform.isMacOS
    ? l.revealInFinder
    : Platform.isWindows
        ? l.revealInFolder
        : l.revealOpenFolder;

/// 设备此刻的连接方式：局域网、直连、中转（官方服务时带上今天剩下的额度）。
String routeLabel(AppLocalizations l, AppState state, Device d) {
  if (!d.online) return l.offline;
  switch (d.connection) {
    case ConnectionKind.CONNECTION_KIND_RELAY:
      final usage = state.officialUsage;
      if (state.officialEnabled && usage != null && usage.available) {
        return l.sendRelayLeft(humanBytes(usage.remainingBytes.toInt()));
      }
      return l.relay;
    default:
      return d.lanReachable ? l.sendLan : l.direct;
  }
}

/// 剩余时间：不到一分钟按秒，不到一小时按分钟，再长按小时和分钟。
String etaLabel(AppLocalizations l, double seconds) {
  if (seconds < 60) return l.etaSeconds(seconds.ceil().clamp(1, 59));
  if (seconds < 3600) return l.etaMinutes((seconds / 60).ceil());
  final m = (seconds / 60).ceil();
  return l.etaHours(m ~/ 60, m % 60);
}

/// 一批的进度说明：「64% · 1.3 / 2.1 GB · 41 MB/s · 还剩 20 秒」。
String progressLabel(AppLocalizations l, Transfer t) {
  final total = t.totalBytes.toInt();
  final done = t.doneBytes.toInt();
  final parts = <String>[
    if (total > 0) '${(done * 100 / total).floor()}%',
    if (total > 0) '${humanBytes(done)} / ${humanBytes(total)}',
    if (t.bytesPerSecond > 0) '${humanBytes(t.bytesPerSecond.round())}/s',
    if (t.bytesPerSecond > 0 && total > done) l.transferLeft(etaLabel(l, (total - done) / t.bytesPerSecond)),
  ];
  return parts.join(' · ');
}

/// 一批的名称：一项时就是它的名字，多项时「报告.pdf 等 3 项」。
String transferTitle(AppLocalizations l, Transfer t) {
  if (t.items.isEmpty) return '';
  final first = t.items.first.name;
  return t.items.length == 1 ? first : l.transferItems(first, t.items.length, t.items.length - 1);
}

IconData transferIcon(Transfer t) => t.items.length == 1 && t.items.first.isDir
    ? AppIcons.folder
    : t.items.length > 1
        ? AppIcons.docOnDoc
        : AppIcons.doc;

Future<void> showSendDialog(BuildContext context, Device device) =>
    showDialog<void>(context: context, builder: (_) => SendDialog(deviceId: device.id));

/// 点雷达上的一台设备弹出的窗口：把文件拖进来，松手就发。下面列出这次发的各批和进度。
class SendDialog extends StatefulWidget {
  const SendDialog({super.key, required this.deviceId});

  final String deviceId;

  @override
  State<SendDialog> createState() => _SendDialogState();
}

class _SendDialogState extends State<SendDialog> {
  bool _dragging = false;

  /// 这个窗口里发出的批次
  final List<String> _sent = [];

  Future<void> _send(Device d, List<String> paths) async {
    final t = await sendFilesTo(context, d, paths);
    if (t != null && mounted) setState(() => _sent.add(t.id));
  }

  Future<void> _chooseFiles(Device d) async {
    final files = await openFiles();
    if (files.isEmpty || !mounted) return;
    await _send(d, [for (final f in files) f.path]);
  }

  Future<void> _chooseFolder(Device d) async {
    final dir = await getDirectoryPath();
    if (dir == null || !mounted) return;
    await _send(d, [dir]);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final p = context.palette;
    final d = state.peers.where((x) => x.id == widget.deviceId).firstOrNull;
    if (d == null) {
      // 设备在窗口开着时被取消配对了
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
      return const SizedBox.shrink();
    }
    final batches = [
      for (final id in _sent)
        ?state.transfers(TransferDirection.TRANSFER_DIRECTION_OUTGOING).where((t) => t.id == id).firstOrNull,
    ];
    final route = d.connection == ConnectionKind.CONNECTION_KIND_RELAY && !state.officialEnabled
        ? l.relayOwnServer
        : routeLabel(l, state, d);

    return Dialog(
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
                  Expanded(child: Text(l.sendToTitle(d.name), style: context.text.titleMedium)),
                  IconAction(icon: AppIcons.xmark, tooltip: l.close, onTap: () => Navigator.pop(context)),
                ],
              ),
              Text(route, style: context.text.bodySmall),
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
                    DropTarget(
                      onDragEntered: (_) => setState(() => _dragging = true),
                      onDragExited: (_) => setState(() => _dragging = false),
                      onDragDone: (details) {
                        setState(() => _dragging = false);
                        _send(d, droppedPaths(details));
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
                            vertical: batches.isEmpty ? 40 : Insets.lg,
                          ),
                          child: Column(
                            children: [
                              Text(
                                _dragging
                                    ? l.sendReleaseTo(d.name)
                                    : batches.isEmpty
                                        ? l.sendDropHere
                                        : l.sendDropMore,
                                style: context.text.titleSmall?.copyWith(color: _dragging ? p.accent : null),
                                textAlign: TextAlign.center,
                              ),
                              if (batches.isEmpty && !_dragging) ...[
                                const SizedBox(height: 4),
                                Text(l.sendDropStarts, style: context.text.bodySmall),
                              ],
                              const SizedBox(height: Insets.lg),
                              Wrap(
                                spacing: Insets.sm,
                                alignment: WrapAlignment.center,
                                children: [
                                  OutlinedButton(onPressed: () => _chooseFiles(d), child: Text(l.sendChooseFiles)),
                                  OutlinedButton(onPressed: () => _chooseFolder(d), child: Text(l.sendChooseFolder)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: Insets.md),
                    Text(
                      batches.isEmpty ? l.sendSavedWhere(d.name) : l.sendCloseKeeps,
                      style: context.text.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 发送窗口里的一批：名称、大小，进度或结果。
class TransferBatchRow extends StatelessWidget {
  const TransferBatchRow({super.key, required this.transfer});

  final Transfer transfer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final t = transfer;
    final active = t.status == 'active';
    final cancellable =
        const {'scanning', 'queued', 'waiting', 'asking', 'active', 'paused', 'interrupted'}.contains(t.status);
    final status = switch (t.status) {
      'done' => l.sendDelivered,
      'active' => null,
      _ => transferStatusText(l, t),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(transferIcon(t), size: 18, color: p.textDim),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  [transferTitle(l, t), if (t.totalBytes > 0) humanBytes(t.totalBytes.toInt())].join(' · '),
                  style: context.text.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (active) ...[
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    minHeight: 3,
                    value: t.totalBytes > 0 ? t.doneBytes.toInt() / t.totalBytes.toInt() : null,
                  ),
                  const SizedBox(height: 2),
                  Text(progressLabel(l, t), style: context.text.bodySmall),
                  if (t.currentFile.isNotEmpty && t.fileCount > 1)
                    Text(
                      l.transferCurrent(t.currentFile.split('/').last, '${t.currentIndex}', '${t.fileCount}'),
                      style: context.text.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ] else if (status != null)
                  Text(
                    status,
                    style: context.text.bodySmall?.copyWith(
                      color: t.status == 'failed' || t.status == 'declined' ? p.danger : null,
                    ),
                  ),
              ],
            ),
          ),
          if (cancellable)
            Padding(
              padding: const EdgeInsets.only(left: Insets.sm),
              child: t.status == 'queued'
                  ? TextButton(
                      onPressed: () => AppScope.read(context).cancelTransfer(t.id),
                      child: Text(l.sendRemoveQueued),
                    )
                  : IconAction(
                      icon: AppIcons.xmark,
                      tooltip: l.cancel,
                      onTap: () => AppScope.read(context).cancelTransfer(t.id),
                    ),
            ),
        ],
      ),
    );
  }
}

/// 一批现在的状态说明（进行中的进度另外显示）。
String transferStatusText(AppLocalizations l, Transfer t) {
  final out = t.direction == TransferDirection.TRANSFER_DIRECTION_OUTGOING;
  // 好友、陌生设备：对方（或本机用户）拒绝、没有回应、不接收，直接说原因
  if (t.status == 'declined') {
    final direct = switch (t.error) {
      'declined' => out ? l.reasonDeclined(t.deviceName) : l.reasonYouDeclined,
      'timeout' => out ? l.reasonTimeout(t.deviceName) : l.reasonYouIgnored,
      'not_allowed' => l.reasonNotAllowed(t.deviceName),
      'rate_limited' => l.reasonRateLimited(t.deviceName),
      _ => null,
    };
    if (direct != null) return direct;
  }
  return switch (t.status) {
    'asking' => out ? l.transferAskingOut(t.deviceName) : l.transferAskingIn,
    'scanning' => l.transferScanning('${t.scannedFiles}'),
    'queued' => l.transferQueued,
    'waiting' => out ? l.transferWaitingPeer(t.deviceName) : l.transferReceiving,
    'active' => out ? l.transferSending : l.transferReceiving,
    'paused' => l.transferPaused,
    'interrupted' => out ? l.transferInterrupted : l.transferInterruptedIncoming(t.deviceName),
    'done' => out ? l.sendDelivered : (t.present.isNotEmpty && t.present.every((p) => !p) ? l.transferMissing : ''),
    'cancelled' => t.error == 'peer_cancelled' ? l.transferPeerCancelled(t.deviceName) : l.transferCancelled,
    'expired' => l.transferExpired,
    _ => out ? l.transferNotSent(transferReason(l, t)) : l.transferNotReceived(transferReason(l, t)),
  };
}

/// 失败、回绝的原因。发出的说对方，收到的说本机。
String transferReason(AppLocalizations l, Transfer t) {
  final out = t.direction == TransferDirection.TRANSFER_DIRECTION_OUTGOING;
  final short = humanBytes(t.shortfallBytes.toInt());
  return switch (t.error) {
    'no_space' => out ? l.reasonNoSpacePeer(t.deviceName, short) : l.reasonNoSpace(short),
    'dest_unavailable' => out ? l.reasonDestUnavailablePeer(t.deviceName) : l.reasonDestUnavailable,
    'file_too_large' => l.reasonFileTooLarge,
    'disabled' => l.reasonDisabledPeer(t.deviceName),
    'source_changed' => l.reasonSourceChanged,
    'source_missing' => l.reasonSourceMissing,
    'read_error' => l.reasonReadError,
    'write_failed' => l.reasonWriteFailed,
    'hash_mismatch' => l.reasonHashMismatch,
    'unsupported' => l.reasonUnsupported(t.deviceName),
    _ => l.reasonOther,
  };
}

/// 拖放区的边框：平时是虚线，拖着文件经过时变成实线。
class DropZonePainter extends CustomPainter {
  DropZonePainter({required this.color, required this.dashed, required this.fill});

  final Color color;
  final bool dashed;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(Radii.md));
    canvas.drawRRect(rect, Paint()..color = fill);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = dashed ? 1 : 1.5;
    final path = Path()..addRRect(rect.deflate(0.5));
    if (!dashed) {
      canvas.drawPath(path, paint);
      return;
    }
    for (final metric in path.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += 9) {
        canvas.drawPath(metric.extractPath(d, d + 5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(DropZonePainter old) => old.color != color || old.dashed != dashed || old.fill != fill;
}
