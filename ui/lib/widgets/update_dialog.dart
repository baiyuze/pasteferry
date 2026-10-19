import 'dart:async';
import 'dart:io' show exit;

import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart' show GrpcError, StatusCode;

import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../main.dart';
import '../platform.dart';
import '../theme.dart';
import 'common.dart';

/// 打开更新窗口：先检查，有新版本时列出各版的更新日志，用户确认后下载、校验、安装并自动重新打开。
Future<void> showUpdateDialog(BuildContext context) => showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const UpdateDialog(),
    );

/// 安装开始后界面要退出，让更新助手替换文件。测试里换成不退出的实现。
@visibleForTesting
void Function() quitForUpdate = () => exit(0);

enum _Phase { checking, failed, upToDate, available, downloading, verifying, installing, downloadFailed }

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({super.key});

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  _Phase _phase = _Phase.checking;
  UpdateInfo? _info;
  String? _error;
  int _done = 0, _total = 0;
  StreamSubscription<UpdateProgress>? _download;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    _download?.cancel();
    super.dispose();
  }

  Future<void> _check() async {
    setState(() {
      _phase = _Phase.checking;
      _error = null;
    });
    final state = AppScope.read(context);
    final language = settingFromLocale(Localizations.localeOf(context));
    try {
      final info = await state.checkForUpdate(language);
      if (!mounted) return;
      setState(() {
        _info = info;
        _phase = info.available ? _Phase.available : _Phase.upToDate;
      });
    } catch (e) {
      if (!mounted) return;
      final unsupported = e is GrpcError && e.code == StatusCode.unimplemented;
      setState(() {
        _phase = _Phase.failed;
        _error = unsupported ? context.l10n.updateUnsupportedBuild : context.l10n.updateCheckFailed;
      });
    }
  }

  void _startDownload() {
    final info = _info!;
    setState(() {
      _phase = _Phase.downloading;
      _done = 0;
      _total = info.downloadBytes.toInt();
    });
    _download = AppScope.read(context).downloadUpdate(info.latestVersion).listen(
      (p) {
        if (!mounted) return;
        setState(() {
          if (p.done) {
            _phase = _Phase.verifying;
          } else {
            _done = p.downloaded.toInt();
            _total = p.total.toInt();
          }
        });
      },
      onError: (Object e) {
        if (mounted) setState(() => _phase = _Phase.downloadFailed);
      },
      onDone: () {
        if (!mounted) return;
        if (_phase == _Phase.verifying) {
          _install();
        } else if (_phase == _Phase.downloading) {
          setState(() => _phase = _Phase.downloadFailed);
        }
      },
      cancelOnError: true,
    );
  }

  Future<void> _cancelDownload() async {
    await _download?.cancel();
    _download = null;
    if (mounted) setState(() => _phase = _Phase.available);
  }

  Future<void> _install() async {
    setState(() => _phase = _Phase.installing);
    try {
      await AppScope.read(context).installUpdate(_info!.latestVersion);
      // 给用户一点时间看到「正在安装」，再退出让更新助手接手
      await Future<void>.delayed(const Duration(milliseconds: 600));
      quitForUpdate();
    } catch (e) {
      if (!mounted) return;
      final message = e is GrpcError ? (e.message ?? '') : e.toString();
      setState(() {
        _phase = _Phase.failed;
        _error = context.l10n.updateInstallFailed(message);
      });
    }
  }

  Future<void> _skip() async {
    final version = _info!.latestVersion;
    final state = AppScope.read(context);
    Navigator.pop(context);
    try {
      await state.skipUpdate(version);
    } catch (_) {
      // 跳过只是不再提示，记不住也不影响使用
    }
  }

  void _openDownloadPage() => openUrl(downloadPageUrl(Localizations.localeOf(context)));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final info = _info;
    return AlertDialog(
      title: Text(switch (_phase) {
        _Phase.upToDate || _Phase.checking || _Phase.failed => l.updateCheck,
        _ => l.updateAvailableTitle(info!.latestVersion),
      }),
      content: SizedBox(width: 440, child: _body(context)),
      actions: _actions(context),
    );
  }

  Widget _body(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final info = _info;
    switch (_phase) {
      case _Phase.checking:
        return _busy(context, l.updateChecking);
      case _Phase.failed:
        return Text(_error ?? '', style: context.text.bodyMedium?.copyWith(color: p.danger));
      case _Phase.upToDate:
        return Text(l.updateUpToDate(info!.currentVersion), style: context.text.bodyMedium);
      case _Phase.downloading:
        final fraction = _total > 0 ? (_done / _total).clamp(0.0, 1.0) : null;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.updateDownloading(humanBytes(_done), humanBytes(_total)), style: context.text.bodyMedium),
            const SizedBox(height: Insets.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: fraction, minHeight: 6, color: p.accent, backgroundColor: p.fill),
            ),
          ],
        );
      case _Phase.verifying:
        return _busy(context, l.updateVerifying);
      case _Phase.installing:
        return _busy(context, info!.installKind == 'linux-deb' ? l.updateInstallingPassword : l.updateInstalling);
      case _Phase.downloadFailed:
        return Text(l.updateDownloadFailed, style: context.text.bodyMedium?.copyWith(color: p.danger));
      case _Phase.available:
        return _notes(context, info!);
    }
  }

  Widget _busy(BuildContext context, String text) => Row(
        children: [
          const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
          const SizedBox(width: Insets.md),
          Expanded(child: Text(text, style: context.text.bodyMedium)),
        ],
      );

  /// 比当前新的各版更新日志：落后不止一版时逐版列出，每版分「新增」与「修复」。
  Widget _notes(BuildContext context, UpdateInfo info) {
    final l = context.l10n;
    final p = context.palette;
    final blocker = switch (info.installBlocker) {
      '' => null,
      'dev' => l.updateBlockedDev,
      'must_move' => l.updateBlockedMustMove,
      'read_only' => l.updateBlockedReadOnly,
      _ => l.updateBlockedUnsupported,
    };
    final several = info.releases.length > 1;
    Widget list(String title, List<String> items) => Padding(
          padding: const EdgeInsets.only(top: Insets.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.text.labelMedium),
              const SizedBox(height: 4),
              for (final item in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('·  ', style: context.text.bodyMedium?.copyWith(color: p.textDim)),
                      Expanded(child: Text(item, style: context.text.bodyMedium)),
                    ],
                  ),
                ),
            ],
          ),
        );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.updateCurrentSize(info.currentVersion, humanBytes(info.downloadBytes.toInt())),
          style: context.text.bodySmall,
        ),
        const SizedBox(height: Insets.md),
        ConstrainedBox(
          // 最小窗口只有 560 高：日志区让出标题、说明与按钮的位置，其余滚动
          constraints: BoxConstraints(maxHeight: (MediaQuery.sizeOf(context).height - 340).clamp(96.0, 320.0)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final r in info.releases) ...[
                  if (several)
                    Padding(
                      padding: const EdgeInsets.only(top: Insets.sm),
                      child: Text(r.date.isEmpty ? r.version : '${r.version}  ·  ${r.date}', style: context.text.titleSmall),
                    ),
                  if (r.changes.isNotEmpty) list(l.updateNew, r.changes),
                  if (r.fixes.isNotEmpty) list(l.updateFixed, r.fixes),
                ],
              ],
            ),
          ),
        ),
        if (blocker != null) ...[
          const SizedBox(height: Insets.md),
          Text(blocker, style: context.text.bodySmall?.copyWith(color: p.warning)),
        ],
      ],
    );
  }

  List<Widget> _actions(BuildContext context) {
    final l = context.l10n;
    final info = _info;
    void close() => Navigator.pop(context);
    switch (_phase) {
      case _Phase.checking:
        return [TextButton(onPressed: close, child: Text(l.cancel))];
      case _Phase.failed:
        return [
          if (info != null && info.available) TextButton(onPressed: _openDownloadPage, child: Text(l.updateOpenDownload)),
          TextButton(onPressed: close, child: Text(l.close)),
          FilledButton(onPressed: _check, child: Text(l.retry)),
        ];
      case _Phase.upToDate:
        return [FilledButton(onPressed: close, child: Text(l.close))];
      case _Phase.available:
        if (info!.installBlocker.isNotEmpty) {
          return [
            TextButton(onPressed: close, child: Text(l.updateLater)),
            FilledButton(onPressed: _openDownloadPage, child: Text(l.updateOpenDownload)),
          ];
        }
        return [
          TextButton(onPressed: _skip, child: Text(l.updateSkip)),
          TextButton(onPressed: close, child: Text(l.updateLater)),
          FilledButton(onPressed: _startDownload, child: Text(l.updateInstall)),
        ];
      case _Phase.downloading:
        return [TextButton(onPressed: _cancelDownload, child: Text(l.cancel))];
      case _Phase.verifying:
      case _Phase.installing:
        return const [];
      case _Phase.downloadFailed:
        return [
          TextButton(onPressed: _openDownloadPage, child: Text(l.updateOpenDownload)),
          TextButton(onPressed: close, child: Text(l.close)),
          FilledButton(onPressed: _startDownload, child: Text(l.retry)),
        ];
    }
  }
}
