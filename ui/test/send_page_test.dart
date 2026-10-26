import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/i18n.dart';
import 'package:pasteferry_ui/main.dart';
import 'package:pasteferry_ui/platform.dart';
import 'package:pasteferry_ui/widgets/send_dialog.dart';

const _in = TransferDirection.TRANSFER_DIRECTION_INCOMING;
const _out = TransferDirection.TRANSFER_DIRECTION_OUTGOING;

Int64 _now([int ago = 0]) => Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000 - ago);

/// 各种状态都有：同一局域网、中转、离线、旧版本、关了接收的设备；收到的与发出的各种结果。
AppState _demo(String language, {bool withActive = true}) => AppState()
  ..debugSeed(
    status: Status(version: '2.5.0', officialUsage: OfficialUsage(available: true, remainingBytes: Int64(62 << 20))),
    config: Config(language: language, deviceName: 'MacBook Pro', serviceMode: ServiceMode.SERVICE_MODE_OFFICIAL),
    self: Device(id: 'self', name: 'MacBook Pro', platform: 'darwin'),
    peers: [
      Device(id: 'air', name: 'MacBook Air', platform: 'darwin', online: true, lanReachable: true,
          connection: ConnectionKind.CONNECTION_KIND_DIRECT, receivesFiles: true),
      Device(id: 'win', name: 'Windows 台式机', platform: 'windows', online: true,
          connection: ConnectionKind.CONNECTION_KIND_RELAY, receivesFiles: true),
      Device(id: 'linux', name: 'Ubuntu 笔记本', platform: 'linux'),
      Device(id: 'old', name: 'Old PC', platform: 'windows', online: true,
          connection: ConnectionKind.CONNECTION_KIND_DIRECT, featuresKnown: true),
      Device(id: 'off', name: 'iMac', platform: 'darwin', online: true, lanReachable: true,
          connection: ConnectionKind.CONNECTION_KIND_DIRECT, receivesFiles: true, receiveDisabled: true),
    ],
    transfers: [
      if (withActive)
        Transfer(id: 'r1', direction: _in, deviceId: 'air', deviceName: 'MacBook Air', status: 'active',
            items: [ClipItem(name: '照片 2026-10', isDir: true, size: Int64(2 << 30))],
            totalBytes: Int64(2 << 30), doneBytes: Int64(1 << 30), fileCount: Int64(412),
            bytesPerSecond: 42e6, currentFile: '照片 2026-10/IMG_2041.HEIC', currentIndex: Int64(281),
            createdAtUnix: _now(30)),
      Transfer(id: 'r2', direction: _in, deviceId: 'air', deviceName: 'MacBook Air', status: 'done',
          items: [ClipItem(name: '合同扫描件.pdf'), ClipItem(name: 'notes.txt'), ClipItem(name: 'a.png')],
          paths: ['/tmp/合同扫描件.pdf', '/tmp/notes.txt', '/tmp/a.png'], present: [true, true, true],
          totalBytes: Int64(18 << 20), fileCount: Int64(3), createdAtUnix: _now(120), finishedAtUnix: _now(100), seen: true,
          renamedFiles: Int64(2)),
      Transfer(id: 'r3', direction: _in, deviceId: 'win', deviceName: 'Windows 台式机', status: 'done',
          items: [ClipItem(name: 'PasteFerry.dmg')], paths: ['/tmp/PasteFerry.dmg'], present: [false],
          totalBytes: Int64(812 << 20), fileCount: Int64(1), createdAtUnix: _now(90000), finishedAtUnix: _now(90000), seen: true),
      if (withActive)
        Transfer(id: 's1', direction: _out, deviceId: 'air', deviceName: 'MacBook Air', status: 'active',
            items: [ClipItem(name: '演示视频.mov')], totalBytes: Int64(3 << 30), doneBytes: Int64(1 << 30),
            fileCount: Int64(1), bytesPerSecond: 41e6, createdAtUnix: _now(20)),
      Transfer(id: 's2', direction: _out, deviceId: 'win', deviceName: 'Windows 台式机', status: 'interrupted',
          items: [ClipItem(name: 'build.zip')], paths: ['/tmp/build.zip'], totalBytes: Int64(300 << 20),
          doneBytes: Int64(120 << 20), fileCount: Int64(1), createdAtUnix: _now(600)),
      Transfer(id: 's3', direction: _out, deviceId: 'air', deviceName: 'MacBook Air', status: 'declined',
          error: 'no_space', shortfallBytes: Int64(1200 << 20), items: [ClipItem(name: '照片 2026-10', isDir: true)],
          paths: ['/tmp/照片 2026-10'], totalBytes: Int64(2 << 30), fileCount: Int64(412), createdAtUnix: _now(3600)),
    ],
  );

