// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => '隔空贴';

  @override
  String get navHistory => '复制记录';

  @override
  String get navDevices => '设备';

  @override
  String get navSettings => '设置';

  @override
  String get navFavorites => '收藏';

  @override
  String get linkConnecting => '正在连接…';

  @override
  String get linkServiceNotRunning => '后台服务未运行';

  @override
  String get linkLanMode => '在局域网中查找设备';

  @override
  String get linkServerUnreachable => '连不上服务器，局域网内照常同步';

  @override
  String get linkNothingOn => '局域网发现已关闭，也没有设置服务器';

  @override
  String get linkLanBlocked => 'macOS 阻止了局域网访问';

  @override
  String linkOnlinePeers(int count) {
    return '$count 台设备在线';
  }

  @override
  String get linkServerConnected => '已连接服务器';

  @override
  String linkConnectionLost(String detail) {
    return '连接中断：$detail';
  }

  @override
  String get linkServiceDisconnected => '后台服务已断开';

  @override
  String get linkServiceDisabled => '后台服务已停用';

  @override
  String get errServiceNotConnected => '后台服务未连接';

  @override
  String get errUnimplemented => '该功能尚未接入';

  @override
  String get errUnavailable => '无法连接后台服务';

  @override
  String errServiceStart(String detail) {
    return '启动后台服务失败：$detail';
  }

  @override
  String errServiceRestart(String detail) {
    return '重启后台服务失败：$detail';
  }

  @override
  String errAutostart(String detail) {
    return '登记开机自启失败：$detail';
  }

  @override
  String get thisMacTitle => '这台 Mac';

  @override
  String get thisPcTitle => '这台电脑';

  @override
  String get thisMacInText => '这台 Mac ';

  @override
  String get thisPcInText => '这台电脑';

  @override
  String get bothMacs => '两台 Mac ';

  @override
  String get bothDevices => '两台设备';

  @override
  String get thisDeviceShort => '本机';

  @override
  String fromDevice(String name) {
    return '来自 $name';
  }

  @override
  String get cancel => '取消';

  @override
  String get close => '关闭';

  @override
  String get save => '保存';

  @override
  String get retry => '重试';

  @override
  String get continueAction => '继续';

  @override
  String get justNow => '刚刚';

  @override
  String secondsAgo(int n) {
    return '$n 秒前';
  }

  @override
  String minutesAgo(int n) {
    return '$n 分钟前';
  }

  @override
  String hoursAgo(int n) {
    return '$n 小时前';
  }

  @override
  String daysAgo(int n) {
    return '$n 天前';
  }

  @override
  String monthDay(int month, int day) {
    return '$month月$day日';
  }

  @override
  String durationHours(int n) {
    return '$n 小时';
  }

  @override
  String durationDays(int n) {
    return '$n 天';
  }

  @override
  String get historyEmptySubtitle => '在任意一台设备上复制，内容会出现在这里';

  @override
  String historyCount(int count) {
    return '共 $count 条';
  }

  @override
  String historyCountKept(int count, String ttl) {
    return '共 $count 条，保留 $ttl';
  }

  @override
  String get filterAll => '全部';

  @override
  String get filterText => '文本';

  @override
  String get filterImage => '图片';

  @override
  String get filterFile => '文件';

  @override
  String get filterLink => '链接';

  @override
  String get historyClearTooltip => '清空记录';

  @override
  String get historyEmptyTitle => '还没有记录';

  @override
  String get historyEmptyFilteredTitle => '没有这一类的记录';

  @override
  String get historyEmptyBody => '在任意一台已配对的设备上复制文本、图片或文件，记录会出现在这里。';

  @override
  String get clearConfirmTitle => '清空全部记录？';

  @override
  String clearConfirmBody(String device) {
    return '所有设备上同步来的记录和已缓存的文件都会从$device上删除。原始文件不受影响。';
  }

  @override
  String get clear => '清空';

  @override
  String get historyCleared => '记录已清空';

  @override
  String get permDeniedTitle => '已禁止隔空贴读取剪贴板';

  @override
  String get permAskTitle => '允许隔空贴读取剪贴板';

  @override
  String get permDeniedBody =>
      '在这台 Mac 上复制的内容不会同步出去。到系统设置里把 PasteFerry Daemon 改为「允许」。';

  @override
  String get permAskBody =>
      '否则 macOS 每次都会弹窗询问。到系统设置里把 PasteFerry Daemon 改为「允许」。';

  @override
  String get openSystemSettings => '打开系统设置';

  @override
  String get fetch => '接收';

  @override
  String get fetchStarted => '正在接收，可在复制记录查看进度';

  @override
  String get transferFailed => '传输失败';

  @override
  String get expired => '已过期';

  @override
  String get putOnClipboard => '放入剪贴板';

  @override
  String get putOnClipboardDone => '已放入剪贴板';

  @override
  String get deleteRecord => '删除这条记录';

  @override
  String get deleted => '已删除';

  @override
  String get emptyRecord => '（空）';

  @override
  String get imageRecord => '图片';

  @override
  String itemsSummary(String name, int others, int count) {
    return '$name 等 $count 项';
  }

  @override
  String get searchHint => '搜索文字和文件名';

  @override
  String get searchClear => '清除搜索';

  @override
  String searchResultCount(int count) {
    return '找到 $count 条';
  }

  @override
  String searchEmptyTitle(String query) {
    return '没有找到「$query」';
  }

  @override
  String get searchEmptyBody => '搜索的是复制过的文字和文件名。';

  @override
  String get favoriteAction => '收藏';

  @override
  String get unfavoriteAction => '取消收藏';

  @override
  String get favoritedToast => '已收藏';

  @override
  String get unfavoritedToast => '已放回复制记录';

  @override
  String get undo => '撤销';

  @override
  String get favoriteSaving => '正在保存…';

  @override
  String favoritedAt(String date) {
    return '收藏于 $date';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    return '$count 条 · 不会被自动清理 · 最多占用 $size';
  }

  @override
  String get favoritesEmptyTitle => '还没有收藏';

  @override
  String get favoritesEmptyBody => '在复制记录里点星标，就会在这里另存一份。收藏不会被自动清理。';

  @override
  String get favoritesSearchHint => '搜索收藏';

  @override
  String favoriteLargeTitle(String size) {
    return '另存一份 $size 的内容？';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return '收藏会另存一份，原文件之后改动或删除都不影响收藏。这会占用$device上 $size 的空间。';
  }

  @override
  String get saveCopy => '另存';

  @override
  String clearKeepsFavorites(int count) {
    return '已收藏的 $count 条会保留。';
  }

  @override
  String get favoritesUsage => '收藏占用';

  @override
  String get favoritesUsageDesc => '收藏不受上面两项的限制，不会被自动清理';

  @override
  String upToSize(String size) {
    return '最多 $size';
  }

  @override
  String detailChars(int count) {
    return '$count 字';
  }

  @override
  String detailTruncated(int count) {
    return '…… 共 $count 字';
  }

  @override
  String detailMoreFiles(int count) {
    return '还有 $count 个';
  }

  @override
  String get detailReceiveFirst => '选中后先下载';

  @override
  String detailTotalSize(String size) {
    return '共 $size';
  }

  @override
  String get quickPaste => '快捷粘贴';

  @override
  String get quickPasteWindow => '快捷粘贴窗口';

  @override
  String get quickPasteWindowDesc => '在任何程序里按快捷键呼出复制记录，选中即粘贴';

  @override
  String get quickPasteShortcut => '快捷键';

  @override
  String get quickPasteRecord => '点击录制';

  @override
  String get quickPasteRecording => '请按下新的快捷键…';

  @override
  String get quickPasteUseDefault => '恢复默认';

  @override
  String get quickPasteNeedsModifier => '要带上 ⌃、⌥、⇧ 或 ⌘，或者用功能键';

  @override
  String get quickPasteNeedsModifierPc => '要带上 Ctrl、Alt、Shift 或 Win 键，或者用功能键';

  @override
  String get quickPasteAfterPick => '选中后';

  @override
  String get quickPastePasteIt => '直接粘贴';

  @override
  String get quickPasteCopyIt => '只放进剪贴板';

  @override
  String get quickPasteIndexKey => '粘贴前 9 条';

  @override
  String get quickPasteIndexKeyDesc => '在快捷窗口里按住它再按 1–9';

  @override
  String get quickPasteAccessibility => '辅助功能权限';

  @override
  String get quickPasteAccessibilityDesc => '直接粘贴需要它；没有授权时只放进剪贴板，再由你按 ⌘V';

  @override
  String get quickPasteAllowed => '已授权';

  @override
  String get quickPasteAllow => '去授权';

  @override
  String get quickPasteNotRunning => '快捷粘贴窗口没有运行';

  @override
  String quickPasteInUse(String key) {
    return '$key 已被其他程序占用，换一个组合';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return '设置 $key 失败：$detail';
  }

  @override
  String get quickPastePortalKey => '在系统的快捷键设置里修改';

  @override
  String get quickPasteWaylandDesc =>
      'Wayland 下快捷键要加在桌面的键盘设置里；选中后放进剪贴板，再按 Ctrl+V 粘贴';

  @override
  String get quickPasteAddShortcut => '添加系统快捷键';

  @override
  String quickPasteShortcutAdded(String key) {
    return '已添加，按 $key 试试';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return '在桌面的键盘设置里添加一个自定义快捷键，命令填：$command';
  }

  @override
  String get pickerSearch => '搜索';

  @override
  String get pickerPaste => '粘贴';

  @override
  String get pickerPlainText => '纯文本';

  @override
  String get pickerCopyOnly => '只复制';

  @override
  String get pickerUnfavoriteHint => '取消收藏（放回复制记录）';

  @override
  String pickerPasteManually(String key) {
    return '选中后按 $key 粘贴';
  }

  @override
  String get pickerGrantHint => '授予「辅助功能」权限后可直接粘贴';

  @override
  String pickerElevated(String key) {
    return '这个窗口以管理员身份运行，选中后按 $key 粘贴';
  }

  @override
  String get pickerDownloading => '正在下载，下完自动粘贴';

  @override
  String get imagePreviewTitle => '图片预览';

  @override
  String get closePreview => '关闭预览';

  @override
  String get previousImage => '上一张';

  @override
  String get nextImage => '下一张';

  @override
  String get previewHint => '滚轮或触控板缩放，拖动查看';

  @override
  String get fitWindow => '适应窗口';

  @override
  String get previewDeleted => '这条图片记录已被删除';

  @override
  String get previewExpired => '图片已过期，无法预览';

  @override
  String get previewDownloading => '正在下载图片…';

  @override
  String get previewDownloadFailed => '图片下载失败，请重试';

  @override
  String get previewNotDownloaded => '图片尚未下载到这台电脑';

  @override
  String get downloadAndPreview => '下载并预览';

  @override
  String get previewUnavailable => '图片暂时无法预览';

  @override
  String get imageSemantic => '复制记录中的图片';

  @override
  String get previewUnreadable => '无法读取图片，文件可能已被清理或损坏';

  @override
  String get devicesSubtitleEmpty => '配对之后，设备之间就会同步剪贴板';

  @override
  String devicesSubtitle(int paired, int online) {
    return '已配对 $paired 台，$online 台在线';
  }

  @override
  String get addDevice => '添加设备';

  @override
  String thisDeviceFootnote(String both) {
    return '配对时，$both会显示同样的两行安全指纹：这台的和对方的。逐字核对一致才能确认。';
  }

  @override
  String get noDevicesTitle => '还没有配对的设备';

  @override
  String get noDevicesBody =>
      '在另一台电脑上打开隔空贴，用 6 位配对码把两台连起来。两台在同一个网络里时，也可以在两台上都打开「搜索附近设备」，点一下对方。';

  @override
  String get pairedDevices => '已配对的设备';

  @override
  String get pairedFootnote =>
      '直连：数据在两台设备之间直接传输。中转：网络环境打不通直连时，经你的服务器转发，内容依然是端到端加密的。';

  @override
  String get offline => '离线';

  @override
  String get direct => '直连';

  @override
  String get relay => '中转';

  @override
  String get online => '在线';

  @override
  String get moreActions => '更多操作';

  @override
  String get copyFingerprint => '拷贝安全指纹';

  @override
  String get unpairEllipsis => '解除配对…';

  @override
  String get fingerprintCopied => '安全指纹已拷贝';

  @override
  String unpairTitle(String name) {
    return '解除与「$name」的配对？';
  }

  @override
  String get unpairBody => '两台设备将不再同步。以后想恢复，需要重新配对并核对指纹。';

  @override
  String get unpair => '解除配对';

  @override
  String get unpaired => '已解除配对';

  @override
  String get enterAddressEllipsis => '输入它的地址…';

  @override
  String setAddressTitle(String name) {
    return '「$name」的地址';
  }

  @override
  String setAddressBody(String name) {
    return '两台不在同一网段、或者都换了地址时用。输入「$name」上「添加设备 → 生成配对码」下面显示的地址。';
  }

  @override
  String get addressSaved => '已记下，正在那个地址上找它';

  @override
  String get lanBlockedTitle => 'macOS 阻止了局域网访问';

  @override
  String lanBlockedBody(String device) {
    return '在「系统设置 → 隐私与安全性 → 本地网络」里打开 PasteFerry Daemon。打开之前，$device连不上同一网络里的设备。';
  }

  @override
  String get searchNearby => '搜索附近设备';

  @override
  String get nearbyTitle => '附近的设备';

  @override
  String get nearbySearching => '正在查找附近的设备…';

  @override
  String get nearbyHint => '在另一台电脑上也打开「搜索附近设备」，它就会出现在这里，点一下即可配对。';

  @override
  String nearbyVisible(String device) {
    return '窗口打开期间，同一网络里的设备能看到$device的名字。';
  }

  @override
  String get nearbyPaired => '已配对';

  @override
  String nearbyRequesting(String name) {
    return '正在联系「$name」…';
  }

  @override
  String nearbyNoReply(String name) {
    return '「$name」没有回应。确认它还开着「搜索附近设备」。';
  }

  @override
  String get nearbyLanOffTitle => '局域网发现已关闭';

  @override
  String get nearbyLanOffBody => '在「设置 → 连接」里打开「在局域网中查找设备」才能看到附近的设备，或者改用配对码。';

  @override
  String get generateCode => '生成配对码';

  @override
  String get enterCode => '输入配对码';

  @override
  String get codeFailedTitle => '没能生成配对码';

  @override
  String get enterOnOther => '在另一台设备上输入这个配对码';

  @override
  String get codeCopied => '配对码已拷贝';

  @override
  String get codeHint => '点击可拷贝，5 分钟内有效';

  @override
  String afterEnterFootnote(String both) {
    return '对方输入后，$both会显示同样的两行安全指纹，核对一致再确认。';
  }

  @override
  String get codeInvalid => '配对码是 6 位字母或数字';

  @override
  String get localAddress => '本机地址';

  @override
  String get addressHint => '不在同一网段时，另一台还要输入这个地址';

  @override
  String get addressCopied => '地址已拷贝';

  @override
  String get differentSubnet => '不在同一网段？';

  @override
  String get peerAddress => '对方配对码下面显示的地址';

  @override
  String get pairNotFound => '没找到那台设备。不在同一网段时，请输入它配对码下面显示的地址。';

  @override
  String get pairNotFoundAddress =>
      '那个地址上没有回应。检查地址是否正确、对方是否还停在配对码页面；对方的防火墙也可能拦住了。';

  @override
  String get codeWrong => '配对码不对，或者已经失效';

  @override
  String get codeExpired => '配对码已失效，请在另一台上重新生成';

  @override
  String get addressInvalid => '地址格式不对，应当像 192.168.1.20 这样';

  @override
  String get pairNoChannel => '请先在「设置 → 连接」里开启局域网发现，或者填写服务器地址。';

  @override
  String get enterCodeShown => '输入另一台设备上显示的配对码';

  @override
  String get pairingDone => '配对完成';

  @override
  String get pairingRejected => '已拒绝配对';

  @override
  String get verifyTitle => '核对安全指纹';

  @override
  String pairingWith(String name) {
    return '正在与「$name」配对';
  }

  @override
  String verifyBody(String both) {
    return '$both上显示的这两行应当完全相同。有任何一个字符不同，说明连接可能被第三方篡改，请拒绝。';
  }

  @override
  String get rejectMismatch => '不一致，拒绝';

  @override
  String get confirmMatch => '一致，确认配对';

  @override
  String get server => '服务器（可选）';

  @override
  String get signalingUrl => '信令服务器地址';

  @override
  String get signalingUrlDesc => '留空仅在局域网同步';

  @override
  String get signalingUrlPlaceholder => 'ws://服务器地址:8787/signal';

  @override
  String get publicStun => '增强公网直连';

  @override
  String get publicStunDesc => '公共服务器可见本机公网 IP';

  @override
  String get connectionStatus => '连接状态';

  @override
  String get disconnectedDesc => '请检查地址与服务器状态';

  @override
  String get connected => '已连接';

  @override
  String get notConnected => '未连接';

  @override
  String get notSet => '未设置';

  @override
  String get serverCleared => '已清除服务器地址，只在局域网里同步';

  @override
  String get localNetwork => '局域网';

  @override
  String get lanDiscovery => '在局域网中查找设备';

  @override
  String get lanDiscoveryDesc => '匿名发现，仅搜索附近设备时显示名称';

  @override
  String get macLocalNetwork => '本地网络权限';

  @override
  String get macLocalNetworkDesc => '在系统设置中允许 PasteFerry Daemon';

  @override
  String get allowLan => 'Windows 防火墙';

  @override
  String get allowLanDesc => '连接受阻时放行，需管理员权限';

  @override
  String get allow => '放行';

  @override
  String get allowLanDone => '已放行，其他设备现在可以连到这台了';

  @override
  String get deviceName => '设备名称';

  @override
  String get language => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get sync => '同步';

  @override
  String get autoSyncLimit => '自动同步上限';

  @override
  String get autoSyncLimitDesc => '超出上限后，在复制记录中手动接收';

  @override
  String get autoApply => '收到后直接写入剪贴板';

  @override
  String get whatToSync => '同步哪些内容';

  @override
  String get syncFiles => '文件与文件夹';

  @override
  String get syncText => '纯文本';

  @override
  String get syncRich => '带格式的文本';

  @override
  String get syncImages => '图片与截图';

  @override
  String get storage => '存储';

  @override
  String get storageFootnote => '到期自动清理记录与缓存。';

  @override
  String get keepHistory => '记录保留';

  @override
  String get keepCache => '缓存文件保留';

  @override
  String get keepCacheDesc => '不超过记录保留时长';

  @override
  String get cacheUsage => '缓存占用';

  @override
  String get backgroundSync => '后台同步';

  @override
  String get backgroundService => '后台服务';

  @override
  String get backgroundServiceDesc => '登录自启，关闭窗口后继续同步';

  @override
  String get restart => '重新启动';

  @override
  String get restarted => '后台服务已重新启动';

  @override
  String get disableEllipsis => '停用…';

  @override
  String get about => '关于';

  @override
  String get aboutDesc => '开源软件，AGPL-3.0 许可';

  @override
  String get homepage => '项目主页';

  @override
  String get feedback => '反馈问题';

  @override
  String get disableTitle => '停用后台同步？';

  @override
  String disableBody(String device) {
    return '$device将停止同步，也不再开机启动。历史记录和配对关系会保留。';
  }

  @override
  String get disable => '停用';

  @override
  String get disabled => '后台同步已停用';

  @override
  String get urlMustBeWs => '地址需以 ws:// 或 wss:// 开头';

  @override
  String get serverUpdated => '服务器地址已更新，正在重连';

  @override
  String get deviceNameUpdated => '设备名称已更新';

  @override
  String get diagIntro =>
      '报告里有版本、系统、设置、设备状态和最近的日志。设备名、服务器地址、公网 IP、用户目录和文件名都已替换，复制的内容从不写进日志。GitHub 上的问题是公开的，贴出去之前请看一遍。';

  @override
  String get diagVerboseTitle => '详细日志';

  @override
  String get diagVerboseDesc => '连接方面的问题常要看它：打开后重现一次问题，再回来生成报告。30 分钟后自动关闭。';

  @override
  String get diagVerboseOn => '打开 30 分钟';

  @override
  String diagVerboseUntil(String time) {
    return '已打开，$time 自动关闭';
  }

  @override
  String get diagVerboseOff => '关闭';

  @override
  String get diagRefresh => '重新生成';

  @override
  String get diagSave => '保存为文件';

  @override
  String diagSaved(String name) {
    return '已保存到「下载」文件夹：$name';
  }

  @override
  String get diagCopy => '拷贝报告';

  @override
  String get diagCopied => '报告已拷贝';

  @override
  String get diagNewIssue => '在 GitHub 上提问题';

  @override
  String get diagIssueHint => '报告已拷贝，粘贴到问题里的「诊断报告」一栏';

  @override
  String diagFailed(String detail) {
    return '生成报告失败：$detail';
  }

  @override
  String get svcExtractTitle => '先解压或安装隔空贴';

  @override
  String get svcExtractBody =>
      '隔空贴现在是直接从压缩包里打开的，关掉之后它所在的临时文件夹就会被删除。运行安装程序，或者把整个文件夹解压出来再打开，就可以启用后台同步。';

  @override
  String get svcMoveTitle => '先把隔空贴移到「应用程序」';

  @override
  String get svcMoveBody =>
      '隔空贴现在是直接从安装盘里打开的。把它拖进「应用程序」文件夹，推出安装盘，再从「应用程序」里打开，就可以启用后台同步。';

  @override
  String get svcStartTitle => '开始使用隔空贴';

  @override
  String get svcStartBody => '隔空贴通过后台进程同步剪贴板，关闭窗口后仍会运行。开机启动可在设置里单独选择，新安装默认关闭。';

  @override
  String get svcEnable => '启用后台同步';

  @override
  String get svcStaleTitle => '重新启用后台同步';

  @override
  String get svcStaleBodyWin =>
      '隔空贴换了位置，开机自启还指向原来的地方。重新启用一次，让后台进程指向当前这份隔空贴。历史记录与配对关系都会保留。';

  @override
  String get svcStaleBodyMac =>
      '隔空贴换了位置，或者之前用旧版安装脚本装过。重新启用一次，让后台进程指向当前这个 App。历史记录与配对关系都会保留。';

  @override
  String get svcReenable => '重新启用';

  @override
  String get svcStoppedTitle => '后台服务没有运行';

  @override
  String get svcStoppedBody => '后台服务已停止。点下面的按钮启动；是否开机启动可在设置里单独选择。';

  @override
  String get svcDevBodyWin =>
      '这是开发构建，旁边没有 pasteferryd.exe。在源码目录运行 scripts\\build-windows.ps1 构建完整的版本。';

  @override
  String get svcDevBodyLinux =>
      '这是开发构建，旁边没有 pasteferryd。在源码目录运行 ./scripts/package-linux.sh 构建完整的版本。';

  @override
  String get svcDevBodyMac =>
      '这是开发构建，App 里没有内置后台服务。在源码目录运行 ./scripts/install-macos.sh 安装它。';

  @override
  String svcLogPath(String path) {
    return '运行日志：$path';
  }

  @override
  String get svcCanDisable => '随时可以在「设置」中停用后台同步。';

  @override
  String get officialService => '服务';

  @override
  String get useOfficialService => '使用服务';

  @override
  String get officialServiceDesc => '跨网络同步，优先直连';

  @override
  String get officialPrivacy =>
      '仅开启后连接服务并记录必要的接入信息。先尝试直连，失败才申请中转；不上传内容、真实设备名或原始系统标识。';

  @override
  String get officialEnableTitle => '启用服务？';

  @override
  String get officialSwitchConfirm => '这会切换当前自定义服务器，已保存的地址仍会保留。';

  @override
  String get customServer => '自定义服务器';

  @override
  String get saveAndConnect => '保存并连接';

  @override
  String get officialLoading => '正在获取额度…';

  @override
  String get officialFetchFailed => '暂时获取不到额度，会自动重试。';

  @override
  String get officialUnavailable => '用量暂不可用，已有数据可能过期';

  @override
  String get officialQuotaTitle => '今日中转额度已用完';

  @override
  String get officialQuotaBody => '服务中转已暂停，北京时间零点重置。局域网和公网直连仍可使用；传输失败时可稍后重试。';

  @override
  String get officialPeerQuota => '对端中转额度不足，直连仍可使用';

  @override
  String get officialPaused => '服务中转暂不可用，直连仍可使用';

  @override
  String get officialViewUsage => '查看用量';

  @override
  String get officialAcknowledge => '知道了';

  @override
  String get officialToday => '今日中转额度';

  @override
  String get officialUsed => '已使用';

  @override
  String get officialRemaining => '剩余额度';

  @override
  String get officialDailyLimit => '每日额度';

  @override
  String get officialUpload => '上传';

  @override
  String get officialDownload => '下载';

  @override
  String get officialReset => '重置时间（北京时间）';

  @override
  String get officialUpdated => '最后更新';

  @override
  String get officialRoutes => '设备连接方式';

  @override
  String get officialRoutesFootnote => '直连时不经过服务中转，也不消耗额度。';

  @override
  String get officialDeviceID => '设备 ID';

  @override
  String get officialWarning => '今日中转额度已使用 90%，直连不消耗此额度。';

  @override
  String get updateCheck => '检查更新';

  @override
  String get updateCheckEllipsis => '检查更新…';

  @override
  String get updateAuto => '自动检查更新';

  @override
  String get updateChecking => '正在检查更新…';

  @override
  String updateUpToDate(String version) {
    return '隔空贴 $version 已是最新版本。';
  }

  @override
  String updateAvailableTitle(String version) {
    return '有新版本：隔空贴 $version';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return '当前版本 $current，需要下载 $size。';
  }

  @override
  String get updateNew => '新增';

  @override
  String get updateFixed => '修复';

  @override
  String get updateSkip => '跳过这个版本';

  @override
  String get updateLater => '以后再说';

  @override
  String get updateInstall => '下载并安装';

  @override
  String updateDownloading(String done, String total) {
    return '正在下载 $done / $total';
  }

  @override
  String get updateVerifying => '正在校验下载的文件…';

  @override
  String get updateInstalling => '正在安装，隔空贴会自动重新打开。';

  @override
  String get updateInstallingPassword =>
      '正在安装。安装到 /opt 需要管理员权限，系统会请你输入密码，之后隔空贴会自动重新打开。';

  @override
  String get updateCheckFailed => '暂时连不上 GitHub 和 Gitee，请稍后再试。';

  @override
  String get updateDownloadFailed => '下载没有完成。可以重试，或者到下载页手动下载新版本。';

  @override
  String updateInstallFailed(String error) {
    return '没能开始安装：$error';
  }

  @override
  String get updateUnsupportedBuild => '这个版本不支持检查更新。';

  @override
  String get updateBlockedDev => '这是开发构建，不能自动更新。';

  @override
  String get updateBlockedMustMove =>
      '隔空贴是直接从磁盘映像里打开的。把它拖到「应用程序」文件夹、从那里打开后，就能自动更新。';

  @override
  String get updateBlockedReadOnly => '隔空贴所在的文件夹不能写入，没法自动更新。请到下载页手动下载新版本。';

  @override
  String get updateBlockedUnsupported => '这台电脑没有可用的自动更新安装包，请到下载页手动下载新版本。';

  @override
  String get updateOpenDownload => '打开下载页';

  @override
  String updateSidebar(String version) {
    return '新版本 $version 可用';
  }

  @override
  String updatedTo(String version) {
    return '已更新到 $version';
  }

  @override
  String updateNotFinished(String version) {
    return '更新没有完成，仍是 $version。';
  }

  @override
  String updateNotFinishedWhy(String version, String detail) {
    return '更新没有完成，仍是 $version。$detail';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return '界面 $uiVersion · 后台 $serviceVersion · 构建 $build';
  }

  @override
  String get notReceived => '尚未接收，暂不可粘贴';

  @override
  String get receivedPreserved => '已接收，点击放入剪贴板后可粘贴';

  @override
  String get clipboardWriteFailed => '已接收，但未能写入剪贴板';

  @override
  String get receivingStatus => '正在接收…';

  @override
  String get largeFileNotifications => '大文件接收提醒';

  @override
  String get notificationsAllowed => '已允许系统通知，接收进度在复制记录中查看。';

  @override
  String get notificationsNotRequested => '开启系统通知，避免大文件等待接收时没有提示；也可随时从复制记录接收。';

  @override
  String get notificationsDenied => '系统通知已关闭，请在系统设置中开启；待接收内容仍可从复制记录接收。';

  @override
  String get notificationsUnknown => '通知显示和勿扰由系统控制；未看到提醒时，可在复制记录中接收。';

  @override
  String get notificationsUnavailable => '系统通知暂不可用，请从复制记录接收大文件。';

  @override
  String get enableNotifications => '开启提醒';

  @override
  String get notificationSettings => '通知设置';

  @override
  String get notifyPendingTitle => '接收后即可粘贴';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\n尚未接收，暂不可粘贴。也可从复制记录接收。';
  }

  @override
  String get notifyReceivingTitle => '正在接收…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\n可在复制记录查看接收进度。';
  }

  @override
  String get notifyReadyTitle => '已就绪，可以粘贴';

  @override
  String notifyReadyBody(String name) {
    return '$name\n已接收并放入剪贴板。';
  }

  @override
  String get notifyReceivedTitle => '已接收';

  @override
  String notifyReceivedBody(String name) {
    return '$name\n已保留当前剪贴板，点击放入剪贴板后可粘贴，也可从复制记录操作。';
  }

  @override
  String get notifyFailedTitle => '接收失败';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\n可从此通知或复制记录重试。';
  }

  @override
  String get notifyClipboardFailedTitle => '已接收，但未能写入剪贴板';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\n可从此通知或复制记录重新放入剪贴板。';
  }

  @override
  String get reconnect => '重新连接';

  @override
  String get reconnecting => '正在连接…';

  @override
  String get reconnectDirect => '已直连';

  @override
  String get reconnectRelay => '直连没打通，继续经中转';

  @override
  String reconnectOffline(String name) {
    return '「$name」不在线，请确认它那边已打开隔空贴';
  }

  @override
  String get reconnectPending => '还在连接，稍后再看';

  @override
  String get renameAction => '重命名';

  @override
  String get renameFavoriteTitle => '重命名收藏';

  @override
  String get renameFavoriteHint => '收藏和快捷粘贴里显示这个名字，搜索也能找到它。留空则恢复显示内容。';

  @override
  String get renamedToast => '已重命名';

  @override
  String get aliasClearedToast => '已恢复显示内容';

  @override
  String get navSend => '隔空传送';

  @override
  String get sendSubtitle => '把文件拖到一台设备上，直接发过去';

  @override
  String get sendNoDevicesTitle => '还没有配对的设备';

  @override
  String get sendNoDevicesBody => '先配对另一台电脑，之后就能在这里给它发文件。';

  @override
  String get sendDropHint => '拖到一台设备上发送';

  @override
  String sendReleaseTo(String name) {
    return '松手发送到 $name';
  }

  @override
  String get sendLan => '局域网';

  @override
  String sendRelayLeft(String left) {
    return '中转 · 今日剩 $left';
  }

  @override
  String get sendNeedsUpdate => '需要更新';

  @override
  String sendNeedsUpdateTip(String name) {
    return '$name 更新到隔空贴 2.5 或更高版本后才能接收文件。';
  }

  @override
  String sendConnectingTip(String name) {
    return '正在连接 $name，连上后就能发送。';
  }

  @override
  String get sendNotReceiving => '不接收文件';

  @override
  String get sendDelivered => '已送达';

  @override
  String sendToTitle(String name) {
    return '发送到 $name';
  }

  @override
  String get sendDropHere => '把文件或文件夹拖到这里';

  @override
  String get sendDropStarts => '松手就开始发送';

  @override
  String get sendChooseFiles => '选择文件…';

  @override
  String get sendChooseFolder => '选择文件夹…';

  @override
  String get sendDropMore => '继续拖入文件，排在后面发送';

  @override
  String sendSavedWhere(String name) {
    return '文件存到 $name 设置的位置，默认是「下载」文件夹。';
  }

  @override
  String get sendCloseKeeps => '关闭窗口不影响发送';

  @override
  String get sendRemoveQueued => '移除';

  @override
  String get sendCannotDrop => '这个项目不能直接拖过来发送。请先把它存成文件，或者用「选择文件…」。';

  @override
  String sendErrOffline(String name) {
    return '$name 不在线。';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name 关闭了接收文件。';
  }

  @override
  String get sendErrMissing => '有文件已经不在了。';

  @override
  String get relayConfirmTitle => '经服务中转发送？';

  @override
  String relayConfirmBody(String name, String left) {
    return '$name 现在和这台电脑没有直连，文件要经服务中转，速度约 0.25 MB/s。今天的中转额度还剩 $left。';
  }

  @override
  String relayConfirmOver(String size) {
    return '这些文件（$size）超出了今天剩余的额度。发到额度用完时会暂停；两台电脑连上直连、或明天额度恢复后，自动继续。';
  }

  @override
  String relayConfirmWithin(String size) {
    return '这次大约用掉今天额度中的 $size。';
  }

  @override
  String get relayExhausted => '今天的中转额度已用完，北京时间 0 点恢复。两台电脑连上直连后不受限制。';

  @override
  String get relayDontAskToday => '今天发给这台设备时不再询问';

  @override
  String get relaySendAnyway => '仍然发送';

  @override
  String get relayOwnServer => '中转，速度取决于你的服务器带宽';

  @override
  String get transfersReceived => '收到的';

  @override
  String get transfersSent => '发出的';

  @override
  String get transfersClearAll => '全部清除';

  @override
  String get transfersClearTitle => '清除这个列表？';

  @override
  String get transfersClearBody => '只清除记录，文件不会被删除。';

  @override
  String get transfersEmptyReceived => '其他设备发来的文件会出现在这里';

  @override
  String get transfersEmptySent => '你发出的文件会出现在这里';

  @override
  String transferFrom(String name) {
    return '来自 $name';
  }

  @override
  String transferTo(String name) {
    return '发给 $name';
  }

  @override
  String transferItems(String name, int total, int others) {
    return '$name 等 $total 项';
  }

  @override
  String transferFileCount(int count) {
    return '$count 个文件';
  }

  @override
  String get transferQueued => '排队中';

  @override
  String transferScanning(String count) {
    return '正在统计… 已找到 $count 个文件';
  }

  @override
  String transferWaitingPeer(String name) {
    return '正在联系 $name…';
  }

  @override
  String get transferSending => '正在发送';

  @override
  String get transferReceiving => '正在接收';

  @override
  String transferCurrent(String file, String index, String total) {
    return '正在传：$file（第 $index / $total 个）';
  }

  @override
  String transferLeft(String time) {
    return '还剩 $time';
  }

  @override
  String etaSeconds(int n) {
    return '$n 秒';
  }

  @override
  String etaMinutes(int n) {
    return '$n 分钟';
  }

  @override
  String etaHours(int h, int m) {
    return '$h 小时 $m 分';
  }

  @override
  String get transferPaused => '已暂停：今天的中转额度用完了';

  @override
  String get transferInterrupted => '已中断，重新连上后继续';

  @override
  String transferInterruptedIncoming(String name) {
    return '已中断 · 等 $name 继续';
  }

  @override
  String get transferCancelled => '已取消';

  @override
  String transferPeerCancelled(String name) {
    return '$name 取消了';
  }

  @override
  String get transferExpired => '已过期';

  @override
  String get transferMissing => '已移动或删除';

  @override
  String transferNotSent(String reason) {
    return '没有发出：$reason';
  }

  @override
  String transferNotReceived(String reason) {
    return '没有收下：$reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return '$name 的磁盘空间不足，还差 $size';
  }

  @override
  String reasonNoSpace(String size) {
    return '磁盘空间不足，还差 $size';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return '$name 的保存位置不可用';
  }

  @override
  String get reasonDestUnavailable => '保存位置不可用，请在设置里检查';

  @override
  String get reasonFileTooLarge => '保存位置在 FAT32 格式的盘上，放不下超过 4 GB 的文件';

  @override
  String reasonDisabledPeer(String name) {
    return '$name 关闭了接收文件';
  }

  @override
  String get reasonSourceChanged => '发送过程中有文件被修改了';

  @override
  String get reasonSourceMissing => '有文件已经不在了';

  @override
  String get reasonReadError => '有文件读取失败';

  @override
  String get reasonWriteFailed => '文件写入失败';

  @override
  String get reasonHashMismatch => '有文件在传输中损坏了';

  @override
  String reasonUnsupported(String name) {
    return '$name 需要更新才能接收文件';
  }

  @override
  String get reasonOther => '出了点问题';

  @override
  String get revealInFinder => '在访达中显示';

  @override
  String get revealInFolder => '在文件夹中显示';

  @override
  String get revealOpenFolder => '打开文件夹';

  @override
  String get transferResend => '重新发送';

  @override
  String get transferRemove => '从列表中移除';

  @override
  String get transferCopyPath => '拷贝路径';

  @override
  String get transferPathCopied => '已拷贝路径';

  @override
  String sendingTo(String name, String percent) {
    return '正在发给 $name · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return '正在接收 $name 的文件 · $percent';
  }

  @override
  String get receiveFiles => '接收其他设备发来的文件';

  @override
  String get saveTo => '保存到';

  @override
  String get saveToChange => '更改…';

  @override
  String get saveToDefault => '下载（默认）';

  @override
  String get saveToUseDefault => '改回「下载」';

  @override
  String get receiveNotify => '收到文件时通知';

  @override
  String receiveFootnote(String device) {
    return '只有已配对的设备能给$device发文件。传输期间$device不会自动睡眠。';
  }

  @override
  String get saveDirNotFound => '这个文件夹不存在。';

  @override
  String get saveDirNotWritable => '隔空贴不能把文件存到这个文件夹。';

  @override
  String get saveDirPermission =>
      '隔空贴还没有使用这个文件夹的权限。请在「系统设置 → 隐私与安全性 → 文件与文件夹」里允许。';

  @override
  String transferRenamed(int count) {
    return '$count 个文件名含 Windows 不支持的字符，已换成相近的全角字符';
  }

  @override
  String get sendRingLan => '同一网络';

  @override
  String get sendRingOther => '其他网络';

  @override
  String sendOfflineList(String names) {
    return '离线：$names';
  }

  @override
  String get listSeparator => '、';

  @override
  String get sendLayout => '传输列表';

  @override
  String get sendLayoutSide => '在雷达右边';

  @override
  String get sendLayoutBelow => '在雷达下面';

  @override
  String get general => '通用';

  @override
  String get launchAtLogin => '开机启动';

  @override
  String get launchAtLoginDesc => '登录电脑后在后台启动，不弹出主窗口。修改此项不会停止当前运行。';

  @override
  String get realtimeSync => '实时同步剪贴板';

  @override
  String get realtimeSyncDesc => '自动与配对设备同步新复制的内容。关闭后仍保存本机记录，也可手动隔空传送。';

  @override
  String get syncBacklog => '重连后补发离线内容';

  @override
  String get syncBacklogDesc =>
      '默认关闭：离线期间未送达的内容不再补发。开启后最多补发 24 小时内的 20 条记录，不覆盖当前剪贴板。';

  @override
  String get peerRealtimeSync => '与这台电脑实时同步';

  @override
  String get syncPaused => '剪贴板同步已暂停';

  @override
  String get quitApp => '退出隔空贴';

  @override
  String get quitAppDesc => '结束隔空贴的全部进程，保留开机启动设置。';

  @override
  String get quitTransfersWarning => '还有文件正在传输，是否中断传输并退出？';

  @override
  String get backgroundRunningTitle => '隔空贴将继续在后台运行';

  @override
  String get backgroundRunningBody =>
      '关闭窗口后，同步和快捷粘贴仍会运行。如需完全停止，请在设置或应用菜单选择「退出隔空贴」。';

  @override
  String get displayAs => '显示为';

  @override
  String get editName => '修改名字';

  @override
  String get nameHint => '好友看到的名字';

  @override
  String get nameDefaultHint => '留空则用系统的用户名。';

  @override
  String get avatarTitle => '设置头像';

  @override
  String get avatarChoose => '选择图片…';

  @override
  String get avatarPaste => '粘贴图片';

  @override
  String get avatarReset => '恢复默认头像';

  @override
  String get avatarZoom => '缩放';

  @override
  String get avatarDragHint => '拖动可以移动图片。';

  @override
  String get avatarNoImage => '剪贴板里没有图片。';

  @override
  String get avatarBad => '这张图片用不了，请换一张 PNG、JPEG 或 GIF。';

  @override
  String get done => '完成';

  @override
  String get friendsTitle => '好友';

  @override
  String get addFriend => '添加好友';

  @override
  String get friendsEmpty => '还没有好友';

  @override
  String get friendsEmptyBody => '加了好友，就能互相发文件，不用配对。好友只能发文件，看不到你的剪贴板。';

  @override
  String get friendSendAction => '发送…';

  @override
  String get friendHistory => '传输记录';

  @override
  String friendHistoryTitle(String name) {
    return '和 $name 的传输';
  }

  @override
  String get friendHistoryEmpty => '还没有传过文件。';

  @override
  String get friendAutoAccept => '自动接收此好友的文件';

  @override
  String get friendRemove => '删除好友';

  @override
  String friendRemoveTitle(String name) {
    return '删除好友「$name」？';
  }

  @override
  String get friendRemoveBody => '双方都会删除对方，之后互相发不了文件。以前的传输记录仍留在这台电脑上。';

  @override
  String friendLastActivity(String time) {
    return '$time传过';
  }

  @override
  String get friendNoActivity => '还没传过文件';

  @override
  String get friendCodeShare => '把这个码发给好友，对方在隔空贴里输入后，你们就成为好友。';

  @override
  String friendCodeExpires(String time) {
    return '$time 后失效';
  }

  @override
  String get friendCodeOr => '或者';

  @override
  String get friendCodeEnter => '输入对方的好友码';

  @override
  String get friendCodeAdd => '添加';

  @override
  String get friendCodeWaiting => '等待对方输入…';

  @override
  String friendConfirmBody(String name) {
    return '添加 $name 为好友？';
  }

  @override
  String get friendSafetyCode => '核对安全码（可选）';

  @override
  String get friendSafetyHint => '面对面时可以核对：两边显示的这两行一样，就没有被人调包。';

  @override
  String get friendWaitingPeer => '等待对方添加…';

  @override
  String friendAdded(String name) {
    return '已添加 $name 为好友';
  }

  @override
  String friendPeerCancelled(String name) {
    return '$name 取消了';
  }

  @override
  String get friendErrFriendCode => '这是好友码，请在隔空传送页的「添加好友」里输入。';

  @override
  String get friendErrDeviceCode => '这是配对码，请在「设备 → 添加设备」里输入。';

  @override
  String get friendErrOutdated => '对方需要更新到隔空贴 2.6.0 或更高版本。';

  @override
  String get friendErrAlreadyPaired => '这台电脑已经是你的设备。';

  @override
  String get friendErrNoChannel => '你们不在同一个局域网，双方都打开「服务」后才能添加。';

  @override
  String get openService => '打开服务…';

  @override
  String get noteLabel => '备注（可选）';

  @override
  String get noteHintEmpty => '先选择要发送的文件';

  @override
  String get noteHint => '比如：合同第 3 页要签字';

  @override
  String noteLine(String note) {
    return '备注：$note';
  }

  @override
  String get sendAction => '发送';

  @override
  String sendItemsSummary(String count, String size) {
    return '共 $count 项 · $size';
  }

  @override
  String sendDropOrPaste(String key) {
    return '把文件或图片拖到这里，或粘贴（$key）';
  }

  @override
  String get sendDropMorePaste => '继续拖入或粘贴';

  @override
  String get sendPasteNothing => '剪贴板里没有文件或图片。';

  @override
  String get sendRemoveItem => '移除';

  @override
  String sendFriendSaved(String name) {
    return '对方点「接受」后才开始发送。';
  }

  @override
  String transferAskingOut(String name) {
    return '等待 $name 接受…';
  }

  @override
  String get transferAskingIn => '等你接受';

  @override
  String reasonDeclined(String name) {
    return '$name 拒绝了';
  }

  @override
  String reasonTimeout(String name) {
    return '$name 没有回应';
  }

  @override
  String reasonNotAllowed(String name) {
    return '$name 不接收文件';
  }

  @override
  String reasonRateLimited(String name) {
    return '$name 暂时不接收你的文件';
  }

  @override
  String get reasonYouDeclined => '已拒绝';

  @override
  String get reasonYouIgnored => '已忽略';

  @override
  String get sendAgain => '再发一次';

  @override
  String incomingTitle(String name) {
    return '$name 想发给你文件';
  }

  @override
  String get incomingAlways => '以后自动接收此好友的文件';

  @override
  String get incomingDecline => '拒绝';

  @override
  String get incomingAccept => '接受';

  @override
  String incomingCountdown(String seconds) {
    return '$seconds 秒后自动拒绝';
  }

  @override
  String get incomingStranger => '附近的设备';

  @override
  String get friendsStrip => '好友';

  @override
  String get strangersStrip => '附近开着「所有人」的设备';

  @override
  String get strangerNearby => '附近';

  @override
  String get friendNeedService => '需要打开服务';

  @override
  String get friendCantReach => '无法连接';

  @override
  String reachSelfNoService(String name) {
    return '你和 $name 不在同一个局域网。打开服务后就能给对方发文件，直连不了时经服务中转。';
  }

  @override
  String reachPeerNoService(String name) {
    return '$name 没有打开服务，不在同一个局域网时发不了。请对方在隔空贴里打开服务。';
  }

  @override
  String get reachDifferentServer => '你们用的不是同一台服务器。双方都打开服务，或者改用同一台服务器后就能发。';

  @override
  String get receiveFromLabel => '允许这些人给我发文件：';

  @override
  String get receiveFromOff => '均不允许';

  @override
  String get receiveFromFriends => '仅限好友';

  @override
  String get receiveFromEveryone => '所有人';

  @override
  String everyoneLeft(String minutes) {
    return '所有人 · 还剩 $minutes 分钟';
  }

  @override
  String get receiveFromOffDesc => '只有你配对的电脑能发。';

  @override
  String get receiveFromFriendsDesc => '好友能发，每次由你接受。';

  @override
  String get receiveFromEveryoneDesc => '同一局域网里的人都能发，每次由你接受；10 分钟后改回「仅限好友」。';

  @override
  String get everyoneEnded => '「所有人」已结束，改回「仅限好友」。';

  @override
  String get friendsCountTooltip => '好友';

  @override
  String get waitingAccept => '等待接受';

  @override
  String get settingsConnection => '连接';

  @override
  String get settingsGeneralSummary => '开机启动、设备名称、语言';

  @override
  String get settingsConnectionSummary => '服务、自建服务器、局域网';

  @override
  String get settingsSyncSummary => '实时同步、自动同步上限、同步哪些内容';

  @override
  String get settingsQuickPasteSummary => '快捷键、选中后的操作';

  @override
  String get settingsSendSummary => '接收文件、保存位置';

  @override
  String get settingsStorageSummary => '记录保留多久、占用空间';

  @override
  String get settingsAboutSummary => '版本、更新、反馈';

  @override
  String get friendsSubtitle => '给别人的电脑发文件，不用配对';

  @override
  String get friendsSearch => '搜索好友';

  @override
  String get friendsNoMatch => '没有找到这个好友';

  @override
  String get friendsPick => '选一个好友，查看传输记录或发文件';

  @override
  String friendDropHint(String name) {
    return '松开即可发给 $name';
  }
}

