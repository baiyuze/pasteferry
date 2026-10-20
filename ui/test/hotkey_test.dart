import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pasteferry_ui/hotkey.dart';

void main() {
  // 写法与后台服务的 config.NormalizeHotkey 一致，见 client-core/internal/config/hotkey_test.go
  test('解析设置里存的快捷键', () {
    expect(Hotkey.parse(''), Hotkey.fallback);
    expect(Hotkey.parse('alt+v')!.canonical, 'alt+v');
    expect(Hotkey.parse('Shift+Ctrl+V')!.canonical, 'ctrl+shift+v');
    expect(Hotkey.parse('cmd+option+space')!.canonical, 'alt+meta+space');
    expect(Hotkey.parse('f9')!.canonical, 'f9');
    for (final bad in ['v', 'alt', 'alt+alt+v', 'hyper+v', 'alt+vv', 'f0', 'f25']) {
      expect(Hotkey.parse(bad), isNull, reason: bad);
    }
  });

  test('等于默认值时存空字符串', () {
    expect(Hotkey.parse('alt+v')!.setting, '');
    expect(Hotkey.parse('ctrl+alt+v')!.setting, 'ctrl+alt+v');
  });

  test('Mac 上用符号显示，其他平台用键名', () {
    final h = Hotkey.parse('ctrl+alt+shift+meta+v')!;
    expect(h.display(mac: true), '⌃⌥⇧⌘V');
    expect(Hotkey.parse('alt+v')!.display(mac: true), '⌥V');
    expect(Hotkey.parse('alt+v')!.display(mac: false), 'Alt+V');
    expect(Hotkey.parse('ctrl+comma')!.display(mac: false), 'Ctrl+,');
    expect(Hotkey.parse('alt+f9')!.display(mac: true), '⌥F9');
  });

  test('录制时按下的键换成快捷键', () {
    expect(Hotkey.fromKey(LogicalKeyboardKey.keyV, PhysicalKeyboardKey.keyV, {'alt'})!.canonical, 'alt+v');
    // Mac 上按着 ⌥ 时逻辑键可能是 √，退回按物理位置认
    expect(
      Hotkey.fromKey(const LogicalKeyboardKey(0x221a), PhysicalKeyboardKey.keyV, {'alt'})!.canonical,
      'alt+v',
    );
    expect(Hotkey.fromKey(LogicalKeyboardKey.digit3, PhysicalKeyboardKey.digit3, {'ctrl', 'shift'})!.canonical,
        'ctrl+shift+3');
    expect(Hotkey.fromKey(LogicalKeyboardKey.altLeft, PhysicalKeyboardKey.altLeft, {'alt'}), isNull);
    expect(Hotkey.fromKey(LogicalKeyboardKey.keyV, PhysicalKeyboardKey.keyV, {})!.usable, isFalse);
    expect(Hotkey.fromKey(LogicalKeyboardKey.f9, PhysicalKeyboardKey.f9, {})!.usable, isTrue);
  });
}
