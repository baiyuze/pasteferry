import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/i18n.dart';
import 'package:pasteferry_ui/main.dart' show AppScope;
import 'package:pasteferry_ui/mobile/mobile_app.dart';
import 'package:pasteferry_ui/mobile/send_tab.dart';
import 'package:pasteferry_ui/mobile/transfers_tab.dart';
import 'package:pasteferry_ui/widgets/common.dart';

class _State extends AppState {
  final batches = <List<String>>[];
  final destinations = <String>[];

  @override
  Future<ClipRecord> submitFiles(List<String> paths) async {
    batches.add(paths);
    return ClipRecord(id: 'submitted');
  }

  @override
  Future<Transfer> sendFiles(String deviceId, List<String> paths, {bool allowRelay = false, String note = ''}) async {
    destinations.add(deviceId);
    batches.add(paths);
    return Transfer(id: 'batch', fileCount: Int64(paths.length));
  }
}

Map<String, Object> _file(String name, {String? path}) => {
  'path': path ?? '/cache/$name', 'name': name, 'size': 16, 'id': 'content://files/$name',
};

void main() {
  const channel = MethodChannel('pasteferry/host');
  for (final transfers in [false, true]) {
    group(transfers ? '隔空传送' : '发送照片与文件', () {
      late _State state;
      late List<List<Map<String, Object>>> results;
      late List<bool> sources;

      setUp(() {
        state = _State()..debugSeed(
          status: Status(), config: Config(language: 'zh-Hans'),
          self: Device(id: 'self', platform: 'android'),
          peers: [Device(id: 'pc', name: 'Computer', online: true, receivesFiles: true)],
        );
        results = [];
        sources = [];
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'pickFiles') {
            sources.add((call.arguments as Map)['photos'] as bool);
            return results.removeAt(0);
          }
          return null;
        });
      });
      tearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
        state.dispose();
      });

      Future<void> open(WidgetTester tester) async {
        tester.view.physicalSize = const Size(412, 915);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(AppScope(state: state, child: MaterialApp(
          theme: buildMobileTheme(Brightness.light),
          locale: const Locale('zh'),
          supportedLocales: supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (_, child) => ToastScope(top: true, child: child!),
          home: Scaffold(body: transfers ? const TransfersTab() : const SendTab()),
        )));
        await tester.pumpAndSettle();
        await tester.tap(find.text(transfers ? '选择文件…' : '照片或文件'));
        await tester.pumpAndSettle();
      }

      Future<void> choose(WidgetTester tester, bool photos) async {
        await tester.tap(find.text(photos ? '选择照片…' : '选择文件…').last);
        await tester.pumpAndSettle();
      }

      for (final photos in [true, false]) {
        testWidgets('一次选择多${photos ? '张照片' : '个文件'}，确认后整批发送', (tester) async {
          results.add([_file('one.jpg'), _file('two.jpg'), _file('three.txt')]);
          await open(tester);
          await choose(tester, photos);
          for (final name in ['one.jpg', 'two.jpg', 'three.txt']) {
            expect(find.text(name), findsOneWidget);
          }
          expect(sources, [photos]);
          expect(state.batches, isEmpty);
          await tester.tap(find.widgetWithText(FilledButton, '发送').last);
          await tester.pumpAndSettle();
          expect(state.batches, [['/cache/one.jpg', '/cache/two.jpg', '/cache/three.txt']]);
          if (transfers) expect(state.destinations, ['pc']);
          await tester.pump(const Duration(seconds: 7));
          await tester.pumpAndSettle();
        });
      }

      testWidgets('追加可混选并按来源去重；取消选择器只返回确认，不误发', (tester) async {
        results.addAll([
          [_file('one.jpg'), _file('two.jpg')],
          [_file('one.jpg', path: '/cache/new-copy.jpg'), _file('three.txt')],
          [],
        ]);
        await open(tester);
        await choose(tester, true);
        await tester.tap(find.text('继续添加'));
        await tester.pumpAndSettle();
        await choose(tester, false);
        expect(find.text('one.jpg'), findsOneWidget);
        expect(find.text('three.txt'), findsOneWidget);
        await tester.tap(find.text('继续添加'));
        await tester.pumpAndSettle();
        await choose(tester, false);
        expect(state.batches, isEmpty);
        expect(find.text('three.txt'), findsOneWidget);
        await tester.tap(find.widgetWithText(FilledButton, '发送').last);
        await tester.pumpAndSettle();
        expect(state.batches.single, ['/cache/one.jpg', '/cache/two.jpg', '/cache/three.txt']);
        await tester.pump(const Duration(seconds: 7));
        await tester.pumpAndSettle();
      });

      testWidgets('取消确认不发送；首次取消选择器也不发送', (tester) async {
        results.addAll([[_file('one.jpg')], []]);
        await open(tester);
        await choose(tester, false);
        await tester.tap(find.text('取消'));
        await tester.pumpAndSettle();
        expect(state.batches, isEmpty);
        await tester.tap(find.text(transfers ? '选择文件…' : '照片或文件'));
        await tester.pumpAndSettle();
        await choose(tester, true);
        expect(state.batches, isEmpty);
        expect(find.text('继续添加'), findsNothing);
      });
    });
  }
}
