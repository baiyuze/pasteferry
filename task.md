# 好友开发任务（2.5.4、2.6.0）

> 方案：[design/friends-send.md](design/friends-send.md)（定稿 2026-10-26）
> 基线：main `4b38b70`（2.5.3）。2.5.4 先发，2.6.0 在它之上做。
> 上一份任务清单（隔空传送 2.5.0）在 git 历史里（`b24cbf6`），唯一没做完的一项挪到了第 9 节。
> 界面文案直接加到 ARB 文件里，**不要运行 `ui/tool/l10n/strings.py`**：它落后于 ARB，运行会删掉 100 多个键。

状态：`[ ]` 未开始 · `[~]` 进行中 · `[x]` 完成

## 0. 准备

- [x] 提交设计稿 `design/friends-send.md`（`docs(design): plan sending files to friends`）
- [x] 拉取最新 main，确认 `go test ./...`、`flutter test` 在基线上是绿的

## 1. 2.5.4：「需要更新」误报（设计稿第 10.1 节）

- [x] 写测试复现：在线（服务器在线通知或局域网可达）但 P2P 还没连上时，`Device.receives_files` 为 false
- [x] `daemon.proto`：`Device` 增加功能声明状态（`unknown` / `known`）和 `app_version`
- [x] `wire.proto`：`PeerFeatures` 增加 `app_version`
- [x] `peers.Manager`：
  - [x] P2P 连通后 5 秒仍没收到声明，才判定为旧版本
  - [x] 声明与版本号存进 `devices`（新增 `features`、`app_version` 列），启动时读回
  - [x] 连不上时报「暂时连不上」，不报旧版本
- [x] 界面：`send_page.dart` 三态：还不知道 →「连接中…」（可点，点了先连）；旧版本 →「需要更新」并提示版本；连不上 →「暂时连不上」
- [x] 测试：在线未连通 → `unknown`；连通不发声明 → 旧版本；重启后读出上次的声明；界面组件测试覆盖三态

## 2. 2.5.4：「官方服务」改叫「服务」（第 12 节）

- [x] 五种语言 ARB：`officialService`、`useOfficialService`、`officialPrivacy`、`relayConfirmTitle`、`relayConfirmBody` 以及其他含「官方服务」的键（简体「服务」、繁体「服務」、英文 Service、日文 サービス）
- [x] 官网 `tools/site/content/{zh,zh-tw,zh-hk,en,ja}.py` 与 README（中英）同步改，运行 `python3 tools/site/build.py`
- [x] 内部标识符（`Official()`、`service_mode = official`）和 `official-gateway.md` 不改
- [x] 截图里如果有「官方服务」字样，重新生成

## 3. 2.5.4 发版（等用户说发再做）

- [x] `go test ./...`、`go vet`、`flutter analyze`、`flutter test` 全部通过
- [x] 本机两个隔离的后台服务：P2P 还没连上时雷达显示「连接中…」，不再闪「需要更新」
- [x] 版本号、`CHANGELOG.md`、`tools/release/notes.py`，按 `.claude/rules/commits-and-releases.md` 发布

## 4. 2.6.0：协议与接口（第 13 节）

- [x] `wire.proto`：`FriendCard`、`FriendRequest`、`FriendAnswer`、`FriendRemove`、`AvatarRequest`、`AvatarData`；`SendOffer.note`；`SendAnswer.reason` 新代码（`pending`、`declined`、`timeout`、`not_allowed`、`rate_limited`）
- [x] 功能标记 `friends_v1`、`send_files_ask_v1`
- [x] `daemon.proto`：名字与头像、好友、发送（`note`、`AnswerIncoming`）、接收设置的 RPC；`Friend`、`IncomingOffer` 等消息；新事件
- [x] 好友码格式：`F` 加 6 位，放在 `proto/pairingcode`（识别、规范化）
- [x] 生成 Go 与 Dart 代码（`scripts/gen-proto.sh`）

## 5. 2.6.0：后台服务（Go）

### 5.1 存储与配置

- [x] `store`：`contacts`、`contact_addrs`、`pending_notices`、`blocked_devices`；`transfers` 增加 `peer_role`、`note`、`thumb_path`
- [x] `config`：`receive_from`（默认 `friends`）、`everyone_until`、`display_name`、`avatar_path`
- [x] 显示名默认值：macOS `NSFullUserName`、Windows 显示名、Linux GECOS

### 5.2 角色与安全（第 11 节，最先做）

- [x] `peers.Manager` 给每个连接带角色：`self` / `friend_pending` / `friend` / `stranger`
- [x] P2P 消息与数据流的入口白名单，新消息默认不放行；单测逐条覆盖每种消息类型
- [x] 剪贴板广播、`PeerDisplay` 等只发给 `self`
- [x] `signed.Verifier`：公钥来源扩展到好友与本次局域网会话里的陌生设备，并带出角色
- [x] 服务器关注列表（Hello 的 `paired_device_ids`）加上好友的设备 ID

### 5.3 好友

- [x] 好友码：复用配对码代理（服务器）与局域网配对通道；`intent` 区分加好友与配对
- [x] 「待定好友」连接上交换名片和头像，两边都确认后写入 `contacts`
- [x] 已配对的电脑不能加为好友；在「添加设备」里输入好友码自动转到加好友
- [x] 删除好友：双向通知，对方不在线时写入 `pending_notices`，连上后补发（最多 30 天）
- [x] 屏蔽陌生设备
- [x] 按需连接：只看在线状态时不建连接；发送、补发通知时才连，空闲 2 分钟断开
- [x] 名片里的服务类型与自建服务器地址哈希；第 9.2 节的可达状态（`friend_reachability`）

