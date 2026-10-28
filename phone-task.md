# 手机端开发任务（网页传输、扫码配对、Android App 一期）

> 方案：[design/phone-sync.md](design/phone-sync.md)（方案稿 2026-10-27）
> 基线：main `979450d`（2.6.3）。
> 顺序：先做 A（网页传输，桌面端），再做 B（扫码配对：桌面部分先随一个桌面版本发出），最后做 C（Android App 一期）。B 的 Android 部分在 C 里做。
> 好友功能的任务清单（2.5.4、2.6.0）还在 [task.md](task.md)，这份不动它。
> 界面文案直接加到 ARB 文件里，**不要运行 `ui/tool/l10n/strings.py`**：2.6.0 时它落后于 ARB，运行会删掉 100 多个键。动手前再确认一次现在是否仍然如此。

状态：`[ ]` 未开始 · `[~]` 进行中 · `[x]` 完成

## 0. 准备

- [ ] 提交方案 `design/phone-sync.md` 与 `design/mobile-clients.md` 的指向改动（`docs(design): plan web transfer and the Android client`）
- [x] 拉取最新 main，确认 `go test ./...`、`flutter test` 在基线上是绿的
- [ ] 待定事项（方案 1.4 节）定下来：
  - [ ] 网页传输开关默认关
  - [ ] 登记的手机 30 天不用自动失效
  - [ ] 网页下载单个文件上限（暂定 200 MiB，真机测过再定）
  - [ ] Android 公开发布时 Release 附件从 14 个变成 15 个

## A. 网页传输（桌面端，方案第 2 节）

实现与方案的出入已经写回方案 2.4.2、2.5 节：二维码先登记、再换成专属会话；网页改用 React + Tailwind + Vite，与 App 同一套设计；RPC 叫 `NewWebShareInvite`；二维码点阵由后台服务生成。

### A1. 核心：`SubmitLocal`（2.5.3 节）

- [x] `sync.Engine.SubmitLocal(ctx, content, via, applyLocal)`（`sync/local.go`）
- [x] `store.Clip.Via` 与 `clips.via` 列；`ClipRecord.via_name`；桌面记录显示「来自 iPhone」
- [x] `Engine.LocalPaths` 导出
- [x] 单测：落库、广播、离线进补发队列、三种写剪贴板的情形、关了同步只落库、文件、空内容

### A2. `internal/webshare`：会话与二维码（2.3 节）

- [x] `web_sessions` 表；密钥经 `identity.ProtectSecret` 加密落盘（Windows 上 DPAPI）
- [x] 邀请只在内存；第一次 `hello` 换成专属会话，邀请作废、通知界面换新
- [x] 一码一台；10 分钟或窗口关闭作废
- [x] 30 天没用的手机清掉；移除后立即失效、断开事件流
- [x] 二维码地址取 `lan.LocalAddrs()`，点阵由 `internal/qrcode` 生成

### A3. `internal/webshare`：加密与接口（2.4、2.5.2 节）

- [x] secretbox；时间戳 + rid 防重放
- [x] 1 MiB 分块，块号受认证保护
- [x] 只收私有地址与本机；解密失败过多的来源暂时拒绝
- [x] 接口：`/api/rpc`、`/api/chunk`、`/api/fetch`、`/api/events`，网页静态文件
- [x] 上传落盘、重名改名、权限 0644；之后 `SubmitLocal`
- [x] 下载：文件、图片、文件夹打包 zip、缩略图；记录的筛选与搜索
- [x] 事件流：订阅 `rpc.Hub`，按会话加密推送
- [x] 开关启停；8790 被占用时退回随机端口

### A4. 接口与代码生成

- [x] `daemon.proto` 新增的 RPC、消息、事件；`gen-proto.sh` 生成 Go 与 Dart
- [x] `rpc/webshare.go`；守护进程组装
- [x] `pasteferry-cli web` 子命令

### A5. 网页（2.2、2.5.4 节）

- [x] `web/phone`：React + TypeScript + Tailwind CSS + Vite；产物输出到 `internal/webshare/web` 并嵌入
- [x] 起名、登记、地址栏凭据替换与本地存储；从收藏 / 主屏幕再打开
- [x] 复制记录：搜索、筛选、分组列表、缩略图、详情弹层、加载全文、复制（失败时长按复制）、下载
- [x] 发送：文字、照片与文件分块上传与进度
- [x] 事件流断线重连、回到前台刷新、被移除时的说明
- [x] 添加到主屏幕卡片与菜单、App 内置浏览器提示、安全说明、改名
- [x] 浅色与深色；五种语言
- [x] 在浏览器面板里按手机尺寸实测（开发服务器与正式构建各一遍，正式构建在内容安全策略下无报错）

