import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pasteferry_ui/theme.dart';
import 'package:pasteferry_ui/widgets/common.dart';

void main() {
  Future<int Function()> open(WidgetTester tester, {TextDirection direction = TextDirection.ltr}) async {
    var backs = 0;
    tester.view.physicalSize = const Size(900, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(Brightness.light),
      home: Directionality(
        textDirection: direction,
        child: Scaffold(
          body: Column(children: [
            PageHeader(title: 'General', backLabel: 'Settings', onBack: () => backs++),
          ]),
        ),
      ),
    ));
    return () => backs;
  }

  // 标题栏透明、内容铺到窗口顶部，但最上面一条仍归系统：在那里按下是拖动窗口，点不到界面
  testWidgets('返回链接整个在 macOS 标题栏下面', (tester) async {
    await open(tester);
    final link = tester.getRect(find.byType(GestureDetector).first);
    expect(link.top, greaterThanOrEqualTo(titleBarHeight));
  });

  testWidgets('返回链接的可点范围比文字大：上下、左右多出一圈也算', (tester) async {
    final backs = await open(tester);
    final text = tester.getRect(find.text('Settings'));
    final icon = tester.getRect(find.byType(Icon).first);
    for (final point in [
      text.center,
      Offset(text.center.dx, text.top - 5), // 文字上方
      Offset(text.center.dx, text.bottom + 5), // 文字下方
      Offset(icon.left - 6, icon.center.dy), // 箭头左边
      Offset(text.right + 6, text.center.dy), // 文字右边
    ]) {
      final before = backs();
      await tester.tapAt(point);
      await tester.pump();
      expect(backs(), before + 1, reason: '点 $point（文字 $text，箭头 $icon，可点 ${tester.getRect(find.byType(GestureDetector).first)}）');
    }
    expect(backs(), 5);
    // 离得远的地方不算：标题、同一行很靠右的地方
    await tester.tap(find.text('General'));
    await tester.tapAt(Offset(text.right + 200, text.center.dy));
    await tester.pump();
    expect(backs(), 5);
  });

  testWidgets('文字的位置与页面标题对齐，多出的点击范围不挪动它', (tester) async {
    await open(tester);
    expect(tester.getRect(find.byType(Icon).first).left, closeTo(tester.getRect(find.text('General')).left, 2));
  });

  testWidgets('从右到左时返回链接在右边，同样能点', (tester) async {
    final backs = await open(tester, direction: TextDirection.rtl);
    final text = tester.getRect(find.text('Settings'));
    expect(text.center.dx, greaterThan(450));
    expect(tester.getRect(find.byType(Icon).first).right, closeTo(tester.getRect(find.text('General')).right, 2));
    await tester.tapAt(Offset(text.left - 6, text.center.dy));
    await tester.pump();
    expect(backs(), 1);
  });
}
