import 'dart:io';

import 'background_service.dart';
import 'hotkey.dart';

/// 快捷粘贴窗口进程的登记。见 design/quick-paste-and-favorites.md 第 6.1 节。
///
/// Mac 上它是 App 包里单独的辅助程序 PasteFerryPicker.app，由界面登记成第二个 LaunchAgent：
/// 不能让后台服务直接拉起它，系统按拉起它的进程记辅助功能权限，授权列表里会显示成后台服务。
/// Windows、Linux 上快捷窗口由后台服务拉起（界面程序加 --picker），这里什么都不做。
abstract class QuickPasteService {
  factory QuickPasteService() =>
      Platform.isMacOS ? MacQuickPasteService() : const _ManagedByDaemon();

  /// App 里带着快捷窗口（开发构建没有）
  bool get available;

  /// 已登记，并且指向当前这个 App
  Future<bool> installed();

  /// 登记并启动。重复调用即为修复
  Future<void> install();

  /// 停止并取消登记
  Future<void> uninstall();

  /// 按当前的 App 重新拉起。用于 App 更新后
  Future<void> restart();
  Future<void> stop();
  Future<void> setLaunchAtLogin(bool enabled);
}

class _ManagedByDaemon implements QuickPasteService {
  const _ManagedByDaemon();
  @override
  bool get available => false;
  @override
  Future<bool> installed() async => true;
  @override
  Future<void> install() async {}
  @override
  Future<void> uninstall() async {}
  @override
  Future<void> restart() async {}
  @override
  Future<void> stop() async {}
  @override
  Future<void> setLaunchAtLogin(bool enabled) async {}
}

class MacQuickPasteService implements QuickPasteService {
  MacQuickPasteService({
    String? executable,
    String? home,
    this.serviceLabel = label,
    this.environment = const {},
    Future<ProcessResult> Function(String, List<String>)? run,
  }) : _executable = executable ?? Platform.resolvedExecutable,
       _home = home ?? Platform.environment['HOME'] ?? '',
       _run = run ?? ((command, args) => Process.run(command, args));

  static const label = 'com.pasteferry.picker';
  static const _appBundleId = 'com.pasteferry.app';

  final String _executable;
  final String _home;
  final String serviceLabel;
  final Map<String, String> environment;
  final Future<ProcessResult> Function(String, List<String>) _run;

  /// `…/PasteFerry.app`，由可执行文件 `…/PasteFerry.app/Contents/MacOS/PasteFerry` 上溯三级。
  String get _bundle => File(_executable).parent.parent.parent.path;

  String get helperBinary =>
      '$_bundle/Contents/Helpers/PasteFerryPicker.app/Contents/MacOS/PasteFerryPicker';
  String get plistPath => '$_home/Library/LaunchAgents/$serviceLabel.plist';
  String get logPath => '$_home/Library/Logs/PasteFerry/picker.log';
  String get runtimePath =>
      '$_home/Library/Application Support/PasteFerry/picker.plist';

  @override
  bool get available =>
      File(helperBinary).existsSync() && !_bundle.startsWith('/Volumes/');

  @override
  Future<bool> installed() async {
    final plist = File(runtimePath).existsSync()
        ? File(runtimePath)
        : File(plistPath);
    if (!await plist.exists()) return false;
    if (!(await plist.readAsString()).contains(helperBinary)) return false;
    return (await _run('launchctl', ['print', await _target()])).exitCode == 0;
  }

  @override
  Future<void> install() async {
    await _bootout();
    final quarantine = await _run('xattr', [
      '-dr',
      'com.apple.quarantine',
      File(helperBinary).parent.parent.parent.path,
    ]);
    if (quarantine.exitCode != 0) {
      throw ServiceException(
        'xattr (${quarantine.exitCode}): ${quarantine.stderr}'.trim(),
      );
    }
    await Directory(File(plistPath).parent.path).create(recursive: true);
    await Directory(File(logPath).parent.path).create(recursive: true);
    await File(runtimePath).parent.create(recursive: true);
    await File(runtimePath).writeAsString(_plist());
    final r = await _run('launchctl', [
      'bootstrap',
      await _domain(),
      runtimePath,
    ]);
    if (r.exitCode != 0) {
      throw ServiceException('bootstrap (${r.exitCode}): ${r.stderr}'.trim());
    }
  }

  @override
  Future<void> stop() async {
    await _bootout();
    if ((await _run('launchctl', ['print', await _target()])).exitCode == 0) {
      throw ServiceException('The quick paste service did not stop.');
    }
  }