### A6. 桌面界面（2.5.5 节）

- [x] 设备页「手机网页传输」区块；二维码窗口（换新、换地址、关窗作废）
- [x] Windows 托盘「手机扫码连接」（只编译验证，没在 Windows 上实测）
- [x] 五种语言的文案
- [x] 组件测试 6 个；截图工具新增 `web-share`、`web-share-dark` 场景

### A7. 自动测试（2.7 节）

- [x] `webshare` 的 Go 测试：用 Go 写的测试客户端走完整协议（登记、一码一台、过期、文字、长文字、分块上传、下载与 zip、重放、密钥错误与限速、来源地址、事件流与移除、开关、30 天清理、筛选与搜索、嵌入的网页完整）
- [x] `go test ./...`、`go vet ./...`、`flutter analyze`、`flutter test` 全部通过

### A8. 真机验证（2.8 节）

- [ ] 复制文字：iPhone 的 Safari、Chrome、微信；Android 的 Chrome、华为 / 小米 / vivo 自带浏览器、微信、UC、QQ 浏览器
- [ ] 下载：Blob 下载、长按保存图片、能承受的文件大小、微信会不会拦截（据此定下载上限）
- [ ] 上传：iPhone 照片的格式；500 MB 视频的速度与发热
- [ ] http 打开局域网地址时各浏览器会不会拦截或警告
- [ ] 切后台、锁屏、回来时事件流的重连与补齐
- [ ] 添加到主屏幕：图标与名字、保存的网址带不带 `#` 后的密钥、从图标打开能否识别、国内浏览器要不要额外授权
- [ ] Windows 防火墙放行前后、macOS 防火墙打开时；Windows 托盘菜单

### A9. 官网与发版（等用户说发再做）

- [ ] 官网功能页加「手机网页传输」一节、截图（`tools/screenshots/render.sh` 已有场景）、常见问题、`docs/llms.txt`、README（中英）
- [ ] 隐私说明补充：局域网里能看到的元数据、防不住篡改网页
- [ ] 版本号（新功能，MINOR）、`CHANGELOG.md`、`tools/release/notes.py`，按 `.claude/rules/commits-and-releases.md` 发布

## B. 扫码配对（方案 3.3.9 节）

桌面部分要早于 Android App 发布，可以和 A 同一个版本，也可以放下一个桌面版本。

### B1. 协议与核心

- [ ] `wire.proto`：`LanPairInfo` 新增 `bytes qr_proof = 12`；`LanPairReject.reason` 新增 `declined`
- [ ] 二维码内容的生成与解析（`https://pasteferry.cc/pair#v=1&id=…&k=…&a=…&n=…`），放在 `proto` 模块里给后台服务和测试共用
- [ ] `transport/lan/pairing.go` 显示方：开放与撤回二维码配对（5 分钟、用一次作废、窗口关掉撤回）；`handlePairRequest` 按有没有 `qr_proof` 分两路，`HMAC-SHA256(k, "pasteferry-qr-pair|v1|" ‖ 电脑 ID ‖ 手机公钥 ‖ nonce)` 常量时间比较
- [ ] `transport/lan/pairing.go` 扫码方：`PairQR(ctx, payload)`，mDNS 带 `s=1` 敲门，向二维码地址和 `p=1` 实例发请求（500 毫秒重发，5 秒为限），核对 `deviceid.For(回复公钥)` 等于二维码里的 `id`；处理 `declined`
- [ ] `peers/manager.go`：`CreatePairingCode` 同时生成 `k` 与二维码内容；`RedeemPairingQR` 核对通过后自动确认；显示方的待确认会话记「已由二维码验证」；拒绝或确认框超时回 `declined`，扫码方收到后撤掉配对
- [ ] `daemon.proto`：`CreatePairingCodeResponse.qr_payload`、RPC `RedeemPairingQR`、`Device.verified_by_qr`；重新生成代码

### B2. 桌面界面

- [ ] 添加设备窗口：配对码上方显示二维码（「用隔空贴手机 App 扫码」）
- [ ] 简化的确认框：`verified_by_qr` 时只显示手机名和型号，不显示指纹（`ui/lib/widgets/pairing_dialog.dart`）
- [ ] 设备列表把 `android` 显示成手机图标（`platformIcon`）
- [ ] 五种语言的文案

### B3. 官网

