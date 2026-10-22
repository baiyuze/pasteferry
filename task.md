# 隔空传送开发任务（2.5.0）

> 方案：[design/send-files.md](design/send-files.md)
> 基线：main `ed09502`（2.4.1）。版本号从 2.5.0 起。
> 2026-10-22：按用户要求改名为「隔空传送」（繁体「隔空傳送」，英文 Send Files，日文 ファイル送信）。
> 第 15 节的待定事项按文档里的建议执行：拖进来立即发送、默认自动接收、存到「下载」本身、
> 离线设备变淡显示、只在 Mac 上打隔离标记、官方中转先确认、列表保留 30 天或 500 条。

状态：`[ ]` 未开始 · `[~]` 进行中 · `[x]` 完成

## 0. 准备与原型

- [x] 拉取最新 main
- [x] 测速原型：本机回环 25–45 MB/s，瓶颈是 pion 逐包的系统调用；调水位、多通道、接收缓冲都没用。首版沿用现有通道（结果见方案第 12.1 节）
- [x] zstd：不可压缩数据约 1.8 GB/s，不是瓶颈，保留压缩
- [x] 确认 `desktop_drop` 0.8.4、`file_selector` 1.1.0 能装上；Mac 版带插件编译通过（以 Swift Package 静态链接，App 包里不多框架）

## 1. 协议与接口

- [x] `wire.proto`：`PeerFeatures`、`SendOffer`、`SendAnswer`、`SendCancel`、`SendResult`（`PeerMessage` 8–12）
- [x] `daemon.proto`：
  - [x] RPC：`SendFiles`、`CancelTransfer`、`ResumeTransfer`、`ListTransfers`、`DeleteTransfers`、`MarkTransfersSeen`、`CheckReceiveDir`
  - [x] `Transfer` 等消息
  - [x] `Config` 23–25、`Device` 9–11、`Event` 11–12
- [x] 生成 Go 与 Dart 代码（`scripts/gen-proto.sh`）

## 2. 后台服务（Go）

- [x] `pack/frames.go`：帧格式编解码、从任意位置续传、逐文件 SHA-256
- [x] `store`：`transfers`、`transfer_entries` 两张表与查询
- [x] `config`：`receive_dir`、`receive_disabled`、`receive_notify_disabled`；各平台的「下载」文件夹
- [x] 连接层：连上后交换 `PeerFeatures`，结果挂到 `Device`；`send:` 开头的数据通道交给隔空传送
- [x] `internal/send`：
  - [x] 发送：统计、清单入库、排队（同一设备一次一批）、发起、开数据流、发帧
  - [x] 接收：检查（开关、保存位置、空间、单文件上限）、应答、写临时目录、校验、移到保存位置、重名改名
  - [x] 取消（两边）、中断与自动续传（30 分钟内）、手动继续
  - [x] 进度（0.2 秒节流）、当前文件（0.5 秒）
  - [x] 官方中转：`allow_relay`，额度用完暂停、恢复后继续
- [x] `internal/power`：传输期间阻止空闲睡眠（Mac、Windows、Linux）
- [x] 通知：较大传输开始时一条、完成或失败替换它；`reveal` 动作；点通知打开隔空传送页
- [x] `rpc`：新接口、事件、`Device` 新字段
- [x] 清理：没续上的半成品 7 天后删除；记录保留 30 天或 500 条
- [x] Mac：收到的文件打 `com.apple.quarantine`
- [x] `scripts/build.sh`：后台服务 Info.plist 加文件夹权限说明，五种语言

## 3. 界面（Flutter）

- [x] 依赖：`desktop_drop`、`file_selector`；快捷粘贴窗口不引用它们
- [x] 雷达抽成公共组件，「搜索附近设备」改用它，外观不变
- [x] 侧边栏「隔空传送」：进度环 / 新收到的个数
- [x] 隔空传送页：雷达（内外圈、各状态、进度环）、拖到设备上发送
- [x] 发送窗口：拖入、选择文件 / 文件夹、进度、排队、取消
- [x] 官方中转确认框
- [x] 传输列表：收到的 / 发出的、悬停列出文件、在访达中显示、继续、重新发送、清除
- [x] 设置页「隔空传送」一组：接收开关、保存位置、通知
- [x] 第一次打开隔空传送页时检查保存位置（触发 Mac 的文件夹授权）
- [x] 五种语言的文案

## 4. 自动测试

- [x] `pack`：帧编解码、续传、路径穿越、Windows 文件名
- [x] `send`：两个后台服务互发：完成、取消、断开续传、源文件被改、保存位置不可用、重名、关闭接收、旧版本、离线、官方中转需同意（磁盘空间不足只在实机上测）
- [x] `store`：建表、重开、标为已看、清理旧记录、删除时连带条目
- [x] 界面组件测试：雷达各状态、列表各状态、侧边栏标记
- [x] `go test ./...`、`go vet`、`flutter analyze`、`flutter test` 全部通过

## 5. 实机验证（第 14 节）

- [x] 本机两个隔离的后台服务（假剪贴板构建，数据与保存位置都在 /tmp），用 `pasteferry-cli send` 实测（2026-10-22）：
  - 2 GB 单个文件：46 秒，44 MB/s，逐字节一致
  - 2 万个小文件（含空文件夹、中文与 emoji 文件名）：10.6 秒，`diff -r` 完全一致，临时目录清干净
  - 传到 892 MB 时杀掉接收方、重启：发送方自动从断点续传，内容一致
  - 传到 667 MB 时杀掉发送方、重启：33 秒内自动续传完成，内容一致
  - 重名自动改成「(2)」；传输期间有 `caffeinate` 的防睡眠声明，传完即撤
- [x] `pasteferry-cli` 加 `send`、`transfers` 两个命令

- [x] Mac ↔ Windows 虚拟机、Mac ↔ Linux 虚拟机：互发、续传（约 18 MB/s，受虚拟网卡限制）；装好的正式界面实测（2026-10-22）
- [ ] 官方中转：额度内、超额暂停、恢复
- [ ] Mac 首次接收的文件夹授权弹窗；连续两个版本之间授权是否保留
- [x] 传输期间不睡眠（Mac 上看到 caffeinate 的声明，传完即撤；Windows、Linux 只看了代码路径）

## 6. 发版（2.5.0，等用户说发再做）

- [x] 截图（send、send-dark、send-dialog-dark 生成到 docs/）、官网首页与功能页、技术规格与常见问题、`llms.txt`、README；隐私说明原有的「内容经设备间加密通道传输」已涵盖，不用改
- [x] 版本号、`CHANGELOG.md`、`tools/release/notes.py`
- [ ] 按 `.claude/rules/commits-and-releases.md` 发布
