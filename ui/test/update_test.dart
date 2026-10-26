import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/main.dart';
import 'package:pasteferry_ui/pages/settings_page.dart';
import 'package:pasteferry_ui/widgets/common.dart';
import 'package:pasteferry_ui/widgets/update_dialog.dart';

/// 不连后台服务：检查、下载、安装都由测试给出结果。
class UpdateTestState extends AppState {
  UpdateTestState({String language = 'zh-Hans', this.info, String available = '', UpdateResult? last}) {
    final status = Status(deviceId: 'abcdefghijklmnopqrstuvwxyz', version: '2.3.0', updateAvailable: available);
    if (last != null) status.lastUpdate = last;
    debugSeed(
      status: status,
      config: Config(serviceMode: ServiceMode.SERVICE_MODE_LAN, language: language),
      self: Device(id: 'abcdefghijklmnopqrstuvwxyz'),
    );
  }

  UpdateInfo? info;
  String? language;
  final progress = StreamController<UpdateProgress>();
  String? installed, skipped;

  @override
  Future<UpdateInfo> checkForUpdate(String language) async {
    this.language = language;
    return info!;
  }

  @override
  Stream<UpdateProgress> downloadUpdate(String version) => progress.stream;

  @override
  Future<void> installUpdate(String version) async => installed = version;

  @override
  Future<void> skipUpdate(String version) async => skipped = version;

  @override
  Future<void> updateConfig(Config next) async =>
      debugSeed(status: status!, config: next, self: self!);
}

UpdateInfo available({String blocker = '', String kind = 'mac-app'}) => UpdateInfo(
      currentVersion: '2.3.0',
      latestVersion: '2.3.2',
      available: true,
      downloadBytes: Int64(24 * 1024 * 1024),
      installBlocker: blocker,
      installKind: kind,
      releases: [
        UpdateRelease(version: '2.3.2', date: '2026-11-02', changes: ['新增甲'], fixes: ['修复乙']),
        UpdateRelease(version: '2.3.1', date: '2026-10-25', changes: ['新增丙']),
      ],
    );

Future<void> openDialog(WidgetTester tester, AppState state) async {
  await tester.pumpWidget(PasteFerryApp(state: state));
  await tester.pumpAndSettle();
  final context = tester.element(find.byType(Shell));
  unawaited(showUpdateDialog(context));
  await tester.pumpAndSettle();
}

