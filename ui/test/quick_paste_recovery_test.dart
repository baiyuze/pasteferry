import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/quick_paste_recovery.dart';
import 'package:pasteferry_ui/quick_paste_service.dart';

class _Service implements QuickPasteService {
  int installs = 0, restarts = 0, uninstalls = 0;
  bool registered = true;
  Future<void> Function()? onInstall, onRestart;
  @override
  bool get available => true;
  @override
  Future<bool> installed() async => registered;
  @override
  Future<void> install() async {
    installs++;
    await onInstall?.call();
  }

  @override
  Future<void> restart() async {
    restarts++;
    await onRestart?.call();
  }

  @override
  Future<void> uninstall() async {
    uninstalls++;
  }

  @override
  Future<void> stop() async {}
  @override
  Future<void> setLaunchAtLogin(bool enabled) async {}
}

void main() {
  late _Service service;
  late QuickPasteRecovery recovery;
  QuickPasteStatus? status;
  QuickPasteStatus ready({String version = '2.12.2', String error = ''}) =>
      QuickPasteStatus(
        running: true,
        version: version,
        hotkey: 'alt+v',
        hotkeyError: error,
      );
  Future<void> sync({bool enabled = true, bool host = true}) =>
      recovery.synchronize(
        enabled: enabled,
        hostRunning: host,
        launchAtLogin: false,
        version: '2.12.2',
      );
  void report(QuickPasteStatus next) {
    status = next;
    recovery.statusChanged();
  }

  setUp(() {
    service = _Service();
    status = QuickPasteStatus();
    recovery = QuickPasteRecovery(
      service: service,
      status: () => status,
      grace: const Duration(milliseconds: 15),
      backoff: const [Duration.zero, Duration.zero],
    );
  });
  tearDown(() => recovery.dispose());

  test(
    'registered job with no session is re-registered and waits for readiness',
    () async {
      service.onInstall = () async => report(ready());
      await sync();
      expect(service.installs, 1);
      expect(recovery.health, QuickPasteHealth.ready);
    },
  );

  test('healthy session is neither restarted nor re-registered', () async {
    report(ready());
    await sync();
    expect(service.installs, 0);
    expect(service.restarts, 0);
    expect(recovery.health, QuickPasteHealth.ready);
  });

  test('slow startup within grace is not interrupted', () async {
    final timer = Timer(const Duration(milliseconds: 3), () => report(ready()));
    addTearDown(timer.cancel);
    await sync();
    expect(service.installs, 0);
    expect(recovery.health, QuickPasteHealth.ready);
  });

  test(
    'hotkey conflict is reported without restarting a healthy process',
    () async {
      report(ready(error: 'in_use'));
      await sync();
      expect(recovery.health, QuickPasteHealth.shortcutError);
      expect(service.installs, 0);
    },
  );

  test('old helper needs a fresh session after restart', () async {
    report(ready(version: '2.12.1'));
    service.onRestart = () async => report(ready());
    await sync();
    expect(service.restarts, 1);
    expect(service.installs, 0);
    expect(recovery.health, QuickPasteHealth.ready);
  });

  test(
    'failed commands stop at the retry ceiling and preserve the reason',
    () async {
      service.onInstall = () async => throw StateError('bootstrap denied');
      await sync();
      expect(service.installs, 2);
      expect(recovery.health, QuickPasteHealth.failed);
      expect(recovery.error, contains('bootstrap denied'));
      await sync();
      expect(service.installs, 2);
    },
  );

  test(
    'disabling during grace cancels recovery and leaves the job uninstalled',
    () async {
      final starting = sync();
      await Future<void>.delayed(Duration.zero);
      await sync(enabled: false);
      await starting;
      expect(service.installs, 0);
      expect(service.uninstalls, 1);
      expect(recovery.health, QuickPasteHealth.idle);
    },
  );

  test(
    'shutdown interrupts the grace period without relaunching a helper',
    () async {
      final starting = sync();
      await Future<void>.delayed(Duration.zero);
      await recovery.suspend();
      await starting;
      expect(service.installs, 0);
      expect(recovery.health, QuickPasteHealth.idle);
    },
  );

  test('daemon unavailable never registers the picker', () async {
    await sync(host: false);
    expect(service.installs, 0);
    expect(recovery.health, QuickPasteHealth.idle);
  });
}
