import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../app_state.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../icons.dart';
import '../main.dart';
import '../theme.dart';
import 'common.dart';

/// 设备页里的「手机网页传输」：开关、显示二维码、已登记的手机（design/phone-sync.md 第 2 节）。
/// 旧版后台服务没有这个功能时不显示。
class WebShareSection extends StatelessWidget {
  const WebShareSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final st = state.webShare;
    if (st == null) return const SizedBox.shrink();
    final l = context.l10n;
    final p = context.palette;
    final error = st.enabled && !st.listening && st.error.isNotEmpty;

    return GroupSection(
      title: l.webShareTitle,
      footnote: l.webShareFootnote,
      child: GroupBox(
        dividerIndent: 52,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Insets.lg,
              Insets.md,
              Insets.lg,
              Insets.md,
            ),
            child: Row(
              children: [
                Icon(AppIcons.phone, size: 22, color: p.textDim),
                const SizedBox(width: Insets.md + 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.webShareSwitch, style: context.text.labelLarge),
                      const SizedBox(height: 2),
                      Text(
                        error
                            ? l.webShareNotListening(st.error)
                            : st.enabled
                            ? l.webShareOn(st.sessions.length)
                            : l.webShareOff,
                        style: context.text.bodySmall?.copyWith(
                          color: error ? p.danger : null,
                        ),
                      ),
                    ],
                  ),
                ),
                if (st.listening) ...[
                  OutlinedButton.icon(
                    onPressed: () => showWebShareDialog(context),
                    icon: Icon(AppIcons.qrCode, size: 14),
                    label: Text(l.webShareShowQr),
                  ),
                  const SizedBox(width: Insets.md),
                ],
                SmallSwitch(
                  value: st.enabled,
                  onChanged: (v) async {
                    try {
                      await AppScope.read(context).setWebShare(v);
                      // 刚打开时直接给出二维码，省得再点一次
                      if (v &&
                          context.mounted &&
                          (AppScope.read(context).webShare?.listening ??
                              false)) {
                        unawaited(showWebShareDialog(context));
                      }
                    } catch (e) {
                      if (context.mounted) {
                        showToast(
                          context,
                          AppState.describeError(e),
                          error: true,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          for (final s in st.sessions) _SessionRow(session: s),
        ],
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session});

  final WebSession session;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;
    final lastSeen = DateTime.fromMillisecondsSinceEpoch(
      session.lastSeenUnix.toInt() * 1000,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        52,
        Insets.sm + 2,
        Insets.sm,
        Insets.sm + 2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.name,
                  style: context.text.bodyMedium?.copyWith(color: p.text),
                ),
                Text(
                  l.webShareLastUsed(relativeTime(lastSeen)),
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                await AppScope.read(context).removeWebSession(session.id);
                if (context.mounted) {
                  showToast(context, l.webShareRemoved(session.name));
                }
              } catch (e) {
                if (context.mounted) {
                  showToast(context, AppState.describeError(e), error: true);
                }
              }
            },
            child: Text(l.webShareRemove),
          ),
        ],
      ),
    );
  }
}

Future<void> showWebShareDialog(BuildContext context) =>
    showDialog<void>(context: context, builder: (_) => const WebShareDialog());

/// 二维码窗口：手机扫码后在浏览器里打开网页。一张二维码只登记一台手机，
/// 被用掉、过期或换了地址时自动换一张；窗口关掉时作废还没被用过的那张。
class WebShareDialog extends StatefulWidget {
  const WebShareDialog({super.key});

  @override
  State<WebShareDialog> createState() => _WebShareDialogState();
}

class _WebShareDialogState extends State<WebShareDialog> {
  WebShareInvite? _invite;
  String _address = '';
  String? _error;
  bool _refreshing = false;
  bool _preparingFirewall = false;
  String? _firewallError;
  Timer? _expiry;
  StreamSubscription<String>? _used;
  late final AppState _state = AppScope.read(context);

