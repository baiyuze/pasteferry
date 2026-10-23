import 'dart:async';
import 'dart:io' show pid;

import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';

import 'background_service.dart';
import 'daemon_client.dart';
import 'i18n.dart';
import 'quick_paste_service.dart';
import 'gen/pasteferry/v1/daemon.pb.dart';
import 'gen/pasteferry/v1/daemon.pbgrpc.dart' show DaemonServiceClient;
import 'widgets/record_hover.dart' show RecordDetails;

/// daemon 连接的生命周期状态。
enum LinkState { connecting, online, offline }

/// 生成的配对码，以及本机的局域网地址（不在同一网段时对方要输入）。
typedef PairingCode = ({String code, List<String> addresses});

/// 隔空传送发不出去的原因，后台服务把它写在错误消息里（见 rpc/send.go）。
enum SendFailure {
  offline,
  unsupported,
  disabled,
  needRelayConsent,
  noPaths,
  unknownDevice,
  other,
}

/// 配对失败的原因。后台服务把原因写在错误消息开头（见 rpc/server.go 的 pairingStatus）。
enum PairingFailure {
  notFound,
  wrongCode,
  codeExpired,
  badAddress,
  noChannel,
  other,
}

/// 应用的单一状态源。
///
/// 所有与 daemon 的交互都经过这里：页面只读状态、调方法，不直接碰 gRPC。
/// 这样断线重连、事件合并这些琐事集中在一处，页面代码保持干净。
class AppState extends ChangeNotifier implements RecordDetails {
  AppState({BackgroundService? service, QuickPasteService? quickPasteService})
    : service = service ?? BackgroundService(),
      quickPasteService = quickPasteService ?? QuickPasteService();

  final BackgroundService service;

  /// Mac 上快捷粘贴窗口的 LaunchAgent，见 quick_paste_service.dart
  final QuickPasteService quickPasteService;

  DaemonConnection? _conn;
  StreamSubscription<Event>? _events;
  Timer? _retry;

  LinkState _link = LinkState.connecting;
  String? _error;
  Status? _status;
  Config? _config;
  Device? _self;
  List<Device> _peers = const [];
  final List<ClipRecord> _records = [];

  /// 收藏，按收藏时间倒序。和复制记录是两份，见 design/quick-paste-and-favorites.md 第 3 节
  final List<ClipRecord> _favorites = [];

  /// 悬停提示框要显示的完整内容，按记录 ID 缓存：内容不会变
  final Map<String, ClipDetail> _details = {};

  /// 快捷粘贴窗口的状态，由后台服务转来；没连上时为 null
  QuickPasteStatus? _quickPaste;

  /// 隔空传送的传输记录，收到的和发出的都在里面，按时间倒序。见 design/send-files.md
  final List<Transfer> _transfers = [];

  /// 后台服务要界面切到的页面（点了隔空传送的通知），每次请求 serial 加一
  String _pageRequest = '';
  int _pageRequestSerial = 0;

  /// 正在传输的记录的进度（0–1），只在界面上展示，传完即移除。
  final Map<String, double> _progress = {};
  final Map<String, ClipboardWriteResult> _clipboardResults = {};
  NotificationStatus? _notificationStatus;
  NotificationStatus? get notificationStatus => _notificationStatus;
  ClipboardWriteResult? clipboardResultOf(String id) => _clipboardResults[id];

  /// 复制记录与收藏各自的搜索。界面只加载最新的 200 条复制记录，更早的只有后台服务能搜到，
  /// 所以不在界面里筛选。
  late final _historySearch = _RecordSearch(
    notify: notifyListeners,
    request: (q) => requestSearch(q),
    local: () => _records,
  );
  late final _favoriteSearch = _RecordSearch(
    notify: notifyListeners,
    request: (q) => requestFavoriteSearch(q),
    local: () => _favorites,
  );

  /// 待用户核对指纹的配对请求。非空时界面弹出确认。
  Device? _pendingPairing;
  final Set<String> _handledPairingSessions = {};

  /// 连不上后台服务时，它的安装状态。界面据此决定显示欢迎页还是重启提示。
  ServiceState? _serviceState;
  bool _serviceChecked = false;
  bool _sessionStartTried = false;
  bool _quitting = false;
  Future<void>? _maintenance;
  Future<void>? _connectionWork;

  LinkState get link => _link;
  String? get error => _error;
  Status? get status => _status;
  Config? get config => _config;
  Device? get self => _self;
  List<Device> get peers => List.unmodifiable(_peers);
  List<ClipRecord> get records => List.unmodifiable(_records);
  List<ClipRecord> get favorites => List.unmodifiable(_favorites);

  /// 按 ID 找一条记录：复制记录、收藏，以及只在搜索结果里出现的较早记录都算。
  ClipRecord? recordById(String id) =>
      _records.where((r) => r.id == id).firstOrNull ??
      _favorites.where((r) => r.id == id).firstOrNull ??
      _historySearch.resultsView?.where((r) => r.id == id).firstOrNull;

  /// 全部收藏的大小之和。硬链接、写时复制保存的副本实际占用更少，界面上写「最多」
  int get favoritesBytes =>
      _favorites.fold(0, (n, r) => n + r.totalSize.toInt());

  QuickPasteStatus? get quickPaste => _quickPaste;

  List<Transfer> transfers(TransferDirection direction) =>
      List.unmodifiable(_transfers.where((t) => t.direction == direction));

  /// 收到了、还没在隔空传送页看过的批数（侧边栏的数字）
  int get unseenTransfers => _transfers
      .where(
        (t) =>
            t.direction == TransferDirection.TRANSFER_DIRECTION_INCOMING &&
            !t.seen &&
            t.status == 'done',
      )
      .length;

