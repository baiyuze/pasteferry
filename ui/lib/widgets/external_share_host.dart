import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../app_state.dart';
import '../application_lifecycle.dart';
import '../external_share.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../icons.dart';
import 'common.dart' show humanBytes;
import 'send_dialog.dart';

class ExternalShareHost extends StatefulWidget {
  const ExternalShareHost({
    super.key,
    required this.shares,
    required this.state,
    required this.child,
  });
  final ExternalShares shares;
  final AppState state;
  final Widget child;
  @override
  State<ExternalShareHost> createState() => _ExternalShareHostState();
}

class _ExternalShareHostState extends State<ExternalShareHost> {
  bool _showing = false;
  String? _blockedDraft, _failure;
  @override
  void initState() {
    super.initState();
    widget.shares.addListener(_changed);
    widget.state.addListener(_changed);
    _changed();
  }

  void _changed() {
    widget.shares.transfersChanged([
      ...widget.state.transfers(TransferDirection.TRANSFER_DIRECTION_OUTGOING),
    ]);
    if (!mounted) return;
    setState(() {});
    if (!_showing &&
        widget.shares.pending.isNotEmpty &&
        widget.shares.pending.first.id != _blockedDraft &&
        widget.state.isOnline) {
      _showing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _show());
    }
  }

  Future<void> _show() async {
    final ctx = appNavigatorKey.currentContext;
    if (!mounted || ctx == null || widget.shares.pending.isEmpty) {
      _showing = false;
      return;
    }
    final draft = widget.shares.pending.first;
    Transfer? result;
    try {
      result = await showDialog<Transfer>(
        context: ctx,
        barrierDismissible: false,
        builder: (_) => _SharedFilesDialog(draft: draft, state: widget.state),
      );
      await widget.shares.complete(draft, result);
    } catch (e) {
      _blockedDraft = draft.id;
      _failure = AppState.describeError(e);
      debugPrint('External share: $e');
    } finally {
      _showing = false;
      if (mounted) _changed();
    }
  }

  @override
  void dispose() {
    widget.shares.removeListener(_changed);
    widget.state.removeListener(_changed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final importing = widget.shares.importing;
    final failed =
        _blockedDraft != null &&
        widget.shares.pending.any((x) => x.id == _blockedDraft);
    final pending = widget.shares.pending.isNotEmpty && !widget.state.isOnline;
    return Stack(
      children: [
        widget.child,
        if (pending || importing || failed)
          Positioned(
            top: 52,
            left: 16,
            right: 16,
            child: SafeArea(
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                child: ListTile(
                  title: Text(
                    importing
                        ? context.l10n.shareImporting
                        : context.l10n.shareConfirmTitle,
                  ),
                  subtitle: importing
                      ? const LinearProgressIndicator()
                      : Text(
                          failed
                              ? _failure!
                              : context.l10n.linkServiceNotRunning,
                        ),
                  trailing: TextButton(
                    onPressed: () {
                      if (failed) {
                        _blockedDraft = null;
                        _changed();
                      } else {
                        unawaited(
                          importing
                              ? widget.shares.cancelImports()
                              : widget.state.enableService(),
                        );
                      }
                    },
                    child: Text(
                      importing ? context.l10n.cancel : context.l10n.retry,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SharedFilesDialog extends StatefulWidget {
  const _SharedFilesDialog({required this.draft, required this.state});
  final ShareDraft draft;
  final AppState state;
  @override
  State<_SharedFilesDialog> createState() => _SharedFilesDialogState();
}

class _SharedFilesDialogState extends State<_SharedFilesDialog> {
  String? _target;
  bool _sending = false;
  String? _error;
  late final _metadata = {
    for (final path in widget.draft.paths) path: FileStat.stat(path),
  };

  Future<void> _send(Device target) async {
    if (_sending) return;
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      for (final path in widget.draft.paths) {
        final type = await FileSystemEntity.type(path);
        if (type != FileSystemEntityType.file &&
            type != FileSystemEntityType.directory) {
          if (mounted) setState(() => _error = context.l10n.sendErrMissing);
          return;
        }
      }
      if (!mounted) return;
      final transfer = await sendFilesTo(context, target, widget.draft.paths);
      if (transfer != null && mounted) Navigator.pop(context, transfer);
    } catch (e) {
      if (mounted) setState(() => _error = AppState.describeError(e));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        final peers = [...widget.state.peers]
          ..sort((a, b) => a.name.compareTo(b.name));
        final selected = peers.where((d) => d.id == _target).firstOrNull;
        final invalid =
            widget.draft.error.isNotEmpty || widget.draft.paths.isEmpty;
        return PopScope(
          canPop: !_sending,
          child: AlertDialog(
            insetPadding: const EdgeInsets.all(16),
            title: Text(l.shareConfirmTitle),
            content: SizedBox(
              width: 440,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (invalid)
                      Text(
                        widget.draft.error.isEmpty ||
                                widget.draft.error == 'files_only'
                            ? l.shareFilesOnly
                            : widget.draft.error,
                      ),
                    if (!invalid) ...[
                      Text(l.mSendConfirmTitle(widget.draft.paths.length)),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 160),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (final path in widget.draft.paths)
                                ListTile(
                                  dense: true,
                                  leading: Icon(AppIcons.folder),
                                  title: Text(
                                    path.replaceAll('\\', '/').split('/').last,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: FutureBuilder<FileStat>(
                                    future: _metadata[path],
                                    builder: (context, snapshot) {
                                      final info = snapshot.data;
                                      return info != null &&
                                              info.type ==
                                                  FileSystemEntityType.file
                                          ? Text(humanBytes(info.size))
                                          : const SizedBox.shrink();
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(l.shareChooseDevice),
                      if (peers.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(l.sendNoDevicesBody),
                        ),
                      RadioGroup<String>(
                        groupValue: _target,
                        onChanged: (id) => setState(() => _target = id),
                        child: Column(
                          children: [
                            for (final d in peers)
                              RadioListTile<String>(
                                title: Text(d.name),
                                subtitle: Text(
                                  !d.online
                                      ? l.offline
                                      : !d.receivesFiles
                                      ? l.sendNeedsUpdate
                                      : d.receiveDisabled
                                      ? l.sendNotReceiving
                                      : l.online,
                                ),
                                value: d.id,
                                enabled:
                                    !_sending &&
                                    d.online &&
                                    d.receivesFiles &&
                                    !d.receiveDisabled,
                              ),
                          ],
                        ),
                      ),
                    ],
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: _sending ? null : () => Navigator.pop(context),
                child: Text(l.cancel),
              ),
              if (!invalid)
                FilledButton(
                  onPressed:
                      _sending ||
                          selected == null ||
                          !selected.online ||
                          !selected.receivesFiles ||
                          selected.receiveDisabled
                      ? null
                      : () => _send(selected),
                  child: Text(l.sendAction),
                ),
            ],
          ),
        );
      },
    );
  }
}