void main() {
  late bool quit;
  setUp(() {
    quit = false;
    quitForUpdate = () => quit = true;
  });

  testWidgets('up to date', (tester) async {
    final state = UpdateTestState(info: UpdateInfo(currentVersion: '2.3.0', latestVersion: '2.3.0'));
    await openDialog(tester, state);
    expect(state.language, 'zh-Hans');
    expect(find.text('隔空贴 2.3.0 已是最新版本。'), findsOneWidget);
  });

  testWidgets('lists every newer release, then downloads, installs and quits', (tester) async {
    final state = UpdateTestState(info: available());
    await openDialog(tester, state);
    expect(find.text('有新版本：隔空贴 2.3.2'), findsOneWidget);
    expect(find.text('2.3.2  ·  2026-11-02'), findsOneWidget);
    expect(find.text('2.3.1  ·  2026-10-25'), findsOneWidget);
    for (final t in ['新增甲', '修复乙', '新增丙']) {
      expect(find.text(t), findsOneWidget);
    }
    expect(find.text('当前版本 2.3.0，需要下载 24.0 MB。'), findsOneWidget);

    await tester.tap(find.text('下载并安装'));
    await tester.pump();
    state.progress.add(UpdateProgress(downloaded: Int64(12 * 1024 * 1024), total: Int64(24 * 1024 * 1024)));
    await tester.pump();
    await tester.pump();
    expect(find.text('正在下载 12.0 MB / 24.0 MB'), findsOneWidget);
    expect(tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator)).value, 0.5);

    state.progress.add(UpdateProgress(done: true));
    await state.progress.close();
    await tester.pump();
    await tester.pump();
    expect(state.installed, '2.3.2');
    expect(find.text('正在安装，隔空贴会自动重新打开。'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(quit, isTrue);
  });

  testWidgets('a .deb install warns about the password prompt', (tester) async {
    final state = UpdateTestState(info: available(kind: 'linux-deb'));
    await openDialog(tester, state);
    await tester.tap(find.text('下载并安装'));
    await tester.pump();
    state.progress.add(UpdateProgress(done: true));
    await state.progress.close();
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('系统会请你输入密码'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('a broken download offers retry and the download page', (tester) async {
    final state = UpdateTestState(info: available());
    await openDialog(tester, state);
    await tester.tap(find.text('下载并安装'));
    await tester.pump();
    state.progress.addError(Exception('mirror down'));
    await tester.pumpAndSettle();
    expect(find.text('下载没有完成。可以重试，或者到下载页手动下载新版本。'), findsOneWidget);
    expect(find.text('打开下载页'), findsOneWidget);
    expect(find.text('重试'), findsOneWidget);
    expect(quit, isFalse);
  });

  testWidgets('an install that cannot update itself only offers the download page', (tester) async {
    final state = UpdateTestState(info: available(blocker: 'must_move'));
    await openDialog(tester, state);
    expect(find.textContaining('直接从磁盘映像里打开'), findsOneWidget);
    expect(find.text('下载并安装'), findsNothing);
    expect(find.text('打开下载页'), findsOneWidget);
  });

  testWidgets('skipping remembers the version', (tester) async {
    final state = UpdateTestState(info: available());
    await openDialog(tester, state);
    await tester.tap(find.text('跳过这个版本'));
    await tester.pumpAndSettle();
    expect(state.skipped, '2.3.2');
    expect(find.byType(UpdateDialog), findsNothing);
  });

  testWidgets('the sidebar hints at an available version and opens the dialog', (tester) async {
    final state = UpdateTestState(info: available(), available: '2.3.2');
    await tester.pumpWidget(PasteFerryApp(state: state));
    await tester.pumpAndSettle();
    await tester.tap(find.text('新版本 2.3.2 可用'));
    await tester.pumpAndSettle();
    expect(find.byType(UpdateDialog), findsOneWidget);
  });

  testWidgets('after an automatic update the result is shown once', (tester) async {
    final state = UpdateTestState(
      last: UpdateResult(fromVersion: '2.3.0', toVersion: '2.3.2', ok: true, atUnix: Int64(1)),
    );
    await tester.pumpWidget(PasteFerryApp(state: state));
    await tester.pumpAndSettle();
    expect(find.text('已更新到 2.3.2'), findsOneWidget);
  });

  testWidgets('the settings switch turns automatic checks off', (tester) async {
    final state = UpdateTestState();
    await tester.pumpWidget(PasteFerryApp(state: state));
    await tester.pumpAndSettle();
    await tester.tap(find.text('设置').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('关于'));
    await tester.pumpAndSettle();
    final page = find.byType(SettingsPage);
    await tester.scrollUntilVisible(find.text('自动检查更新'), 200,
        scrollable: find.descendant(of: page, matching: find.byType(Scrollable)).first);
    final row = find.ancestor(of: find.text('自动检查更新'), matching: find.byType(SettingRow));
    final toggle = find.descendant(of: row, matching: find.byType(SmallSwitch));
    // 各平台的设置页行数不同：文字进入视野时开关可能还在屏幕边缘外
    await tester.ensureVisible(toggle);
    await tester.pumpAndSettle();
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(state.config!.updateCheckDisabled, isTrue);
    expect(state.autoCheckUpdates, isFalse);
  });

  for (final language in ['en', 'zh-Hans', 'zh-Hant-TW', 'zh-Hant-HK', 'ja']) {
    testWidgets('update dialog fits the minimum window in $language', (tester) async {
      tester.view.physicalSize = const Size(760, 560);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final long = List.generate(12, (i) => 'A fairly long line describing change number $i in some detail.');
      final state = UpdateTestState(
        language: language,
        info: available(blocker: 'read_only')
          ..releases.first.changes.addAll(long)
          ..releases.first.fixes.addAll(long),
      );
      await openDialog(tester, state);
      expect(find.byType(UpdateDialog), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