### 5.4 头像

- [x] `SetAvatar`：裁剪、缩到 256×256 JPEG、≤ 64 KB、去掉 EXIF；`ResetAvatar`
- [x] 名片带头像哈希，变了才请求 `AvatarData`；收到后重新解码再编码，坏数据退回默认头像
- [x] 陌生人不交换头像

### 5.5 发送与接收

- [x] 发给好友：对方必须声明 `send_files_ask_v1`；`note` 校验（≤ 200 字符、单行、无控制字符、必须有文件）
- [x] 接收方：按 `receive_from` 和角色决定直接拒绝、弹窗确认或自动接收（好友的 `auto_accept`）
- [x] 等待确认：先回 `pending`，60 秒超时；发送方等最终结果
- [x] 防打扰：同一台电脑 1 分钟内被拒 3 次，之后 10 分钟自动拒绝
- [x] 非 `self` 发来的文件：去掉可执行权限；Mac 上一律打隔离标记；核对路径穿越与符号链接
- [x] 收到的图片：用 `internal/imagepreview` 重新编码生成缩略图，写到 `thumb_path`
- [x] 通知：接收请求带「接受」「拒绝」按钮与备注；能换图标的平台用对方头像；60 秒后换成「已忽略」

### 5.6 「所有人」模式

- [x] 只在局域网：打开期间 mDNS 广播带显示名，关掉就撤下
- [x] 10 分钟后自动回到「仅限好友」，发 `receive_policy_changed` 事件
- [x] 陌生设备公钥只存内存，关掉「所有人」就清掉

### 5.7 其他

- [x] `rpc`：新接口与事件
- [x] `pasteferry-cli`：`friends`、`friend add | code | remove`、`send --to <好友> --note`、`accept`、`decline`

## 6. 2.6.0：界面（Flutter）

- [x] 隔空传送页顶部：头像、显示名（可改）、「好友 N」、「＋」
- [x] 头像菜单（选择、粘贴、拖入、恢复默认）与裁剪窗口
- [x] 默认头像组件：圆形色块加首字，颜色由设备 ID 算出
- [x] 雷达：好友排在最外圈，显示头像与第 8 节表格里的各种状态；「所有人」模式下的陌生设备（虚线圈）
- [x] 好友列表窗口与右键菜单
- [x] 添加好友：显示好友码、输入好友码、确认框（可展开安全码）、不在同一网络时的提示
- [x] 发送窗口：好友标题、备注框（没选文件时不能用）、⌘V / Ctrl+V 粘贴图片和文件、等待接受 / 拒绝 / 没有回应
- [x] 接收弹窗：对方头像、文件、备注、「以后自动接收」、倒计时
- [x] 传输列表：好友的行带头像与备注，图片显示缩略图
- [x] 和某个好友的传输记录窗口
- [x] 底部「允许这些人给我发文件」菜单；「所有人 · 还剩 N 分钟」
- [x] 第 9.2 节的「打开服务」提示，按钮跳到服务设置页
- [x] 五种语言的文案（按第 6.5 节的口径：写「给好友发文件」，不写「聊天」）

## 7. 2.6.0：自动测试（第 15 节）

- [x] 单测：角色白名单、接收设置三档 × 三种角色、60 秒超时、防打扰、备注校验、图片与头像、路径穿越、好友码识别、可达提示
- [x] 本机端到端（`-tags fakeclip`、隔离的 `-data-dir`、`receive_dir` 在 /tmp），A1/A2 配对、B1 另一个人：
  - [x] A1 和 B1 加好友后互相发，备注与头像正确；A2 和 B1 互相发不了
  - [x] **A1 复制文字、图片、文件后，B1 的剪贴板与复制记录没有变化**
  - [x] B1 选「均不允许」时 A1 得到「不接收文件」
  - [x] 删除好友，含对方离线时补发
  - [ ] 2.5.3 对端：显示「需要更新」，好友码报「配对码无效」
- [x] 界面组件测试：雷达好友状态、发送窗口备注、接收弹窗
- [x] `go test ./...`、`go vet`、`flutter analyze`、`flutter test` 全部通过

## 8. 2.6.0：实机验证与发版

- [x] Mac（A）↔ Linux 虚拟机（B，隔离的 HOME，不用和真 Mac 配对过的数据）：
  - [ ] 双方打开服务、关掉局域网：跨网络发送、中转确认、额度扣减
  - [x] 一方关掉服务：第 9.2 节的提示
- [ ] Windows 虚拟机：接收弹窗、通知按钮与头像
- [x] 官网：功能页加「给好友发文件」一节、截图（示例内容用 example.com、虚构的人名，不用真实公司名或地址）、常见问题、`llms.txt`、README
- [x] 隐私说明补充：好友能看到的信息（显示名、电脑名、系统、服务类型、头像）
- [ ] 版本号、`CHANGELOG.md`、`tools/release/notes.py`，按 `.claude/rules/commits-and-releases.md` 发布（等用户说发再做）

## 8.5 2.6.0：追加

- [x] 设置页改成类别列表 + 二级页（通用、连接、同步、快捷粘贴、隔空传送、存储、关于），「打开服务…」直达「连接」
- [x] 好友页：点好友列表的一行（或右键雷达下的头像）打开，含状态、自动接收开关、发送按钮与传输记录

## 9. 遗留（来自 2.5.0）

- [ ] 官方中转额度用完时暂停、恢复后继续：会用掉当天的中转额度，等用户同意再测
