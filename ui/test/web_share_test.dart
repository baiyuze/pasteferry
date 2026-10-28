import 'dart:async';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/i18n.dart';
import 'package:pasteferry_ui/main.dart';
import 'package:pasteferry_ui/records.dart';
import 'package:pasteferry_ui/widgets/web_share.dart';

Int64 _now([int ago = 0]) =>
    Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000 - ago);

/// 21×21 的点阵：左上角一个定位图案，够界面画出来就行
List<int> _modules() {
  final m = List<int>.filled(21 * 21, 0);
  for (var i = 0; i < 7; i++) {
    m[i] = 1;
    m[i * 21] = 1;
  }
  return m;
}

/// 记下界面调了哪些网页传输的操作，不连后台服务
class _WebShareState extends AppState {
  final invites = <String>[]; // 申请二维码时给的地址
  final closed = <String>[];
  final toggles = <bool>[];
  final removed = <String>[];
  int firewallRequests = 0;
  Future<void> Function()? firewallPermission;
  var _serial = 0;

  @override
  Future<void> requestLocalNetworkPermission() async {
    firewallRequests++;
    await firewallPermission?.call();
  }

  WebShareStatus _status(bool on, {List<WebSession> sessions = const []}) =>
      WebShareStatus(
        enabled: on,
        listening: on,
        port: 8790,
        addresses: ['192.168.1.5', '10.0.0.8'],
        sessions: sessions,
      );

  @override
  Future<WebShareInvite> newWebShareInvite(String address) async {
    invites.add(address);
    _serial++;
    final host = address.isEmpty ? '192.168.1.5' : address;
    return WebShareInvite(
      id: 'inv$_serial',
      url: 'http://$host:8790/#i=inv$_serial&k=key',
      expiresAtUnix: _now(-600),
      qrSize: 21,
      qrModules: _modules(),
    );
  }

  @override
  Future<void> closeWebShareInvite(String id) async => closed.add(id);

  @override
  Future<void> setWebShare(bool enabled) async {
    toggles.add(enabled);
    debugEvent(
      Event(
        webShareChanged: _status(
          enabled,
          sessions: webShare?.sessions ?? const [],
        ),
      ),
    );
  }

  @override
  Future<void> removeWebSession(String id) async {
    removed.add(id);
    debugEvent(
      Event(
        webShareChanged: _status(
          true,
          sessions: webShare!.sessions.where((s) => s.id != id).toList(),
        ),
      ),
    );
  }
}

_WebShareState _demo({
  bool on = true,
  List<WebSession> sessions = const [],
  String platform = 'darwin',
  String language = 'zh-Hans',
}) {
  final state = _WebShareState();
  state.debugSeed(
    status: Status(version: '2.7.0'),
    config: Config(language: language, deviceName: 'MacBook Pro'),
    self: Device(id: 'self', name: 'MacBook Pro', platform: platform),
    webShare: state._status(on, sessions: sessions),
  );
  return state;
}

final _iphone = WebSession(
  id: 's1',
  name: 'iPhone',
  createdAtUnix: _now(7200),
  lastSeenUnix: _now(120),
);