  /// 正在收发的批次（统计、等待、传输中），侧边栏据此显示进度环
  List<Transfer> get activeTransfers => _transfers
      .where((t) => const {'scanning', 'waiting', 'active'}.contains(t.status))
      .toList();

  /// 所有正在传的批次合起来的进度（0–1）；没有在传的为 null
  double? get transferProgress {
    var total = 0, done = 0;
    for (final t in _transfers) {
      if (t.status != 'active' && t.status != 'waiting') continue;
      total += t.totalBytes.toInt();
      done += t.doneBytes.toInt();
    }
    if (total <= 0) return activeTransfers.isEmpty ? null : 0;
    return (done / total).clamp(0.0, 1.0);
  }

  /// 正在发给这台设备的一批（雷达上的进度环）
  Transfer? sendingTo(String deviceId) => _transfers
      .where(
        (t) =>
            t.direction == TransferDirection.TRANSFER_DIRECTION_OUTGOING &&
            t.deviceId == deviceId &&
            const {
              'scanning',
              'waiting',
              'active',
              'queued',
            }.contains(t.status),
      )
      .lastOrNull;

  String get pageRequest => _pageRequest;
  int get pageRequestSerial => _pageRequestSerial;

  /// 正在搜索复制记录（搜索词不是空白）。
  bool get searching => _historySearch.active;
  String get searchQuery => _historySearch.query.trim();

  /// 搜到的记录，按时间倒序；没在搜索、或这次搜索还没出结果时为 null。
  List<ClipRecord>? get searchResults => _historySearch.resultsView;

  /// 收藏页的搜索，与复制记录的分开。
  bool get searchingFavorites => _favoriteSearch.active;
  String get favoriteQuery => _favoriteSearch.query.trim();
  List<ClipRecord>? get favoriteResults => _favoriteSearch.resultsView;

  /// 传输进度；总量未知或尚未开始时为 null。
  double? progressOf(String clipId) => _progress[clipId];
  Device? get pendingPairing => _pendingPairing;
  ServiceState? get serviceState => _serviceState;

  bool get isOnline => _link == LinkState.online;
  int get onlinePeerCount => _peers.where((p) => p.online).length;

  /// 设置里填了服务器地址。没填时只在局域网里同步，不算异常。
  bool get serverConfigured => _status?.serverConfigured ?? false;
  bool get lanEnabled => _status?.lanEnabled ?? false;
  bool get officialEnabled =>
      _config?.serviceMode == ServiceMode.SERVICE_MODE_OFFICIAL;
  OfficialUsage? get officialUsage =>
      _status?.hasOfficialUsage() == true ? _status!.officialUsage : null;
  int _officialNavigationSerial = 0;
  int get officialNavigationSerial => _officialNavigationSerial;
  final Set<String> _acknowledgedOfficial = {};
  String? get officialNoticeKey {
    if (!officialEnabled) return null;
    final u = officialUsage;
    if (u == null ||
        !const {
          'quota_exhausted',
          'peer_quota_exhausted',
          'global_exhausted',
          'global_paused',
          'relay_blocked',
          'device_banned',
        }.contains(u.reason)) {
      return null;
    }
    final day = u.day.isNotEmpty
        ? u.day
        : DateTime.now()
              .toUtc()
              .add(const Duration(hours: 8))
              .toIso8601String()
              .substring(0, 10);
    final key = '${u.quotaGroup}:$day:${u.reason}';
    if (_acknowledgedOfficial.contains(key) ||
        (_config?.officialNoticeAck ?? '').split('\n').contains(key)) {
      return null;
    }
    return key;
  }

  Future<void> acknowledgeOfficialNotice(String key) async {
    _acknowledgedOfficial.add(key);
    final cfg = _config;
    if (cfg == null) return;
    final keys = {
      ...cfg.officialNoticeAck.split('\n').where((s) => s.isNotEmpty),
      key,
    }.toList();
    final next = cfg.deepCopy()
      ..officialNoticeAck = keys
          .skip(keys.length > 64 ? keys.length - 64 : 0)
          .join('\n');
    await updateConfig(next);
  }

  /// macOS 拦下了发往局域网的包：用户还没允许「本地网络」权限。
  bool get lanBlocked => _status?.lanBlocked ?? false;

  /// 详细日志打开到什么时候；没打开时为 null。
  DateTime? get verboseLogUntil {
    final until = _status?.verboseLogUntilUnix.toInt() ?? 0;
    return until == 0
        ? null
        : DateTime.fromMillisecondsSinceEpoch(until * 1000);
  }

  @override
  void dispose() {
    _retry?.cancel();
    _historySearch.dispose();
    _favoriteSearch.dispose();
    _events?.cancel();
    _conn?.close();
    super.dispose();
  }

  // ─────────────────────────── 连接 ───────────────────────────

  Future<void> connect() => _connectionWork = _connect();