- [ ] `pair` 页面：只在浏览器里读 `#` 后的内容、不发给服务器；「打开隔空贴」按钮（`pasteferry://pair#…`）；Android 下载链接；微信里打开时提示改用系统相机或 App 里的「扫码」；五种语言（`tools/site`）
- [ ] `/.well-known/assetlinks.json`：写 Android 发版证书的 SHA-256（要等 C6 生成签名密钥后才能写）
- [ ] 部署：按发版规范第 10 步部署 `docs/`

### B4. 测试

- [ ] 两实例集成测试：二维码配对后两边落库、直连，全程不经指纹核对
- [ ] 错的 `k`、换了公钥、换了 nonce 被拒绝；同一个码第二次使用、过期、窗口关闭后被拒绝
- [ ] 回复公钥与二维码 `id` 对不上时扫码方不落库；电脑拒绝或超时后扫码方撤掉配对
- [ ] 二维码解析：IPv6 地址、中文与 emoji 电脑名、超长名字截断、未知版本号
- [ ] 旧版本（2.6.3）不受影响：配对码与雷达照常

## C. Android App 一期（方案第 3 节）

### C1. 第一周：真机验证（3.5 节）

- [x] gomobile 打出 AAR，Go 核心在 App 进程里启动、停止、再启动，没有残留 goroutine（`mobile_test.go`）；`daemon.json` 与 gRPC 回环连接正常（模拟器实测）
- [x] `net.Interfaces()` 在 Android 11+ 报 `netlinkrib: permission denied`（模拟器实测），已换成 `anet`；pion/mdns 里的两处另见方案 3.3.10 节
- [ ] 持有 MulticastLock 时 mDNS 互相发现（Mac、Windows 各一台），雷达配对正常
- [ ] 后台写剪贴板：后台亮屏写入后微信、浏览器里能粘贴；锁屏能否写入；会不会弹「已复制」预览
- [ ] 前台服务锁屏 8 小时以上能否在线、收文字的延迟、耗电；小米、OPPO、vivo、荣耀，默认设置与加白名单后的差异
- [ ] 图片和文件经剪贴板 URI 在微信、QQ、备忘录、浏览器里粘贴的效果
- [ ] 与 2.6.3 桌面互通：配对、文字双向、图片、50 MiB 以上手动下载、电脑重启后补发
- [ ] 扫码组件在没有 Google Play 服务的手机上能否用、识别速度
- [ ] 系统相机扫码：Pixel 与国内手机上 App Link 能否拉起 App；拉不起时官网 `pair` 页的按钮；微信扫码的提示
- [ ] 扫码配对时没放行防火墙的 Windows 能否靠敲门收到请求
- [ ] 按结论重估 C 的工作量，有变化就改方案

### C2. Go 核心（3.3.2 节）

- [x] ~~所有 `//go:build linux` 改成 `linux && !android`~~ 不需要：手机的组装不引用 X11、D-Bus 这些包（方案 3.3.10 节）
- [x] 构建加 `-ldflags=-checklinkname=0`（`wlynxg/anet` 的 `go:linkname`）；跟进上游
- [x] `transport/lan/addrs.go`、`transport/p2p/egress_history.go` 改用 `anet.Interfaces()`
- [x] Android 剪贴板（`mobile/clipboard.go`）：`Write` 经宿主回调；`Peek` 的变化计数只在本机写入时增加；`Read` 返回 `ErrUnsupported`
- [x] RPC `SubmitText`（经 `SubmitLocal`，`applyLocal=false`）
- [x] 配置项「收到图片和文件后自动写入剪贴板」：桌面默认开、Android 默认关；`finishReceive` 只按它决定自动推送后写不写；「复制」走 `Fetch(preserve_clipboard=false)` 或 `ApplyToClipboard`，「保存」「分享」走 `preserve_clipboard=true`
- [x] ~~从 `cmd/pasteferryd/main.go` 抽出 `internal/runtime`~~ 改为在 `client-core/mobile/` 单独组装（方案 3.3.10 节）
- [x] `client-core/mobile/`：`Start(dataDir, deviceName, version, host)`、`Stop()`、`Running()`；`host` 接口 `WriteClipboard(kind, text, html, paths)`、`StatusChanged(online, lastFrom, lastKind)`；只开局域网通道
- [ ] `GetStatus` 报告本机支持的功能，界面据此显示（方案第 4 节）
- [ ] 桌面三端回归：`go test ./...` 已过（Mac）；Windows、Linux 各跑一遍复制同步

### C3. Kotlin 宿主（3.3.3 节）

