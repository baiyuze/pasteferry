import 'dart:io';

import 'package:flutter/services.dart';

/// 呼出快捷粘贴窗口的快捷键。写法与后台服务的 config.NormalizeHotkey 相同：
/// 修饰键在前、按 ctrl、alt、shift、meta 的顺序，最后是一个键，用 + 连起来，全小写，如 "alt+v"。
/// meta 是 Mac 上的 ⌘、Windows 上的 Win 键、Linux 上的 Super 键。快捷窗口的原生外壳按同样的写法解析。
class Hotkey {
  const Hotkey(this.modifiers, this.key);

  /// 修饰键，按 [order] 排好
  final List<String> modifiers;
  final String key;

  static const order = ['ctrl', 'alt', 'shift', 'meta'];

  /// 默认的 ⌥V / Alt+V。设置里存空字符串就是它
  static const fallback = Hotkey(['alt'], 'v');

  static const _aliases = {
    'control': 'ctrl', 'option': 'alt', 'opt': 'alt',
    'cmd': 'meta', 'command': 'meta', 'win': 'meta', 'super': 'meta',
  };

  static const _named = {
    'space', 'tab', 'enter', 'backspace', 'delete', 'insert', 'home', 'end', 'pageup', 'pagedown',
    'up', 'down', 'left', 'right', 'comma', 'period', 'slash', 'semicolon', 'quote',
    'bracketleft', 'bracketright', 'backslash', 'minus', 'equal', 'backquote',
  };

  /// 设置里存的字符串 → 快捷键。空字符串是默认的；写不对的返回 null。
  static Hotkey? parse(String s) {
    s = s.trim().replaceAll(' ', '').toLowerCase();
    if (s.isEmpty) return fallback;
    final parts = s.split('+');
    final key = parts.removeLast();
    final mods = <String>{};
    for (var p in parts) {
      p = _aliases[p] ?? p;
      if (!order.contains(p) || !mods.add(p)) return null;
    }
    if (!isValidKey(key)) return null;
    if (mods.isEmpty && !isFunctionKey(key)) return null;
    return Hotkey([for (final m in order) if (mods.contains(m)) m], key);
  }

  static bool isFunctionKey(String k) {
    final m = RegExp(r'^f([1-9][0-9]?)$').firstMatch(k);
    if (m == null) return false;
    final n = int.parse(m.group(1)!);
    return n >= 1 && n <= 24;
  }

  static bool isValidKey(String k) => isFunctionKey(k) || _named.contains(k) || RegExp(r'^[a-z0-9]$').hasMatch(k);

  /// 设置里存的写法。等于默认的时候存空字符串，以后默认值变了跟着变
  String get setting => this == fallback ? '' : canonical;

  String get canonical => [...modifiers, key].join('+');

  /// 显示给用户看的写法：Mac 上 ⌃⌥⇧⌘V，Windows 上 Ctrl+Alt+Shift+Win+V，Linux 上 Win 写成 Super。
  String display({bool? mac}) {
    final isMac = mac ?? Platform.isMacOS;
    if (isMac) {
      const symbols = {'ctrl': '⌃', 'alt': '⌥', 'shift': '⇧', 'meta': '⌘'};
      return '${modifiers.map((m) => symbols[m]).join()}${_keyLabel(key, mac: true)}';
    }
    final names = {'ctrl': 'Ctrl', 'alt': 'Alt', 'shift': 'Shift', 'meta': Platform.isLinux ? 'Super' : 'Win'};
    return [...modifiers.map((m) => names[m]!), _keyLabel(key, mac: false)].join('+');
  }

