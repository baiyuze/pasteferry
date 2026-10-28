# 隔空贴 Android：手机 → 电脑的发送入口

> 调研稿 · 2026-10-19 · 补充 [mobile-clients.md](mobile-clients.md) 第 2.1 节
>
> 依据：Android 官方文档、AOSP 与 Chromium 源码（main 分支）、KDE Connect 与 SyncClipboard Mobile 的源码和 issue。**未做真机验证**，标注“待验证”的条目需要在第 7 节的真机上确认。

## 1. 结论

Android 10 起，后台读取其他 App 剪贴板的权限 `READ_CLIPBOARD_IN_BACKGROUND` 只给系统角色，普通 App 拿不到；前台服务、常驻通知都不解除这个限制。手机 → 电脑只能走两类入口：

- **用户点一下，隔空贴短暂拿到窗口焦点后读取剪贴板**：通知按钮、快捷设置磁贴、桌面快捷方式。
- **系统直接把内容交给隔空贴，不经过剪贴板**：文字选择菜单、系统分享。

推荐首版提供以下入口，位置固定，不随版本挪动：

| 入口 | 用户操作 | 微信里能用 | 定位 |
|---|---|---|---|
| 快捷设置磁贴“发送剪贴板” | 复制 → 下拉控制中心 → 点磁贴 | 能 | 主入口 |
| 常驻通知上的“发送剪贴板”按钮 | 复制 → 下拉通知栏 → 点按钮 | 能 | 主入口 |
| 长按图标快捷方式 / 桌面小组件 | 复制 → 回桌面 → 点 | 能 | 主入口的备用 |
| 系统分享 + 每台电脑一个直接分享目标 | 分享 → 点“发送到 MacBook” | 能（图片、文件、链接） | 图片和文件的主入口 |
| 文字选择菜单“隔空贴” | 选中文字 → 点“隔空贴” | **不能** | 浏览器等场景的捷径 |
| 打开隔空贴时发送剪贴板 | 复制 → 打开隔空贴 | 能 | 可选，默认关 |

手机上最常见的“微信里复制”，实际是“复制 + 下拉 + 点一下”。对外按这个说法宣传，不说“手机复制后电脑自动就有”。

悬浮球、Shizuku 后台读取作为高级选项以后再评估；READ_LOGS、无障碍、自研输入法不做（见第 5 节）。

## 2. 各入口

### 2.1 快捷设置磁贴

- `TileService.onClick()` → `unlockAndRun()` → `startActivityAndCollapse(PendingIntent)` 拉起透明读取页（第 3 节）。
  - targetSdk 34 起，传 `Intent` 的旧重载会抛 `UnsupportedOperationException`，必须用 `PendingIntent` 版本（API 34 新增）。
  - 锁屏时读取剪贴板一律返回 null，所以先 `unlockAndRun()`。
  - targetSdk 35 起，PendingIntent 的创建方默认不再带后台启动权限。磁贴拉起 Activity 是否受影响，要在 Android 15+ 真机上确认，必要时用 `ActivityOptions` 设置创建方的后台启动模式。
- Android 13+ 用 `StatusBarManager.requestAddTileService()` 弹窗请用户添加磁贴：
  - 调用时 App 必须在前台；
  - 用户多次拒绝后系统可能自动拒绝；
  - 国产系统上能否弹出待验证，失败时退回图文教程。
- 已知问题：
  - SyncClipboard 有一例在一加平板（ColorOS 16、Android 16）上，磁贴读到空剪贴板，桌面快捷方式正常；同系统的 OPPO 手机没问题。
  - KDE Connect 在 2026-10 才补上 `onStartListening` 里刷新磁贴状态。

### 2.2 常驻通知按钮

- 按钮直接用 `PendingIntent.getActivity()` 拉起透明读取页。
  - targetSdk 31 起，不能先发广播或启动 Service 再由它们 `startActivity()`（通知跳板限制）。
  - Activity 类型的 PendingIntent 被点击时，系统会先要求解锁，再自动收起通知栏。
- 这条通知不能是唯一入口：
  - Android 13 起前台服务通知可以划掉；Android 14 起设了 ongoing 的普通通知也能划掉。KDE Connect 的用户关掉常驻通知后就没有任何发送途径了。
  - 华为 EMUI 11 上通知展不开，按钮点不到。
  - 澎湃 OS 上前台服务通知还在，进程却会被系统冻结。但用户点按钮时拉起的是 Activity，进程会被唤醒或冷启动，只是速度慢一些。
- 普通通知在进程被杀后仍然保留；强制停止、卸载、更新 App 时，系统会清掉该 App 的所有通知。

### 2.3 长按图标快捷方式与桌面小组件

