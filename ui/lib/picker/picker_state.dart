import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';

import '../app_state.dart' show AppState, matchesSearch;
import '../background_service.dart' show appVersion;
import '../daemon_client.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../gen/pasteferry/v1/daemon.pbgrpc.dart' show DaemonServiceClient;
import '../hotkey.dart';
import '../records.dart';
import '../widgets/record_hover.dart';
import 'picker_host.dart';

/// 快捷窗口的页签：前五个按类型筛选复制记录，最后一个是收藏。
enum PickerTab { all, text, link, image, file, favorites }

extension PickerTabX on PickerTab {
  RecordFilter? get filter => switch (this) {
        PickerTab.all => RecordFilter.all,
        PickerTab.text => RecordFilter.text,
        PickerTab.link => RecordFilter.link,
        PickerTab.image => RecordFilter.image,
        PickerTab.file => RecordFilter.file,
        PickerTab.favorites => null,
      };
}

/// 快捷粘贴窗口的状态：连着后台服务，保留最近的复制记录与全部收藏，呼出时不用临时查询。
/// 见 design/quick-paste-and-favorites.md 第 2、6 节。
class PickerState extends ChangeNotifier implements RecordDetails {
  PickerState({PickerHost? host}) : host = host ?? PickerHost();

  final PickerHost host;

  DaemonConnection? _conn;
  StreamSubscription<Event>? _events;
  StreamController<QuickPasteStatus>? _statusOut;
  StreamSubscription<QuickPasteCommand>? _commands;
  Timer? _retry;

  Config? _config;
  final List<ClipRecord> _records = [];
  final List<ClipRecord> _favorites = [];
  final Map<String, ClipDetail> _details = {};
  final Map<String, String> _thumbs = {};
  final Map<String, double> _progress = {};

  /// 界面语言跟着设置走，单独通知，免得每次列表变化都重建 MaterialApp
  final language = ValueNotifier<String>('');

  bool _connected = false;
  bool get connected => _connected;
  Config? get config => _config;

  // ── 原生外壳报上来的 ──
  HotkeyResult? _hotkey;
  String _registered = '';
  PasteStatus _paste = const PasteStatus(available: false, reason: 'unsupported');
  QuickPasteStatus? _lastSent;

  // ── 界面 ──
  PickerTab _tab = PickerTab.all;
  String _query = '';
  int _selected = 0;
  List<ClipRecord>? _results;
  Timer? _searchTimer;
  int _searchSeq = 0;
  String? _error;

  /// 选中了一条还没下载的大文件：下完再粘贴
  String? _pendingId;
  bool _pendingPlain = false, _pendingCopyOnly = false;

  /// 每次呼出时加一，界面据此把焦点放回搜索框、清空输入
  final shown = ValueNotifier<int>(0);

  PickerTab get tab => _tab;
  String get query => _query;
  int get selected => _selected;
  String? get error => _error;
  String? get pendingId => _pendingId;
  double? progressOf(String id) => _progress[id];
  String? thumbnailOf(String id) => _thumbs[id];

  bool get copyOnly => _config?.quickPasteCopyOnly ?? false;

  /// 选中后能不能自动粘贴；不能的原因见 [pasteBlockedReason]
  bool get canPaste => !copyOnly && _paste.available;

  /// copy_only、not_trusted、wayland，能粘贴时为空
  String get pasteBlockedReason => copyOnly ? 'copy_only' : (_paste.available ? '' : _paste.reason);

  /// 这一次的目标窗口以管理员身份运行，选中后只放进剪贴板。不报给设置页：换个窗口就又能粘贴了
  bool get targetElevated => _paste.targetElevated;

  /// 当前页签、搜索词下的列表。
  List<ClipRecord> get visible {
    final f = _tab.filter;
    final base = f == null ? _favorites : _records.where(f.matches).toList();
    if (_query.trim().isEmpty) return base;
    // 后台服务的结果回来之前，先在已加载的里面找，打字时列表立刻有反应
    return _results ?? base.where((r) => matchesSearch(r, _query.trim())).toList();
  }

