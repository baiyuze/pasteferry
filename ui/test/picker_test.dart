import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/picker/picker_host.dart';
import 'package:pasteferry_ui/picker/picker_state.dart';
import 'package:pasteferry_ui/picker/picker_view.dart';

const _channel = MethodChannel('pasteferry/picker');

// 快捷窗口的按键跟着平台走：Mac 上是 ⌘，Windows 与 Linux 上是 Ctrl（序号是 Alt+数字）
final _mac = Platform.isMacOS;
final _cmdKey = _mac ? LogicalKeyboardKey.metaLeft : LogicalKeyboardKey.controlLeft;

/// 不连后台服务：放进剪贴板、下载、收藏都记下来。
class _TestPicker extends PickerState {
  _TestPicker() : super(host: PickerHost(_channel));

  final applied = <(String, bool)>[];
  final fetched = <String>[];
  final favorited = <(String, bool)>[];
  final searches = <(String, PickerTab)>[];

  /// 后台服务对这些搜索词给出的结果（比如按拼音找到的）；不在这里的当作不支持搜索的旧版后台服务
  final answers = <String, List<ClipRecord>>{};

  @override
  Future<void> requestApply(String id, bool plain) async => applied.add((id, plain));

  @override
  Future<void> requestFetch(String id) async => fetched.add(id);

  @override
  Future<void> requestFavorite(String id, bool favorite) async => favorited.add((id, favorite));

  @override
  Future<ListHistoryResponse> requestSearch(String query, PickerTab tab) async {
    searches.add((query, tab));
    final found = answers[query];
    return found == null ? ListHistoryResponse(searched: false) : ListHistoryResponse(records: found, searched: true);
  }

  @override
  Future<ClipDetail> clipDetail(String clipId) async => ClipDetail(text: 'detail', textLength: 6);

  @override
  Future<GetImagePreviewResponse> imagePreview(String clipId, {int index = 0}) async => GetImagePreviewResponse();
}

final _now = Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000);

ClipRecord _text(String id, String text, {int ago = 0, bool link = false}) => ClipRecord(
      id: id,
      kind: ClipKind.CLIP_KIND_TEXT,
      status: ClipStatus.CLIP_STATUS_READY,
      textPreview: text,
      isLink: link,
      outgoing: true,
      createdAtUnix: _now - ago,
    );

final _records = [
  _text('a', '会议改到周四下午 3 点', ago: 1),
  _text('b', 'https://github.com/baiyuze/pasteferry', ago: 60, link: true),
  _text('c', 'docker compose up -d --build', ago: 3600),
  ClipRecord(
    id: 'big',
    kind: ClipKind.CLIP_KIND_FILE,
    status: ClipStatus.CLIP_STATUS_REMOTE_ONLY,
    originDeviceName: 'MacBook Air',
    items: [ClipItem(name: 'PasteFerry.dmg', size: Int64(812 << 20))],
    totalSize: Int64(812 << 20),
    createdAtUnix: _now - 7200,
  ),
];

final _favorite = _text('f1', '收货地址：上海市徐汇区', ago: 86400)
  ..favorite = true
  ..favoritedAtUnix = _now;