- 静态快捷方式“发送剪贴板”放在长按图标的菜单里；`ShortcutManager.requestPinShortcut()` 和 `AppWidgetManager.requestPinAppWidget()`（API 26）把它固定到桌面。
- 由桌面应用发起的启动属于后台启动的豁免情形。
- Android 15 起，强制停止后 App 的 PendingIntent 全部取消，小组件变灰，直到用户再次打开 App。

### 2.4 系统分享与直接分享

- 接收 `ACTION_SEND` / `ACTION_SEND_MULTIPLE`：文字、链接、图片、文件都能走，内容由来源 App 直接交过来，不读剪贴板。
- 每台已配对的电脑用 `ShortcutManagerCompat.pushDynamicShortcut()` 发布一个直接分享目标，分享面板第一排就是“MacBook”“办公室 PC”，少一步选择设备。最低 API 和 `<share-target>` 的写法待实现时核对（KDE Connect 已这样做，可参考）。
- **Android 13 起，AOSP 的复制浮层带“分享”按钮**：复制后左下角弹出预览，点“分享”就进入系统分享面板，文本走 `EXTRA_TEXT`，图片走 `EXTRA_STREAM`。原生系统上可以“复制 → 点浮层分享 → 点电脑”，全程不用读剪贴板，也没有读取提示。三星、小米、OPPO 等厂商的浮层是否保留这个按钮待验证。

### 2.5 文字选择菜单（`ACTION_PROCESS_TEXT`）

- API 23 起提供。选中的文字通过 `EXTRA_PROCESS_TEXT` 直接交过来，不经过剪贴板，没有焦点问题，也没有读取提示。只读场景下带 `EXTRA_PROCESS_TEXT_READONLY`，隔空贴不回写文字，发完即结束。
- 覆盖面有限：
  - **微信、知乎用自绘菜单，不显示第三方项**。微信公众号文章内的情况可信度较低，待验证。
  - 宿主 App 的 targetSdk ≥ 30 时，必须在 `<queries>` 里声明 `PROCESS_TEXT`，它的菜单里才会出现隔空贴；WebView 也按宿主 App 的可见性查询。Chrome 声明了 `QUERY_ALL_PACKAGES`，可以显示。
  - 只有 Activity 里的 TextView 才显示这些项；密码框不显示。
  - 澎湃 OS 把第三方项放进“更多”溢出菜单；新装后要重启手机才出现。ColorOS 16 直接全部展开。
- QQ、小红书、抖音、淘宝、微博、WPS 的情况待真机确认。

### 2.6 打开隔空贴时发送

- App 获得焦点时读取并发送，或在首页显示“发送当前剪贴板”。
- 每次读取都会触发 Android 12 起的系统提示，小米还会弹“已智能允许读取剪切板”的气泡。默认关闭，由用户在设置里打开。

## 3. 透明读取页（磁贴、通知、快捷方式共用）

- **主题**：用半透明主题，并给它一个真实的布局（可以是全透明的空布局）。
  - `Theme.NoDisplay` 没有窗口，永远拿不到焦点。
  - KDE Connect 早期没有布局时，在 OxygenOS 上拿不到焦点，界面卡在最上层。
  - 设 `excludeFromRecents`、空 `taskAffinity`，不进最近任务。
- **读取时机**：在 `onWindowFocusChanged(true)` 里读，不在 `onCreate` / `onResume` 里读。系统按窗口焦点判断能否读取，而焦点是异步分配的，太早读会拿到 null，logcat 里出现 “Denying clipboard access … not in focus”。这一条来自 AOSP 源码，不是文档承诺；如果仍读到空内容，短时间内重试几次再报错。
- **交接**：读到内容后，先 `startForegroundService()` 交给发送服务，再 `finish()`。
  - Android 14+ 用 `shortService` 类型：约 3 分钟，不需要额外的类型权限，不能 sticky。
  - 更低版本用 `dataSync`。
  - 从刚可见的 Activity 启动前台服务属于豁免情形，AOSP 默认还有 5 秒宽限，所以必须在 `finish()` 之前启动。
- **内容**：
  - 首版只发文字和富文本。
  - 带 `ClipDescription.EXTRA_IS_SENSITIVE` 标记的内容（密码管理器复制的密码）默认不发，提示用户。
  - 复制的图片在剪贴板里通常是 content URI，读取方能否拿到访问权限待验证；首版先引导图片走分享。
- **反馈**：用一条通知显示“已发送到 MacBook”或“电脑不在线，已保存”，不再额外弹 toast，避免和系统的读取提示叠在一起。

## 4. 电脑端要配合的改动

现在的补发逻辑会让手机的主动发送落空：