  // ─────────────────────────── 启动与连接 ───────────────────────────

  Future<void> start() async {
    host
      ..onShow = _onShow
      ..onHide = _onHide
      ..onHotkeyChanged = (h) {
        _hotkey = HotkeyResult(ok: true, error: '', source: _hotkey?.source ?? 'portal', hotkey: h);
        _sendStatus();
      }
      ..listen();
    await connect();
    await host.ready();
  }

  Future<void> connect() async {
    _retry?.cancel();
    try {
      final conn = await DaemonConnection.connect();
      final results = await Future.wait([
        conn.client.listHistory(ListHistoryRequest(limit: 200)),
        conn.client.listHistory(ListHistoryRequest(limit: 500, favorites: true)),
        conn.client.getConfig(Empty()),
      ]);
      _conn = conn;
      _records
        ..clear()
        ..addAll((results[0] as ListHistoryResponse).records);
      _favorites
        ..clear()
        ..addAll((results[1] as ListHistoryResponse).records.where((r) => r.favorite));
      _config = results[2] as Config;
      language.value = _config!.language;
      _events = conn.client.subscribe(SubscribeRequest()).listen(
            _onEvent,
            onError: (_) => _lost(),
            onDone: _lost,
          );
      _startSession(conn);
      _connected = true;
      notifyListeners();
      await _applyConfig();
    } catch (_) {
      _lost();
    }
  }

  void _lost() {
    _events?.cancel();
    _events = null;
    _commands?.cancel();
    _commands = null;
    _statusOut?.close();
    _statusOut = null;
    _lastSent = null;
    _conn?.close();
    _conn = null;
    if (_connected) {
      _connected = false;
      notifyListeners();
    }
    // 后台服务可能正在重启（更新、换设置），过一会儿再连
    _retry?.cancel();
    _retry = Timer(const Duration(seconds: 2), connect);
  }

  void _startSession(DaemonConnection conn) {
    final out = StreamController<QuickPasteStatus>();
    _statusOut = out;
    _commands = conn.client.quickPasteSession(out.stream).listen(_onCommand, onError: (_) {}, onDone: () {});
  }

  /// 按设置注册快捷键；关掉了快捷粘贴就退出进程（Windows、Linux 上后台服务不会再拉起它，
  /// Mac 上 LaunchAgent 只在异常退出时重启）。
  Future<void> _applyConfig() async {
    final c = _config;
    if (c == null) return;
    if (c.quickPasteDisabled) {
      await host.setHotkey('', enabled: false);
      await host.quit();
      return;
    }
    final hk = (Hotkey.parse(c.quickPasteHotkey) ?? Hotkey.fallback).canonical;
    if (hk != _registered) {
      _hotkey = await host.setHotkey(hk, enabled: true);
      _registered = hk;
    }
    _paste = await host.pasteStatus();
    _sendStatus();
    notifyListeners();
  }

  QuickPasteStatus get _status => QuickPasteStatus(
        running: true,
        hotkey: _hotkey?.hotkey ?? '',
        hotkeyError: _hotkey == null || _hotkey!.ok ? '' : _hotkey!.error,
        hotkeySource: _hotkey?.source ?? 'native',
        pasteAvailable: canPaste,
        pasteUnavailableReason: pasteBlockedReason,
        version: appVersion,
      );

  void _sendStatus() {
    final out = _statusOut;
    if (out == null || out.isClosed) return;
    final st = _status;
    if (st == _lastSent) return;
    _lastSent = st;
    out.add(st);
  }

  Timer? _permissionPoll;

