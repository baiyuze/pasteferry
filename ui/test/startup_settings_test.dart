import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasteferry_ui/background_service.dart';
import 'package:pasteferry_ui/background_service_linux.dart';
import 'package:pasteferry_ui/quick_paste_service.dart';

void main() {
  test(
    'Mac login preference changes without stopping the runtime job',
    () async {
      final dir = await Directory.systemTemp.createTemp('pasteferry-startup-');
      addTearDown(() => dir.delete(recursive: true));
      final service = MacBackgroundService(
        home: dir.path,
        executable: '/Applications/PasteFerry.app/Contents/MacOS/PasteFerry',
      );
      final picker = MacQuickPasteService(
        home: dir.path,
        executable: '/Applications/PasteFerry.app/Contents/MacOS/PasteFerry',
      );
      final runtime = File(service.runtimePath);
      await runtime.parent.create(recursive: true);
      await runtime.writeAsString('running-job');
      expect(await service.launchAtLogin(), isFalse);
      await service.setLaunchAtLogin(true);
      await picker.setLaunchAtLogin(true);
      expect(await service.launchAtLogin(), isTrue);
      expect(await File(picker.plistPath).exists(), isTrue);
      await service.setLaunchAtLogin(false);
      await picker.setLaunchAtLogin(false);
      expect(await service.launchAtLogin(), isFalse);
      expect(await File(picker.plistPath).exists(), isFalse);
      expect(await runtime.readAsString(), 'running-job');
    },
  );

  test(
    'Linux login preference changes without launching or stopping a process',
    () async {
      final dir = await Directory.systemTemp.createTemp('pasteferry-startup-');
      addTearDown(() => dir.delete(recursive: true));
      final service = LinuxBackgroundService(
        executable: '/opt/PasteFerry/pasteferry',
        environment: {'HOME': dir.path},
      );
      expect(await service.launchAtLogin(), isFalse);
      await service.setLaunchAtLogin(true);
      expect(await service.launchAtLogin(), isTrue);
      expect(
        await File(service.autostartPath).readAsString(),
        contains('pasteferryd'),
      );
      await service.setLaunchAtLogin(false);
      expect(await service.launchAtLogin(), isFalse);
    },
  );
}
