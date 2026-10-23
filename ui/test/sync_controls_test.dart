import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/main.dart';
import 'package:pasteferry_ui/widgets/common.dart';

class _State extends AppState {
  @override
  Future<void> updateConfig(Config next) async {
    debugSeed(status: status!, config: next, self: self!, peers: peers);
  }
}

void main() {
  testWidgets('sync defaults and switches preserve independent settings', (
    tester,
  ) async {
    final state = _State()
      ..debugSeed(
        status: Status(),
        config: Config(),
        self: Device(id: 'self'),
      );
    await tester.pumpWidget(PasteFerryApp(state: state));
    await tester.tap(find.text('设置').first);
    await tester.pumpAndSettle();
    Future<void> toggle(String title) async {
      await tester.scrollUntilVisible(
        find.text(title),
        250,
        scrollable: find.descendant(of: find.byType(ListView).last, matching: find.byType(Scrollable)).first,
      );
      final row = find.ancestor(
        of: find.text(title).first,
        matching: find.byType(SettingRow),
      );
      await tester.ensureVisible(row);
      await tester.tap(
        find.descendant(of: row, matching: find.byType(SmallSwitch)),
      );
      await tester.pumpAndSettle();
    }

    expect(state.config!.syncBacklog, isFalse);
    await toggle('实时同步剪贴板');
    expect(state.config!.realtimeSyncDisabled, isTrue);
    expect(
      state.config!.syncText,
      isFalse,
    ); // Unrelated content settings stay intact.
    await toggle('重连后补发离线内容');
    expect(state.config!.syncBacklog, isTrue);
    expect(state.config!.realtimeSyncDisabled, isTrue);
    expect(state.config!.launchAtLogin, isFalse);
  });

  testWidgets(
    'a device can pause sync without unpairing or changing other devices',
    (tester) async {
      final state = _State()
        ..debugSeed(
          status: Status(),
          config: Config(),
          self: Device(id: 'self'),
          peers: [
            Device(id: 'home', name: 'Home'),
            Device(id: 'office', name: 'Office'),
          ],
        );
      await tester.pumpWidget(PasteFerryApp(state: state));
      await tester.tap(find.text('设备').first);
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byTooltip('与这台电脑实时同步').first,
          matching: find.byType(SmallSwitch),
        ),
      );
      await tester.pumpAndSettle();
      expect(state.config!.syncDisabledPeers, ['home']);
      expect(state.peers.length, 2);
      expect(find.text('剪贴板同步已暂停'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
