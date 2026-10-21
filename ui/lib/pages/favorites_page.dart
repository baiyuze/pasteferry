import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_state.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../icons.dart';
import '../main.dart';
import '../records.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/favorite_actions.dart';
import '../widgets/image_preview_dialog.dart';
import '../widgets/record_hover.dart';

/// 收藏：另存的一份，不会被自动清理。见 design/quick-paste-and-favorites.md 第 3 节。
///
/// 布局与复制记录页一样。每一行只有两个操作：放进剪贴板、取消收藏（放回复制记录，可以撤销）。
/// 没有删除：想删掉的先取消收藏，再到复制记录里删。
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  RecordFilter _filter = RecordFilter.all;
  final _search = TextEditingController();
  final _searchFocus = FocusNode();
  AppState? _state;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _state = AppScope.read(context);
  }

  @override
  void dispose() {
    // 离开这一页就不再搜索，回来看到的是完整的列表
    _state?.searchFavorites('', notify: false);
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final searching = state.searchingFavorites;
    final all = state.favorites;
    // 搜索结果还没回来时为 null，这时列表先空着，不闪一下「没有找到」
    final records = (searching ? state.favoriteResults : all)?.where(_filter.matches).toList();
    final l = context.l10n;

    final page = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: l.navFavorites,
          subtitle: searching && records != null
              ? l.searchResultCount(records.length)
              : all.isEmpty
                  ? null
                  : l.favoritesSubtitle(all.length, humanBytes(state.favoritesBytes)),
        ),
        if (all.isNotEmpty || searching)
          Padding(
            padding: const EdgeInsets.fromLTRB(Insets.xl, 0, Insets.xl, Insets.md),
            child: Row(
              children: [
                Expanded(
                  child: SearchField(
                    controller: _search,
                    focusNode: _searchFocus,
                    hint: l.favoritesSearchHint,
                    clearTooltip: l.searchClear,
                    onChanged: state.searchFavorites,
                  ),
                ),
                const SizedBox(width: Insets.md),
                Segmented<RecordFilter>(
                  value: _filter,
                  segments: [for (final f in RecordFilter.values) (f, f.label(l))],
                  onChanged: (f) => setState(() => _filter = f),
                ),
              ],
            ),
          ),
        Expanded(
          child: records == null
              ? const SizedBox.shrink()
              : records.isEmpty && searching
                  ? EmptyState(
                      icon: AppIcons.search,
                      title: l.searchEmptyTitle(state.favoriteQuery),
                      description: l.searchEmptyBody,
                    )
                  : records.isEmpty
                      ? EmptyState(
                          icon: all.isEmpty ? AppIcons.star : AppIcons.filter,
                          title: all.isEmpty ? l.favoritesEmptyTitle : l.historyEmptyFilteredTitle,
                          description: all.isEmpty ? l.favoritesEmptyBody : null,
                        )
                      : CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(Insets.xl, 0, Insets.xl, Insets.xl),
                              sliver: DecoratedSliver(
                                decoration: BoxDecoration(
                                  color: context.palette.surface,
                                  borderRadius: BorderRadius.circular(Radii.md),
                                  border: Border.all(color: context.palette.border),
                                ),
                                sliver: SliverPadding(
                                  padding: const EdgeInsets.all(Insets.xs),
                                  sliver: SliverList.separated(
                                    itemCount: records.length,
                                    separatorBuilder: (_, _) => const Divider(indent: 44, endIndent: 8),
                                    itemBuilder: (_, i) => _FavoriteRow(
                                      key: ValueKey(records[i].id),
                                      record: records[i],
                                      highlight: searching ? state.favoriteQuery : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
        ),
      ],
    );

    // ⌘F（Windows、Linux 上是 Ctrl+F）跳到搜索框
    return CallbackShortcuts(
      bindings: {
        SingleActivator(LogicalKeyboardKey.keyF, meta: Platform.isMacOS, control: !Platform.isMacOS):
            _searchFocus.requestFocus,
      },
      child: Focus(autofocus: true, child: page),
    );
  }
}

