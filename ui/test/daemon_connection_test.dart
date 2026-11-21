import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/background_service.dart';
import 'package:pasteferry_ui/daemon_client.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pbgrpc.dart';

class _Service implements BackgroundService {
  @override
  bool get available => false;
  @override
  Future<ServiceState> state() async => ServiceState.running;
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw StateError('$invocation');
}

class _RecoverableService implements BackgroundService {
  _RecoverableService(this.onInstall, {this.current = ServiceState.stopped});

  final Future<void> Function() onInstall;
  final ServiceState current;
  int installs = 0;

  @override
  bool get available => true;
  @override
  Future<ServiceState> state() async => current;
  @override
  Future<bool> removeLegacy() async => false;
  @override
  Future<bool> launchAtLogin() async => false;
  @override
  Future<void> install() async {
    installs++;
    await onInstall();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw StateError('$invocation');
}

class _Daemon extends DaemonServiceBase {
  final statusStarted = Completer<void>();
  final statusResult = Completer<Status>();
  final events = StreamController<Event>.broadcast();

  @override
  Future<Config> getConfig(ServiceCall call, Empty request) async =>
      Config(language: 'zh-Hans', deviceName: 'Windows');

  @override
  Future<Config> updateConfig(ServiceCall call, Config request) async =>
      request;

  @override
  Future<Status> getStatus(ServiceCall call, Empty request) {
    if (!statusStarted.isCompleted) statusStarted.complete();
    return statusResult.future;
  }

  @override
  Future<ListHistoryResponse> listHistory(
    ServiceCall call,
    ListHistoryRequest request,
  ) async => ListHistoryResponse();

  @override
  Future<ListDevicesResponse> listDevices(
    ServiceCall call,
    Empty request,
  ) async => ListDevicesResponse(self: Device(id: 'self'));

  @override
  Stream<Event> subscribe(ServiceCall call, SubscribeRequest request) =>
      events.stream;

  List<String> addresses = ['192.168.1.5'];
  final inviteAddresses = <String>[];

  @override
  Future<WebShareStatus> getWebShare(ServiceCall call, Empty request) async =>
      WebShareStatus(enabled: true, listening: true, addresses: addresses);