void main() {
  for (final language in ['en', 'ja', 'zh-Hans', 'zh-Hant-TW', 'zh-Hant-HK']) {
    group('最小窗口下的 $language 隔空传送', () {
      setUp(() {
        final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
        view.physicalSize = const Size(760, 520);
        view.devicePixelRatio = 1;
      });
      tearDown(() => TestWidgetsFlutterBinding.instance.platformDispatcher.views.first.reset());

      Future<AppLocalizations> open(WidgetTester tester, AppState state) async {
        await tester.pumpWidget(PasteFerryApp(state: state));
        await tester.pump();
        final l = AppLocalizations.of(tester.element(find.byType(Shell)));
        await tester.tap(find.text(l.navSend).first);
        await tester.pump();
        return l;
      }

      testWidgets('还没连上的设备写「正在连接」，不写需要更新', (tester) async {
        final state = AppState()
          ..debugSeed(
            status: Status(version: '2.5.4'),
            config: Config(language: language, deviceName: 'MacBook Pro'),
            self: Device(id: 'self', name: 'MacBook Pro', platform: 'darwin'),
            peers: [
              // 在线（服务器或局域网报告）但还没连上、没收到功能声明
              Device(id: 'new', name: 'Linux 台式机', platform: 'linux', online: true),
              // 连上以后一直没声明，判定为旧版本
              Device(id: 'old', name: 'Old PC', platform: 'windows', online: true,
                  connection: ConnectionKind.CONNECTION_KIND_DIRECT, featuresKnown: true),
            ],
          );
        final l = await open(tester, state);
        expect(find.text(l.reconnecting), findsOneWidget);
        expect(find.byTooltip(l.sendConnectingTip('Linux 台式机')), findsOneWidget);
        expect(find.text(l.sendNeedsUpdate), findsOneWidget);
        expect(find.byTooltip(l.sendNeedsUpdateTip('Old PC')), findsOneWidget);
      });

      testWidgets('雷达与列表', (tester) async {
        final l = await open(tester, _demo(language));
        expect(find.text(l.sendSubtitle), findsOneWidget);
        // 在线的上雷达；离线的 Ubuntu 笔记本在雷达下面列一行
        for (final name in ['MacBook Air', 'Windows 台式机', 'Old PC', 'iMac']) {
          expect(find.text(name), findsOneWidget, reason: name);
        }
        expect(find.text(l.sendOfflineList('Ubuntu 笔记本')), findsOneWidget);
        expect(find.text(l.sendRingLan), findsOneWidget);
        // 发不了的在名字下面写原因；连接方式在悬停提示里
        expect(find.text(l.sendNeedsUpdate), findsOneWidget);
        expect(find.text(l.sendNotReceiving), findsOneWidget);
        expect(find.byTooltip(l.sendRelayLeft('62.0 MB')), findsOneWidget);
        expect(find.byTooltip(l.sendLan), findsOneWidget);
        // 收到的。最小窗口下列表只放得下两三行，后面的要滚动
        final list = find.byType(Scrollable).last;
        expect(find.textContaining('IMG_2041.HEIC'), findsOneWidget);
        await tester.scrollUntilVisible(find.textContaining(l.transferItems('合同扫描件.pdf', 3, 2)), 60, scrollable: list);
        await tester.scrollUntilVisible(find.text(l.transferRenamed(2)), 60, scrollable: list);
        await tester.scrollUntilVisible(find.textContaining(l.transferMissing), 60, scrollable: list);
        // 发出的
        await tester.tap(find.text(l.transfersSent));
        await tester.pump();
        // 最小窗口下列表很窄，按钮是图标，文字在提示里
        await tester.scrollUntilVisible(find.byTooltip(l.continueAction), 60, scrollable: list);
        await tester.scrollUntilVisible(find.textContaining(l.reasonNoSpacePeer('MacBook Air', '1.2 GB')), 60,
            scrollable: list);
        expect(find.byTooltip(l.transferResend), findsOneWidget);
      });

      testWidgets('发送窗口', (tester) async {
        final l = await open(tester, _demo(language));
        await tester.tap(find.text('MacBook Air'));
        // 雷达的波纹一直在动，等不到 pumpAndSettle，等弹窗的动画放完就行
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.text(l.sendToTitle('MacBook Air')), findsOneWidget);
        expect(find.text(l.sendDropHere), findsOneWidget);
        expect(find.text(l.sendChooseFolder), findsOneWidget);
      });

      testWidgets('设置里的隔空传送', (tester) async {
        await tester.pumpWidget(PasteFerryApp(state: _demo(language)));
        await tester.pump();
        final l = AppLocalizations.of(tester.element(find.byType(Shell)));
        await tester.tap(find.text(l.navSettings).first);
        await tester.pump();
        await tester.dragUntilVisible(find.text(l.receiveNotify), find.byType(ListView), const Offset(0, -100));
        expect(find.text(l.receiveFiles), findsOneWidget);
        expect(find.text(l.sendLayout), findsOneWidget);
        expect(find.text(l.saveToChange), findsOneWidget);
      });
    });
  }

  testWidgets('有文件在传时侧边栏显示进度环，没有时显示新收到的个数', (tester) async {
    final state = _demo('zh-Hans');
    await tester.pumpWidget(PasteFerryApp(state: state));
    await tester.pump();
    final ring = find.descendant(of: find.byType(Tooltip), matching: find.byType(CircularProgressIndicator));
    expect(ring, findsOneWidget);

    final idle = _demo('zh-Hans', withActive: false);
    idle.debugEvent(Event(transferChanged: Transfer(id: 'new', direction: _in, deviceName: 'MacBook Air',
        status: 'done', items: [ClipItem(name: 'x.txt')], createdAtUnix: _now())));
    await tester.pumpWidget(PasteFerryApp(key: UniqueKey(), state: idle));
    await tester.pump();
    expect(ring, findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('点了隔空传送的通知，界面切到隔空传送页', (tester) async {
    final state = _demo('zh-Hans');
    await tester.pumpWidget(PasteFerryApp(state: state));
    await tester.pump();
    expect(find.text('把文件拖到一台设备上，直接发过去'), findsNothing);
    state.debugEvent(Event(navigate: 'send'));
    await tester.pump();
    expect(find.text('把文件拖到一台设备上，直接发过去'), findsOneWidget);
  });

  // 默认左右排，窗口再窄也是；设置里选了上下排才放到雷达下面
  for (final (stacked, size) in [
    (false, const Size(1180, 720)),
    (false, const Size(960, 640)),
    (false, const Size(760, 520)),
    (false, const Size(760, 760)),
    (true, const Size(760, 520)),
    (true, const Size(1180, 720)),
  ]) {
    testWidgets(stacked ? '设置里选了上下排，列表在雷达下面' : '默认左右排，列表在雷达右边（${size.width.round()} 宽）', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final state = _demo('zh-Hans');
      state.config!.sendLayoutStacked = stacked;
      await tester.pumpWidget(PasteFerryApp(state: state));
      await tester.pump();
      await tester.tap(find.text('隔空传送').first);
      await tester.pump();
      // 本机的叫法随平台变：Mac 上「这台 Mac」，其他平台「这台电脑」
      final self = find.text(Wording.thisDevice);
      final radar = tester.getCenter(self);
      final tabs = tester.getCenter(find.text('收到的'));
      if (stacked) {
        expect(tabs.dy, greaterThan(radar.dy), reason: '列表在雷达下面');
      } else {
        expect(tabs.dx, greaterThan(radar.dx), reason: '列表在雷达右边');
        expect(tabs.dy, lessThan(radar.dy), reason: '列表从顶上开始');
      }
      final paints = find.byWidgetPredicate((w) => w is CustomPaint && w.painter.runtimeType.toString() == '_SendRadarPainter');
      expect(paints, findsOneWidget);
      final dynamic painter = tester.widget<CustomPaint>(paints).painter;
      final Size inner = painter.inner;
      final Size outer = painter.outer;
      expect(inner.width, inner.height, reason: '内圈必须保持正圆');
      expect(outer.width, outer.height, reason: '外圈必须保持正圆');
      expect(tester.takeException(), isNull);
      // 雷达上的设备名字不压到中间的本机，也不互相压
      final selfRect = tester.getRect(self);
      final names = [
        for (final d in state.peers.where((d) => d.online))
          if (find.text(d.name).evaluate().isNotEmpty) tester.getRect(find.text(d.name).first)
      ];
      expect(names, isNotEmpty);
      for (final (i, r) in names.indexed) {
        expect(r.overlaps(selfRect), isFalse, reason: '设备名字压到了本机');
        for (final o in names.skip(i + 1)) {
          expect(r.overlaps(o), isFalse, reason: '两个设备的名字叠在一起');
        }
      }
    });
  }

  test('剩余时间与进度的写法', () {
    final l = lookupAppLocalizations(const Locale('zh'));
    expect(etaLabel(l, 20), '20 秒');
    expect(etaLabel(l, 90), '2 分钟');
    expect(etaLabel(l, 3900), '1 小时 5 分');
    final t = Transfer(totalBytes: Int64(2 << 30), doneBytes: Int64(1 << 30), bytesPerSecond: 40 * 1024 * 1024);
    expect(progressLabel(l, t), '50% · 1.0 GB / 2.0 GB · 40.0 MB/s · 还剩 26 秒');
  });
}
