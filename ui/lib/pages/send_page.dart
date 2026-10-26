import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_state.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../icons.dart';
import '../main.dart';
import '../platform.dart';
import '../theme.dart';
import '../widgets/avatar.dart';
import '../widgets/common.dart';
import '../widgets/friend_send_dialog.dart';
import '../widgets/friends_dialog.dart';
import '../widgets/nearby_dialog.dart';
import '../widgets/pairing_dialog.dart';
import '../widgets/radar.dart';
import '../widgets/record_hover.dart';
import '../widgets/send_dialog.dart';
import 'devices_page.dart' show platformIcon;

/// 隔空传送：雷达上是已配对的设备，把文件拖到一台上，或者点它在弹出的窗口里拖，就直接发过去。
/// 下面是收到的和发出的列表。见 design/send-files.md。
class SendPage extends StatefulWidget {
  const SendPage({super.key});

  @override
  State<SendPage> createState() => _SendPageState();
}

/// 雷达上的位置（角度，0 是正右方，顺时针）。雷达上只放在线的设备，离线的在雷达下面列一行。
/// 内圈是同一个局域网里的设备，放在本机的四个斜角，不和「这台 Mac」挤在一行；
/// 外圈是其他网络里的设备，只用左右两个位置。放不下的在雷达下面以小标签列出。
const _innerAngles = [-135.0, -45.0, 135.0, 45.0];
const _outerAngles = [180.0, 0.0];

/// 内圈的大小是外圈的多少
const _innerScale = 0.62;

/// 这次启动以来检查过保存位置没有：macOS 上第一次写「下载」等文件夹时系统会弹窗，要在用户看着的时候触发
bool _receiveDirChecked = false;

