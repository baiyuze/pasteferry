import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/mobile/mobile_app.dart';
import 'package:pasteferry_ui/mobile/ui.dart';

Int64 _ago(int seconds) => Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000 - seconds);

/// 记下手机界面调了哪些操作，不连 Go 核心
class _PhoneState extends AppState {
  final submitted = <String>[];
  final applied = <String>[];

  @override
  Future<ClipRecord> submitText(String text) async {
    submitted.add(text);
    return ClipRecord(id: 'new', kind: ClipKind.CLIP_KIND_TEXT, outgoing: true, textPreview: text);
  }

  @override
  Future<void> applyToClipboard(String clipId) async => applied.add(clipId);
}

_PhoneState _demo({bool online = true, List<ClipRecord> records = const []}) {
  final state = _PhoneState();
  state.debugSeed(
    status: Status(version: '2.7.0'),
    config: Config(language: 'zh-Hans', deviceName: 'Pixel 8', autoApplyToClipboard: true),
    self: Device(id: 'self', name: 'Pixel 8', platform: 'android'),
    peers: [Device(id: 'mac', name: 'MacBook', platform: 'darwin', online: online)],
    records: records,
  );
  return state;
}

final _text = ClipRecord(
  id: 't1',
  kind: ClipKind.CLIP_KIND_TEXT,
  status: ClipStatus.CLIP_STATUS_READY,
  originDeviceName: 'MacBook',
  textPreview: '会议改到下午三点',
  createdAtUnix: _ago(60),
);

final _bigFile = ClipRecord(
  id: 'f1',
  kind: ClipKind.CLIP_KIND_FILE,
  status: ClipStatus.CLIP_STATUS_REMOTE_ONLY,
  originDeviceName: 'MacBook',
  items: [ClipItem(name: '演示视频.mov', size: Int64(80 << 20))],
  totalSize: Int64(80 << 20),
  createdAtUnix: _ago(120),
);

Future<void> _pump(WidgetTester tester, AppState state) async {
  tester.view.physicalSize = const Size(412 * 3, 915 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MobileApp(state: state));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('底部四个标签，默认是记录', (tester) async {
    await _pump(tester, _demo(records: [_text]));
    expect(find.byType(MobileTabBar), findsOneWidget);
    for (final label in ['记录', '发送', '设备', '设置']) {
      expect(find.descendant(of: find.byType(MobileTabBar), matching: find.text(label)), findsOneWidget);
    }
    expect(find.text('会议改到下午三点'), findsOneWidget);
  });

  testWidgets('记录上的「复制」写手机剪贴板；文字记录没有保存和分享', (tester) async {
    final state = _demo(records: [_text]);
    await _pump(tester, state);
    await tester.tap(find.widgetWithText(TextButton, '复制'));
    await tester.pump();
    expect(state.applied, ['t1']);
    await tester.pump(const Duration(seconds: 4));

    await tester.tap(find.text('会议改到下午三点'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(FilledButton, '复制'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '保存'), findsNothing);
    expect(find.widgetWithText(FilledButton, '分享'), findsNothing);
  });

  testWidgets('没下载的文件标出来，详情里有复制、保存、分享', (tester) async {
    await _pump(tester, _demo(records: [_bigFile]));
    expect(find.textContaining('还没下载'), findsOneWidget);
    await tester.tap(find.text('演示视频.mov'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(FilledButton, '复制'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '保存'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '分享'), findsOneWidget);
    expect(find.textContaining('点「复制」「保存」「分享」时会先下载。'), findsOneWidget);
  });

  testWidgets('发送页：有在线设备、输入了文字才能发；发出后清空', (tester) async {
    final state = _demo();
    await _pump(tester, state);
    await tester.tap(find.descendant(of: find.byType(MobileTabBar), matching: find.text('发送')));
    await tester.pumpAndSettle();

    FilledButton send() => tester.widget<FilledButton>(find.widgetWithText(FilledButton, '发送'));
    expect(send().onPressed, isNull);
    expect(find.text('将发给 MacBook'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '手机上写的一段话');
    await tester.pump();
    expect(send().onPressed, isNotNull);
    await tester.tap(find.widgetWithText(FilledButton, '发送'));
    await tester.pump();
    expect(state.submitted, ['手机上写的一段话']);
    expect(find.text('手机上写的一段话'), findsNothing);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('发送页：没有在线设备时不能发', (tester) async {
    await _pump(tester, _demo(online: false));
    await tester.tap(find.descendant(of: find.byType(MobileTabBar), matching: find.text('发送')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '你好');
    await tester.pump();
    expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, '发送')).onPressed, isNull);
    expect(find.text('附近没有在线的设备'), findsWidgets);
  });

  testWidgets('设备页列出已配对的设备，有添加设备和搜索附近设备', (tester) async {
    await _pump(tester, _demo());
    await tester.tap(find.descendant(of: find.byType(MobileTabBar), matching: find.text('设备')));
    await tester.pumpAndSettle();
    expect(find.text('MacBook'), findsWidgets);
    expect(find.text('添加设备'), findsOneWidget);
    expect(find.text('搜索附近设备'), findsOneWidget);
  });
}
