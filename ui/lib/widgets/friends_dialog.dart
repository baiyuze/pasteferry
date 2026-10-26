import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_state.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../icons.dart';
import '../main.dart';
import '../platform.dart';
import '../theme.dart';
import 'avatar.dart';
import 'common.dart';
import 'friend_send_dialog.dart';
import 'send_dialog.dart';

// 好友：列表、加好友、确认框、和某个好友的传输记录、连不上时的提示。见 design/friends-send.md 第 5、8、9.2 节。

/// 好友的名字一行：「小明 · MacBook Air」
String friendTitle(Friend f) => f.deviceName.isEmpty ? f.displayName : '${f.displayName} · ${f.deviceName}';

/// 好友此刻能不能收文件
bool friendCanSend(Friend f) => f.online && f.receivesFiles && !f.receiveDisabled;

/// 雷达和列表上好友名字下面的小字
String friendStatus(AppLocalizations l, AppState state, Friend f) {
  if (!f.online) {
    return switch (f.reachability) {
      'self_no_service' || 'peer_no_service' => l.friendNeedService,
      'different_server' => l.friendCantReach,
      _ => l.offline,
    };
  }
  if (!f.featuresKnown && !f.receivesFiles) return l.reconnecting;
  if (f.receiveDisabled) return l.sendNotReceiving;
  if (!f.receivesFiles) return l.sendNeedsUpdate;
  return switch (f.connection) {
    ConnectionKind.CONNECTION_KIND_RELAY => l.relay,
    _ => f.lanReachable ? l.sendLan : l.direct,
  };
}

/// 好友连不上时的说明（第 9.2 节）；在线、或者两边同一种服务只是没开机时为 null
String? reachabilityText(AppLocalizations l, Friend f) => switch (f.reachability) {
  'self_no_service' => l.reachSelfNoService(f.displayName),
  'peer_no_service' => l.reachPeerNoService(f.displayName),
  'different_server' => l.reachDifferentServer,
  _ => null,
};

/// 连不上的好友：说明原因，本机没开服务时给出「打开服务…」
Future<void> showReachabilityHint(BuildContext context, Friend f) async {
  final l = context.l10n;
  final text = reachabilityText(l, f);
  if (text == null) return;
  final open = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      content: SizedBox(width: 380, child: Text(text)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.officialAcknowledge)),
        if (f.reachability == 'self_no_service')
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.openService)),
      ],
    ),
  );
  if (open == true && context.mounted) AppScope.read(context).requestPage('settings:connection');
}

// ─────────────────────────── 好友列表 ───────────────────────────

Future<void> showFriendsDialog(BuildContext context) =>
    showDialog<void>(context: context, builder: (_) => const FriendsDialog());

