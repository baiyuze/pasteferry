import 'dart:async';

import 'package:flutter/material.dart';

import '../app_state.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../main.dart' show AppScope;
import '../widgets/common.dart';
import 'host.dart';

/// 记录上的「复制 / 保存 / 分享」（design/phone-sync.md 3.2.2 节）。
///
/// 文字直接写剪贴板；图片和文件不在本机时（超过电脑的自动同步上限、或之前下载失败）先下载，
/// 下载时不动剪贴板（preserve_clipboard），下完再按用户点的那一项处理。
enum RecordAction { copy, save, share }

bool isMedia(ClipRecord r) => r.kind == ClipKind.CLIP_KIND_IMAGE || r.kind == ClipKind.CLIP_KIND_FILE;

Future<void> runRecordAction(BuildContext context, ClipRecord r, RecordAction action) async {
  final state = AppScope.read(context);
  final l = context.l10n;
  try {
    if (isMedia(r) && r.status != ClipStatus.CLIP_STATUS_READY) {
      if (r.status == ClipStatus.CLIP_STATUS_EXPIRED) {
        showToast(context, l.expired, error: true);
        return;
      }
      showToast(context, l.mDownloading);
      await _download(state, r.id);
    }
    switch (action) {
      case RecordAction.copy:
        await state.applyToClipboard(r.id);
        if (context.mounted) showToast(context, l.mCopied);
      case RecordAction.save:
        final paths = await _localPaths(state, r.id);
        await Host.save(paths);
        if (context.mounted) showToast(context, l.mSaved);
      case RecordAction.share:
        await Host.share(await _localPaths(state, r.id));
    }
  } catch (e) {
    if (context.mounted) showToast(context, l.mActionFailed(AppState.describeError(e)), error: true);
  }
}

Future<List<String>> _localPaths(AppState state, String id) async {
  final paths = await state.localPaths(id);
  if (paths.isEmpty) throw StateError(appL10n.expired);
  return paths;
}

/// 下载到本机、不写剪贴板，等记录变成「就绪」。
Future<void> _download(AppState state, String id) async {
  final done = Completer<void>();
  void check() {
    final r = state.recordById(id);
    if (r == null || done.isCompleted) return;
    if (r.status == ClipStatus.CLIP_STATUS_READY) done.complete();
    if (r.status == ClipStatus.CLIP_STATUS_FAILED) done.completeError(StateError(r.error));
  }

  state.addListener(check);
  try {
    await state.fetchImagePreview(id);
    check();
    await done.future;
  } finally {
    state.removeListener(check);
  }
}
