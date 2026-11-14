import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pasteferry_ui/quick_paste_service.dart';

void main() {
  test(
    'registered spawn failure is not confused with a successful process',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'pasteferry-launch-fixture-',
      );
      addTearDown(() => root.delete(recursive: true));
      final service = MacQuickPasteService(
        home: root.path,
        executable: '/Applications/PasteFerry.app/Contents/MacOS/PasteFerry',
        run: (command, args) async => command == 'id'
            ? ProcessResult(1, 0, '501\n', '')
            : ProcessResult(
                1,
                0,
                'state = spawn scheduled\nlast exit code = 78: EX_CONFIG\njob state = spawn failed\n',
                '',
              ),
      );
      final plist = File(service.runtimePath);
      await plist.parent.create(recursive: true);
      await plist.writeAsString(service.helperBinary);
      expect(await service.installed(), isTrue);
      final detail = await service.diagnostics();
      expect(detail, contains('spawn failed'));
      expect(detail, contains('78: EX_CONFIG'));
    },
  );

  test('bootout permission failure never continues to bootstrap', () async {
    var bootstrap = false;
    final service = MacQuickPasteService(
      run: (command, args) async {
        if (command == 'id') return ProcessResult(1, 0, '501', '');
        if (args.first == 'bootstrap') bootstrap = true;
        if (args.first == 'bootout') {
          return ProcessResult(1, 1, '', 'permission denied');
        }
        return ProcessResult(1, 0, 'state = running', '');
      },
    );
    await expectLater(
      service.install(),
      throwsA(predicate((e) => '$e'.contains('permission denied'))),
    );
    expect(bootstrap, isFalse);
  });

  test(
    'a missing registration is allowed, but query failures are not',
    () async {
      final service = MacQuickPasteService(
        run: (command, args) async => command == 'id'
            ? ProcessResult(1, 0, '501', '')
            : ProcessResult(1, 1, '', 'query denied'),
      );
      await expectLater(
        service.stop(),
        throwsA(predicate((e) => '$e'.contains('query denied'))),
      );
    },
  );

  test('kickstart errors reach the recovery controller', () async {
    final service = MacQuickPasteService(
      run: (command, args) async => command == 'id'
          ? ProcessResult(1, 0, '501', '')
          : ProcessResult(1, 5, '', 'input/output error'),
    );
    await expectLater(
      service.restart(),
      throwsA(predicate((e) => '$e'.contains('kickstart (5)'))),
    );
  });
}
