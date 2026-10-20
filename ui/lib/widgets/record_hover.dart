import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../records.dart';
import '../theme.dart';
import 'common.dart';

/// 悬停提示框要的数据：完整的文字与图片在本机的位置。AppState 与快捷窗口各自提供。
abstract interface class RecordDetails {
  Future<ClipDetail> clipDetail(String clipId);
  Future<GetImagePreviewResponse> imagePreview(String clipId, {int index = 0});
}

/// 鼠标在一行上停约 0.5 秒，弹出提示框显示完整内容：文字的全文、放大的图片、完整的文件列表。
/// 主窗口的复制记录页、收藏页与快捷窗口共用，见 design/quick-paste-and-favorites.md 第 4 节。
///
/// 只认鼠标移动：用键盘上下移动时列表滚动，鼠标下面换了一行也不弹，免得一路闪。
/// 提示框画在窗口里面、这一行的下面，下面放不下就放到上面；它不接鼠标，鼠标照样能移到别的行。
class RecordHover extends StatefulWidget {
  const RecordHover({super.key, required this.record, required this.details, required this.child});

  final ClipRecord record;
  final RecordDetails details;
  final Widget child;

  /// 鼠标停多久才弹出
  static const delay = Duration(milliseconds: 500);

  @override
  State<RecordHover> createState() => _RecordHoverState();
}

class _RecordHoverState extends State<RecordHover> {
  final _portal = OverlayPortalController();
  final _link = LayerLink();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _arm() {
    if (_portal.isShowing) return;
    _timer?.cancel();
    _timer = Timer(RecordHover.delay, () {
      if (mounted) _portal.show();
    });
  }

  void _hide() {
    _timer?.cancel();
    if (_portal.isShowing) _portal.hide();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _portal,
        overlayChildBuilder: _card,
        child: MouseRegion(
          onHover: (_) => _arm(),
          onExit: (_) => _hide(),
          child: Listener(
            // 点了这一行就收起来：要么粘贴了，要么打开了预览
            onPointerDown: (_) => _hide(),
            child: widget.child,
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext context) {
    final box = this.context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return const SizedBox.shrink();
    final screen = MediaQuery.sizeOf(context);
    final top = box.localToGlobal(Offset.zero);
    const margin = 12.0;
    const estimatedHeight = 300.0;
    final below = screen.height - (top.dy + box.size.height) >= estimatedHeight + margin ||
        top.dy < screen.height / 2;
    final width = (screen.width - margin * 2).clamp(200.0, 460.0);
    // 左边和这一行的文字对齐（让开类型图标），右边不出窗口
    final dx = math.min(math.max(32.0, margin - top.dx), screen.width - margin - width - top.dx);
    return CompositedTransformFollower(
      link: _link,
      showWhenUnlinked: false,
      targetAnchor: below ? Alignment.bottomLeft : Alignment.topLeft,
      followerAnchor: below ? Alignment.topLeft : Alignment.bottomLeft,
      offset: Offset(dx, below ? 2 : -2),
      child: Align(
        alignment: below ? Alignment.topLeft : Alignment.bottomLeft,
        child: IgnorePointer(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width,
              maxHeight: below ? screen.height - top.dy - box.size.height - margin : top.dy - margin,
            ),
            child: _HoverCard(record: widget.record, details: widget.details),
          ),
        ),
      ),
    );
  }
}

class _HoverCard extends StatelessWidget {
  const _HoverCard({required this.record, required this.details});

  final ClipRecord record;
  final RecordDetails details;

  /// 文字最多显示几行
  static const maxLines = 15;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final r = record;
    final Widget body;
    if (r.kind == ClipKind.CLIP_KIND_TEXT || r.kind == ClipKind.CLIP_KIND_HTML) {
      body = _TextBody(record: r, details: details);
    } else if (r.status != ClipStatus.CLIP_STATUS_READY) {
      body = _FileList(record: r, details: details, notReceived: r.status == ClipStatus.CLIP_STATUS_REMOTE_ONLY);
    } else if (r.imageCount > 0 && (r.kind == ClipKind.CLIP_KIND_IMAGE || r.items.length == 1)) {
      body = _ImageBody(record: r, details: details);
    } else {
      body = _FileList(record: r, details: details);
    }
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.all(Insets.md),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: p.border),
          boxShadow: const [BoxShadow(color: Color(0x26000000), blurRadius: 16, offset: Offset(0, 4))],
        ),
        child: body,
      ),
    );
  }
}

/// 最后一行：来源、完整的复制时间，以及大小或字数。
class _Footer extends StatelessWidget {
  const _Footer({required this.record, required this.extra});

  final ClipRecord record;
  final String? extra;

