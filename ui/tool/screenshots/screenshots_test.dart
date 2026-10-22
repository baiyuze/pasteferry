// 生成 README 与网站用的界面截图：演示数据，不连接后台服务，不读真实剪贴板。
//
// 不要直接运行，用仓库根目录的 tools/screenshots/render.sh——
// 它会先从本机系统字体生成渲染用的字体文件，渲染完再加上 macOS 窗口外框。
//
// 放在 tool/ 而非 test/：它依赖本机字体，不该随 flutter test 在 CI 上跑。
// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'dart:async';
import 'dart:io';
import 'dart:ui' show ImageByteFormat;

import 'package:pasteferry_ui/app_state.dart';
import 'package:pasteferry_ui/background_service.dart';
import 'package:pasteferry_ui/gen/pasteferry/v1/daemon.pb.dart';
import 'package:pasteferry_ui/i18n.dart';
import 'package:pasteferry_ui/main.dart';
import 'package:pasteferry_ui/picker/picker_host.dart';
import 'package:pasteferry_ui/picker/picker_state.dart';
import 'package:pasteferry_ui/picker/picker_view.dart';
import 'package:pasteferry_ui/theme.dart';
import 'package:pasteferry_ui/widgets/nearby_dialog.dart';
import 'package:pasteferry_ui/widgets/pairing_dialog.dart';
import 'package:pasteferry_ui/widgets/send_dialog.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// 截图的界面语言：zh、zh-tw、zh-hk、en 或 ja，由 render.sh 设置。演示数据里的文件名、文字也跟着换。
final _lang = Platform.environment['SCREENSHOT_LANG'] ?? 'zh';
final _locale = switch (_lang) { 'zh-tw' => zhHantTW, 'zh-hk' => zhHantHK, _ => Locale(_lang) };
String _t(String zh, String en, String ja, {required String tw, required String hk}) =>
    switch (_lang) { 'en' => en, 'ja' => ja, 'zh-tw' => tw, 'zh-hk' => hk, _ => zh };

/// 汉字的字形跟着语言走：日文界面用冬青黑体，繁体用苹方的台湾、香港字形，否则用简体的苹方
final _cjk = switch (_lang) {
  'ja' => const ['Hiragino', 'PingFang'],
  'zh-tw' => const ['PingFangTC'],
  'zh-hk' => const ['PingFangHK'],
  _ => const ['PingFang'],
};

/// 生成配对码、搜索附近设备、搜索复制记录都不走后台服务，直接给固定的演示数据。
class _DemoState extends AppState {
  @override
  Future<PairingCode> createPairingCode() async => (code: 'K7MP2X', addresses: ['192.168.1.20']);

  @override
  Future<ListHistoryResponse> requestSearch(String query) async =>
      ListHistoryResponse(records: records.where((r) => matchesSearch(r, query)), searched: true);

  // 悬停提示框里的全文
  @override
  Future<ClipDetail> clipDetail(String clipId) async => ClipDetail(text: _meetingNotes, textLength: _meetingNotes.length);

  // 不关闭的流：后台服务那边的订阅一直开着，结束就表示后台服务断开了
  @override
  Stream<List<NearbyDevice>> watchNearby() => (StreamController<List<NearbyDevice>>()
        ..add([
          NearbyDevice(id: 'n1', name: _t('设计部的 PC', 'Design PC', 'デザイン部の PC', tw: '設計部的 PC', hk: '設計部的 PC'), platform: 'windows'),
          NearbyDevice(id: 'n2', name: 'MacBook Air', platform: 'darwin', paired: true),
          NearbyDevice(id: 'n3', name: _t('会议室的 iMac', 'Meeting room iMac', '会議室の iMac', tw: '會議室的 iMac', hk: '會議室的 iMac'), platform: 'darwin'),
        ]))
      .stream;
}

Future<void> _loadFonts() async {
  final dir = Platform.environment['SCREENSHOT_FONTS'];
  if (dir == null) throw StateError('用 tools/screenshots/render.sh 运行，它会设置 SCREENSHOT_FONTS');

  Future<void> family(String name, List<String> files) async {
    final loader = FontLoader(name);
    for (final f in files) {
      loader.addFont(Future.value(ByteData.sublistView(File('$dir/$f').readAsBytesSync())));
    }
    await loader.load();
  }

  await family('SF', ['SF-Regular.ttf', 'SF-Medium.ttf', 'SF-Semibold.ttf']);
  await family('PingFang', ['PingFang-Regular.ttf', 'PingFang-Medium.ttf', 'PingFang-Semibold.ttf']);
  await family('PingFangTC', ['PingFangTC-Regular.ttf', 'PingFangTC-Medium.ttf', 'PingFangTC-Semibold.ttf']);
  await family('PingFangHK', ['PingFangHK-Regular.ttf', 'PingFangHK-Medium.ttf', 'PingFangHK-Semibold.ttf']);
  await family('Hiragino', ['Hiragino-Regular.ttf', 'Hiragino-Medium.ttf', 'Hiragino-Semibold.ttf']);
  await family(monoFamily, ['Menlo-Regular.ttf', 'Menlo-Bold.ttf']);
  // 图标字体随依赖包打进测试资源，但测试环境不会自动加载
  final icons = FontLoader('packages/cupertino_icons/CupertinoIcons')
    ..addFont(rootBundle.load('packages/cupertino_icons/assets/CupertinoIcons.ttf'));
  await icons.load();
}

