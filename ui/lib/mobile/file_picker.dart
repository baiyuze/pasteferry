import 'package:flutter/material.dart';

import '../i18n.dart';
import '../icons.dart';
import '../theme.dart';
import 'host.dart';
import 'ui.dart';

/// 两个发送入口共用：一次勾选多张照片或多个文件，确认后才提交整批。
Future<List<PickedFile>?> pickFilesForSend(BuildContext context) async {
  final picked = <PickedFile>[];
  while (context.mounted) {
    final l = context.l10n;
    final photos = await showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      builder: (context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Insets.lg, 0, Insets.lg, Insets.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.mMultiSelectHint, style: context.text.bodySmall, textAlign: TextAlign.center),
              const SizedBox(height: Insets.md),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: Icon(AppIcons.photo),
                label: Text(l.mChoosePhotos),
              ),
              const SizedBox(height: Insets.sm),
              FilledButton.icon(
                style: secondaryButtonStyle(context),
                onPressed: () => Navigator.pop(context, false),
                icon: Icon(AppIcons.folder),
                label: Text(l.sendChooseFiles),
              ),
            ],
          ),
        ),
      ),
    );
    if (!context.mounted) return null;
    if (photos != null) {
      final files = await Host.pickFiles(photos: photos);
      if (!context.mounted) return null;
      for (final file in files) {
        if (!picked.any((p) => p.id == file.id)) picked.add(file);
      }
    }
    // 取消追加选择只返回确认框；绝不隐式发送已有项目。
    if (picked.isEmpty) return null;
    var addMore = false;
    final ok = await showFileConfirmSheet(context, picked, onAddMore: () => addMore = true);
    if (!context.mounted) return null;
    if (addMore) continue;
    return ok == true ? picked : null;
  }
  return null;
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
Future<bool?> showFileConfirmSheet(BuildContext context, List<PickedFile> files, {VoidCallback? onAddMore}) {
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
                              child: Text(f.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 15)),
                            ),
                            const SizedBox(width: Insets.md),
                            Text(_sizeLabel(f.size), style: TextStyle(fontSize: 13, color: p.textDim)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Insets.md),
            if (onAddMore != null) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: secondaryButtonStyle(context),
                  onPressed: () {
                    onAddMore();
                    Navigator.pop(context, false);
                  },
                  child: Text(l.mAddMore),
                ),
              ),
            ],
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