  Future<void> _connect() async {
    if (_quitting) return;
    _retry?.cancel();
    _setLink(LinkState.connecting, null);
    await _replaceLegacyService();

    try {
      final conn = await DaemonConnection.connect();
      _conn = conn;

      // 首屏需要的数据一次取齐，避免界面分几次闪烁
      final results = await Future.wait([
        conn.client.listHistory(ListHistoryRequest(limit: 200)),
        conn.client.getConfig(Empty()),
        conn.client.getStatus(Empty()),
        conn.client.listHistory(
          ListHistoryRequest(limit: 500, favorites: true),
        ),
      ]);

      _records
        ..clear()
        ..addAll((results[0] as ListHistoryResponse).records);
      if (_quitting) {
        await conn.close();
        return;
      }
      _config = results[1] as Config;
      _status = results[2] as Status;
      // 旧版后台服务不认识 favorites，会把复制记录原样返回：只收下真的收藏
      _favorites
        ..clear()
        ..addAll(
          (results[3] as ListHistoryResponse).records.where((r) => r.favorite),
        );
      await _loadQuickPasteStatus();

      await _loadDevices();
      await _loadTransfers();
      await refreshNotificationStatus();

      _events = conn.client
          .subscribe(SubscribeRequest())
          .listen(
            _onEvent,
            onError: (Object e) =>
                _scheduleRetry(appL10n.linkConnectionLost(_describe(e))),
            onDone: () => _scheduleRetry(appL10n.linkServiceDisconnected),
          );

      _serviceState = null;
      _setLink(LinkState.online, null);
      _maintenance = _ensureServiceCurrent();
      _historySearch.schedule(Duration.zero);
      _favoriteSearch.schedule(Duration.zero);
    } on DaemonNotRunning {
      if (!_sessionStartTried && service.available && !_quitting) {
        _sessionStartTried = true;
        try {
          final current = await service.state();
          if (current != ServiceState.mustMove &&
              current != ServiceState.unavailable) {
            await service.install();
            await _connect();
            return;
          }
        } catch (_) {
          /* Show the service page with a retry action. */
        }
      }
      await _refreshServiceState();
      _scheduleRetry(appL10n.linkServiceNotRunning);
    } catch (e) {
      await _refreshServiceState();
      _scheduleRetry(_describe(e));
    }
  }

  bool _legacyChecked = false;

  /// 2.0.0 之前叫 CopySync 时登记的后台服务先停掉；原先启用着的，改为启用新的，
  /// 新的后台服务第一次启动时会把旧的数据目录挪过来，配对关系与复制记录都还在
  Future<void> _replaceLegacyService() async {
    if (_legacyChecked || !service.available) return;
    _legacyChecked = true;
    try {
      if (await service.removeLegacy()) {
        await service.setLaunchAtLogin(true);
        await service.install();
      }
    } catch (_) {
      // 清理失败不影响使用：用户还可以在界面上手动启用后台同步
    }
  }

  Future<void> _refreshServiceState() async {
    try {
      _serviceState = await service.state();
    } catch (_) {
      _serviceState = null;
    }
  }

  /// 连上的后台服务不一定是这个 App 内置的那份，每次启动核对一次：
  /// - 登录项指向别处（旧版脚本装的、或 App 换了位置）：改为指向当前 App
  /// - 覆盖安装了新版 App：launchd 里跑的还是旧进程，按新的可执行文件重启
  /// 两种情况都会让当前连接断开，随后的自动重连会连上新进程。
  Future<void> _ensureServiceCurrent() async {
    if (!service.available || _serviceChecked || _quitting) return;
    _serviceChecked = true;
    try {
      final s = await service.state();
      if (s == ServiceState.stale) {
        await service.install();
        return;
      }
      final running = _status?.version ?? '';
      if (s == ServiceState.running &&
          appVersion != 'dev' &&
          running.isNotEmpty &&
          running != appVersion) {
        await service.restart();
      }
    } catch (_) {
      // 核对失败不影响使用：旧进程仍在正常工作
    }
    if (_quitting) return;
    try {
      final enabled = await service.launchAtLogin();
      if (_config != null && _config!.launchAtLogin != enabled) {
        await updateConfig(_config!.deepCopy()..launchAtLogin = enabled);
      }
    } catch (_) {
      /* Keep the saved value if the OS query fails. */
    }
    await _syncQuickPaste();
  }

  /// Mac 上按设置登记或撤下快捷粘贴窗口的 LaunchAgent；App 更新后还在跑旧版的，按新的程序重新拉起。
  /// Windows、Linux 上快捷窗口由后台服务照看，这里什么都不做。
  Future<void> _syncQuickPaste() async {
    final qp = quickPasteService;
    if (!qp.available || _quitting) return;
    try {
      // 快捷窗口跟着后台服务走：后台服务没登记成登录项（开发时手动跑的、测试用的）就不登记它
      if (await service.state() != ServiceState.running) return;
      if (_config?.quickPasteDisabled ?? false) {
        await qp.uninstall();
      } else if (!await qp.installed()) {
        await qp.install();
      } else {
        final v = _quickPaste?.version ?? '';
        if (appVersion != 'dev' && v.isNotEmpty && v != appVersion) {
          await qp.restart();
        }
      }
      if (!(_config?.quickPasteDisabled ?? false)) {
        await qp.setLaunchAtLogin(await service.launchAtLogin());
      }
    } catch (_) {
      // 登记失败不影响主界面，设置页会显示快捷窗口没在运行
    }
  }

  /// 截图与界面测试用：直接填入数据，不连接后台服务。
  @visibleForTesting
  void debugSeed({
    required Status status,
    required Config config,
    required Device self,
    List<Device> peers = const [],
    List<ClipRecord> records = const [],
    List<ClipRecord> favorites = const [],
    Device? pendingPairing,
    LinkState link = LinkState.online,
    ServiceState? serviceState,
    QuickPasteStatus? quickPaste,
    List<Transfer> transfers = const [],
  }) {
    _status = status;
    _config = config;
    _self = self;
    _peers = peers;
    _records
      ..clear()
      ..addAll(records);
    _favorites
      ..clear()
      ..addAll(favorites);
    _quickPaste = quickPaste;
    _transfers
      ..clear()
      ..addAll(transfers);
    _pendingPairing = pendingPairing;
    _serviceState = serviceState;
    _link = link;
    notifyListeners();
  }