- [x] `PasteFerryApp` 持有 Go 核心单例
- [x] `SyncService`：`connectedDevice` 前台服务、常驻通知（连接状态与最近一条的来源和类型，不写正文）、点通知打开 App；设置里能关
- [x] 剪贴板：主线程 `setPrimaryClip`；文字、HTML、`content://` URI（FileProvider，`grantUriPermissions="true"`）；过期的记录显示「已过期」
- [x] `WifiManager.MulticastLock`；不在 Wi-Fi 时页面顶部提示「没有连接 Wi-Fi」（回到前台时检查，没有监听网络变化）
- [x] 保存：图片进相册、文件进「下载」（MediaStore）；分享：`ACTION_SEND`
- [ ] 权限：`POST_NOTIFICATIONS`（13+，设置页里请求，已做）；`CAMERA`（扫码，随 B 做）
- [ ] 电池优化设置的跳转（已做，设置页）；国内品牌的自启动 / 后台运行 / 锁屏清理说明页
- [x] 数据目录不参与系统云备份
- [ ] App Link：`https://pasteferry.cc/pair` 的 intent filter（`autoVerify`）；自定义协议 `pasteferry://pair`

### C4. Flutter 界面（3.3.4 节）

- [x] `flutter create --platforms=android`；`desktop_drop` 等桌面插件按平台条件引入
- [x] `daemon_client.dart` 改为从宿主取数据目录
- [x] 手机外壳：底部标签「记录 / 发送 / 设备 / 设置」，触控尺寸；样子与网页传输的页面一致（页头、搜索框、分段筛选、分组列表、按钮）
- [x] 发送页：`Clipboard.hasStrings()` 有文字时「粘贴」按钮才能点，点了才 `Clipboard.getData()`；输入框；在线设备；没有在线设备时不能发送
- [x] 记录：列表、搜索、详情、长按删除；图片 / 文件的「复制 / 保存 / 分享」与下载进度
- [ ] 设备：雷达、配对码（已做，沿用桌面的对话框）；扫码页、「显示二维码」页、二维码出错提示、「已配对，等待 ××× 确认」状态（随 B 做）
- [ ] 首次引导：起名、通知、配对（默认打开扫码）、后台运行
- [ ] 设置：自动写入剪贴板开关、后台保持连接开关、通知、电池优化、设备名（已做）；同步类型、历史保留期、清除缓存、诊断导出、检查更新
- [x] 不在 Android 上出现：托盘、热键、快捷粘贴窗口、服务器与官方服务页、好友页、隔空传送、手机网页传输
- [x] 五种语言的文案

### C5. 自动测试（3.4 节）

- [x] Go 单测：`SubmitText`；新配置项（自动推送写不写、手动下载照写）；Android 剪贴板实现不触发 Watcher 回调；`ClipDetail.local_paths`
- [ ] 两实例集成测试：一边 Android 组装（只开局域网）、一边桌面组装，跑配对、文字双向、图片推送、超阈值手动下载（已在模拟器里手动跑通配对、文字双向、图片，见方案 3.3.10 节；自动化的还没写）
- [ ] Flutter 测试：发送页按钮状态、记录按钮随类型和状态变化（`test/mobile_test.dart`，已做）；扫码页出错提示（随 B 做）
- [x] `go test ./...`、`go vet`、`flutter analyze`、`flutter test` 全部通过

### C6. 构建与签名（3.3.7、3.3.8 节）

- [ ] 生成 Android 发版签名密钥，存在发版的 Mac 上，按更新私钥的方式备份；记进发版规范：永远不换
- [x] 构建脚本 `scripts/build-android.sh`：只出 arm64（x86_64 见方案 3.3.10 节）；`--aar --emulator` 打模拟器用的 Go 核心
- [x] minSdk 29、targetSdk / compileSdk 36、只出 arm64-v8a
- [x] 量一下 APK 体积：release、arm64 约 47 MB，已去掉调试信息
- [ ] 把证书 SHA-256 写进 B3 的 `assetlinks.json`

### C7. 内测与发布准备

- [ ] 签名 APK 发给内测用户；收集国内机型后台在线与扫码的反馈
- [ ] 公开发布前定下（等用户决定）：
  - [ ] Release 附件加 `PasteFerry-android.apk`，同时改 `.claude/rules/commits-and-releases.md`、`tools/release/manifest.py`、Release 正文下载表、官网下载页
  - [ ] Google 开发者验证：2027 年前在 Android Developer Console 完成
  - [ ] 官网加 Android 页面、常见问题（手机上复制不会自动发出、国内机型白名单）