/// The translations for Chinese, as used in Hong Kong, using the Han script (`zh_Hant_HK`).
class AppLocalizationsZhHantHk extends AppLocalizationsZh {
  AppLocalizationsZhHantHk() : super('zh_Hant_HK');

  @override
  String get appName => '隔空貼';

  @override
  String get navHistory => '複製記錄';

  @override
  String get navDevices => '裝置';

  @override
  String get navSettings => '設定';

  @override
  String get navFavorites => '收藏';

  @override
  String get linkConnecting => '正在連線…';

  @override
  String get linkServiceNotRunning => '背景服務未在執行';

  @override
  String get linkLanMode => '在區域網絡中尋找裝置';

  @override
  String get linkServerUnreachable => '連不上伺服器，區域網絡內照常同步';

  @override
  String get linkNothingOn => '區域網絡發現已關閉，也沒有設定伺服器';

  @override
  String get linkLanBlocked => 'macOS 阻擋了區域網絡存取';

  @override
  String linkOnlinePeers(int count) {
    return '$count 部裝置在線';
  }

  @override
  String get linkServerConnected => '已連線到伺服器';

  @override
  String linkConnectionLost(String detail) {
    return '連線中斷：$detail';
  }

  @override
  String get linkServiceDisconnected => '背景服務已中斷連線';

