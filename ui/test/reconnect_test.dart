import 'package:flutter_test/flutter_test.dart';

import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/main.dart';

/// 不连后台服务：「重新连接」按测试给的结果回答。
class _ReconnectState extends AppState {
  _ReconnectState(this.result);

  final ConnectionKind result;
  final calls = <String>[];

  @override
  Future<ConnectionKind> reconnect(String deviceId) async {
    calls.add(deviceId);
    return result;
  }
}

_ReconnectState _seed(ConnectionKind result) => _ReconnectState(result)
  ..debugSeed(
    status: Status(signalingConnected: true, version: '2.4.2'),
    config: Config(language: 'zh-Hans'),
    self: Device(id: 'self', name: 'MacBook Pro'),
    peers: [
      Device(id: 'a', name: '直连的电脑', online: true, connection: ConnectionKind.CONNECTION_KIND_DIRECT),
      Device(id: 'b', name: '中转的电脑', online: true, connection: ConnectionKind.CONNECTION_KIND_RELAY),
      Device(id: 'c', name: '离线的电脑', connection: ConnectionKind.CONNECTION_KIND_OFFLINE),
    ],
  );

Future<void> _openMenu(WidgetTester tester, int row) async {
  await tester.tap(find.byTooltip('更多操作').at(row));
  await tester.pumpAndSettle();
}

void main() {
  Future<_ReconnectState> open(WidgetTester tester, ConnectionKind result) async {
    final state = _seed(result);
    await tester.pumpWidget(PasteFerryApp(state: state));
    await tester.pump();
    await tester.tap(find.text('设备').first); // 侧边栏
    await tester.pumpAndSettle();
    return state;
  }

  testWidgets('已是直连的设备菜单里没有「重新连接」', (tester) async {
    await open(tester, ConnectionKind.CONNECTION_KIND_DIRECT);
    await _openMenu(tester, 0);
    expect(find.text('拷贝安全指纹'), findsOneWidget);
    expect(find.text('重新连接'), findsNothing);
  });

  for (final (result, toast) in [
    (ConnectionKind.CONNECTION_KIND_DIRECT, '已直连'),
    (ConnectionKind.CONNECTION_KIND_RELAY, '直连没打通，继续经中转'),
  ]) {
    testWidgets('中转的设备点「重新连接」，结果是 $result 时提示「$toast」', (tester) async {
      final state = await open(tester, result);
      await _openMenu(tester, 1);
      await tester.tap(find.text('重新连接'));
      await tester.pumpAndSettle();
      expect(state.calls, ['b']);
      expect(find.text(toast), findsOneWidget);
    });
  }

  testWidgets('离线的设备也能「重新连接」，找不到时说明对方不在线', (tester) async {
    final state = await open(tester, ConnectionKind.CONNECTION_KIND_OFFLINE);
    await _openMenu(tester, 2);
    await tester.tap(find.text('重新连接'));
    await tester.pumpAndSettle();
    expect(state.calls, ['c']);
    expect(find.text('「离线的电脑」不在线，请确认它那边已打开隔空贴'), findsOneWidget);
  });
}
