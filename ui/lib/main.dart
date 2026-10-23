import 'dart:io';

import 'package:flutter/material.dart';

import 'app_state.dart';
import 'application_lifecycle.dart';
import 'gen/pasteferry/v1/daemon.pb.dart' show TransferDirection;
import 'background_service.dart';
import 'i18n.dart';
import 'pages/devices_page.dart';
import 'pages/favorites_page.dart';
import 'pages/history_page.dart';
import 'pages/send_page.dart';
import 'pages/service_page.dart';
import 'pages/settings_page.dart';
import 'pages/official_service_page.dart';
import 'picker/picker_main.dart';
import 'theme.dart';
import 'widgets/common.dart';
import 'widgets/pairing_dialog.dart';
import 'widgets/update_dialog.dart';
import 'icons.dart';

/// 带 --picker 启动的是快捷粘贴窗口进程，见 picker/picker_main.dart。
void main(List<String> args) {
  if (args.contains('--picker')) {
    runPicker();
    return;
  }
  runApp(const PasteFerryApp());
}

class PasteFerryApp extends StatefulWidget {
  const PasteFerryApp({super.key, this.state});

  /// 测试与截图用：注入预先填好数据的状态，不去连真实的后台服务。
  final AppState? state;

  @override
  State<PasteFerryApp> createState() => _PasteFerryAppState();
}

class _PasteFerryAppState extends State<PasteFerryApp> {
  late final AppState _state;

  /// 按界面语言缓存的浅色、深色主题：Windows 上中文和日文的汉字用不同的字体
  final _themes = <String, (ThemeData, ThemeData)>{};

  @override
  void initState() {
    super.initState();
    _state = widget.state ?? (AppState()..connect());
    if (widget.state == null) installApplicationLifecycle(_state);
  }

  @override
  void dispose() {
    if (widget.state == null) _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AppScope 必须包在 MaterialApp 外面：showDialog 推出的路由挂在 Navigator 上，
    // 与 home 是兄弟而非后代，放在 home 里的话对话框里就取不到 AppState。
    return AppScope(
      state: _state,
      // 语言设置存在后台服务的配置里，配置变了要重建 MaterialApp 才会换语言
      child: ListenableBuilder(
        listenable: _state,
        builder: (context, _) {
          final locale = localeFromSetting(_state.config?.language ?? '');
          // zh、zh-Hant-TW、zh-Hant-HK、en、ja：Windows 与 Linux 上按它挑汉字字体
          final language =
              (locale ??
                      resolveLocale(
                        WidgetsBinding.instance.platformDispatcher.locales,
                      ))
                  .toLanguageTag();
          final (light, dark) = _themes.putIfAbsent(
            language,
            () => (
              buildTheme(Brightness.light, language: language),
              buildTheme(Brightness.dark, language: language),
            ),
          );
          return MaterialApp(
            title: 'PasteFerry',
            navigatorKey: appNavigatorKey,
            debugShowCheckedModeBanner: false,
            theme: light,
            darkTheme: dark,
            locale: locale,
            supportedLocales: supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            localeListResolutionCallback: (preferred, _) =>
                resolveLocale(preferred),
            builder: (context, child) {
              appL10n = context.l10n;
              return child!;
            },
            home: const Shell(),
          );
        },
      ),
    );
  }
}

/// 把 AppState 传递给整棵子树。用 InheritedNotifier 而非引入
/// provider 之类的依赖——状态只有一个，没必要为此多一个包。
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope 未在上层提供');
    return scope!.notifier!;
  }

  /// 只读取一次、不订阅变化。用于事件回调里拿实例。
  static AppState read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppScope>()!.notifier!;
}

enum Section { history, favorites, send, devices, official, settings }

class Shell extends StatefulWidget {
  const Shell({super.key, this.initialSection = Section.history});