class _SendPageState extends State<SendPage> with SingleTickerProviderStateMixin {
  // 从本机向外扩散的一圈柔和的光带，3.2 秒一次
  late final AnimationController _pulse =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 3200));
  TransferDirection _tab = TransferDirection.TRANSFER_DIRECTION_INCOMING;

  /// 拖着文件经过雷达时：光标下的设备
  bool _dragging = false;
  String? _dropTarget;

  /// 发送窗口开着时，雷达不接拖放（窗口下面的雷达也会收到拖放事件）
  bool _dialogOpen = false;

  /// 每台设备在雷达上占一个固定位置：(内圈?, 第几个)
  final Map<String, (bool, int)> _slots = {};

  /// 设备在雷达上的位置，拖放时据此判断落在哪台上
  final Map<String, Rect> _nodeRects = {};

  CheckReceiveDirResponse? _dirCheck;
  Timer? _deliveredTimer;

  /// 附近开着「所有人」的陌生设备（2.6.0），页面打开期间订阅
  List<Stranger> _strangers = const [];
  StreamSubscription<List<Stranger>>? _strangerSub;
  Timer? _strangerRetry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkReceiveDir();
      _watchStrangers();
    });
  }

  void _watchStrangers() {
    if (!mounted) return;
    final state = AppScope.read(context);
    _strangerSub?.cancel();
    if (!state.isOnline) {
      _strangerRetry = Timer(const Duration(seconds: 3), _watchStrangers);
      return;
    }
    try {
      _strangerSub = state.watchStrangers().listen(
        (list) {
          if (mounted) setState(() => _strangers = list);
        },
        onError: (_) {
          // 旧版后台服务没有这个接口，或者连接断了：过一会儿再试
          _strangerRetry = Timer(const Duration(seconds: 10), _watchStrangers);
        },
        cancelOnError: true,
      );
    } catch (_) {
      _strangerRetry = Timer(const Duration(seconds: 10), _watchStrangers);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulse.stop();
    } else if (!_pulse.isAnimating) {
      _pulse.repeat();
    }
  }

  @override
  void dispose() {
    _deliveredTimer?.cancel();
    _strangerSub?.cancel();
    _strangerRetry?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _checkReceiveDir() async {
    if (_receiveDirChecked || !mounted) return;
    final state = AppScope.read(context);
    if (!state.isOnline) return;
    _receiveDirChecked = true;
    try {
      final r = await state.checkReceiveDir();
      if (mounted) setState(() => _dirCheck = r);
    } catch (_) {
      // 旧版后台服务没有这个接口
    }
  }

  Future<void> _openDialog(Device d) async {
    setState(() => _dialogOpen = true);
    await showSendDialog(context, d);
    if (mounted) setState(() => _dialogOpen = false);
  }

  String? _deviceAt(Offset pos) {
    for (final e in _nodeRects.entries) {
      if (e.value.inflate(8).contains(pos)) return e.key;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    // 停在这一页上时，新收到的都算看过
    if (state.unseenTransfers > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => state.markTransfersSeen());
    }
    _scheduleDeliveredRefresh(state);

    return LayoutBuilder(builder: (context, box) => _body(context, state, box.biggest));
  }

  /// 默认左右排：雷达在左、列表在右，各自撑满高度，窗口再窄也是这样。设置里可以改成上下排，雷达限高。
  Widget _body(BuildContext context, AppState state, Size size) {
    final l = context.l10n;
    final wide = !(state.config?.sendLayoutStacked ?? false);
    final ownRadar = state.peers.isEmpty
        ? EmptyState(
            icon: AppIcons.send,
            title: l.sendNoDevicesTitle,
            description: l.sendNoDevicesBody,
            action: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton(onPressed: () => showPairingDialog(context), child: Text(l.addDevice)),
                const SizedBox(width: Insets.sm),
                OutlinedButton(onPressed: () => showNearbyDialog(context), child: Text(l.searchNearby)),
              ],
            ),
          )
        : _radar(context, state);
    // 雷达下面是好友和附近开着「所有人」的设备（2.6.0）
    final radar = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: ownRadar),
        if (state.friends.isNotEmpty)
          _PeopleStrip(
            title: l.friendsStrip,
            people: [for (final f in _sortedFriends(state)) _Person.friend(f)],
          ),
        if (_strangers.isNotEmpty)
          _PeopleStrip(
            title: l.strangersStrip,
            people: [for (final st in _strangers) _Person.stranger(st)],
          ),
      ],
    );
    final listWidth = (size.width * 0.45).clamp(260.0, 460.0);
    final list = _TransferList(
        direction: _tab, onDirection: (d) => setState(() => _tab = d), compact: wide, narrow: wide && listWidth < 340);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: l.navSend,
          subtitle: l.sendSubtitle,
          actions: [
            if (state.profile != null) const _ProfileChip(),
            if (state.profile != null)
              Tooltip(
                message: l.friendsTitle,
                child: TextButton.icon(
                  onPressed: () => showFriendsDialog(context),
                  icon: Icon(AppIcons.people, size: 16),
                  label: Text(state.friends.isEmpty ? l.friendsTitle : '${l.friendsTitle} ${state.friends.length}'),
                ),
              ),
            if (state.profile != null)
              IconAction(icon: AppIcons.personAdd, tooltip: l.addFriend, onTap: () => showAddFriendDialog(context)),
          ],
        ),
        if (_dirCheck != null && !_dirCheck!.ok)
          Padding(
            padding: const EdgeInsets.fromLTRB(Insets.xl, 0, Insets.xl, Insets.md),
            child: Notice(
              title: l.reasonDestUnavailable,
              message: switch (_dirCheck!.error) {
                'not_found' => l.saveDirNotFound,
                'permission_denied' => l.saveDirPermission,
                _ => l.saveDirNotWritable,
              },
            ),
          ),
        Expanded(
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: Padding(padding: const EdgeInsets.only(bottom: Insets.xl), child: radar)),
                    VerticalDivider(width: 1, color: context.palette.border),
                    // 列表占四成五（宽窗口下与雷达 11:9），最窄的窗口里也留出 260
                    SizedBox(width: listWidth, child: list),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: (size.height * 0.46).clamp(240.0, 320.0), child: radar),
                    Expanded(child: list),
                  ],
                ),
        ),
        if (state.profile != null) const _ReceiveFromBar(),
      ],
    );
  }

  List<Friend> _sortedFriends(AppState state) => [...state.friends]
    ..sort((a, b) {
      final ca = friendCanSend(a), cb = friendCanSend(b);
      if (ca != cb) return ca ? -1 : 1;
      if (a.online != b.online) return a.online ? -1 : 1;
      return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
    });

  /// 刚送达的设备在雷达上显示 3 秒「已送达」，到时间刷新一次
  void _scheduleDeliveredRefresh(AppState state) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final recent = state
        .transfers(TransferDirection.TRANSFER_DIRECTION_OUTGOING)
        .where((t) => t.status == 'done' && now - t.finishedAtUnix.toInt() < 3);
    if (recent.isEmpty || _deliveredTimer?.isActive == true) return;
    _deliveredTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() {});
    });
  }

  /// 分配雷达上的位置：已有的不动，新来的按内外圈占空位，换了网络的换到另一圈。
  /// 能发送的排前面：一圈满了时，排得更靠后的设备让出位置，挪到下面的小标签里。
  void _assignSlots(List<Device> online) {
    int rank(Device d) => _canSend(d) ? 0 : 1;
    final ids = {for (final d in online) d.id};
    final byId = {for (final d in online) d.id: d};
    _slots.removeWhere((id, _) => !ids.contains(id));
    // online 已按名字排好；List.sort 不保证稳定，排名相同时再按原来的顺序比
    final order = {for (var i = 0; i < online.length; i++) online[i].id: i};
    for (final d in [...online]..sort((a, b) {
      final r = rank(a).compareTo(rank(b));
      return r != 0 ? r : order[a.id]!.compareTo(order[b.id]!);
    })) {
      final inner = d.lanReachable;
      final cur = _slots[d.id];
      if (cur != null && cur.$1 == inner) continue;
      _slots.remove(d.id);
      final used = {for (final s in _slots.values) if (s.$1 == inner) s.$2};
      final count = inner ? _innerAngles.length : _outerAngles.length;
      var free = List.generate(count, (i) => i).where((i) => !used.contains(i)).firstOrNull;
      if (free == null) {
        final holders = _slots.entries.where((e) => e.value.$1 == inner).toList()
          ..sort((a, b) => rank(byId[b.key]!).compareTo(rank(byId[a.key]!)));
        if (holders.isNotEmpty && rank(byId[holders.first.key]!) > rank(d)) {
          free = holders.first.value.$2;
          _slots.remove(holders.first.key);
        }
      }
      if (free != null) _slots[d.id] = (inner, free);
    }
  }

  Widget _radar(BuildContext context, AppState state) {
    // 后台服务给的设备列表没有固定顺序：按名字排，雷达上的位置和离线那一行每次都一样
    int byName(Device a, Device b) => a.name.toLowerCase().compareTo(b.name.toLowerCase());
    final online = state.peers.where((d) => d.online).toList()..sort(byName);
    final offline = state.peers.where((d) => !d.online).toList()..sort(byName);
    _assignSlots(online);
    final overflow = online.where((d) => !_slots.containsKey(d.id)).toList();
    return LayoutBuilder(builder: (context, box) => _radarIn(context, state, box.biggest, online, offline, overflow));
  }

  /// 雷达只占它需要的高度，在可用空间里垂直居中，下面紧跟着放不下的设备和离线设备。
  Widget _radarIn(BuildContext context, AppState state, Size space, List<Device> online, List<Device> offline,
      List<Device> overflow) {
    final p = context.palette;
    final l = context.l10n;
    final selfPlatform = state.self?.platform ?? Platform.operatingSystem.replaceFirst('macos', 'darwin');
    final hasOuter = _slots.values.any((s) => !s.$1);

    // 在至少 420 宽的逻辑画布上排布，再整体等比缩小；圈和节点使用同一变换。
    // 小窗口仍左右排，但不会把圆拉成长椭圆，也不靠压缩节点间距塞进窄栏。
    final canvasWidth = math.max(space.width, 420.0);
    final nodeW = (canvasWidth * 0.3).clamp(110.0, _SendNode.width);
    final below = (overflow.isNotEmpty ? 40.0 : 0) + (offline.isNotEmpty ? 40.0 : 0);
    final maxR = math.max(146.0, (space.height - below) / 2 - 22);
    final outerRx = math.min(maxR, canvasWidth / 2 - nodeW / 2);
    final outerRy = outerRx;
    final innerRx = outerRx * _innerScale;
    final innerRy = innerRx;

    final radar = DropTarget(
      enable: !_dialogOpen,
      onDragEntered: (e) => setState(() {
        _dragging = true;
        _dropTarget = _deviceAt(e.localPosition);
      }),
      onDragUpdated: (e) {
        final target = _deviceAt(e.localPosition);
        if (target != _dropTarget) setState(() => _dropTarget = target);
      },
      onDragExited: (_) => setState(() {
        _dragging = false;
        _dropTarget = null;
      }),
      onDragDone: (details) {
        final target = _deviceAt(details.localPosition);
        setState(() {
          _dragging = false;
          _dropTarget = null;
        });
        final d = online.where((x) => x.id == target).firstOrNull;
        if (d == null) {
          showToast(context, l.sendDropHint);
        } else if (_canSend(d)) {
          sendFilesTo(context, d, droppedPaths(details));
        }
      },
      child: LayoutBuilder(
        builder: (context, box) {
          final center = box.biggest.center(Offset.zero);
          _nodeRects.clear();
          final nodes = <Widget>[];
          for (final d in online) {
            final slot = _slots[d.id];
            if (slot == null) continue;
            final (inner, i) = slot;
            final a = (inner ? _innerAngles[i] : _outerAngles[i]) * math.pi / 180;
            final at = center +
                Offset((inner ? innerRx : outerRx) * math.cos(a), (inner ? innerRy : outerRy) * math.sin(a));
            final rect = Rect.fromLTWH(
                at.dx - nodeW / 2, at.dy - _SendNode.avatar / 2, nodeW, _SendNode.avatar + 40);
            _nodeRects[d.id] = rect;
            nodes.add(Positioned(
              key: ValueKey(d.id),
              left: rect.left,
              top: rect.top,
              width: nodeW,
              child: _node(context, state, d),
            ));
          }
          // 圆线断开的地方：圈顶的小字左右各让出一点；外圈两侧的设备，名字在图标下面，让出图标往下的一段
          final captionStyle = context.text.labelSmall?.copyWith(color: p.textFaint);
          (double, double) topGap(String text, double rx) {
            final w = (TextPainter(text: TextSpan(text: text, style: captionStyle), textDirection: TextDirection.ltr)
                  ..layout())
                .width;
            final half = math.asin(math.min(1.0, (w / 2 + 6) / rx));
            return (-math.pi / 2 - half, half * 2);
          }
          final below = math.asin(math.min(1.0, (_SendNode.avatar / 2 + 40) / outerRy));
          final outerGaps = <(double, double)>[
            if (hasOuter) topGap(l.sendRingOther, outerRx),
            for (final s in _slots.values)
              if (!s.$1) _outerAngles[s.$2] == 0 ? (0.0, below) : (math.pi - below, below),
          ];
          final innerGaps = [topGap(l.sendRingLan, innerRx)];
          // 圈顶上的小字：内圈是同一网络，外圈是其他网络。外圈没有设备时只标内圈
          Widget caption(String text, double ry) => Positioned(
                left: 0,
                right: 0,
                top: center.dy - ry - 8,
                child: Center(child: _Label(text: text, style: captionStyle)),
              );
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _SendRadarPainter(
                      pulse: _pulse,
                      ring: p.separator,
                      wave: p.accent,
                      inner: Size(innerRx, innerRy),
                      outer: Size(outerRx, outerRy),
                      highlight: _dragging,
                      innerGaps: innerGaps,
                      outerGaps: outerGaps,
                    ),
                  ),
                ),
              ),
              caption(l.sendRingLan, innerRy),
              if (hasOuter) caption(l.sendRingOther, outerRy),
              Positioned(
                left: center.dx - nodeW / 2,
                top: center.dy - _SendNode.avatar / 2,
                width: nodeW,
                child: RadarSelfNode(platform: selfPlatform, size: _SendNode.avatar),
              ),
              ...nodes,
              if (_dragging && _dropTarget == null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -4,
                  child: Text(l.sendDropHint, textAlign: TextAlign.center, style: context.text.bodySmall),
                ),
            ],
          );
        },
      ),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(width: canvasWidth, height: outerRy * 2 + 44, child: radar),
          ),
        ),
        if (overflow.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(Insets.xl, Insets.xs, Insets.xl, 0),
            child: Wrap(
              spacing: Insets.sm,
              runSpacing: Insets.xs,
              alignment: WrapAlignment.center,
              children: [
                for (final d in overflow)
                  ActionChip(
                    avatar: Icon(platformIcon(d.platform), size: 14),
                    // 发不了的写上原因
                    label: Text(_canSend(d) ? d.name : '${d.name} · ${_statusOf(context, state, d)}'),
                    onPressed: _canSend(d)
                        ? () => _openDialog(d)
                        : _connecting(d)
                            ? () => _connect(state, d)
                            : null,
                  ),
              ],
            ),
          ),
        // 离线的设备不上雷达，在这里列一行
        if (offline.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(Insets.xl, Insets.sm, Insets.xl, 0),
            child: Text(
              l.sendOfflineList(offline.map((d) => d.name).join(l.listSeparator)),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.text.bodySmall?.copyWith(color: p.textFaint),
            ),
          ),
      ],
    );
  }

  bool _canSend(Device d) => d.online && d.receivesFiles && !d.receiveDisabled;

  /// 在线、但还不知道对方能不能收文件（还没连上、没收到它的功能声明）。
  /// 这时不能说对方要更新：点它就先去连
  bool _connecting(Device d) => d.online && !d.featuresKnown && !d.receivesFiles;

  void _connect(AppState state, Device d) {
    state.reconnect(d.id).catchError((_) => ConnectionKind.CONNECTION_KIND_UNSPECIFIED);
  }

  /// 发不了的原因，或者能发时的连接方式
  String _statusOf(BuildContext context, AppState state, Device d) {
    final l = context.l10n;
    if (!d.online) return l.offline;
    if (_connecting(d)) return l.reconnecting;
    if (!d.receivesFiles) return l.sendNeedsUpdate;
    if (d.receiveDisabled) return l.sendNotReceiving;
    return routeLabel(l, state, d);
  }

  Widget _node(BuildContext context, AppState state, Device d) {
    final l = context.l10n;
    final p = context.palette;
    final sending = state.sendingTo(d.id);
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final delivered = state
        .transfers(TransferDirection.TRANSFER_DIRECTION_OUTGOING)
        .any((t) => t.deviceId == d.id && t.status == 'done' && now - t.finishedAtUnix.toInt() < 3);
    final enabled = _canSend(d);
    // 名字下面平时不写字，只在发送中、刚送达、或者发不了的时候写一行
    String? note;
    if (!enabled) {
      note = _statusOf(context, state, d);
    } else if (sending != null && sending.status == 'active' && sending.totalBytes > 0) {
      note = '${(sending.doneBytes.toInt() * 100 / sending.totalBytes.toInt()).floor()}%';
    } else if (delivered) {
      note = '✓ ${l.sendDelivered}';
    }
    // 头像右下角的小圆点是连接方式：绿色局域网，蓝色直连，橙色中转
    final dot = !enabled
        ? null
        : d.connection == ConnectionKind.CONNECTION_KIND_RELAY
            ? p.warning
            : d.lanReachable
                ? p.online
                : p.accent;
    final tip = _connecting(d)
        ? l.sendConnectingTip(d.name)
        : d.online && !d.receivesFiles
            ? l.sendNeedsUpdateTip(d.name)
            : _statusOf(context, state, d);
    double? progress;
    if (sending != null) {
      progress = sending.status == 'active' && sending.totalBytes > 0
          ? sending.doneBytes.toInt() / sending.totalBytes.toInt()
          : null;
    }
    return Tooltip(
      message: tip,
      waitDuration: const Duration(milliseconds: 400),
      child: _SendNode(
        device: d,
        note: note,
        dot: dot,
        enabled: enabled,
        dropping: _dragging && enabled,
        dropTarget: _dropTarget == d.id && enabled,
        sending: sending != null,
        progress: progress,
        onTap: enabled
            ? () => _openDialog(d)
            : _connecting(d)
                ? () => _connect(state, d)
                : null,
      ),
    );
  }
}

