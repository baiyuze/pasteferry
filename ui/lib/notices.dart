import 'l10n/app_localizations.dart';

/// 后台推来的小提示（`Event.notice`）翻译成给用户看的一句话。
///
/// 后台只发固定代码（见手机端与桌面端的 `sync.NoticeClipboardFilesUnreadable`），
/// 文案在各语言的 arb 里，界面自己翻译。不认识的代码返回 null，界面就不提示。
String? noticeText(AppLocalizations l, String kind) {
  return switch (kind) {
    'clipboard_files_unreadable' => l.noticeFilesUnreadable,
    _ => null,
  };
}