  @override
  void initState() {
    super.initState();
    _used = _state.webShareInviteUsed.listen((id) {
      if (id != _invite?.id) return;
      // 扫码登记的那台手机排在列表第一个（按最后使用时间倒序）
      final name = _state.webShare?.sessions.firstOrNull?.name;
      if (mounted && name != null) {
        showToast(context, context.l10n.webShareNewPhone(name));
      }
      _refresh(closeOld: false);
    });
    _refresh();
    // 包括开关自动打开、二维码按钮和托盘入口；只在窗口打开时申请，
    // 不随邀请轮换重复弹 UAC。后台服务会先检查，已放行时直接返回。
    if (_state.self?.platform == 'windows') {
      _preparingFirewall = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _prepareFirewall();
      });
    }
  }

  Future<void> _prepareFirewall() async {
    setState(() {
      _preparingFirewall = true;
      _firewallError = null;
    });
    try {
      await _state.requestLocalNetworkPermission();
    } catch (e) {
      if (mounted) {
        setState(() => _firewallError = AppState.describeError(e));
      }
    } finally {
      if (mounted) setState(() => _preparingFirewall = false);
    }
  }

  @override
  void dispose() {
    _expiry?.cancel();
    _used?.cancel();
    final id = _invite?.id;
    if (id != null) _state.closeWebShareInvite(id);
    super.dispose();
  }

  Future<void> _refresh({bool closeOld = true}) async {
    if (_refreshing) return;
    _refreshing = true;
    final old = _invite?.id;
    try {
      final inv = await _state.newWebShareInvite(_address);
      if (!mounted) {
        _state.closeWebShareInvite(inv.id);
        return;
      }
      setState(() {
        _invite = inv;
        _error = null;
      });
      if (closeOld && old != null) _state.closeWebShareInvite(old);
      // 到期前半分钟换新，窗口开着时二维码一直能用
      _expiry?.cancel();
      final left =
          DateTime.fromMillisecondsSinceEpoch(
            inv.expiresAtUnix.toInt() * 1000,
          ).difference(DateTime.now()) -
          const Duration(seconds: 30);
      _expiry = Timer(
        left.isNegative ? const Duration(seconds: 5) : left,
        _refresh,
      );
    } catch (e) {
      if (mounted) setState(() => _error = AppState.describeError(e));
    } finally {
      _refreshing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final st = AppScope.of(context).webShare;
    final l = context.l10n;
    final p = context.palette;
    final addresses = st?.addresses ?? const <String>[];
    // 地址变了（换了 Wi-Fi）：当前二维码里的地址不在了，换一张
    final current = _invite == null ? null : Uri.tryParse(_invite!.url)?.host;
    if (current != null &&
        addresses.isNotEmpty &&
        !addresses.contains(current) &&
        !_refreshing) {
      _address = '';
      WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
    }

    return Dialog(
      child: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Insets.xl,
              Insets.lg,
              Insets.md,
              Insets.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.webShareDialogTitle,
                        style: context.text.titleMedium,
                      ),
                    ),
                    IconAction(
                      icon: AppIcons.xmark,
                      tooltip: l.close,
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: Insets.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: Insets.sm),
                      Text(
                        l.webShareDialogBody,
                        style: context.text.bodyMedium?.copyWith(
                          color: p.textDim,
                        ),
                      ),
                      if (_state.self?.platform == 'windows') ...[
                        const SizedBox(height: Insets.md),
                        _Note(
                          icon: AppIcons.lockShield,
                          text: _preparingFirewall
                              ? l.webShareFirewallPreparing
                              : _firewallError != null
                              ? l.webShareFirewallFailed
                              : l.webShareFirewallReady,
                        ),
                        if (_firewallError != null) ...[
                          const SizedBox(height: Insets.sm),
                          Text(
                            _firewallError!,
                            style: context.text.bodySmall?.copyWith(
                              color: p.danger,
                            ),
                          ),
                        ],
                        if (!_preparingFirewall)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: OutlinedButton(
                              onPressed: _prepareFirewall,
                              child: Text(l.webShareFirewallAllow),
                            ),
                          ),
                      ],
                      const SizedBox(height: Insets.lg),
                      Center(
                        child: Container(
                          width: 232,
                          height: 232,
                          padding: const EdgeInsets.all(Insets.md),
                          // 二维码一律深色画在白底上：深色模式下也是，反色的码很多扫码器认不出
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(Radii.lg),
                            border: Border.all(color: p.border),
                          ),
                          child: _invite == null
                              ? Center(
                                  child: _error == null
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          _error!,
                                          textAlign: TextAlign.center,
                                          style: context.text.bodySmall
                                              ?.copyWith(color: p.danger),
                                        ),
                                )
                              : QrCodeView(
                                  size: _invite!.qrSize,
                                  modules: Uint8List.fromList(
                                    _invite!.qrModules,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: Insets.md),
                      if (_invite != null)
                        SelectableText(
                          _invite!.url.split('#').first,
                          textAlign: TextAlign.center,
                          style: context.text.bodySmall?.copyWith(
                            fontFamily: monoFamily,
                          ),
                        ),
                      if (addresses.length > 1) ...[
                        const SizedBox(height: Insets.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l.webShareAddress,
                              style: context.text.bodySmall,
                            ),
                            const SizedBox(width: Insets.sm),
                            DropdownButton<String>(
                              value: addresses.contains(current)
                                  ? current
                                  : addresses.first,
                              isDense: true,
                              underline: const SizedBox.shrink(),
                              style: context.text.bodySmall?.copyWith(
                                color: p.text,
                                fontFamily: monoFamily,
                              ),
                              items: [
                                for (final a in addresses)
                                  DropdownMenuItem(value: a, child: Text(a)),
                              ],
                              onChanged: (a) {
                                if (a == null || a == current) return;
                                setState(() => _address = a);
                                _refresh();
                              },
                            ),
                          ],
                        ),
                      ] else if (addresses.isEmpty) ...[
                        const SizedBox(height: Insets.sm),
                        Text(
                          l.webShareNoAddress,
                          textAlign: TextAlign.center,
                          style: context.text.bodySmall?.copyWith(
                            color: p.warning,
                          ),
                        ),
                      ],
                      if (st?.portFallback ?? false) ...[
                        const SizedBox(height: Insets.sm),
                        Text(
                          l.webSharePortFallback,
                          textAlign: TextAlign.center,
                          style: context.text.bodySmall?.copyWith(
                            color: p.warning,
                          ),
                        ),
                      ],
                      const SizedBox(height: Insets.lg),
                      _Note(
                        icon: AppIcons.lockShield,
                        text: l.webShareSecurity,
                      ),
                      const SizedBox(height: Insets.sm),
                      _Note(icon: AppIcons.info, text: l.webShareCantOpen),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: context.palette.textDim),
        const SizedBox(width: Insets.sm),
        Expanded(child: Text(text, style: context.text.bodySmall)),
      ],
    );
  }
}

