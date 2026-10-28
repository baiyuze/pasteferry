import 'dart:io';

import 'package:flutter/material.dart';

import '../app_state.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../icons.dart';
import '../main.dart' show AppScope;
import '../records.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'ui.dart';
import 'record_actions.dart';

/// 复制记录（design/phone-sync.md 3.2.4 节）：搜索、按类型筛选、列表；点开看详情，长按删除。
class RecordsTab extends StatefulWidget {
  const RecordsTab({super.key});

  @override
  State<RecordsTab> createState() => _RecordsTabState();
}

class _RecordsTabState extends State<RecordsTab> {
  RecordFilter _filter = RecordFilter.all;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final p = context.palette;
    final source = state.searching ? (state.searchResults ?? const <ClipRecord>[]) : state.records;
    final records = source.where(_filter.matches).toList();

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverToBoxAdapter(child: MobileHeader(title: l.mTabRecords)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Insets.lg, 0, Insets.lg, Insets.md),
              child: Column(
                children: [
                  MobileSearchField(hint: l.searchHint, onChanged: state.search),
                  const SizedBox(height: Insets.md),
                  MobileSegmented<RecordFilter>(
                    value: _filter,
                    segments: [for (final f in RecordFilter.values) (f, f.label(l))],
                    onChanged: (f) => setState(() => _filter = f),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: LanNotice()),
          if (records.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(Insets.xl, Insets.xl, Insets.xl, 96),
                child: EmptyState(
                  icon: AppIcons.clock,
                  title: state.searching
                      ? l.searchEmptyTitle(state.searchQuery)
                      : _filter == RecordFilter.all
                      ? l.historyEmptyTitle
                      : l.historyEmptyFilteredTitle,
                  description: state.searching ? l.searchEmptyBody : l.historyEmptySubtitle,
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Insets.lg, 0, Insets.lg, Insets.xl),
              sliver: DecoratedSliver(
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: BorderRadius.circular(Radii.lg),
                  border: Border.all(color: p.border),
                ),
                sliver: SliverList.separated(
                  itemCount: records.length,
                  // 分隔线从文字处开始：左边距 16 + 图标 40 + 间距 12
                  separatorBuilder: (_, _) => const Divider(indent: 68, height: 1),
                  itemBuilder: (context, i) => _RecordRow(
                    record: records[i],
                    first: i == 0,
                    last: i == records.length - 1,
                    query: state.searching ? state.searchQuery : null,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 一行记录：左边类型图标（图片换成缩略图），中间内容与「来自 × · 大小 · 时间」，
/// 右边文字是「复制」，图片和文件是箭头（点开再复制、保存、分享）。和网页的一行一样。
class _RecordRow extends StatelessWidget {
  const _RecordRow({required this.record, required this.first, required this.last, this.query});

  final ClipRecord record;
  final bool first;
  final bool last;
  final String? query;

  @override
  Widget build(BuildContext context) {
    final r = record;
    final p = context.palette;
    final l = context.l10n;
    final state = AppScope.of(context);
    final note = statusNote(r);
    final progress = state.progressOf(r.id);
    final media = isMedia(r);
    return InkWell(
      borderRadius: BorderRadius.vertical(
        top: first ? const Radius.circular(Radii.lg) : Radius.zero,
        bottom: last ? const Radius.circular(Radii.lg) : Radius.zero,
      ),
      onTap: () => showRecordSheet(context, r),
      onLongPress: () => confirmDelete(context, r),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Insets.lg, Insets.md, Insets.sm, Insets.md),
        child: Row(
          children: [
            Align(alignment: Alignment.topCenter, child: RecordThumb(record: r)),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contentTitle(r, query: query),
                    maxLines: media ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, height: 1.375),
                  ),
                  const SizedBox(height: 2),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: recordSource(r),
                          style: r.outgoing ? TextStyle(color: p.accent) : null,
                        ),
                        TextSpan(
                          text: [
                            if (r.totalSize > 0) humanBytes(r.totalSize.toInt()),
                            relativeTime(recordTime(r)),
                          ].map((e) => ' · $e').join(),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: p.textDim),
                  ),
                  if (note != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        note,
                        style: TextStyle(
                          fontSize: 13,
                          color: r.status == ClipStatus.CLIP_STATUS_FAILED ? p.danger : p.textDim,
                        ),
                      ),
                    ),
                  if (r.status == ClipStatus.CLIP_STATUS_FETCHING) ...[
                    const SizedBox(height: 6),
                    LinearProgressIndicator(value: progress, minHeight: 3, borderRadius: BorderRadius.circular(2)),
                  ],
                ],
              ),
            ),
            const SizedBox(width: Insets.xs),
            if (media)
              Padding(
                padding: const EdgeInsets.only(right: Insets.xs),
                child: Icon(AppIcons.chevronRight, size: 20, color: p.textFaint),
              )
            else
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                onPressed: () => runRecordAction(context, r, RecordAction.copy),
                child: Text(l.mCopy),
              ),
          ],
        ),
      ),
    );
  }
}

