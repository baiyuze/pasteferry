import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/main.dart';

AppState _state() => AppState()..debugSeed(status: Status(), config: Config(), self: Device(id: 'self'));

class _UnavailableSettings extends AppState {
  int retries = 0;
  @override
  Config? get config => null;
  @override
  LinkState get link => LinkState.offline;
  @override
  Future<void> connect() async { retries++; }
}

void main() {
  testWidgets('设置加载失败显示重试入口，停止无限转圈', (tester) async {
    final state = _UnavailableSettings();
    await tester.pumpWidget(PasteFerryApp(state: state));
    await tester.tap(find.text('设置').first);
    await tester.pumpAndSettle();
    expect(find.text('无法连接后台服务'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.tap(find.text('重试'));
    expect(state.retries, 1);
  });

  testWidgets('设置首页列出各类，点进去是二级页，能返回', (tester) async {
    await tester.pumpWidget(PasteFerryApp(state: _state()));
    await tester.tap(find.text('设置').first);
    await tester.pumpAndSettle();
    for (final title in ['通用', '连接', '同步', '快捷粘贴', '存储', '关于']) {
      expect(find.text(title), findsOneWidget);
    }
    // 首页只有类别，没有具体的设置项
    expect(find.text('在局域网中查找设备'), findsNothing);

    await tester.tap(find.text('连接'));
    await tester.pumpAndSettle();
    expect(find.text('在局域网中查找设备'), findsOneWidget);
    expect(find.text('通用'), findsNothing);

    // 点「‹ 设置」回到首页
    await tester.tap(find.text('设置').last);
    await tester.pumpAndSettle();
    expect(find.text('通用'), findsOneWidget);

    // Esc 也能返回
    await tester.tap(find.text('存储'));
    await tester.pumpAndSettle();
    expect(find.text('记录保留'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('通用'), findsOneWidget);
  });

  testWidgets('好友连不上时「打开服务…」直接进到连接', (tester) async {
    final state = _state();
    await tester.pumpWidget(PasteFerryApp(state: state));
    await tester.pumpAndSettle();
    state.requestPage('settings:connection');
    await tester.pumpAndSettle();
    expect(find.text('使用服务'), findsOneWidget);
    expect(find.text('在局域网中查找设备'), findsOneWidget);
  });
}