final _now = DateTime.now();
Int64 _ago(Duration d) => Int64(_now.subtract(d).millisecondsSinceEpoch ~/ 1000);

ClipRecord _clip(
  String id,
  ClipKind kind, {
  String preview = '',
  bool outgoing = false,
  String from = 'MacBook Air',
  int size = 0,
  required Duration ago,
  ClipStatus status = ClipStatus.CLIP_STATUS_READY,
  List<ClipItem> items = const [],
}) =>
    ClipRecord(
      id: id,
      kind: kind,
      status: status,
      outgoing: outgoing,
      originDeviceName: outgoing ? 'MacBook Pro' : from,
      textPreview: preview,
      totalSize: Int64(size),
      createdAtUnix: _ago(ago),
      items: items,
    );

const _mb = 1024 * 1024;
final _quarterly = _t('季度汇报-终版.key', 'Q3 review - final.key', '四半期報告_最終版.key',
    tw: '季度報告-定稿.key', hk: '季度報告-最終版.key');
final _meeting = _t('会议结论：周二灰度 10%，观察两天没问题周四全量；回滚预案见文档第 3 节',
    'Decision: ship to 10% on Tuesday, everyone on Thursday if two days look clean. Rollback plan in section 3',
    '決定事項：火曜に 10% へ先行公開、2 日問題なければ木曜に全体公開。切り戻し手順は資料の第 3 節',
    tw: '會議結論：週二先開放 10%，觀察兩天沒問題就在週四全面上線；回滾方案見文件第 3 節',
    hk: '會議結論：星期二先開放 10%，觀察兩日沒問題便於星期四全面推出；回滾方案見文件第 3 節');
// 悬停提示框里显示的全文：比列表里那一行长，换了行
final _meetingNotes = _meeting + _t(
    '\n\n负责人：前端 小林，后端 老周，测试 阿杰\n发布窗口：周二 10:00–11:00\n监控：错误率超过 0.5% 立即回滚',
    '\n\nOwners: web Lin, backend Zhou, QA Jay\nRelease window: Tuesday 10:00–11:00\nMonitoring: roll back at once if errors exceed 0.5%',
    '\n\n担当：フロント 林、バックエンド 周、テスト 杰\n公開時間：火曜 10:00–11:00\n監視：エラー率 0.5% 超えで即切り戻し',
    tw: '\n\n負責人：前端 小林，後端 老周，測試 阿杰\n發布時段：週二 10:00–11:00\n監控：錯誤率超過 0.5% 立即回滾',
    hk: '\n\n負責人：前端 小林，後端 老周，測試 阿杰\n發佈時段：星期二 10:00–11:00\n監察：錯誤率超過 0.5% 立即回滾');

ClipRecord _favorite(ClipRecord r, Duration ago) => r
  ..favorite = true
  ..favoritedAtUnix = _ago(ago);