  Future<void> _onCommand(QuickPasteCommand c) async {
    switch (c.command) {
      case 'request_permission':
        await host.requestPermission();
        // 用户去系统设置里打开开关要一会儿：一分钟内每秒看一次
        _permissionPoll?.cancel();
        var ticks = 0;
        _permissionPoll = Timer.periodic(const Duration(seconds: 1), (t) async {
          _paste = await host.pasteStatus();
          _sendStatus();
          if (_paste.available || ++ticks >= 60) t.cancel();
        });
      case 'suspend_hotkey':
        await host.setSuspended(true);
      case 'resume_hotkey':
        await host.setSuspended(false);
      case 'show':
        await host.show();
    }
  }

  void _onEvent(Event ev) {
    switch (ev.whichPayload()) {
      case Event_Payload.clipAdded:
        _upsert(ev.clipAdded);
      case Event_Payload.clipUpdated:
        _upsert(ev.clipUpdated);
      case Event_Payload.clipRemoved:
        _records.removeWhere((r) => r.id == ev.clipRemoved);
        _favorites.removeWhere((r) => r.id == ev.clipRemoved);
        _results?.removeWhere((r) => r.id == ev.clipRemoved);
        _details.remove(ev.clipRemoved);
        _thumbs.remove(ev.clipRemoved);
      case Event_Payload.configChanged:
        _config = ev.configChanged;
        language.value = _config!.language;
        _applyConfig();
      case Event_Payload.progress:
        final p = ev.progress;
        if (p.total > 0) _progress[p.clipId] = (p.transferred.toInt() / p.total.toInt()).clamp(0.0, 1.0);
      default:
        return;
    }
    _clampSelection();
    notifyListeners();
  }

  /// 与主窗口的 AppState 同样的规则：按 favorite 分到复制记录或收藏，取消收藏的同一条换过去。
  void _upsert(ClipRecord r) {
    if (r.favorite) {
      _records.removeWhere((x) => x.id == r.id);
      final i = _favorites.indexWhere((x) => x.id == r.id);
      if (i >= 0) {
        _favorites[i] = r;
      } else {
        _favorites.add(r);
      }
      _favorites.sort((a, b) => b.favoritedAtUnix.compareTo(a.favoritedAtUnix));
    } else {
      _favorites.removeWhere((x) => x.id == r.id);
      final i = _records.indexWhere((x) => x.id == r.id);
      if (i >= 0) {
        _records[i] = r;
      } else {
        final at = _records.indexWhere((x) => x.createdAtUnix < r.createdAtUnix);
        _records.insert(at < 0 ? _records.length : at, r);
        if (_records.length > 500) _records.removeLast();
      }
    }
    final ri = _results?.indexWhere((x) => x.id == r.id) ?? -1;
    if (ri >= 0) _results![ri] = r.deepCopy()..textPreview = _results![ri].textPreview;
    if (r.status != ClipStatus.CLIP_STATUS_FETCHING) _progress.remove(r.id);
    // 等着下载完再粘贴的那一条就绪了
    if (r.id == _pendingId && r.status == ClipStatus.CLIP_STATUS_READY) {
      _pendingId = null;
      choose(r, plain: _pendingPlain, copyOnly: _pendingCopyOnly);
    } else if (r.id == _pendingId && r.status == ClipStatus.CLIP_STATUS_FAILED) {
      _pendingId = null;
      _error = r.error;
    }
  }

  // ─────────────────────────── 呼出与收起 ───────────────────────────

  void _onShow() {
    _reset();
    shown.value++;
    // 辅助功能权限可能刚在系统设置里打开
    host.pasteStatus().then((p) {
      _paste = p;
      _sendStatus();
      notifyListeners();
    });
    notifyListeners();
  }

  void _onHide() {
    _reset();
    notifyListeners();
  }

  /// 每次呼出都从「全部」、第一条、空搜索开始。
  void _reset() {
    _tab = PickerTab.all;
    _query = '';
    _selected = 0;
    _results = null;
    _searchTimer?.cancel();
    _searchSeq++;
    _error = null;
    _pendingId = null;
  }

  Future<void> close() async {
    _reset();
    notifyListeners();
    await host.hide();
  }

