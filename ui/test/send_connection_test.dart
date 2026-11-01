import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/i18n.dart';
import 'package:pasteferry_ui/main.dart';
import 'package:pasteferry_ui/widgets/friends_dialog.dart';
import 'package:pasteferry_ui/widgets/send_dialog.dart';

class _ConnectingSend extends AppState {
  @override
  Future<Transfer> sendFiles(
    String deviceId,
    List<String> paths, {
    bool allowRelay = false,
    String note = '',
  }) async {
    throw const GrpcError.failedPrecondition('connecting');
  }
}

void main() {
  testWidgets('连接中的发送提示正在连接，不提示更新', (tester) async {
    final state = _ConnectingSend()
      ..debugSeed(
        status: Status(),
        config: Config(),
        self: Device(id: 'self'),
      );
    await tester.pumpWidget(PasteFerryApp(state: state));
    final context = tester.element(find.byType(Shell));
    final l = context.l10n;
    await sendFilesById(context, 'friend', 'Windows', ['/tmp/file.txt']);
    await tester.pump();
    expect(find.text(l.sendConnectingTip('Windows')), findsOneWidget);
    expect(find.text(l.sendNeedsUpdateTip('Windows')), findsNothing);
    await tester.pump(const Duration(seconds: 4));
  });

  test('好友重连期间优先显示连接状态，连通后才显示能力限制', () {
    final state = AppState();
    addTearDown(state.dispose);
    final f = Friend(
      online: true,
      featuresKnown: true,
      connection: ConnectionKind.CONNECTION_KIND_OFFLINE,
    );
    expect(friendStatus(appL10n, state, f), appL10n.reconnecting);
    f.connection = ConnectionKind.CONNECTION_KIND_DIRECT;
    expect(friendStatus(appL10n, state, f), appL10n.sendNeedsUpdate);
  });
}