/// 收藏页的演示数据：常用的文字、链接、文件。收藏页按收藏时间从新到旧排。
/// 例子里不用编出来的公司名、真实的地址
List<ClipRecord> _favorites() => <ClipRecord>[
      _favorite(
          _clip('f1', ClipKind.CLIP_KIND_TEXT,
              preview: _t('周报模板：本周完成 / 下周计划 / 需要协助',
                  'Weekly report: done this week / next week / blockers',
                  '週報テンプレート：今週の成果／来週の予定／相談事項',
                  tw: '週報範本：本週完成 / 下週計畫 / 需要協助',
                  hk: '週報範本：本週完成 / 下週計劃 / 需要協助'),
              outgoing: true, size: 72, ago: const Duration(days: 12)),
          const Duration(days: 12)),
      _favorite(
          _clip('f2', ClipKind.CLIP_KIND_TEXT,
              preview: _t('收到，我看一下，今天下班前给你答复。', 'Got it — I’ll take a look and get back to you today.',
                  '承知しました。確認して本日中にお返事します。',
                  tw: '收到，我看一下，今天下班前給你答覆。', hk: '收到，我睇一睇，今日放工前覆你。'),
              outgoing: true, size: 54, ago: const Duration(days: 6)),
          const Duration(days: 6)),
      _favorite(
          _clip('f3', ClipKind.CLIP_KIND_TEXT,
              preview: 'https://pasteferry.cc/download/', outgoing: true, size: 31, ago: const Duration(days: 4))
            ..isLink = true,
          const Duration(days: 4)),
      _favorite(
          _clip('f4', ClipKind.CLIP_KIND_FILE,
              size: (1.2 * _mb).round(), ago: const Duration(days: 9),
              items: [ClipItem(name: _t('营业执照.pdf', 'certificate-of-incorporation.pdf', '登記簿謄本.pdf',
                  tw: '公司登記證明.pdf', hk: '商業登記證.pdf'), size: Int64((1.2 * _mb).round()))]),
          const Duration(days: 3)),
      _favorite(
          _clip('f5', ClipKind.CLIP_KIND_TEXT,
              preview: 'ssh deploy@203.0.113.10 -p 2222', outgoing: true, size: 32, ago: const Duration(days: 20)),
          const Duration(days: 2)),
    ].reversed.toList();

AppState _demo({LinkState link = LinkState.online,
    ServiceState? service, Device? pending, bool empty = false,
    String server = 'wss://sync.example.com/signal'}) {
  final state = _DemoState();
  state.debugSeed(
    link: link,
    serviceState: service,
    pendingPairing: pending,
    status: Status(
      version: '2.4.1',
      deviceName: 'MacBook Pro',
      signalingConnected: link == LinkState.online && server.isNotEmpty,
      serverConfigured: server.isNotEmpty,
      lanEnabled: true,
      clipboardPermission: ClipboardPermission.CLIPBOARD_PERMISSION_ALWAYS_ALLOW,
      cacheBytesUsed: Int64(412 * _mb),
      peersOnline: 2,
    ),
    config: Config(
      signalingUrl: server,
      deviceName: 'MacBook Pro',
      autoSyncThresholdBytes: Int64(50 * _mb),
      historyTtlSeconds: Int64(3 * 86400),
      cacheTtlSeconds: Int64(86400),
      syncText: true,
      syncHtml: true,
      syncImage: true,
      syncFile: true,
      autoApplyToClipboard: true,
    ),
    self: Device(id: 'self', name: 'MacBook Pro', platform: 'darwin', publicKeyFingerprint: 'H3QD-7KXA-M2PV'),
    peers: empty ? const [] : [
      Device(
        id: 'air',
        name: 'MacBook Air',
        platform: 'darwin',
        online: true,
        connection: ConnectionKind.CONNECTION_KIND_DIRECT,
        publicKeyFingerprint: 'R8NF-2WTC-QL5J',
      ),
      Device(
        id: 'mini',
        name: 'Mac mini',
        platform: 'darwin',
        online: true,
        connection: ConnectionKind.CONNECTION_KIND_RELAY,
        publicKeyFingerprint: 'B6YE-X4MH-9DKS',
      ),
      Device(id: 'imac', name: 'iMac', platform: 'darwin', publicKeyFingerprint: 'T2VA-LP7Q-8ZRN'),
    ],
    favorites: empty ? const [] : _favorites(),
    records: empty ? const [] : [
      _clip('1', ClipKind.CLIP_KIND_TEXT,
          preview: 'git push origin release/1.0 && gh release create v1.0.0',
          outgoing: true, size: 54, ago: const Duration(seconds: 4)),
      _clip('2', ClipKind.CLIP_KIND_IMAGE,
          preview: _t('图片 2.4 MB', 'Image 2.4 MB', '画像 2.4 MB', tw: '圖片 2.4 MB', hk: '圖片 2.4 MB'), size: (2.4 * _mb).round(), ago: const Duration(minutes: 2),
          items: [ClipItem(name: 'image.png', size: Int64((2.4 * _mb).round()))]),
      _clip('3', ClipKind.CLIP_KIND_FILE,
          size: (38.2 * _mb).round(), ago: const Duration(minutes: 9),
          items: [ClipItem(name: _quarterly, size: Int64((38.2 * _mb).round()))]),
      _clip('4', ClipKind.CLIP_KIND_FILE,
          size: (1.3 * 1024 * _mb).round(), ago: const Duration(minutes: 14),
          from: 'Mac mini', status: ClipStatus.CLIP_STATUS_REMOTE_ONLY,
          items: [ClipItem(name: _t('发布演示录屏.mov', 'launch-demo.mov', '発表デモ.mov', tw: '發表會示範錄影.mov', hk: '發佈會示範錄影.mov'), size: Int64((1.3 * 1024 * _mb).round()))]),
      _clip('5', ClipKind.CLIP_KIND_HTML,
          preview: _meeting, from: 'Mac mini', size: 2310, ago: const Duration(minutes: 26)),
      _clip('6', ClipKind.CLIP_KIND_FILE,
          outgoing: true, size: 126 * _mb, ago: const Duration(minutes: 41),
          items: [ClipItem(name: 'design-assets', size: Int64(126 * _mb), isDir: true)]),
      _clip('7', ClipKind.CLIP_KIND_FILE,
          size: (18.6 * _mb).round(), ago: const Duration(hours: 1),
          status: ClipStatus.CLIP_STATUS_FETCHING,
          items: [ClipItem(name: _t('合同扫描件.pdf', 'signed-contract.pdf', '契約書_署名済み.pdf', tw: '合約掃描檔.pdf', hk: '合約掃描本.pdf'), size: Int64((18.6 * _mb).round()))]),
      _clip('8', ClipKind.CLIP_KIND_TEXT,
          preview: 'https://github.com/baiyuze/pasteferry/releases', outgoing: true, size: 44,
          ago: const Duration(hours: 3))
        ..isLink = true,
      _clip('9', ClipKind.CLIP_KIND_FILE,
          size: (4.1 * _mb).round(), ago: const Duration(hours: 5),
          items: [
            ClipItem(name: 'IMG_2041.HEIC', size: Int64((1.4 * _mb).round())),
            ClipItem(name: 'IMG_2042.HEIC', size: Int64((1.3 * _mb).round())),
            ClipItem(name: 'IMG_2043.HEIC', size: Int64((1.4 * _mb).round())),
          ]),
      _clip('10', ClipKind.CLIP_KIND_IMAGE,
          preview: _t('图片 864 KB', 'Image 864 KB', '画像 864 KB', tw: '圖片 864 KB', hk: '圖片 864 KB'), outgoing: true, size: 864 * 1024, ago: const Duration(days: 1),
          items: [ClipItem(name: 'image.png', size: Int64(864 * 1024))]),
    ],
  );
  return state;
}

