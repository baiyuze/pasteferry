import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

/// 界面用到的图标：Mac 上是 Cupertino 图标，Windows 上是微软的 Fluent 图标，
/// 各自与系统自带的应用一致。Linux 上用 Fluent：线条风格与 GNOME、KDE 的图标接近。
abstract final class AppIcons {
  static final bool _win = !Platform.isMacOS;

  /// 当前主题用像素图标（[AppThemeSpec.pixelIcons]）。界面最外层按主题设置，换主题时整个界面重建
  static bool pixel = false;

  static IconData _pick(IconData mac, IconData windows, IconData pixelIcon) =>
      pixel ? pixelIcon : (_win ? windows : mac);

  static IconData get clock => _pick(CupertinoIcons.clock, FluentIcons.history_24_regular, PixelIcons.clock);
  static IconData get deviceLaptop => _pick(CupertinoIcons.device_laptop, FluentIcons.laptop_24_regular, PixelIcons.laptop);
  static IconData get desktopComputer => _pick(CupertinoIcons.desktopcomputer, FluentIcons.desktop_24_regular, PixelIcons.monitor);
  static IconData get gear => _pick(CupertinoIcons.gear, FluentIcons.settings_24_regular, PixelIcons.gear);
  static IconData get exclamationmarkCircle =>
      _pick(CupertinoIcons.exclamationmark_circle, FluentIcons.error_circle_24_regular, PixelIcons.warningDiamond);
  static IconData get trash => _pick(CupertinoIcons.trash, FluentIcons.delete_24_regular, PixelIcons.trash);
  static IconData get checkmark => _pick(CupertinoIcons.checkmark, FluentIcons.checkmark_24_regular, PixelIcons.check);
  static IconData get checkmarkCircle =>
      _pick(CupertinoIcons.checkmark_circle, FluentIcons.checkmark_circle_24_regular, PixelIcons.checkboxOn);
  static IconData get xmark => _pick(CupertinoIcons.xmark, FluentIcons.dismiss_24_regular, PixelIcons.close);
  static IconData get search => _pick(CupertinoIcons.search, FluentIcons.search_24_regular, PixelIcons.search);
  static IconData get arrowDownCircle =>
      _pick(CupertinoIcons.arrow_down_circle, FluentIcons.arrow_circle_down_24_regular, PixelIcons.arrowDownCircle);
  static IconData get pencil => _pick(CupertinoIcons.pencil, FluentIcons.edit_24_regular, PixelIcons.pencil);
  static IconData get arrowClockwise =>
      _pick(CupertinoIcons.arrow_clockwise, FluentIcons.arrow_clockwise_24_regular, PixelIcons.reload);
  // 搜索框里的清除按钮：实心圆里一个叉，与系统的搜索框一致
  static IconData get clearField =>
      _pick(CupertinoIcons.xmark_circle_fill, FluentIcons.dismiss_circle_20_filled, PixelIcons.xSolid);
  static IconData get textAlignLeft =>
      _pick(CupertinoIcons.text_alignleft, FluentIcons.text_align_left_24_regular, PixelIcons.textAlignLeft);
  static IconData get questionCircle =>
      _pick(CupertinoIcons.question_circle, FluentIcons.question_circle_24_regular, PixelIcons.circleQuestion);
  static IconData get plus => _pick(CupertinoIcons.plus, FluentIcons.add_24_regular, PixelIcons.plus);
  static IconData get radar =>
      _pick(CupertinoIcons.dot_radiowaves_left_right, FluentIcons.radar_20_regular, PixelIcons.target);
  static IconData get photo => _pick(CupertinoIcons.photo, FluentIcons.image_24_regular, PixelIcons.image);
  static IconData get lockShield => _pick(CupertinoIcons.lock_shield, FluentIcons.shield_lock_24_regular, PixelIcons.shield);
  static IconData get filter =>
      _pick(CupertinoIcons.line_horizontal_3_decrease, FluentIcons.filter_24_regular, PixelIcons.filter);
  static IconData get folder => _pick(CupertinoIcons.folder, FluentIcons.folder_24_regular, PixelIcons.folder);
  static IconData get ellipsis => _pick(CupertinoIcons.ellipsis, FluentIcons.more_horizontal_24_regular, PixelIcons.moreHorizontal);
  static IconData get docRichtext =>
      _pick(CupertinoIcons.doc_richtext, FluentIcons.document_text_24_regular, PixelIcons.article);
  static IconData get docOnDoc => _pick(CupertinoIcons.doc_on_doc, FluentIcons.copy_24_regular, PixelIcons.files);
  static IconData get docOnClipboard =>
      _pick(CupertinoIcons.doc_on_clipboard, FluentIcons.clipboard_paste_24_regular, PixelIcons.clipboardNote);
  static IconData get doc => _pick(CupertinoIcons.doc, FluentIcons.document_24_regular, PixelIcons.file);
  static IconData get chevronLeft => _pick(CupertinoIcons.chevron_left, FluentIcons.chevron_left_24_regular, PixelIcons.chevronLeft);
  static IconData get chevronRight => _pick(CupertinoIcons.chevron_right, FluentIcons.chevron_right_24_regular, PixelIcons.chevronRight);
  static IconData get chevronDown => _pick(CupertinoIcons.chevron_down, FluentIcons.chevron_down_24_regular, PixelIcons.chevronDown);
  static IconData get person => _pick(CupertinoIcons.person, FluentIcons.person_24_regular, PixelIcons.user);
  static IconData get people => _pick(CupertinoIcons.person_2, FluentIcons.people_24_regular, PixelIcons.users);
  static IconData get personAdd => _pick(CupertinoIcons.person_badge_plus, FluentIcons.person_add_24_regular, PixelIcons.userPlus);
  static IconData get chevronUpDown =>
      _pick(CupertinoIcons.chevron_up_chevron_down, FluentIcons.chevron_up_down_24_regular, PixelIcons.chevronsVertical);
  static IconData get link => _pick(CupertinoIcons.link, FluentIcons.link_24_regular, PixelIcons.link);
  // 设置首页各类别
  static IconData get globe => _pick(CupertinoIcons.globe, FluentIcons.globe_24_regular, PixelIcons.globe);
  static IconData get sync => _pick(CupertinoIcons.arrow_2_circlepath, FluentIcons.arrow_sync_24_regular, PixelIcons.refresh);
  static IconData get archive => _pick(CupertinoIcons.archivebox, FluentIcons.archive_24_regular, PixelIcons.archive);
  static IconData get info => _pick(CupertinoIcons.info_circle, FluentIcons.info_24_regular, PixelIcons.circleInfo);
  static IconData get star => _pick(CupertinoIcons.star, FluentIcons.star_24_regular, PixelIcons.star);
  static IconData get starFill => _pick(CupertinoIcons.star_fill, FluentIcons.star_24_filled, PixelIcons.star);
  static IconData get keyboard => _pick(CupertinoIcons.keyboard, FluentIcons.keyboard_24_regular, PixelIcons.keyboard);
  // 回车键：快捷窗口底栏的按键提示里用。字符 ↩ 在 Mac 上会被画成彩色 emoji，所以用图标
  // 隔空传送：侧边栏的纸飞机，列表里收到（向下）与发出（向上）
  static IconData get send => _pick(CupertinoIcons.paperplane, FluentIcons.send_24_regular, PixelIcons.send);
  static IconData get arrowDown => _pick(CupertinoIcons.arrow_down, FluentIcons.arrow_down_24_regular, PixelIcons.arrowDown);
  static IconData get arrowUp => _pick(CupertinoIcons.arrow_up, FluentIcons.arrow_up_24_regular, PixelIcons.arrowUp);
  static IconData get returnKey => _pick(CupertinoIcons.return_icon, FluentIcons.arrow_enter_left_20_regular, PixelIcons.cornerDownLeft);
  // 手机网页传输
  static IconData get phone => _pick(CupertinoIcons.device_phone_portrait, FluentIcons.phone_24_regular, PixelIcons.smartphone);
  static IconData get qrCode => _pick(CupertinoIcons.qrcode, FluentIcons.qr_code_24_regular, PixelIcons.qrCode);
  // Android App
  static IconData get copy => _pick(CupertinoIcons.doc_on_doc, FluentIcons.copy_24_regular, PixelIcons.copy);
  static IconData get share => _pick(CupertinoIcons.share, FluentIcons.share_android_24_regular, PixelIcons.share);
  static IconData get download => _pick(CupertinoIcons.arrow_down_to_line, FluentIcons.arrow_download_24_regular, PixelIcons.download);
  // 设置里的「外观」
  static IconData get paint =>
      _pick(CupertinoIcons.paintbrush, FluentIcons.paint_brush_24_regular, PixelIcons.brush);
  // 侧边栏的「服务」：两个平台都用 Material 的云
  static IconData get cloud => pixel ? PixelIcons.cloud : Icons.cloud_outlined;
  static IconData get wifiOff => _pick(CupertinoIcons.wifi_slash, FluentIcons.wifi_off_24_regular, PixelIcons.cellularSignal0);
}

