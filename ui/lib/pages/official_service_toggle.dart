import 'package:flutter/material.dart';

import '../app_state.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../widgets/common.dart';

/// Use the same confirmation and persisted service mode from both entry points.
Future<void> setOfficialService(
  BuildContext context,
  AppState state,
  bool enabled,
) async {
  final cfg = state.config;
  if (cfg == null) return;
  if (enabled) {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.officialEnableTitle),
        content: Text(
          '${context.l10n.officialPrivacy}${cfg.serviceMode == ServiceMode.SERVICE_MODE_CUSTOM ? '\n\n${context.l10n.officialSwitchConfirm}' : ''}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.l10n.useOfficialService),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
  }
  try {
    final next = cfg.deepCopy()
      ..serviceMode = (enabled
          ? ServiceMode.SERVICE_MODE_OFFICIAL
          : ServiceMode.SERVICE_MODE_LAN)
      ..signalingUrl = '';
    await state.updateConfig(next);
  } catch (e) {
    if (context.mounted) {
      showToast(context, AppState.describeError(e), error: true);
    }
  }
}