  // ─────────────────────────── 后台服务 ───────────────────────────

  /// 注册后台服务并连接。用于首次启用，也用于修复被移动过的 App。
  Future<void> enableService() async {
    await service.install();
    await _refreshServiceState();
    await connect();
    await _syncQuickPaste();
  }

  Future<void> restartService() async {
    await service.restart();
    await connect();
  }

  /// 停用后台服务：关闭同步并取消开机自启。快捷窗口离了后台服务没法用，一起撤下，重新启用时再登记。
  Future<void> disableService() async {
    _sessionStartTried = true;
    _retry?.cancel();
    if (quickPasteService.available) await quickPasteService.uninstall();
    await service.uninstall();
    await _refreshServiceState();
    _scheduleRetry(appL10n.linkServiceDisabled);
  }

  Future<void> _loadDevices() async {
    final conn = _conn;
    if (conn == null) return;
    try {
      final resp = await conn.client.listDevices(Empty());
      _self = resp.self;
      _peers = resp.peers;
      notifyListeners();
    } on GrpcError catch (e) {
      // 配对能力尚未接入时返回 Unimplemented，属预期情况
      if (e.code != StatusCode.unimplemented) rethrow;
    }
  }

  void _scheduleRetry(String message) {
    if (_quitting) return;
    _events?.cancel();
    _events = null;
    _conn?.close();
    _conn = null;
    _setLink(LinkState.offline, message);
    // daemon 可能正在重启，自动重连省去用户手动操作
    _retry = Timer(const Duration(seconds: 3), connect);
  }

  void _setLink(LinkState state, String? error) {
    _link = state;
    _error = error;
    notifyListeners();
  }

  void _onEvent(Event ev) {
    final added = ev.whichPayload();
    switch (added) {
      // 同一条记录会被推送多次（开始接收时一次、接收完成时一次），一律按 id 合并，
      // 否则界面上会出现两行，其中「接收中」那行的进度条永远停不下来
      case Event_Payload.clipAdded:
        _upsert(ev.clipAdded);
        // 新记录该不该出现在搜索结果里，只有后台服务知道
        final search = ev.clipAdded.favorite ? _favoriteSearch : _historySearch;
        if (!search.patch(ev.clipAdded)) {
          search.schedule(const Duration(milliseconds: 300));
        }
        // 取消收藏后同一条记录换到了复制记录里
        (ev.clipAdded.favorite ? _historySearch : _favoriteSearch).remove(
          ev.clipAdded.id,
        );

      case Event_Payload.clipUpdated:
        _upsert(ev.clipUpdated);
        _historySearch.patch(ev.clipUpdated);
        _favoriteSearch.patch(ev.clipUpdated);

      case Event_Payload.clipRemoved:
        _records.removeWhere((r) => r.id == ev.clipRemoved);
        _favorites.removeWhere((r) => r.id == ev.clipRemoved);
        _clipboardResults.remove(ev.clipRemoved);
        _details.remove(ev.clipRemoved);
        _historySearch.remove(ev.clipRemoved);
        _favoriteSearch.remove(ev.clipRemoved);

      case Event_Payload.configChanged:
        // 别处（快捷窗口、另一个界面窗口）改了设置
        _config = ev.configChanged;

      case Event_Payload.quickPasteChanged:
        _quickPaste = ev.quickPasteChanged;

      case Event_Payload.clipboardWritten:
        _clipboardResults[ev.clipboardWritten.clipId] = ev.clipboardWritten;

      case Event_Payload.deviceChanged:
        _onDeviceChanged(ev.deviceChanged);

      case Event_Payload.statusChanged:
        _status = ev.statusChanged;

      case Event_Payload.progress:
        _onProgress(ev.progress);

      case Event_Payload.transferChanged:
        _upsertTransfer(ev.transferChanged);

      case Event_Payload.transferRemoved:
        _transfers.removeWhere((t) => t.id == ev.transferRemoved);

      case Event_Payload.navigate:
        _pageRequest = ev.navigate;
        _pageRequestSerial++;

      default:
        break;
    }
    notifyListeners();
  }

  void _upsert(ClipRecord r) {
    if (r.status == ClipStatus.CLIP_STATUS_FETCHING) {
      _clipboardResults.remove(r.id);
    }
    if (r.favorite) {
      _records.removeWhere((x) => x.id == r.id);
      final i = _favorites.indexWhere((x) => x.id == r.id);
      if (i >= 0) {
        _favorites[i] = r;
      } else {
        _favorites.add(r);
      }
      // 再收藏一次同样的内容会把它挪到最上面
      _favorites.sort((a, b) => b.favoritedAtUnix.compareTo(a.favoritedAtUnix));
      return;
    }
    // 取消收藏：同一条记录从收藏挪回复制记录
    _favorites.removeWhere((x) => x.id == r.id);
    final i = _records.indexWhere((x) => x.id == r.id);
    if (i >= 0) {
      _records[i] = r;
    } else {
      // 按复制时间插到该在的位置：新复制的、刚取消收藏的都在最上面
      final at = _records.indexWhere((x) => x.createdAtUnix < r.createdAtUnix);
      _records.insert(at < 0 ? _records.length : at, r);
      if (_records.length > 500) _records.removeLast();
    }
    // 传完（或失败）了就不再显示进度
    if (r.status != ClipStatus.CLIP_STATUS_FETCHING) _progress.remove(r.id);
  }

