import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/i18n.dart';
import 'package:pasteferry_ui/main.dart' show AppScope;
import 'package:pasteferry_ui/mobile/mobile_app.dart';
import 'package:pasteferry_ui/mobile/transfers_tab.dart';
import 'package:pasteferry_ui/mobile/ui.dart';

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
      testWidgets('$brightness $status: narrow screen and large text keep compact controls to the right', (tester) async {
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
        final action = find.byTooltip(status == 'done' ? '删除' : status == 'interrupted' ? '更多操作' : '取消');
        await tester.ensureVisible(action);
        expect(tester.getTopLeft(action).dx, greaterThanOrEqualTo(tester.getTopRight(title).dx));
        expect(tester.takeException(), isNull);
        await tester.tap(action);
        if (status == 'interrupted') { await tester.pumpAndSettle(); await tester.tap(find.text('取消')); await tester.pumpAndSettle(); }
        if (status == 'done') { expect(state.deleted, ['batch']); }
        else { expect(state.cancelled, ['batch']); }
        if (status == 'interrupted') {
          await tester.ensureVisible(find.byTooltip('继续'));
          await tester.tap(find.byTooltip('继续'));
          expect(state.resumed, ['batch']);
        }
        await tester.pumpWidget(const SizedBox());
      });
    }
  }
  testWidgets('received files keep compact controls on the right', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final state = _State()..debugSeed(status: Status(), config: Config(language: 'zh-Hans'),
      self: Device(id: 'self', platform: 'android'), transfers: [Transfer(
        id: 'received', status: 'done', direction: TransferDirection.TRANSFER_DIRECTION_INCOMING,
        deviceName: 'MacBook', items: [ClipItem(name: 'report.pdf', size: Int64(1024))], totalBytes: Int64(1024),
      )]);
    addTearDown(state.dispose);
    await tester.pumpWidget(AppScope(state: state, child: MaterialApp(
      theme: buildMobileTheme(Brightness.light), locale: const Locale('zh'),
      builder: (_, child) => MediaQuery(data: const MediaQueryData(size: Size(360, 800), padding: EdgeInsets.only(top: 32)), child: child!),
      localizationsDelegates: AppLocalizations.localizationsDelegates, supportedLocales: supportedLocales,
      home: const Scaffold(body: TransfersTab()),
    )));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byType(MobileHeader)).dy, greaterThanOrEqualTo(32));
    final title = find.text('report.pdf');
    expect(tester.getTopLeft(find.byTooltip('保存')).dx, greaterThanOrEqualTo(tester.getTopRight(title).dx));
    expect(tester.getSize(find.byType(MobileTransferCard)).height, lessThan(105));
    await tester.tap(find.byTooltip('更多操作'));
    await tester.pumpAndSettle();
    expect(find.text('分享'), findsOneWidget);
    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();
    expect(state.deleted, ['received']);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

}
