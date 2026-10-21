import 'dart:io';

import 'package:flutter/material.dart';

import '../app_state.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../platform.dart';
import '../records.dart';
import 'common.dart';

/// 要整份复制、超过这个大小时先确认。见 design/quick-paste-and-favorites.md 第 3.2 节。
const _confirmCopyBytes = 1 << 30;

/// 收藏一条复制记录（另存一份），或取消收藏（放回复制记录的最上面，可以撤销）。
/// [r] 是复制记录（看 favorited 决定收藏还是取消）或收藏本身（取消）。
Future<void> toggleFavorite(BuildContext context, AppState state, ClipRecord r) async {
  final l = context.l10n;
  final remove = r.favorite || r.favorited;
  try {
    if (remove) {
      final back = await state.setFavorite(r.id, false);
      if (!context.mounted) return;
      showToast(context, l.unfavoritedToast, actionLabel: l.undo, onAction: () async {
        try {
          await state.setFavorite(back.id, true);
        } catch (e) {
          if (context.mounted) showToast(context, AppState.describeError(e), error: true);
        }
      });
      return;
    }
    if (_needsFullCopy(r) && !await _confirmLargeCopy(context, r)) return;
    final fav = await state.setFavorite(r.id, true);
    if (!context.mounted) return;
    if (fav.status == ClipStatus.CLIP_STATUS_FAILED) {
      showToast(context, fav.error.isEmpty ? l.transferFailed : fav.error, error: true);
    } else {
      showToast(context, l.favoritedToast);
    }
  } catch (e) {
    if (context.mounted) showToast(context, AppState.describeError(e), error: true);
  }
}

/// 本机复制的大文件要整份复制。Mac 上的 APFS 写时复制几乎不占空间，不问；
/// 从其他设备收到的在缓存里，用硬链接，也不问。
bool _needsFullCopy(ClipRecord r) =>
    !Platform.isMacOS &&
    r.kind == ClipKind.CLIP_KIND_FILE &&
    r.outgoing &&
    r.totalSize.toInt() > _confirmCopyBytes;

Future<bool> _confirmLargeCopy(BuildContext context, ClipRecord r) async {
  final l = context.l10n;
  final size = humanBytes(r.totalSize.toInt());
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.favoriteLargeTitle(size)),
      content: Text(l.favoriteLargeBody(size, Wording.thisDeviceInText)),
      actions: [
        OutlinedButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.saveCopy)),
      ],
    ),
  );
  return ok == true;
}

/// 给收藏起别名（重命名）。清空后保存就恢复按内容显示的标题。
Future<void> renameFavorite(BuildContext context, AppState state, ClipRecord r) async {
  final l = context.l10n;
  final alias = await showDialog<String>(
    context: context,
    builder: (_) => _RenameDialog(record: r),
  );
  if (alias == null || alias.trim() == r.alias) return;
  try {
    await state.setAlias(r.id, alias);
    if (context.mounted) showToast(context, alias.trim().isEmpty ? l.aliasClearedToast : l.renamedToast);
  } catch (e) {
    if (context.mounted) showToast(context, AppState.describeError(e), error: true);
  }
}

class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.record});

  final ClipRecord record;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final _name = TextEditingController(text: widget.record.alias)
    ..selection = TextSelection(baseOffset: 0, extentOffset: widget.record.alias.length);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _save() => Navigator.pop(context, _name.text);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.renameFavoriteTitle),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _name,
              autofocus: true,
              maxLength: 100,
              decoration: InputDecoration(
                // 没起过别名时，提示里是现在显示的标题
                hintText: contentTitle(widget.record),
                counterText: '',
              ),
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 8),
            Text(l.renameFavoriteHint, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
      actions: [
        OutlinedButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(onPressed: _save, child: Text(l.save)),
      ],
    );
  }
}
