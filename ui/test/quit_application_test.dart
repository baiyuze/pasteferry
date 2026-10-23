import 'package:flutter_test/flutter_test.dart';
import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/background_service.dart';
import 'package:pasteferry_ui/quick_paste_service.dart';

class _Service implements BackgroundService {
  _Service(this.events);
  final List<String> events;
  @override
  bool get available => true;
  @override
  Future<void> stop() async => events.add('daemon stopped');
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw StateError('Unexpected: $invocation');
}

class _Picker implements QuickPasteService {
  _Picker(this.events);
  final List<String> events;
  @override
  bool get available => true;
  @override
  Future<void> stop() async => events.add('picker stopped');
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw StateError('Unexpected: $invocation');
}

void main() {
  test(
    'quit stops both helpers without removing or changing login preferences',
    () async {
      final events = <String>[];
      final state = AppState(
        service: _Service(events),
        quickPasteService: _Picker(events),
      );
      addTearDown(state.dispose);
      await state.quitApplication();
      expect(events, ['picker stopped', 'daemon stopped']);
      // Pending retry callbacks and subsequent connections must not restart helpers.
      await state.connect();
      expect(events, ['picker stopped', 'daemon stopped']);
    },
  );
}