class FriendsDialog extends StatelessWidget {
  const FriendsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final p = context.palette;
    final friends = [...state.friends]
      ..sort((a, b) {
        if (a.online != b.online) return a.online ? -1 : 1;
        return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
      });
    return Dialog(
      child: SizedBox(
        width: 480,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Insets.xl, Insets.lg, Insets.md, Insets.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text(l.friendsTitle, style: context.text.titleMedium)),
                  TextButton.icon(
                    onPressed: () => showAddFriendDialog(context),
                    icon: Icon(AppIcons.plus, size: 16),
                    label: Text(l.addFriend),
                  ),
                  IconAction(icon: AppIcons.xmark, tooltip: l.close, onTap: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: Insets.md),
              if (friends.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, Insets.xl, Insets.md, Insets.xl),
                  child: Column(
                    children: [
                      Text(l.friendsEmpty, style: context.text.titleSmall),
                      const SizedBox(height: Insets.sm),
                      Text(l.friendsEmptyBody, style: context.text.bodySmall, textAlign: TextAlign.center),
                    ],
                  ),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 420),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(right: Insets.md),
                    itemCount: friends.length,
                    separatorBuilder: (_, _) => Divider(height: 1, color: p.separator),
                    itemBuilder: (_, i) => _FriendRow(friend: friends[i]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FriendRow extends StatelessWidget {
  const _FriendRow({required this.friend});

  final Friend friend;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final p = context.palette;
    final f = friend;
    final last = f.lastActivityUnix.toInt();
    final sub = [
      friendStatus(l, state, f),
      last > 0
          ? l.friendLastActivity(relativeTime(DateTime.fromMillisecondsSinceEpoch(last * 1000)))
          : l.friendNoActivity,
      if (f.autoAccept) l.friendAutoAccept,
    ].join(' · ');
    return GestureDetector(
      onSecondaryTapUp: (d) => _menu(context, d.globalPosition),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.sm),
        child: Row(
          children: [
            Opacity(
              opacity: f.online ? 1 : 0.55,
              child: PersonAvatar(deviceId: f.id, name: f.displayName, hash: f.avatarHash, size: 36),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(friendTitle(f), style: context.text.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(sub, style: context.text.bodySmall?.copyWith(color: p.textDim), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            TextButton(onPressed: () => openFriendSend(context, f), child: Text(l.friendSendAction)),
            Builder(
              builder: (bctx) => IconAction(
                icon: AppIcons.ellipsis,
                tooltip: l.friendsTitle,
                onTap: () {
                  final box = bctx.findRenderObject() as RenderBox;
                  _menu(context, box.localToGlobal(box.size.bottomLeft(Offset.zero)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _menu(BuildContext context, Offset at) async {
    final l = context.l10n;
    final state = AppScope.read(context);
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final v = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(at & const Size(1, 1), Offset.zero & overlay.size),
      items: [
        PopupMenuItem(value: 'send', child: Text(l.friendSendAction)),
        PopupMenuItem(value: 'history', child: Text(l.friendHistory)),
        CheckedPopupMenuItem(value: 'auto', checked: friend.autoAccept, child: Text(l.friendAutoAccept)),
        const PopupMenuDivider(),
        PopupMenuItem(value: 'remove', child: Text(l.friendRemove, style: TextStyle(color: context.palette.danger))),
      ],
    );
    if (!context.mounted) return;
    try {
      switch (v) {
        case 'send':
          await openFriendSend(context, friend);
        case 'history':
          await showFriendHistory(context, friend);
        case 'auto':
          await state.setFriendAutoAccept(friend.id, !friend.autoAccept);
        case 'remove':
          final ok = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(l.friendRemoveTitle(friend.displayName)),
              content: SizedBox(width: 380, child: Text(l.friendRemoveBody)),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: context.palette.danger),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(l.friendRemove),
                ),
              ],
            ),
          );
          if (ok == true) await state.removeFriend(friend.id);
      }
    } catch (e) {
      if (context.mounted) showToast(context, AppState.describeError(e), error: true);
    }
  }
}

/// 点一个好友：能发就打开发送窗口；连不上时说明原因
Future<void> openFriendSend(BuildContext context, Friend f) async {
  final l = context.l10n;
  if (!f.online && reachabilityText(l, f) != null) {
    await showReachabilityHint(context, f);
    return;
  }
  if (!f.online) {
    showToast(context, l.sendErrOffline(f.displayName), error: true);
    return;
  }
  if (!f.featuresKnown && !f.receivesFiles) {
    unawaited(AppScope.read(context).reconnect(f.id).catchError((_) => ConnectionKind.CONNECTION_KIND_UNSPECIFIED));
  }
  await showFriendSendDialog(context, SendTarget.friend(f));
}

// ─────────────────────────── 加好友 ───────────────────────────

Future<void> showAddFriendDialog(BuildContext context) =>
    showDialog<void>(context: context, builder: (_) => const AddFriendDialog());

/// 加好友：上面显示本机的好友码，下面可以输入对方的。别人兑换了本机的码，由主窗口弹出确认框
class AddFriendDialog extends StatefulWidget {
  const AddFriendDialog({super.key});

  @override
  State<AddFriendDialog> createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends State<AddFriendDialog> {
  String? _code;
  DateTime? _expires;
  String? _error;
  bool _loading = true;
  bool _redeeming = false;
  String? _redeemError;
  final _input = TextEditingController();
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _generate();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    _input.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final got = await AppScope.read(context).createFriendCode();
      if (mounted) {
        setState(() {
          _code = got.code;
          _expires = DateTime.now().add(const Duration(minutes: 5));
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = friendErrorText(context.l10n, e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _redeem() async {
    final code = _input.text.trim();
    if (code.isEmpty || _redeeming) return;
    setState(() {
      _redeeming = true;
      _redeemError = null;
    });
    try {
      final r = await AppScope.read(context).redeemFriendCode(code);
      if (!mounted) return;
      Navigator.pop(context);
      await showFriendConfirmDialog(context, r);
    } catch (e) {
      if (mounted) setState(() => _redeemError = friendErrorText(context.l10n, e));
    } finally {
      if (mounted) setState(() => _redeeming = false);
    }
  }

  String _formatCode(String c) => c.length == 7 ? '${c[0]}-${c.substring(1)}' : c;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final left = _expires?.difference(DateTime.now());
    final expired = left != null && left.isNegative;
    return Dialog(
      child: SizedBox(
        width: 440,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Insets.xl, Insets.lg, Insets.md, Insets.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text(l.addFriend, style: context.text.titleMedium)),
                  IconAction(icon: AppIcons.xmark, tooltip: l.close, onTap: () => Navigator.pop(context)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: Insets.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: Insets.lg),
                    if (_loading)
                      const Padding(
                        padding: EdgeInsets.all(Insets.xl),
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    else if (_error != null)
                      Notice(title: l.codeFailedTitle, message: _error!)
                    else ...[
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            await Clipboard.setData(ClipboardData(text: _code ?? ''));
                            if (context.mounted) showToast(context, l.codeCopied);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: Insets.lg),
                            decoration: BoxDecoration(color: p.fill, borderRadius: BorderRadius.circular(Radii.md)),
                            child: Text(
                              expired ? '—' : _formatCode(_code ?? ''),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                fontFamily: monoFamily,
                                letterSpacing: 6,
                                color: p.text,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Insets.sm),
                      if (expired)
                        Center(child: TextButton(onPressed: _generate, child: Text(l.retry)))
                      else if (left != null)
                        Text(
                          l.friendCodeExpires('${left.inMinutes}:${(left.inSeconds % 60).toString().padLeft(2, '0')}'),
                          textAlign: TextAlign.center,
                          style: context.text.labelSmall,
                        ),
                      const SizedBox(height: Insets.md),
                      Text(l.friendCodeShare, style: context.text.bodySmall),
                      const SizedBox(height: Insets.xs),
                      Text(l.friendCodeWaiting, style: context.text.bodySmall?.copyWith(color: p.textFaint)),
                    ],
                    const SizedBox(height: Insets.xl),
                    Row(
                      children: [
                        Expanded(child: Divider(color: p.separator)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Insets.md),
                          child: Text(l.friendCodeOr, style: context.text.bodySmall),
                        ),
                        Expanded(child: Divider(color: p.separator)),
                      ],
                    ),
                    const SizedBox(height: Insets.lg),
                    Text(l.friendCodeEnter, style: context.text.labelLarge),
                    const SizedBox(height: Insets.sm),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _input,
                            enabled: !_redeeming,
                            textCapitalization: TextCapitalization.characters,
                            decoration: const InputDecoration(hintText: 'F-XXXXXX', isDense: true),
                            onSubmitted: (_) => _redeem(),
                          ),
                        ),
                        const SizedBox(width: Insets.sm),
                        FilledButton(
                          onPressed: _redeeming ? null : _redeem,
                          child: _redeeming
                              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                              : Text(l.friendCodeAdd),
                        ),
                      ],
                    ),
                    if (_redeemError != null) ...[
                      const SizedBox(height: Insets.sm),
                      Text(_redeemError!, style: context.text.bodySmall?.copyWith(color: p.danger)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 加好友出错时给用户看的话
String friendErrorText(AppLocalizations l, Object e) => switch (AppState.pairingFailure(e)) {
  PairingFailure.friendCode => l.friendErrFriendCode,
  PairingFailure.deviceCode => l.friendErrDeviceCode,
  PairingFailure.peerOutdated => l.friendErrOutdated,
  PairingFailure.alreadyPaired => l.friendErrAlreadyPaired,
  PairingFailure.noChannel || PairingFailure.notFound => l.friendErrNoChannel,
  PairingFailure.wrongCode => l.codeWrong,
  PairingFailure.codeExpired => l.codeExpired,
  _ => AppState.describeError(e),
};

/// 加好友的确认框：对方的名字和电脑，可展开的安全码。点了「添加」后等对方也添加
Future<void> showFriendConfirmDialog(BuildContext context, FriendRequest r) => showDialog<void>(
  context: context,
  barrierDismissible: false,
  builder: (_) => FriendConfirmDialog(request: r),
);

class FriendConfirmDialog extends StatefulWidget {
  const FriendConfirmDialog({super.key, required this.request});

  final FriendRequest request;

  @override
  State<FriendConfirmDialog> createState() => _FriendConfirmDialogState();
}

class _FriendConfirmDialogState extends State<FriendConfirmDialog> {
  bool _showCode = false;
  bool _waiting = false;
  bool _closing = false;

  Future<void> _respond(bool accept) async {
    final state = AppScope.read(context);
    try {
      await state.confirmFriend(widget.request.session, accept);
      if (!mounted) return;
      if (!accept) {
        Navigator.pop(context);
        return;
      }
      setState(() => _waiting = true);
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      showToast(context, friendErrorText(context.l10n, e), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final p = context.palette;
    final r = widget.request;
    final name = r.displayName.isEmpty ? r.deviceName : r.displayName;
    // 两边都添加了，或者对方取消了：关掉并提示
    if (_waiting && !_closing) {
      final added = state.friendById(r.deviceId) != null;
      final cancelled = state.friendCancelled(r.deviceId);
      if (added || cancelled) {
        _closing = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.pop(context);
          showToast(context, added ? l.friendAdded(name) : l.friendPeerCancelled(name), error: !added);
        });
      }
    }
    return Dialog(
      child: SizedBox(
        width: 420,
        child: Padding(
          padding: const EdgeInsets.all(Insets.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.addFriend, style: context.text.titleMedium),
              const SizedBox(height: Insets.lg),
              Row(
                children: [
                  PersonAvatar(deviceId: r.deviceId, name: name, size: 44),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: Text(
                      l.friendConfirmBody(r.deviceName.isEmpty ? name : '$name · ${r.deviceName}'),
                      style: context.text.bodyLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Insets.lg),
              InkWell(
                onTap: () => setState(() => _showCode = !_showCode),
                child: Row(
                  children: [
                    Icon(_showCode ? AppIcons.chevronDown : AppIcons.chevronRight, size: 14, color: p.textDim),
                    const SizedBox(width: Insets.xs),
                    Text(l.friendSafetyCode, style: context.text.bodySmall),
                  ],
                ),
              ),
              if (_showCode) ...[
                const SizedBox(height: Insets.sm),
                Container(
                  padding: const EdgeInsets.all(Insets.md),
                  decoration: BoxDecoration(color: p.fill, borderRadius: BorderRadius.circular(Radii.md)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final fp in ([r.fingerprint, r.selfFingerprint]..sort()))
                        Text(fp, style: TextStyle(fontFamily: monoFamily, fontSize: 18, letterSpacing: 2, color: p.text)),
                      const SizedBox(height: Insets.sm),
                      Text(l.friendSafetyHint, style: context.text.bodySmall),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: Insets.xl),
              if (_waiting)
                Row(
                  children: [
                    const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                    const SizedBox(width: Insets.sm),
                    Expanded(child: Text(l.friendWaitingPeer, style: context.text.bodySmall)),
                    TextButton(onPressed: () => Navigator.pop(context), child: Text(l.close)),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => _respond(false), child: Text(l.cancel)),
                    const SizedBox(width: Insets.sm),
                    FilledButton(onPressed: () => _respond(true), child: Text(l.friendCodeAdd)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── 传输记录 ───────────────────────────

Future<void> showFriendHistory(BuildContext context, Friend f) =>
    showDialog<void>(context: context, builder: (_) => _FriendHistoryDialog(friendId: f.id));

class _FriendHistoryDialog extends StatelessWidget {
  const _FriendHistoryDialog({required this.friendId});

  final String friendId;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final p = context.palette;
    final f = state.friendById(friendId);
    if (f == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) Navigator.pop(context);
      });
      return const SizedBox.shrink();
    }
    final list = [
      ...state.transfers(TransferDirection.TRANSFER_DIRECTION_INCOMING),
      ...state.transfers(TransferDirection.TRANSFER_DIRECTION_OUTGOING),
    ].where((t) => t.deviceId == friendId).toList()
      ..sort((a, b) => b.createdAtUnix.compareTo(a.createdAtUnix));
    return Dialog(
      child: SizedBox(
        width: 520,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Insets.xl, Insets.lg, Insets.md, Insets.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  PersonAvatar(deviceId: f.id, name: f.displayName, hash: f.avatarHash, size: 32),
                  const SizedBox(width: Insets.md),
                  Expanded(child: Text(l.friendHistoryTitle(friendTitle(f)), style: context.text.titleMedium)),
                  TextButton(onPressed: () => openFriendSend(context, f), child: Text(l.friendSendAction)),
                  IconAction(icon: AppIcons.xmark, tooltip: l.close, onTap: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: Insets.md),
              if (list.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(Insets.xl),
                  child: Text(l.friendHistoryEmpty, textAlign: TextAlign.center, style: context.text.bodySmall),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 440),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(right: Insets.md),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => Divider(height: 1, color: p.separator),
                    itemBuilder: (_, i) => _HistoryRow(transfer: list[i]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.transfer});

  final Transfer transfer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final t = transfer;
    final out = t.direction == TransferDirection.TRANSFER_DIRECTION_OUTGOING;
    final when = DateTime.fromMillisecondsSinceEpoch(t.createdAtUnix.toInt() * 1000);
    final status = t.status == 'active' ? progressLabel(l, t) : transferStatusText(l, t);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 18,
            child: Text(out ? '↑' : '↓', style: context.text.labelLarge?.copyWith(color: p.textDim)),
          ),
          SizedBox(width: 76, child: Text(relativeTime(when), style: context.text.bodySmall)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  [transferTitle(l, t), if (t.totalBytes > 0) humanBytes(t.totalBytes.toInt())].join(' · '),
                  style: context.text.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (t.note.isNotEmpty)
                  Text(l.noteLine(t.note), style: context.text.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                if (status.isNotEmpty)
                  Text(
                    status,
                    style: context.text.bodySmall?.copyWith(
                      color: t.status == 'failed' || t.status == 'declined' ? p.danger : p.textDim,
                    ),
                  ),
              ],
            ),
          ),
          if (!out && t.status == 'done' && t.paths.isNotEmpty)
            TextButton(onPressed: () => revealFile(t.paths.first), child: Text(revealLabel(l))),
        ],
      ),
    );
  }
}