  // ─────────────────────────── 列表与搜索 ───────────────────────────

  void setTab(PickerTab t) {
    if (t == _tab) return;
    _tab = t;
    _selected = 0;
    _results = null;
    _scheduleSearch(Duration.zero);
    notifyListeners();
  }

  void cycleTab(int delta) {
    const tabs = PickerTab.values;
    setTab(tabs[(tabs.indexOf(_tab) + delta) % tabs.length]);
  }

  void setQuery(String q) {
    _query = q;
    _selected = 0;
    _results = null;
    _error = null;
    _scheduleSearch(const Duration(milliseconds: 150));
    notifyListeners();
  }

  void select(int i) {
    if (i == _selected || i < 0 || i >= visible.length) return;
    _selected = i;
    notifyListeners();
  }

  void moveSelection(int delta) {
    final n = visible.length;
    if (n == 0) return;
    _selected = (_selected + delta).clamp(0, n - 1);
    notifyListeners();
  }

  void _clampSelection() {
    final n = visible.length;
    if (_selected >= n) _selected = n == 0 ? 0 : n - 1;
  }

  void _scheduleSearch(Duration delay) {
    _searchTimer?.cancel();
    if (_query.trim().isEmpty) return;
    _searchTimer = Timer(delay, _runSearch);
  }

  Future<void> _runSearch() async {
    final q = _query.trim();
    final tab = _tab;
    final seq = ++_searchSeq;
    try {
      final r = await requestSearch(q, tab);
      if (seq != _searchSeq || q != _query.trim() || tab != _tab) return;
      if (r.searched) {
        _results = r.records.toList();
        _clampSelection();
        notifyListeners();
      }
    } catch (_) {
      // 搜不了就用已加载的记录里找到的
    }
  }

  @protected
  Future<ListHistoryResponse> requestSearch(String query, PickerTab tab) {
    final req = ListHistoryRequest(limit: 100, query: query, favorites: tab == PickerTab.favorites);
    switch (tab) {
      case PickerTab.text:
        req.kindFilter = ClipKind.CLIP_KIND_TEXT;
      case PickerTab.link:
        req.linksOnly = true;
      case PickerTab.image:
        req.kindFilter = ClipKind.CLIP_KIND_IMAGE;
      case PickerTab.file:
        req.kindFilter = ClipKind.CLIP_KIND_FILE;
      case PickerTab.all || PickerTab.favorites:
    }
    return _client.listHistory(req);
  }

  // ─────────────────────────── 选中、收藏、删除 ───────────────────────────

  /// 能选的：已就绪的，或者还没下载的大文件（先下载再粘贴）。过期、失败、收藏还在保存的不能选。
  static bool selectable(ClipRecord r) => switch (r.status) {
        ClipStatus.CLIP_STATUS_READY => true,
        ClipStatus.CLIP_STATUS_REMOTE_ONLY || ClipStatus.CLIP_STATUS_FETCHING => !r.favorite && !r.outgoing,
        _ => false,
      };

  /// 选中一条：放进剪贴板，收起窗口，把焦点还给原来的窗口，能粘贴时模拟粘贴键。
  /// [plain] 只写纯文本；[copyOnly] 只放进剪贴板，不粘贴。
  Future<void> choose(ClipRecord r, {bool plain = false, bool copyOnly = false}) async {
    if (!selectable(r)) return;
    _error = null;
    if (r.status != ClipStatus.CLIP_STATUS_READY) {
      _pendingId = r.id;
      _pendingPlain = plain;
      _pendingCopyOnly = copyOnly;
      notifyListeners();
      if (r.status == ClipStatus.CLIP_STATUS_REMOTE_ONLY) {
        try {
          await requestFetch(r.id);
        } catch (e) {
          _pendingId = null;
          _error = AppState.describeError(e);
          notifyListeners();
        }
      }
      return;
    }
    try {
      await requestApply(r.id, plain);
    } catch (e) {
      _error = AppState.describeError(e);
      notifyListeners();
      return;
    }
    final paste = !copyOnly && !this.copyOnly;
    _reset();
    notifyListeners();
    await host.commit(paste: paste);
  }

