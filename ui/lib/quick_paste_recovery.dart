import 'dart:async';

import 'package:flutter/foundation.dart';

import 'gen/pasteferry/v1/daemon.pb.dart';
import 'quick_paste_service.dart';

enum QuickPasteHealth { idle, starting, ready, shortcutError, failed }

/// Registration is not readiness: launchd can retain a job which never spawns.
/// Only a fresh Picker session and its hotkey result complete a restart.
class QuickPasteRecovery extends ChangeNotifier {
  QuickPasteRecovery({
    required this.service,
    required this.status,
    this.grace = const Duration(seconds: 10),
    this.backoff = const [Duration(seconds: 5), Duration(seconds: 15)],
  });

  final QuickPasteService service;
  final QuickPasteStatus? Function() status;
  final Duration grace;
  final List<Duration> backoff;

  QuickPasteHealth health = QuickPasteHealth.idle;
  String? error;
  int attempts = 0;
  bool _enabled = false, _hostRunning = false, _login = false;
  bool _disposed = false, _pending = false, _manual = false;
  String _version = 'dev';
  int _generation = 0, _serial = 0, _minimumSerial = 0;
  Future<void>? _work;
  Completer<void>? _wake;

  bool get busy => health == QuickPasteHealth.starting;
  void reportFailure(Object failure) =>
      _set(QuickPasteHealth.failed, '$failure');
  bool get _active => !_disposed && _enabled && _hostRunning;
  bool _current(int generation) => generation == _generation && _active;

  Future<void> synchronize({
    required bool enabled,
    required bool hostRunning,
    required bool launchAtLogin,
    required String version,
  }) {
    if (_disposed) return Future.value();
    if (_enabled != enabled ||
        _hostRunning != hostRunning ||
        _version != version) {
      _generation++;
      _signal();
      if (_enabled != enabled) attempts = 0;
    }
    _enabled = enabled;
    _hostRunning = hostRunning;
    _login = launchAtLogin;
    _version = version;
    _pending = true;
    return _drain();
  }

  /// Called for session events, including disconnects and hotkey conflicts.
  void statusChanged() {
    _serial++;
    _signal();
    if (!_active) return;
    if (_ready()) {
      _set(
        status()!.hotkeyError.isEmpty
            ? QuickPasteHealth.ready
            : QuickPasteHealth.shortcutError,
      );
    } else if (_work == null &&
        (health == QuickPasteHealth.ready ||
            health == QuickPasteHealth.shortcutError)) {
      _pending = true;
      unawaited(_drain());
    }
  }

  Future<void> repair() {
    if (!_active) return Future.value();
    _generation++;
    _signal();
    attempts = 0;
    _manual = true;
    _pending = true;
    return _drain();
  }

  /// Cancel before shutdown/update/disable, including an in-flight grace period.
  Future<void> suspend() {
    _hostRunning = false;
    _generation++;
    _pending = false;
    _signal();
    _set(QuickPasteHealth.idle);
    return _work ?? Future.value();
  }

  Future<void> _drain() {
    final running = _work;
    if (running != null) return running;
    final work = _run();
    _work = work;
    return work.whenComplete(() {
      if (identical(_work, work)) _work = null;
    });
  }

  Future<void> _run() async {
    while (_pending && !_disposed) {
      _pending = false;
      final generation = _generation;
      final manual = _manual;
      _manual = false;
      if (!_hostRunning || !service.available) {
        _set(QuickPasteHealth.idle);
        continue;
      }
      if (!_enabled) {
        try {
          await service.uninstall();
          _set(QuickPasteHealth.idle);
        } catch (e) {
          _set(QuickPasteHealth.failed, '$e');
        }
        continue;
      }
      _set(QuickPasteHealth.starting);
      try {
        final registered = await service.installed();
        if (!_current(generation)) continue;
        if (manual || !registered) {
          _minimumSerial = _serial + 1;
          await service.install();
        } else {
          final old = status();
          if (old != null &&
              old.running &&
              old.version.isNotEmpty &&
              _version != 'dev' &&
              old.version != _version) {
            _minimumSerial = _serial + 1;
            await service.restart();
          }
        }
        if (!_current(generation)) continue;
        await service.setLaunchAtLogin(_login);
        if (!_current(generation)) continue;
        if (await _waitReady(generation)) continue;
      } catch (e) {
        if (!_current(generation)) continue;
        error = '$e';
        debugPrint('Quick paste startup: $e');
      }
      while (_current(generation) && attempts < backoff.length) {
        _set(QuickPasteHealth.starting, error);
        final pause = backoff[attempts];
        final watch = Stopwatch()..start();
        while (_current(generation) && watch.elapsed < pause && !_ready()) {
          await _wait(pause - watch.elapsed);
        }
        if (!_current(generation) || _acceptReady()) break;
        attempts++;
        try {
          _minimumSerial = _serial + 1;
          await service
              .install(); // bootout + bootstrap also repairs stale LWCR.
          if (!_current(generation)) break;
          await service.setLaunchAtLogin(_login);
          if (await _waitReady(generation)) break;
        } catch (e) {
          if (!_current(generation)) break;
          error = '$e';
          debugPrint('Quick paste recovery $attempts: $e');
        }
      }
      if (_current(generation) && !_acceptReady()) {
        var reason = error ?? 'picker_not_ready';
        if (service case final MacQuickPasteService mac) {
          try {
            reason +=
                '\n${await mac.diagnostics().timeout(const Duration(seconds: 3))}';
          } catch (e) {
            debugPrint('Quick paste diagnostics: $e');
          }
        }
        if (_current(generation)) _set(QuickPasteHealth.failed, reason);
      }
    }
  }

  bool _ready() {
    final current = status();
    return _serial >= _minimumSerial &&
        current != null &&
        current.running &&
        current.version.isNotEmpty &&
        (_version == 'dev' || current.version == _version) &&
        (current.hotkey.isNotEmpty || current.hotkeyError.isNotEmpty);
  }

  bool _acceptReady() {
    if (!_ready()) return false;
    _set(
      status()!.hotkeyError.isEmpty
          ? QuickPasteHealth.ready
          : QuickPasteHealth.shortcutError,
    );
    return true;
  }

  Future<bool> _waitReady(int generation) async {
    final watch = Stopwatch()..start();
    while (_current(generation)) {
      if (_acceptReady()) return true;
      final remaining = grace - watch.elapsed;
      if (remaining <= Duration.zero) break;
      await _wait(remaining);
    }
    return false;
  }

  Future<void> _wait(Duration duration) async {
    final wake = Completer<void>();
    _wake = wake;
    final timer = Timer(duration, () {
      if (!wake.isCompleted) wake.complete();
    });
    try {
      await wake.future;
    } finally {
      timer.cancel();
      if (identical(_wake, wake)) _wake = null;
    }
  }

  void _signal() {
    final wake = _wake;
    if (wake != null && !wake.isCompleted) wake.complete();
  }

  void _set(QuickPasteHealth next, [String? detail]) {
    if (_disposed) return;
    if (health == next && error == detail) return;
    health = next;
    error = detail;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    _signal();
    super.dispose();
  }
}