  @override
  String get linkServiceDisabled => '背景服務已停用';

  @override
  String get errServiceNotConnected => '未連線到背景服務';

  @override
  String get errUnimplemented => '這項功能仍未提供';

  @override
  String get errUnavailable => '無法連線到背景服務';

  @override
  String errServiceStart(String detail) {
    return '無法啟動背景服務：$detail';
  }

  @override
  String errServiceRestart(String detail) {
    return '無法重新啟動背景服務：$detail';
  }

  @override
  String errAutostart(String detail) {
    return '無法設定開機自動啟動：$detail';
  }

  @override
  String get thisMacTitle => '這部 Mac';

  @override
  String get thisPcTitle => '這部電腦';

  @override
  String get thisMacInText => '這部 Mac ';

  @override
  String get thisPcInText => '這部電腦';

  @override
  String get bothMacs => '兩部 Mac ';

  @override
  String get bothDevices => '兩部裝置';

  @override
  String get thisDeviceShort => '本機';

  @override
  String fromDevice(String name) {
    return '來自 $name';
  }

  @override
  String get cancel => '取消';

  @override
  String get close => '關閉';

  @override
  String get save => '儲存';

  @override
  String get retry => '重試';

  @override
  String get continueAction => '繼續';

  @override
  String get justNow => '剛剛';

  @override
  String secondsAgo(int n) {
    return '$n 秒前';
  }

  @override
  String minutesAgo(int n) {
    return '$n 分鐘前';
  }

  @override
  String hoursAgo(int n) {
    return '$n 小時前';
  }

  @override
  String daysAgo(int n) {
    return '$n 天前';
  }

  @override
  String monthDay(int month, int day) {
    return '$month月$day日';
  }

  @override
  String durationHours(int n) {
    return '$n 小時';
  }

  @override
  String durationDays(int n) {
    return '$n 天';
  }

  @override
  String get historyEmptySubtitle => '在任何一部裝置上複製，內容會出現在這裏';

  @override
  String historyCount(int count) {
    return '共 $count 條';
  }

  @override
  String historyCountKept(int count, String ttl) {
    return '共 $count 條，保留 $ttl';
  }

  @override
  String get filterAll => '全部';

  @override
  String get filterText => '文字';

  @override
  String get filterImage => '圖片';

  @override
  String get filterFile => '檔案';

  @override
  String get filterLink => '連結';

  @override
  String get historyClearTooltip => '清除記錄';

  @override
  String get historyEmptyTitle => '仍未有記錄';

  @override
  String get historyEmptyFilteredTitle => '沒有這一類的記錄';

  @override
  String get historyEmptyBody => '在任何一部已配對的裝置上複製文字、圖片或檔案，記錄會出現在這裏。';

  @override
  String get clearConfirmTitle => '清除全部記錄？';

  @override
  String clearConfirmBody(String device) {
    return '所有裝置同步過來的記錄和已快取的檔案都會從$device上刪除。原始檔案不受影響。';
  }

  @override
  String get clear => '清除';

  @override
  String get historyCleared => '記錄已清除';

  @override
  String get permDeniedTitle => '已禁止隔空貼讀取剪貼簿';

  @override
  String get permAskTitle => '允許隔空貼讀取剪貼簿';

  @override
  String get permDeniedBody =>
      '在這部 Mac 上複製的內容不會同步出去。請到系統設定裏把 PasteFerry Daemon 改為「允許」。';

  @override
  String get permAskBody =>
      '否則 macOS 每次都會彈出視窗詢問。請到系統設定裏把 PasteFerry Daemon 改為「允許」。';

  @override
  String get openSystemSettings => '開啟系統設定';

  @override
  String get fetch => '接收';

  @override
  String get fetchStarted => '正在接收，可在複製記錄查看進度';

  @override
  String get transferFailed => '傳輸失敗';

  @override
  String get expired => '已過期';

  @override
  String get putOnClipboard => '放入剪貼簿';

  @override
  String get putOnClipboardDone => '已放入剪貼簿';

  @override
  String get deleteRecord => '刪除這條記錄';

  @override
  String get deleted => '已刪除';

  @override
  String get emptyRecord => '（空）';

  @override
  String get imageRecord => '圖片';

  @override
  String itemsSummary(String name, int others, int count) {
    return '$name 等 $count 項';
  }

  @override
  String get searchHint => '搜尋文字和檔案名稱';

  @override
  String get searchClear => '清除搜尋';

  @override
  String searchResultCount(int count) {
    return '找到 $count 條';
  }

  @override
  String searchEmptyTitle(String query) {
    return '找不到「$query」';
  }

  @override
  String get searchEmptyBody => '搜尋範圍是複製過的文字和檔案名稱。';

  @override
  String get favoriteAction => '收藏';

  @override
  String get unfavoriteAction => '取消收藏';

  @override
  String get favoritedToast => '已收藏';

  @override
  String get unfavoritedToast => '已放回複製記錄';

  @override
  String get undo => '復原';

  @override
  String get favoriteSaving => '正在儲存…';

  @override
  String favoritedAt(String date) {
    return '收藏於 $date';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    return '$count 條 · 不會被自動清理 · 最多佔用 $size';
  }

  @override
  String get favoritesEmptyTitle => '仍未有收藏';

  @override
  String get favoritesEmptyBody => '在複製記錄裏按星號，就會在這裏另存一份。收藏不會被自動清理。';

  @override
  String get favoritesSearchHint => '搜尋收藏';

  @override
  String favoriteLargeTitle(String size) {
    return '另存一份 $size 的內容？';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return '收藏會另存一份，原檔案之後改動或刪除都不影響收藏。這會佔用$device上 $size 的空間。';
  }

  @override
  String get saveCopy => '另存';

  @override
  String clearKeepsFavorites(int count) {
    return '已收藏的 $count 條會保留。';
  }

  @override
  String get favoritesUsage => '收藏佔用';

  @override
  String get favoritesUsageDesc => '收藏不受上面兩項的限制，不會被自動清理';

  @override
  String upToSize(String size) {
    return '最多 $size';
  }

  @override
  String detailChars(int count) {
    return '$count 字';
  }

  @override
  String detailTruncated(int count) {
    return '…… 共 $count 字';
  }

  @override
  String detailMoreFiles(int count) {
    return '還有 $count 個';
  }

  @override
  String get detailReceiveFirst => '選取後先下載';

  @override
  String detailTotalSize(String size) {
    return '共 $size';
  }

  @override
  String get quickPaste => '快速貼上';

  @override
  String get quickPasteWindow => '快速貼上視窗';

  @override
  String get quickPasteWindowDesc => '在任何程式裏按快速鍵叫出複製記錄，選取即貼上';

  @override
  String get quickPasteShortcut => '快速鍵';