  final Section initialSection;

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> with WidgetsBindingObserver {
  late Section _section = widget.initialSection;
  bool _pairingDialogOpen = false;
  bool _officialDialogOpen = false;
  int _seenOfficialNavigation = 0;
  int _seenPageRequest = 0;
  String? _shownUpdateResult;
  AppLifecycleState _lifecycle = AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lifecycle =
        WidgetsBinding.instance.lifecycleState ?? AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (mounted) setState(() => _lifecycle = state);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    if (state.officialNavigationSerial != _seenOfficialNavigation) {
      _seenOfficialNavigation = state.officialNavigationSerial;
      if (state.officialEnabled) _section = Section.official;
    }
    // 点了隔空传送的通知：后台服务让界面切到隔空传送页
    if (state.pageRequestSerial != _seenPageRequest) {
      _seenPageRequest = state.pageRequestSerial;
      if (state.pageRequest == 'send') _section = Section.send;
    }
    if (!state.officialEnabled && _section == Section.official) {
      _section = Section.settings;
    }

    // 对端发起配对时主动弹出确认——指纹核对不能等用户自己去翻页面
    final pending = state.pendingPairing;
    if (pending != null && !_pairingDialogOpen && !_officialDialogOpen) {
      _pairingDialogOpen = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        if (state.pendingPairing?.pairingSession != pending.pairingSession) {
          setState(() => _pairingDialogOpen = false);
          return;
        }
        await showPairingConfirmDialog(context, pending);
        if (mounted) setState(() => _pairingDialogOpen = false);
      });
    }
    final notice = state.officialNoticeKey;
    if (notice != null &&
        pending == null &&
        !_pairingDialogOpen &&
        !_officialDialogOpen &&
        _lifecycle == AppLifecycleState.resumed) {
      _officialDialogOpen = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        if (state.officialNoticeKey != notice ||
            _lifecycle != AppLifecycleState.resumed) {
          setState(() => _officialDialogOpen = false);
          return;
        }
        final l = context.l10n;
        final reason = state.officialUsage?.reason;
        final view = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              reason == 'quota_exhausted'
                  ? l.officialQuotaTitle
                  : l.officialService,
            ),
            content: Text(
              reason == 'quota_exhausted'
                  ? l.officialQuotaBody
                  : reason == 'peer_quota_exhausted'
                  ? l.officialPeerQuota
                  : l.officialPaused,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l.officialAcknowledge),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l.officialViewUsage),
              ),
            ],
          ),
        );
        try {
          await state.acknowledgeOfficialNotice(notice);
        } catch (e) {
          if (context.mounted) {
            showToast(context, AppState.describeError(e), error: true);
          }
        }
        if (mounted) {
          setState(() {
            _officialDialogOpen = false;
            if (view == true && state.officialEnabled) {
              _section = Section.official;
            }
          });
        }
      });
    }

    // 自动更新后重新打开时提示一次结果
    final updated = state.lastUpdate;
    if (updated != null) {
      final key =
          '${updated.fromVersion}>${updated.toVersion}@${updated.atUnix}';
      if (key != _shownUpdateResult) {
        _shownUpdateResult = key;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final l = context.l10n;
          showToast(
            context,
            updated.ok
                ? l.updatedTo(updated.toVersion)
                : l.updateNotFinished(updated.fromVersion),
            error: !updated.ok,
          );
        });
      }
    }

    // 后台服务没装或没在跑时，其他页面都无从谈起，先引导把它启用
    final service = state.serviceState;
    final needsService =
        state.link == LinkState.offline &&
        service != null &&
        service != ServiceState.running;

    return Scaffold(
      body: Row(
        children: [
          _Sidebar(
            current: _section,
            onSelect: (s) => setState(() => _section = s),
          ),
          Expanded(
            child: needsService
                ? const ServicePage()
                : switch (_section) {
                    Section.history => const HistoryPage(),
                    Section.favorites => const FavoritesPage(),
                    Section.send => const SendPage(),
                    Section.devices => const DevicesPage(),
                    Section.official => const OfficialServicePage(),
                    Section.settings => const SettingsPage(),
                  },
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.current, required this.onSelect});

  final Section current;
  final ValueChanged<Section> onSelect;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = context.palette;
    final l = context.l10n;

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: p.sidebar,
        border: Border(right: BorderSide(color: p.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mac 上顶部留白是红绿灯按钮所在的标题栏（内容铺满了整个窗口）；
          // Windows 用系统标题栏，内容从标题栏下面开始
          SizedBox(height: Platform.isMacOS ? 52 : Insets.lg),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Insets.lg,
              0,
              Insets.lg,
              Insets.lg,
            ),
            child: Row(
              children: [
                const AppMark(size: 22),
                const SizedBox(width: Insets.sm),
                Text(l.appName, style: context.text.titleSmall),
              ],
            ),
          ),
          _NavItem(
            icon: AppIcons.clock,
            label: l.navHistory,
            selected: current == Section.history,
            trailing: state.records.isEmpty ? null : '${state.records.length}',
            onTap: () => onSelect(Section.history),
          ),
          _NavItem(
            icon: AppIcons.star,
            label: l.navFavorites,
            selected: current == Section.favorites,
            trailing: state.favorites.isEmpty
                ? null
                : '${state.favorites.length}',
            onTap: () => onSelect(Section.favorites),
          ),
          _NavItem(
            icon: AppIcons.send,
            label: l.navSend,
            selected: current == Section.send,
            // 有文件在收发时显示进度环，否则显示新收到、还没看过的批数
            trailingWidget: _SendBadge(state: state),
            onTap: () => onSelect(Section.send),
          ),
          // 分两组：上面是用的（复制的内容、发文件），下面是管的（设备、服务、设置）
          const SizedBox(height: Insets.lg),
          _NavItem(
            icon: AppIcons.deviceLaptop,
            label: l.navDevices,
            selected: current == Section.devices,
            onTap: () => onSelect(Section.devices),
          ),
          if (state.officialEnabled)
            _NavItem(
              icon: Icons.cloud_outlined,
              label: l.officialService,
              selected: current == Section.official,
              onTap: () => onSelect(Section.official),
            ),
          _NavItem(
            icon: AppIcons.gear,
            label: l.navSettings,
            selected: current == Section.settings,
            onTap: () => onSelect(Section.settings),
          ),
          const Spacer(),
          const _UpdateHint(),
          const _ConnectionFooter(),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.trailing,
    this.trailingWidget,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? trailing;
  final Widget? trailingWidget;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final selected = widget.selected;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.sm, vertical: 1),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: selected
                  ? p.selection
                  : (_hovered ? p.hover : Colors.transparent),
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 16,
                  color: selected ? p.accent : p.textDim,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.label,
                    style: context.text.labelLarge?.copyWith(
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                if (widget.trailing != null)
                  Text(widget.trailing!, style: context.text.labelSmall),
                ?widget.trailingWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 侧边栏「隔空传送」右边的标记：有文件在收发时是一个小进度环（悬停列出每一批），
/// 否则是新收到、还没看过的批数，都没有时不显示。
class _SendBadge extends StatelessWidget {
  const _SendBadge({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final active = state.activeTransfers;
    if (active.isEmpty) {
      final n = state.unseenTransfers;
      return n == 0
          ? const SizedBox.shrink()
          : Text('$n', style: context.text.labelSmall);
    }
    final lines = [
      for (final t in active)
        () {
          final percent = t.totalBytes > 0
              ? '${(t.doneBytes.toInt() * 100 / t.totalBytes.toInt()).floor()}%'
              : '…';
          return t.direction == TransferDirection.TRANSFER_DIRECTION_OUTGOING
              ? l.sendingTo(t.deviceName, percent)
              : l.receivingFrom(t.deviceName, percent);
        }(),
    ];
    return Tooltip(
      message: lines.join('\n'),
      child: SizedBox.square(
        dimension: 12,
        child: CircularProgressIndicator(
          strokeWidth: 1.6,
          value: state.transferProgress,
        ),
      ),
    );
  }
}

/// 自动检查发现新版本时，侧边栏底部多一行，点开是更新窗口。不弹窗打扰。
class _UpdateHint extends StatelessWidget {
  const _UpdateHint();

  @override
  Widget build(BuildContext context) {
    final version = AppScope.of(context).updateAvailable;
    if (version.isEmpty) return const SizedBox.shrink();
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.sm, 0, Insets.sm, Insets.xs),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          foregroundColor: p.accent,
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        onPressed: () => showUpdateDialog(context),
        icon: Icon(AppIcons.arrowDownCircle, size: 16),
        label: Text(
          context.l10n.updateSidebar(version),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

/// 侧边栏底部的连接状态。常驻可见，用户不必进设置页就知道能不能用。
class _ConnectionFooter extends StatelessWidget {
  const _ConnectionFooter();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = context.palette;
    final signaling = state.status?.signalingConnected ?? false;
    final online = state.onlinePeerCount;
    final l = context.l10n;

    // 服务器是可选的：没填地址时只在局域网里同步，是正常状态，不用警示色
    final (color, label) = switch (state.link) {
      LinkState.connecting => (p.textFaint, l.linkConnecting),
      LinkState.offline => (p.danger, state.error ?? l.linkServiceNotRunning),
      LinkState.online when state.lanBlocked => (p.warning, l.linkLanBlocked),
      LinkState.online when online > 0 => (p.online, l.linkOnlinePeers(online)),
      LinkState.online when state.serverConfigured && !signaling => (
        p.warning,
        state.lanEnabled ? l.linkServerUnreachable : l.notConnected,
      ),
      LinkState.online when state.serverConfigured => (
        p.online,
        l.linkServerConnected,
      ),
      LinkState.online when state.lanEnabled => (p.textFaint, l.linkLanMode),
      LinkState.online => (p.warning, l.linkNothingOn),
    };

    return Container(
      padding: const EdgeInsets.fromLTRB(
        Insets.lg,
        Insets.md,
        Insets.lg,
        Insets.md,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: p.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: Insets.sm),
          Expanded(
            child: Text(
              label,
              style: context.text.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
