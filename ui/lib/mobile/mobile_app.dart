import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_state.dart';
import '../application_lifecycle.dart' show appNavigatorKey;
import '../daemon_client.dart';
import '../i18n.dart';
import '../icons.dart';
import '../main.dart' show AppScope;
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pairing_dialog.dart';
import 'devices_tab.dart';
import 'host.dart';
import 'records_tab.dart';
import 'send_tab.dart';
import 'settings_tab.dart';
import 'ui.dart';

/// Android 的入口：先让宿主拉起 Go 核心、告诉界面数据目录，再像桌面一样经 gRPC 连上去。
void runMobile() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MobileApp());
}

class MobileApp extends StatefulWidget {
  const MobileApp({super.key, this.state});

  /// 测试用：注入预先填好数据的状态，不去启动 Go 核心
  final AppState? state;

  @override
  State<MobileApp> createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> with WidgetsBindingObserver {
  late final AppState _state = widget.state ?? AppState();
  final _themes = <String, (ThemeData, ThemeData)>{};
  String? _startError;

  @override
  void initState() {
    super.initState();
    if (widget.state == null) {
      WidgetsBinding.instance.addObserver(this);
      _start();
    }
  }

  Future<void> _start() async {
    try {
      DaemonEndpoint.androidDataDir = await Host.start();
      if (mounted) setState(() => _startError = null);
      await _state.connect();
    } catch (e) {
      if (mounted) setState(() => _startError = AppState.describeError(e));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    // 关了「后台保持连接」时，离开前台核心就停了；回到前台重新拉起（重复调用无害）
    if (s == AppLifecycleState.resumed) _start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (widget.state == null) _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: ListenableBuilder(
        listenable: _state,
        builder: (context, _) {
          final locale = localeFromSetting(_state.config?.language ?? '');
          final language =
              (locale ?? resolveLocale(WidgetsBinding.instance.platformDispatcher.locales)).toLanguageTag();
          final (light, dark) = _themes.putIfAbsent(
            language,
            () => (buildMobileTheme(Brightness.light), buildMobileTheme(Brightness.dark)),
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
            localeListResolutionCallback: (preferred, _) => resolveLocale(preferred),
            builder: (context, child) {
              appL10n = context.l10n;
              return child!;
            },
            home: MobileShell(startError: _startError, onRetry: _start),
          );
        },
      ),
    );
  }
}

/// 手机上的字号与触控尺寸：配色、圆角沿用桌面的设计系统（theme.dart），
/// 字号放大一档、控件高 48，和网页传输的页面（web/phone）一致。
ThemeData buildMobileTheme(Brightness brightness) {
  final base = buildTheme(brightness);
  final p = base.extension<AppPalette>()!;
  final text = TextTheme(
    headlineMedium: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: p.text, letterSpacing: -0.6),
    headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: p.text, letterSpacing: -0.4),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: p.text, letterSpacing: -0.3),
    titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: p.text, letterSpacing: -0.2),
    titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: p.text),
    bodyLarge: TextStyle(fontSize: 16, color: p.text, height: 1.45),
    bodyMedium: TextStyle(fontSize: 15, color: p.text, height: 1.45),
    bodySmall: TextStyle(fontSize: 13, color: p.textDim, height: 1.4),
    labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.text),
    labelMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: p.textDim),
    labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: p.textDim),
  );
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md));
  const padding = EdgeInsets.symmetric(horizontal: 18, vertical: 12);
  return base.copyWith(
    textTheme: text,
    splashFactory: InkRipple.splashFactory,
    highlightColor: p.hover,
    iconTheme: IconThemeData(color: p.textDim, size: 22),
    // 主按钮与次要按钮对应网页的 primary、secondary：强调色底 / 浅灰底，禁用时整体变淡。
    // 桌面共用的对话框里用的 OutlinedButton 也画成浅灰底，和网页一致
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: p.accent,
        foregroundColor: Colors.white,
        disabledBackgroundColor: p.accent.withValues(alpha: 0.4),
        disabledForegroundColor: Colors.white.withValues(alpha: 0.8),
        shape: shape,
        padding: padding,
        minimumSize: const Size(0, 48),
        textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: p.text,
        backgroundColor: p.fill,
        disabledForegroundColor: p.text.withValues(alpha: 0.4),
        shape: shape,
        padding: padding,
        minimumSize: const Size(0, 48),
        textStyle: text.labelLarge,
        side: BorderSide.none,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: p.accent,
        shape: shape,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        minimumSize: const Size(0, 44),
        textStyle: text.labelLarge,
      ),
    ),
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      isDense: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintStyle: text.bodyLarge?.copyWith(color: p.textFaint),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.md), borderSide: BorderSide(color: p.border)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        borderSide: BorderSide(color: p.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        borderSide: BorderSide(color: p.accent, width: 1.5),
      ),
    ),
    switchTheme: base.switchTheme.copyWith(materialTapTargetSize: MaterialTapTargetSize.padded),
    dialogTheme: base.dialogTheme.copyWith(titleTextStyle: text.titleMedium, contentTextStyle: text.bodyMedium?.copyWith(color: p.textDim)),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: p.surface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: p.border,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.lg))),
    ),
  );
}

enum MobileTab { records, send, devices, settings }

class MobileShell extends StatefulWidget {
  const MobileShell({super.key, this.startError, this.onRetry, this.initialTab = MobileTab.records});

  /// Go 核心没能启动的原因
  final String? startError;
  final VoidCallback? onRetry;
  final MobileTab initialTab;

  @override
  State<MobileShell> createState() => _MobileShellState();
}

class _MobileShellState extends State<MobileShell> {
  late MobileTab _tab = widget.initialTab;
  bool _pairingDialogOpen = false;

  void select(MobileTab t) => setState(() => _tab = t);

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;

    // 对端发起配对时主动弹出指纹核对，和桌面一样（main.dart 的 Shell）
    final pending = state.pendingPairing;
    if (pending != null && !_pairingDialogOpen) {
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

    final Widget body;
    if (widget.startError != null) {
      body = _StartFailed(error: widget.startError!, onRetry: widget.onRetry);
    } else if (state.link == LinkState.connecting && state.config == null) {
      body = const Center(child: CircularProgressIndicator(strokeWidth: 2.5));
    } else {
      body = IndexedStack(
        index: _tab.index,
        children: [
          const RecordsTab(),
          SendTab(onPair: () => select(MobileTab.devices)),
          const DevicesTab(),
          const SettingsTab(),
        ],
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: body,
        bottomNavigationBar: MobileTabBar(
          index: _tab.index,
          onSelect: (i) => select(MobileTab.values[i]),
          items: [
            (FluentIcons.history_24_regular, FluentIcons.history_24_filled, l.mTabRecords),
            (FluentIcons.send_24_regular, FluentIcons.send_24_filled, l.mTabSend),
            (FluentIcons.laptop_24_regular, FluentIcons.laptop_24_filled, l.navDevices),
            (FluentIcons.settings_24_regular, FluentIcons.settings_24_filled, l.navSettings),
          ],
        ),
      ),
    );
  }
}

class _StartFailed extends StatelessWidget {
  const _StartFailed({required this.error, this.onRetry});

  final String error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Insets.xl),
        child: EmptyState(
          icon: AppIcons.exclamationmarkCircle,
          title: l.mStartFailed(error),
          action: FilledButton(onPressed: onRetry, child: Text(l.retry)),
        ),
      ),
    );
  }
}
