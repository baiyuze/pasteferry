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
import '../widgets/common.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkReceiveDir());
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

  /// 默认左右排：雷达在左、列表在右，各自撑满高度。设置里可以改成上下排，雷达限高；
  /// 窗口太窄、左右排放不下时也临时上下排。
  Widget _body(BuildContext context, AppState state, Size size) {
    final l = context.l10n;
    final wide = !(state.config?.sendLayoutStacked ?? false) && size.width >= 760;
    final radar = state.peers.isEmpty
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
    final list = _TransferList(direction: _tab, onDirection: (d) => setState(() => _tab = d), compact: wide);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(title: l.navSend, subtitle: l.sendSubtitle),
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
                    Expanded(flex: 11, child: Padding(padding: const EdgeInsets.only(bottom: Insets.xl), child: radar)),
                    VerticalDivider(width: 1, color: context.palette.border),
                    Expanded(flex: 9, child: list),
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
      ],
    );
  }

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
    for (final d in [...online]..sort((a, b) => rank(a).compareTo(rank(b)))) {
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
    final online = state.peers.where((d) => d.online).toList();
    final offline = state.peers.where((d) => !d.online).toList();
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

    // 轨道的大小：外圈接近正圆，横纵比不超过 1.35，也不比宽度高。
    // 太矮时横向至少 190，内圈斜角上的设备才不会压到中间的本机
    final below = (overflow.isNotEmpty ? 40.0 : 0) + (offline.isNotEmpty ? 28.0 : 0);
    final maxRy = (space.height - below) / 2 - 22;
    final outerRx = math.min(math.max(maxRy * 1.35, 190.0), space.width / 2 - _SendNode.width / 2);
    final outerRy = math.max(80.0, math.min(maxRy, outerRx));
    final innerRx = outerRx * _innerScale;
    final innerRy = outerRy * _innerScale;

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
                at.dx - _SendNode.width / 2, at.dy - _SendNode.avatar / 2, _SendNode.width, _SendNode.avatar + 40);
            _nodeRects[d.id] = rect;
            nodes.add(Positioned(
              key: ValueKey(d.id),
              left: rect.left,
              top: rect.top,
              width: _SendNode.width,
              child: _node(context, state, d),
            ));
          }
          // 圈顶上的小字：内圈是同一网络，外圈是其他网络。外圈没有设备时只标内圈
          Widget caption(String text, double ry) => Positioned(
                left: 0,
                right: 0,
                top: center.dy - ry - 8,
                child: Center(child: _Label(text: text, style: context.text.labelSmall?.copyWith(color: p.textFaint))),
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
                    ),
                  ),
                ),
              ),
              caption(l.sendRingLan, innerRy),
              if (hasOuter) caption(l.sendRingOther, outerRy),
              Positioned(
                left: center.dx - _SendNode.width / 2,
                top: center.dy - _SendNode.avatar / 2,
                width: _SendNode.width,
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
        SizedBox(height: outerRy * 2 + 44, child: radar),
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
                    onPressed: _canSend(d) ? () => _openDialog(d) : null,
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

  /// 发不了的原因，或者能发时的连接方式
  String _statusOf(BuildContext context, AppState state, Device d) {
    final l = context.l10n;
    if (!d.online) return l.offline;
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
    final tip = !d.receivesFiles ? l.sendNeedsUpdateTip(d.name) : _statusOf(context, state, d);
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
        onTap: enabled ? () => _openDialog(d) : null,
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
  }) : super(repaint: pulse);

  final Animation<double> pulse;
  final Color ring;
  final Color wave;
  final Size inner;
  final Size outer;
  final bool highlight;

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
    canvas.drawOval(oval(inner.width, inner.height), rings);
    canvas.drawOval(oval(outer.width, outer.height), rings);
  }

  @override
  bool shouldRepaint(_SendRadarPainter old) =>
      old.ring != ring || old.wave != wave || old.inner != inner || old.outer != outer || old.highlight != highlight;
}

/// 压在轨道线上的文字：底色与页面相同，线在文字处断开。
class _Label extends StatelessWidget {
  const _Label({required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        color: context.palette.background,
        child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: style),
      );
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
  const _TransferList({required this.direction, required this.onDirection, this.compact = false});

  final TransferDirection direction;
  final ValueChanged<TransferDirection> onDirection;

  /// 放在雷达右边时：左边距收窄一些
  final bool compact;

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
          padding: EdgeInsets.fromLTRB(compact ? Insets.lg : Insets.xl, Insets.sm, Insets.xl, Insets.sm),
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
                TextButton(onPressed: () => _clearAll(context), child: Text(l.transfersClearAll)),
            ],
          ),
        ),
        Divider(height: 1, indent: compact ? Insets.lg : Insets.xl, endIndent: Insets.xl, color: context.palette.border),
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
                  itemBuilder: (context, i) => _TransferRow(key: ValueKey(list[i].id), transfer: list[i]),
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
  const _TransferRow({super.key, required this.transfer});

  final Transfer transfer;

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
              Icon(transferIcon(t), size: 18, color: p.textDim),
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

  Widget _trailing(BuildContext context) {
    final l = context.l10n;
    final state = AppScope.read(context);
    final buttons = <Widget>[];
    if (!_out && t.status == 'done' && _present.isNotEmpty) {
      buttons.add(OutlinedButton(onPressed: () => revealFile(_present.first), child: Text(revealLabel(l))));
    }
    if (_out && (t.status == 'interrupted' || t.status == 'paused')) {
      buttons.add(OutlinedButton(onPressed: () => _run(() => state.resumeTransfer(t.id)), child: Text(l.continueAction)));
    }
    if (_out && (t.status == 'failed' || t.status == 'declined') && t.paths.isNotEmpty) {
      buttons.add(OutlinedButton(onPressed: _resend, child: Text(l.transferResend)));
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
    final d = AppScope.read(context).peers.where((x) => x.id == t.deviceId).firstOrNull;
    if (d == null) return;
    await sendFilesTo(context, d, t.paths.toList());
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
