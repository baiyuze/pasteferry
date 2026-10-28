import 'package:flutter/material.dart';

import '../app_state.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../icons.dart';
import '../main.dart' show AppScope;
import '../pages/devices_page.dart' show connectionLabel, platformIcon;
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/nearby_dialog.dart';
import '../widgets/pairing_dialog.dart';
import 'ui.dart';

/// 设备页：已配对的设备，以及用配对码或「搜索附近设备」配对（design/phone-sync.md 3.2.1 节）。
/// 配对的对话框、指纹核对和桌面共用一套（widgets/pairing_dialog.dart、widgets/nearby_dialog.dart）。
class DevicesTab extends StatelessWidget {
  const DevicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final p = context.palette;
    final peers = state.peers;

    final actions = Padding(
      padding: const EdgeInsets.fromLTRB(Insets.lg, 0, Insets.lg, Insets.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            onPressed: () => showPairingDialog(context),
            icon: Icon(AppIcons.plus, size: 20),
            label: Text(l.addDevice),
          ),
          const SizedBox(height: Insets.sm),
          OutlinedButton.icon(
            onPressed: () => showNearbyDialog(context),
            icon: Icon(AppIcons.radar, size: 20, color: p.text),
            label: Text(l.searchNearby),
          ),
        ],
      ),
    );

    return SafeArea(
      bottom: false,
      child: ListView(
        children: [
          MobileHeader(title: l.navDevices),
          const LanNotice(),
          if (peers.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(Insets.xl, Insets.xl, Insets.xl, Insets.xxl),
              child: EmptyState(
                icon: AppIcons.deviceLaptop,
                title: l.noDevicesTitle,
                description: l.mNoDevicesBody,
              ),
            ),
            actions,
          ] else ...[
            MobileGroup(
              title: l.pairedDevices,
              inset: 56,
              children: [for (final d in peers) _DeviceRow(device: d)],
            ),
            actions,
          ],
          if (state.self != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(Insets.xl, 0, Insets.xl, Insets.xl),
              child: Text(
                l.mThisPhoneName(state.self!.name),
                textAlign: TextAlign.center,
                style: context.text.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({required this.device});

  final Device device;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = context.l10n;
    final d = device;
    final synced = !(AppScope.of(context).config?.syncDisabledPeers.contains(d.id) ?? false);
    return MobileTile(
      leading: Icon(platformIcon(d.platform), size: 24, color: p.textDim),
      title: d.name,
      subtitle: [
        d.online ? connectionLabel(d) : l.offline,
        if (!synced) l.syncPaused,
      ].join(' · '),
      trailing: StatusDot(color: d.online ? p.online : p.textFaint, label: ''),
      onTap: () => _showDeviceSheet(context, d),
    );
  }
}

Future<void> _showDeviceSheet(BuildContext context, Device d) => showModalBottomSheet<void>(
  context: context,
  useSafeArea: true,
  builder: (ctx) {
    final state = AppScope.of(ctx);
    final l = ctx.l10n;
    final p = ctx.palette;
    final synced = !(state.config?.syncDisabledPeers.contains(d.id) ?? false);
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.lg, 0, Insets.lg, Insets.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(platformIcon(d.platform), size: 36, color: p.textDim),
          const SizedBox(height: Insets.sm),
          Text(d.name, style: ctx.text.titleMedium, textAlign: TextAlign.center),
          Text(d.online ? connectionLabel(d) : l.offline, style: ctx.text.bodySmall, textAlign: TextAlign.center),
          const SizedBox(height: Insets.lg),
          Container(
            decoration: BoxDecoration(color: p.fill, borderRadius: BorderRadius.circular(Radii.md)),
            child: MobileTile(
              title: l.peerRealtimeSync,
              trailing: Switch(
                value: synced,
                onChanged: (v) async {
                  try {
                    await state.setPeerSync(d.id, v);
                  } catch (e) {
                    if (ctx.mounted) showToast(ctx, AppState.describeError(e), error: true);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: Insets.lg),
          OutlinedButton(
            style: OutlinedButton.styleFrom(foregroundColor: p.danger),
            onPressed: () async {
              Navigator.pop(ctx);
              await _unpair(context, d);
            },
            child: Text(l.unpair),
          ),
        ],
      ),
    );
  },
);

Future<void> _unpair(BuildContext context, Device d) async {
  final state = AppScope.read(context);
  final l = context.l10n;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.unpairTitle(d.name)),
      content: Text(l.unpairBody),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: ctx.palette.danger),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l.unpair),
        ),
      ],
    ),
  );
  if (ok != true) return;
  try {
    await state.unpair(d.id);
    if (context.mounted) showToast(context, l.unpaired);
  } catch (e) {
    if (context.mounted) showToast(context, AppState.describeError(e), error: true);
  }
}
