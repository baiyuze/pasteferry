import 'package:flutter/widgets.dart';

import 'picker_state.dart';
import 'picker_view.dart';

/// 快捷粘贴窗口进程的入口：界面程序带着 --picker 启动（Mac 上是 PasteFerryPicker.app 用同一份 Dart 代码启动）。
void runPicker() {
  WidgetsFlutterBinding.ensureInitialized();
  final state = PickerState();
  runApp(PickerApp(state: state));
  state.start();
}