  Future<void> chooseIndex(int i, {bool plain = false, bool copyOnly = false}) async {
    final list = visible;
    if (i < 0 || i >= list.length) return;
    _selected = i;
    await choose(list[i], plain: plain, copyOnly: copyOnly);
  }

  Future<void> toggleFavorite(ClipRecord r) async {
    try {
      await requestFavorite(r.id, !(r.favorite || r.favorited));
    } catch (e) {
      _error = AppState.describeError(e);
      notifyListeners();
    }
  }

  Future<void> delete(ClipRecord r) async {
    if (r.favorite) return; // 收藏里没有删除
    try {
      await _client.deleteHistory(DeleteHistoryRequest(ids: [r.id]));
      _records.removeWhere((x) => x.id == r.id);
      _results?.removeWhere((x) => x.id == r.id);
      _clampSelection();
      notifyListeners();
    } catch (e) {
      _error = AppState.describeError(e);
      notifyListeners();
    }
  }

  @protected
  Future<void> requestApply(String id, bool plain) => _client.applyToClipboard(
        ApplyToClipboardRequest(clipId: id, plainText: plain),
        options: CallOptions(timeout: const Duration(seconds: 5)),
      );

  /// 下载但不覆盖剪贴板：下完由 [choose] 放进剪贴板再粘贴
  @protected
  Future<void> requestFetch(String id) => _client.fetch(FetchRequest(clipId: id, preserveClipboard: true));

  @protected
  Future<void> requestFavorite(String id, bool favorite) =>
      _client.setFavorite(SetFavoriteRequest(clipId: id, favorite: favorite));

  /// 图片行的小缩略图：取一次本机路径，记下来。
  Future<void> loadThumbnail(ClipRecord r) async {
    if (_thumbs.containsKey(r.id) || r.status != ClipStatus.CLIP_STATUS_READY) return;
    _thumbs[r.id] = '';
    try {
      final p = await imagePreview(r.id);
      if (p.path.isNotEmpty && File(p.path).existsSync()) {
        _thumbs[r.id] = p.path;
        notifyListeners();
      }
    } catch (_) {}
  }

  // ─────────────────────────── 悬停提示框 ───────────────────────────

  @override
  Future<ClipDetail> clipDetail(String clipId) async =>
      _details[clipId] ??= await _client.getClipDetail(GetClipDetailRequest(clipId: clipId));

  @override
  Future<GetImagePreviewResponse> imagePreview(String clipId, {int index = 0}) => _client.getImagePreview(
        GetImagePreviewRequest(clipId: clipId, index: index),
        options: CallOptions(timeout: const Duration(seconds: 20)),
      );

  DaemonServiceClient get _client {
    final c = _conn;
    if (c == null) throw DaemonNotRunning('快捷窗口还没连上后台服务');
    return c.client;
  }

  /// 测试用：直接填入数据，不连接后台服务。
  @visibleForTesting
  void debugSeed({
    required Config config,
    List<ClipRecord> records = const [],
    List<ClipRecord> favorites = const [],
    PasteStatus paste = const PasteStatus(available: true, reason: ''),
  }) {
    _config = config;
    language.value = config.language;
    _records
      ..clear()
      ..addAll(records);
    _favorites
      ..clear()
      ..addAll(favorites);
    _paste = paste;
    _connected = true;
    notifyListeners();
  }

  @visibleForTesting
  void debugEvent(Event ev) => _onEvent(ev);

  @visibleForTesting
  void debugShow() => _onShow();

  @override
  void dispose() {
    _retry?.cancel();
    _searchTimer?.cancel();
    _permissionPoll?.cancel();
    _events?.cancel();
    _commands?.cancel();
    _statusOut?.close();
    _conn?.close();
    super.dispose();
  }
}