  @override
  String get quickPasteRecord => '按一下錄製';

  @override
  String get quickPasteRecording => '請按下新的快速鍵…';

  @override
  String get quickPasteUseDefault => '恢復預設';

  @override
  String get quickPasteNeedsModifier => '要加上 ⌃、⌥、⇧ 或 ⌘，或者用功能鍵';

  @override
  String get quickPasteNeedsModifierPc => '要加上 Ctrl、Alt、Shift 或 Win 鍵，或者用功能鍵';

  @override
  String get quickPasteAfterPick => '選取後';

  @override
  String get quickPastePasteIt => '直接貼上';

  @override
  String get quickPasteCopyIt => '只放入剪貼簿';

  @override
  String get quickPasteIndexKey => '貼上前 9 項';

  @override
  String get quickPasteIndexKeyDesc => '在快速貼上視窗裏按住它再按 1–9';

  @override
  String get quickPasteAccessibility => '輔助使用權限';

  @override
  String get quickPasteAccessibilityDesc => '直接貼上需要它；沒有授權時只放入剪貼簿，再由你按 ⌘V';

  @override
  String get quickPasteAllowed => '已授權';

  @override
  String get quickPasteAllow => '去授權';

  @override
  String get quickPasteNotRunning => '快速貼上視窗未有執行';

  @override
  String quickPasteInUse(String key) {
    return '$key 已被其他程式佔用，請換一個組合';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return '無法設定 $key：$detail';
  }

  @override
  String get quickPastePortalKey => '在系統的快速鍵設定裏修改';

  @override
  String get quickPasteWaylandDesc =>
      'Wayland 下快速鍵要加在桌面的鍵盤設定裏；選取後放入剪貼簿，再按 Ctrl+V 貼上';

  @override
  String get quickPasteAddShortcut => '新增系統快速鍵';

  @override
  String quickPasteShortcutAdded(String key) {
    return '已新增，按 $key 試試';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return '在桌面的鍵盤設定裏新增一個自訂快速鍵，指令填：$command';
  }

  @override
  String get pickerSearch => '搜尋';

  @override
  String get pickerPaste => '貼上';

  @override
  String get pickerPlainText => '純文字';

  @override
  String get pickerCopyOnly => '只複製';

  @override
  String get pickerUnfavoriteHint => '取消收藏（放回複製記錄）';

  @override
  String pickerPasteManually(String key) {
    return '選取後按 $key 貼上';
  }

  @override
  String get pickerGrantHint => '授予「輔助使用」權限後可直接貼上';

  @override
  String pickerElevated(String key) {
    return '這個視窗以管理員身分執行，選取後按 $key 貼上';
  }

  @override
  String get pickerDownloading => '正在下載，下載完自動貼上';

  @override
  String get imagePreviewTitle => '圖片預覽';

  @override
  String get closePreview => '關閉預覽';

  @override
  String get previousImage => '上一張';

  @override
  String get nextImage => '下一張';

  @override
  String get previewHint => '用滾輪或觸控板縮放，拖移查看';

  @override
  String get fitWindow => '符合視窗大小';

  @override
  String get previewDeleted => '這條圖片記錄已被刪除';

  @override
  String get previewExpired => '圖片已過期，無法預覽';

  @override
  String get previewDownloading => '正在下載圖片…';

  @override
  String get previewDownloadFailed => '圖片下載失敗，請重試';

  @override
  String get previewNotDownloaded => '圖片仍未下載到這部電腦';

  @override
  String get downloadAndPreview => '下載並預覽';

  @override
  String get previewUnavailable => '圖片暫時無法預覽';

  @override
  String get imageSemantic => '複製記錄中的圖片';

  @override
  String get previewUnreadable => '無法讀取圖片，檔案可能已被清理或損壞';

  @override
  String get devicesSubtitleEmpty => '配對之後，裝置之間就會同步剪貼簿';

  @override
  String devicesSubtitle(int paired, int online) {
    return '已配對 $paired 部，$online 部在線';
  }

  @override
  String get addDevice => '新增裝置';

  @override
  String thisDeviceFootnote(String both) {
    return '配對時，$both會顯示同樣的兩行安全指紋：這部的和對方的。逐字核對一致才可確認。';
  }

  @override
  String get noDevicesTitle => '仍未有已配對的裝置';

  @override
  String get noDevicesBody =>
      '在另一部電腦上開啟隔空貼，用 6 位配對碼把兩部連起來。兩部在同一個網絡裏時，也可以在兩部上都開啟「搜尋附近裝置」，按一下對方。';

  @override
  String get pairedDevices => '已配對的裝置';

  @override
  String get pairedFootnote =>
      '直連：資料在兩部裝置之間直接傳輸。中轉：網絡環境打不通直連時，經你的伺服器轉發，內容依然是端對端加密的。';

  @override
  String get offline => '離線';

  @override
  String get direct => '直連';

  @override
  String get relay => '中轉';

  @override
  String get online => '在線';

  @override
  String get moreActions => '更多操作';

  @override
  String get copyFingerprint => '拷貝安全指紋';

  @override
  String get unpairEllipsis => '解除配對…';

  @override
  String get fingerprintCopied => '安全指紋已拷貝';

  @override
  String unpairTitle(String name) {
    return '解除與「$name」的配對？';
  }

  @override
  String get unpairBody => '兩部裝置將不再同步。日後想恢復，需要重新配對並核對指紋。';

  @override
  String get unpair => '解除配對';

  @override
  String get unpaired => '已解除配對';

  @override
  String get enterAddressEllipsis => '輸入它的地址…';

  @override
  String setAddressTitle(String name) {
    return '「$name」的地址';
  }

  @override
  String setAddressBody(String name) {
    return '兩部不在同一網段，或者都換了地址時使用。輸入「$name」上「新增裝置 → 產生配對碼」下面顯示的地址。';
  }

  @override
  String get addressSaved => '已記下，正在那個地址上尋找它';

  @override
  String get lanBlockedTitle => 'macOS 阻擋了區域網絡存取';

  @override
  String lanBlockedBody(String device) {
    return '在「系統設定 → 私隱與保安 → 本地網絡」裏開啟 PasteFerry Daemon。開啟之前，$device連不上同一網絡裏的裝置。';
  }

  @override
  String get searchNearby => '搜尋附近裝置';

  @override
  String get nearbyTitle => '附近的裝置';

  @override
  String get nearbySearching => '正在尋找附近的裝置…';

  @override
  String get nearbyHint => '在另一部電腦上也開啟「搜尋附近裝置」，它就會出現在這裏，按一下即可配對。';

  @override
  String nearbyVisible(String device) {
    return '視窗開啟期間，同一網絡裏的裝置能看到$device的名稱。';
  }

  @override
  String get nearbyPaired => '已配對';

  @override
  String nearbyRequesting(String name) {
    return '正在聯絡「$name」…';
  }

  @override
  String nearbyNoReply(String name) {
    return '「$name」沒有回應。請確認它仍開着「搜尋附近裝置」。';
  }

  @override
  String get nearbyLanOffTitle => '區域網絡發現已關閉';

  @override
  String get nearbyLanOffBody => '在「設定 → 連接」裏開啟「在區域網絡中尋找裝置」才能看到附近的裝置，或者改用配對碼。';

  @override
  String get generateCode => '產生配對碼';

  @override
  String get enterCode => '輸入配對碼';

  @override
  String get codeFailedTitle => '未能產生配對碼';

  @override
  String get enterOnOther => '在另一部裝置上輸入這個配對碼';

  @override
  String get codeCopied => '配對碼已拷貝';

  @override
  String get codeHint => '按一下即可拷貝，5 分鐘內有效';

  @override
  String afterEnterFootnote(String both) {
    return '對方輸入後，$both會顯示同樣的兩行安全指紋，核對一致再確認。';
  }

  @override
  String get codeInvalid => '配對碼是 6 位字母或數字';

  @override
  String get localAddress => '本機地址';

  @override
  String get addressHint => '不在同一網段時，另一部還要輸入這個地址';

  @override
  String get addressCopied => '地址已拷貝';

  @override
  String get differentSubnet => '不在同一網段？';

  @override
  String get peerAddress => '對方配對碼下面顯示的地址';

  @override
  String get pairNotFound => '找不到那部裝置。不在同一網段時，請輸入它配對碼下面顯示的地址。';

  @override
  String get pairNotFoundAddress =>
      '那個地址沒有回應。請檢查地址是否正確、對方是否仍停留在配對碼頁面；對方的防火牆也可能阻擋了連線。';

  @override
  String get codeWrong => '配對碼不正確，或者已經失效';

  @override
  String get codeExpired => '配對碼已失效，請在另一部上重新產生';

  @override
  String get addressInvalid => '地址格式不正確，應該像 192.168.1.20 這樣';

  @override
  String get pairNoChannel => '請先在「設定 → 連接」裏開啟區域網絡發現，或者填寫伺服器地址。';

  @override
  String get enterCodeShown => '輸入另一部裝置上顯示的配對碼';

  @override
  String get pairingDone => '配對完成';

  @override
  String get pairingRejected => '已拒絕配對';

  @override
  String get verifyTitle => '核對安全指紋';

  @override
  String pairingWith(String name) {
    return '正在與「$name」配對';
  }

  @override
  String verifyBody(String both) {
    return '$both上顯示的這兩行應該完全相同。只要有一個字元不同，就代表連線可能被第三方篡改，請拒絕。';
  }

  @override
  String get rejectMismatch => '不一致，拒絕';

  @override
  String get confirmMatch => '一致，確認配對';

  @override
  String get server => '伺服器（可選）';

  @override
  String get signalingUrl => '信令伺服器地址';

  @override
  String get signalingUrlDesc => '留空只在區域網絡同步';

  @override
  String get signalingUrlPlaceholder => 'ws://伺服器地址:8787/signal';

  @override
  String get publicStun => '提升公網直連成功率';

  @override
  String get publicStunDesc => '公共伺服器可見本機公網 IP';

  @override
  String get connectionStatus => '連線狀態';

  @override
  String get disconnectedDesc => '請檢查地址與伺服器狀態';

  @override
  String get connected => '已連線';

  @override
  String get notConnected => '未連線';

  @override
  String get notSet => '未設定';

  @override
  String get serverCleared => '已清除伺服器地址，只在區域網絡裏同步';

  @override
  String get localNetwork => '區域網絡';

  @override
  String get lanDiscovery => '在區域網絡中尋找裝置';

  @override
  String get lanDiscoveryDesc => '匿名發現，只在搜尋附近裝置時顯示名稱';

  @override
  String get macLocalNetwork => '本地網絡權限';

  @override
  String get macLocalNetworkDesc => '在系統設定中允許 PasteFerry Daemon';

  @override
  String get allowLan => 'Windows 防火牆';

  @override
  String get allowLanDesc => '連線受阻時允許連線，需管理員權限';

  @override
  String get allow => '允許';

  @override
  String get allowLanDone => '已允許，其他裝置現在可以連到這部電腦了';

  @override
  String get deviceName => '裝置名稱';

  @override
  String get language => '語言';

  @override
  String get languageSystem => '跟隨系統';

  @override
  String get sync => '同步';

  @override
  String get autoSyncLimit => '自動同步上限';

  @override
  String get autoSyncLimitDesc => '超出上限後，在複製記錄中手動接收';

  @override
  String get autoApply => '收到後直接寫入剪貼簿';

  @override
  String get whatToSync => '同步哪些內容';

  @override
  String get syncFiles => '檔案與資料夾';

  @override
  String get syncText => '純文字';

  @override
  String get syncRich => '帶格式的文字';

  @override
  String get syncImages => '圖片與截圖';

  @override
  String get storage => '儲存空間';

  @override
  String get storageFootnote => '到期自動清理記錄與快取。';

  @override
  String get keepHistory => '記錄保留';

  @override
  String get keepCache => '快取檔案保留';

  @override
  String get keepCacheDesc => '不超過記錄保留時間';

  @override
  String get cacheUsage => '快取佔用空間';

  @override
  String get backgroundSync => '背景同步';

  @override
  String get backgroundService => '背景服務';

  @override
  String get backgroundServiceDesc => '登入自動啟動，關閉視窗後繼續同步';

  @override
  String get restart => '重新啟動';

  @override
  String get restarted => '背景服務已重新啟動';

  @override
  String get disableEllipsis => '停用…';

  @override
  String get about => '關於';

  @override
  String get aboutDesc => '開源軟件，以 AGPL-3.0 授權';

  @override
  String get homepage => '項目主頁';

  @override
  String get feedback => '回報問題';

  @override
  String get disableTitle => '停用背景同步？';

  @override
  String disableBody(String device) {
    return '$device將停止同步，也不再開機啟動。歷史記錄和配對關係會保留。';
  }

  @override
  String get disable => '停用';

  @override
  String get disabled => '背景同步已停用';

  @override
  String get urlMustBeWs => '地址必須以 ws:// 或 wss:// 開頭';

  @override
  String get serverUpdated => '伺服器地址已更新，正在重新連線';

  @override
  String get deviceNameUpdated => '裝置名稱已更新';

  @override
  String get diagIntro =>
      '報告裏有版本、系統、設定、裝置狀態和最近的日誌。裝置名稱、伺服器地址、公網 IP、用戶資料夾和檔案名稱都已替換，複製的內容從不寫進日誌。GitHub 上的問題是公開的，貼出去之前請看一遍。';

  @override
  String get diagVerboseTitle => '詳細日誌';

  @override
  String get diagVerboseDesc => '連線方面的問題常要看它：開啟後重現一次問題，再回來產生報告。30 分鐘後自動關閉。';

  @override
  String get diagVerboseOn => '開啟 30 分鐘';

  @override
  String diagVerboseUntil(String time) {
    return '已開啟，$time 自動關閉';
  }

  @override
  String get diagVerboseOff => '關閉';

  @override
  String get diagRefresh => '重新產生';

  @override
  String get diagSave => '儲存為檔案';

  @override
  String diagSaved(String name) {
    return '已儲存到「下載」資料夾：$name';
  }

  @override
  String get diagCopy => '拷貝報告';

  @override
  String get diagCopied => '報告已拷貝';

  @override
  String get diagNewIssue => '在 GitHub 上回報';

  @override
  String get diagIssueHint => '報告已拷貝，貼到問題裏的「診斷報告」一欄';

  @override
  String diagFailed(String detail) {
    return '產生報告失敗：$detail';
  }

  @override
  String get svcExtractTitle => '先解壓縮或安裝隔空貼';

  @override
  String get svcExtractBody =>
      '隔空貼現在是直接從壓縮檔裏開啟的，關閉之後它所在的臨時資料夾就會被刪除。執行安裝程式，或者把整個資料夾解壓縮出來再開啟，就可以啟用背景同步。';

  @override
  String get svcMoveTitle => '先把隔空貼移到「應用程式」';

  @override
  String get svcMoveBody =>
      '隔空貼現在是直接從磁碟映像裏開啟的。把它拖進「應用程式」資料夾，推出磁碟映像，再從「應用程式」裏開啟，就可以啟用背景同步。';

  @override
  String get svcStartTitle => '開始使用隔空貼';

  @override
  String get svcStartBody => '隔空貼透過背景程序同步剪貼簿，關閉視窗後仍會運作。開機啟動可在設定裏單獨選擇，新安裝預設關閉。';

  @override
  String get svcEnable => '啟用背景同步';

  @override
  String get svcStaleTitle => '重新啟用背景同步';

  @override
  String get svcStaleBodyWin =>
      '隔空貼換了位置，開機自動啟動仍指向原來的位置。重新啟用一次，讓背景程序指向目前這份隔空貼。歷史記錄與配對關係都會保留。';

  @override
  String get svcStaleBodyMac =>
      '隔空貼換了位置，或者之前用舊版安裝腳本安裝過。重新啟用一次，讓背景程序指向目前這個 App。歷史記錄與配對關係都會保留。';

  @override
  String get svcReenable => '重新啟用';

  @override
  String get svcStoppedTitle => '背景服務沒有執行';

  @override
  String get svcStoppedBody => '背景服務已停止。按下面的按鈕啟動；是否開機啟動可在設定裏單獨選擇。';

  @override
  String get svcDevBodyWin =>
      '這是開發版本，旁邊沒有 pasteferryd.exe。在原始碼目錄執行 scripts\\build-windows.ps1 建置完整的版本。';

  @override
  String get svcDevBodyLinux =>
      '這是開發版本，旁邊沒有 pasteferryd。在原始碼目錄執行 ./scripts/package-linux.sh 建置完整的版本。';

  @override
  String get svcDevBodyMac =>
      '這是開發版本，App 裏沒有內建背景服務。在原始碼目錄執行 ./scripts/install-macos.sh 安裝它。';

  @override
  String svcLogPath(String path) {
    return '執行日誌：$path';
  }

  @override
  String get svcCanDisable => '隨時可以在「設定」中停用背景同步。';

  @override
  String get officialService => '服務';

  @override
  String get useOfficialService => '使用服務';

  @override
  String get officialServiceDesc => '跨網絡同步，優先直連';

  @override
  String get officialPrivacy =>
      '只在啟用後連接服務並記錄必要的連線資料。先嘗試直連，失敗才申請中轉；不傳送內容、真實裝置名稱或原始系統識別碼。';

  @override
  String get officialEnableTitle => '啟用服務？';

  @override
  String get officialSwitchConfirm => '這會切換目前的自訂伺服器，已儲存的地址仍會保留。';

  @override
  String get customServer => '自訂伺服器';

  @override
  String get saveAndConnect => '儲存並連接';

  @override
  String get officialLoading => '正在取得額度…';

  @override
  String get officialFetchFailed => '暫時無法取得額度，會自動重試。';

  @override
  String get officialUnavailable => '用量暫時無法取得，現有資料可能過期';

  @override
  String get officialQuotaTitle => '今日中轉額度已用完';

  @override
  String get officialQuotaBody => '服務中轉已暫停，北京時間午夜重設。區域網絡和公網直連仍可使用；傳輸失敗時可稍後重試。';

  @override
  String get officialPeerQuota => '對方中轉額度不足，直連仍可使用';

  @override
  String get officialPaused => '服務中轉暫時無法使用，直連仍可使用';

  @override
  String get officialViewUsage => '查看用量';

  @override
  String get officialAcknowledge => '知道了';

  @override
  String get officialToday => '今日中轉額度';

  @override
  String get officialUsed => '已使用';

  @override
  String get officialRemaining => '剩餘額度';

  @override
  String get officialDailyLimit => '每日額度';

  @override
  String get officialUpload => '上傳';

  @override
  String get officialDownload => '下載';

