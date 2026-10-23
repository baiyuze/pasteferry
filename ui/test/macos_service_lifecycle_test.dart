import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasteferry_ui/background_service.dart';

void main() {
  test(
    'launchd: disabling login keeps this session alive; quit stays stopped; reopening restarts',
    () async {
      final dir = await Directory.systemTemp.createTemp('pasteferry-launchd-');
      final exe = '${dir.path}/PasteFerry.app/Contents/MacOS/PasteFerry';
      final service = MacBackgroundService(
        home: dir.path,
        executable: exe,
        serviceLabel: 'com.pasteferry.lifecycle-test.$pid',
      );
      final binary = File(service.helperBinary);
      await binary.parent.create(recursive: true);
      await binary.writeAsString(
        '#!/bin/sh\ntrap "exit 0" TERM INT\nwhile :; do sleep 1; done\n',
      );
      await Process.run('chmod', ['+x', binary.path]);
      addTearDown(() async {
        await service.uninstall();
        await dir.delete(recursive: true);
      });
      Future<void> waitRunning() async {
        for (var i = 0; i < 40; i++) {
          if (await service.state() == ServiceState.running) return;
          await Future<void>.delayed(const Duration(milliseconds: 100));
        }
        fail('launchd job did not start');
      }

      await service.install();
      await waitRunning();
      expect(await service.launchAtLogin(), isFalse);
      await service.setLaunchAtLogin(true);
      await service.setLaunchAtLogin(false);
      expect(await service.state(), ServiceState.running);
      await service.setLaunchAtLogin(true);
      await service.stop();
      expect(await service.launchAtLogin(), isTrue);
      expect(await service.state(), ServiceState.stopped);
      await Future<void>.delayed(const Duration(seconds: 2));
      expect(await service.state(), ServiceState.stopped);
      await service.install();
      await waitRunning();
      expect(await service.launchAtLogin(), isTrue);
    },
    skip: !Platform.isMacOS,
  );
}
