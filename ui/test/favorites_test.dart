import 'package:fixnum/fixnum.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/main.dart';
import 'package:pasteferry_ui/widgets/record_hover.dart';

/// 不连后台服务：收藏与取消收藏按后台服务的规则在本地模拟，完整内容按测试给的回答。
class _FavState extends AppState {
  final calls = <(String, bool)>[];
  final detailCalls = <String>[];
  int _next = 0;

  @override
  Future<ClipRecord> setFavorite(String clipId, bool favorite) async {
    calls.add((clipId, favorite));
    final now = Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000);
    if (favorite) {
      final src = records.firstWhere((r) => r.id == clipId);
      final fav = src.deepCopy()
        ..id = 'fav-${_next++}'
        ..favorite = true
        ..favorited = false
        ..favoritedAtUnix = now + _next;
      debugEvent(Event(clipAdded: src.deepCopy()..favorited = true));
      debugEvent(Event(clipAdded: fav));
      return fav;
    }
    // 取消收藏：收藏放回复制记录的最上面，原记录合并掉
    final fav = favorites.firstWhere((r) => r.id == clipId || r.id == 'fav-of-$clipId', orElse: () => favorites.first);
    final back = fav.deepCopy()
      ..favorite = false
      ..favoritedAtUnix = Int64(0)
      ..createdAtUnix = now;
    for (final r in records.where((r) => r.favorited).toList()) {
      debugEvent(Event(clipRemoved: r.id));
    }
    debugEvent(Event(clipAdded: back));
    return back;
  }

  @override
  Future<ClipDetail> requestClipDetail(String clipId) async {
    detailCalls.add(clipId);
    return ClipDetail(text: 'SELECT o.id\nFROM orders o\nWHERE o.status = \'paid\';', textLength: 42);
  }
}

final _now = Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000);

final _text = ClipRecord(
  id: 'text',
  kind: ClipKind.CLIP_KIND_TEXT,
  status: ClipStatus.CLIP_STATUS_READY,
  textPreview: 'SELECT o.id FROM orders o WHERE o.status = …',
  outgoing: true,
  createdAtUnix: _now - 60,
);
final _link = ClipRecord(
  id: 'link',
  kind: ClipKind.CLIP_KIND_TEXT,
  status: ClipStatus.CLIP_STATUS_READY,
  textPreview: 'https://pasteferry.cc/download/',
  isLink: true,
  outgoing: true,
  createdAtUnix: _now - 120,
);
final _image = ClipRecord(
  id: 'image',
  kind: ClipKind.CLIP_KIND_IMAGE,
  status: ClipStatus.CLIP_STATUS_READY,
  originDeviceName: 'Windows PC',
  imageCount: 1,
  totalSize: Int64(1 << 20),
  createdAtUnix: _now - 180,
);

_FavState _seed({List<ClipRecord> favorites = const []}) => _FavState()
  ..debugSeed(
    status: Status(signalingConnected: true, version: '2.4.0'),
    config: Config(language: 'zh-Hans', historyTtlSeconds: Int64(3 * 86400)),
    self: Device(id: 'self', name: 'MacBook Pro'),
    records: [_text, _link, _image],
    favorites: favorites,
  );

Future<TestGesture> _hover(WidgetTester tester, Finder target) async {
  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await gesture.moveTo(tester.getCenter(target));
  await tester.pump();
  // 鼠标在行里动一下才开始计时
  await gesture.moveTo(tester.getCenter(target) + const Offset(4, 0));
  await tester.pump();
  return gesture;
}