  static String _keyLabel(String k, {required bool mac}) {
    const punct = {
      'comma': ',', 'period': '.', 'slash': '/', 'semicolon': ';', 'quote': "'", 'bracketleft': '[',
      'bracketright': ']', 'backslash': r'\', 'minus': '-', 'equal': '=', 'backquote': '`',
      'up': '↑', 'down': '↓', 'left': '←', 'right': '→',
    };
    const macNamed = {'enter': '↩', 'tab': '⇥', 'backspace': '⌫', 'delete': '⌦', 'space': 'Space',
        'home': '↖', 'end': '↘', 'pageup': '⇞', 'pagedown': '⇟'};
    const pcNamed = {'enter': 'Enter', 'tab': 'Tab', 'backspace': 'Backspace', 'delete': 'Delete', 'space': 'Space',
        'insert': 'Insert', 'home': 'Home', 'end': 'End', 'pageup': 'PageUp', 'pagedown': 'PageDown'};
    return punct[k] ?? (mac ? macNamed[k] : pcNamed[k]) ?? k.toUpperCase();
  }

  /// 录制快捷键时，把按下的键换成快捷键。按的是修饰键本身、或者不认识的键时返回 null。
  /// 不带修饰键的普通键也返回一个结果，由调用方提示「要带上修饰键」。
  static Hotkey? fromKey(LogicalKeyboardKey logical, PhysicalKeyboardKey physical, Set<String> modifiers) {
    final key = _keyName(logical) ?? _physicalName(physical);
    if (key == null) return null;
    return Hotkey([for (final m in order) if (modifiers.contains(m)) m], key);
  }

  /// 当前按着的修饰键。
  static Set<String> pressedModifiers() {
    final kb = HardwareKeyboard.instance;
    return {
      if (kb.isControlPressed) 'ctrl',
      if (kb.isAltPressed) 'alt',
      if (kb.isShiftPressed) 'shift',
      if (kb.isMetaPressed) 'meta',
    };
  }

  /// 是不是能当快捷键用（不带修饰键时只能是功能键）。
  bool get usable => modifiers.isNotEmpty || isFunctionKey(key);

  static final _logicalNames = <LogicalKeyboardKey, String>{
    LogicalKeyboardKey.space: 'space', LogicalKeyboardKey.tab: 'tab', LogicalKeyboardKey.enter: 'enter',
    LogicalKeyboardKey.backspace: 'backspace', LogicalKeyboardKey.delete: 'delete',
    LogicalKeyboardKey.insert: 'insert', LogicalKeyboardKey.home: 'home', LogicalKeyboardKey.end: 'end',
    LogicalKeyboardKey.pageUp: 'pageup', LogicalKeyboardKey.pageDown: 'pagedown',
    LogicalKeyboardKey.arrowUp: 'up', LogicalKeyboardKey.arrowDown: 'down',
    LogicalKeyboardKey.arrowLeft: 'left', LogicalKeyboardKey.arrowRight: 'right',
    LogicalKeyboardKey.comma: 'comma', LogicalKeyboardKey.period: 'period', LogicalKeyboardKey.slash: 'slash',
    LogicalKeyboardKey.semicolon: 'semicolon', LogicalKeyboardKey.quote: 'quote',
    LogicalKeyboardKey.bracketLeft: 'bracketleft', LogicalKeyboardKey.bracketRight: 'bracketright',
    LogicalKeyboardKey.backslash: 'backslash', LogicalKeyboardKey.minus: 'minus',
    LogicalKeyboardKey.equal: 'equal', LogicalKeyboardKey.backquote: 'backquote',
  };

  static String? _keyName(LogicalKeyboardKey k) {
    final named = _logicalNames[k];
    if (named != null) return named;
    final label = k.keyLabel.toLowerCase();
    if (RegExp(r'^[a-z0-9]$').hasMatch(label)) return label;
    if (isFunctionKey(label)) return label;
    return null;
  }

  /// 按着 ⌥ 时有的布局给出的逻辑键是别的字符（如 √），退回按物理位置认字母与数字（USB HID 键码）。
  static String? _physicalName(PhysicalKeyboardKey k) {
    final u = k.usbHidUsage;
    final a = PhysicalKeyboardKey.keyA.usbHidUsage;
    if (u >= a && u <= PhysicalKeyboardKey.keyZ.usbHidUsage) return String.fromCharCode(0x61 + u - a);
    final one = PhysicalKeyboardKey.digit1.usbHidUsage;
    if (u >= one && u <= PhysicalKeyboardKey.digit9.usbHidUsage) return '${1 + u - one}';
    if (k == PhysicalKeyboardKey.digit0) return '0';
    return null;
  }

  @override
  bool operator ==(Object other) => other is Hotkey && other.canonical == canonical;

  @override
  int get hashCode => canonical.hashCode;

  @override
  String toString() => canonical;
}

/// 快捷窗口里按住它再按 1–9 粘贴对应那一条的修饰键（Config.quick_paste_index_modifier）。
/// 默认 alt：Mac 上是 ⌥。Windows、Linux 上不能选 meta：Win 键加数字是系统切换任务栏程序用的。
abstract final class IndexModifier {
  static List<String> get choices => Platform.isMacOS ? const ['alt', 'meta', 'ctrl'] : const ['alt', 'ctrl'];

  static String of(String setting) => choices.contains(setting) ? setting : 'alt';

  /// 写在序号前面：⌥1、Alt+1
  static String label(String modifier) => Platform.isMacOS
      ? const {'alt': '⌥', 'meta': '⌘', 'ctrl': '⌃'}[modifier]!
      : const {'alt': 'Alt+', 'ctrl': 'Ctrl+'}[modifier]!;
}
