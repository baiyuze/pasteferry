import 'package:flutter/widgets.dart';

import 'gen/pasteferry/v1/daemon.pb.dart';
import 'i18n.dart';
import 'icons.dart';
import 'widgets/common.dart';

/// 复制记录、收藏和快捷窗口共用的类型筛选：全部 · 文字 · 链接 · 图片 · 文件。
/// 见 design/quick-paste-and-favorites.md 第 5 节。
enum RecordFilter { all, text, link, image, file }

extension RecordFilterX on RecordFilter {
  bool matches(ClipRecord r) => switch (this) {
        RecordFilter.all => true,
        // 富文本也是文字，用户不关心它在剪贴板里是不是 HTML；整条是网址的归到「链接」
        RecordFilter.text =>
          (r.kind == ClipKind.CLIP_KIND_TEXT || r.kind == ClipKind.CLIP_KIND_HTML) && !r.isLink,
        RecordFilter.link => r.isLink,
        RecordFilter.image => r.kind == ClipKind.CLIP_KIND_IMAGE,
        RecordFilter.file => r.kind == ClipKind.CLIP_KIND_FILE,
      };

  String label(AppLocalizations l) => switch (this) {
        RecordFilter.all => l.filterAll,
        RecordFilter.text => l.filterText,
        RecordFilter.link => l.filterLink,
        RecordFilter.image => l.filterImage,
        RecordFilter.file => l.filterFile,
      };
}

/// 按内容类型区分的图标：只靠形状区分，不靠颜色。
IconData kindIcon(ClipRecord r) => switch (r.kind) {
      _ when r.isLink => AppIcons.link,
      ClipKind.CLIP_KIND_TEXT => AppIcons.textAlignLeft,
      ClipKind.CLIP_KIND_HTML => AppIcons.docRichtext,
      ClipKind.CLIP_KIND_IMAGE => AppIcons.photo,
      // 单张图片文件也用图片图标，一眼看出点开能预览
      ClipKind.CLIP_KIND_FILE when r.items.length == 1 && r.imageCount == 1 => AppIcons.photo,
      ClipKind.CLIP_KIND_FILE when r.items.length > 1 => AppIcons.docOnDoc,
      ClipKind.CLIP_KIND_FILE when r.items.isNotEmpty && r.items.first.isDir =>
        AppIcons.folder,
      ClipKind.CLIP_KIND_FILE => AppIcons.doc,
      _ => AppIcons.questionCircle,
    };

/// 记录在列表里的标题：起了别名的收藏显示别名，其他的见 [contentTitle]。
String recordTitle(ClipRecord r, {String? query}) =>
    hasAlias(r) ? r.alias : contentTitle(r, query: query);

/// 收藏起了别名。取消收藏后别名还留在后台服务里，只是不显示
bool hasAlias(ClipRecord r) => r.favorite && r.alias.isNotEmpty;

/// 按内容拼的标题。搜索时传入 [query]：一次复制了多个文件、搜到的又不是第一个时，
/// 标题改用搜到的那个文件名打头，看得出为什么搜到了它。
String contentTitle(ClipRecord r, {String? query}) {
  // 图片和文件的标题按当前界面语言拼：后台服务存下的摘要是写入时的中文，不会跟着换语言
  if (r.kind == ClipKind.CLIP_KIND_IMAGE) return appL10n.imageRecord;
  if (r.kind != ClipKind.CLIP_KIND_FILE && r.textPreview.isNotEmpty) {
    return r.textPreview.replaceAll('\n', ' ').trim();
  }
  if (r.items.isEmpty) return appL10n.emptyRecord;
  if (r.items.length == 1) return r.items.first.name;
  final q = query?.toLowerCase();
  final lead = q == null ? null : r.items.where((i) => i.name.toLowerCase().contains(q)).firstOrNull;
  return appL10n.itemsSummary((lead ?? r.items.first).name, r.items.length - 1, r.items.length);
}

/// 记录的来源：本机，或者「来自」哪台设备。
// 手机网页传输发来的内容也是本机发出的（会同步给其他设备），来源写手机的名字
String recordSource(ClipRecord r) => r.outgoing
    ? (r.viaName.isNotEmpty ? appL10n.fromDevice(r.viaName) : appL10n.thisDeviceShort)
    : appL10n.fromDevice(r.originDeviceName);

DateTime recordTime(ClipRecord r) => DateTime.fromMillisecondsSinceEpoch(r.createdAtUnix.toInt() * 1000);

DateTime favoritedTime(ClipRecord r) => DateTime.fromMillisecondsSinceEpoch(r.favoritedAtUnix.toInt() * 1000);

/// 列表里标题下面那一行：来源 · 大小 · 时间。收藏显示收藏时间；起了别名的，最前面是按内容拼的标题。
String recordMeta(ClipRecord r) => [
      if (hasAlias(r)) contentTitle(r),
      recordSource(r),
      if (r.totalSize > 0) humanBytes(r.totalSize.toInt()),
      r.favorite ? appL10n.favoritedAt(shortDate(favoritedTime(r))) : relativeTime(recordTime(r)),
    ].join(' · ');

/// 月日，今年以前的带上年份。
String shortDate(DateTime t, {DateTime? now}) {
  final n = now ?? DateTime.now();
  final md = appL10n.monthDay(t.month, t.day);
  return t.year == n.year ? md : '${t.year} $md';
}

/// 把 [text] 里所有不分大小写匹配 [query] 的片段套上 [mark] 样式。
/// 转小写后长度变了的少数字符（如土耳其语的 İ）对不上位置，这时不标。
List<TextSpan> highlightMatches(String text, String? query, TextStyle mark) {
  final lower = text.toLowerCase();
  final q = query?.toLowerCase() ?? '';
  if (q.isEmpty || lower.length != text.length) return [TextSpan(text: text)];
  final spans = <TextSpan>[];
  var start = 0;
  for (var i = lower.indexOf(q); i >= 0; i = lower.indexOf(q, start)) {
    if (i > start) spans.add(TextSpan(text: text.substring(start, i)));
    spans.add(TextSpan(text: text.substring(i, i + q.length), style: mark));
    start = i + q.length;
  }
  if (start < text.length) spans.add(TextSpan(text: text.substring(start)));
  return spans;
}
