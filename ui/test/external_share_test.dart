import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/application_lifecycle.dart';
import 'package:pasteferry_ui/external_share.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/i18n.dart';
import 'package:pasteferry_ui/main.dart' show AppScope;
import 'package:pasteferry_ui/widgets/external_share_host.dart';

class _State extends AppState {
  final sent = <(String, List<String>)>[];
  @override
  Future<Transfer> sendFiles(
    String deviceId,
    List<String> paths, {
    bool allowRelay = false,
    String note = '',
  }) async {
    sent.add((deviceId, [...paths]));
    return Transfer(id: 'transfer-0001', status: 'active');
  }
}

void main() {
  late Directory root;
  late ExternalShares shares;
  late File source;
  Future<void> incoming(
    String id, {
    String owned = '',
    String? error,
    List<String>? paths,
  }) async {
    final f = File('${root.path}/share-inbox/$id.json');
    await f.parent.create(recursive: true);
    await f.writeAsString(
      jsonEncode({
        'id': id,
        'paths': paths ?? [source.path],
        'ownedDirectory': owned,
        'error': ?error,
      }),
    );
    await shares.scan();
    for (var i = 0; i < 100 && shares.pending.every((d) => d.id != id); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 2));
    }
  }

  setUp(() async {
    root = await Directory.systemTemp.createTemp('pasteferry-sharing-');
    source = File('${root.path}/original 中文 file.txt');
    await source.writeAsString('original');
    shares = ExternalShares(dataDir: root.path);
    await shares.start();
  });
  tearDown(() async {
    await shares.close();
    shares.dispose();
    // Windows closes the native watch handle on a later event-loop turn even
    // after subscription cancellation, particularly after a widget test zone.
    for (var attempt = 0; ; attempt++) {
      try {
        await root.delete(recursive: true);
        break;
      } on FileSystemException catch (e) {
        if (!Platform.isWindows || e.osError?.errorCode != 32 || attempt == 19) {
          rethrow;
        }
        await Future<void>.delayed(const Duration(milliseconds: 25));
      }
    }
  });

  test(
    'cold-start restore and repeated notifications preserve one batch',
    () async {
      await incoming('batch-0001');
      await incoming('batch-0001');
      expect(shares.pending, hasLength(1));
      await shares.close();
      shares.dispose();
      shares = ExternalShares(dataDir: root.path);
      await shares.start();
      expect(shares.pending.single.paths, [source.path]);
    },
  );

  test(
    'two shares stay separate and cancellation leaves originals untouched',
    () async {
      await incoming('batch-0001');
      await incoming('batch-0002');
      expect(shares.pending, hasLength(2));
      await shares.complete(shares.pending.first, null);
      expect(shares.pending.single.id, 'batch-0002');
      expect(await source.readAsString(), 'original');
    },
  );

  test(
    'imported files survive restart, unknown records, pause and resume',
    () async {
      final copy = File('${root.path}/share-staging/batch-0001/copied.txt');
      await copy.parent.create(recursive: true);
      await copy.writeAsString('imported');
      await incoming('batch-0001', owned: copy.parent.path, paths: [copy.path]);
      await shares.complete(
        shares.pending.single,
        Transfer(id: 'transfer-0001'),
      );
      await shares.close();
      shares.dispose();
      shares = ExternalShares(dataDir: root.path);
      await shares.start();
      expect(shares.pending, isEmpty);
      shares.transfersChanged([]);
      shares.transfersChanged([
        Transfer(id: 'transfer-0001', status: 'paused'),
      ]);
      await Future<void>.delayed(Duration.zero);
      expect(await copy.exists(), isTrue);
      shares.transfersChanged([Transfer(id: 'transfer-0001', status: 'done')]);
      for (var i = 0; i < 100 && await copy.exists(); i++) {
        await Future<void>.delayed(const Duration(milliseconds: 2));
      }
      expect(await copy.exists(), isFalse);
      expect(await source.exists(), isTrue);
    },
  );

  test(
    'staging path traversal is rejected without deleting external files',
    () async {
      await incoming('batch-0001', owned: root.parent.path);
      expect(shares.pending, isEmpty);
      expect(await source.exists(), isTrue);
    },
  );

  test(
    'cancelling import removes markers without deleting source files',
    () async {
      final marker = File('${root.path}/share-inbox/import-0001.importing');
      await marker.writeAsString('');
      await shares.scan();
      expect(shares.importing, isTrue);
      await shares.cancelImports();
      expect(shares.importing, isFalse);
      expect(await source.exists(), isTrue);
    },
  );

  testWidgets(
    'sharing requires one explicit target and confirmation, never clipboard submission',
    (tester) async {
      await tester.runAsync(() => incoming('batch-0001'));
      final state = _State()
        ..debugSeed(
          status: Status(),
          config: Config(language: 'en'),
          self: Device(id: 'self', name: 'This device'),
          peers: [
            Device(
              id: 'target',
              name: 'Receiving computer',
              online: true,
              receivesFiles: true,
            ),
            Device(
              id: 'offline',
              name: 'Offline computer',
              online: false,
              receivesFiles: true,
            ),
          ],
        );
      await tester.pumpWidget(
        AppScope(
          state: state,
          child: MaterialApp(
            navigatorKey: appNavigatorKey,
            locale: const Locale('en'),
            supportedLocales: supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: ExternalShareHost(
              shares: shares,
              state: state,
              child: const Scaffold(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Send shared files'), findsOneWidget);
      expect(state.sent, isEmpty);
      var send = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Send'),
      );
      expect(send.onPressed, isNull);
      await tester.tap(find.text('Receiving computer'));
      await tester.pumpAndSettle();
      send = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Send'),
      );
      expect(send.onPressed, isNotNull);
      await tester.runAsync(() async {
        await tester.tap(find.widgetWithText(FilledButton, 'Send'));
        await Future<void>.delayed(const Duration(milliseconds: 25));
      });
      await tester.pumpAndSettle();
      expect(state.sent.single.$1, 'target');
      expect(state.sent.single.$2, [source.path]);
      await tester.pumpWidget(const SizedBox());
      state.dispose();
    },
  );
}