/// 隔空传送页的演示数据：同一局域网、跨网络中转、离线的设备，收到的与发出的各种状态。
AppState _sendDemo() {
  final base = _demo();
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  Int64 ago(int s) => Int64(now - s);
  const incoming = TransferDirection.TRANSFER_DIRECTION_INCOMING;
  const outgoing = TransferDirection.TRANSFER_DIRECTION_OUTGOING;
  final photos = _t('照片 2026-10', 'Photos 2026-10', '写真 2026-10', tw: '照片 2026-10', hk: '相片 2026-10');
  final contract = _t('合同扫描件.pdf', 'signed-contract.pdf', '契約書_署名済み.pdf', tw: '合約掃描檔.pdf', hk: '合約掃描本.pdf');
  final windows = _t('Windows 台式机', 'Windows Desktop', 'Windows デスクトップ', tw: 'Windows 桌機', hk: 'Windows 桌面電腦');
  final ubuntu = _t('Ubuntu 笔记本', 'Ubuntu Laptop', 'Ubuntu ノート', tw: 'Ubuntu 筆電', hk: 'Ubuntu 手提電腦');
  base.debugSeed(
    status: base.status!..officialUsage = OfficialUsage(available: true, remainingBytes: Int64(62 * _mb)),
    config: base.config!..serviceMode = ServiceMode.SERVICE_MODE_OFFICIAL,
    self: base.self!,
    peers: [
      Device(id: 'air', name: 'MacBook Air', platform: 'darwin', online: true, lanReachable: true,
          connection: ConnectionKind.CONNECTION_KIND_DIRECT, receivesFiles: true),
      Device(id: 'win', name: windows, platform: 'windows', online: true,
          connection: ConnectionKind.CONNECTION_KIND_RELAY, receivesFiles: true),
      Device(id: 'ubuntu', name: ubuntu, platform: 'linux', receivesFiles: true),
    ],
    transfers: [
      Transfer(id: 'r1', direction: incoming, deviceId: 'air', deviceName: 'MacBook Air', status: 'active',
          items: [ClipItem(name: photos, isDir: true, size: Int64(2150 * _mb))],
          totalBytes: Int64(2150 * _mb), doneBytes: Int64(1462 * _mb), fileCount: Int64(412),
          bytesPerSecond: 42.0 * _mb, currentFile: '$photos/IMG_2041.HEIC', currentIndex: Int64(281),
          createdAtUnix: ago(40)),
      Transfer(id: 'r2', direction: incoming, deviceId: 'air', deviceName: 'MacBook Air', status: 'done',
          items: [ClipItem(name: contract), ClipItem(name: 'notes.txt'), ClipItem(name: 'IMG_2042.HEIC')],
          paths: ['/a', '/b', '/c'], present: [true, true, true], totalBytes: Int64((18.4 * _mb).round()),
          fileCount: Int64(3), createdAtUnix: ago(200), finishedAtUnix: ago(180), seen: true),
      Transfer(id: 'r3', direction: incoming, deviceId: 'win', deviceName: windows, status: 'done',
          items: [ClipItem(name: 'PasteFerry-Setup.exe')], paths: ['/d'], present: [false],
          totalBytes: Int64(42 * _mb), fileCount: Int64(1), createdAtUnix: ago(90000), finishedAtUnix: ago(90000),
          seen: true),
      Transfer(id: 's1', direction: outgoing, deviceId: 'air', deviceName: 'MacBook Air', status: 'done',
          items: [ClipItem(name: 'design-assets', isDir: true)], paths: ['/e'], totalBytes: Int64(126 * _mb),
          fileCount: Int64(58), createdAtUnix: ago(4000), finishedAtUnix: ago(3990)),
    ],
  );
  return base;
}

