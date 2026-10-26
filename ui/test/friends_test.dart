import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/i18n.dart';
import 'package:pasteferry_ui/main.dart';
import 'package:pasteferry_ui/widgets/friend_send_dialog.dart';
import 'package:pasteferry_ui/widgets/common.dart';
import 'package:pasteferry_ui/widgets/friends_dialog.dart';

/// 记下界面调了哪些好友相关的操作，不连后台服务
class _FriendsState extends AppState {
  final answers = <(String, bool, bool)>[];
  final receiveFromCalls = <String>[];
  final autoCalls = <(String, bool)>[];

  @override
  Future<void> setFriendAutoAccept(String id, bool auto) async => autoCalls.add((id, auto));

  @override
  Future<void> answerIncoming(String transferId, bool accept, {bool always = false}) async {
    answers.add((transferId, accept, always));
    await super.answerIncomingLocally(transferId);
  }

  @override
  Future<void> setReceiveFrom(String v) async {
    receiveFromCalls.add(v);
    debugSeed(
      status: status!,
      config: config!.deepCopy()..receiveFrom = v,
      self: self!,
      peers: peers,
      friends: friends,
      profile: profile,
    );
  }
}

/// 隔空传送页的雷达一直在动，pumpAndSettle 等不到停：按时间推进几帧
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

Int64 _now([int ago = 0]) => Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000 - ago);

final _xiaoming = Friend(
  id: 'xm',
  displayName: '小明',
  deviceName: 'MacBook Air',
  platform: 'darwin',
  online: true,
  lanReachable: true,
  connection: ConnectionKind.CONNECTION_KIND_DIRECT,
  featuresKnown: true,
  receivesFiles: true,
  addedAtUnix: _now(3600),
);

final _ajie = Friend(
  id: 'aj',
  displayName: '阿杰',
  deviceName: 'Win 台式机',
  platform: 'windows',
  reachability: 'peer_no_service',
  addedAtUnix: _now(7200),
);

_FriendsState _demo({List<Transfer> transfers = const []}) => _FriendsState()
  ..debugSeed(
    status: Status(version: '2.6.0'),
    config: Config(language: 'zh-Hans', deviceName: 'MacBook Pro', receiveFrom: 'friends'),
    self: Device(id: 'self', name: 'MacBook Pro', platform: 'darwin'),
    peers: [
      Device(id: 'air', name: 'iMac', platform: 'darwin', online: true, lanReachable: true,
          connection: ConnectionKind.CONNECTION_KIND_DIRECT, receivesFiles: true, featuresKnown: true),
    ],
    friends: [_xiaoming, _ajie],
    profile: Profile(displayName: '光光', deviceId: 'self'),
    transfers: transfers,
  );

