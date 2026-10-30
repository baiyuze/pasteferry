import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/i18n.dart';
import 'package:pasteferry_ui/main.dart' show AppScope;
import 'package:pasteferry_ui/mobile/mobile_app.dart';
import 'package:pasteferry_ui/mobile/transfers_tab.dart';

class _State extends AppState {
  final cancelled = <String>[];
  final resumed = <String>[];
  final deleted = <String>[];
  @override
  Future<void> cancelTransfer(String id) async => cancelled.add(id);
  @override
  Future<void> resumeTransfer(String id) async => resumed.add(id);
  @override
  Future<void> deleteTransfers({List<String>? ids, TransferDirection? clearAll}) async => deleted.addAll(ids ?? []);
}

void main() {
  for (final brightness in Brightness.values) {
    for (final status in ['done', 'active', 'interrupted']) {
      testWidgets('$brightness $status: narrow screen and large text keep filename and actions on separate rows', (tester) async {
        tester.view.physicalSize = const Size(320, 950);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final transfer = Transfer(
          id: 'batch', status: status, direction: TransferDirection.TRANSFER_DIRECTION_OUTGOING,
          deviceName: 'Very long computer name',
          items: [ClipItem(name: 'long-file-name-very-long-季度汇报-终稿-2026.pdf', size: Int64(1024))],
          totalBytes: Int64(1024), doneBytes: Int64(512), fileCount: Int64(1),
        );
        final state = _State()..debugSeed(status: Status(), config: Config(language: 'zh-Hans'),
          self: Device(id: 'self', platform: 'android'), transfers: [transfer]);
        addTearDown(state.dispose);
        await tester.pumpWidget(AppScope(state: state, child: MaterialApp(
          theme: buildMobileTheme(brightness), locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates, supportedLocales: supportedLocales,
          builder: (_, child) => MediaQuery(data: MediaQueryData(size: const Size(320,950), textScaler: TextScaler.linear(2)), child: child!),
          home: const Scaffold(body: TransfersTab()),
        )));
        await tester.pumpAndSettle();
        final title = find.text('long-file-name-very-long-季度汇报-终稿-2026.pdf');
        expect(title, findsOneWidget);
        final action = find.text(status == 'done' ? '删除' : '取消');
        await tester.ensureVisible(action);
        expect(tester.getTopLeft(action).dy, greaterThan(tester.getBottomLeft(title).dy));
        expect(tester.takeException(), isNull);
        await tester.tap(action);
        if (status == 'done') { expect(state.deleted, ['batch']); }
        else { expect(state.cancelled, ['batch']); }
        if (status == 'interrupted') {
          await tester.ensureVisible(find.text('继续'));
          await tester.tap(find.text('继续'));
          expect(state.resumed, ['batch']);
        }
        await tester.pumpWidget(const SizedBox());
      });
    }
  }
}