/// 隔空传送的雷达底图：内外两圈很淡的轨道，一圈柔和的光带从本机向外扩散。
/// 拖着文件经过时轨道稍微亮一点。
class _SendRadarPainter extends CustomPainter {
  _SendRadarPainter({
    required this.pulse,
    required this.ring,
    required this.wave,
    required this.inner,
    required this.outer,
    required this.highlight,
    this.innerGaps = const [],
    this.outerGaps = const [],
  }) : super(repaint: pulse);

  final Animation<double> pulse;
  final Color ring;
  final Color wave;
  final Size inner;
  final Size outer;
  final bool highlight;

  /// 圆线在这些地方断开（起始角度、跨过的角度，弧度，顺时针从正右方算）：圈顶上的小字、外圈两侧设备的名字。
  /// 文字不垫底色，扩散的光带经过时也不会露出一块
  final List<(double, double)> innerGaps;
  final List<(double, double)> outerGaps;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    Rect oval(double rx, double ry) => Rect.fromCenter(center: c, width: rx * 2, height: ry * 2);

    // 扩散的光带：边缘最亮，向里渐隐，越往外越淡
    final t = pulse.value;
    final k = Curves.easeOut.transform(t);
    final rx = 30 + (outer.width - 30) * k;
    final ry = 30 + (outer.height - 30) * k;
    final a = 0.16 * (1 - t);
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.scale(1, ry / rx);
    canvas.drawCircle(
      Offset.zero,
      rx,
      Paint()
        ..shader = RadialGradient(
          colors: [wave.withValues(alpha: 0), wave.withValues(alpha: 0), wave.withValues(alpha: a)],
          stops: const [0, 0.72, 1],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: rx)),
    );
    canvas.restore();

    final rings = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = highlight ? wave.withValues(alpha: 0.35) : ring;
    _ring(canvas, oval(inner.width, inner.height), innerGaps, rings);
    _ring(canvas, oval(outer.width, outer.height), outerGaps, rings);
  }

  /// 画一圈，跳过 gaps 里的几段
  static void _ring(Canvas canvas, Rect rect, List<(double, double)> gaps, Paint paint) {
    if (gaps.isEmpty) {
      canvas.drawOval(rect, paint);
      return;
    }
    const full = 2 * math.pi;
    final sorted = [for (final (start, sweep) in gaps) ((start % full + full) % full, sweep)]
      ..sort((a, b) => a.$1.compareTo(b.$1));
    for (var i = 0; i < sorted.length; i++) {
      final from = sorted[i].$1 + sorted[i].$2;
      var to = i + 1 < sorted.length ? sorted[i + 1].$1 : sorted.first.$1 + full;
      if (to > from) canvas.drawArc(rect, from, to - from, false, paint);
    }
  }

  @override
  bool shouldRepaint(_SendRadarPainter old) =>
      old.ring != ring ||
      old.wave != wave ||
      old.inner != inner ||
      old.outer != outer ||
      old.highlight != highlight ||
      old.innerGaps.toString() != innerGaps.toString() ||
      old.outerGaps.toString() != outerGaps.toString();
}