  @override
  Widget build(BuildContext context) {
    final t = recordTime(record);
    final hm = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    return Padding(
      padding: const EdgeInsets.only(top: Insets.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(height: 1, color: context.palette.border),
          const SizedBox(height: Insets.sm),
          Text(
            [recordSource(record), '${shortDate(t)} $hm', if (extra?.isNotEmpty ?? false) extra!].join(' · '),
            style: context.text.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _TextBody extends StatelessWidget {
  const _TextBody({required this.record, required this.details});

  final ClipRecord record;
  final RecordDetails details;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FutureBuilder<ClipDetail>(
      future: details.clipDetail(record.id),
      builder: (context, snap) {
        final d = snap.data;
        final text = d?.text ?? record.textPreview;
        final length = d?.textLength ?? text.runes.length;
        final lines = '\n'.allMatches(text).length + 1;
        final truncated = length > text.runes.length || lines > _HoverCard.maxLines;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Text(
                text,
                style: context.text.bodyMedium,
                maxLines: _HoverCard.maxLines,
                overflow: TextOverflow.fade,
              ),
            ),
            if (truncated)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(l.detailTruncated(length), style: context.text.bodySmall),
              ),
            _Footer(record: record, extra: l.detailChars(length)),
          ],
        );
      },
    );
  }
}

class _ImageBody extends StatefulWidget {
  const _ImageBody({required this.record, required this.details});

  final ClipRecord record;
  final RecordDetails details;

  @override
  State<_ImageBody> createState() => _ImageBodyState();
}

class _ImageBodyState extends State<_ImageBody> {
  late final Future<(String, Size?)> _image = _load();

  Future<(String, Size?)> _load() async {
    final path = (await widget.details.imagePreview(widget.record.id)).path;
    Size? size;
    try {
      // 只读文件头取尺寸，不解码整张图
      final buffer = await ui.ImmutableBuffer.fromFilePath(path);
      final desc = await ui.ImageDescriptor.encoded(buffer);
      size = Size(desc.width.toDouble(), desc.height.toDouble());
      desc.dispose();
      buffer.dispose();
    } catch (_) {}
    return (path, size);
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.record;
    return FutureBuilder<(String, Size?)>(
      future: _image,
      builder: (context, snap) {
        final data = snap.data;
        final size = data?.$2;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360, maxHeight: 240, minHeight: 60, minWidth: 120),
              child: data == null
                  ? const SizedBox(width: 120, height: 60)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(Radii.sm),
                      child: Image.file(
                        File(data.$1),
                        fit: BoxFit.contain,
                        cacheWidth: 720,
                        errorBuilder: (_, _, _) => const SizedBox(width: 120, height: 60),
                      ),
                    ),
            ),
            if (r.kind == ClipKind.CLIP_KIND_FILE)
              Padding(
                padding: const EdgeInsets.only(top: Insets.sm),
                child: Text(r.items.first.name, style: context.text.labelLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            _Footer(
              record: r,
              extra: [
                if (size != null) '${size.width.toInt()} × ${size.height.toInt()}',
                if (r.totalSize > 0) humanBytes(r.totalSize.toInt()),
              ].join(' · '),
            ),
          ],
        );
      },
    );
  }
}

class _FileList extends StatelessWidget {
  const _FileList({required this.record, required this.details, this.notReceived = false});

  final ClipRecord record;
  final RecordDetails details;
  final bool notReceived;

  static const maxItems = 10;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final r = record;
    final shown = r.items.take(maxItems).toList();
    return FutureBuilder<ClipDetail>(
      // 本机复制的文件显示所在的文件夹
      future: r.outgoing ? details.clipDetail(r.id) : null,
      builder: (context, snap) {
        final folder = _folderOf(snap.data?.sourcePaths ?? const []);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final it in shown)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(it.isDir ? '${it.name}/' : it.name,
                          style: context.text.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    if (it.size > 0 && !it.isDir) ...[
                      const SizedBox(width: Insets.md),
                      Text(humanBytes(it.size.toInt()), style: context.text.bodySmall),
                    ],
                  ],
                ),
              ),
            if (r.items.length > maxItems)
              Text(l.detailMoreFiles(r.items.length - maxItems), style: context.text.bodySmall),
            if (notReceived)
              Padding(
                padding: const EdgeInsets.only(top: Insets.xs),
                child: Text(l.detailReceiveFirst, style: context.text.bodySmall),
              ),
            _Footer(
              record: r,
              extra: [
                ?folder,
                if (r.totalSize > 0) l.detailTotalSize(humanBytes(r.totalSize.toInt())),
              ].join(' · '),
            ),
          ],
        );
      },
    );
  }

  /// 第一个文件所在的文件夹，用户目录写成 ~。
  static String? _folderOf(List<String> paths) {
    if (paths.isEmpty) return null;
    var dir = File(paths.first).parent.path;
    final home = Platform.environment[Platform.isWindows ? 'USERPROFILE' : 'HOME'];
    if (home != null && home.isNotEmpty && dir.startsWith(home)) dir = '~${dir.substring(home.length)}';
    return dir;
  }
}
