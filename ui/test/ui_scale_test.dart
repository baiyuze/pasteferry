import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/application_lifecycle.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/main.dart';
import 'package:pasteferry_ui/theme.dart';
import 'package:pasteferry_ui/widgets/common.dart';

/// 界面缩放（issue #7）：整个界面按倍数放大，点击、菜单、提示条的位置都对得上。

void _window(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// 用 [UiScale] 包起来的最小的 App；[scale] 变了就按新倍数重画
Widget _app(ValueListenable<double> scale, Widget home, {Size minSize = const Size(400, 300)}) {
  return ValueListenableBuilder<double>(
    valueListenable: scale,
    builder: (context, s, _) => MaterialApp(
      theme: buildTheme(Brightness.light),
      builder: (context, child) => UiScale(scale: s, minSize: minSize, child: child!),
      home: home,
    ),
  );
}

class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int n = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 100, top: 80),
          child: GestureDetector(
            onTap: () => setState(() => n++),
            child: SizedBox(key: const Key('box'), width: 100, height: 40, child: Text('$n')),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatefulWidget {
  const _Field();

  @override
  State<_Field> createState() => _FieldState();
}

class _FieldState extends State<_Field> {
  final _c = TextEditingController(text: 'hello world');

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(controller: _c, contextMenuBuilder: textContextMenu);
}

AppState _state() => AppState()
  ..debugSeed(
    status: Status(signalingConnected: true, version: '2.13.1'),
    config: Config(language: 'zh-Hans'),
    self: Device(id: 'self', name: 'MacBook Pro'),
  );

void main() {
  test('档位：归到最近的一档，往上往下挪一档，到头不动', () {
    expect(UiScale.snap(120), 125);
    expect(UiScale.snap(100), 100);
    expect(UiScale.snap(10), 90);
    expect(UiScale.snap(400), 150);
    expect(UiScale.step(100, 1), 110);
    expect(UiScale.step(100, -1), 90);
    expect(UiScale.step(150, 1), 150);
    expect(UiScale.step(90, -1), 90);
    expect(UiScale.step(118, 1), 150); // 118 先归到 125
  });

  test('窗口装不下时降倍数，但不低于 100%', () {
    const min = Size(760, 520);
    expect(UiScale.effective(1.5, const Size(1200, 800), min), 1.5);
    expect(UiScale.effective(1.5, const Size(1000, 800), min), closeTo(1000 / 760, 1e-9));
    expect(UiScale.effective(1.5, const Size(700, 500), min), 1);
    // 缩小不受影响
    expect(UiScale.effective(0.9, const Size(700, 500), min), 0.9);
  });

  testWidgets('放大以后：排版按缩小的窗口算，画出来整体放大，点击照样点得中', (tester) async {
    _window(tester, const Size(1000, 750));
    late Size inner;
    final scale = ValueNotifier(1.25);
    await tester.pumpWidget(_app(scale, Builder(builder: (context) {
      inner = MediaQuery.sizeOf(context);
      return const _Counter();
    })));
    expect(inner, const Size(800, 600));
    // getRect 是窗口坐标（放大以后的），getSize 是排版用的大小
    expect(tester.getSize(find.byKey(const Key('box'))), const Size(100, 40));
    expect(tester.getRect(find.byKey(const Key('box'))), const Rect.fromLTWH(125, 100, 125, 50));
    await tester.tap(find.byKey(const Key('box')));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('换倍数不丢页面状态', (tester) async {
    _window(tester, const Size(1000, 750));
    final scale = ValueNotifier(1.0);
    await tester.pumpWidget(_app(scale, const _Counter()));
    await tester.tap(find.byKey(const Key('box')));
    await tester.pump();
    scale.value = 1.5;
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    expect(tester.getRect(find.byKey(const Key('box'))).size, const Size(150, 60));
    scale.value = 0.9;
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('右键菜单出现在点的位置', (tester) async {
    _window(tester, const Size(1000, 750));
    await tester.pumpWidget(_app(ValueNotifier(1.5), Scaffold(
      body: Builder(
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onSecondaryTapUp: (d) => showMenu<void>(
            context: context,
            position: RelativeRect.fromRect(
              overlayPosition(context, d.globalPosition) & const Size(1, 1),
              Offset.zero & (Overlay.of(context).context.findRenderObject() as RenderBox).size,
            ),
            items: const [PopupMenuItem(child: Text('菜单项'))],
          ),
          child: const SizedBox.expand(),
        ),
      ),
    )));
    const at = Offset(450, 300);
    await tester.tapAt(at, buttons: kSecondaryButton, kind: PointerDeviceKind.mouse);
    await tester.pumpAndSettle();
    // 菜单项在点的位置的右下方不远（菜单本身有内边距）；没换算的话会跑到 1.5 倍远的地方
    final item = tester.getTopLeft(find.text('菜单项'));
    expect(item.dx, inInclusiveRange(at.dx, at.dx + 60));
    expect(item.dy, inInclusiveRange(at.dy, at.dy + 60));
  });

  testWidgets('输入框的右键菜单：靠近窗口右边时往回收，仍在点的地方旁边', (tester) async {
    _window(tester, const Size(1000, 750));
    await tester.pumpWidget(_app(ValueNotifier(1.5), const Scaffold(
      body: Padding(padding: EdgeInsets.fromLTRB(200, 200, 200, 0), child: _Field()),
    )));
    final field = tester.getRect(find.byType(TextField));
    // 菜单放大以后约 330 宽，点在 680：右边差一点放不下，往左收一点，不会翻到很远或跑出窗口
    final at = Offset(field.right - 20, field.center.dy);
    await tester.tapAt(at, buttons: kSecondaryButton, kind: PointerDeviceKind.mouse);
    await tester.pumpAndSettle();
    final item = tester.getRect(find.text('Select all'));
    expect(item.right, lessThan(1000));
    expect((item.left - at.dx).abs(), lessThan(40));
    expect(item.top - at.dy, closeTo(10.5, 1));
  }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

  testWidgets('输入框的右键菜单出现在点的位置', (tester) async {
    _window(tester, const Size(1000, 750));
    await tester.pumpWidget(_app(ValueNotifier(1.5), const Scaffold(
      body: Padding(padding: EdgeInsets.fromLTRB(200, 200, 200, 0), child: _Field()),
    )));
    // 点在输入框中间偏右：离输入框左上角越远，没修正时偏得越多（这里会偏出一百多像素）
    final field = tester.getRect(find.byType(TextField));
    final at = Offset(field.left + field.width * 0.6, field.center.dy);
    await tester.tapAt(at, buttons: kSecondaryButton, kind: PointerDeviceKind.mouse);
    await tester.pumpAndSettle();
    final item = find.text('Select all');
    expect(item, findsOneWidget);
    // 与 100% 时一样，菜单的左上角就在点的地方：按钮文字在它右下方 20×7（放大 1.5 倍）
    expect(tester.getTopLeft(item) - at, within(distance: 1, from: const Offset(30, 10.5)));
  }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

  testWidgets('提示条跟着放大', (tester) async {
    _window(tester, const Size(1000, 750));
    late BuildContext ctx;
    await tester.pumpWidget(_app(ValueNotifier(1.5), Builder(builder: (context) {
      ctx = context;
      return const Scaffold();
    })));
    showToast(ctx, '已复制');
    await tester.pump();
    final text = find.text('已复制');
    expect(text, findsOneWidget);
    expect(tester.getRect(text).height, closeTo(tester.getSize(text).height * 1.5, 0.01));
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  group('主窗口', () {
    for (final percent in UiScale.steps) {
      testWidgets('$percent%：各页面排得下，不溢出', (tester) async {
        // 原生外壳把最小窗口放大到 760×520 乘以倍数
        _window(tester, Size(760 * percent / 100, 520 * percent / 100));
        final state = _state();
        await state.theme.applyConfig(Config(uiScalePercent: percent));
        expect(state.theme.uiScale, percent / 100);
        await tester.pumpWidget(PasteFerryApp(state: state));
        await tester.pump();
        for (final label in ['收藏', '隔空传送', '设备', '设置', '复制记录']) {
          await tester.tap(find.text(label).first);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));
          expect(tester.takeException(), isNull, reason: '$percent% $label');
        }
      });
    }

    testWidgets('外观里能选界面缩放，显示现在的档位', (tester) async {
      _window(tester, const Size(1140, 780));
      final state = _state();
      await state.theme.applyConfig(Config(uiScalePercent: 150));
      await tester.pumpWidget(PasteFerryApp(state: state));
      await tester.tap(find.text('设置').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('外观').first);
      await tester.pumpAndSettle();
      expect(find.text('界面缩放'), findsOneWidget);
      for (final p in UiScale.steps) {
        expect(find.text('$p%'), findsOneWidget);
      }
      final seg = tester.widget<Segmented<int>>(find.byType(Segmented<int>));
      expect(seg.value, 150);
    });

    testWidgets('倍数变了告诉原生窗口', (tester) async {
      final calls = <MethodCall>[];
      const channel = MethodChannel('com.pasteferry.app/lifecycle');
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (c) async {
        calls.add(c);
        return null;
      });
      addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, null));
      await setWindowUiScale(1.25);
      expect(calls.single.method, 'setUiScale');
      expect(calls.single.arguments, {'scale': 1.25});
    });
  });
}