  @override
  String get officialReset => '重設時間（北京時間）';

  @override
  String get officialUpdated => '上次更新';

  @override
  String get officialRoutes => '裝置連線方式';

  @override
  String get officialRoutesFootnote => '直連時不經過服務中轉，也不消耗額度。';

  @override
  String get officialDeviceID => '裝置 ID';

  @override
  String get officialWarning => '今日中轉額度已使用 90%，直連不消耗此額度。';

  @override
  String get updateCheck => '檢查更新';

  @override
  String get updateCheckEllipsis => '檢查更新…';

  @override
  String get updateAuto => '自動檢查更新';

  @override
  String get updateChecking => '正在檢查更新…';

  @override
  String updateUpToDate(String version) {
    return '隔空貼 $version 已是最新版本。';
  }

  @override
  String updateAvailableTitle(String version) {
    return '有新版本：隔空貼 $version';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return '目前版本 $current，需要下載 $size。';
  }

  @override
  String get updateNew => '新增';

  @override
  String get updateFixed => '修正';

  @override
  String get updateSkip => '略過這個版本';

  @override
  String get updateLater => '稍後再說';

  @override
  String get updateInstall => '下載並安裝';

  @override
  String updateDownloading(String done, String total) {
    return '正在下載 $done / $total';
  }

  @override
  String get updateVerifying => '正在校驗下載的檔案…';

  @override
  String get updateInstalling => '正在安裝，隔空貼會自動重新開啟。';

  @override
  String get updateInstallingPassword =>
      '正在安裝。安裝到 /opt 需要管理員權限，系統會請你輸入密碼，之後隔空貼會自動重新開啟。';

  @override
  String get updateCheckFailed => '暫時連不上 GitHub 和 Gitee，請稍後再試。';

  @override
  String get updateDownloadFailed => '下載沒有完成。可以重試，或到下載頁手動下載新版本。';

  @override
  String updateInstallFailed(String error) {
    return '未能開始安裝：$error';
  }

  @override
  String get updateUnsupportedBuild => '這個版本不支援檢查更新。';

  @override
  String get updateBlockedDev => '這是開發版本，不能自動更新。';

  @override
  String get updateBlockedMustMove =>
      '隔空貼是直接從磁碟映像檔裏開啟的。把它拖到「應用程式」資料夾、從那裏開啟後，就能自動更新。';

  @override
  String get updateBlockedReadOnly => '隔空貼所在的資料夾無法寫入，沒法自動更新。請到下載頁手動下載新版本。';

  @override
  String get updateBlockedUnsupported => '這部電腦沒有可用的自動更新安裝檔，請到下載頁手動下載新版本。';

  @override
  String get updateOpenDownload => '開啟下載頁';

  @override
  String updateSidebar(String version) {
    return '新版本 $version 可用';
  }

  @override
  String updatedTo(String version) {
    return '已更新到 $version';
  }

  @override
  String updateNotFinished(String version) {
    return '更新沒有完成，仍是 $version。';
  }

  @override
  String updateNotFinishedWhy(String version, String detail) {
    return '更新沒有完成，仍是 $version。$detail';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return '介面 $uiVersion · 背景服務 $serviceVersion · 版本識別 $build';
  }

  @override
  String get notReceived => '尚未接收，暫不可貼上';

  @override
  String get receivedPreserved => '已接收，按放入剪貼簿後即可貼上';

  @override
  String get clipboardWriteFailed => '已接收，但無法寫入剪貼簿';

  @override
  String get receivingStatus => '正在接收…';

  @override
  String get largeFileNotifications => '大檔案接收提醒';

  @override
  String get notificationsAllowed => '已允許系統通知，接收進度可在複製記錄中查看。';

  @override
  String get notificationsNotRequested => '開啟系統通知，避免大檔案等待接收時沒有提示；亦可隨時從複製記錄接收。';

  @override
  String get notificationsDenied => '系統通知已關閉，請在系統設定中開啟；待接收內容仍可從複製記錄接收。';

  @override
  String get notificationsUnknown => '通知顯示和勿擾由系統控制；未看到提示時，可在複製記錄中接收。';

  @override
  String get notificationsUnavailable => '系統通知暫時無法使用，請從複製記錄接收大檔案。';

  @override
  String get enableNotifications => '開啟提醒';

  @override
  String get notificationSettings => '通知設定';

  @override
  String get notifyPendingTitle => '接收後即可貼上';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\n尚未接收，暫不可貼上。亦可從複製記錄接收。';
  }

  @override
  String get notifyReceivingTitle => '正在接收…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\n可在複製記錄查看接收進度。';
  }

  @override
  String get notifyReadyTitle => '已就緒，可以貼上';

  @override
  String notifyReadyBody(String name) {
    return '$name\n已接收並放入剪貼簿。';
  }

  @override
  String get notifyReceivedTitle => '已接收';

  @override
  String notifyReceivedBody(String name) {
    return '$name\n已保留目前剪貼簿，按放入剪貼簿後即可貼上，亦可從複製記錄操作。';
  }

  @override
  String get notifyFailedTitle => '接收失敗';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\n可從此通知或複製記錄重試。';
  }

  @override
  String get notifyClipboardFailedTitle => '已接收，但無法寫入剪貼簿';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\n可從此通知或複製記錄重新放入剪貼簿。';
  }

  @override
  String get reconnect => '重新連線';

  @override
  String get reconnecting => '正在連線…';

  @override
  String get reconnectDirect => '已直連';

  @override
  String get reconnectRelay => '直連沒有打通，繼續經中轉';

  @override
  String reconnectOffline(String name) {
    return '「$name」不在線，請確認它那邊已開啟隔空貼';
  }

  @override
  String get reconnectPending => '仍在連線，請稍後再看';

  @override
  String get renameAction => '重新命名';

  @override
  String get renameFavoriteTitle => '重新命名收藏';

  @override
  String get renameFavoriteHint => '收藏和快速貼上裡顯示這個名稱，搜尋也找得到。留空則恢復顯示內容。';

  @override
  String get renamedToast => '已重新命名';

  @override
  String get aliasClearedToast => '已恢復顯示內容';

  @override
  String get navSend => '隔空傳送';

  @override
  String get sendSubtitle => '把檔案拖到一部裝置上，直接傳過去';

  @override
  String get sendNoDevicesTitle => '還沒有配對的裝置';

  @override
  String get sendNoDevicesBody => '先配對另一部電腦，之後就能在這裏傳檔案給它。';

  @override
  String get sendDropHint => '拖到一部裝置上傳送';

  @override
  String sendReleaseTo(String name) {
    return '放手以傳送到 $name';
  }

  @override
  String get sendLan => '區域網絡';

  @override
  String sendRelayLeft(String left) {
    return '中轉 · 今日剩 $left';
  }

  @override
  String get sendNeedsUpdate => '需要更新';

  @override
  String sendNeedsUpdateTip(String name) {
    return '$name 更新到隔空貼 2.5 或更新版本後才能接收檔案。';
  }

  @override
  String sendConnectingTip(String name) {
    return '正在連線 $name，連上後就能傳送。';
  }

  @override
  String get sendNotReceiving => '不接收檔案';

  @override
  String get sendDelivered => '已送達';

  @override
  String sendToTitle(String name) {
    return '傳送到 $name';
  }

  @override
  String get sendDropHere => '把檔案或資料夾拖到這裏';

  @override
  String get sendDropStarts => '放手就開始傳送';

  @override
  String get sendChooseFiles => '選擇檔案…';

  @override
  String get sendChooseFolder => '選擇資料夾…';

  @override
  String get sendDropMore => '繼續拖入檔案，排在後面傳送';

  @override
  String sendSavedWhere(String name) {
    return '檔案會存到 $name 設定的位置，預設是「下載」資料夾。';
  }

  @override
  String get sendCloseKeeps => '關閉視窗不影響傳送';

  @override
  String get sendRemoveQueued => '移除';

  @override
  String get sendCannotDrop => '這個項目不能直接拖過來傳送。請先把它存成檔案，或使用「選擇檔案…」。';

  @override
  String sendErrOffline(String name) {
    return '$name 不在線上。';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name 關閉了接收檔案。';
  }

  @override
  String get sendErrMissing => '有檔案已經不在了。';

  @override
  String get relayConfirmTitle => '經服務中轉傳送？';

  @override
  String relayConfirmBody(String name, String left) {
    return '$name 目前和這部電腦沒有直連，檔案要經服務中轉，速度約 0.25 MB/s。今天的中轉額度還剩 $left。';
  }

  @override
  String relayConfirmOver(String size) {
    return '這些檔案（$size）超出了今天剩餘的額度。傳到額度用完時會暫停；兩部電腦連上直連、或明天額度恢復後，自動繼續。';
  }

  @override
  String relayConfirmWithin(String size) {
    return '這次大約用掉今天額度中的 $size。';
  }

  @override
  String get relayExhausted => '今天的中轉額度已用完，北京時間 0 點恢復。兩部電腦連上直連後不受限制。';

  @override
  String get relayDontAskToday => '今天傳給這部裝置時不再詢問';

  @override
  String get relaySendAnyway => '仍然傳送';

  @override
  String get relayOwnServer => '中轉，速度取決於你的伺服器頻寬';

  @override
  String get transfersReceived => '收到的';

  @override
  String get transfersSent => '傳出的';

  @override
  String get transfersClearAll => '全部清除';

  @override
  String get transfersClearTitle => '清除這個列表？';

  @override
  String get transfersClearBody => '只清除紀錄，檔案不會被刪除。';

  @override
  String get transfersEmptyReceived => '其他裝置傳來的檔案會出現在這裏';

  @override
  String get transfersEmptySent => '你傳出的檔案會出現在這裏';

  @override
  String transferFrom(String name) {
    return '來自 $name';
  }

  @override
  String transferTo(String name) {
    return '傳給 $name';
  }

  @override
  String transferItems(String name, int total, int others) {
    return '$name 等 $total 項';
  }

  @override
  String transferFileCount(int count) {
    return '$count 個檔案';
  }

  @override
  String get transferQueued => '排隊中';

  @override
  String transferScanning(String count) {
    return '正在統計… 已找到 $count 個檔案';
  }

  @override
  String transferWaitingPeer(String name) {
    return '正在聯絡 $name…';
  }

  @override
  String get transferSending => '正在傳送';

  @override
  String get transferReceiving => '正在接收';

  @override
  String transferCurrent(String file, String index, String total) {
    return '正在傳：$file（第 $index / $total 個）';
  }

  @override
  String transferLeft(String time) {
    return '還剩 $time';
  }

  @override
  String etaSeconds(int n) {
    return '$n 秒';
  }

  @override
  String etaMinutes(int n) {
    return '$n 分鐘';
  }

  @override
  String etaHours(int h, int m) {
    return '$h 小時 $m 分';
  }

  @override
  String get transferPaused => '已暫停：今天的中轉額度用完了';

  @override
  String get transferInterrupted => '已中斷，重新連上後繼續';

  @override
  String transferInterruptedIncoming(String name) {
    return '已中斷 · 等 $name 繼續';
  }

  @override
  String get transferCancelled => '已取消';

  @override
  String transferPeerCancelled(String name) {
    return '$name 取消了';
  }

  @override
  String get transferExpired => '已過期';

  @override
  String get transferMissing => '已移動或刪除';

  @override
  String transferNotSent(String reason) {
    return '沒有傳出：$reason';
  }

  @override
  String transferNotReceived(String reason) {
    return '沒有收下：$reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return '$name 的磁碟空間不足，還差 $size';
  }

  @override
  String reasonNoSpace(String size) {
    return '磁碟空間不足，還差 $size';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return '$name 的儲存位置無法使用';
  }

  @override
  String get reasonDestUnavailable => '儲存位置無法使用，請在設定中檢查';

  @override
  String get reasonFileTooLarge => '儲存位置在 FAT32 格式的磁碟上，放不下超過 4 GB 的檔案';

  @override
  String reasonDisabledPeer(String name) {
    return '$name 關閉了接收檔案';
  }

  @override
  String get reasonSourceChanged => '傳送過程中有檔案被修改了';

  @override
  String get reasonSourceMissing => '有檔案已經不在了';

  @override
  String get reasonReadError => '有檔案讀取失敗';

  @override
  String get reasonWriteFailed => '檔案寫入失敗';

  @override
  String get reasonHashMismatch => '有檔案在傳輸中損毀了';

  @override
  String reasonUnsupported(String name) {
    return '$name 需要更新才能接收檔案';
  }

  @override
  String get reasonOther => '出了點問題';

  @override
  String get revealInFinder => '在 Finder 中顯示';

  @override
  String get revealInFolder => '在資料夾中顯示';

  @override
  String get revealOpenFolder => '打開資料夾';

  @override
  String get transferResend => '重新傳送';

  @override
  String get transferRemove => '從列表中移除';

  @override
  String get transferCopyPath => '拷貝路徑';

  @override
  String get transferPathCopied => '已拷貝路徑';

  @override
  String sendingTo(String name, String percent) {
    return '正在傳給 $name · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return '正在接收 $name 的檔案 · $percent';
  }

  @override
  String get receiveFiles => '接收其他裝置傳來的檔案';

  @override
  String get saveTo => '儲存到';

  @override
  String get saveToChange => '更改…';

  @override
  String get saveToDefault => '下載（預設）';

  @override
  String get saveToUseDefault => '改回「下載」';

  @override
  String get receiveNotify => '收到檔案時通知';

  @override
  String receiveFootnote(String device) {
    return '只有已配對的裝置能傳檔案給$device。傳輸期間$device不會自動睡眠。';
  }

  @override
  String get saveDirNotFound => '這個資料夾不存在。';

  @override
  String get saveDirNotWritable => '隔空貼無法把檔案存到這個資料夾。';

  @override
  String get saveDirPermission =>
      '隔空貼還沒有使用這個資料夾的權限。請在「系統設定 → 私隱與保安 → 檔案和資料夾」中允許。';

  @override
  String transferRenamed(int count) {
    return '$count 個檔名含 Windows 不支援的字元，已換成相近的全形字元';
  }

  @override
  String get sendRingLan => '同一網絡';

  @override
  String get sendRingOther => '其他網絡';

  @override
  String sendOfflineList(String names) {
    return '離線：$names';
  }

  @override
  String get listSeparator => '、';

  @override
  String get sendLayout => '傳輸列表';

  @override
  String get sendLayoutSide => '在雷達右邊';

  @override
  String get sendLayoutBelow => '在雷達下面';

  @override
  String get general => '一般';

  @override
  String get launchAtLogin => '開機啟動';

  @override
  String get launchAtLoginDesc => '登入電腦後在背景啟動，不開啟主視窗。更改此項不會停止目前的運作。';

  @override
  String get realtimeSync => '即時同步剪貼簿';

  @override
  String get realtimeSyncDesc => '自動與配對裝置同步新複製的內容。關閉後仍保留本機記錄，也可手動隔空傳送。';

  @override
  String get syncBacklog => '重新連線後補傳離線內容';

  @override
  String get syncBacklogDesc =>
      '預設關閉：離線期間未送達的內容不再補傳。開啟後最多補傳 24 小時內的 20 筆記錄，不覆寫目前的剪貼簿。';

  @override
  String get peerRealtimeSync => '與這部電腦即時同步';

  @override
  String get syncPaused => '剪貼簿同步已暫停';

  @override
  String get quitApp => '退出隔空貼';

  @override
  String get quitAppDesc => '結束隔空貼的全部程序，保留開機啟動設定。';

  @override
  String get quitTransfersWarning => '還有檔案正在傳輸，要中斷傳輸並退出嗎？';

  @override
  String get backgroundRunningTitle => '隔空貼將繼續在背景運作';

  @override
  String get backgroundRunningBody =>
      '關閉視窗後，同步和快速貼上仍會運作。如需完全停止，請在設定或應用程式選單選擇「退出隔空貼」。';

  @override
  String get displayAs => '顯示為';

  @override
  String get editName => '修改名稱';

  @override
  String get nameHint => '好友看到的名稱';

  @override
  String get nameDefaultHint => '留空則使用系統的用戶名稱。';

  @override
  String get avatarTitle => '設定頭像';

  @override
  String get avatarChoose => '選擇圖片…';

  @override
  String get avatarPaste => '貼上圖片';

  @override
  String get avatarReset => '恢復預設頭像';

  @override
  String get avatarZoom => '縮放';

  @override
  String get avatarDragHint => '拖曳可以移動圖片。';

  @override
  String get avatarNoImage => '剪貼簿裏沒有圖片。';

  @override
  String get avatarBad => '這張圖片無法使用，請換一張 PNG、JPEG 或 GIF。';

  @override
  String get done => '完成';

  @override
  String get friendsTitle => '好友';

  @override
  String get addFriend => '新增好友';

  @override
  String get friendsEmpty => '還沒有好友';

  @override
  String get friendsEmptyBody => '加了好友，就能互相傳檔案，不用配對。好友只能傳檔案，看不到你的剪貼簿。';

  @override
  String get friendSendAction => '傳送…';

  @override
  String get friendHistory => '傳輸記錄';

  @override
  String friendHistoryTitle(String name) {
    return '和 $name 的傳輸';
  }

  @override
  String get friendHistoryEmpty => '還沒有傳過檔案。';

  @override
  String get friendAutoAccept => '自動接收此好友的檔案';

  @override
  String get friendRemove => '刪除好友';

  @override
  String friendRemoveTitle(String name) {
    return '刪除好友「$name」？';
  }

  @override
  String get friendRemoveBody => '雙方都會刪除對方，之後互相傳不了檔案。以前的傳輸記錄仍留在這部電腦上。';

  @override
  String friendLastActivity(String time) {
    return '$time傳過';
  }

  @override
  String get friendNoActivity => '還沒傳過檔案';

  @override
  String get friendCodeShare => '把這個碼傳給好友，對方在隔空貼裏輸入後，你們就成為好友。';

  @override
  String friendCodeExpires(String time) {
    return '$time 後失效';
  }

  @override
  String get friendCodeOr => '或者';

  @override
  String get friendCodeEnter => '輸入對方的好友碼';

  @override
  String get friendCodeAdd => '新增';

  @override
  String get friendCodeWaiting => '等待對方輸入…';

  @override
  String friendConfirmBody(String name) {
    return '新增 $name 為好友？';
  }

  @override
  String get friendSafetyCode => '核對安全碼（可選）';

  @override
  String get friendSafetyHint => '面對面時可以核對：兩邊顯示的這兩行一樣，就沒有被人調包。';

  @override
  String get friendWaitingPeer => '等待對方新增…';

  @override
  String friendAdded(String name) {
    return '已新增 $name 為好友';
  }

  @override
  String friendPeerCancelled(String name) {
    return '$name 取消了';
  }

  @override
  String get friendErrFriendCode => '這是好友碼，請在隔空傳送頁的「新增好友」裏輸入。';

  @override
  String get friendErrDeviceCode => '這是配對碼，請在「裝置 → 新增裝置」裏輸入。';

  @override
  String get friendErrOutdated => '對方需要更新到隔空貼 2.6.0 或更新版本。';

  @override
  String get friendErrAlreadyPaired => '這部電腦已經是你的裝置。';

  @override
  String get friendErrNoChannel => '你們不在同一個區域網絡，雙方都開啟「服務」後才能新增。';

  @override
  String get openService => '開啟服務…';

  @override
  String get noteLabel => '備註（可選）';

  @override
  String get noteHintEmpty => '先選擇要傳送的檔案';

  @override
  String get noteHint => '例如：合約第 3 頁要簽名';

  @override
  String noteLine(String note) {
    return '備註：$note';
  }

  @override
  String get sendAction => '傳送';

  @override
  String sendItemsSummary(String count, String size) {
    return '共 $count 項 · $size';
  }

  @override
  String sendDropOrPaste(String key) {
    return '把檔案或圖片拖到這裏，或貼上（$key）';
  }

  @override
  String get sendDropMorePaste => '繼續拖入或貼上';

  @override
  String get sendPasteNothing => '剪貼簿裏沒有檔案或圖片。';

  @override
  String get sendRemoveItem => '移除';

  @override
  String sendFriendSaved(String name) {
    return '對方按「接受」後才開始傳送。';
  }

  @override
  String transferAskingOut(String name) {
    return '等待 $name 接受…';
  }

  @override
  String get transferAskingIn => '等你接受';

  @override
  String reasonDeclined(String name) {
    return '$name 拒絕了';
  }

  @override
  String reasonTimeout(String name) {
    return '$name 沒有回應';
  }

  @override
  String reasonNotAllowed(String name) {
    return '$name 不接收檔案';
  }

  @override
  String reasonRateLimited(String name) {
    return '$name 暫時不接收你的檔案';
  }

  @override
  String get reasonYouDeclined => '已拒絕';

  @override
  String get reasonYouIgnored => '已忽略';

  @override
  String get sendAgain => '再傳一次';

  @override
  String incomingTitle(String name) {
    return '$name 想傳檔案給你';
  }

  @override
  String get incomingAlways => '以後自動接收此好友的檔案';

  @override
  String get incomingDecline => '拒絕';

  @override
  String get incomingAccept => '接受';

  @override
  String incomingCountdown(String seconds) {
    return '$seconds 秒後自動拒絕';
  }

  @override
  String get incomingStranger => '附近的裝置';

  @override
  String get friendsStrip => '好友';

  @override
  String get strangersStrip => '附近開著「所有人」的裝置';

  @override
  String get strangerNearby => '附近';

  @override
  String get friendNeedService => '需要開啟服務';

  @override
  String get friendCantReach => '無法連線';

  @override
  String reachSelfNoService(String name) {
    return '你和 $name 不在同一個區域網絡。開啟服務後就能傳檔案給對方，直連不了時經服務中轉。';
  }

  @override
  String reachPeerNoService(String name) {
    return '$name 沒有開啟服務，不在同一個區域網絡時傳不了。請對方在隔空貼裏開啟服務。';
  }

  @override
  String get reachDifferentServer => '你們用的不是同一部伺服器。雙方都開啟服務，或者改用同一部伺服器後就能傳。';

  @override
  String get receiveFromLabel => '允許這些人傳檔案給我：';

  @override
  String get receiveFromOff => '均不允許';

  @override
  String get receiveFromFriends => '只限好友';

  @override
  String get receiveFromEveryone => '所有人';

  @override
  String everyoneLeft(String minutes) {
    return '所有人 · 還剩 $minutes 分鐘';
  }

  @override
  String get receiveFromOffDesc => '只有你配對的電腦能傳。';

  @override
  String get receiveFromFriendsDesc => '好友能傳，每次由你接受。';

  @override
  String get receiveFromEveryoneDesc => '同一區域網絡裏的人都能傳，每次由你接受；10 分鐘後改回「只限好友」。';

  @override
  String get everyoneEnded => '「所有人」已結束，改回「只限好友」。';

  @override
  String get friendsCountTooltip => '好友';

  @override
  String get waitingAccept => '等待接受';

  @override
  String get settingsConnection => '連接';

  @override
  String get settingsGeneralSummary => '開機啟動、裝置名稱、語言';

  @override
  String get settingsConnectionSummary => '服務、自建伺服器、區域網絡';

  @override
  String get settingsSyncSummary => '即時同步、自動同步上限、同步哪些內容';

  @override
  String get settingsQuickPasteSummary => '快速鍵、選取後的動作';

  @override
  String get settingsSendSummary => '接收檔案、儲存位置';

  @override
  String get settingsStorageSummary => '記錄保留多久、佔用空間';

  @override
  String get settingsAboutSummary => '版本、更新、回報';

  @override
  String get friendsSubtitle => '傳檔案給別人的電腦，不用配對';

  @override
  String get friendsSearch => '搜尋好友';

  @override
  String get friendsNoMatch => '找不到這個好友';

  @override
  String get friendsPick => '選一個好友，查看傳輸記錄或傳檔案';

  @override
  String friendDropHint(String name) {
    return '放開即可傳給 $name';
  }
}

