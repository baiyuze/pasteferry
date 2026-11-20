import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_state.dart';
import 'i18n.dart';

final appNavigatorKey = GlobalKey<NavigatorState>();
const _channel = MethodChannel('com.pasteferry.app/lifecycle');
bool _busy = false;

/// 主窗口的界面在 100% 时至少要有多大，界面缩放时窗口装不下它乘以倍数就降倍数（见 UiScale）。
/// 原生外壳的最小窗口是 760×520（MainFlutterWindow.swift、flutter_window.cpp、my_application.cc），
/// 界面缩放时乘以倍数；Windows 上那是连边框的大小，里面的内容区小一圈，所以这里留了余量
const mainContentMinSize = Size(740, 480);

/// 告诉原生外壳界面缩放的倍数：最小尺寸跟着放大，窗口比它小时放大窗口。
/// 旧版外壳没有这个方法，不报错（界面那边窗口装不下时自己降倍数，见 UiScale）
Future<void> setWindowUiScale(double scale) async {
  try {
    await _channel.invokeMethod<void>('setUiScale', {'scale': scale});
  } on MissingPluginException {
    // 测试里、旧版外壳
  } on PlatformException catch (e) {
    debugPrint('setUiScale: $e');
  }
}

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