final _boundary = GlobalKey();

Future<void> _shoot(
  WidgetTester tester,
  String name, {
  required AppState state,
  Section section = Section.history,
  Brightness brightness = Brightness.light,
  Future<void> Function()? arrange,
  bool settle = true,
}) async {
  // 960×640 的窗口，按 Retina 2 倍渲染
  tester.view.physicalSize = const Size(1920, 1280);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  // 平台覆盖必须在测试体内复原：框架在执行 tearDown 之前就会检查它
  debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
  // 测试框架默认把阴影画成实心描边（便于图片比对），截图要真实的模糊阴影
  debugDisableShadows = false;
  try {
    await _render(tester, name, state: state, section: section, brightness: brightness,
        arrange: arrange, settle: settle);
  } finally {
    debugDefaultTargetPlatformOverride = null;
    debugDisableShadows = true;
  }
}

Future<void> _render(
  WidgetTester tester,
  String name, {
  required AppState state,
  required Section section,
  required Brightness brightness,
  required Future<void> Function()? arrange,
  required bool settle,
}) async {

  final theme = buildTheme(brightness, fontFamily: 'SF', fontFamilyFallback: _cjk);
  await tester.pumpWidget(RepaintBoundary(
    key: _boundary,
    child: AppScope(
      state: state,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        locale: _locale,
        supportedLocales: supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Shell(initialSection: section),
      ),
    ),
  ));
  await tester.pump();
  // 图片解码是真实的异步操作，在测试的假时钟里不会自己完成
  await tester.runAsync(() async {
    for (final el in find.byType(Image).evaluate()) {
      await precacheImage((el.widget as Image).image, el);
    }
  });
  await tester.pump();
  if (arrange != null) await arrange();
  // 「拉取中」的进度条是无限动画，有它在的页面不能等动画结束
  settle ? await tester.pumpAndSettle() : await tester.pump(const Duration(milliseconds: 400));
  await _capture(tester, name);
}