/// 列表里标题下面要补充的状态：还没下载、下载中、失败、过期。就绪时为 null
String? statusNote(ClipRecord r) {
  final l = appL10n;
  return switch (r.status) {
    ClipStatus.CLIP_STATUS_REMOTE_ONLY => l.mNotDownloaded,
    ClipStatus.CLIP_STATUS_FETCHING => l.mDownloading,
    ClipStatus.CLIP_STATUS_FAILED => l.transferFailed,
    ClipStatus.CLIP_STATUS_EXPIRED => l.expired,
    _ => null,
  };
}

/// 行首 40×40：图片显示缩略图，其他显示类型图标，和网页一样不加底色。
class RecordThumb extends StatelessWidget {
  const RecordThumb({super.key, required this.record, this.size = 40});

  final ClipRecord record;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final r = record;
    final image = r.status == ClipStatus.CLIP_STATUS_READY && r.imageCount > 0;
    final icon = Icon(kindIcon(r), size: 24, color: p.textDim);
    return SizedBox.square(
      dimension: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radii.sm),
        child: image ? _Preview(clipId: r.id, fallback: Center(child: icon)) : Center(child: icon),
      ),
    );
  }
}

/// 记录里第一张图片。路径由 Go 核心给出（HEIC 之类先转成 PNG），按记录缓存
class _Preview extends StatelessWidget {
  const _Preview({required this.clipId, required this.fallback});

  final String clipId;
  final Widget fallback;

  static final _paths = <String, Future<String>>{};

  @override
  Widget build(BuildContext context) {
    final state = AppScope.read(context);
    final path = _paths.putIfAbsent(clipId, () => state.imagePreview(clipId).then((g) => g.path));
    return FutureBuilder<String>(
      future: path,
      builder: (context, snap) {
        if (snap.hasError) {
          _paths.remove(clipId);
          return fallback;
        }
        if (!snap.hasData) return fallback;
        return Image.file(
          File(snap.data!),
          fit: BoxFit.cover,
          cacheWidth: 160,
          errorBuilder: (_, _, _) => fallback,
        );
      },
    );
  }
}

Future<void> confirmDelete(BuildContext context, ClipRecord r) async {
  final l = context.l10n;
  final state = AppScope.read(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.mDeleteConfirm),
      content: Text(contentTitle(r), maxLines: 3, overflow: TextOverflow.ellipsis),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: ctx.palette.danger),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l.mDelete),
        ),
      ],
    ),
  );
  if (ok != true) return;
  try {
    await state.deleteRecords(ids: [r.id]);
    if (context.mounted) showToast(context, l.deleted);
  } catch (e) {
    if (context.mounted) showToast(context, AppState.describeError(e), error: true);
  }
}

/// 点开一条记录：全文、图片预览或文件列表，下面是「复制 / 保存 / 分享」。
Future<void> showRecordSheet(BuildContext context, ClipRecord r) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _RecordSheet(id: r.id, initial: r),
);

class _RecordSheet extends StatelessWidget {
  const _RecordSheet({required this.id, required this.initial});