/// 雷达上的一行文字。不垫底色：圆线在文字处由 _SendRadarPainter 断开。
class _Label extends StatelessWidget {
  const _Label({required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) =>
      Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: style);
}

/// 雷达上的一台设备：圆形图标、右下角表示连接方式的小圆点、名字。正在发给它时图标外面一圈进度环。
class _SendNode extends StatefulWidget {
  const _SendNode({
    required this.device,
    required this.note,
    required this.dot,
    required this.enabled,
    required this.dropping,
    required this.dropTarget,
    required this.sending,
    required this.progress,
    this.onTap,
  });

  static const width = 128.0;
  static const avatar = 52.0;

  final Device device;

  /// 名字下面的一行小字，没有时不显示
  final String? note;

  /// 连接方式的颜色；发不了时为 null
  final Color? dot;
  final bool enabled;

  /// 正拖着文件经过雷达：能接收的设备描边变亮
  final bool dropping;

  /// 光标正在这台设备上：系统蓝、略微放大
  final bool dropTarget;
  final bool sending;
  final double? progress;
  final VoidCallback? onTap;

  @override
  State<_SendNode> createState() => _SendNodeState();
}

class _SendNodeState extends State<_SendNode> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final d = widget.device;
    final highlight = widget.enabled && (_hover || widget.dropTarget);
    final border = widget.dropTarget
        ? p.accent
        : highlight || widget.dropping
            ? p.accent.withValues(alpha: widget.dropTarget || _hover ? 1 : 0.6)
            : p.border;

    final node = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedScale(
          scale: widget.dropTarget ? 1.08 : 1,
          duration: const Duration(milliseconds: 120),
          child: SizedBox.square(
            dimension: _SendNode.avatar,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.dropTarget ? Color.alphaBlend(p.accent.withValues(alpha: 0.08), p.surface) : p.surface,
                    border: Border.all(color: border, width: highlight || widget.dropping ? 1.5 : 1),
                    boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))],
                  ),
                ),
                Icon(platformIcon(d.platform), size: 24, color: highlight ? p.accent : p.textDim),
                if (widget.sending)
                  SizedBox.expand(
                    child: CircularProgressIndicator(strokeWidth: 2, value: widget.progress),
                  ),
                if (widget.dot != null)
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: widget.dot,
                        shape: BoxShape.circle,
                        border: Border.all(color: p.background, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        _Label(text: d.name, style: context.text.labelMedium?.copyWith(color: p.text)),
        if (widget.note != null) _Label(text: widget.note!, style: context.text.labelSmall),
      ],
    );

    return Semantics(
      button: widget.enabled,
      label: d.name,
      child: MouseRegion(
        cursor: widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Opacity(opacity: widget.enabled ? 1 : 0.55, child: node),
        ),
      ),
    );
  }
}

