import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_state.dart';
import 'i18n.dart';

final appNavigatorKey = GlobalKey<NavigatorState>();
const _channel = MethodChannel('com.pasteferry.app/lifecycle');
bool _busy = false;

void installApplicationLifecycle(AppState state) {
  _channel.setMethodCallHandler((call) async {
    final context = appNavigatorKey.currentContext;
    if (context == null) return;
    if (call.method == 'quitRequested') {
      await requestApplicationQuit(context, state);
    }
    if (call.method == 'closeRequested' && context.mounted) {
      await _closeWindow(context);
    }
  });
}

Future<void> requestApplicationQuit(
  BuildContext context,
  AppState state,
) async {
  if (_busy) return;
  _busy = true;
  try {
    if (state.activeTransfers.isNotEmpty) {
      final l = context.l10n;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l.quitApp),
          content: Text(l.quitTransfersWarning),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.quitApp),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    await state.quitApplication();
    exit(0);
  } catch (e) {
    if (context.mounted) {
      final l = context.l10n;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l.quitApp),
          content: Text(AppState.describeError(e)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.close),
            ),
          ],
        ),
      );
    }
  } finally {
    _busy = false;
  }
}

Future<void> _closeWindow(BuildContext context) async {
  if (_busy) return;
  _busy = true;
  try {
    final env = Platform.environment;
    final root = Platform.isWindows
        ? '${env['LOCALAPPDATA']}\\PasteFerry'
        : Platform.isMacOS
        ? '${env['HOME']}/Library/Application Support/PasteFerry'
        : '${env['XDG_DATA_HOME'] ?? '${env['HOME']}/.local/share'}/pasteferry';
    final marker = File('$root/window-close-notice');
    if (!await marker.exists() && context.mounted) {
      final l = context.l10n;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l.backgroundRunningTitle),
          content: Text(l.backgroundRunningBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.close),
            ),
          ],
        ),
      );
      await marker.parent.create(recursive: true);
      await marker.writeAsString('1');
    }
    await _channel.invokeMethod<void>('hideWindow');
  } on FileSystemException {
    await _channel.invokeMethod<void>('hideWindow');
  } finally {
    _busy = false;
  }
}