void main() {
  setUp(() {
    final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(1180, 760);
    view.devicePixelRatio = 1;
  });
  tearDown(() => TestWidgetsFlutterBinding.instance.platformDispatcher.views.first.reset());

  Future<AppLocalizations> openSend(WidgetTester tester, AppState state) async {
    await tester.pumpWidget(PasteFerryApp(state: state));
    await tester.pump();
    final l = AppLocalizations.of(tester.element(find.byType(Shell)));
    await tester.tap(find.text(l.navSend).first);
    await tester.pump();
    return l;
  }

  testWidgets('隔空传送页：本机名片、好友、谁可以给我发文件', (tester) async {
    final state = _demo();
    final l = await openSend(tester, state);
    expect(find.text('光光'), findsOneWidget);
    expect(find.text('${l.friendsTitle} 2'), findsOneWidget);
    // 雷达下面一排好友：能发的写连接方式，连不上的写原因
    expect(find.text('小明'), findsOneWidget);
    expect(find.text('阿杰'), findsOneWidget);
    expect(find.text(l.friendNeedService), findsOneWidget);
    expect(find.text(l.receiveFromFriends), findsOneWidget);

    await tester.tap(find.text(l.receiveFromFriends));
    await _settle(tester);
    await tester.tap(find.widgetWithText(CheckedPopupMenuItem<String>, l.receiveFromEveryone));
    await _settle(tester);
    expect(state.receiveFromCalls, ['everyone']);
  });

  testWidgets('点连不上的好友：说明原因，不打开发送窗口', (tester) async {
    final state = _demo();
    final l = await openSend(tester, state);
    await tester.tap(find.text('阿杰'));
    await _settle(tester);
    expect(find.text(l.reachPeerNoService('阿杰')), findsOneWidget);
    expect(find.byType(FriendSendDialog), findsNothing);
  });

  testWidgets('发给好友：选好文件之前不能写备注、不能发', (tester) async {
    final state = _demo();
    final l = await openSend(tester, state);
    await tester.tap(find.text('小明'));
    await _settle(tester);
    expect(find.byType(FriendSendDialog), findsOneWidget);
    expect(find.text(l.sendToTitle('小明 · MacBook Air')), findsOneWidget);
    final note = tester.widget<TextField>(find.byType(TextField));
    expect(note.enabled, isFalse);
    final send = tester.widget<FilledButton>(find.widgetWithText(FilledButton, l.sendAction));
    expect(send.onPressed, isNull);
  });

  testWidgets('好友发来文件：弹出接收框，显示备注，勾选以后自动接收', (tester) async {
    final asking = Transfer(
      id: 't1',
      direction: TransferDirection.TRANSFER_DIRECTION_INCOMING,
      deviceId: 'xm',
      deviceName: '小明 · MacBook Air',
      status: 'asking',
      peerRole: 'friend',
      note: '合同第 3 页要签字',
      items: [ClipItem(name: '合同扫描件.pdf', size: Int64(18 << 20))],
      totalBytes: Int64(18 << 20),
      createdAtUnix: _now(2),
    );
    final state = _demo(transfers: [asking]);
    await tester.pumpWidget(PasteFerryApp(state: state));
    await tester.pump();
    await tester.pump();
    final l = AppLocalizations.of(tester.element(find.byType(Shell)));
    expect(find.text(l.incomingTitle('小明 · MacBook Air')), findsOneWidget);
    expect(find.text(l.noteLine('合同第 3 页要签字')), findsOneWidget);
    await tester.tap(find.text(l.incomingAlways));
    await tester.pump();
    await tester.tap(find.text(l.incomingAccept));
    await _settle(tester);
    expect(state.answers, [('t1', true, true)]);
    expect(find.text(l.incomingTitle('小明 · MacBook Air')), findsNothing);
  });

  testWidgets('好友列表与加好友的错误文案', (tester) async {
    final state = _demo();
    await openSend(tester, state);
    final ctx = tester.element(find.byType(Shell));
    final l = AppLocalizations.of(ctx);
    showFriendsDialog(ctx);
    await _settle(tester);
    expect(find.text('小明 · MacBook Air'), findsOneWidget);
    expect(find.text('阿杰 · Win 台式机'), findsOneWidget);
    expect(friendStatus(l, state, _xiaoming), l.sendLan);
    expect(friendStatus(l, state, _ajie), l.friendNeedService);
    expect(friendCanSend(_xiaoming), isTrue);
    expect(friendCanSend(_ajie), isFalse);
  });

  testWidgets('好友列表里点一个好友：打开好友页，能开自动接收、看传输记录', (tester) async {
    final state = _demo();
    await openSend(tester, state);
    final ctx = tester.element(find.byType(Shell));
    final l = AppLocalizations.of(ctx);
    showFriendsDialog(ctx);
    await _settle(tester);
    await tester.tap(find.text('小明 · MacBook Air'));
    await _settle(tester);
    expect(find.text(l.friendHistory), findsOneWidget);
    expect(find.text(l.friendAutoAccept), findsOneWidget);
    await tester.tap(find.descendant(
        of: find.ancestor(of: find.text(l.friendAutoAccept), matching: find.byType(Row)).first,
        matching: find.byType(SmallSwitch)));
    await _settle(tester);
    expect(state.autoCalls, [('xm', true)]);
  });
}