/// 收到的、发出的列表。
class _TransferList extends StatelessWidget {
  const _TransferList({required this.direction, required this.onDirection, this.compact = false, this.narrow = false});

  final TransferDirection direction;
  final ValueChanged<TransferDirection> onDirection;

  /// 放在雷达右边时：左边距收窄一些
  final bool compact;

  /// 列表很窄（小窗口里放在雷达右边）：按钮换成带提示的图标，名字放不下时省略
  final bool narrow;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final list = state.transfers(direction);
    final incoming = direction == TransferDirection.TRANSFER_DIRECTION_INCOMING;
    final finished = list.where((t) => const {'done', 'failed', 'cancelled', 'declined', 'expired'}.contains(t.status));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              narrow ? Insets.md : (compact ? Insets.lg : Insets.xl), Insets.sm, narrow ? Insets.md : Insets.xl, Insets.sm),
          child: Row(
            children: [
              Segmented<TransferDirection>(
                value: direction,
                segments: [
                  (TransferDirection.TRANSFER_DIRECTION_INCOMING, l.transfersReceived),
                  (TransferDirection.TRANSFER_DIRECTION_OUTGOING, l.transfersSent),
                ],
                onChanged: onDirection,
              ),
              const Spacer(),
              if (finished.isNotEmpty)
                narrow
                    ? IconAction(icon: AppIcons.trash, tooltip: l.transfersClearAll, onTap: () => _clearAll(context))
                    : TextButton(onPressed: () => _clearAll(context), child: Text(l.transfersClearAll)),
            ],
          ),
        ),
        Divider(
            height: 1,
            indent: narrow ? Insets.md : (compact ? Insets.lg : Insets.xl),
            endIndent: narrow ? Insets.md : Insets.xl,
            color: context.palette.border),
        Expanded(
          child: list.isEmpty
              ? Center(
                  child: Text(incoming ? l.transfersEmptyReceived : l.transfersEmptySent,
                      style: context.text.bodySmall),
                )
              : ListView.builder(
                  // 收到的、发出的各自记住滚动位置，切换时不沿用另一边的
                  key: PageStorageKey(direction),
                  padding: const EdgeInsets.fromLTRB(Insets.lg, Insets.sm, Insets.lg, Insets.xl),
                  itemCount: list.length,
                  itemBuilder: (context, i) => _TransferRow(key: ValueKey(list[i].id), transfer: list[i], narrow: narrow),
                ),
        ),
      ],
    );
  }

  Future<void> _clearAll(BuildContext context) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.transfersClearTitle),
        content: Text(l.transfersClearBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.clear)),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await AppScope.read(context).deleteTransfers(clearAll: direction);
    } catch (e) {
      if (context.mounted) showToast(context, AppState.describeError(e), error: true);
    }
  }
}