  final String id;
  final ClipRecord initial;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final r = state.recordById(id) ?? initial;
    final l = context.l10n;
    final p = context.palette;
    final media = isMedia(r);
    final busy = r.status == ClipStatus.CLIP_STATUS_FETCHING;
    final note = statusNote(r);
    const buttonSize = Size(0, 44);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Insets.lg, 0, Insets.lg, Insets.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${recordSource(r)} · ${relativeTime(recordTime(r))}',
              style: TextStyle(fontSize: 13, color: p.textDim),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Insets.md),
            Flexible(
              child: SingleChildScrollView(
                child: media ? _MediaBody(record: r) : _FullText(record: r),
              ),
            ),
            if (note != null) ...[
              const SizedBox(height: Insets.md),
              Text(
                r.status == ClipStatus.CLIP_STATUS_REMOTE_ONLY ? '$note · ${l.mDownloadHint}' : note,
                style: TextStyle(fontSize: 13, color: p.textDim),
                textAlign: TextAlign.center,
              ),
            ],
            if (busy) ...[
              const SizedBox(height: Insets.sm),
              LinearProgressIndicator(value: state.progressOf(r.id), minHeight: 3),
            ],
            const SizedBox(height: Insets.lg),
            FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: buttonSize),
              onPressed: busy ? null : () => runRecordAction(context, r, RecordAction.copy),
              icon: Icon(AppIcons.copy, size: 20),
              label: Text(l.mCopy),
            ),
            if (media) ...[
              const SizedBox(height: Insets.md),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      style: secondaryButtonStyle(context).copyWith(minimumSize: const WidgetStatePropertyAll(buttonSize)),
                      onPressed: busy ? null : () => runRecordAction(context, r, RecordAction.save),
                      icon: Icon(AppIcons.download, size: 20),
                      label: Text(l.save),
                    ),
                  ),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: FilledButton.icon(
                      style: secondaryButtonStyle(context).copyWith(minimumSize: const WidgetStatePropertyAll(buttonSize)),
                      onPressed: busy ? null : () => runRecordAction(context, r, RecordAction.share),
                      icon: Icon(AppIcons.share, size: 20),
                      label: Text(l.mShare),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: Insets.xs),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: p.danger),
              onPressed: () async {
                Navigator.pop(context);
                await confirmDelete(context, r);
              },
              child: Text(l.deleteRecord),
            ),
          ],
        ),
      ),
    );
  }
}

class _FullText extends StatelessWidget {
  const _FullText({required this.record});

  final ClipRecord record;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.read(context);
    final l = context.l10n;
    final p = context.palette;
    return FutureBuilder<ClipDetail>(
      future: state.clipDetail(record.id),
      builder: (context, snap) {
        final d = snap.data;
        final text = d?.text ?? record.textPreview;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(Insets.md),
              decoration: BoxDecoration(color: p.fill, borderRadius: BorderRadius.circular(Radii.md)),
              child: SelectableText(text, style: const TextStyle(fontSize: 16, height: 1.6)),
            ),
            if (d != null && d.textLength > text.runes.length) ...[
              const SizedBox(height: Insets.sm),
              Text(l.mTextTruncated(text.runes.length, d.textLength), style: TextStyle(fontSize: 13, color: p.textDim)),
            ],
          ],
        );
      },
    );
  }
}

/// 图片和文件：有缩略图时放在上面，下面一组列出名字和大小，和网页的详情一样。
class _MediaBody extends StatelessWidget {
  const _MediaBody({required this.record});

  final ClipRecord record;

  @override
  Widget build(BuildContext context) {
    final r = record;
    final p = context.palette;
    final l = context.l10n;
    final items = r.kind == ClipKind.CLIP_KIND_IMAGE
        ? [ClipItem(name: l.imageRecord, size: r.totalSize)]
        : r.items;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (r.status == ClipStatus.CLIP_STATUS_READY && r.imageCount > 0) ...[
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Radii.md),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 224),
                child: _Preview(clipId: r.id, fallback: const SizedBox.shrink()),
              ),
            ),
          ),
          const SizedBox(height: Insets.md),
        ],
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(color: p.border),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const Divider(indent: Insets.lg, height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
                  child: Row(
                    children: [
                      Icon(items[i].isDir ? AppIcons.folder : kindIcon(r), size: 22, color: p.textDim),
                      const SizedBox(width: Insets.md),
                      Expanded(
                        child: Text(
                          items[i].name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      if (items[i].size > 0)
                        Text(humanBytes(items[i].size.toInt()), style: TextStyle(fontSize: 13, color: p.textDim)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