/// The translations for Chinese, as used in Taiwan, using the Han script (`zh_Hant_TW`).
class AppLocalizationsZhHantTw extends AppLocalizationsZh {
  AppLocalizationsZhHantTw() : super('zh_Hant_TW');

  @override
  String get appName => '隔空貼';

  @override
  String get navHistory => '複製記錄';

  @override
  String get navDevices => '裝置';

  @override
  String get navSettings => '設定';

  @override
  String get navFavorites => '收藏';

  @override
  String get linkConnecting => '正在連線…';

  @override
  String get linkServiceNotRunning => '背景服務未執行';

  @override
  String get linkLanMode => '在區域網路中尋找裝置';

  @override
  String get linkServerUnreachable => '連不上伺服器，區域網路內照常同步';

  @override
  String get linkNothingOn => '區域網路探索已關閉，也沒有設定伺服器';

  @override
  String get linkLanBlocked => 'macOS 阻擋了區域網路存取';

  @override
  String linkOnlinePeers(int count) {
    return '$count 台裝置在線上';
  }

  @override
  String get linkServerConnected => '已連線到伺服器';

  @override
  String linkConnectionLost(String detail) {
    return '連線中斷：$detail';
  }

  @override
  String get linkServiceDisconnected => '背景服務已中斷連線';

  @override
  String get linkServiceDisabled => '背景服務已停用';

  @override
  String get errServiceNotConnected => '背景服務未連線';

  @override
  String get errUnimplemented => '這項功能尚未提供';

  @override
  String get errUnavailable => '無法連線到背景服務';

  @override
  String errServiceStart(String detail) {
    return '啟動背景服務失敗：$detail';
  }

  @override
  String errServiceRestart(String detail) {
    return '重新啟動背景服務失敗：$detail';
  }

  @override
  String errAutostart(String detail) {
    return '設定開機自動啟動失敗：$detail';
  }

  @override
  String get thisMacTitle => '這台 Mac';

  @override
  String get thisPcTitle => '這台電腦';

  @override
  String get thisMacInText => '這台 Mac ';

  @override
  String get thisPcInText => '這台電腦';

  @override
  String get bothMacs => '兩台 Mac ';

  @override
  String get bothDevices => '兩台裝置';

  @override
  String get thisDeviceShort => '本機';

  @override
  String fromDevice(String name) {
    return '來自 $name';
  }

  @override
  String get cancel => '取消';

  @override
  String get close => '關閉';

  @override
  String get save => '儲存';

  @override
  String get retry => '重試';

  @override
  String get continueAction => '繼續';

  @override
  String get justNow => '剛剛';

  @override
  String secondsAgo(int n) {
    return '$n 秒前';
  }

  @override
  String minutesAgo(int n) {
    return '$n 分鐘前';
  }

  @override
  String hoursAgo(int n) {
    return '$n 小時前';
  }

  @override
  String daysAgo(int n) {
    return '$n 天前';
  }

  @override
  String monthDay(int month, int day) {
    return '$month月$day日';
  }

  @override
  String durationHours(int n) {
    return '$n 小時';
  }

  @override
  String durationDays(int n) {
    return '$n 天';
  }

  @override
  String get historyEmptySubtitle => '在任何一台裝置上複製，內容會出現在這裡';

  @override
  String historyCount(int count) {
    return '共 $count 筆';
  }

  @override
  String historyCountKept(int count, String ttl) {
    return '共 $count 筆，保留 $ttl';
  }

  @override
  String get filterAll => '全部';

  @override
  String get filterText => '文字';

  @override
  String get filterImage => '圖片';

  @override
  String get filterFile => '檔案';

  @override
  String get filterLink => '連結';

  @override
  String get historyClearTooltip => '清空記錄';

  @override
  String get historyEmptyTitle => '還沒有記錄';

  @override
  String get historyEmptyFilteredTitle => '沒有這一類的記錄';

  @override
  String get historyEmptyBody => '在任何一台已配對的裝置上複製文字、圖片或檔案，記錄會出現在這裡。';

  @override
  String get clearConfirmTitle => '要清空全部記錄嗎？';

  @override
  String clearConfirmBody(String device) {
    return '從所有裝置同步過來的記錄和已快取的檔案，都會從$device上刪除。原始檔案不受影響。';
  }

  @override
  String get clear => '清空';

  @override
  String get historyCleared => '記錄已清空';

  @override
  String get permDeniedTitle => '已禁止隔空貼讀取剪貼簿';

  @override
  String get permAskTitle => '允許隔空貼讀取剪貼簿';

  @override
  String get permDeniedBody =>
      '在這台 Mac 上複製的內容不會同步出去。請到系統設定裡把 PasteFerry Daemon 改為「允許」。';

  @override
  String get permAskBody =>
      '否則 macOS 每次都會跳出視窗詢問。請到系統設定裡把 PasteFerry Daemon 改為「允許」。';

  @override
  String get openSystemSettings => '打開系統設定';

  @override
  String get fetch => '接收';

  @override
  String get fetchStarted => '正在接收，可在複製記錄查看進度';

  @override
  String get transferFailed => '傳輸失敗';

  @override
  String get expired => '已過期';

  @override
  String get putOnClipboard => '放入剪貼簿';

  @override
  String get putOnClipboardDone => '已放入剪貼簿';

  @override
  String get deleteRecord => '刪除這筆記錄';

  @override
  String get deleted => '已刪除';

  @override
  String get emptyRecord => '（空）';

  @override
  String get imageRecord => '圖片';

  @override
  String itemsSummary(String name, int others, int count) {
    return '$name 等 $count 項';
  }

  @override
  String get searchHint => '搜尋文字和檔名';

  @override
  String get searchClear => '清除搜尋';

  @override
  String searchResultCount(int count) {
    return '找到 $count 筆';
  }

  @override
  String searchEmptyTitle(String query) {
    return '找不到「$query」';
  }

  @override
  String get searchEmptyBody => '搜尋範圍是複製過的文字和檔名。';

  @override
  String get favoriteAction => '收藏';

  @override
  String get unfavoriteAction => '取消收藏';

  @override
  String get favoritedToast => '已收藏';

  @override
  String get unfavoritedToast => '已放回複製記錄';

  @override
  String get undo => '復原';

  @override
  String get favoriteSaving => '正在儲存…';

  @override
  String favoritedAt(String date) {
    return '收藏於 $date';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    return '$count 筆 · 不會被自動清除 · 最多佔用 $size';
  }

  @override
  String get favoritesEmptyTitle => '還沒有收藏';

  @override
  String get favoritesEmptyBody => '在複製記錄裡點星號，就會在這裡另存一份。收藏不會被自動清除。';

  @override
  String get favoritesSearchHint => '搜尋收藏';

  @override
  String favoriteLargeTitle(String size) {
    return '要另存一份 $size 的內容嗎？';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return '收藏會另存一份，原檔案之後改動或刪除都不影響收藏。這會佔用$device上 $size 的空間。';
  }

  @override
  String get saveCopy => '另存';

  @override
  String clearKeepsFavorites(int count) {
    return '已收藏的 $count 筆會保留。';
  }

  @override
  String get favoritesUsage => '收藏佔用';

  @override
  String get favoritesUsageDesc => '收藏不受上面兩項的限制，不會被自動清除';

  @override
  String upToSize(String size) {
    return '最多 $size';
  }

  @override
  String detailChars(int count) {
    return '$count 字';
  }

  @override
  String detailTruncated(int count) {
    return '…… 共 $count 字';
  }

  @override
  String detailMoreFiles(int count) {
    return '還有 $count 個';
  }

  @override
  String get detailReceiveFirst => '選取後先下載';

  @override
  String detailTotalSize(String size) {
    return '共 $size';
  }

  @override
  String get quickPaste => '快速貼上';

  @override
  String get quickPasteWindow => '快速貼上視窗';

  @override
  String get quickPasteWindowDesc => '在任何程式裡按快速鍵叫出複製記錄，選取即貼上';

  @override
  String get quickPasteShortcut => '快速鍵';

  @override
  String get quickPasteRecord => '按一下錄製';

  @override
  String get quickPasteRecording => '請按下新的快速鍵…';

  @override
  String get quickPasteUseDefault => '恢復預設';

  @override
  String get quickPasteNeedsModifier => '要加上 ⌃、⌥、⇧ 或 ⌘，或者用功能鍵';

  @override
  String get quickPasteNeedsModifierPc => '要加上 Ctrl、Alt、Shift 或 Win 鍵，或者用功能鍵';

  @override
  String get quickPasteAfterPick => '選取後';

  @override
  String get quickPastePasteIt => '直接貼上';

  @override
  String get quickPasteCopyIt => '只放進剪貼簿';

  @override
  String get quickPasteIndexKey => '貼上前 9 筆';

  @override
  String get quickPasteIndexKeyDesc => '在快速貼上視窗裡按住它再按 1–9';

  @override
  String get quickPasteAccessibility => '輔助使用權限';

  @override
  String get quickPasteAccessibilityDesc => '直接貼上需要它；沒有授權時只放進剪貼簿，再由你按 ⌘V';

  @override
  String get quickPasteAllowed => '已授權';

  @override
  String get quickPasteAllow => '去授權';

  @override
  String get quickPasteNotRunning => '快速貼上視窗沒有在執行';

  @override
  String quickPasteInUse(String key) {
    return '$key 已被其他程式佔用，請換一個組合';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return '設定 $key 失敗：$detail';
  }

  @override
  String get quickPastePortalKey => '在系統的快速鍵設定裡修改';

  @override
  String get quickPasteWaylandDesc =>
      'Wayland 下快速鍵要加在桌面的鍵盤設定裡；選取後放進剪貼簿，再按 Ctrl+V 貼上';

  @override
  String get quickPasteAddShortcut => '新增系統快速鍵';

  @override
  String quickPasteShortcutAdded(String key) {
    return '已新增，按 $key 試試';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return '在桌面的鍵盤設定裡新增一個自訂快速鍵，指令填：$command';
  }

  @override
  String get pickerSearch => '搜尋';

  @override
  String get pickerPaste => '貼上';

  @override
  String get pickerPlainText => '純文字';

  @override
  String get pickerCopyOnly => '只複製';

  @override
  String get pickerUnfavoriteHint => '取消收藏（放回複製記錄）';

  @override
  String pickerPasteManually(String key) {
    return '選取後按 $key 貼上';
  }

  @override
  String get pickerGrantHint => '授予「輔助使用」權限後可直接貼上';

  @override
  String pickerElevated(String key) {
    return '這個視窗以系統管理員身分執行，選取後按 $key 貼上';
  }

  @override
  String get pickerDownloading => '正在下載，下載完自動貼上';

  @override
  String get imagePreviewTitle => '圖片預覽';

  @override
  String get closePreview => '關閉預覽';

  @override
  String get previousImage => '上一張';

  @override
  String get nextImage => '下一張';

  @override
  String get previewHint => '用滾輪或觸控板縮放，拖曳查看';

  @override
  String get fitWindow => '符合視窗大小';

  @override
  String get previewDeleted => '這筆圖片記錄已被刪除';

  @override
  String get previewExpired => '圖片已過期，無法預覽';

  @override
  String get previewDownloading => '正在下載圖片…';

  @override
  String get previewDownloadFailed => '圖片下載失敗，請重試';

  @override
  String get previewNotDownloaded => '圖片尚未下載到這台電腦';

  @override
  String get downloadAndPreview => '下載並預覽';

  @override
  String get previewUnavailable => '圖片暫時無法預覽';

  @override
  String get imageSemantic => '複製記錄中的圖片';

  @override
  String get previewUnreadable => '無法讀取圖片，檔案可能已被清除或損毀';

  @override
  String get devicesSubtitleEmpty => '配對之後，裝置之間就會同步剪貼簿';

  @override
  String devicesSubtitle(int paired, int online) {
    return '已配對 $paired 台，$online 台在線上';
  }

  @override
  String get addDevice => '新增裝置';

  @override
  String thisDeviceFootnote(String both) {
    return '配對時，$both會顯示同樣的兩行安全指紋：這台的和對方的。逐字核對一致才能確認。';
  }

  @override
  String get noDevicesTitle => '還沒有配對的裝置';

  @override
  String get noDevicesBody =>
      '在另一台電腦上打開隔空貼，用 6 碼配對碼把兩台連起來。兩台在同一個網路裡時，也可以在兩台上都打開「搜尋附近裝置」，點一下對方。';

  @override
  String get pairedDevices => '已配對的裝置';

  @override
  String get pairedFootnote =>
      '直連：資料在兩台裝置之間直接傳輸。中繼：網路環境打不通直連時，經你的伺服器轉送，內容依然是端對端加密的。';

  @override
  String get offline => '離線';

  @override
  String get direct => '直連';

  @override
  String get relay => '中繼';

  @override
  String get online => '線上';

  @override
  String get moreActions => '更多操作';

  @override
  String get copyFingerprint => '複製安全指紋';

  @override
  String get unpairEllipsis => '解除配對…';

  @override
  String get fingerprintCopied => '安全指紋已複製';

  @override
  String unpairTitle(String name) {
    return '要解除與「$name」的配對嗎？';
  }

  @override
  String get unpairBody => '兩台裝置將不再同步。以後想恢復，需要重新配對並核對指紋。';

  @override
  String get unpair => '解除配對';