  /// 进度事件只用于「从对端接收」的记录：本机复制的记录在发送时也会产生进度，
  /// 若把它们也标成「接收中」，就再也没有事件能把状态改回来。
  void _onProgress(TransferProgress p) {
    final i = _records.indexWhere((r) => r.id == p.clipId);
    if (i < 0 || _records[i].outgoing) return;
    final r = _records[i];
    if (r.status == ClipStatus.CLIP_STATUS_REMOTE_ONLY) {
      // 用户点了「拉取到本机」，开始传了
      _records[i] = r.deepCopy()..status = ClipStatus.CLIP_STATUS_FETCHING;
      _historySearch.patch(_records[i]);
    } else if (r.status != ClipStatus.CLIP_STATUS_FETCHING) {
      return; // 已经传完的记录，迟到的进度事件不能把它拉回「接收中」
    }
    if (p.total > 0) {
      _progress[p.clipId] = (p.transferred.toInt() / p.total.toInt()).clamp(
        0.0,
        1.0,
      );
    }
  }

  void _upsertTransfer(Transfer t) {
    final i = _transfers.indexWhere((x) => x.id == t.id);
    if (i >= 0) {
      _transfers[i] = t;
    } else {
      final at = _transfers.indexWhere(
        (x) => x.createdAtUnix < t.createdAtUnix,
      );
      _transfers.insert(at < 0 ? _transfers.length : at, t);
    }
  }

  Future<void> _loadTransfers() async {
    final conn = _conn;
    if (conn == null) return;
    try {
      final resp = await conn.client.listTransfers(
        ListTransfersRequest(limit: 500),
      );
      _transfers
        ..clear()
        ..addAll(resp.transfers);
    } on GrpcError {
      // 更新期间连上的可能还是不认识隔空传送的旧版后台服务
      _transfers.clear();
    }
  }

  /// 测试用：直接注入一条后台服务的事件。
  @visibleForTesting
  void debugEvent(Event ev) => _onEvent(ev);

  void _onDeviceChanged(Device d) {
    // 带 pairingSession 的不是已配对设备，而是一条待确认的配对请求
    if (d.pairingSession.isNotEmpty) {
      _setPendingPairing(d);
      return;
    }
    final i = _peers.indexWhere((p) => p.id == d.id);
    final next = List<Device>.from(_peers);
    if (i >= 0) {
      next[i] = d;
    } else {
      next.add(d);
    }
    _peers = next;
  }

  // ─────────────────────────── 操作 ───────────────────────────

  DaemonServiceClient get _client {
    final c = _conn;
    if (c == null) throw StateError(appL10n.errServiceNotConnected);
    return c.client;
  }

  Future<PairingCode> createPairingCode() async {
    final resp = await _client.createPairingCode(Empty());
    return (code: resp.code, addresses: resp.lanAddresses.toList());
  }

  /// 兑换配对码，返回待核对指纹的对端信息。
  /// [address] 是对方配对码下面显示的地址，不在同一网段时才需要。
  Future<Device> redeemPairingCode(String code, {String address = ''}) async {
    final resp = await _client.redeemPairingCode(
      RedeemPairingCodeRequest(
        code: code.trim().toUpperCase(),
        address: address.trim(),
      ),
      // 在局域网里找对方要几秒，找不到再去服务器上兑换
      options: CallOptions(timeout: const Duration(seconds: 30)),
    );
    final peer = resp.peer..pairingSession = resp.pairingSession;
    _setPendingPairing(peer);
    notifyListeners();
    return peer;
  }

  /// 「搜索附近设备」窗口打开期间订阅：本机在局域网里公开设备名，
  /// 收到附近同样打开了这个窗口的设备。取消订阅本机就撤下。
  Stream<List<NearbyDevice>> watchNearby() =>
      _client.watchNearby(Empty()).map((e) => e.devices.toList());

  /// 向附近的一台设备发起配对，返回待核对指纹的对端信息。
  Future<Device> pairNearby(String id) async {
    final resp = await _client.pairNearby(
      PairNearbyRequest(id: id),
      options: CallOptions(timeout: const Duration(seconds: 15)),
    );
    final peer = resp.peer..pairingSession = resp.pairingSession;
    _setPendingPairing(peer);
    notifyListeners();
    return peer;
  }

  Future<void> confirmPairing(String session, bool accept) async {
    await _client.confirmPairing(
      ConfirmPairingRequest(pairingSession: session, accept: accept),
    );
    dismissPendingPairing(session);
    await _loadDevices();
  }

  void _setPendingPairing(Device peer) {
    // 事件流和兑换 RPC 返回同一个会话，先后顺序不固定。
    if (!_handledPairingSessions.contains(peer.pairingSession)) {
      _pendingPairing = peer;
    }
  }

  void dismissPendingPairing([String? session]) {
    final handled = session ?? _pendingPairing?.pairingSession;
    if (handled != null) _handledPairingSessions.add(handled);
    // 确认旧会话期间可能来了另一条请求，不能把新请求一并清掉。
    if (_pendingPairing?.pairingSession == handled) _pendingPairing = null;
    notifyListeners();
  }

  /// 手动告诉后台服务某台设备的地址：跨网段、或两边都换了地址时用。
  Future<void> setDeviceAddress(String deviceId, String address) =>
      _client.setDeviceAddress(
        SetDeviceAddressRequest(deviceId: deviceId, address: address.trim()),
      );

  /// macOS 打开「本地网络」设置；Windows 申请管理员权限放行防火墙。
  Future<void> requestLocalNetworkPermission() =>
      _client.requestLocalNetworkPermission(Empty());