/// 像素主题的图标：Pixelarticons（MIT），由 tools/pixel-theme/build_assets.py 挑出界面用到的几十个，
/// 缩放到 16px 时一格正好一个逻辑像素。
abstract final class PixelIcons {
  static const _family = 'PixelIcons';

  static const archive = IconData(0xea58, fontFamily: _family);
  static const arrowDown = IconData(0xea6d, fontFamily: _family);
  static const arrowDownCircle = IconData(0xea67, fontFamily: _family);
  static const arrowUp = IconData(0xea7a, fontFamily: _family);
  static const article = IconData(0xea7e, fontFamily: _family);
  static const cellularSignal0 = IconData(0xeafa, fontFamily: _family);
  static const check = IconData(0xeb0a, fontFamily: _family);
  static const checkboxOn = IconData(0xeb0c, fontFamily: _family);
  static const chevronDown = IconData(0xeb12, fontFamily: _family);
  static const chevronLeft = IconData(0xeb14, fontFamily: _family);
  static const chevronRight = IconData(0xeb16, fontFamily: _family);
  static const chevronsVertical = IconData(0xeb1c, fontFamily: _family);
  static const circleInfo = IconData(0xeb20, fontFamily: _family);
  static const circleQuestion = IconData(0xeb24, fontFamily: _family);
  static const clipboardNote = IconData(0xeb2c, fontFamily: _family);
  static const clock = IconData(0xeb2f, fontFamily: _family);
  static const brush = IconData(0xead5, fontFamily: _family);
  static const close = IconData(0xeb30, fontFamily: _family);
  static const cloud = IconData(0xeb34, fontFamily: _family);
  static const copy = IconData(0xeb49, fontFamily: _family);
  static const cornerDownLeft = IconData(0xeb4b, fontFamily: _family);
  static const download = IconData(0xeb7f, fontFamily: _family);
  static const file = IconData(0xeb9a, fontFamily: _family);
  static const files = IconData(0xeb9c, fontFamily: _family);
  static const filter = IconData(0xeb9d, fontFamily: _family);
  static const folder = IconData(0xebad, fontFamily: _family);
  static const gear = IconData(0xebb7, fontFamily: _family);
  static const globe = IconData(0xebc6, fontFamily: _family);
  static const image = IconData(0xebfb, fontFamily: _family);
  static const keyboard = IconData(0xec15, fontFamily: _family);
  static const laptop = IconData(0xec1e, fontFamily: _family);
  static const link = IconData(0xec5f, fontFamily: _family);
  static const monitor = IconData(0xeca0, fontFamily: _family);
  static const moreHorizontal = IconData(0xeca3, fontFamily: _family);
  static const pencil = IconData(0xecc5, fontFamily: _family);
  static const plus = IconData(0xecd8, fontFamily: _family);
  static const qrCode = IconData(0xece9, fontFamily: _family);
  static const refresh = IconData(0xecf8, fontFamily: _family);
  static const reload = IconData(0xecfa, fontFamily: _family);
  static const search = IconData(0xed18, fontFamily: _family);
  static const send = IconData(0xed1e, fontFamily: _family);
  static const share = IconData(0xed27, fontFamily: _family);
  static const shield = IconData(0xed29, fontFamily: _family);
  static const smartphone = IconData(0xed41, fontFamily: _family);
  static const star = IconData(0xed6d, fontFamily: _family);
  static const target = IconData(0xed8a, fontFamily: _family);
  static const textAlignLeft = IconData(0xeda0, fontFamily: _family);
  static const trash = IconData(0xedbe, fontFamily: _family);
  static const user = IconData(0xeddf, fontFamily: _family);
  static const userPlus = IconData(0xeddb, fontFamily: _family);
  static const users = IconData(0xede1, fontFamily: _family);
  static const warningDiamond = IconData(0xedf6, fontFamily: _family);
  static const xSolid = IconData(0xee05, fontFamily: _family);
}