/// 列表里的一批：名称与大小；来自（发给）哪台、时间、状态；进行中的显示进度。
class _TransferRow extends StatefulWidget {
  const _TransferRow({super.key, required this.transfer, this.narrow = false});

  final Transfer transfer;
  final bool narrow;

  @override
  State<_TransferRow> createState() => _TransferRowState();
}

class _TransferRowState extends State<_TransferRow> {
  bool _hovered = false;

  Transfer get t => widget.transfer;
  bool get _out => t.direction == TransferDirection.TRANSFER_DIRECTION_OUTGOING;

  /// 收到的、还在原处的顶层项目
  List<String> get _present => [
        for (var i = 0; i < t.paths.length; i++)
          if (i >= t.present.length || t.present[i]) t.paths[i],
      ];

  bool get _finished => const {'done', 'failed', 'cancelled', 'declined', 'expired'}.contains(t.status);

  @override
  Widget build(BuildContext context) {
    // 鼠标停一会儿列出这一批里的全部文件，与复制记录页的提示框同一个样式
    final row = _content(context);
    if (t.items.isEmpty) return row;
    return RecordHover(record: _asRecord(), details: _TransferDetails(t), child: row);
  }

  /// 悬停提示框认的是复制记录，把这一批包装成一条文件记录
  ClipRecord _asRecord() => ClipRecord(
        id: t.id,
        kind: ClipKind.CLIP_KIND_FILE,
        status: ClipStatus.CLIP_STATUS_READY,
        outgoing: _out,
        originDeviceName: t.deviceName,
        items: [for (final it in t.items) ClipItem(name: it.name, size: it.size, isDir: it.isDir)],
        totalSize: t.totalBytes,
        createdAtUnix: t.finishedAtUnix > 0 ? t.finishedAtUnix : t.createdAtUnix,
      );

