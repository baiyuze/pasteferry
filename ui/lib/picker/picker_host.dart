import 'package:flutter/services.dart';

/// 快捷粘贴窗口的原生外壳（Mac 的 Swift、Windows 的 C++、Linux 的 C）。
/// 全局快捷键、窗口的显示与隐藏、记下并还原原来的窗口、模拟粘贴键都由它做，Dart 只管列表与按键。
/// 通道名与方法名三个平台一致，见 design/quick-paste-and-favorites.md 第 6、7 节。
///
/// Dart → 原生：
///   setHotkey {hotkey, enabled} → {ok, error, source, hotkey}
///   setSuspended {suspended}       设置页录制快捷键期间暂停
///   pasteStatus → {available, reason, targetElevated}   targetElevated 只有 Windows 给
///   requestPermission              Mac：请求辅助功能权限
///   show / hide                    hide 会把焦点还给原来的窗口
///   commit {paste} → {pasted, reason}   隐藏窗口、还原焦点，paste 时再模拟粘贴键
///   ready                          Dart 准备好了；之前按下的快捷键这时才显示窗口
///   quit                           关掉快捷粘贴时退出进程
/// 原生 → Dart：
///   onShow                         窗口刚显示出来
///   onHide                         窗口被收起（点了窗口外面、切到别的程序）
///   onHotkeyChanged {hotkey}       Wayland 上用户在系统设置里改了快捷键
///   onFocusIn                      Linux：窗口拿到了焦点，重新打开输入法（见 linux/runner/picker_application.cc）
class PickerHost {
  PickerHost([MethodChannel? channel]) : _ch = channel ?? const MethodChannel('pasteferry/picker');

  final MethodChannel _ch;

  VoidCallback? onShow;
  VoidCallback? onHide;
  ValueChanged<String>? onHotkeyChanged;

  void listen() {
    _ch.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onShow':
          onShow?.call();
        case 'onHide':
          onHide?.call();
        case 'onHotkeyChanged':
          onHotkeyChanged?.call('${(call.arguments as Map?)?['hotkey'] ?? ''}');
        case 'onFocusIn':
          // 和搜索框连着输入法时 TextInputConnection.show 发的是同一条：引擎据此调用 gtk_im_context_focus_in
          await SystemChannels.textInput.invokeMethod<void>('TextInput.show');
      }
      return null;
    });
  }

  Future<HotkeyResult> setHotkey(String hotkey, {required bool enabled}) async {
    final r = await _invoke('setHotkey', {'hotkey': hotkey, 'enabled': enabled});
    return HotkeyResult(
      ok: r?['ok'] == true,
      error: '${r?['error'] ?? (r == null ? 'unsupported' : '')}',
      source: '${r?['source'] ?? 'native'}',
      hotkey: '${r?['hotkey'] ?? hotkey}',
    );
  }

  Future<void> setSuspended(bool suspended) => _invoke('setSuspended', {'suspended': suspended});

  Future<PasteStatus> pasteStatus() async {
    final r = await _invoke('pasteStatus');
    return PasteStatus(
      available: r?['available'] == true,
      reason: '${r?['reason'] ?? 'unsupported'}',
      targetElevated: r?['targetElevated'] == true,
    );
  }

  Future<void> requestPermission() => _invoke('requestPermission');
  Future<void> show() => _invoke('show');
  Future<void> hide() => _invoke('hide');
  Future<void> ready() => _invoke('ready');
  Future<void> quit() => _invoke('quit');

  Future<CommitResult> commit({required bool paste}) async {
    final r = await _invoke('commit', {'paste': paste});
    return CommitResult(pasted: r?['pasted'] == true, reason: '${r?['reason'] ?? ''}');
  }

  /// 原生外壳没实现（界面测试、在开发机上直接 flutter run）时返回 null，不抛异常。
  Future<Map<Object?, Object?>?> _invoke(String method, [Map<String, Object?>? args]) async {
    try {
      final r = await _ch.invokeMethod<Object?>(method, args);
      return r is Map ? r : const {};
    } on MissingPluginException {
      return null;
    }
  }
}

class HotkeyResult {
  const HotkeyResult({required this.ok, required this.error, required this.source, required this.hotkey});
  final bool ok;

  /// in_use、invalid、unsupported，或者平台给的原文
  final String error;

  /// native、portal、system_shortcut
  final String source;
  final String hotkey;
}

class PasteStatus {
  const PasteStatus({required this.available, required this.reason, this.targetElevated = false});
  final bool available;

  /// not_trusted（Mac 没授予辅助功能）、wayland
  final String reason;

  /// 呼出前的窗口以管理员身份运行（Windows）：系统不许普通程序给它发按键，这一次只能放进剪贴板
  final bool targetElevated;
}

class CommitResult {
  const CommitResult({required this.pasted, required this.reason});
  final bool pasted;

  /// 没粘贴的原因：not_trusted、wayland、elevated（目标窗口以管理员身份运行）、failed
  final String reason;
}