  @override
  String get unpaired => '已解除配對';

  @override
  String get enterAddressEllipsis => '輸入它的位址…';

  @override
  String setAddressTitle(String name) {
    return '「$name」的位址';
  }

  @override
  String setAddressBody(String name) {
    return '兩台不在同一網段、或都換了位址時使用。輸入「$name」上「新增裝置 → 產生配對碼」下方顯示的位址。';
  }

  @override
  String get addressSaved => '已記下，正在那個位址上尋找它';

  @override
  String get lanBlockedTitle => 'macOS 阻擋了區域網路存取';

  @override
  String lanBlockedBody(String device) {
    return '在「系統設定 → 隱私權與安全性 → 本機網路」裡開啟 PasteFerry Daemon。開啟之前，$device連不上同一個網路裡的裝置。';
  }

  @override
  String get searchNearby => '搜尋附近裝置';

  @override
  String get nearbyTitle => '附近的裝置';

  @override
  String get nearbySearching => '正在尋找附近的裝置…';

  @override
  String get nearbyHint => '在另一台電腦上也打開「搜尋附近裝置」，它就會出現在這裡，點一下即可配對。';

  @override
  String nearbyVisible(String device) {
    return '這個視窗開著的期間，同一個網路裡的裝置能看到$device的名稱。';
  }

  @override
  String get nearbyPaired => '已配對';

  @override
  String nearbyRequesting(String name) {
    return '正在聯絡「$name」…';
  }

  @override
  String nearbyNoReply(String name) {
    return '「$name」沒有回應。請確認它還開著「搜尋附近裝置」。';
  }

  @override
  String get nearbyLanOffTitle => '區域網路探索已關閉';

  @override
  String get nearbyLanOffBody => '在「設定 → 連線」裡開啟「在區域網路中尋找裝置」才能看到附近的裝置，或者改用配對碼。';

  @override
  String get generateCode => '產生配對碼';

  @override
  String get enterCode => '輸入配對碼';

  @override
  String get codeFailedTitle => '無法產生配對碼';

  @override
  String get enterOnOther => '在另一台裝置上輸入這組配對碼';

  @override
  String get codeCopied => '配對碼已複製';

  @override
  String get codeHint => '點一下即可複製，5 分鐘內有效';

  @override
  String afterEnterFootnote(String both) {
    return '對方輸入後，$both會顯示同樣的兩行安全指紋，核對一致再確認。';
  }

  @override
  String get codeInvalid => '配對碼是 6 個字母或數字';

  @override
  String get localAddress => '本機位址';

  @override
  String get addressHint => '不在同一網段時，另一台還要輸入這個位址';

  @override
  String get addressCopied => '位址已複製';

  @override
  String get differentSubnet => '不在同一網段？';

  @override
  String get peerAddress => '對方配對碼下方顯示的位址';

  @override
  String get pairNotFound => '找不到那台裝置。不在同一網段時，請輸入它配對碼下方顯示的位址。';

  @override
  String get pairNotFoundAddress =>
      '那個位址沒有回應。請檢查位址是否正確、對方是否還停在配對碼畫面；也可能是對方的防火牆擋住了。';

  @override
  String get codeWrong => '配對碼不正確，或已經失效';

  @override
  String get codeExpired => '配對碼已失效，請在另一台上重新產生';

  @override
  String get addressInvalid => '位址格式不正確，應該像 192.168.1.20 這樣';

  @override
  String get pairNoChannel => '請先在「設定 → 連線」裡開啟區域網路探索，或者填寫伺服器位址。';

  @override
  String get enterCodeShown => '輸入另一台裝置上顯示的配對碼';

  @override
  String get pairingDone => '配對完成';

  @override
  String get pairingRejected => '已拒絕配對';

  @override
  String get verifyTitle => '核對安全指紋';

  @override
  String pairingWith(String name) {
    return '正在與「$name」配對';
  }

  @override
  String verifyBody(String both) {
    return '$both上顯示的這兩行應該完全相同。只要有任何一個字元不同，就表示連線可能遭到第三方竄改，請拒絕。';
  }

  @override
  String get rejectMismatch => '不一致，拒絕';

  @override
  String get confirmMatch => '一致，確認配對';

  @override
  String get server => '伺服器（選用）';

  @override
  String get signalingUrl => '信令伺服器位址';

  @override
  String get signalingUrlDesc => '留空僅在區域網路同步';

  @override
  String get signalingUrlPlaceholder => 'ws://伺服器位址:8787/signal';

  @override
  String get publicStun => '改善公網直接連線';

  @override
  String get publicStunDesc => '公共伺服器可見本機的公用 IP';

  @override
  String get connectionStatus => '連線狀態';

  @override
  String get disconnectedDesc => '請檢查位址與伺服器狀態';

  @override
  String get connected => '已連線';

  @override
  String get notConnected => '未連線';

  @override
  String get notSet => '未設定';

  @override
  String get serverCleared => '已清除伺服器位址，只在區域網路裡同步';

  @override
  String get localNetwork => '區域網路';

  @override
  String get lanDiscovery => '在區域網路中尋找裝置';

  @override
  String get lanDiscoveryDesc => '匿名探索，僅搜尋附近裝置時顯示名稱';

  @override
  String get macLocalNetwork => '本機網路權限';

  @override
  String get macLocalNetworkDesc => '在系統設定中允許 PasteFerry Daemon';

  @override
  String get allowLan => 'Windows 防火牆';

  @override
  String get allowLanDesc => '連線受阻時允許連入，需系統管理員權限';

  @override
  String get allow => '允許';

  @override
  String get allowLanDone => '已允許，其他裝置現在可以連到這台了';

  @override
  String get deviceName => '裝置名稱';

  @override
  String get language => '語言';

  @override
  String get languageSystem => '跟隨系統';

  @override
  String get sync => '同步';

  @override
  String get autoSyncLimit => '自動同步上限';

  @override
  String get autoSyncLimitDesc => '超過上限後，在複製記錄中手動接收';

  @override
  String get autoApply => '收到後直接寫入剪貼簿';

  @override
  String get whatToSync => '同步哪些內容';

  @override
  String get syncFiles => '檔案與資料夾';

  @override
  String get syncText => '純文字';

  @override
  String get syncRich => '帶格式的文字';

  @override
  String get syncImages => '圖片與螢幕截圖';

  @override
  String get storage => '儲存空間';

  @override
  String get storageFootnote => '到期自動清除記錄與快取。';

  @override
  String get keepHistory => '記錄保留';

  @override
  String get keepCache => '快取檔案保留';

  @override
  String get keepCacheDesc => '不超過記錄保留時間';

  @override
  String get cacheUsage => '快取佔用';

  @override
  String get backgroundSync => '背景同步';

  @override
  String get backgroundService => '背景服務';

  @override
  String get backgroundServiceDesc => '登入自動啟動，關閉視窗後繼續同步';

  @override
  String get restart => '重新啟動';

  @override
  String get restarted => '背景服務已重新啟動';

  @override
  String get disableEllipsis => '停用…';

  @override
  String get about => '關於';

  @override
  String get aboutDesc => '開源軟體，採用 AGPL-3.0 授權';

  @override
  String get homepage => '專案首頁';

  @override
  String get feedback => '回報問題';

  @override
  String get disableTitle => '要停用背景同步嗎？';

  @override
  String disableBody(String device) {
    return '$device將停止同步，也不會再開機自動啟動。歷史記錄和配對關係會保留。';
  }

  @override
  String get disable => '停用';

  @override
  String get disabled => '背景同步已停用';

  @override
  String get urlMustBeWs => '位址必須以 ws:// 或 wss:// 開頭';

  @override
  String get serverUpdated => '伺服器位址已更新，正在重新連線';

  @override
  String get deviceNameUpdated => '裝置名稱已更新';

  @override
  String get diagIntro =>
      '報告裡有版本、系統、設定、裝置狀態和最近的記錄檔。裝置名稱、伺服器位址、公用 IP、使用者資料夾和檔名都已替換，複製的內容從不寫進記錄檔。GitHub 上的問題是公開的，貼出去之前請看一遍。';

  @override
  String get diagVerboseTitle => '詳細記錄檔';

  @override
  String get diagVerboseDesc => '連線方面的問題常要看它：開啟後重現一次問題，再回來產生報告。30 分鐘後自動關閉。';

  @override
  String get diagVerboseOn => '開啟 30 分鐘';

  @override
  String diagVerboseUntil(String time) {
    return '已開啟，$time 自動關閉';
  }

  @override
  String get diagVerboseOff => '關閉';

  @override
  String get diagRefresh => '重新產生';

  @override
  String get diagSave => '儲存為檔案';

  @override
  String diagSaved(String name) {
    return '已儲存到「下載」資料夾：$name';
  }

  @override
  String get diagCopy => '複製報告';

  @override
  String get diagCopied => '報告已複製';

  @override
  String get diagNewIssue => '在 GitHub 上回報';

  @override
  String get diagIssueHint => '報告已複製，貼到問題裡的「診斷報告」一欄';

  @override
  String diagFailed(String detail) {
    return '產生報告失敗：$detail';
  }

  @override
  String get svcExtractTitle => '先解壓縮或安裝隔空貼';

  @override
  String get svcExtractBody =>
      '隔空貼現在是直接從壓縮檔裡打開的，關掉之後它所在的暫存資料夾就會被刪除。執行安裝程式，或者把整個資料夾解壓縮出來再打開，就可以啟用背景同步。';

  @override
  String get svcMoveTitle => '先把隔空貼移到「應用程式」';

  @override
  String get svcMoveBody =>
      '隔空貼現在是直接從磁碟映像檔裡打開的。把它拖進「應用程式」資料夾，退出磁碟映像檔，再從「應用程式」裡打開，就可以啟用背景同步。';

  @override
  String get svcStartTitle => '開始使用隔空貼';

  @override
  String get svcStartBody => '隔空貼透過背景程序同步剪貼簿，關閉視窗後仍會執行。開機啟動可在設定裡單獨選擇，新安裝預設關閉。';

  @override
  String get svcEnable => '啟用背景同步';

  @override
  String get svcStaleTitle => '重新啟用背景同步';

  @override
  String get svcStaleBodyWin =>
      '隔空貼換了位置，開機自動啟動還指向原來的地方。重新啟用一次，讓背景程序指向目前這份隔空貼。歷史記錄與配對關係都會保留。';

  @override
  String get svcStaleBodyMac =>
      '隔空貼換了位置，或者之前用舊版安裝腳本裝過。重新啟用一次，讓背景程序指向目前這個 App。歷史記錄與配對關係都會保留。';

  @override
  String get svcReenable => '重新啟用';

  @override
  String get svcStoppedTitle => '背景服務沒有在執行';

  @override
  String get svcStoppedBody => '背景服務已停止。點下面的按鈕啟動；是否開機啟動可在設定裡單獨選擇。';

  @override
  String get svcDevBodyWin =>
      '這是開發版本，旁邊沒有 pasteferryd.exe。在原始碼資料夾執行 scripts\\build-windows.ps1 建置完整的版本。';

  @override
  String get svcDevBodyLinux =>
      '這是開發版本，旁邊沒有 pasteferryd。在原始碼資料夾執行 ./scripts/package-linux.sh 建置完整的版本。';

  @override
  String get svcDevBodyMac =>
      '這是開發版本，App 裡沒有內建背景服務。在原始碼資料夾執行 ./scripts/install-macos.sh 安裝它。';

  @override
  String svcLogPath(String path) {
    return '記錄檔：$path';
  }

  @override
  String get svcCanDisable => '隨時可以在「設定」中停用背景同步。';

  @override
  String get officialService => '服務';

  @override
  String get useOfficialService => '使用服務';

  @override
  String get officialServiceDesc => '跨網路同步，優先直連';

  @override
  String get officialPrivacy =>
      '僅開啟後連線服務並記錄必要的連線資訊。先嘗試直連，失敗才申請中繼；不傳送內容、真實裝置名稱或原始系統識別碼。';

  @override
  String get officialEnableTitle => '啟用服務？';

  @override
  String get officialSwitchConfirm => '這會切換目前的自訂伺服器，已儲存的位址仍會保留。';

  @override
  String get customServer => '自訂伺服器';

  @override
  String get saveAndConnect => '儲存並連線';

  @override
  String get officialLoading => '正在取得額度…';

  @override
  String get officialFetchFailed => '暫時無法取得額度，會自動重試。';

  @override
  String get officialUnavailable => '用量暫時無法取得，現有資料可能過期';

  @override
  String get officialQuotaTitle => '今日中繼額度已用完';

  @override
  String get officialQuotaBody => '服務中繼已暫停，北京時間午夜重設。區域網路和公網直連仍可使用；傳輸失敗時可稍後重試。';

  @override
  String get officialPeerQuota => '對方中繼額度不足，直連仍可使用';

  @override
  String get officialPaused => '服務中繼暫時無法使用，直連仍可使用';

  @override
  String get officialViewUsage => '查看用量';

  @override
  String get officialAcknowledge => '知道了';

  @override
  String get officialToday => '今日中繼額度';

  @override
  String get officialUsed => '已使用';

  @override
  String get officialRemaining => '剩餘額度';

  @override
  String get officialDailyLimit => '每日額度';

  @override
  String get officialUpload => '上傳';

  @override
  String get officialDownload => '下載';

  @override
  String get officialReset => '重設時間（北京時間）';

  @override
  String get officialUpdated => '上次更新';

  @override
  String get officialRoutes => '裝置連線方式';

  @override
  String get officialRoutesFootnote => '直連時不經過服務中繼，也不消耗額度。';

  @override
  String get officialDeviceID => '裝置 ID';

  @override
  String get officialWarning => '今日中繼額度已使用 90%，直連不消耗此額度。';

  @override
  String get updateCheck => '檢查更新';

  @override
  String get updateCheckEllipsis => '檢查更新…';

  @override
  String get updateAuto => '自動檢查更新';

  @override
  String get updateChecking => '正在檢查更新…';

  @override
  String updateUpToDate(String version) {
    return '隔空貼 $version 已是最新版本。';
  }

  @override
  String updateAvailableTitle(String version) {
    return '有新版本：隔空貼 $version';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return '目前版本 $current，需要下載 $size。';
  }

  @override
  String get updateNew => '新增';

  @override
  String get updateFixed => '修正';

  @override
  String get updateSkip => '略過這個版本';

  @override
  String get updateLater => '以後再說';

  @override
  String get updateInstall => '下載並安裝';

  @override
  String updateDownloading(String done, String total) {
    return '正在下載 $done / $total';
  }

  @override
  String get updateVerifying => '正在驗證下載的檔案…';

  @override
  String get updateInstalling => '正在安裝，隔空貼會自動重新開啟。';

  @override
  String get updateInstallingPassword =>
      '正在安裝。安裝到 /opt 需要系統管理員權限，系統會請你輸入密碼，之後隔空貼會自動重新開啟。';

  @override
  String get updateCheckFailed => '暫時連不上 GitHub 和 Gitee，請稍後再試。';

  @override
  String get updateDownloadFailed => '下載沒有完成。可以重試，或到下載頁手動下載新版本。';

  @override
  String updateInstallFailed(String error) {
    return '沒能開始安裝：$error';
  }

  @override
  String get updateUnsupportedBuild => '這個版本不支援檢查更新。';

  @override
  String get updateBlockedDev => '這是開發版本，不能自動更新。';

  @override
  String get updateBlockedMustMove =>
      '隔空貼是直接從磁碟映像檔裡開啟的。把它拖到「應用程式」資料夾、從那裡開啟後，就能自動更新。';

  @override
  String get updateBlockedReadOnly => '隔空貼所在的資料夾無法寫入，沒辦法自動更新。請到下載頁手動下載新版本。';

  @override
  String get updateBlockedUnsupported => '這台電腦沒有可用的自動更新安裝檔，請到下載頁手動下載新版本。';

  @override
  String get updateOpenDownload => '開啟下載頁';

  @override
  String updateSidebar(String version) {
    return '新版本 $version 可用';
  }

  @override
  String updatedTo(String version) {
    return '已更新到 $version';
  }

  @override
  String updateNotFinished(String version) {
    return '更新沒有完成，仍是 $version。';
  }

  @override
  String updateNotFinishedWhy(String version, String detail) {
    return '更新沒有完成，仍是 $version。$detail';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return '介面 $uiVersion · 背景服務 $serviceVersion · 建置 $build';
  }

  @override
  String get notReceived => '尚未接收，暫不可貼上';

  @override
  String get receivedPreserved => '已接收，點選放入剪貼簿後即可貼上';

  @override
  String get clipboardWriteFailed => '已接收，但無法寫入剪貼簿';

  @override
  String get receivingStatus => '正在接收…';

  @override
  String get largeFileNotifications => '大檔案接收提醒';

  @override
  String get notificationsAllowed => '已允許系統通知，接收進度可在複製記錄中查看。';

  @override
  String get notificationsNotRequested => '開啟系統通知，避免大檔案等待接收時沒有提醒；也可隨時從複製記錄接收。';

  @override
  String get notificationsDenied => '系統通知已關閉，請在系統設定中開啟；待接收內容仍可從複製記錄接收。';

  @override
  String get notificationsUnknown => '通知顯示和勿擾由系統控制；未看到提醒時，可在複製記錄中接收。';

  @override
  String get notificationsUnavailable => '系統通知暫時無法使用，請從複製記錄接收大檔案。';

  @override
  String get enableNotifications => '開啟提醒';

  @override
  String get notificationSettings => '通知設定';