  Widget _content(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final active = t.status == 'active';
    final time = DateTime.fromMillisecondsSinceEpoch(
        (t.finishedAtUnix > 0 ? t.finishedAtUnix : t.createdAtUnix).toInt() * 1000);
    final status = active ? '' : transferStatusText(l, t);
    final bad = const {'failed', 'declined'}.contains(t.status);
    final meta = [
      _out ? l.transferTo(t.deviceName) : l.transferFrom(t.deviceName),
      relativeTime(time),
      if (status.isNotEmpty) status,
    ].join(' · ');

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onSecondaryTapUp: (d) => _menu(context, d.globalPosition),
        onDoubleTap: !_out && t.status == 'done' && _present.length == 1 ? () => openUrl(_present.first) : null,
        child: Container(
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
          decoration: BoxDecoration(
            color: _hovered ? p.hover : Colors.transparent,
            borderRadius: BorderRadius.circular(Radii.sm),
          ),
          child: Row(
            children: [
              Icon(_out ? AppIcons.arrowUp : AppIcons.arrowDown, size: 12, color: p.textFaint),
              const SizedBox(width: Insets.xs),
              _thumb(context) ?? Icon(transferIcon(t), size: 18, color: p.textDim),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      [
                        transferTitle(l, t),
                        if (t.fileCount > 1) l.transferFileCount(t.fileCount.toInt()),
                        if (t.totalBytes > 0) humanBytes(t.totalBytes.toInt()),
                      ].join(' · '),
                      style: context.text.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meta,
                      style: context.text.bodySmall?.copyWith(color: bad ? p.danger : null),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // 好友、陌生设备的备注
                    if (t.note.isNotEmpty)
                      Text(l.noteLine(t.note), style: context.text.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                    // Windows 上改过的文件名：只换了名字里不允许的字符，内容不变
                    if (!_out && t.status == 'done' && t.renamedFiles > 0)
                      Text(l.transferRenamed(t.renamedFiles.toInt()), style: context.text.bodySmall),
                    if (active) ...[
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        minHeight: 3,
                        value: t.totalBytes > 0 ? t.doneBytes.toInt() / t.totalBytes.toInt() : null,
                      ),
                      const SizedBox(height: 2),
                      Text(progressLabel(l, t), style: context.text.bodySmall),
                      if (t.currentFile.isNotEmpty && t.fileCount > 1)
                        Text(
                          l.transferCurrent(t.currentFile.split('/').last, '${t.currentIndex}', '${t.fileCount}'),
                          style: context.text.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: Insets.md),
              _trailing(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 收到的图片的缩略图（后台服务重新编码过的），没有时为 null
  Widget? _thumb(BuildContext context) {
    final path = t.thumbs.where((x) => x.isNotEmpty).firstOrNull;
    if (path == null || !File(path).existsSync()) return null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.sm),
      child: Image.file(File(path), width: 36, height: 36, fit: BoxFit.cover, cacheWidth: 72),
    );
  }

  Widget _trailing(BuildContext context) {
    final l = context.l10n;
    final state = AppScope.read(context);
    final buttons = <Widget>[];
    // 列表很窄时用图标按钮，文字放进提示里
    Widget button(IconData icon, String label, VoidCallback onTap) => widget.narrow
        ? IconAction(icon: icon, tooltip: label, onTap: onTap)
        : OutlinedButton(onPressed: onTap, child: Text(label));
    if (!_out && t.status == 'done' && _present.isNotEmpty) {
      buttons.add(button(AppIcons.folder, revealLabel(l), () => revealFile(_present.first)));
    }
    // 好友、陌生设备发来的，等本机用户接受：弹窗关掉了也能在这里处理
    if (!_out && t.status == 'asking') {
      buttons.add(button(AppIcons.xmark, l.incomingDecline, () => _run(() => state.answerIncoming(t.id, false))));
      buttons.add(button(AppIcons.checkmark, l.incomingAccept, () => _run(() => state.answerIncoming(t.id, true))));
      return Row(mainAxisSize: MainAxisSize.min, children: [buttons[0], const SizedBox(width: Insets.xs), buttons[1]]);
    }
    if (_out && (t.status == 'interrupted' || t.status == 'paused')) {
      buttons.add(button(AppIcons.arrowClockwise, l.continueAction, () => _run(() => state.resumeTransfer(t.id))));
    }
    if (_out && (t.status == 'failed' || t.status == 'declined') && t.paths.isNotEmpty) {
      buttons.add(button(AppIcons.arrowClockwise, l.transferResend, _resend));
    }
    if (!_finished) {
      buttons.add(IconAction(icon: AppIcons.xmark, tooltip: l.cancel, onTap: () => _run(() => state.cancelTransfer(t.id))));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < buttons.length; i++) ...[if (i > 0) const SizedBox(width: Insets.xs), buttons[i]],
      ],
    );
  }

  Future<void> _resend() async {
    final state = AppScope.read(context);
    final d = state.peers.where((x) => x.id == t.deviceId).firstOrNull;
    if (d != null) {
      await sendFilesTo(context, d, t.paths.toList());
      return;
    }
    // 好友：带上原来的备注再发一次
    final f = state.friendById(t.deviceId);
    if (f != null) await sendFilesById(context, f.id, f.displayName, t.paths.toList(), note: t.note);
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      if (mounted) showToast(context, AppState.describeError(e), error: true);
    }
  }

  Future<void> _menu(BuildContext context, Offset at) async {
    final l = context.l10n;
    final state = AppScope.read(context);
    final reveal = !_out && t.status == 'done' && _present.isNotEmpty;
    final path = _present.firstOrNull ?? (t.paths.isNotEmpty ? t.paths.first : null);
    final choice = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(at.dx, at.dy, at.dx, at.dy),
      items: [
        if (reveal) PopupMenuItem(value: 'reveal', child: Text(revealLabel(l))),
        if (path != null) PopupMenuItem(value: 'copy', child: Text(l.transferCopyPath)),
        if (_finished) PopupMenuItem(value: 'remove', child: Text(l.transferRemove)),
      ],
    );
    if (!context.mounted) return;
    switch (choice) {
      case 'reveal':
        revealFile(_present.first);
      case 'copy':
        await Clipboard.setData(ClipboardData(text: path!));
        if (context.mounted) showToast(context, l.transferPathCopied);
      case 'remove':
        await _run(() => state.deleteTransfers(ids: [t.id]));
    }
  }
}

/// 悬停提示框要的数据：发出的那一批显示源文件所在的文件夹。
class _TransferDetails implements RecordDetails {
  _TransferDetails(this.t);

  final Transfer t;

  @override
  Future<ClipDetail> clipDetail(String clipId) async => ClipDetail(sourcePaths: t.paths);

  @override
  Future<GetImagePreviewResponse> imagePreview(String clipId, {int index = 0}) async =>
      GetImagePreviewResponse(count: 0);
}


// ─────────────────────────── 好友（2.6.0） ───────────────────────────

/// 页面右上角：本机的头像和好友看到的名字。点头像换头像，点名字改名
class _ProfileChip extends StatelessWidget {
  const _ProfileChip();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final name = state.profile?.displayName ?? '';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SelfAvatarButton(size: 30),
        const SizedBox(width: Insets.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.displayAs, style: context.text.labelSmall),
            InkWell(
              onTap: () => _editName(context, name),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 140),
                    child: Text(name, style: context.text.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 4),
                  Icon(AppIcons.pencil, size: 12, color: context.palette.textFaint),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: Insets.sm),
      ],
    );
  }

  Future<void> _editName(BuildContext context, String current) async {
    final l = context.l10n;
    final c = TextEditingController(text: current);
    final next = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.editName),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: c,
                autofocus: true,
                maxLength: 32,
                decoration: InputDecoration(hintText: l.nameHint),
                onSubmitted: (v) => Navigator.pop(ctx, v),
              ),
              Text(l.nameDefaultHint, style: ctx.text.bodySmall),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, c.text), child: Text(l.save)),
        ],
      ),
    );
    c.dispose();
    if (next == null || !context.mounted) return;
    try {
      await AppScope.read(context).setDisplayName(next.trim());
    } catch (e) {
      if (context.mounted) showToast(context, AppState.describeError(e), error: true);
    }
  }
}

/// 雷达下面的一排人：好友，或者附近开着「所有人」的陌生设备
class _Person {
  _Person.friend(Friend f) : friend = f, stranger = null;
  _Person.stranger(Stranger s) : friend = null, stranger = s;