/// 自己按 2 倍截取：matchesGoldenFile 只按 1 倍输出，放到 Retina 屏上会糊。
Future<void> _capture(WidgetTester tester, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_boundary));
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final png = await image.toByteData(format: ImageByteFormat.png);
    File('tool/screenshots/out/$name.png')
      ..createSync(recursive: true)
      ..writeAsBytesSync(png!.buffer.asUint8List());
  });
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    appL10n = lookupAppLocalizations(_locale);
    await _loadFonts();
  });

  testWidgets('history', (tester) async {
    await _shoot(tester, 'history', state: _demo(), settle: false, arrange: () async {
      // 悬停在一条记录上，展示「放入剪贴板」
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(find.text(_quarterly)));
      await tester.pump();
    });
  });

  testWidgets('history-dark', (tester) async {
    await _shoot(tester, 'history-dark',
        state: _demo(), brightness: Brightness.dark, settle: false);
  });

  // 网站「功能」页：鼠标停在一条长文字上，弹出提示框显示全文
  testWidgets('hover-dark', (tester) async {
    await _shoot(tester, 'hover-dark', state: _demo(), brightness: Brightness.dark, settle: false,
        arrange: () async {
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(find.text(_meeting)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();
      await tester.pump();
    });
  });

  testWidgets('favorites-dark', (tester) async {
    await _shoot(tester, 'favorites-dark', state: _demo(), section: Section.favorites,
        brightness: Brightness.dark);
  });

  // 快捷粘贴窗口：单独渲染，透明背景，自带圆角与阴影
  testWidgets('card-picker-dark', (tester) async {
    await _shootPicker(tester, 'card-picker-dark');
  });

  testWidgets('card-picker-search-dark', (tester) async {
    await _shootPicker(tester, 'card-picker-search-dark', query: 'docker');
  });

  for (final dark in [false, true]) {
    testWidgets(dark ? 'send-dark' : 'send', (tester) async {
      await _shoot(tester, dark ? 'send-dark' : 'send',
          state: _sendDemo(),
          section: Section.send,
          brightness: dark ? Brightness.dark : Brightness.light,
          settle: false, // 雷达的波纹一直在动
          arrange: () async => tester.pump(const Duration(milliseconds: 900)));
    });
  }

  testWidgets('send-dialog', (tester) async {
    await _shoot(tester, 'send-dialog', state: _sendDemo(), section: Section.send, settle: false,
        arrange: () async {
      showDialog<void>(
        context: tester.element(find.byType(Shell)),
        builder: (_) => const SendDialog(deviceId: 'air'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
    });
  });

  testWidgets('devices', (tester) async {
    await _shoot(tester, 'devices', state: _demo(), section: Section.devices);
  });

  testWidgets('pairing', (tester) async {
    await _shoot(tester, 'pairing', state: _demo(), section: Section.devices, arrange: () async {
      showDialog<void>(
        context: tester.element(find.byType(Shell)),
        builder: (_) => const PairingDialog(),
      );
    });
  });

  for (final dark in [false, true]) {
    testWidgets(dark ? 'nearby-dark' : 'nearby', (tester) async {
      await _shoot(tester, dark ? 'nearby-dark' : 'nearby',
          state: _demo(),
          section: Section.devices,
          brightness: dark ? Brightness.dark : Brightness.light,
          settle: false, // 雷达的波纹一直在动
          arrange: () async {
        showDialog<void>(
          context: tester.element(find.byType(Shell)),
          builder: (_) => const NearbyDialog(),
        );
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 900));
      });
    });
  }

  testWidgets('verify', (tester) async {
    await _shoot(tester, 'verify',
        section: Section.devices,
        state: _demo(
          pending: Device(
            id: 'new',
            name: 'MacBook Air',
            platform: 'darwin',
            publicKeyFingerprint: 'R8NF-2WTC-QL5J',
            pairingSession: 's1',
          ),
        ));
  });

  testWidgets('settings', (tester) async {
    await _shoot(tester, 'settings', state: _demo(), section: Section.settings);
  });

  AppState officialDemo() {
    final state = _demo();
    final bjt = _now.toUtc().add(const Duration(hours: 8));
    final reset = DateTime.utc(bjt.year, bjt.month, bjt.day + 1).subtract(const Duration(hours: 8));
    state.debugSeed(
      status: state.status!.deepCopy()
        ..deviceId = 'demo-device-7k2m9q4v'
        ..officialUsage = OfficialUsage(
          available: true,
          uploadBytes: Int64(12340000),
          downloadBytes: Int64(7660000),
          limitBytes: Int64(100000000),
          remainingBytes: Int64(80000000),
          updatedAtUnix: Int64(_now.millisecondsSinceEpoch ~/ 1000),
          resetAtUnix: Int64(reset.millisecondsSinceEpoch ~/ 1000),
        ),
      config: state.config!.deepCopy()
        ..serviceMode = ServiceMode.SERVICE_MODE_OFFICIAL
        ..signalingUrl = '',
      self: state.self!,
      peers: state.peers,
      records: state.records,
    );
    return state;
  }

  testWidgets('official-settings-dark', (tester) async {
    await _shoot(tester, 'official-settings-dark', state: officialDemo(),
        section: Section.settings, brightness: Brightness.dark);
  });

  testWidgets('official-usage-dark', (tester) async {
    await _shoot(tester, 'official-usage-dark', state: officialDemo(),
        section: Section.official, brightness: Brightness.dark);
  });

  // 网站「在局域网里部署服务器」：服务器地址填局域网 IP，已连接
  testWidgets('settings-lan-dark', (tester) async {
    await _shoot(tester, 'settings-lan-dark',
        state: _demo(server: 'ws://192.168.1.20:8787/signal'),
        section: Section.settings, brightness: Brightness.dark);
  });

  // 网站「部署到公网服务器」：服务器地址填公网 IP（文档专用的示例地址段）
  testWidgets('settings-cloud-dark', (tester) async {
    await _shoot(tester, 'settings-cloud-dark',
        state: _demo(server: 'ws://203.0.113.10:8787/signal'),
        section: Section.settings, brightness: Brightness.dark);
  });

  // 网站「快速开始」：第一次打开、生成配对码，深色界面配深色网页
  testWidgets('welcome-dark', (tester) async {
    final state = _demo(link: LinkState.offline, service: ServiceState.notInstalled, empty: true);
    await _shoot(tester, 'welcome-dark', state: state, brightness: Brightness.dark);
  });

  testWidgets('pairing-dark', (tester) async {
    await _shoot(tester, 'pairing-dark', state: _demo(), section: Section.devices,
        brightness: Brightness.dark, arrange: () async {
      showDialog<void>(
        context: tester.element(find.byType(Shell)),
        builder: (_) => const PairingDialog(),
      );
    });
  });

  // 网站「同一网络」的跨网段一节与「Tailscale」：输入配对码，展开地址框，填上对方显示的地址
  for (final (name, address) in [('pairing-join-dark', '192.168.1.20'), ('pairing-join-ts-dark', '100.92.41.17')]) {
    testWidgets(name, (tester) async {
      await _shoot(tester, name, state: _demo(), section: Section.devices,
          brightness: Brightness.dark, arrange: () async {
        showDialog<void>(
          context: tester.element(find.byType(Shell)),
          builder: (_) => const PairingDialog(),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text(appL10n.enterCode));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).last, 'K7MP2X');
        await tester.tap(find.text(appL10n.differentSubnet));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).last, address);
      });
    });
  }

  // 网站上与文字并排展示的对话框：单独渲染，透明背景，保留对话框自己的圆角与阴影
  for (final dark in [false, true]) {
    testWidgets(dark ? 'card-verify-dark' : 'card-verify', (tester) async {
      tester.view.physicalSize = const Size(1120, 800);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      debugDisableShadows = false;
      try {
        final brightness = dark ? Brightness.dark : Brightness.light;
        await tester.pumpWidget(RepaintBoundary(
          key: _boundary,
          // 对话框要同时显示本机的指纹，从 AppScope 里取
          child: AppScope(
            state: _demo(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: buildTheme(brightness, fontFamily: 'SF', fontFamilyFallback: _cjk),
              locale: _locale,
              supportedLocales: supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: PairingConfirmDialog(
                    peer: Device(name: 'MacBook Air', publicKeyFingerprint: 'R8NF-2WTC-QL5J'),
                  ),
                ),
              ),
            ),
          ),
        ));
        await tester.pumpAndSettle();
        await _capture(tester, dark ? 'card-verify-dark' : 'card-verify');
      } finally {
        debugDefaultTargetPlatformOverride = null;
        debugDisableShadows = true;
      }
    });
  }

  testWidgets('welcome', (tester) async {
    // 首次打开时还没有任何记录和设备
    final state = _demo(link: LinkState.offline, service: ServiceState.notInstalled, empty: true);
    await _shoot(tester, 'welcome', state: state);
  });
}

