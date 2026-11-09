import 'dart:convert';
import 'dart:io';

import 'daemon_client.dart';

/// 请用户去 GitHub 点 Star 的小横幅该不该出现。
///
/// 规则（尽量不打扰）：
/// - 装好满 [minDays] 天，并且同步过 [minSyncs] 条以上才出现，用户已经觉得好用再提；
/// - 「去点 Star」或「×」之后永不再提；
/// - 「以后再说」隔 [snoozeDays] 天再出现一次，第二次再点就永不再提。
///
/// 状态只存在本机数据目录的 `star-prompt.json` 里，不上报。App 无从知道用户到底点没点，
/// 点了「去点 Star」就当点过了。
class StarPrompt {
  StarPrompt({this.path, DateTime Function()? now})
    : _now = now ?? DateTime.now;

  static const url = 'https://github.com/baiyuze/pasteferry';
  static const minDays = 3;
  static const minSyncs = 20;
  static const snoozeDays = 7;

  /// 只存在内存里、不读写文件：跑测试时用，免得动到真实的数据目录
  StarPrompt.memory({DateTime Function()? now})
    : path = '',
      _now = now ?? DateTime.now;

  /// 为 null 时用数据目录里的默认位置；为空字符串时不读写文件
  final String? path;
  final DateTime Function() _now;
  /// 横幅该出现或收起时调用，由 AppState 接上 notifyListeners
  void Function()? onChanged;

  bool _loaded = false;
  int _firstUseUnix = 0;
  int _syncs = 0;
  int _snoozes = 0;
  int _snoozeUntilUnix = 0;
  bool _done = false;

  int get syncs => _syncs;
  bool get done => _done;

  int get _nowUnix => _now().millisecondsSinceEpoch ~/ 1000;

  bool get visible {
    if (!_loaded || _done || _syncs < minSyncs) return false;
    final now = _nowUnix;
    return now - _firstUseUnix >= minDays * 86400 && now >= _snoozeUntilUnix;
  }

  File? get _file {
    final path = this.path ?? '${DaemonEndpoint.defaultDataDir()}${Platform.pathSeparator}star-prompt.json';
    return path.isEmpty ? null : File(path);
  }

  /// 读出上次的状态。第一次运行时记下首次使用时间。读写失败都不影响使用。
  Future<void> load() async {
    if (_loaded) return;
    final file = _file;
    try {
      if (file != null && await file.exists()) {
        final m = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        _firstUseUnix = (m['first_use_unix'] as num?)?.toInt() ?? 0;
        _syncs = (m['syncs'] as num?)?.toInt() ?? 0;
        _snoozes = (m['snoozes'] as num?)?.toInt() ?? 0;
        _snoozeUntilUnix = (m['snooze_until_unix'] as num?)?.toInt() ?? 0;
        _done = m['done'] as bool? ?? false;
      }
    } catch (_) {
      // 文件坏了就当第一次用
    }
    _loaded = true;
    if (_firstUseUnix <= 0) {
      _firstUseUnix = _nowUnix;
      await _save();
    }
    onChanged?.call();
  }

  /// 成功同步了一条（收到别的设备的，或本机复制后发了出去）
  void recordSync() {
    if (!_loaded || _done) return;
    final wasVisible = visible;
    _syncs++;
    // 门槛以下每条都写一次；到了门槛以后横幅出现与否已经定了，不必每条都写盘
    if (_syncs <= minSyncs) _save();
    if (visible != wasVisible) onChanged?.call();
  }

  /// 「去点 Star」：以后不再出现
  void starred() => _finish();

  /// 「×」：以后不再出现
  void dismiss() => _finish();

  /// 「以后再说」：第一次隔几天再提，第二次就不再提了
  void later() {
    if (_snoozes >= 1) {
      _finish();
      return;
    }
    _snoozes++;
    _snoozeUntilUnix = _nowUnix + snoozeDays * 86400;
    _save();
    onChanged?.call();
  }

  void _finish() {
    _done = true;
    _save();
    onChanged?.call();
  }

  // 写盘排队进行，免得两次写同时截断文件、写出半截内容
  Future<void> _saving = Future.value();

  Future<void> _save() => _saving = _saving.then((_) => _write());

  Future<void> _write() async {
    final file = _file;
    if (file == null) return;
    try {
      await file.parent.create(recursive: true);
      await file.writeAsString(
        jsonEncode({
          'first_use_unix': _firstUseUnix,
          'syncs': _syncs,
          'snoozes': _snoozes,
          'snooze_until_unix': _snoozeUntilUnix,
          'done': _done,
        }),
      );
    } catch (_) {
      // 写不进去下次就再提一次，不值得打扰用户
    }
  }
}