  @override
  Future<WebShareInvite> newWebShareInvite(
    ServiceCall call,
    NewWebShareInviteRequest request,
  ) async {
    inviteAddresses.add(request.address);
    return WebShareInvite(id: 'new');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw const GrpcError.unimplemented();
}

void main() {
  late _Daemon daemon;
  late Server server;
  late Directory dir;

  setUp(() async {
    daemon = _Daemon();
    server = Server.create(services: [daemon]);
    await server.serve(address: InternetAddress.loopbackIPv4, port: 0);
    dir = await Directory.systemTemp.createTemp('pasteferry-connection-');
    await File(
      '${dir.path}/daemon.json',
    ).writeAsString(jsonEncode({'port': server.port, 'token': 'test'}));
  });

  tearDown(() async {
    if (!daemon.statusResult.isCompleted) {
      daemon.statusResult.complete(Status());
    }
    await daemon.events.close();
    await server.shutdown();
    await dir.delete(recursive: true);
  });

  Future<DaemonConnection> connect({
    Duration requestTimeout = const Duration(seconds: 2),
  }) => DaemonConnection.connect(
    dataDir: dir.path,
    requestTimeout: requestTimeout,
  );

  for (final current in [ServiceState.stopped, ServiceState.running]) {
    test('reopening recovers a stale endpoint with service $current', () async {
      daemon.statusResult.complete(Status(deviceId: 'self'));
      final endpoint = File('${dir.path}/daemon.json');
      final currentEndpoint = await endpoint.readAsString();
      final oldPort = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      await endpoint.writeAsString(
        jsonEncode({'port': oldPort.port, 'token': 'old-session'}),
      );
      await oldPort.close();
      final service = _RecoverableService(() async {
        await endpoint.writeAsString(currentEndpoint);
      }, current: current);
      final state = AppState(service: service, connectDaemon: () => connect());
      addTearDown(state.dispose);

      await state.connect().timeout(const Duration(seconds: 10));

      expect(service.installs, 1);
      expect(state.link, LinkState.online);
      expect(state.status?.deviceId, 'self');
    });
  }

  test(
    'reopening repairs an unreadable endpoint using the startup action',
    () async {
      daemon.statusResult.complete(Status(deviceId: 'self'));
      final endpoint = File('${dir.path}/daemon.json');
      final currentEndpoint = await endpoint.readAsString();
      await endpoint.writeAsString('{incomplete');
      final service = _RecoverableService(() async {
        await endpoint.writeAsString(currentEndpoint);
      });
      final state = AppState(service: service, connectDaemon: () => connect());
      addTearDown(state.dispose);

      await state.connect();

      expect(service.installs, 1);
      expect(state.link, LinkState.online);
    },
  );

  test('reopening starts the service when its endpoint was removed', () async {
    daemon.statusResult.complete(Status(deviceId: 'self'));
    final endpoint = File('${dir.path}/daemon.json');
    final currentEndpoint = await endpoint.readAsString();
    await endpoint.delete();
    final service = _RecoverableService(() async {
      await endpoint.writeAsString(currentEndpoint);
    });
    final state = AppState(service: service, connectDaemon: () => connect());
    addTearDown(state.dispose);

    await state.connect();

    expect(service.installs, 1);
    expect(state.link, LinkState.online);
  });

  test(
    'slow startup reconnects automatically without repeatedly restarting',
    () async {
      daemon.statusResult.complete(Status(deviceId: 'self'));
      final endpoint = File('${dir.path}/daemon.json');
      final currentEndpoint = await endpoint.readAsString();
      await endpoint.delete();
      // Detached process creation completes before the daemon publishes its port.
      final service = _RecoverableService(() async {});
      final state = AppState(service: service, connectDaemon: () => connect());
      addTearDown(state.dispose);

      await state.connect();
      expect(state.link, LinkState.offline);
      expect(service.installs, 1);

      final online = Completer<void>();
      state.addListener(() {
        if (state.isOnline && !online.isCompleted) online.complete();
      });
      await endpoint.writeAsString(currentEndpoint);
      await online.future.timeout(const Duration(seconds: 10));

      expect(state.link, LinkState.online);
      expect(service.installs, 1);
    },
  );

  for (final current in [ServiceState.mustMove, ServiceState.unavailable]) {
    test('automatic recovery respects $current', () async {
      await File('${dir.path}/daemon.json').delete();
      final service = _RecoverableService(() async {}, current: current);
      final state = AppState(service: service, connectDaemon: () => connect());
      addTearDown(state.dispose);

      await state.connect();
      await state.connect();

      expect(service.installs, 0);
      expect(state.link, LinkState.offline);
    });
  }

  test(
    'failed automatic startup stays bounded and manual repair still works',
    () async {
      daemon.statusResult.complete(Status(deviceId: 'self'));
      final endpoint = File('${dir.path}/daemon.json');
      final currentEndpoint = await endpoint.readAsString();
      await endpoint.delete();
      var failInstall = true;
      final service = _RecoverableService(() async {
        if (failInstall) throw StateError('startup failed');
        await endpoint.writeAsString(currentEndpoint);
      });
      final state = AppState(service: service, connectDaemon: () => connect());
      addTearDown(state.dispose);

      await state.connect();
      await state.connect();
      expect(service.installs, 1);
      expect(state.link, LinkState.offline);

      failInstall = false;
      await state.enableService();
      expect(service.installs, 2);
      expect(state.link, LinkState.online);
    },
  );

  test(
    'settings config appears while status is stalled; timeout permits reconnect',
    () async {
      final state = AppState(
        service: _Service(),
        connectDaemon: () => connect(),
      );
      addTearDown(state.dispose);
      final configReady = Completer<void>();
      state.addListener(() {
        if (state.config != null && !configReady.isCompleted) {
          configReady.complete();
        }
      });
      final first = state.connect();
      await configReady.future.timeout(const Duration(seconds: 10));
      expect(state.config?.deviceName, 'Windows');
      expect(daemon.statusResult.isCompleted, isFalse);
      await first.timeout(const Duration(seconds: 10));
      expect(state.link, LinkState.offline);

      daemon.statusResult.complete(Status(deviceId: 'self'));
      await state.connect().timeout(const Duration(seconds: 10));
      expect(state.link, LinkState.online);
      expect(state.config?.deviceName, 'Windows');
    },
  );

  test('unary calls time out but event streams stay open', () async {
    final conn = await connect(
      requestTimeout: const Duration(milliseconds: 300),
    );
    addTearDown(conn.close);
    final subscription = conn.client.subscribe(SubscribeRequest());
    final event = subscription.first;
    await expectLater(
      conn.client.getStatus(Empty()),
      throwsA(
        isA<GrpcError>().having(
          (e) => e.code,
          'code',
          StatusCode.deadlineExceeded,
        ),
      ),
    );
    daemon.events.add(
      Event(statusChanged: Status(deviceId: 'still-subscribed')),
    );
    expect(
      (await event.timeout(const Duration(seconds: 10))).statusChanged.deviceId,
      'still-subscribed',
    );
  });

  test(
    'settings edited during startup are retained when status arrives',
    () async {
      final state = AppState(
        service: _Service(),
        connectDaemon: () => connect(),
      );
      addTearDown(state.dispose);
      final configReady = Completer<void>();
      state.addListener(() {
        if (state.config != null && !configReady.isCompleted) {
          configReady.complete();
        }
      });
      final startup = state.connect();
      await configReady.future.timeout(const Duration(seconds: 10));
      await state.updateConfig(
        state.config!.deepCopy()..deviceName = 'Renamed',
      );
      daemon.statusResult.complete(Status(deviceId: 'self'));
      await startup.timeout(const Duration(seconds: 10));
      expect(state.link, LinkState.online);
      expect(state.config?.deviceName, 'Renamed');
    },
  );

  test(
    'invites reload network addresses and discard a vanished selection',
    () async {
      daemon.statusResult.complete(Status(deviceId: 'self'));
      final state = AppState(
        service: _Service(),
        connectDaemon: () => connect(),
      );
      addTearDown(state.dispose);
      await state.connect();
      expect(state.webShare?.addresses, ['192.168.1.5']);
      daemon.addresses = ['192.168.3.19'];
      await state.newWebShareInvite('192.168.1.5');
      expect(state.webShare?.addresses, ['192.168.3.19']);
      expect(daemon.inviteAddresses, ['']);
      await state.newWebShareInvite('192.168.3.19');
      expect(daemon.inviteAddresses, ['', '192.168.3.19']);
    },
  );

  test('explicit deadlines override the default timeout', () async {
    final conn = await connect(
      requestTimeout: const Duration(milliseconds: 300),
    );
    addTearDown(conn.close);
    final response = conn.client.getStatus(
      Empty(),
      options: CallOptions(timeout: const Duration(seconds: 2)),
    );
    await daemon.statusStarted.future;
    await Future<void>.delayed(const Duration(milliseconds: 450));
    daemon.statusResult.complete(Status(deviceId: 'completed'));
    expect((await response).deviceId, 'completed');
  });
}
