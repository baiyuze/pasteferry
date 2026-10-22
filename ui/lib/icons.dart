import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

/// 界面用到的图标：Mac 上是 Cupertino 图标，Windows 上是微软的 Fluent 图标，
/// 各自与系统自带的应用一致。Linux 上用 Fluent：线条风格与 GNOME、KDE 的图标接近。
abstract final class AppIcons {
  static final bool _win = !Platform.isMacOS;

  static IconData _pick(IconData mac, IconData windows) => _win ? windows : mac;

  static IconData get clock => _pick(CupertinoIcons.clock, FluentIcons.history_24_regular);
  static IconData get deviceLaptop => _pick(CupertinoIcons.device_laptop, FluentIcons.laptop_24_regular);
  static IconData get desktopComputer => _pick(CupertinoIcons.desktopcomputer, FluentIcons.desktop_24_regular);
  static IconData get gear => _pick(CupertinoIcons.gear, FluentIcons.settings_24_regular);
  static IconData get exclamationmarkCircle =>
      _pick(CupertinoIcons.exclamationmark_circle, FluentIcons.error_circle_24_regular);
  static IconData get trash => _pick(CupertinoIcons.trash, FluentIcons.delete_24_regular);
  static IconData get checkmark => _pick(CupertinoIcons.checkmark, FluentIcons.checkmark_24_regular);
  static IconData get checkmarkCircle =>
      _pick(CupertinoIcons.checkmark_circle, FluentIcons.checkmark_circle_24_regular);
  static IconData get xmark => _pick(CupertinoIcons.xmark, FluentIcons.dismiss_24_regular);
  static IconData get search => _pick(CupertinoIcons.search, FluentIcons.search_24_regular);
  static IconData get arrowDownCircle =>
      _pick(CupertinoIcons.arrow_down_circle, FluentIcons.arrow_circle_down_24_regular);
  static IconData get pencil => _pick(CupertinoIcons.pencil, FluentIcons.edit_24_regular);
  static IconData get arrowClockwise =>
      _pick(CupertinoIcons.arrow_clockwise, FluentIcons.arrow_clockwise_24_regular);
  // 搜索框里的清除按钮：实心圆里一个叉，与系统的搜索框一致
  static IconData get clearField =>
      _pick(CupertinoIcons.xmark_circle_fill, FluentIcons.dismiss_circle_20_filled);
  static IconData get textAlignLeft =>
      _pick(CupertinoIcons.text_alignleft, FluentIcons.text_align_left_24_regular);
  static IconData get questionCircle =>
      _pick(CupertinoIcons.question_circle, FluentIcons.question_circle_24_regular);
  static IconData get plus => _pick(CupertinoIcons.plus, FluentIcons.add_24_regular);
  static IconData get radar =>
      _pick(CupertinoIcons.dot_radiowaves_left_right, FluentIcons.radar_20_regular);
  static IconData get photo => _pick(CupertinoIcons.photo, FluentIcons.image_24_regular);
  static IconData get lockShield => _pick(CupertinoIcons.lock_shield, FluentIcons.shield_lock_24_regular);
  static IconData get filter =>
      _pick(CupertinoIcons.line_horizontal_3_decrease, FluentIcons.filter_24_regular);
  static IconData get folder => _pick(CupertinoIcons.folder, FluentIcons.folder_24_regular);
  static IconData get ellipsis => _pick(CupertinoIcons.ellipsis, FluentIcons.more_horizontal_24_regular);
  static IconData get docRichtext =>
      _pick(CupertinoIcons.doc_richtext, FluentIcons.document_text_24_regular);
  static IconData get docOnDoc => _pick(CupertinoIcons.doc_on_doc, FluentIcons.copy_24_regular);
  static IconData get docOnClipboard =>
      _pick(CupertinoIcons.doc_on_clipboard, FluentIcons.clipboard_paste_24_regular);
  static IconData get doc => _pick(CupertinoIcons.doc, FluentIcons.document_24_regular);
  static IconData get chevronLeft => _pick(CupertinoIcons.chevron_left, FluentIcons.chevron_left_24_regular);
  static IconData get chevronRight => _pick(CupertinoIcons.chevron_right, FluentIcons.chevron_right_24_regular);
  static IconData get chevronUpDown =>
      _pick(CupertinoIcons.chevron_up_chevron_down, FluentIcons.chevron_up_down_24_regular);
  static IconData get link => _pick(CupertinoIcons.link, FluentIcons.link_24_regular);
  static IconData get star => _pick(CupertinoIcons.star, FluentIcons.star_24_regular);
  static IconData get starFill => _pick(CupertinoIcons.star_fill, FluentIcons.star_24_filled);
  static IconData get keyboard => _pick(CupertinoIcons.keyboard, FluentIcons.keyboard_24_regular);
  // 回车键：快捷窗口底栏的按键提示里用。字符 ↩ 在 Mac 上会被画成彩色 emoji，所以用图标
  // 隔空传送：侧边栏的纸飞机，列表里收到（向下）与发出（向上）
  static IconData get send => _pick(CupertinoIcons.paperplane, FluentIcons.send_24_regular);
  static IconData get arrowDown => _pick(CupertinoIcons.arrow_down, FluentIcons.arrow_down_24_regular);
  static IconData get arrowUp => _pick(CupertinoIcons.arrow_up, FluentIcons.arrow_up_24_regular);
  static IconData get returnKey => _pick(CupertinoIcons.return_icon, FluentIcons.arrow_enter_left_20_regular);
}