  @override
  String get notifyPendingTitle => '接收後即可貼上';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\n尚未接收，暫不可貼上。也可從複製記錄接收。';
  }

  @override
  String get notifyReceivingTitle => '正在接收…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\n可在複製記錄查看接收進度。';
  }

  @override
  String get notifyReadyTitle => '已就緒，可以貼上';

  @override
  String notifyReadyBody(String name) {
    return '$name\n已接收並放入剪貼簿。';
  }

  @override
  String get notifyReceivedTitle => '已接收';

  @override
  String notifyReceivedBody(String name) {
    return '$name\n已保留目前剪貼簿，點選放入剪貼簿後即可貼上，也可從複製記錄操作。';
  }

  @override
  String get notifyFailedTitle => '接收失敗';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\n可從此通知或複製記錄重試。';
  }

  @override
  String get notifyClipboardFailedTitle => '已接收，但無法寫入剪貼簿';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\n可從此通知或複製記錄重新放入剪貼簿。';
  }

  @override
  String get reconnect => '重新連線';

  @override
  String get reconnecting => '正在連線…';

  @override
  String get reconnectDirect => '已直連';

  @override
  String get reconnectRelay => '直連沒有打通，繼續經中繼';

  @override
  String reconnectOffline(String name) {
    return '「$name」不在線上，請確認它那邊已開啟隔空貼';
  }

  @override
  String get reconnectPending => '仍在連線，請稍後再看';

  @override
  String get renameAction => '重新命名';

  @override
  String get renameFavoriteTitle => '重新命名收藏';

  @override
  String get renameFavoriteHint => '收藏和快速貼上裡顯示這個名稱，搜尋也找得到。留空則恢復顯示內容。';

  @override
  String get renamedToast => '已重新命名';

  @override
  String get aliasClearedToast => '已恢復顯示內容';

  @override
  String get navSend => '隔空傳送';

  @override
  String get sendSubtitle => '把檔案拖到一台裝置上，直接傳過去';

  @override
  String get sendNoDevicesTitle => '還沒有配對的裝置';

  @override
  String get sendNoDevicesBody => '先配對另一台電腦，之後就能在這裡傳檔案給它。';

  @override
  String get sendDropHint => '拖到一台裝置上傳送';

  @override
  String sendReleaseTo(String name) {
    return '放開以傳送到 $name';
  }

  @override
  String get sendLan => '區域網路';

  @override
  String sendRelayLeft(String left) {
    return '中繼 · 今日剩 $left';
  }

  @override
  String get sendNeedsUpdate => '需要更新';

  @override
  String sendNeedsUpdateTip(String name) {
    return '$name 更新到隔空貼 2.5 或更新版本後才能接收檔案。';
  }

  @override
  String sendConnectingTip(String name) {
    return '正在連線 $name，連上後就能傳送。';
  }

  @override
  String get sendNotReceiving => '不接收檔案';

  @override
  String get sendDelivered => '已送達';

  @override
  String sendToTitle(String name) {
    return '傳送到 $name';
  }

  @override
  String get sendDropHere => '把檔案或資料夾拖到這裡';

  @override
  String get sendDropStarts => '放開就開始傳送';

  @override
  String get sendChooseFiles => '選擇檔案…';

  @override
  String get sendChooseFolder => '選擇資料夾…';

  @override
  String get sendDropMore => '繼續拖入檔案，排在後面傳送';

  @override
  String sendSavedWhere(String name) {
    return '檔案會存到 $name 設定的位置，預設是「下載項目」檔案夾。';
  }

  @override
  String get sendCloseKeeps => '關閉視窗不影響傳送';

  @override
  String get sendRemoveQueued => '移除';

  @override
  String get sendCannotDrop => '這個項目不能直接拖過來傳送。請先把它存成檔案，或使用「選擇檔案…」。';

  @override
  String sendErrOffline(String name) {
    return '$name 不在線上。';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name 關閉了接收檔案。';
  }

  @override
  String get sendErrMissing => '有檔案已經不在了。';

  @override
  String get relayConfirmTitle => '經服務中繼傳送？';

  @override
  String relayConfirmBody(String name, String left) {
    return '$name 目前和這台電腦沒有直連，檔案要經服務中繼，速度約 0.25 MB/s。今天的中繼額度還剩 $left。';
  }

  @override
  String relayConfirmOver(String size) {
    return '這些檔案（$size）超出了今天剩餘的額度。傳到額度用完時會暫停；兩台電腦連上直連、或明天額度恢復後，自動繼續。';
  }

  @override
  String relayConfirmWithin(String size) {
    return '這次大約用掉今天額度中的 $size。';
  }

  @override
  String get relayExhausted => '今天的中繼額度已用完，北京時間 0 點恢復。兩台電腦連上直連後不受限制。';

  @override
  String get relayDontAskToday => '今天傳給這台裝置時不再詢問';

  @override
  String get relaySendAnyway => '仍然傳送';

  @override
  String get relayOwnServer => '中繼，速度取決於你的伺服器頻寬';

  @override
  String get transfersReceived => '收到的';

  @override
  String get transfersSent => '傳出的';

  @override
  String get transfersClearAll => '全部清除';

  @override
  String get transfersClearTitle => '清除這個列表？';

  @override
  String get transfersClearBody => '只清除紀錄，檔案不會被刪除。';

  @override
  String get transfersEmptyReceived => '其他裝置傳來的檔案會出現在這裡';

  @override
  String get transfersEmptySent => '你傳出的檔案會出現在這裡';

  @override
  String transferFrom(String name) {
    return '來自 $name';
  }

  @override
  String transferTo(String name) {
    return '傳給 $name';
  }

  @override
  String transferItems(String name, int total, int others) {
    return '$name 等 $total 項';
  }

  @override
  String transferFileCount(int count) {
    return '$count 個檔案';
  }

  @override
  String get transferQueued => '排隊中';

  @override
  String transferScanning(String count) {
    return '正在統計… 已找到 $count 個檔案';
  }

  @override
  String transferWaitingPeer(String name) {
    return '正在聯絡 $name…';
  }

  @override
  String get transferSending => '正在傳送';

  @override
  String get transferReceiving => '正在接收';

  @override
  String transferCurrent(String file, String index, String total) {
    return '正在傳：$file（第 $index / $total 個）';
  }

  @override
  String transferLeft(String time) {
    return '還剩 $time';
  }

  @override
  String etaSeconds(int n) {
    return '$n 秒';
  }

  @override
  String etaMinutes(int n) {
    return '$n 分鐘';
  }

  @override
  String etaHours(int h, int m) {
    return '$h 小時 $m 分';
  }

  @override
  String get transferPaused => '已暫停：今天的中繼額度用完了';

  @override
  String get transferInterrupted => '已中斷，重新連上後繼續';

  @override
  String transferInterruptedIncoming(String name) {
    return '已中斷 · 等 $name 繼續';
  }

  @override
  String get transferCancelled => '已取消';

  @override
  String transferPeerCancelled(String name) {
    return '$name 取消了';
  }

  @override
  String get transferExpired => '已過期';

  @override
  String get transferMissing => '已移動或刪除';

  @override
  String transferNotSent(String reason) {
    return '沒有傳出：$reason';
  }

  @override
  String transferNotReceived(String reason) {
    return '沒有收下：$reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return '$name 的磁碟空間不足，還差 $size';
  }

  @override
  String reasonNoSpace(String size) {
    return '磁碟空間不足，還差 $size';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return '$name 的儲存位置無法使用';
  }

  @override
  String get reasonDestUnavailable => '儲存位置無法使用，請在設定中檢查';

  @override
  String get reasonFileTooLarge => '儲存位置在 FAT32 格式的磁碟上，放不下超過 4 GB 的檔案';

  @override
  String reasonDisabledPeer(String name) {
    return '$name 關閉了接收檔案';
  }

  @override
  String get reasonSourceChanged => '傳送過程中有檔案被修改了';

  @override
  String get reasonSourceMissing => '有檔案已經不在了';

  @override
  String get reasonReadError => '有檔案讀取失敗';

  @override
  String get reasonWriteFailed => '檔案寫入失敗';

  @override
  String get reasonHashMismatch => '有檔案在傳輸中損毀了';

  @override
  String reasonUnsupported(String name) {
    return '$name 需要更新才能接收檔案';
  }

  @override
  String get reasonOther => '出了點問題';

  @override
  String get revealInFinder => '在 Finder 中顯示';

  @override
  String get revealInFolder => '在資料夾中顯示';

  @override
  String get revealOpenFolder => '打開資料夾';

  @override
  String get transferResend => '重新傳送';

  @override
  String get transferRemove => '從列表中移除';

  @override
  String get transferCopyPath => '拷貝路徑';

  @override
  String get transferPathCopied => '已拷貝路徑';

  @override
  String sendingTo(String name, String percent) {
    return '正在傳給 $name · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return '正在接收 $name 的檔案 · $percent';
  }

  @override
  String get receiveFiles => '接收其他裝置傳來的檔案';

  @override
  String get saveTo => '儲存到';

  @override
  String get saveToChange => '更改…';

  @override
  String get saveToDefault => '下載項目（預設）';

  @override
  String get saveToUseDefault => '改回「下載項目」';

  @override
  String get receiveNotify => '收到檔案時通知';

  @override
  String receiveFootnote(String device) {
    return '只有已配對的裝置能傳檔案給$device。傳輸期間$device不會自動睡眠。';
  }

  @override
  String get saveDirNotFound => '這個資料夾不存在。';

  @override
  String get saveDirNotWritable => '隔空貼無法把檔案存到這個資料夾。';

  @override
  String get saveDirPermission =>
      '隔空貼還沒有使用這個資料夾的權限。請在「系統設定 → 隱私權與安全性 → 檔案與資料夾」中允許。';

  @override
  String transferRenamed(int count) {
    return '$count 個檔名含 Windows 不支援的字元，已換成相近的全形字元';
  }

  @override
  String get sendRingLan => '同一網路';

  @override
  String get sendRingOther => '其他網路';

  @override
  String sendOfflineList(String names) {
    return '離線：$names';
  }

  @override
  String get listSeparator => '、';

  @override
  String get sendLayout => '傳輸列表';

  @override
  String get sendLayoutSide => '在雷達右邊';

  @override
  String get sendLayoutBelow => '在雷達下面';

  @override
  String get general => '一般';

  @override
  String get launchAtLogin => '開機啟動';

  @override
  String get launchAtLoginDesc => '登入電腦後在背景啟動，不開啟主視窗。變更此項不會停止目前的執行。';

  @override
  String get realtimeSync => '即時同步剪貼簿';

  @override
  String get realtimeSyncDesc => '自動與配對裝置同步新複製的內容。關閉後仍保留本機記錄，也可手動隔空傳送。';

  @override
  String get syncBacklog => '重新連線後補傳離線內容';

  @override
  String get syncBacklogDesc =>
      '預設關閉：離線期間未送達的內容不再補傳。開啟後最多補傳 24 小時內的 20 筆記錄，不覆寫目前的剪貼簿。';

  @override
  String get peerRealtimeSync => '與這台電腦即時同步';

  @override
  String get syncPaused => '剪貼簿同步已暫停';

  @override
  String get quitApp => '結束隔空貼';

  @override
  String get quitAppDesc => '結束隔空貼的全部程序，保留開機啟動設定。';

  @override
  String get quitTransfersWarning => '還有檔案正在傳輸，要中斷傳輸並結束嗎？';

  @override
  String get backgroundRunningTitle => '隔空貼將繼續在背景執行';

  @override
  String get backgroundRunningBody =>
      '關閉視窗後，同步和快速貼上仍會執行。如需完全停止，請在設定或應用程式選單選擇「結束隔空貼」。';

  @override
  String get displayAs => '顯示為';

  @override
  String get editName => '修改名稱';

  @override
  String get nameHint => '好友看到的名稱';

  @override
  String get nameDefaultHint => '留空則使用系統的使用者名稱。';

  @override
  String get avatarTitle => '設定頭像';

  @override
  String get avatarChoose => '選擇圖片…';

  @override
  String get avatarPaste => '貼上圖片';

  @override
  String get avatarReset => '恢復預設頭像';

  @override
  String get avatarZoom => '縮放';

  @override
  String get avatarDragHint => '拖曳可以移動圖片。';

  @override
  String get avatarNoImage => '剪貼簿裡沒有圖片。';

  @override
  String get avatarBad => '這張圖片無法使用，請換一張 PNG、JPEG 或 GIF。';

  @override
  String get done => '完成';

  @override
  String get friendsTitle => '好友';

  @override
  String get addFriend => '新增好友';

  @override
  String get friendsEmpty => '還沒有好友';

  @override
  String get friendsEmptyBody => '加了好友，就能互相傳檔案，不用配對。好友只能傳檔案，看不到你的剪貼簿。';

  @override
  String get friendSendAction => '傳送…';

  @override
  String get friendHistory => '傳輸記錄';

  @override
  String friendHistoryTitle(String name) {
    return '和 $name 的傳輸';
  }

  @override
  String get friendHistoryEmpty => '還沒有傳過檔案。';

  @override
  String get friendAutoAccept => '自動接收此好友的檔案';

  @override
  String get friendRemove => '刪除好友';

  @override
  String friendRemoveTitle(String name) {
    return '刪除好友「$name」？';
  }

  @override
  String get friendRemoveBody => '雙方都會刪除對方，之後互相傳不了檔案。以前的傳輸記錄仍留在這台電腦上。';

  @override
  String friendLastActivity(String time) {
    return '$time傳過';
  }

  @override
  String get friendNoActivity => '還沒傳過檔案';

  @override
  String get friendCodeShare => '把這個碼傳給好友，對方在隔空貼裡輸入後，你們就成為好友。';

  @override
  String friendCodeExpires(String time) {
    return '$time 後失效';
  }

  @override
  String get friendCodeOr => '或者';

  @override
  String get friendCodeEnter => '輸入對方的好友碼';

  @override
  String get friendCodeAdd => '新增';

  @override
  String get friendCodeWaiting => '等待對方輸入…';

  @override
  String friendConfirmBody(String name) {
    return '新增 $name 為好友？';
  }

  @override
  String get friendSafetyCode => '核對安全碼（選填）';

  @override
  String get friendSafetyHint => '面對面時可以核對：兩邊顯示的這兩行一樣，就沒有被人調包。';

  @override
  String get friendWaitingPeer => '等待對方新增…';

  @override
  String friendAdded(String name) {
    return '已新增 $name 為好友';
  }

  @override
  String friendPeerCancelled(String name) {
    return '$name 取消了';
  }

  @override
  String get friendErrFriendCode => '這是好友碼，請在隔空傳送頁的「新增好友」裡輸入。';

  @override
  String get friendErrDeviceCode => '這是配對碼，請在「裝置 → 新增裝置」裡輸入。';

  @override
  String get friendErrOutdated => '對方需要更新到隔空貼 2.6.0 或更新版本。';

  @override
  String get friendErrAlreadyPaired => '這台電腦已經是你的裝置。';

  @override
  String get friendErrNoChannel => '你們不在同一個區域網路，雙方都開啟「服務」後才能新增。';

  @override
  String get openService => '開啟服務…';

  @override
  String get noteLabel => '備註（選填）';

  @override
  String get noteHintEmpty => '先選擇要傳送的檔案';

  @override
  String get noteHint => '例如：合約第 3 頁要簽名';

  @override
  String noteLine(String note) {
    return '備註：$note';
  }

  @override
  String get sendAction => '傳送';

  @override
  String sendItemsSummary(String count, String size) {
    return '共 $count 項 · $size';
  }

  @override
  String sendDropOrPaste(String key) {
    return '把檔案或圖片拖到這裡，或貼上（$key）';
  }

  @override
  String get sendDropMorePaste => '繼續拖入或貼上';

  @override
  String get sendPasteNothing => '剪貼簿裡沒有檔案或圖片。';

  @override
  String get sendRemoveItem => '移除';

  @override
  String sendFriendSaved(String name) {
    return '對方按「接受」後才開始傳送。';
  }

  @override
  String transferAskingOut(String name) {
    return '等待 $name 接受…';
  }

  @override
  String get transferAskingIn => '等你接受';

  @override
  String reasonDeclined(String name) {
    return '$name 拒絕了';
  }

  @override
  String reasonTimeout(String name) {
    return '$name 沒有回應';
  }

  @override
  String reasonNotAllowed(String name) {
    return '$name 不接收檔案';
  }

  @override
  String reasonRateLimited(String name) {
    return '$name 暫時不接收你的檔案';
  }

  @override
  String get reasonYouDeclined => '已拒絕';

  @override
  String get reasonYouIgnored => '已忽略';

  @override
  String get sendAgain => '再傳一次';

  @override
  String incomingTitle(String name) {
    return '$name 想傳檔案給你';
  }

  @override
  String get incomingAlways => '以後自動接收此好友的檔案';

  @override
  String get incomingDecline => '拒絕';

  @override
  String get incomingAccept => '接受';

  @override
  String incomingCountdown(String seconds) {
    return '$seconds 秒後自動拒絕';
  }

  @override
  String get incomingStranger => '附近的裝置';

  @override
  String get friendsStrip => '好友';

  @override
  String get strangersStrip => '附近開著「所有人」的裝置';

  @override
  String get strangerNearby => '附近';

  @override
  String get friendNeedService => '需要開啟服務';

  @override
  String get friendCantReach => '無法連線';

  @override
  String reachSelfNoService(String name) {
    return '你和 $name 不在同一個區域網路。開啟服務後就能傳檔案給對方，直連不了時經服務中繼。';
  }

  @override
  String reachPeerNoService(String name) {
    return '$name 沒有開啟服務，不在同一個區域網路時傳不了。請對方在隔空貼裡開啟服務。';
  }

  @override
  String get reachDifferentServer => '你們用的不是同一台伺服器。雙方都開啟服務，或者改用同一台伺服器後就能傳。';

  @override
  String get receiveFromLabel => '允許這些人傳檔案給我：';

  @override
  String get receiveFromOff => '均不允許';

  @override
  String get receiveFromFriends => '僅限好友';

  @override
  String get receiveFromEveryone => '所有人';

  @override
  String everyoneLeft(String minutes) {
    return '所有人 · 還剩 $minutes 分鐘';
  }

  @override
  String get receiveFromOffDesc => '只有你配對的電腦能傳。';

  @override
  String get receiveFromFriendsDesc => '好友能傳，每次由你接受。';

  @override
  String get receiveFromEveryoneDesc => '同一區域網路裡的人都能傳，每次由你接受；10 分鐘後改回「僅限好友」。';

  @override
  String get everyoneEnded => '「所有人」已結束，改回「僅限好友」。';

  @override
  String get friendsCountTooltip => '好友';

  @override
  String get waitingAccept => '等待接受';

  @override
  String get settingsConnection => '連線';

  @override
  String get settingsGeneralSummary => '開機啟動、裝置名稱、語言';

  @override
  String get settingsConnectionSummary => '服務、自架伺服器、區域網路';

  @override
  String get settingsSyncSummary => '即時同步、自動同步上限、同步哪些內容';

  @override
  String get settingsQuickPasteSummary => '快速鍵、選取後的動作';

  @override
  String get settingsSendSummary => '接收檔案、儲存位置';

  @override
  String get settingsStorageSummary => '記錄保留多久、佔用空間';

  @override
  String get settingsAboutSummary => '版本、更新、回報';

  @override
  String get friendsSubtitle => '傳檔案給別人的電腦，不用配對';

  @override
  String get friendsSearch => '搜尋好友';

  @override
  String get friendsNoMatch => '沒有找到這個好友';

  @override
  String get friendsPick => '選一個好友，查看傳輸記錄或傳檔案';

  @override
  String friendDropHint(String name) {
    return '放開即可傳給 $name';
  }
}