  final Set<String> _reconnecting = {};

  /// 这台设备正在「重新连接」，列表里显示「正在连接」
  bool isReconnecting(String deviceId) => _reconnecting.contains(deviceId);

  /// 设备菜单里的「重新连接」：后台服务最多等十几秒，返回那时的连接状态。
  Future<ConnectionKind> reconnect(String deviceId) async {
    _reconnecting.add(deviceId);
    notifyListeners();
    try {
      final r = await _client.reconnect(
        ReconnectRequest(deviceId: deviceId),
        options: CallOptions(timeout: const Duration(seconds: 30)),
      );
      return r.kind;
    } finally {
      _reconnecting.remove(deviceId);
      notifyListeners();
    }
  }

  Future<void> unpair(String deviceId) async {
    await _client.unpair(UnpairRequest(deviceId: deviceId));
    _peers = _peers.where((p) => p.id != deviceId).toList();
    notifyListeners();
  }

  Future<void> updateConfig(Config next) async {
    final wasOfficial = officialEnabled;
    final quickPasteWasDisabled = _config?.quickPasteDisabled;
    _config = await _client.updateConfig(next);
    if (!wasOfficial && officialEnabled) _officialNavigationSerial++;
    notifyListeners();
    if (_config!.quickPasteDisabled != quickPasteWasDisabled) {
      await _syncQuickPaste();
    }
  }

  Future<void> setLaunchAtLogin(bool enabled) async {
    await service.setLaunchAtLogin(enabled);
    try {
      if (quickPasteService.available) {
        await quickPasteService.setLaunchAtLogin(
          enabled && !(config?.quickPasteDisabled ?? false),
        );
      }
      await updateConfig(config!.deepCopy()..launchAtLogin = enabled);
    } catch (_) {
      await service.setLaunchAtLogin(!enabled);
      if (quickPasteService.available) {
        await quickPasteService.setLaunchAtLogin(
          !enabled && !(config?.quickPasteDisabled ?? false),
        );
      }
      rethrow;
    }
  }

  Future<void> setPeerSync(String id, bool enabled) async {
    final next = config!.deepCopy();
    next.syncDisabledPeers.removeWhere((peer) => peer == id);
    if (!enabled) next.syncDisabledPeers.add(id);
    await updateConfig(next);
  }

  /// Stop helper jobs before the UI exits, preserving login entries.
  Future<void> quitApplication() async {
    _quitting = true;
    _retry?.cancel();
    try {
      await _connectionWork;
      await _maintenance;
      await _events?.cancel();
      _events = null;
      await _conn?.close();
      _conn = null;
      if (quickPasteService.available) await quickPasteService.stop();
      if (service.available) await service.stop();
    } catch (_) {
      _quitting = false;
      _scheduleRetry(appL10n.linkServiceDisconnected);
      rethrow;
    }
  }

  // ─────────────────────────── 更新 ───────────────────────────

  /// 自动检查发现、要在侧边栏提示的新版本；空字符串表示没有。
  String get updateAvailable => _status?.updateAvailable ?? '';

  /// 刚完成的那次自动更新，后台服务过一会儿就不再带。
  UpdateResult? get lastUpdate =>
      _status?.hasLastUpdate() == true ? _status!.lastUpdate : null;

  bool get autoCheckUpdates => !(_config?.updateCheckDisabled ?? false);

  /// [language] 是更新日志的语言，见 [settingFromLocale]。
  Future<UpdateInfo> checkForUpdate(String language) =>
      _client.checkForUpdate(CheckForUpdateRequest(language: language));

  /// 下载并校验新版本。取消订阅即停止下载。
  Stream<UpdateProgress> downloadUpdate(String version) =>
      _client.downloadUpdate(DownloadUpdateRequest(version: version));

  /// 让后台服务启动更新助手。返回后界面要立即退出，助手等它退出后替换文件并重新打开。
  Future<void> installUpdate(String version) async {
    await _client.installUpdate(
      InstallUpdateRequest(version: version, uiPid: pid),
    );
  }

  Future<void> skipUpdate(String version) =>
      updateConfig(config!.deepCopy()..updateSkipVersion = version);

  Future<void> setAutoCheckUpdates(bool on) =>
      updateConfig(config!.deepCopy()..updateCheckDisabled = !on);

  // ─────────────────────────── 反馈问题 ───────────────────────────

  /// 反馈问题用的诊断报告，由后台服务生成并脱敏，带上最近 [logLines] 行日志。
  Future<String> exportDiagnostics({int logLines = 200}) async =>
      (await _client.exportDiagnostics(
        ExportDiagnosticsRequest(logLines: logLines, uiVersion: appVersion),
      )).report;

  /// 临时打开详细日志 [minutes] 分钟，0 表示立即关闭。
  Future<void> setVerboseLog(int minutes) async {
    _status = await _client.setVerboseLog(
      SetVerboseLogRequest(minutes: minutes),
    );
    notifyListeners();
  }

  Future<void> deleteRecords({List<String>? ids, bool all = false}) async {
    await _client.deleteHistory(
      DeleteHistoryRequest(ids: ids ?? const [], all: all),
    );
    if (all) {
      // 清空只清复制记录，收藏不受影响
      _records.clear();
      _historySearch.clear();
    } else if (ids != null) {
      _records.removeWhere((r) => ids.contains(r.id));
      ids.forEach(_historySearch.remove);
    }
    notifyListeners();
  }

  // ─────────────────────────── 收藏 ───────────────────────────