- 发送时连接没建立，内容进入补发队列（[backlog.go](../client-core/internal/sync/backlog.go)）。
- 连接恢复后，补发的 offer 带 `backlog` 标记。
- 电脑收到带标记的内容只记进历史，**不写进剪贴板**（[engine.go](../client-core/internal/sync/engine.go) 的 `handleOffer`）。

手机点“发送”时，App 常常是冷启动，连接要过几秒才建立。按现在的逻辑，内容送到时只进历史，电脑上 Cmd+V 粘贴不出来。

改法：手机端把用户主动发送的内容记为“待送达的主动发送”，带时间戳。

- 在时限内送达（初值 60 秒，真机测完冷启动耗时后再定）：按普通 offer 发出，电脑照常写进剪贴板。
- 超时才送达：按补发处理，只进历史；通知提示“电脑不在线，已保存，稍后会出现在电脑的历史里”。

`backlog` 标记由发送方决定，所以这个改动只在手机端，不需要改协议和电脑端。

## 5. 不采用的方案

| 方案 | 原因 |
|---|---|
| READ_LOGS 监听剪贴板拒绝日志 | Android 13 起每次读日志都弹系统确认框，App 不在前台时直接被拒；只能用 adb 授权。KDE Connect 仍保留，但普通用户用不了 |
| 无障碍服务监听复制 | 不稳定，Google Play 会拒，国产系统反复警告 |
| 自研输入法 | 默认输入法可以读剪贴板，同类项目的用户也认为“只有输入法能完美同步”；但要用户换键盘，等于另做一个产品 |
| 悬浮球（默认开启） | 可获得焦点的悬浮窗按 AOSP 源码能读取剪贴板，SyncClipboard 在 ColorOS 16 上可用；但会抢前台 App 的焦点和输入法，导致打字发涩。以后可作为高级选项 |
| Shizuku 后台读取 | 只适合极客用户；SyncClipboard 已实现，可作为以后的高级选项 |

## 6. 系统与厂商限制

- **读取提示**：Android 12 起，每条别人复制的内容第一次被读取时，系统弹“隔空贴已粘贴自剪贴板”，第三方 App 关不掉。这是用户主动点的入口，可以接受。
- **小米剪贴板权限**：小米对每个 App 的“读取剪贴板”默认是“智能允许”。官方文档写的是 Android 10/11：没向小米登记规则的 App 读取任意文本时会被拒，并提示用户；登记只接受已在小米商店上架的 App。澎湃 OS 上是否仍然如此待验证。如果仍然如此，首次发送失败时要引导用户把隔空贴的读取权限改成“允许”。
- **后台冻结与自启动**：澎湃 OS 2 上要同时打开“自启动”和“省电无限制”，后台连接才不会被冻结。这影响冷启动速度和电脑 → 手机的接收，不影响读取本身。
- **纯血鸿蒙**：HarmonyOS 5 起不能直接安装 APK，新的华为手机覆盖不到；HarmonyOS 4.x 及更早版本可以。
- **应用商店**：小米商店要求读取剪贴板是核心功能，只在前台由用户触发，隐私政策写明用途和保存时长，并提交截图或录屏；后台读取明确不予通过。隔空贴的设计（只在用户点击后读取）符合这些要求，剪贴板同步需要按“例外功能”单独说明。华为、OPPO、vivo、应用宝的审核要求待查。
- **电脑 → 手机的副作用**：Android 13 起，每次往剪贴板写内容，系统都会弹复制浮层（锁屏时改为 toast），第三方 App 无法关闭。重复内容不要重复写入。

## 7. 真机验证清单

设备：Pixel（原生基准）、小米澎湃 OS、OPPO ColorOS 16（手机和平板各一台）、vivo OriginOS、荣耀 MagicOS、三星 One UI、华为 HarmonyOS 4.x。

| 项目 | 要确认的事 |
|---|---|
| 三个主入口 | 磁贴、通知按钮、快捷方式各自能否读到剪贴板；锁屏下点磁贴是否先解锁 |
| 小米剪贴板权限 | 默认“智能允许”下能否读到微信里复制的文字；被拒时用户看到什么 |
| 磁贴添加 | `requestAddTileService` 在各厂商上能否弹出 |
| 通知 | 常驻通知是否被折进“不重要通知”，按钮是否可见、可点 |
| 冷启动耗时 | 进程被冻结或被杀后，从点击到电脑剪贴板更新的时间（局域网和公网分别测），据此确定第 4 节的时限 |
| 文字选择菜单 | 微信公众号文章、QQ、小红书、抖音、淘宝、微博、WPS、系统浏览器、Chrome 中是否出现“隔空贴” |
| 复制浮层 | 各厂商复制后是否有带“分享”按钮的浮层 |
| 敏感内容 | 从密码管理器复制后是否带 `EXTRA_IS_SENSITIVE` 标记，隔空贴是否正确跳过 |

