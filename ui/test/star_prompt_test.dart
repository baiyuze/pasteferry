import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:flutter/material.dart';
import 'package:pasteferry_ui/main.dart';
import 'package:pasteferry_ui/mobile/mobile_app.dart';
import 'package:pasteferry_ui/star_prompt.dart';
import 'package:pasteferry_ui/widgets/star_banner.dart';

void main() {
  var now = DateTime(2026, 11, 1, 9);
  DateTime clock() => now;

  setUp(() => now = DateTime(2026, 11, 1, 9));

  Future<StarPrompt> ready({int syncs = StarPrompt.minSyncs}) async {
    final p = StarPrompt.memory(now: clock);
    await p.load();
    for (var i = 0; i < syncs; i++) {
      p.recordSync();
    }
    return p;
  }

  group('什么时候出现', () {
    test('同步够了但不满 3 天不出现，满 3 天出现', () async {
      final p = await ready();
      expect(p.visible, isFalse);
      now = now.add(const Duration(days: 3));
      expect(p.visible, isTrue);
    });

    test('满 3 天但同步不到 20 条不出现', () async {
      final p = await ready(syncs: StarPrompt.minSyncs - 1);
      now = now.add(const Duration(days: 30));
      expect(p.visible, isFalse);
      p.recordSync();
      expect(p.visible, isTrue);
    });

    test('「以后再说」隔 7 天再出现一次，第二次就不再出现', () async {
      final p = await ready();
      now = now.add(const Duration(days: 3));
      p.later();
      expect(p.visible, isFalse);
      now = now.add(const Duration(days: 6));
      expect(p.visible, isFalse);
      now = now.add(const Duration(days: 1));
      expect(p.visible, isTrue);
      p.later();
      expect(p.done, isTrue);
      now = now.add(const Duration(days: 365));
      expect(p.visible, isFalse);
    });

    test('「去点 Star」与「×」之后不再出现', () async {
      for (final act in [(StarPrompt p) => p.starred(), (StarPrompt p) => p.dismiss()]) {
        final p = await ready();
        now = now.add(const Duration(days: 3));
        act(p);
        expect(p.visible, isFalse);
        now = now.add(const Duration(days: 365));
        expect(p.visible, isFalse);
        now = DateTime(2026, 11, 1, 9);
      }
    });
  });

  test('状态存在本地文件里，重开 App 还在', () async {
    final dir = await Directory.systemTemp.createTemp('star-prompt');
    addTearDown(() => dir.delete(recursive: true));
    final path = '${dir.path}/sub/star-prompt.json';

    final a = StarPrompt(path: path, now: clock);
    await a.load();
    for (var i = 0; i < StarPrompt.minSyncs; i++) {
      a.recordSync();
    }
    now = now.add(const Duration(days: 3));
    a.later();
    await a.flushed();

    final b = StarPrompt(path: path, now: clock);
    await b.load();
    expect(b.syncs, StarPrompt.minSyncs);
    expect(b.visible, isFalse);
    now = now.add(const Duration(days: 7));
    expect(b.visible, isTrue);
  });

  group('同步计数', () {
    ClipRecord clip(String id, {bool outgoing = false, bool favorite = false}) => ClipRecord(
      id: id,
      kind: ClipKind.CLIP_KIND_TEXT,
      status: ClipStatus.CLIP_STATUS_READY,
      outgoing: outgoing,
      favorite: favorite,
      textPreview: id,
    );

    Future<AppState> seeded({bool peerOnline = true}) async {
      final s = AppState(starPrompt: StarPrompt.memory(now: clock));
      await s.starPrompt.load();
      s.debugSeed(
        status: Status(),
        config: Config(),
        self: Device(id: 'self'),
        peers: [Device(id: 'peer', name: 'Pixel', online: peerOnline)],
      );
      return s;
    }

    test('收到的记录算，同一条推送多次只算一次，收藏不算', () async {
      final s = await seeded();
      s.debugEvent(Event(clipAdded: clip('a')));
      s.debugEvent(Event(clipAdded: clip('a')));
      s.debugEvent(Event(clipAdded: clip('fav', favorite: true)));
      expect(s.starPrompt.syncs, 1);
    });

    test('本机复制的只在有设备在线时才算', () async {
      final offline = await seeded(peerOnline: false);
      offline.debugEvent(Event(clipAdded: clip('mine', outgoing: true)));
      expect(offline.starPrompt.syncs, 0);

      final online = await seeded();
      online.debugEvent(Event(clipAdded: clip('mine', outgoing: true)));
      expect(online.starPrompt.syncs, 1);
    });
  });

  testWidgets('复制记录页显示横幅，「以后再说」后收起', (tester) async {
    final prompt = StarPrompt.memory(now: clock);
    await prompt.load();
    for (var i = 0; i < StarPrompt.minSyncs; i++) {
      prompt.recordSync();
    }
    now = now.add(const Duration(days: 3));
    final state = AppState(starPrompt: prompt)
      ..debugSeed(status: Status(), config: Config(), self: Device(id: 'self'));
    await tester.pumpWidget(PasteFerryApp(state: state));
    await tester.pumpAndSettle();

    expect(find.text('觉得隔空贴好用吗？'), findsOneWidget);
    await tester.tap(find.text('以后再说'));
    await tester.pumpAndSettle();
    expect(find.text('觉得隔空贴好用吗？'), findsNothing);
  });

  testWidgets('没到门槛不显示横幅', (tester) async {
    final prompt = StarPrompt.memory(now: clock);
    await prompt.load();
    final state = AppState(starPrompt: prompt)
      ..debugSeed(status: Status(), config: Config(), self: Device(id: 'self'));
    await tester.pumpWidget(PasteFerryApp(state: state));
    await tester.pumpAndSettle();
    expect(find.text('觉得隔空贴好用吗？'), findsNothing);
  });

  // 英文、日文的文案比中文长：最小窗口与手机上都不能溢出
  for (final language in ['en', 'ja', 'zh-Hans', 'zh-Hant-TW', 'zh-Hant-HK']) {
    Future<AppState> visibleState() async {
      final prompt = StarPrompt.memory(now: clock);
      await prompt.load();
      for (var i = 0; i < StarPrompt.minSyncs; i++) {
        prompt.recordSync();
      }
      now = now.add(const Duration(days: 3));
      return AppState(starPrompt: prompt)..debugSeed(
        status: Status(version: '2.11.0'),
        config: Config(language: language),
        self: Device(id: 'self'),
        peers: [Device(id: 'peer', name: 'Pixel', online: true)],
      );
    }

    testWidgets('$language：最小窗口放得下横幅', (tester) async {
      tester.view.physicalSize = const Size(760, 520);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(PasteFerryApp(state: await visibleState()));
      await tester.pumpAndSettle();
      expect(find.byType(StarBanner), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('$language：手机上放得下横幅', (tester) async {
      tester.view.physicalSize = const Size(412 * 3, 915 * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      // 只看横幅自己有没有溢出：英文的底部标签栏在这个尺寸下本来就差 2 像素（mobile/ui.dart）
      final errors = <String>[];
      final previous = FlutterError.onError;
      FlutterError.onError = (d) => errors.add(d.toString());
      addTearDown(() => FlutterError.onError = previous);
      await tester.pumpWidget(MobileApp(state: await visibleState()));
      await tester.pumpAndSettle();
      FlutterError.onError = previous;
      expect(find.byType(StarBanner), findsOneWidget);
      expect(errors.where((e) => e.contains('star_banner.dart')), isEmpty);
    });
  }
}