  /// 收藏（另存一份）或取消收藏（放回复制记录的最上面）。返回收藏后的收藏，或取消后放回的那一条。
  /// 取消收藏时 [clipId] 是收藏或它的原记录都可以。
  Future<ClipRecord> setFavorite(String clipId, bool favorite) async {
    final r = await _client.setFavorite(
      SetFavoriteRequest(clipId: clipId, favorite: favorite),
      // 整份复制大文件时后台服务先返回「正在保存」，不会等太久
      options: CallOptions(timeout: const Duration(seconds: 30)),
    );
    _upsert(r);
    (r.favorite ? _historySearch : _favoriteSearch).remove(r.id);
    notifyListeners();
    return r;
  }

  /// 给收藏起别名，[alias] 为空表示去掉。
  Future<ClipRecord> setAlias(String clipId, String alias) async {
    final r = await _client.setAlias(
      SetAliasRequest(clipId: clipId, alias: alias),
    );
    _upsert(r);
    _favoriteSearch.patch(r);
    notifyListeners();
    return r;
  }

  /// 悬停提示框要显示的完整内容。
  @override
  Future<ClipDetail> clipDetail(String clipId) async {
    final cached = _details[clipId];
    if (cached != null) return cached;
    final d = await requestClipDetail(clipId);
    _details[clipId] = d;
    return d;
  }

  @protected
  Future<ClipDetail> requestClipDetail(String clipId) =>
      _client.getClipDetail(GetClipDetailRequest(clipId: clipId));

  // ─────────────────────────── 快捷粘贴窗口 ───────────────────────────

  Future<void> _loadQuickPasteStatus() async {
    final conn = _conn;
    if (conn == null) return;
    try {
      _quickPaste = await conn.client.getQuickPasteStatus(Empty());
    } on GrpcError {
      _quickPaste = null; // 旧版后台服务没有快捷窗口
    }
  }

  /// 转给快捷窗口的命令：request_permission、suspend_hotkey、resume_hotkey、show。
  Future<void> sendQuickPasteCommand(String command) =>
      _client.sendQuickPasteCommand(QuickPasteCommand(command: command));

  // ─────────────────────────── 搜索 ───────────────────────────

  /// 输入搜索词。停顿一下再向后台服务查询，不必每敲一个字就查一次；空白表示不搜索。
  /// [notify] 为 false 用于页面销毁时清掉搜索：那时界面树已锁定，不能再通知重建。
  void search(String query, {bool notify = true}) =>
      _historySearch.set(query, notify: notify);

  /// 收藏页的搜索，用法与 [search] 相同。
  void searchFavorites(String query, {bool notify = true}) =>
      _favoriteSearch.set(query, notify: notify);

  /// 向后台服务搜索复制记录。界面测试与截图里由子类给出演示结果。
  @protected
  Future<ListHistoryResponse> requestSearch(String query) =>
      _client.listHistory(ListHistoryRequest(limit: 200, query: query));

  /// 向后台服务搜索收藏。
  @protected
  Future<ListHistoryResponse> requestFavoriteSearch(String query) =>
      _client.listHistory(
        ListHistoryRequest(limit: 200, query: query, favorites: true),
      );

  Future<void> refreshNotificationStatus() async {
    final conn = _conn;
    if (conn == null) return;
    try {
      final status = await conn.client.getNotificationStatus(
        Empty(),
        options: CallOptions(timeout: const Duration(seconds: 12)),
      );
      if (_conn == conn) _notificationStatus = status;
    } on GrpcError {
      if (_conn == conn) {
        _notificationStatus = NotificationStatus(permission: 'unavailable');
      }
    }
    if (_conn == conn) notifyListeners();
  }

  Future<void> requestNotifications() async {
    _notificationStatus = await _client.requestNotificationPermission(
      Empty(),
      options: CallOptions(timeout: const Duration(seconds: 20)),
    );
    notifyListeners();
  }

  Future<void> fetch(String clipId) =>
      _client.fetch(FetchRequest(clipId: clipId));

  Future<void> fetchImagePreview(String clipId) =>
      _client.fetch(FetchRequest(clipId: clipId, preserveClipboard: true));

  Future<void> applyToClipboard(String clipId) =>
      _client.applyToClipboard(ApplyToClipboardRequest(clipId: clipId));

  /// 一条记录里第 [index] 张图片：本机路径、文件名，以及能预览的图片总数。
  /// HEIC 这类格式由后台服务先转换，大图可能要一两秒，超时放宽一些。
  @override
  Future<GetImagePreviewResponse> imagePreview(
    String clipId, {
    int index = 0,
  }) => _client.getImagePreview(
    GetImagePreviewRequest(clipId: clipId, index: index),
    options: CallOptions(timeout: const Duration(seconds: 20)),
  );

  // ─────────────────────────── 隔空传送 ───────────────────────────

  /// 把文件发给一台设备。要经官方服务中转而用户还没同意时抛出 SendFailure.needRelayConsent。
  Future<Transfer> sendFiles(
    String deviceId,
    List<String> paths, {
    bool allowRelay = false,
  }) async {
    final t = await _client.sendFiles(
      SendFilesRequest(
        deviceId: deviceId,
        paths: paths,
        allowRelay: allowRelay,
      ),
    );
    _upsertTransfer(t);
    notifyListeners();
    return t;
  }

  Future<void> cancelTransfer(String id) =>
      _client.cancelTransfer(TransferRef(id: id));

  Future<void> resumeTransfer(String id) =>
      _client.resumeTransfer(TransferRef(id: id));