  @override
  Future<void> setLaunchAtLogin(bool enabled) async {
    final file = File(plistPath);
    if (enabled) {
      await file.parent.create(recursive: true);
      await file.writeAsString(_plist());
    } else if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<void> uninstall() async {
    await stop();
    final runtime = File(runtimePath);
    if (await runtime.exists()) await runtime.delete();
    final plist = File(plistPath);
    if (await plist.exists()) await plist.delete();
  }

  @override
  Future<void> restart() async {
    final result = await _run('launchctl', [
      'kickstart',
      '-k',
      await _target(),
    ]);
    if (result.exitCode != 0) {
      throw ServiceException(
        'kickstart (${result.exitCode}): ${result.stderr}'.trim(),
      );
    }
  }

  Future<void> _bootout() async {
    final target = await _target();
    final before = await _run('launchctl', ['print', target]);
    if (before.exitCode == 113 || before.exitCode == 3) return;
    if (before.exitCode != 0) {
      throw ServiceException(
        'print (${before.exitCode}): ${before.stderr}'.trim(),
      );
    }
    final result = await _run('launchctl', ['bootout', target]);
    for (var i = 0; i < 20; i++) {
      final current = await _run('launchctl', ['print', target]);
      if (current.exitCode == 113 || current.exitCode == 3) {
        return;
      }
      if (current.exitCode != 0) {
        throw ServiceException(
          'print (${current.exitCode}): ${current.stderr}'.trim(),
        );
      }
      if (result.exitCode != 0) {
        throw ServiceException(
          'bootout (${result.exitCode}): ${result.stderr}'.trim(),
        );
      }
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
    throw ServiceException(
      'The quick paste service did not stop within 5 seconds.',
    );
  }

  String? _uid;
  Future<String> _domain() async {
    final result = _uid == null ? await _run('id', ['-u']) : null;
    if (result != null) {
      final value = '${result.stdout}'.trim();
      if (result.exitCode != 0 || !RegExp(r'^\d+$').hasMatch(value)) {
        throw ServiceException(
          'Cannot determine the login user: ${result.stderr}',
        );
      }
      _uid = value;
    }
    return 'gui/$_uid';
  }

  Future<String> _target() async => '${await _domain()}/$serviceLabel';

  Future<String> diagnostics() async {
    final result = await _run('launchctl', ['print', await _target()]);
    final lines = '${result.stdout}'
        .split('\n')
        .where(
          (line) => RegExp(
            r'^\s*(state|job state|last exit code|pid|runs)\s*=',
          ).hasMatch(line),
        )
        .take(12);
    return 'launchctl print: ${result.exitCode}\n${lines.join('\n')}\n${result.stderr}'
        .trim();
  }

  // 只在异常退出时重启：快捷粘贴被关掉时它自己正常退出，不该再被拉起来
  String _plist() =>
      '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>              <string>$serviceLabel</string>
    <key>ProgramArguments</key>
    <array>
        <string>${_xml(helperBinary)}</string>
    </array>
    <key>RunAtLoad</key>          <true/>
    ${environment.isEmpty ? '' : '<key>EnvironmentVariables</key><dict>${environment.entries.map((e) => '<key>${_xml(e.key)}</key><string>${_xml(e.value)}</string>').join()}</dict>'}
    <key>KeepAlive</key>
    <dict>
        <key>SuccessfulExit</key> <false/>
    </dict>
    <key>ThrottleInterval</key>   <integer>10</integer>
    <key>LimitLoadToSessionType</key> <string>Aqua</string>
    <key>StandardOutPath</key>    <string>${_xml(logPath)}</string>
    <key>StandardErrorPath</key>  <string>${_xml(logPath)}</string>
    <key>ProcessType</key>        <string>Interactive</string>
    <key>AssociatedBundleIdentifiers</key>
    <array>
        <string>$_appBundleId</string>
    </array>
</dict>
</plist>
''';

  static String _xml(String s) => s
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;');
}

/// Linux Wayland 上没有全局快捷键门户时（如 Ubuntu 24.04 的 GNOME 46），
/// 在 GNOME 的自定义快捷键里加一条，运行 `pasteferry --picker --toggle`：
/// 它会交给已经在运行的快捷窗口显示或收起（见 linux/runner/picker_application.cc），几乎没有延迟。
abstract final class GnomeShortcut {
  static const _schema = 'org.gnome.settings-daemon.plugins.media-keys';
  static const _path =
      '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/pasteferry/';

  static bool get supported =>
      Platform.isLinux &&
      (Platform.environment['XDG_CURRENT_DESKTOP'] ?? '')
          .toUpperCase()
          .contains('GNOME');

  /// 呼出快捷窗口的命令
  static String get command =>
      '${Platform.resolvedExecutable} --picker --toggle';

  /// GNOME 的写法：`<Alt>v`、`<Primary><Shift>v`、`<Super>v`。
  static String binding(Hotkey h) {
    const names = {
      'ctrl': '<Primary>',
      'alt': '<Alt>',
      'shift': '<Shift>',
      'meta': '<Super>',
    };
    const keys = {
      'space': 'space',
      'tab': 'Tab',
      'enter': 'Return',
      'backspace': 'BackSpace',
      'delete': 'Delete',
      'insert': 'Insert',
      'home': 'Home',
      'end': 'End',
      'pageup': 'Page_Up',
      'pagedown': 'Page_Down',
      'up': 'Up',
      'down': 'Down',
      'left': 'Left',
      'right': 'Right',
      'quote': 'apostrophe',
      'backquote': 'grave',
    };
    final key =
        keys[h.key] ??
        (Hotkey.isFunctionKey(h.key) ? h.key.toUpperCase() : h.key);
    return '${h.modifiers.map((m) => names[m]).join()}$key';
  }

  /// 添加或更新这条自定义快捷键。
  static Future<void> install(Hotkey h) async {
    final key = '$_schema.custom-keybinding:$_path';
    for (final (k, v) in [
      ('name', 'PasteFerry'),
      ('command', command),
      ('binding', binding(h)),
    ]) {
      final r = await Process.run('gsettings', ['set', key, k, v]);
      if (r.exitCode != 0) throw ServiceException('${r.stderr}'.trim());
    }
    final list = await Process.run('gsettings', [
      'get',
      _schema,
      'custom-keybindings',
    ]);
    final current = RegExp(
      r"'([^']+)'",
    ).allMatches('${list.stdout}').map((m) => m.group(1)!).toList();
    if (!current.contains(_path)) {
      final next = [...current, _path].map((p) => "'$p'").join(', ');
      final r = await Process.run('gsettings', [
        'set',
        _schema,
        'custom-keybindings',
        '[$next]',
      ]);
      if (r.exitCode != 0) throw ServiceException('${r.stderr}'.trim());
    }
  }
}