/// 按后台服务给的点阵画二维码（internal/qrcode）。四周留 4 个模块的空白，这是扫码器要求的静区。
class QrCodeView extends StatelessWidget {
  const QrCodeView({
    super.key,
    required this.size,
    required this.modules,
    this.color = Colors.black,
  });

  final int size;
  final Uint8List modules;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _QrPainter(size, modules, color),
    child: const SizedBox.expand(),
  );
}

class _QrPainter extends CustomPainter {
  _QrPainter(this.n, this.modules, this.color);

  final int n;
  final Uint8List modules;
  final Color color;

  static const quiet = 4;

  @override
  void paint(Canvas canvas, Size size) {
    if (n <= 0 || modules.length != n * n) return;
    final total = n + quiet * 2;
    // 每个模块取整数像素，边缘不会糊
    final cell = (size.shortestSide / total).floorToDouble().clamp(
      1.0,
      double.infinity,
    );
    final origin = Offset(
      (size.width - cell * n) / 2,
      (size.height - cell * n) / 2,
    );
    final paint = Paint()
      ..color = color
      ..isAntiAlias = false;
    final path = Path();
    for (var y = 0; y < n; y++) {
      for (var x = 0; x < n; x++) {
        if (modules[y * n + x] == 1) {
          path.addRect(
            Rect.fromLTWH(
              origin.dx + x * cell,
              origin.dy + y * cell,
              cell,
              cell,
            ),
          );
        }
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_QrPainter old) =>
      old.modules != modules || old.color != color || old.n != n;
}