void main() {
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(1180, 900);
    view.devicePixelRatio = 1;
  });
  tearDown(
    () => TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
        .reset(),
  );

  Future<AppLocalizations> openDevices(
    WidgetTester tester,
    AppState state,
  ) async {
    await tester.pumpWidget(PasteFerryApp(state: state));
    await tester.pump();
    final l = AppLocalizations.of(tester.element(find.byType(Shell)));
    await tester.tap(find.text(l.navDevices).first);
    await tester.pumpAndSettle();
    return l;
  }

  testWidgets('设备页：网页传输的开关、已登记的手机、移除', (tester) async {
    final state = _demo(sessions: [_iphone]);
    final l = await openDevices(tester, state);
    expect(find.text(l.webShareTitle), findsOneWidget);
    expect(find.text(l.webShareOn(1)), findsOneWidget);
    expect(find.text('iPhone'), findsOneWidget);
    expect(find.text(l.webShareShowQr), findsOneWidget);

    await tester.tap(find.text(l.webShareRemove));
    await tester.pumpAndSettle();
    expect(state.removed, ['s1']);
    expect(find.text('iPhone'), findsNothing);
    expect(find.text(l.webShareOn(0)), findsOneWidget);
  });

  testWidgets('关着时没有二维码按钮；打开开关后直接弹出二维码', (tester) async {
    final state = _demo(on: false, platform: 'windows');
    final l = await openDevices(tester, state);
    expect(find.text(l.webShareOff), findsOneWidget);
    expect(find.text(l.webShareShowQr), findsNothing);

    await tester.tap(find.byType(Switch).last);
    await tester.pumpAndSettle();
    expect(state.toggles, [true]);
    expect(find.byType(WebShareDialog), findsOneWidget);
    expect(find.byType(QrCodeView), findsOneWidget);
    expect(find.text('http://192.168.1.5:8790/'), findsOneWidget);
    expect(state.firewallRequests, 1);
    expect(find.text(l.webShareFirewallReady), findsOneWidget);
  });

  testWidgets('Windows 二维码窗口等待授权，失败后可以原地重试', (tester) async {
    final pending = Completer<void>();
    final state = _demo(platform: 'windows')
      ..firewallPermission = () => pending.future;
    final l = await openDevices(tester, state);
    await tester.tap(find.text(l.webShareShowQr));
    await tester.pumpAndSettle();
    expect(state.firewallRequests, 1);
    expect(find.text(l.webShareFirewallPreparing), findsOneWidget);
    expect(find.text(l.webShareFirewallReady), findsNothing);
    expect(find.text(l.webShareFirewallAllow), findsNothing);

    pending.completeError(StateError('UAC cancelled'));
    await tester.pumpAndSettle();
    expect(find.text(l.webShareFirewallFailed), findsOneWidget);
    expect(find.textContaining('UAC cancelled'), findsOneWidget);
    expect(find.text(l.webShareFirewallReady), findsNothing);

    state.firewallPermission = () async {};
    await tester.ensureVisible(find.text(l.webShareFirewallAllow));
    await tester.tap(find.text(l.webShareFirewallAllow));
    await tester.pumpAndSettle();
    expect(state.firewallRequests, 2);
    expect(find.text(l.webShareFirewallReady), findsOneWidget);
    expect(find.text(l.webShareFirewallFailed), findsNothing);

    // 邀请自动轮换不再申请；重新打开窗口才重新检查，避免每次 UAC。
    state.debugEvent(
      Event(webShareChanged: state._status(true)..inviteUsed = 'inv1'),
    );
    await tester.pumpAndSettle();
    expect(state.invites, ['', '']);
    expect(state.firewallRequests, 2);
    await tester.tap(find.byTooltip(l.close));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.webShareShowQr));
    await tester.pumpAndSettle();
    expect(state.firewallRequests, 3);
  });

  testWidgets('Windows 授权中关闭二维码窗口不会在完成时访问已销毁界面', (tester) async {
    final pending = Completer<void>();
    final state = _demo(platform: 'windows')
      ..firewallPermission = () => pending.future;
    final l = await openDevices(tester, state);
    await tester.tap(find.text(l.webShareShowQr));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l.close));
    await tester.pumpAndSettle();
    pending.complete();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(WebShareDialog), findsNothing);
  });

  for (final language in ['en', 'ja', 'zh-Hans', 'zh-Hant-TW', 'zh-Hant-HK']) {
    testWidgets('Windows 最小窗口的 $language 授权提示和二维码可滚动访问', (tester) async {
      tester.view.physicalSize = const Size(760, 520);
      final state = _demo(platform: 'windows', language: language)
        ..firewallPermission = () async => throw StateError('UAC cancelled');
      await tester.pumpWidget(PasteFerryApp(state: state));
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(Shell));
      final l = AppLocalizations.of(context);
      unawaited(showWebShareDialog(context));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text(l.webShareFirewallAllow));
      await tester.pumpAndSettle();
      state.firewallPermission = () async {};
      await tester.tap(find.text(l.webShareFirewallAllow));
      await tester.pumpAndSettle();
      expect(state.firewallRequests, 2);
      expect(find.text(l.webShareFirewallReady), findsOneWidget);
      await tester.ensureVisible(find.byType(QrCodeView));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('二维码窗口：被扫码用掉后换一张新的，切换地址，关掉时作废', (tester) async {
    final state = _demo(sessions: [_iphone]);
    final l = await openDevices(tester, state);
    await tester.tap(find.text(l.webShareShowQr));
    await tester.pumpAndSettle();
    expect(state.invites, ['']);
    expect(state.firewallRequests, 0);
    expect(find.text(l.webShareFirewallPreparing), findsNothing);

    // 手机扫码登记：后台服务推来 invite_used，窗口换一张新的二维码并提示
    final android = WebSession(
      id: 's2',
      name: 'Android 手机',
      createdAtUnix: _now(),
      lastSeenUnix: _now(),
    );
    state.debugEvent(
      Event(
        webShareChanged: WebShareStatus(
          enabled: true,
          listening: true,
          port: 8790,
          addresses: ['192.168.1.5', '10.0.0.8'],
          sessions: [android, _iphone],
          inviteUsed: 'inv1',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(state.invites, ['', '']);
    expect(find.text(l.webShareNewPhone('Android 手机')), findsOneWidget);
    expect(state.closed, isEmpty, reason: '用掉的那张不用再作废');

    // 换一个地址：用新地址申请，旧的作废
    await tester.tap(find.text('192.168.1.5').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('10.0.0.8').last);
    await tester.pumpAndSettle();
    expect(state.invites.last, '10.0.0.8');
    expect(state.closed, ['inv2']);
    expect(find.text('http://10.0.0.8:8790/'), findsOneWidget);

    await tester.tap(find.byTooltip(l.close));
    await tester.pumpAndSettle();
    expect(find.byType(WebShareDialog), findsNothing);
    expect(state.closed, ['inv2', 'inv3']);
  });

  testWidgets('旧版后台服务没有网页传输时不显示', (tester) async {
    final state = _WebShareState()
      ..debugSeed(
        status: Status(version: '2.6.3'),
        config: Config(language: 'zh-Hans'),
        self: Device(id: 'self', name: 'MacBook Pro', platform: 'darwin'),
      );
    final l = await openDevices(tester, state);
    expect(find.text(l.webShareTitle), findsNothing);
  });

  test('网页发来的记录显示手机的名字', () {
    final r = ClipRecord(
      outgoing: true,
      viaName: 'iPhone',
      originDeviceName: 'MacBook Pro',
    );
    expect(recordSource(r), appL10n.fromDevice('iPhone'));
    expect(recordSource(ClipRecord(outgoing: true)), appL10n.thisDeviceShort);
  });

  testWidgets('二维码按点阵画出来', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: QrCodeView(
              size: 21,
              modules: Uint8List.fromList(_modules()),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