// ─────────────────────────── 快捷粘贴窗口 ───────────────────────────

const _pickerChannel = MethodChannel('pasteferry/picker');

/// 快捷窗口的演示数据，照 design/quick-paste-and-favorites.md 第 2.6 节的示意。不连后台服务。
class _DemoPicker extends PickerState {
  _DemoPicker() : super(host: PickerHost(_pickerChannel));

  @override
  Future<ListHistoryResponse> requestSearch(String query, PickerTab tab) async => ListHistoryResponse(searched: false);

  @override
  Future<ClipDetail> clipDetail(String clipId) async => ClipDetail();

  @override
  Future<GetImagePreviewResponse> imagePreview(String clipId, {int index = 0}) async => GetImagePreviewResponse();
}

ClipRecord _pick(String id, String text, Duration ago, {bool link = false, bool favorited = false}) =>
    _clip(id, ClipKind.CLIP_KIND_TEXT, preview: text, outgoing: true, size: text.length, ago: ago)
      ..isLink = link
      ..favorited = favorited;

List<ClipRecord> _pickerRecords() => [
      _pick('p1', _t('会议改到周四下午 3 点，地点不变', 'Meeting moved to Thursday 3 pm, same room',
          '打ち合わせは木曜 15 時に変更、場所は同じ',
          tw: '會議改到週四下午 3 點，地點不變', hk: '會議改到星期四下午 3 點，地點不變'), const Duration(seconds: 8)),
      _pick('p2', 'https://github.com/baiyuze/pasteferry', const Duration(minutes: 2), link: true),
      _clip('p3', ClipKind.CLIP_KIND_IMAGE,
          preview: _t('截图 14.32.png', 'Screenshot 14.32.png', 'スクリーンショット 14.32.png',
              tw: '截圖 14.32.png', hk: '截圖 14.32.png'),
          from: _t('Windows 台式机', 'Windows PC', 'Windows デスクトップ', tw: 'Windows 桌機', hk: 'Windows 桌面電腦'),
          size: 412 * 1024, ago: const Duration(minutes: 5),
          items: [ClipItem(name: _t('截图 14.32.png', 'Screenshot 14.32.png', 'スクリーンショット 14.32.png',
              tw: '截圖 14.32.png', hk: '截圖 14.32.png'), size: Int64(412 * 1024))])
        ..favorited = true,
      _clip('p4', ClipKind.CLIP_KIND_FILE, outgoing: true, size: (6.4 * _mb).round(), ago: const Duration(minutes: 52),
          items: [
            ClipItem(name: _t('合同扫描件.pdf', 'signed-contract.pdf', '契約書_署名済み.pdf', tw: '合約掃描檔.pdf', hk: '合約掃描本.pdf'),
                size: Int64((2.2 * _mb).round())),
            ClipItem(name: _t('报价单.xlsx', 'quote.xlsx', '見積書.xlsx', tw: '報價單.xlsx', hk: '報價單.xlsx'), size: Int64(96 * 1024)),
            ClipItem(name: _t('附件.zip', 'attachments.zip', '添付.zip', tw: '附件.zip', hk: '附件.zip'), size: Int64((4.1 * _mb).round())),
          ]),
      _pick('p5', 'docker compose up -d --build', const Duration(hours: 1, minutes: 5)),
      _clip('p6', ClipKind.CLIP_KIND_FILE, status: ClipStatus.CLIP_STATUS_REMOTE_ONLY,
          size: 812 * _mb, ago: const Duration(hours: 20),
          items: [ClipItem(name: 'PasteFerry.dmg', size: Int64(812 * _mb))]),
      _pick('p7', _t('快递单号：7712 3456 0098', 'Tracking number: 7712 3456 0098', '追跡番号：7712 3456 0098',
          tw: '物流單號：7712 3456 0098', hk: '速遞單號：7712 3456 0098'),
          const Duration(hours: 22), favorited: true),
      _pick('p8', "SELECT id, status FROM orders WHERE created_at > now() - interval '1 day'", const Duration(hours: 23)),
      _pick('p9', 'pnpm install', const Duration(hours: 26)),
      _pick('p10', 'git push origin main', const Duration(hours: 27)),
      _pick('p11', 'docker logs -f gateway', const Duration(days: 2)),
      _pick('p12', _t('把 docker 镜像源换成国内的', 'switch the docker registry mirror', 'docker のミラーを切り替える',
          tw: '把 docker 映像來源換成本地的', hk: '把 docker 鏡像源換成本地的'), const Duration(days: 2, hours: 3)),
    ];

