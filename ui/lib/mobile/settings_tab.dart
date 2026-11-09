import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:protobuf/protobuf.dart';

import '../app_state.dart';
import '../i18n.dart';
import '../main.dart' show AppScope;
import '../icons.dart';
import '../star_prompt.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'host.dart';
import 'update_check.dart';
import 'send_tab.dart' show sentRetentionDays;
import 'ui.dart';
import '../pixel_art.dart';

/// 设置页：本机名称、收到文字后写不写剪贴板、后台保持连接与相关的系统权限、版本。
class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> with WidgetsBindingObserver {
  bool? _keepAlive;
  String? _notifications;
  bool? _battery;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    // 从系统设置回来：权限可能变了
    if (s == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _refresh() async {
    try {
      final keep = await Host.keepAlive();
      final notif = await Host.notifications();
      final battery = await Host.batteryUnrestricted();
      if (mounted) {
        setState(() {
          _keepAlive = keep;
          _notifications = notif;
          _battery = battery;
        });
      }
    } on MissingPluginException {
      // 测试里没有宿主
    }
  }

  Future<void> _rename() async {
    final state = AppScope.read(context);
    final l = context.l10n;
    final cfg = state.config;
    if (cfg == null) return;
    final controller = TextEditingController(text: cfg.deviceName);
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deviceName),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 40,
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, controller.text), child: Text(l.save)),
        ],
      ),
    );
    controller.dispose();
    final trimmed = name?.trim() ?? '';
    if (trimmed.isEmpty || trimmed == cfg.deviceName) return;
    try {
      await state.updateConfig(cfg.deepCopy()..deviceName = trimmed);
      if (mounted) showToast(context, l.deviceNameUpdated);
    } catch (e) {
      if (mounted) showToast(context, AppState.describeError(e), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final p = context.palette;
    final cfg = state.config;

    return SafeArea(
      bottom: false,
      child: ListView(
        children: [
          MobileHeader(title: l.navSettings),
          MobileGroup(
            children: [
              MobileTile(
                title: l.deviceName,
                subtitle: cfg?.deviceName ?? '',
                trailing: Icon(Icons.chevron_right, color: p.textFaint),
                onTap: _rename,
              ),
            ],
          ),
          MobileGroup(
            title: l.mSectionSync,
            children: [
              MobileTile(
                title: l.mSentRetention,
                subtitle: l.mSentRetentionDesc('${sentRetentionDays(cfg)}'),
                trailing: Icon(Icons.chevron_right, color: p.textFaint),
                onTap: () => _pickRetention(context),
              ),
            ],
          ),
          MobileGroup(
            title: l.mSectionSync,
            children: [
              MobileTile(
                title: l.autoApply,
                subtitle: l.mAutoApplyDesc,
                trailing: Switch(
                  value: cfg?.autoApplyToClipboard ?? true,
                  onChanged: cfg == null
                      ? null
                      : (v) async {
                          try {
                            await state.updateConfig(cfg.deepCopy()..autoApplyToClipboard = v);
                          } catch (e) {
                            if (context.mounted) showToast(context, AppState.describeError(e), error: true);
                          }
                        },
                ),
              ),
            ],
          ),
          // 外观：选主题、浅色与深色（只在这台手机上，不同步）
          ListenableBuilder(
            listenable: state.theme,
            builder: (context, _) {
              final theme = state.theme;
              final current = theme.themes.where((t) => t.id == theme.id).firstOrNull;
              return MobileGroup(
                title: l.appearance,
                children: [
                  MobileTile(
                    title: l.themeTitle,
                    subtitle: current?.displayName(l) ?? l.themeDefault,
                    trailing: Icon(Icons.chevron_right, color: p.textFaint),
                    onTap: () => _pick<String>(
                      context,
                      l.themeTitle,
                      [for (final t in theme.themes) (t.id, t.displayName(l))],
                      theme.id,
                      theme.select,
                    ),
                  ),
                  MobileTile(
                    title: l.themeMode,
                    subtitle: switch (theme.mode) {
                      ThemeMode.light => l.themeModeLight,
                      ThemeMode.dark => l.themeModeDark,
                      ThemeMode.system => l.themeModeSystem,
                    },
                    trailing: Icon(Icons.chevron_right, color: p.textFaint),
                    onTap: () => _pick<ThemeMode>(
                      context,
                      l.themeMode,
                      [
                        (ThemeMode.system, l.themeModeSystem),
                        (ThemeMode.light, l.themeModeLight),
                        (ThemeMode.dark, l.themeModeDark),
                      ],
                      theme.mode,
                      theme.setMode,
                    ),
                  ),
                  // 背景图：选一张照片铺在底下。自带主题不能改，第一次设置时复制一份
                  MobileTile(
                    title: l.themeBackground,
                    subtitle: l.themeBackgroundDesc,
                    trailing: Icon(Icons.chevron_right, color: p.textFaint),
                    onTap: () => _pick<String>(
                      context,
                      l.themeBackground,
                      [
                        ('choose', theme.background == null ? l.themeBackgroundChoose : l.themeBackgroundChange),
                        if (theme.background != null) ('remove', l.themeBackgroundRemove),
                      ],
                      '',
                      (v) async {
                        if (v == 'remove') return theme.removeBackground();
                        final files = await Host.pickFiles(photos: true);
                        if (files.isEmpty) return;
                        final copied = await theme.setBackgroundImage(files.first.path, l);
                        if (copied != null && context.mounted) showToast(context, l.themeCopiedForEdit(copied));
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          MobileGroup(
            title: l.mSectionBackground,
            children: [
              MobileTile(
                title: l.mKeepAlive,
                subtitle: l.mKeepAliveDesc,
                trailing: Switch(
                  value: _keepAlive ?? true,
                  onChanged: _keepAlive == null
                      ? null
                      : (v) async {
                          setState(() => _keepAlive = v);
                          await Host.setKeepAlive(v);
                        },
                ),
              ),
              MobileTile(
                title: l.mNotifications,
                subtitle: l.mNotificationsDesc,
                trailing: _notifications == 'granted'
                    ? Text(l.mAllowed, style: context.text.bodySmall)
                    : TextButton(
                        onPressed: () async {
                          final s = await Host.requestNotifications();
                          if (mounted) setState(() => _notifications = s);
                        },
                        child: Text(l.mAllow),
                      ),
              ),
              MobileTile(
                title: l.mBattery,
                subtitle: l.mBatteryDesc,
                trailing: _battery == true
                    ? Text(l.mAllowed, style: context.text.bodySmall)
                    : TextButton(onPressed: Host.requestBatteryUnrestricted, child: Text(l.mAllow)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Insets.xl, 0, Insets.xl, Insets.xxl),
            child: Column(
              children: [
                const AppMark(size: 40),
                const SizedBox(height: Insets.sm),
                Text(l.appName, style: context.text.titleSmall),
                Text(l.mVersion(state.status?.version ?? ''), style: context.text.bodySmall),
                const SizedBox(height: Insets.md),
                _UpdateTile(current: state.status?.version ?? ''),
                TextButton.icon(
                  onPressed: () => Host.openUrl(StarPrompt.url),
                  icon: Icon(AppIcons.star, size: 18),
                  label: Text(l.starAction),
                ),
                Text(l.aboutDesc, style: context.text.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 底部弹出的单选列表：选主题、选浅色深色
Future<void> _pick<T>(
  BuildContext context,
  String title,
  List<(T, String)> options,
  T current,
  Future<void> Function(T) onPick,
) async {
  final picked = await showModalBottomSheet<T>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Insets.lg, 0, Insets.lg, Insets.sm),
            child: Text(title, style: ctx.text.titleMedium),
          ),
          for (final (value, label) in options)
            MobileTile(
              title: label,
              trailing: value == current ? Icon(Icons.check, color: ctx.palette.accent) : null,
              onTap: () => Navigator.pop(ctx, value),
            ),
          const SizedBox(height: Insets.md),
        ],
      ),
    ),
  );
  if (picked == null || picked == current) return;
  try {
    await onPick(picked);
  } catch (e) {
    if (context.mounted) showToast(context, AppState.describeError(e), error: true);
  }
}

/// 检查更新：版本号从更新清单里读（地址固定），有新版就在浏览器里下 APK。
class _UpdateTile extends StatefulWidget {
  const _UpdateTile({required this.current});

  final String current;

  @override
  State<_UpdateTile> createState() => _UpdateTileState();
}

class _UpdateTileState extends State<_UpdateTile> {
  bool _busy = false;
  String? _latest;
  String? _error;

  Future<void> _check() async {
    final l = context.l10n;
    setState(() {
      _busy = true;
      _error = null;
      _latest = null;
    });
    final v = await UpdateCheck.latest();
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (v == null) {
        _error = l.mUpdateFailed;
      } else if (UpdateCheck.isNewer(v, widget.current)) {
        _latest = v;
      } else {
        _latest = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    return Column(
      children: [
        OutlinedButton(
          onPressed: _busy ? null : _check,
          child: _busy
              ? const SizedBox.square(dimension: 16, child: ThemedSpinner(strokeWidth: 2))
              : Text(l.mCheckUpdate),
        ),
        if (_error != null) ...[
          const SizedBox(height: Insets.xs),
          Text(_error!, style: TextStyle(fontSize: 12, color: p.danger)),
        ],
        if (_latest != null && _latest!.isEmpty) ...[
          const SizedBox(height: Insets.xs),
          Text(l.mUpToDate, style: TextStyle(fontSize: 12, color: p.textDim)),
        ],
        if (_latest != null && _latest!.isNotEmpty) ...[
          const SizedBox(height: Insets.xs),
          Text(l.mNewVersion(_latest!), style: TextStyle(fontSize: 12, color: p.accent)),
          const SizedBox(height: Insets.xs),
          FilledButton(
            onPressed: () => Host.openUrl(UpdateCheck.apkUrl),
            child: Text(l.mDownloadInstall),
          ),
        ],
      ],
    );
  }
}

/// 选「发送记录」保留几天：1、3、7、30 天
Future<void> _pickRetention(BuildContext context) async {
  final l = context.l10n;
  final state = AppScope.read(context);
  final cfg = state.config;
  if (cfg == null) return;
  final days = await showModalBottomSheet<int>(
    context: context,
    useSafeArea: true,
    builder: (ctx) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final d in const [1, 3, 7, 30])
          ListTile(
            title: Text(l.mSentRetentionDays(d)),
            trailing: sentRetentionDays(cfg) == d ? const Icon(Icons.check) : null,
            onTap: () => Navigator.pop(ctx, d),
          ),
      ],
    ),
  );
  if (days == null) return;
  try {
    await state.updateConfig(cfg.deepCopy()..sentRetentionDays = days);
  } catch (_) {}
}