  /// 只删记录，不删文件。
  Future<void> deleteTransfers({
    List<String>? ids,
    TransferDirection? clearAll,
  }) async {
    await _client.deleteTransfers(
      DeleteTransfersRequest(
        ids: ids ?? const [],
        all: clearAll != null,
        direction: clearAll ?? TransferDirection.TRANSFER_DIRECTION_UNSPECIFIED,
      ),
    );
  }

  /// 打开隔空传送页时调用：侧边栏的数字清零。
  Future<void> markTransfersSeen() async {
    if (unseenTransfers == 0 || _conn == null) return;
    try {
      await _client.markTransfersSeen(Empty());
    } on GrpcError {
      // 旧版后台服务没有这个接口
    }
  }

  /// 检查保存位置能否写入；macOS 上会在这时触发系统的文件夹授权。
  Future<CheckReceiveDirResponse> checkReceiveDir([String path = '']) =>
      _client.checkReceiveDir(CheckReceiveDirRequest(path: path));

  static SendFailure sendFailure(Object e) {
    if (e is! GrpcError) return SendFailure.other;
    return switch ((e.message ?? '').split(':').first.trim()) {
      'offline' => SendFailure.offline,
      'unsupported' => SendFailure.unsupported,
      'disabled' => SendFailure.disabled,
      'relay' => SendFailure.needRelayConsent,
      'no_paths' => SendFailure.noPaths,
      'unknown_device' => SendFailure.unknownDevice,
      _ => SendFailure.other,
    };
  }

  Future<void> requestClipboardPermission() =>
      _client.requestClipboardPermission(Empty());

  /// 把 gRPC 异常翻译成用户能看懂的话，而不是抛一串堆栈。
  static String _describe(Object e) {
    if (e is GrpcError) {
      if (e.code == StatusCode.unimplemented) return appL10n.errUnimplemented;
      if (e.code == StatusCode.unavailable) return appL10n.errUnavailable;
      return e.message ?? e.codeName;
    }
    if (e is DaemonNotRunning) return appL10n.linkServiceNotRunning;
    if (e is StateError) return e.message;
    return e.toString();
  }

  static String describeError(Object e) => _describe(e);

  /// 从配对出错的消息里取出原因。
  static PairingFailure pairingFailure(Object e) {
    if (e is! GrpcError) return PairingFailure.other;
    final reason = (e.message ?? '').split(':').first.trim();
    return switch (reason) {
      'not_found' => PairingFailure.notFound,
      'wrong_code' => PairingFailure.wrongCode,
      'code_expired' => PairingFailure.codeExpired,
      'bad_address' => PairingFailure.badAddress,
      'no_channel' => PairingFailure.noChannel,
      _ => PairingFailure.other,
    };
  }
}

/// 一组记录（复制记录或收藏）的搜索：搜索词、后台服务返回的结果，以及「只采用最后一次」的计数。
class _RecordSearch {
  _RecordSearch({
    required this.notify,
    required this.request,
    required this.local,
  });

  final VoidCallback notify;
  final Future<ListHistoryResponse> Function(String query) request;

  /// 已加载的记录：后台服务不支持搜索时在这里面找
  final List<ClipRecord> Function() local;

  String query = '';
  List<ClipRecord>? _results;
  Timer? _timer;
  int _seq = 0; // 只采用最后一次搜索的结果，先发出的请求可能后返回

  bool get active => query.trim().isNotEmpty;
  List<ClipRecord>? get resultsView =>
      _results == null ? null : List.unmodifiable(_results!);

  void set(String q, {bool notify = true}) {
    query = q;
    _timer?.cancel();
    if (!active) {
      _seq++;
      _results = null;
      if (notify) this.notify();
      return;
    }
    schedule(const Duration(milliseconds: 200));
  }

  void schedule(Duration delay) {
    if (!active) return;
    _timer?.cancel();
    _timer = Timer(delay, _run);
  }

  Future<void> _run() async {
    final q = query.trim();
    final seq = ++_seq;
    List<ClipRecord> found;
    try {
      final r = await request(q);
      // 旧版后台服务不认识搜索词，会原样返回全部记录：退回到只在已加载的记录里找
      found = r.searched
          ? List.of(r.records)
          : local().where((x) => matchesSearch(x, q)).toList();
    } catch (_) {
      found = local().where((x) => matchesSearch(x, q)).toList();
    }
    if (seq != _seq || q != query.trim()) return;
    _results = found;
    notify();
  }

  /// 结果里的同一条记录跟着更新状态（拉取进度、星标等），预览保留搜索给的那一段。
  /// 返回这条记录在不在结果里。
  bool patch(ClipRecord r) {
    final results = _results;
    final i = results?.indexWhere((x) => x.id == r.id) ?? -1;
    if (i < 0) return false;
    results![i] = r.deepCopy()..textPreview = results[i].textPreview;
    return true;
  }

  void remove(String id) => _results?.removeWhere((r) => r.id == id);

  void clear() => _results?.clear();

  void dispose() => _timer?.cancel();
}

/// 在界面已有的信息里判断一条记录是否匹配搜索词：预览片段或文件名包含它，不分大小写。
/// 只在后台服务不支持搜索时用；正常情况下由后台服务按全文搜索。
bool matchesSearch(ClipRecord r, String query) {
  final q = query.toLowerCase();
  if (r.favorite && r.alias.toLowerCase().contains(q)) return true;
  if (r.kind != ClipKind.CLIP_KIND_IMAGE &&
      r.items.any((i) => i.name.toLowerCase().contains(q))) {
    return true;
  }
  return r.kind != ClipKind.CLIP_KIND_FILE &&
      r.kind != ClipKind.CLIP_KIND_IMAGE &&
      r.textPreview.toLowerCase().contains(q);
}