class _FavoriteRow extends StatefulWidget {
  const _FavoriteRow({super.key, required this.record, this.highlight});

  final ClipRecord record;
  final String? highlight;

  @override
  State<_FavoriteRow> createState() => _FavoriteRowState();
}

class _FavoriteRowState extends State<_FavoriteRow> {
  bool _hovered = false;
  bool _busy = false;

  @override
  Widget build(BuildContext context) =>
      RecordHover(record: widget.record, details: AppScope.read(context), child: _content(context));

  Widget _content(BuildContext context) {
    final r = widget.record;
    final p = context.palette;
    final l = context.l10n;
    final previewable = r.imageCount > 0 && r.status == ClipStatus.CLIP_STATUS_READY;
    final detail = switch (r.status) {
      ClipStatus.CLIP_STATUS_FETCHING => l.favoriteSaving,
      ClipStatus.CLIP_STATUS_FAILED => r.error.isEmpty ? l.transferFailed : r.error,
      _ => null,
    };

    return MouseRegion(
      cursor: previewable ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: previewable ? () => showImagePreview(context, r.id) : null,
        borderRadius: BorderRadius.circular(Radii.sm),
        child: Container(
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
          decoration: BoxDecoration(
            color: _hovered ? p.hover : Colors.transparent,
            borderRadius: BorderRadius.circular(Radii.sm),
          ),
          child: Row(
            children: [
              Icon(kindIcon(r), size: 18, color: p.textDim),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: highlightMatches(
                          recordTitle(r, query: widget.highlight),
                          widget.highlight,
                          TextStyle(backgroundColor: p.accent.withValues(alpha: 0.28)),
                        ),
                      ),
                      style: context.text.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(recordMeta(r), style: context.text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (detail != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        detail,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.bodySmall?.copyWith(
                          color: r.status == ClipStatus.CLIP_STATUS_FAILED ? p.danger : p.textDim,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: Insets.md),
              _trailing(context, r),
            ],
          ),
        ),
      ),
    );
  }

  Widget _trailing(BuildContext context, ClipRecord r) {
    final l = context.l10n;
    if (_busy) {
      return const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2));
    }
    final unfavorite = IconAction(
      icon: AppIcons.starFill,
      color: context.palette.accent,
      tooltip: l.unfavoriteAction,
      onTap: () => toggleFavorite(context, AppScope.read(context), r),
    );
    // 重命名：悬停时才显示，和「放进剪贴板」一样不占眼
    final rename = Visibility(
      visible: _hovered,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: IconAction(
        icon: AppIcons.pencil,
        tooltip: l.renameAction,
        onTap: () => renameFavorite(context, AppScope.read(context), r),
      ),
    );
    switch (r.status) {
      case ClipStatus.CLIP_STATUS_FETCHING:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 72, child: LinearProgressIndicator(minHeight: 3)),
            const SizedBox(width: Insets.sm),
            rename,
            unfavorite,
          ],
        );
      case ClipStatus.CLIP_STATUS_FAILED:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
              // 再收藏一次就是重新另存：下载失败的重新下载，复制失败的重新复制
              onPressed: () => _run(() => AppScope.read(context).setFavorite(r.id, true), null),
              child: Text(l.retry),
            ),
            const SizedBox(width: Insets.xs),
            rename,
            unfavorite,
          ],
        );
      default:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: _hovered,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: TextButton(
                onPressed: () => _run(() => AppScope.read(context).applyToClipboard(r.id), l.putOnClipboardDone),
                child: Text(l.putOnClipboard),
              ),
            ),
            rename,
            unfavorite,
          ],
        );
    }
  }

  Future<void> _run(Future<void> Function() action, String? success) async {
    setState(() => _busy = true);
    try {
      await action();
      if (mounted && success != null) showToast(context, success);
    } catch (e) {
      if (mounted) showToast(context, AppState.describeError(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