  final Friend? friend;
  final Stranger? stranger;

  String get id => friend?.id ?? stranger!.id;
  String get name => friend?.displayName ?? stranger!.displayName;
}

class _PeopleStrip extends StatelessWidget {
  const _PeopleStrip({required this.title, required this.people});

  final String title;
  final List<_Person> people;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.xl, Insets.sm, Insets.xl, Insets.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(title, style: context.text.labelSmall?.copyWith(color: p.textFaint)),
              const SizedBox(width: Insets.sm),
              Expanded(child: Divider(color: p.separator, height: 1)),
            ],
          ),
          const SizedBox(height: Insets.sm),
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: people.length,
              separatorBuilder: (_, _) => const SizedBox(width: Insets.sm),
              itemBuilder: (_, i) => _PersonNode(person: people[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonNode extends StatefulWidget {
  const _PersonNode({required this.person});

  final _Person person;

  @override
  State<_PersonNode> createState() => _PersonNodeState();
}

class _PersonNodeState extends State<_PersonNode> {
  bool _dropping = false;
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final p = context.palette;
    final f = widget.person.friend;
    final st = widget.person.stranger;
    final canSend = f != null ? friendCanSend(f) : (st?.receivesFiles ?? false);
    final sending = state.sendingTo(widget.person.id);
    final status = f != null ? friendStatus(l, state, f) : l.strangerNearby;
    final highlight = canSend && (_hover || _dropping);
    return Tooltip(
      message: f != null ? (reachabilityText(l, f) ?? friendTitle(f)) : widget.person.name,
      waitDuration: const Duration(milliseconds: 400),
      child: DropTarget(
        enable: canSend,
        onDragEntered: (_) => setState(() => _dropping = true),
        onDragExited: (_) => setState(() => _dropping = false),
        onDragDone: (details) {
          setState(() => _dropping = false);
          final paths = droppedPaths(details);
          // 拖到头像上直接发，不带备注
          sendFilesById(context, widget.person.id, widget.person.name, paths);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => f != null
                ? openFriendSend(context, f)
                : showFriendSendDialog(context, SendTarget.stranger(st!)),
            // 右键好友：打开好友页（状态、传输记录）
            onSecondaryTap: f != null ? () => showFriendHistory(context, f) : null,
            child: SizedBox(
              width: 84,
              child: Opacity(
                opacity: canSend || (f != null && !f.featuresKnown && f.online) ? 1 : 0.55,
                child: Column(
                  children: [
                    AnimatedScale(
                      scale: _dropping ? 1.08 : 1,
                      duration: const Duration(milliseconds: 120),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: highlight ? p.accent : Colors.transparent, width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: PersonAvatar(
                                deviceId: widget.person.id,
                                name: widget.person.name,
                                hash: f?.avatarHash ?? const [],
                                size: 44,
                                dashed: st != null,
                              ),
                            ),
                          ),
                          if (sending != null)
                            SizedBox.square(
                              dimension: 52,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value: sending.status == 'active' && sending.totalBytes > 0
                                    ? sending.doneBytes.toInt() / sending.totalBytes.toInt()
                                    : null,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(widget.person.name,
                        style: context.text.labelMedium?.copyWith(color: p.text),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text(
                      sending?.status == 'asking'
                          ? l.waitingAccept
                          : sending?.status == 'active' && sending!.totalBytes > 0
                              ? '${(sending.doneBytes.toInt() * 100 / sending.totalBytes.toInt()).floor()}%'
                              : status,
                      style: context.text.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 页面底部：谁可以给我发文件（均不允许 / 仅限好友 / 所有人）。「所有人」显示还剩几分钟
class _ReceiveFromBar extends StatefulWidget {
  const _ReceiveFromBar();

  @override
  State<_ReceiveFromBar> createState() => _ReceiveFromBarState();
}

class _ReceiveFromBarState extends State<_ReceiveFromBar> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 20), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final p = context.palette;
    final v = state.receiveFrom;
    final until = state.everyoneUntil;
    final label = switch (v) {
      'off' => l.receiveFromOff,
      'everyone' when until != null =>
        l.everyoneLeft('${math.max(1, (until.difference(DateTime.now()).inSeconds / 60).ceil())}'),
      'everyone' => l.receiveFromEveryone,
      _ => l.receiveFromFriends,
    };
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: p.border))),
      padding: const EdgeInsets.symmetric(horizontal: Insets.xl, vertical: Insets.sm),
      child: Row(
        children: [
          Text(l.receiveFromLabel, style: context.text.bodySmall),
          PopupMenuButton<String>(
            tooltip: '',
            position: PopupMenuPosition.over,
            onSelected: (next) async {
              try {
                await state.setReceiveFrom(next);
              } catch (e) {
                if (context.mounted) showToast(context, AppState.describeError(e), error: true);
              }
            },
            itemBuilder: (_) => [
              for (final (value, title, desc) in [
                ('off', l.receiveFromOff, l.receiveFromOffDesc),
                ('friends', l.receiveFromFriends, l.receiveFromFriendsDesc),
                ('everyone', l.receiveFromEveryone, l.receiveFromEveryoneDesc),
              ])
                CheckedPopupMenuItem(
                  value: value,
                  checked: v == value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title),
                      SizedBox(
                        width: 280,
                        child: Text(desc, style: context.text.bodySmall),
                      ),
                    ],
                  ),
                ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.xs, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label, style: context.text.bodySmall?.copyWith(color: p.accent)),
                  const SizedBox(width: 2),
                  Icon(AppIcons.chevronDown, size: 12, color: p.accent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