void main() {
  late List<MethodCall> calls;

  setUp(() {
    calls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(_channel, (c) async {
      calls.add(c);
      return switch (c.method) {
        'commit' => {'pasted': true, 'reason': ''},
        'pasteStatus' => {'available': true, 'reason': ''},
        _ => null,
      };
    });
  });

  Future<_TestPicker> open(WidgetTester tester, {Config? config, PasteStatus? paste, List<ClipRecord>? records}) async {
    final view = tester.view;
    view.physicalSize = const Size(560, 460);
    view.devicePixelRatio = 1;
    addTearDown(view.reset);
    final s = _TestPicker()
      ..debugSeed(
        config: config ?? Config(language: 'zh-Hans'),
        records: records ?? _records,
        favorites: [_favorite],
        paste: paste ?? const PasteStatus(available: true, reason: ''),
      );
    await tester.pumpWidget(PickerApp(state: s));
    await tester.pump();
    return s;
  }

  List<MethodCall> commits() => calls.where((c) => c.method == 'commit').toList();

  testWidgets('前 9 条标序号，按数字直接粘贴那一条', (tester) async {
    final s = await open(tester);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    // 「收藏」既是页签，也是底栏 ⌘D 的说明
    for (final t in ['全部', '文本', '链接', '图片', '文件', '收藏']) {
      expect(find.text(t), findsWidgets, reason: t);
    }

    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await tester.pump();
    expect(s.applied, [('b', false)]);
    expect(commits().single.arguments, {'paste': true});
  });

  testWidgets('模拟输入没有扫描码、认不出物理按键时，按逻辑按键认数字', (tester) async {
    final s = await open(tester);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.digit3, physicalKey: PhysicalKeyboardKey.keyQ);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.digit3, physicalKey: PhysicalKeyboardKey.keyQ);
    await tester.pump();
    expect(s.applied, [('c', false)]);
  });

  testWidgets('输入法收下数字键、只交来文字时（Windows 中文输入法），也按数字选那一行', (tester) async {
    final s = await open(tester);
    final field = tester.widget<TextField>(find.byType(TextField));
    field.controller!.value = const TextEditingValue(text: '２', selection: TextSelection.collapsed(offset: 1));
    await tester.pump();
    expect(s.applied, [('b', false)]);
    expect(field.controller!.text, '');
  });

  testWidgets('搜索时数字是打字，序号变成 ⌘1……', (tester) async {
    final s = await open(tester);
    await tester.enterText(find.byType(TextField), 'docker 2');
    await tester.pump();
    expect(s.applied, isEmpty);
    await tester.enterText(find.byType(TextField), 'docker');
    await tester.pump();
    expect(find.text(_mac ? '⌘1' : 'Alt+1'), findsOneWidget);
    expect(find.textContaining('docker compose'), findsOneWidget);
    expect(find.textContaining('会议'), findsNothing);
    // 停顿后在当前页签里搜全部历史
    await tester.pump(const Duration(milliseconds: 200));
    expect(s.searches.last, ('docker', PickerTab.all));
  });

  testWidgets('上下键移动选择，回车粘贴，⇧回车纯文本，⌘回车只复制', (tester) async {
    final s = await open(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(s.selected, 2);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(s.applied.last, ('c', false));
    expect(commits().last.arguments, {'paste': true});

    // 选中后会回到第一条
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pump();
    expect(s.applied.last, ('a', true));

    await tester.sendKeyDownEvent(_cmdKey);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyUpEvent(_cmdKey);
    await tester.pump();
    expect(commits().last.arguments, {'paste': false});
  });

  testWidgets('Tab 切换页签，「链接」只有网址，「收藏」里 ⌘D 是取消收藏', (tester) async {
    final s = await open(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(s.tab, PickerTab.link);
    expect(find.textContaining('github.com'), findsOneWidget);
    expect(find.textContaining('会议'), findsNothing);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pump();
    expect(s.tab, PickerTab.favorites);
    expect(find.textContaining('收货地址'), findsOneWidget);
    expect(find.textContaining('取消收藏（放回复制记录）'), findsOneWidget);

    await tester.sendKeyDownEvent(_cmdKey);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyD);
    await tester.sendKeyUpEvent(_cmdKey);
    await tester.pump();
    expect(s.favorited, [('f1', false)]);
  });

  testWidgets('Esc 先清空搜索，再按一次收起窗口', (tester) async {
    final s = await open(tester);
    await tester.enterText(find.byType(TextField), 'docker');
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(s.query, '');
    expect(calls.where((c) => c.method == 'hide'), isEmpty);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(calls.where((c) => c.method == 'hide'), hasLength(1));
  });

  testWidgets('设置里选了只复制：选中后不模拟粘贴，底栏写明要按 ⌘V', (tester) async {
    final s = await open(tester, config: Config(language: 'zh-Hans', quickPasteCopyOnly: true));
    expect(find.text('选中后按 ${_mac ? '⌘V' : 'Ctrl+V'} 粘贴'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.pump();
    expect(s.applied.single.$1, 'a');
    expect(commits().single.arguments, {'paste': false});
  });

  testWidgets('目标窗口以管理员身份运行（Windows）：底栏先说明要自己按粘贴键，设置页照样报能粘贴', (tester) async {
    final s = await open(tester, paste: const PasteStatus(available: true, reason: '', targetElevated: true));
    expect(find.text('这个窗口以管理员身份运行，选中后按 ${_mac ? '⌘V' : 'Ctrl+V'} 粘贴'), findsOneWidget);
    expect(s.canPaste, isTrue);
    expect(s.pasteBlockedReason, '');
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.pump();
    expect(s.applied.single.$1, 'a');
  });

  testWidgets('没授予辅助功能：底栏提示并给出授权按钮', (tester) async {
    await open(tester, paste: const PasteStatus(available: false, reason: 'not_trusted'));
    expect(find.textContaining('授予「辅助功能」权限后可直接粘贴'), findsOneWidget);
    await tester.tap(find.text('去授权'));
    await tester.pump();
    expect(calls.map((c) => c.method), contains('requestPermission'));
  });

  testWidgets('按拼音搜：只有后台服务找得到，结果回来之前列表接着显示上一次的结果，不闪「没有找到」', (tester) async {
    final s = await open(tester);
    s.answers['huiyi'] = [_records[0]];
    s.answers['huiyix'] = [];
    await tester.enterText(find.byType(TextField), 'huiyi');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump();
    expect(s.visible.map((r) => r.id), ['a']);
    expect(find.textContaining('会议改到周四'), findsOneWidget);

    // 多打一个字母：本地找不到，后台服务还没回话，列表不变
    await tester.enterText(find.byType(TextField), 'huiyix');
    await tester.pump();
    expect(s.visible.map((r) => r.id), ['a']);
    expect(find.textContaining('没有找到'), findsNothing);

    // 后台服务说没有，这才显示「没有找到」
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump();
    expect(s.visible, isEmpty);
    expect(find.textContaining('没有找到'), findsOneWidget);
  });

  group('滚动', () {
    final many = [for (var i = 0; i < 40; i++) _text('m$i', '第 $i 条', ago: i * 60)];

    ScrollPosition position(WidgetTester tester) =>
        tester.state<ScrollableState>(find.descendant(of: find.byType(ListView), matching: find.byType(Scrollable))).position;
    double offset(WidgetTester tester) => position(tester).pixels;

    testWidgets('用滚轮滚下去以后，缩略图、传输进度这类更新不会把列表拉回选中的那一行', (tester) async {
      final s = await open(tester, records: many);
      final pointer = TestPointer(1, PointerDeviceKind.mouse);
      // 鼠标停在列表上，选中的是鼠标下面那一行；滚轮往下滚时鼠标不动，选中的那一行滚出了视野
      await tester.sendEventToBinding(pointer.hover(tester.getCenter(find.byType(ListView))));
      await tester.pump();
      final selected = s.selected;
      await tester.sendEventToBinding(pointer.scroll(const Offset(0, 600)));
      await tester.pump();
      final scrolled = offset(tester);
      expect(scrolled, greaterThan(0));
      expect(s.selected, selected);

      // 后台服务发来的更新：传输进度、记录变化。滚动位置要留在原处
      s.debugEvent(Event(progress: TransferProgress(clipId: 'm30', transferred: Int64(1), total: Int64(2))));
      await tester.pump();
      s.debugEvent(Event(clipUpdated: many[25].deepCopy()..textPreview = '第 25 条（改过）'));
      await tester.pump();
      expect(offset(tester), scrolled);
    });

    testWidgets('用键盘上下移动时，选中的那一行仍然留在视野里', (tester) async {
      final s = await open(tester, records: many);
      for (var i = 0; i < 20; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      }
      await tester.pump();
      expect(s.selected, 20);
      final view = position(tester).viewportDimension;
      final top = 20 * PickerView.rowHeight;
      expect(offset(tester), lessThanOrEqualTo(top));
      expect(offset(tester) + view, greaterThanOrEqualTo(top + PickerView.rowHeight));

      // 换搜索词，列表回到最上面
      await tester.enterText(find.byType(TextField), '第');
      await tester.pump();
      expect(offset(tester), 0);
      await tester.pump(const Duration(milliseconds: 200)); // 等搜索的计时器走完
    });
  });

  testWidgets('没下载的大文件：先下载，下完放进剪贴板再粘贴', (tester) async {
    final s = await open(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit4);
    await tester.pump();
    expect(s.fetched, ['big']);
    expect(s.applied, isEmpty);
    expect(find.text('正在下载，下完自动粘贴'), findsOneWidget);

    s.debugEvent(Event(clipUpdated: _records[3].deepCopy()..status = ClipStatus.CLIP_STATUS_READY));
    await tester.pump();
    expect(s.applied, [('big', false)]);
    expect(commits().single.arguments, {'paste': true});
  });

  testWidgets('正在用输入法打字时，数字和回车交给输入法', (tester) async {
    final s = await open(tester);
    final field = tester.widget<TextField>(find.byType(TextField));
    field.controller!.value = const TextEditingValue(
      text: 'hui',
      selection: TextSelection.collapsed(offset: 3),
      composing: TextRange(start: 0, end: 3),
    );
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(s.applied, isEmpty);
    // 拼音不拿去搜，列表不变；选字上屏后才搜
    expect(s.query, '');
    expect(find.textContaining('docker compose'), findsOneWidget);
    field.controller!.value = const TextEditingValue(text: '会', selection: TextSelection.collapsed(offset: 1));
    await tester.pump();
    expect(s.query, '会');
    expect(find.textContaining('会议'), findsOneWidget);
    expect(find.textContaining('docker compose'), findsNothing);
    await tester.pump(const Duration(milliseconds: 200));
  });

  testWidgets('每次呼出都从「全部」、第一条、空搜索开始', (tester) async {
    final s = await open(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.enterText(find.byType(TextField), 'abc');
    await tester.pump();
    s.debugShow();
    await tester.pump();
    expect(s.tab, PickerTab.all);
    expect(s.query, '');
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, '');
  });
}