Future<void> _shootPicker(WidgetTester tester, String name, {String query = ''}) async {
  // 窗口 560×460，四周留出阴影的位置
  const pad = 40.0;
  tester.view.physicalSize = const Size((560 + pad * 2) * 2, (460 + pad * 2) * 2);
  tester.view.devicePixelRatio = 2;
  tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(_pickerChannel, (c) async {
    return switch (c.method) {
      'pasteStatus' => {'available': true, 'reason': ''},
      _ => null,
    };
  });
  debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
  debugDisableShadows = false;
  try {
    final s = _DemoPicker()
      ..debugSeed(
        config: Config(language: _lang == 'zh' ? 'zh-Hans' : _locale.toLanguageTag()),
        records: _pickerRecords(),
        favorites: _favorites(),
      );
    final theme = buildTheme(Brightness.dark, fontFamily: 'SF', fontFamilyFallback: _cjk).copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: Colors.transparent,
    );
    await tester.pumpWidget(RepaintBoundary(
      key: _boundary,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.transparent,
        theme: theme,
        locale: _locale,
        supportedLocales: supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Center(
          child: Container(
            width: 560,
            height: 460,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Radii.lg),
              boxShadow: const [
                BoxShadow(color: Color(0x73000000), blurRadius: 36, offset: Offset(0, 14)),
                BoxShadow(color: Color(0x40000000), blurRadius: 3),
              ],
            ),
            child: PickerView(state: s),
          ),
        ),
      ),
    ));
    await tester.pump();
    if (query.isNotEmpty) {
      await tester.enterText(find.byType(TextField), query);
      await tester.pump(const Duration(milliseconds: 300));
    }
    await tester.pumpAndSettle();
    await _capture(tester, name);
  } finally {
    debugDefaultTargetPlatformOverride = null;
    debugDisableShadows = true;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(_pickerChannel, null);
  }
}