## 8. 来源

**Android 官方文档**

- [Android 10 隐私变更：剪贴板](https://developer.android.com/about/versions/10/privacy/changes)
- [Android 12 行为变更：剪贴板访问提示](https://developer.android.com/about/versions/12/behavior-changes-all)、[通知跳板限制](https://developer.android.com/about/versions/12/behavior-changes-12)
- [复制和粘贴（含 `EXTRA_IS_SENSITIVE`、复制浮层）](https://developer.android.com/develop/ui/views/touch-and-input/copy-paste)
- [`ACTION_PROCESS_TEXT`](https://developer.android.com/reference/android/content/Intent#ACTION_PROCESS_TEXT)、[软件包可见性：自定义文字选择操作](https://developer.android.com/training/package-visibility/use-cases)
- [TileService](https://developer.android.com/reference/android/service/quicksettings/TileService)、[快捷设置磁贴](https://developer.android.com/develop/ui/views/quicksettings-tiles)、[StatusBarManager](https://developer.android.com/reference/android/app/StatusBarManager)
- [后台启动 Activity 的限制](https://developer.android.com/guide/components/activities/background-starts)
- [前台服务类型](https://developer.android.com/develop/background-work/services/fgs/service-types)、[后台启动前台服务的限制](https://developer.android.com/develop/background-work/services/fgs/restrictions-bg-start)
- 行为变更：[Android 13](https://developer.android.com/about/versions/13/behavior-changes-all)、[14](https://developer.android.com/about/versions/14/behavior-changes-14)、[15](https://developer.android.com/about/versions/15/behavior-changes-15)
- [接收其他 App 分享的数据](https://developer.android.com/training/sharing/receive)、[ShortcutManagerCompat](https://developer.android.com/reference/androidx/core/content/pm/ShortcutManagerCompat)

**AOSP / Chromium 源码**

- [ClipboardService.java](https://android.googlesource.com/platform/frameworks/base/+/refs/heads/main/services/core/java/com/android/server/clipboard/ClipboardService.java)：读取需焦点、写入不需要、读取提示、锁屏返回 null
- [`READ_CLIPBOARD_IN_BACKGROUND` 的声明](https://android.googlesource.com/platform/frameworks/base/+/refs/heads/main/core/res/AndroidManifest.xml)
- SystemUI `clipboardoverlay/`：复制浮层的分享按钮与无法关闭
- `core/java/android/widget/Editor.java`；Chromium `SelectActionMenuHelper.java`：文字选择菜单的查询方式

**同类项目**

- KDE Connect：[透明 Activity 需有布局（MR !145）](https://invent.kde.org/network/kdeconnect-android/-/merge_requests/145)、[EMUI 通知按钮点不到（bug 445658）](https://bugs.kde.org/show_bug.cgi?id=445658)、[关掉通知后无法发送（bug 446366）](https://bugs.kde.org/show_bug.cgi?id=446366)、[按钮挪位引发反对（bug 521052）](https://bugs.kde.org/show_bug.cgi?id=521052)
- SyncClipboard Mobile：[ColorOS 16 平板磁贴读到空内容（#52）](https://github.com/Jeric-X/syncclipboard-mobile/issues/52)、[悬浮窗与 Shizuku（#6）](https://github.com/Jeric-X/syncclipboard-mobile/issues/6)、[澎湃 OS 进程冻结（#29）](https://github.com/Jeric-X/syncclipboard-mobile/issues/29)、[输入法方案的讨论（#30）](https://github.com/Jeric-X/syncclipboard-mobile/issues/30)
- [LocalSend 的发送剪贴板需求（#3376）](https://github.com/localsend/localsend/issues/3376)
- [READ_LOGS 在 Android 13 起需逐次确认](https://support.google.com/android/answer/12986432)

**国内厂商与商店**

- [微信、知乎不显示第三方选择菜单项](https://github.com/CashewTeam/BigBang_NovaText/issues/25)、[澎湃 OS 的选择菜单](https://github.com/FreeTeaspoon/TextMenuCleaner)、[小米新装菜单项需重启](https://github.com/czy0729/Bangumi/issues/260)、[ColorOS 16 全部展开](https://github.com/TheKingBucket001/txtoi)
- 小米：[读取剪贴板权限使用及申请标准](https://dev.mi.com/xiaomihyperos/documentation/detail?pId=2225)、[剪切板权限调整说明](https://dev.mi.com/xiaomihyperos/documentation/detail?pId=1627)
- [HarmonyOS 5](https://en.wikipedia.org/wiki/HarmonyOS_5)