void main() {
  testWidgets('「链接」只列出整条是网址的记录，「文本」里不再有它', (tester) async {
    await tester.pumpWidget(PasteFerryApp(state: _seed()));
    await tester.pump();
    await tester.tap(find.text('链接'));
    await tester.pump();
    expect(find.text('https://pasteferry.cc/download/'), findsOneWidget);
    expect(find.textContaining('SELECT'), findsNothing);

    await tester.tap(find.text('文本'));
    await tester.pump();
    expect(find.textContaining('SELECT'), findsOneWidget);
    expect(find.text('https://pasteferry.cc/download/'), findsNothing);
  });

  testWidgets('点星标收藏：出现在收藏页，原记录的星标一直亮着', (tester) async {
    final state = _seed();
    await tester.pumpWidget(PasteFerryApp(state: state));
    await tester.pump();

    await _hover(tester, find.textContaining('SELECT'));
    await tester.tap(find.byTooltip('收藏').first);
    await tester.pump();
    expect(state.calls, [('text', true)]);
    expect(find.text('已收藏'), findsOneWidget);
    expect(state.records.firstWhere((r) => r.id == 'text').favorited, isTrue);
    expect(state.favorites.single.textPreview, _text.textPreview);

    // 鼠标移开，亮着的星标还在
    await tester.tap(find.text('收藏').first); // 侧边栏
    await tester.pumpAndSettle();
    expect(find.textContaining('SELECT'), findsOneWidget);
    expect(find.textContaining('不会被自动清理'), findsOneWidget);
    expect(find.byTooltip('取消收藏'), findsOneWidget);
  });

  testWidgets('在收藏页取消收藏：放回复制记录，可以撤销', (tester) async {
    final fav = _text.deepCopy()
      ..id = 'fav-of-text'
      ..favorite = true
      ..favoritedAtUnix = _now;
    final state = _seed(favorites: [fav]);
    await tester.pumpWidget(PasteFerryApp(state: state));
    await tester.pump();
    await tester.tap(find.text('收藏').first);
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('取消收藏'));
    await tester.pump();
    expect(state.calls.last, ('fav-of-text', false));
    expect(state.favorites, isEmpty);
    expect(state.records.first.id, 'fav-of-text');
    expect(find.text('已放回复制记录'), findsOneWidget);
    expect(find.text('还没有收藏'), findsOneWidget);
    // 收藏里没有删除
    expect(find.byTooltip('删除这条记录'), findsNothing);

    await tester.pump(const Duration(milliseconds: 500)); // 提示条滑进来
    await tester.tap(find.text('撤销'));
    await tester.pump();
    expect(state.calls.last, ('fav-of-text', true));
  });

  testWidgets('鼠标停一会儿显示完整内容，移开就消失', (tester) async {
    final state = _seed();
    await tester.pumpWidget(PasteFerryApp(state: state));
    await tester.pump();

    // 列表里的预览没有 'paid'，只有完整内容里有
    final gesture = await _hover(tester, find.textContaining('SELECT'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.textContaining("'paid'"), findsNothing, reason: '还没到时间');
    await tester.pump(RecordHover.delay);
    await tester.pump();
    expect(find.textContaining("'paid'"), findsOneWidget);
    expect(state.detailCalls, ['text']);
    expect(find.textContaining('42 字'), findsOneWidget);

    await gesture.moveTo(const Offset(5, 5));
    await tester.pump();
    expect(find.textContaining("'paid'"), findsNothing);
  });

  testWidgets('清空记录时说明收藏会保留', (tester) async {
    final fav = _text.deepCopy()
      ..id = 'fav'
      ..favorite = true;
    await tester.pumpWidget(PasteFerryApp(state: _seed(favorites: [fav])));
    await tester.pump();
    await tester.tap(find.byTooltip('清空记录'));
    await tester.pumpAndSettle();
    expect(find.textContaining('已收藏的 1 条会保留'), findsOneWidget);
  });

  test('事件按 favorite 分到复制记录或收藏，取消收藏的同一条换过去', () {
    final state = _seed();
    final fav = _image.deepCopy()
      ..id = 'f1'
      ..favorite = true
      ..favoritedAtUnix = _now;
    state.debugEvent(Event(clipAdded: fav));
    expect(state.favorites.map((r) => r.id), ['f1']);
    expect(state.records.map((r) => r.id), isNot(contains('f1')));

    state.debugEvent(Event(clipAdded: fav.deepCopy()
      ..favorite = false
      ..createdAtUnix = _now + 10));
    expect(state.favorites, isEmpty);
    expect(state.records.first.id, 'f1', reason: '取消收藏后在复制记录的最上面');

    state.debugEvent(Event(clipRemoved: 'f1'));
    expect(state.records.map((r) => r.id), isNot(contains('f1')));
  });
}
