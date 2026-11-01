import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/i18n.dart';
import 'package:pasteferry_ui/main.dart';
import 'package:pasteferry_ui/widgets/friend_send_dialog.dart';
import 'package:pasteferry_ui/widgets/friends_dialog.dart';
import 'package:pasteferry_ui/widgets/send_dialog.dart';

const _out = TransferDirection.TRANSFER_DIRECTION_OUTGOING;
final _friend = Friend(
  id: 'friend',
  displayName: '小明',
  online: true,
  connection: ConnectionKind.CONNECTION_KIND_DIRECT,
  featuresKnown: true,
  receivesFiles: true,
);

Transfer _transfer(
  String status, {
  String id = 'batch',
  String device = 'friend',
}) => Transfer(
  id: id,
  direction: _out,
  deviceId: device,
  deviceName: '小明',
  peerRole: 'friend',
  status: status,
  items: [ClipItem(name: '$id.txt')],
);

class _CancelState extends AppState {
  _CancelState(List<Transfer> transfers) {
    debugSeed(
      status: Status(),
      config: Config(language: 'zh-Hans'),
      self: Device(id: 'self'),
      friends: [_friend],
      transfers: transfers,
    );
  }

  final cancelled = <String>[];
  Completer<void>? pending;

  @override
  Future<void> cancelTransfer(String id) async {
    cancelled.add(id);
    await pending?.future;
    final t = transfers(_out).firstWhere((t) => t.id == id).deepCopy()
      ..status = 'cancelled'
      ..error = 'cancelled';
    debugEvent(Event(transferChanged: t));
  }
}

Future<BuildContext> _open(WidgetTester tester, AppState state) async {
  await tester.pumpWidget(PasteFerryApp(state: state));
  await tester.pump();
  return tester.element(find.byType(Shell));
}

Future<void> _detail(WidgetTester tester, BuildContext context) async {
  unawaited(
    showDialog<void>(
      context: context,
      builder: (_) => const Dialog(
        child: SizedBox(
          width: 580,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: FriendDetail(friendId: 'friend', inDialog: true),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final status in [
    'scanning',
    'queued',
    'waiting',
    'asking',
    'active',
    'paused',
    'interrupted',
  ]) {
    testWidgets('好友记录可以取消 $status 的发送', (tester) async {
      final state = _CancelState([_transfer(status)]);
      final context = await _open(tester, state);
      final l = context.l10n;
      await _detail(tester, context);
      await tester.tap(
        find.widgetWithText(
          TextButton,
          status == 'queued' ? l.sendRemoveQueued : l.cancel,
        ),
      );
      await tester.pump();
      expect(state.cancelled, ['batch']);
      expect(find.text(l.transferCancelled), findsOneWidget);
      expect(find.byType(TransferCancelButton), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('已结束的好友发送不显示取消', (tester) async {
    final state = _CancelState([
      for (final status in [
        'done',
        'failed',
        'cancelled',
        'declined',
        'expired',
      ])
        _transfer(status, id: status),
    ]);
    final context = await _open(tester, state);
    await _detail(tester, context);
    expect(find.byType(TransferCancelButton), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('重开发送窗口仍能取消该好友的传输，不显示别人的任务', (tester) async {
    final state = _CancelState([
      _transfer('asking'),
      _transfer('active', id: 'other', device: 'another-friend'),
      _transfer('done', id: 'finished'),
    ]);
    final context = await _open(tester, state);
    final l = context.l10n;
    unawaited(showFriendSendDialog(context, SendTarget.friend(_friend)));
    await tester.pumpAndSettle();
    expect(find.text('batch.txt'), findsOneWidget);
    expect(find.text('other.txt'), findsNothing);
    expect(find.text('finished.txt'), findsNothing);
    await tester.tap(find.byTooltip(l.close));
    await tester.pumpAndSettle();
    unawaited(showFriendSendDialog(context, SendTarget.friend(_friend)));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, l.cancel));
    await tester.pump();
    expect(state.cancelled, ['batch']);
    expect(find.text(l.transferCancelled), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('取消请求等待时防止重复点击，失败后可重试', (tester) async {
    final state = _CancelState([_transfer('waiting')])
      ..pending = Completer<void>();
    final context = await _open(tester, state);
    final l = context.l10n;
    await _detail(tester, context);
    final button = find.widgetWithText(TextButton, l.cancel);
    await tester.tap(button);
    await tester.pump();
    expect(tester.widget<TextButton>(button).onPressed, isNull);
    expect(state.cancelled, ['batch']);
    state.pending!.completeError(const GrpcError.internal('cancel failed'));
    await tester.pump();
    expect(
      find.text(
        AppState.describeError(const GrpcError.internal('cancel failed')),
      ),
      findsOneWidget,
    );
    expect(tester.widget<TextButton>(button).onPressed, isNotNull);
    state.pending = null;
    await tester.tap(button);
    await tester.pump();
    expect(state.cancelled, ['batch', 'batch']);
    expect(find.text(l.transferCancelled), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('最小窗口里多批待发送文件仍能滚动并取消', (tester) async {
    tester.view.physicalSize = const Size(760, 520);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final state = _CancelState([
      for (var i = 0; i < 8; i++) _transfer('asking', id: 'batch-$i'),
    ]);
    final context = await _open(tester, state);
    final l = context.l10n;
    unawaited(showFriendSendDialog(context, SendTarget.friend(_friend)));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final list = find.descendant(
      of: find.byType(FriendSendDialog),
      matching: find.byType(ListView),
    );
    await tester.drag(list, const Offset(0, -500));
    await tester.pumpAndSettle();
    final row = find.ancestor(
      of: find.text('batch-7.txt'),
      matching: find.byType(TransferBatchRow),
    );
    await tester.tap(
      find.descendant(
        of: row,
        matching: find.widgetWithText(TextButton, l.cancel),
      ),
    );
    await tester.pump();
    expect(state.cancelled, ['batch-7']);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
