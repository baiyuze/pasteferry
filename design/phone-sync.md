# 隔空贴手机端方案：网页传输与 Android App

> 方案稿 · 2026-10-27 · 基于 2.6.3（`979450d`）· 尚未实现
>
> - 合并了之前分开写的网页传输、Android 客户端两份方案。
> - 取代 [mobile-clients.md](mobile-clients.md) 里 Android 的部分；iOS 暂不做，调研结论见 5.3 节。
> - 平台规则对照了官方文档或 AOSP 源码（第 6 节）。标「待验证」的条目，在 2.8 节和 3.5 节的真机验证里确认。

## 1. 总览

### 1.1 分两步做

| 步骤 | 是什么 | 改哪里 | 工作量（一人全职） |
|---|---|---|---|
| 第一步：网页传输 | 电脑上显示二维码，手机扫码后用浏览器和电脑互传文字、照片、文件，看电脑上的复制记录。iPhone 也能用 | 只改桌面端 | 3–4 周 |
| 第二步：Android App 一期 | 局域网简单版：扫码配对；看记录；电脑复制的文字自动进手机剪贴板；图片和文件点了才复制；手机发文字给电脑和其他设备 | 新增 Android 工程，Go 核心小改；桌面端加配对二维码 | 6.5–8.5 周，从第一步做完后算起 |

两步都**只在局域网里用**。网页传输**不改设备之间的协议**；Android 的扫码配对只给局域网配对报文加字段，不改原有字段，旧版本不受影响（3.3.9 节）。

- 网页传输随下一个桌面版本发布，按发版规范是 MINOR。
- Android App 能和现有的 2.6.x 电脑用雷达或配对码配对、同步，电脑不用升级；扫码配对要新版桌面端（3.3.9 节）。

### 1.2 两种方式能做到的程度

| | 网页传输 | Android App 一期 |
|---|---|---|
| 安装 | 不用装，iPhone 也能用 | 要装 APK |
| 连上电脑 | 扫码登记这台手机（不是配对，手机不进设备列表） | 扫码配对，不用核对指纹；也可以用雷达或配对码 |
| 手机 → 电脑：文字 | 粘贴进网页输入框发送 | 一样 |
| 手机 → 电脑：照片、文件 | 能 | 一期不做 |
| 电脑 → 手机：文字 | 网页开着时实时出现，点「复制」 | 自动写进手机剪贴板，后台也行 |
| 电脑 → 手机：图片、文件 | 下载、长按保存 | 复制、保存、分享 |
| 网页关掉、锁屏后 | 不同步；再打开时看到最新记录 | 后台保持连接 |
| 手机上的记录 | 看的是电脑上的记录 | 手机自己存一份 |
| 传输加密 | 网页里自己加密，防旁听，防不住篡改网页 | 端到端（DTLS + 设备签名） |
| 网络 | 同一局域网 | 同一局域网 |

两种方式都做不到「手机上一复制就自动发到电脑」：Android 10 起只有前台 App 和默认输入法能读剪贴板，浏览器里更不行。手机上复制的内容，要粘贴进网页或 App 的发送框再发。

### 1.3 共用的部分

- **提交接口**：`Engine.SubmitLocal(content, originName, applyLocal)`。网页传输先做，Android App 直接复用（2.5.3 节、3.3.2 节第 5 条）。
- **复制记录**：都用 Go 核心里现有的记录、缓存和广播逻辑；手机发出的内容和在电脑上复制的效果一样，会发给其他已配对的设备。
- **二维码组件**：桌面端网页传输和扫码配对共用同一个二维码组件，都由后台服务生成内容、界面只负责画（2.5.5 节、3.3.9 节）。
- **跨平台约定**：第 4 节。

### 1.4 已定的和要你拍板的

已定：

1. 一期只做局域网。
2. 先做网页传输，再做 Android App。
3. iOS 暂不做，iPhone 用户先用网页传输。
4. Android 最低支持 Android 9（3.3.8 节）。
5. 网页传输在网页里自己加密内容，不用明文 http。
6. Android 一期：文字自动写进手机剪贴板；图片和文件点了才放进剪贴板；手机在发送页发文字。
7. Android 支持扫码配对：扫电脑上的二维码，不用核对指纹，电脑上点一次确认（3.3.9 节）。

待定：

1. 网页传输的开关默认关，用户主动打开。
2. 网页传输登记的手机 30 天不用自动失效。
3. 网页下载单个文件上限暂定 200 MiB，真机测过再定。
4. Android App 公开发布时，Release 附件从 14 个变成 15 个（3.3.7 节）。

## 2. 网页传输

**不装 App，iPhone 和 Android 扫一下电脑上的二维码，用浏览器就能和电脑互传文字、照片、文件，还能看电脑上的复制记录。**

- **改动范围**：全部在桌面端，不改设备之间的协议，也不涉及 App 分发。
- **网络**：只在局域网里用，手机和电脑要在同一个网络、能互相访问。
- **做不到**：
  - 网页关掉或手机锁屏后，不再同步；
  - 不会自动写进手机剪贴板，每次都要点「复制」；
  - 图片不能复制到手机剪贴板，只能保存。

  这些要靠 App。
- **安全**：只能用 http，所以网页里自己加密内容，同一个网络里的人旁听看不到内容；但防不住有人在局域网里主动篡改网页（2.4 节）。界面上写明：在家里、可信的办公网络里用，公共 Wi-Fi 不要用。

### 2.1 用户怎么用

#### 2.1.1 开启

1. 电脑上打开「设备 → 手机网页传输」，打开开关。默认是关的。
2. Windows 第一次可能弹防火墙询问，点允许。
3. 窗口里显示二维码和网址。电脑有多个网络时，可以切换用哪个地址。一个二维码只登记一台手机，登记后自动换新（2.3 节）。
4. 关掉窗口不影响使用：只要开关开着，已登记的手机随时能打开网页。

#### 2.1.2 手机扫码

1. 用相机或浏览器扫码，打开网页。
2. 第一次打开时给这台手机起个名字。默认按浏览器信息猜，比如「iPhone」「Android 手机」。
3. 网页顶部显示连着的电脑名，下面分两块：「发送」和「记录」。

用微信扫码会在微信内置浏览器里打开，下载文件可能被拦，这时提示「在浏览器中打开」（**待验证**）。

#### 2.1.3 手机 → 电脑

- **文字**：在输入框里输入或长按粘贴，点「发送」。电脑上：
  - 进复制记录，记录的来源写这台手机的名字；
  - 按电脑「收到后自动写入剪贴板」的设置写进剪贴板，直接 Ctrl+V / ⌘V；
  - 和在这台电脑上复制一样，同时发给其他已配对的设备。
- **照片、文件**：点「选择照片或文件」，可以多选。电脑上：
  - 存进隔空传送的保存位置（默认「下载」文件夹），重名自动改名；
  - 进复制记录，按设置把文件写进剪贴板，在聊天软件或文件夹里能直接粘贴；
  - 和本机复制文件一样发给其他已配对的设备：50 MiB 以内自动推送，更大的对方点了才取。
- 上传有进度条；中途断了从断开的那一块接着传。

#### 2.1.4 电脑 → 手机

- 「记录」里显示电脑上的复制记录（包括电脑从其他设备收到的），新记录实时出现。
- **文字**：点「复制」。浏览器不支持时选中全文，提示长按复制。
- **图片**：显示缩略图，点「下载」打开原图，长按保存到相册。
- **文件**：点「下载」；文件夹打包成 zip 下载。
- 电脑本机还没有内容的记录（在其他设备上、超过阈值没拉取的）也显示出来，但不能下载，标「内容在 ××× 上」。

#### 2.1.5 记住这台手机

- 把网页加进收藏或主屏幕，下次直接打开，不用再扫码。
- 30 天没用自动失效；电脑上可以随时移除某台手机。
- 电脑换了 IP 地址，收藏的网址就打不开了，要重新扫码。

### 2.2 添加到主屏幕的提示

**只能引导用户自己添加，不能一键添加。**

- Android Chrome 的「安装应用」弹窗（`beforeinstallprompt`）只给 https 网站；
- iOS 从来没有让网页触发添加的接口。

我们的网页是 http，两边都只能由用户在浏览器菜单里自己点。

**网页上的提示：**

1. 第一次连上、成功发出或收到一条内容后，在页面底部显示一张卡片：「添加到主屏幕，下次一点就能打开」。不在刚打开时就弹，免得挡住第一次使用。
2. 卡片按浏览器给出对应的步骤，配一张示意图：

   | 浏览器 | 步骤 |
   |---|---|
   | iPhone Safari | 底部「分享」→「添加到主屏幕」→「添加」 |
   | iPhone 上的 Chrome | 地址栏的「分享」→「添加到主屏幕」 |
   | Android Chrome | 右上角 ⋮ →「添加到主屏幕」→「添加」 |
   | 华为、小米、vivo、OPPO 自带浏览器 | 菜单 →「添加到桌面」或「发送到桌面」；部分系统要先允许浏览器「创建桌面快捷方式」 |
   | 微信、QQ 内置浏览器 | 不能添加：先点右上角 ··· →「在浏览器中打开」，再按上面的步骤 |
   | 认不出的浏览器 | 只说「在浏览器菜单里找『添加到主屏幕』」 |

3. 卡片上有「知道了」和「不再提示」。点「知道了」，下次打开还会出现；「不再提示」记在浏览器本地。
4. 从主屏幕图标打开时（iOS 用 `navigator.standalone`，其他平台用 `display-mode: standalone` 媒体查询判断），不再显示这张卡片。
5. 设置里也留一个「添加到主屏幕」入口，随时能再看步骤。

**图标和名字**：页面提供 `apple-touch-icon` 和 Web App Manifest（名字「隔空贴」、图标、`display: standalone`），添加后主屏幕上显示隔空贴的图标。http 网站的 Manifest 各浏览器认不认，**待验证**。

**添加之后的限制：**

- **密钥要跟着网址走。**主屏幕图标保存的是当时的网址。iOS 上从主屏幕打开的网页用的是一份单独的存储，读不到在 Safari 里存的密钥。所以网页读出 `#` 后面的密钥后不把它从地址栏去掉，让添加时连密钥一起存进去。添加时会不会带上 `#` 后面的部分，**待验证**；不带的话，从主屏幕打开时要再扫一次码。
- **电脑关着时，看到的是浏览器自己的错误页。**离线页面要靠 Service Worker，它也只给 https。所以电脑关机、换了 IP、不在同一 Wi-Fi 时，点主屏幕图标看到的是浏览器的「无法访问」，网页没法给出自己的提示。这一点写进卡片的说明里：「电脑要开着，并和手机在同一个 Wi-Fi」。
- 电脑换 IP 后，旧图标就失效了，要重新扫码再添加一次。台式机建议在路由器里固定 IP，[局域网直连](lan-mode.md)里也是这么建议的。

### 2.3 服务的启停与二维码

**网页由电脑上现有的后台服务提供，不另起程序。**后台服务随 App 注册为登录项：开机自启、崩溃自动拉起、关掉窗口也照常运行（`ui/lib/background_service.dart`）。它本来就在局域网上收发 UDP 和 TCP，这次只是多监听一个 HTTP 端口。

| 状态 | 后台服务做什么 |
|---|---|
| 开关关着（默认） | 不监听端口，手机打不开网页 |
| 开关打开 | 一直监听 TCP 端口（暂定 8790），窗口关着、App 界面没开也照样能用；已登记的手机随时能打开网页 |
| 电脑睡眠 | 网页打不开；唤醒后地址没变就恢复 |
| 关掉开关 | 停止监听，断开所有网页连接；已登记的手机保留，重新打开开关后照常能用 |
| 退出 App（Windows 托盘「退出」等） | 后台服务停下，网页随之不可用 |

**二维码一次只登记一台手机：**

1. 打开二维码窗口时，后台服务生成一张邀请（邀请 ID 加密钥），只放在内存里。
2. 有手机用它连上（第一次 `hello` 解密成功）后，电脑给这台手机发一对专属的会话 ID 与密钥（2.4.2 节），写进 `web_sessions` 表，邀请作废；窗口里列出这台手机，二维码马上换成新的，给下一台用。
3. 已经用过的二维码，别的手机再扫会被拒绝，防止二维码被拍下来反复使用。
4. 没被用过的二维码在窗口关闭或 10 分钟后作废，窗口开着时到期自动换新。

**地址：**二维码里的地址取后台服务当前的局域网地址（`transport/lan.LocalAddrs()`）。电脑有多个网络时默认选有默认路由的那个，窗口里可以切换；地址变化（换 Wi-Fi、拔网线）时，二维码跟着刷新。

### 2.4 安全

#### 2.4.1 为什么不用 https

- 局域网地址拿不到浏览器信任的证书。
- 自签名证书会弹全屏警告，用户养成点「继续」的习惯，比不加密更糟。

所以只能用 http。http 页面在浏览器看来不是「安全上下文」，带来两点限制：

- 浏览器的剪贴板接口（`navigator.clipboard`）不能用；
- 内置加密接口（`crypto.subtle`）也不能用，只有随机数（`crypto.getRandomValues`）可以用。

#### 2.4.2 设计

- **密钥放在网址 `#` 后面。**二维码里是一张「邀请」：邀请 ID 加 32 字节随机密钥，网址形如 `http://192.168.1.5:8790/#i=邀请ID&k=密钥`。手机第一次连上时，电脑用邀请密钥加密，下发这台手机专属的会话 ID 与会话密钥，邀请随即作废；网页把地址栏 `#` 后面换成 `#s=会话ID&k=会话密钥`，同时存进浏览器本地存储。这样同一张二维码第二台手机再扫会被拒绝（一码一台），添加到主屏幕时存下的也是这台手机自己的密钥。浏览器不会把 `#` 后面的部分发给服务器，网络上看不到密钥。
- **内容全部加密。**请求和响应里的文字、记录列表、缩略图、文件都用 secretbox（XSalsa20-Poly1305）加密：
  - 网页里用 tweetnacl-js（Unlicense 许可，随页面一起嵌进程序）；
  - 后台服务用 `golang.org/x/crypto/nacl/secretbox`（`x/crypto` 已在依赖里）。

  能解密就证明持有密钥，不另设登录。每条消息带递增序号，防重放。
- **文件分块。**每块 1 MiB 单独加密、单独校验，块号参与认证，防止重排和截断。
- **只收局域网的连接。**来源地址必须是私有地址：10/8、172.16/12、192.168/16、100.64/10（Tailscale）、169.254/16、fc00::/7、fe80::/10，其他一律拒绝。电脑有公网地址时也不会暴露。
- **默认关闭。**总开关关掉时不监听端口。二维码只在窗口打开时显示。网页内容里不显示密钥；地址栏的网址里带着它，这是为了能添加到主屏幕（2.2 节），所以不要把这个网址发给别人。
- **限速。**同一来源解密失败多次就暂时拒绝。

#### 2.4.3 防不住的

- **篡改网页。**网页代码本身是用 http 下发的。同一个网络里有人主动篡改（比如 ARP 欺骗），就能改掉网页里的代码、拿到密钥。这是 http 下所有网页的共同问题，网页里自己加密只能防旁听。
- **看到二维码的人。**看到电脑屏幕上二维码的人也能扫码连上。所以二维码只在窗口打开时显示；连上的手机都列在窗口里，可以移除。
- **元数据。**同一个网络里能看到「这台手机在访问这台电脑」以及流量大小。

界面和帮助文档要照实说明这三点；要端到端加密，用 App。

### 2.5 技术方案

#### 2.5.1 架构

```text
手机浏览器：web/phone（React + TypeScript + Tailwind CSS，Vite 构建）
    │  http，局域网，内容 secretbox 加密（tweetnacl）
    ▼
桌面后台服务：internal/webshare
    ├── 网页：构建产物嵌进程序（go:embed），只有静态文件
    ├── 会话：登记的手机、密钥、最后使用时间（SQLite 表 web_sessions）；邀请只在内存里
    ├── 接口：见 2.5.2
    └── 调用：sync.Engine（提交内容、本地路径、图片预览、搜索）、store（记录）、rpc.Hub（新记录事件）
```

网页的界面与 App 是同一套设计语言：颜色、圆角、间距取自 `ui/lib/theme.dart`，图标用 App 在 Windows、Linux 上用的 Fluent 图标；「复制记录」与 App 的记录页同样结构（大标题、搜索框、全部 / 文本 / 链接 / 图片 / 文件筛选、分组列表），底部「复制记录 / 发送」两个标签。Android App 沿用这一套（第 3 节）。

#### 2.5.2 HTTP 接口

调用都是 POST，请求体与回复体都是 `nonce‖密文`。查询参数 `s` 是会话 ID（扫码登记那一次是 `i`，邀请 ID）。会话不存在、解密失败这类没法加密回复的错误，用明文 JSON `{"err": 代码}`。

| 接口 | 作用 |
|---|---|
| `GET /` 与 `/assets/*` 等 | 网页。`index.html` 不缓存；`/assets/` 下文件名带内容哈希，长期缓存 |
| `POST /api/rpc` | 加密的 JSON 调用 `{ts, rid, m, a}`：`hello`（登记 / 核对、改名，返回电脑名与电脑时间）、`records`（分页、`filter`、`q` 搜索）、`text`、`full_text`、`upload_start`、`upload_cancel`、`upload_done`、`file_info` |
| `POST /api/chunk` | 上传一块：4 字节大端长度、说明 `{ts, rid, u, n}`、数据，一起加密 |
| `POST /api/fetch` | 下载一块（`chunk`）或缩略图（`thumb`）。回复解密后第一个字节 0 表示数据、1 表示 JSON 错误 |
| `GET /api/events` | 事件流（SSE）。EventSource 不能带请求体，凭据是查询参数 `t`：一段加密的 `{ts, rid}`，每次连接都要换新的 |

防重放：每次请求带按电脑时间校正的毫秒时间戳 `ts`（相差超过 2 分钟拒绝）与随机 `rid`（2 分钟内重复拒绝）。不用递增序号：同一台手机可能开着几个标签页，刷新后序号也会从头开始。`hello` 不看时间戳，因为网页要靠它的回复校正时钟。

端口固定 8790（TCP），被占用时退回随机端口，窗口里提示收藏的网址要重新扫码。

#### 2.5.3 和现有代码的接口

| 位置 | 改动 |
|---|---|
| `sync/local.go` | `Engine.SubmitLocal(ctx, content, via, applyLocal)`：走 `recordOutgoingVia` 落库，`offerToPeers` 发给其他设备（这种类型关了同步时只落库）；`applyLocal` 为真时按 `AutoApplyToClipboard` 经 Watcher 写本机剪贴板。`Engine.LocalPaths` 导出本机路径。Android 的 `SubmitText` 是它的文字特例 |
| `store` | `clips` 表新增 `via` 列：经由的手机名，记录仍是本机发出的。新表 `web_sessions`；密钥用 `identity.ProtectSecret` 加密后落盘（Windows 上是 DPAPI） |
| `daemon.proto` | `ClipRecord.via_name`；RPC `GetWebShare`、`SetWebShare`、`NewWebShareInvite`（返回网址与二维码点阵）、`CloseWebShareInvite`、`RemoveWebSession`；事件 `web_share_changed`（`invite_used` 是刚被扫码用掉的二维码） |
| `internal/qrcode` | 把文字编成二维码点阵（`rsc.io/qr`），界面按点阵画，扫码配对（3.3.9 节）也用它 |
| `config` | `web_share_enabled`，默认关 |
| 上传落盘 | 先写工作目录里的临时文件，收完移进 `EffectiveReceiveDir()`，重名改成「名字 (n).扩展名」，权限 0644 |
| `cmd/pasteferryd` | 组装 `webshare`，按开关启停；Windows 托盘在网页传输开着时多一项「手机扫码连接」，点了切到设备页并打开二维码窗口 |
| `cmd/pasteferry-cli` | `web`、`web on`、`web off`、`web invite [地址]`、`web remove ID` |

#### 2.5.4 网页

- **工程**：`web/phone/`，React 19、TypeScript、Tailwind CSS 4、Vite 8。`npm run build` 把产物输出到 `client-core/internal/webshare/web/`，与源码一起提交，构建后台服务不需要 Node。`webshare` 的测试核对 `index.html` 引用的文件都在、没有内联脚本。
- **开发**：`npm run dev`，Vite 把 `/api` 转发给本机 8790 端口的后台服务。
- **内容安全策略**：后台服务只允许同源的脚本和样式，所以构建关掉了 modulePreload 的内联脚本，也不内联资源。
- **复制文字**：隐藏输入框加 `document.execCommand('copy')`，必须在点击事件里同步调用，所以 64 KB 以内的文字随记录一起发来；更长的先点「加载全文」。失败时弹出可长按选中的全文。各浏览器是否支持**待验证**。
- **上传**：`File.slice` 按 1 MiB 切块，加密后逐块上传，网络错误重试 3 次。iPhone 选照片时 Safari 可能把 HEIC 转成 JPEG（**待验证**），电脑那边两种都能处理。
- **下载**：分块取回、解密，拼成 Blob。图片在弹层里显示，长按保存；其他文件直接下载。整个文件要放进手机浏览器内存，所以单个文件上限暂定 200 MiB（**待实测**）。
- **事件流**：断了就换新凭据重连（EventSource 自己重连会带旧凭据，被当成重放拒绝），退避到 30 秒；回到前台时立即重连并刷新列表。手机被移除时显示「这台手机已被移除」。

#### 2.5.5 桌面界面

- 设备页的「手机网页传输」区块：开关、「显示二维码」、已登记的手机（名称、最后使用时间、移除）。刚打开开关时直接弹出二维码。
- 二维码窗口：二维码（按后台服务给的点阵画，一律深色画在白底上，深色模式也是）、网址、地址切换、安全提示、打不开时的排查提示。被扫码用掉、快过期、地址变了时自动换新；关窗口时作废没用过的那张。
- 复制记录里，网页发来的内容显示「来自 iPhone」（`recordSource` 看 `via_name`），快捷粘贴窗口同样。
- 截图工具里加了 `web-share` 与 `web-share-dark` 两个场景，官网以后可以用。

### 2.6 防火墙与系统权限

- **Windows**：设置里的「放行」按钮按程序放行入站 TCP 和 UDP（`transport/lan/permission_windows.go`），对任何端口都有效。从没放行过的电脑，开启时提示点「放行」；不放行，手机打不开网页。
- **macOS**：系统防火墙默认关。用户打开了的话，后台服务接受入站连接时会不会弹询问，**待验证**。
- **网络隔离**：访客网络、开了 AP 隔离的路由器里，手机连不上电脑。网页打不开时，二维码窗口里提示检查这一点。

### 2.7 测试

- **Go 单元测试**：
  - secretbox 加解密与 tweetnacl-js 的测试向量一致；序号防重放；
  - 分块上传的乱序、缺块、重复块、超长都被拒绝；
  - 非私有地址被拒绝；会话 30 天过期、移除后立即失效；
  - 二维码：同一个码只能登记一台手机；没用过的码在窗口关闭或 10 分钟后作废；开关关掉后不再监听端口，重新打开后已登记的手机照常能用；
  - `SubmitLocal`：记录落库、发给其他设备；`applyLocal` 为真时写本机剪贴板且不被 Watcher 当成新复制，为假时不写。
- **集成测试**：用 Go 写一个按同样加密协议说话的测试客户端，覆盖发文字、上传、取记录、下载、事件流断线补齐。
- **网页**：在桌面浏览器里跑一遍上传、下载、复制。

### 2.8 先验证的事

1. 各浏览器能否复制文字：iPhone 的 Safari、Chrome、微信内置浏览器，Android 的 Chrome、华为 / 小米 / vivo 自带浏览器、微信内置浏览器、UC、QQ 浏览器。
2. 下载：各浏览器里 Blob 下载能否成功、图片能否长按保存到相册；能承受多大的文件；微信内置浏览器会不会拦截。
3. 上传：iPhone 照片的格式；500 MB 视频在 tweetnacl-js 加密下的速度与发热。
4. 用 http 打开局域网地址时，各浏览器会不会拦截或弹警告。
5. 浏览器切到后台、锁屏、再回来时，事件流的重连与补齐。
6. 添加到主屏幕：
   - 各浏览器添加后的图标和名字对不对（http 网站的 Manifest 和 `apple-touch-icon` 认不认）；
   - 保存的网址带不带 `#` 后面的密钥；
   - 从图标打开时，能否被识别为主屏幕打开（不再显示提示卡片）；
   - 国内自带浏览器的「添加到桌面」要不要额外授权。
7. Windows 防火墙（放行前后）、macOS 防火墙打开时的表现。

### 2.9 工作量

按一个人全职估算：

| 部分 | 时间 |
|---|---|
| `webshare` 包、加密、会话、接口、`SubmitLocal` | 1–1.5 周 |
| 网页：发送、上传、记录、下载、复制、添加到主屏幕的提示、五种语言 | 1 周 |
| 桌面界面：开关、二维码、手机列表、托盘入口 | 0.5 周 |
| 测试与 2.8 节真机验证 | 0.5–1 周 |

合计约 **3–4 周**。

## 3. Android App 一期

### 3.1 范围

#### 3.1.1 做什么

| 功能 | 行为 |
|---|---|
| 局域网配对 | 三种方式：**扫码配对**（推荐，不用核对指纹，3.3.9 节）；「搜索附近设备」雷达和配对码，这两种要核对安全指纹，跨网段时输入对方地址，沿用桌面的局域网模式 |
| 复制记录 | 列表显示双向的记录（来源设备、时间、类型），可以搜索、查看详情、删除 |
| 收到文字 | 电脑复制文字 → 手机进记录，**同时自动写入手机剪贴板**，在任何 App 里长按就能粘贴。设置里可以关掉自动写入 |
| 收到图片、文件 | 进记录，**不自动写剪贴板**。在记录上点「复制」才放进剪贴板，另有「保存」「分享」 |
| 手机发文字 | 发送页里输入或粘贴文字 → 点发送 → 进手机的记录，并发给所有在线的已配对设备。电脑收到后进它的复制记录，按电脑自己的设置写入剪贴板，效果和在另一台电脑上复制一样 |
| 后台在线 | 退到后台后用前台服务保持连接，所以手机不开着隔空贴也能收到文字。有一条常驻通知，设置里可以关 |

#### 3.1.2 不做什么（留到后续，见 3.7 节）

- 跨网同步：信令服务器、官方服务、TURN 中转。一期手机和电脑必须在同一个局域网里。
- 手机发图片、文件（先用网页传输）；系统分享、选中文字菜单、通知栏「发送剪贴板」、快捷设置磁贴这些入口。
- 好友、隔空传送、快捷粘贴、无障碍。
- 自动更新：一期只提示有新版本，点了跳下载页。
- iOS（iPhone 用户先用网页传输，见 5.3 节）、鸿蒙 NEXT。

#### 3.1.3 和电脑端的关系

**现有的 2.6.x 电脑不用升级，就能用雷达或配对码和手机配对、同步。**手机在协议里就是一台普通设备；手机和手机之间也能同步。

只有扫码配对给协议加了字段（3.3.9 节）：只加不改，旧版本不受影响，但电脑要升级才能显示配对二维码。

桌面端的改动随下一个桌面版本发出，不影响互通：

- 添加设备窗口显示配对二维码，处理扫码配对的请求（3.3.9 节）。
- 设备列表把 `android` 显示成手机图标。现在未知系统一律显示成笔记本图标（`ui/lib/pages/devices_page.dart` 的 `platformIcon`）。
- 核心代码的共用改动（3.3.2 节），桌面端的行为不变。

#### 3.1.4 用户要知道的边界

- **手机上复制的内容不会自动发出去。**要在隔空贴的发送页里粘贴再发。Android 10 起，只有当前在前台的 App 和默认输入法能读剪贴板。
- **记录只包含配对之后的内容**，不会把电脑上已有的历史搬过来。手机离线期间电脑复制的内容，要电脑打开了「补发离线期间的内容」（默认关）才会在重新连上后补发最近 20 条、24 小时以内的，补发的只进记录、不写剪贴板。这份补发队列在电脑内存里，电脑重启就没了。
- 后台在线靠常驻通知。国内手机还要用户手动把隔空贴加进「自启动 / 后台运行」白名单，否则锁屏一段时间后会被系统停掉，要再打开 App 才会重新连上。

### 3.2 用户怎么用

#### 3.2.1 首次使用

1. 安装 APK，打开，起设备名。
2. 允许通知（Android 13+）：常驻通知要用。拒绝也能用，只是看不到通知。
3. 配对：默认打开扫码，扫电脑「添加设备」窗口里的二维码，电脑上点「确认」（3.3.9 节）。电脑是旧版本、显示不了二维码时，改用「搜索附近设备」（两边都打开，点对方）或输入电脑显示的配对码，两边核对指纹后确认。
4. 引导「允许后台运行」：跳到系统的电池优化设置；国内机型再按品牌说明「自启动 / 后台运行 / 锁屏清理」的位置。可以跳过，首页留一条提示。

#### 3.2.2 电脑 → 手机

- **文字、网页格式的文字**：进记录，写入手机剪贴板（网页格式写成 HTML 加纯文本）。Android 13+ 系统会弹出「已复制」预览，这时候手机的剪贴板里就是电脑刚复制的内容。
- **图片**：50 MiB 以内的由电脑自动推送过来，记录里显示缩略图。点「复制」写入剪贴板，目标 App 能不能粘贴图片取决于它自己；点「保存」存进相册，点「分享」发给别的 App。
- **文件**：同样自动推送 50 MiB 以内的。点「复制」写入剪贴板，能不能粘贴取决于目标 App；「保存」存进「下载」目录，「分享」发给别的 App。
- **超过 50 MiB 的图片和文件**：只先显示名称和大小，按钮相同。点「复制」时先下载，下载完写入剪贴板；点「保存」「分享」时也先下载，但不动剪贴板。
- **文件夹**：显示里面的文件列表，可以逐个保存或分享。一期不支持把整个文件夹放进剪贴板。
- 推送阈值由电脑决定，就是电脑设置里的「自动同步上限」，手机这边一期改不了。都在局域网里，不考虑流量问题。

#### 3.2.3 手机 → 电脑

1. 打开隔空贴，进「发送」页。
2. 如果剪贴板里有文字，输入框上方显示「粘贴剪贴板里的文字」。这一步只看剪贴板里有没有文字，不读内容，系统不会弹提示；点了才真正读取。
3. 在输入框里输入或粘贴，可以修改，点「发送」。
4. 文字进手机的记录，并发给所有在线的已配对设备；某台设备不想收，就在设备菜单里关掉对它的同步（沿用现有的按设备开关）。
5. 没有在线设备时，发送按钮不能点，显示「附近没有在线的设备」。部分设备不在线时，它们会在上线后收到补发（与电脑端相同；手机上的补发队列也在内存里，App 被系统停掉就没了）。

#### 3.2.4 记录

- 和桌面一样按时间倒序，显示来源设备、类型、预览。
- 点开看全文、图片预览、文件列表；长按删除。
- 搜索沿用桌面的拼音搜索。
- 收藏的接口和桌面共用，界面顺带支持，但不作为一期的验收项。

#### 3.2.5 常驻通知

- 内容只写连接状态，比如「已连接 MacBook、办公室台式机」，和最近一条的来源与类型（「来自 MacBook 的文字」），不写正文。
- 点通知打开 App。
- 设置里关掉「后台保持连接」后，常驻通知消失，App 离开前台就断开，回到前台重新连接并收补发。

### 3.3 技术方案

#### 3.3.1 架构

```text
Flutter 界面：记录 / 发送 / 设备 / 设置
    │  gRPC，127.0.0.1 + 一次性 token（复用 DaemonConnection）
    ▼
Go 核心：与 pasteferryd 同一套组装逻辑，以库的形式跑在 App 进程里
    │  只开局域网通道（mDNS 发现 + UDP 信令 + WebRTC 直连 + 局域网 TCP 快速通道）
    │  宿主回调：写剪贴板、通知内容
    ▼
Kotlin 宿主
    ├── 前台服务（connectedDevice）：持有唯一的 Go 核心实例 + 常驻通知
    ├── 剪贴板写入（文字、HTML、图片 / 文件的 content:// URI）
    ├── MulticastLock、通知权限、电池优化引导
    └── FileProvider；保存到相册 / 下载目录；系统分享
```

- **复用 gRPC。**桌面 UI 本来就经本机 gRPC 连守护进程：守护进程把端口和一次性 token 写进 `daemon.json`（`client-core/internal/rpc/endpoint.go`）。Android 上 Go 核心照样监听回环端口，把 `daemon.json` 写进 App 私有目录，Flutter 的 `DaemonConnection` 只改数据目录就能连。57 个 RPC 都不用写平台通道。
- **原生桥只留几个调用**：`Start(dataDir, host)`、`Stop()`、`Status()`。`host` 是 Kotlin 实现的回调接口：`WriteClipboard(kind, text, html, paths)` 和 `UpdateNotification(summary)`。
- **桥接**用 `gomobile bind` 产出 AAR（需要 NDK，cgo 只在这一层）；备选是 `-buildmode=c-shared` 加 JNI。不把 `pasteferryd` 当子进程跑：Android 12 起系统会限制和查杀 App 的子进程，生命周期也更难管。
- **进程模型**：Go 核心由前台服务启动，不依赖界面。界面关掉后核心继续在服务里跑；界面打开时经 gRPC 连上。用户关掉后台在线时，由界面所在的 Activity 管核心的启停。

#### 3.3.2 Go 核心改动

| # | 位置 | 改动 |
|---|---|---|
| 1 | 所有 `//go:build linux` 的文件 | `GOOS=android` 同时满足 `linux` 标签，X11 剪贴板（`clipboard/linux.go`）、D-Bus 通知、`systemd-inhibit`（`power/power_linux.go`）都会被编进去。改成 `linux && !android`，新增 `*_android.go` |
| 2 | 构建参数 | pion 的间接依赖 `wlynxg/anet` 用 `go:linkname` 引用 `net.zoneCache`，Go 1.26 默认拒绝链接。加 `-ldflags=-checklinkname=0`（已实测可行）；v0.0.5 已是最新版，同时跟进上游 |
| 3 | `transport/lan/addrs.go`、`transport/p2p/egress_history.go` | 直接调 `net.Interfaces()`，Android 11 起可能拿不到网卡列表（**待验证**）。改用依赖里已有的 `anet.Interfaces()` |
| 4 | `clipboard/android.go`（新） | 实现 `Clipboard` 接口。`Write` 经宿主回调写入；图片和文件传本地路径，由 Kotlin 转成 FileProvider URI。`Peek` 返回一个只在本机写入时增加的变化计数，所以 Watcher 永远不会把后台写入当成新复制再发出去。`Read` 返回 `ErrUnsupported`：手机发出的内容走第 5 条的 `SubmitText`，不经 Watcher |
| 5 | `sync/engine.go` + `daemon.proto` | 复用网页传输加的 `Engine.SubmitLocal(content, originName, applyLocal)`（2.5.3 节）：直接调用 `recordOutgoing` 和 `offerToPeers`，跳过 `watcher.Read`，其余与本机复制完全相同。Android 上提交的是手机本机的内容，`applyLocal=false`，不写本机剪贴板。新增 RPC `SubmitText` 给 Flutter 调用 |
| 6 | `config` + `sync/engine.go` 的 `finishReceive` | 新增配置项「收到图片和文件后自动写入剪贴板」，只管自动推送：桌面默认开，行为不变；Android 默认关。文字仍由 `AutoApplyToClipboard` 控制。用户点的下载走现有的 `Fetch`：「复制」用 `preserve_clipboard=false`，下载完写入；「保存」「分享」用 `preserve_clipboard=true`，不动剪贴板。已经在本地的记录，「复制」直接调 `ApplyToClipboard` |
| 7 | `cmd/pasteferryd/main.go` | 组装逻辑都写在 `main()` 里（767 行）。抽出 `internal/runtime`，桌面和 Android 共用；Android 入口放在 `client-core/mobile/`，只开局域网通道，不起托盘、热键、快捷粘贴、自动更新安装 |
| 8 | 数据目录 | 由宿主传入 App 私有目录。私钥沿用现在非 Windows 平台的做法（`identity/protect_other.go`，0600 文件），App 沙盒保证其他 App 读不到；用 Android Keystore 加密放到后续阶段。数据目录不参与系统云备份 |

第 4 条里，Watcher 依赖的主线程 `MainLoop` 在 Android 上不需要锁定 OS 线程：Kotlin 那边会自己切到主线程写剪贴板，Go 这边只要保证调用一个接一个执行。

#### 3.3.3 Kotlin 宿主

- **`PasteFerryApp`**（Application）：持有 Go 核心单例，Activity 重建时不重复启动。
- **`SyncService`**（前台服务，类型 `connectedDevice`）：
  - 官方定义是「与需要蓝牙、NFC、红外、USB 或网络连接的外部设备交互」。前提是声明 `CHANGE_NETWORK_STATE`、`CHANGE_WIFI_STATE`、`CHANGE_WIFI_MULTICAST_STATE` 之一；隔空贴本来就要用 `CHANGE_WIFI_MULTICAST_STATE`。
  - 没有 `dataSync` 那样「每 24 小时最多在后台跑 6 小时」的限制（Android 15 起）。
  - 只在用户打开 App 后启动。开机自启放到后续阶段：要验证 Android 15 起对 `BOOT_COMPLETED` 启动前台服务的限制是否涉及 `connectedDevice`。
- **剪贴板**：在主线程调 `ClipboardManager.setPrimaryClip`。
  - 文字用 `ClipData.newPlainText`，网页格式用 `ClipData.newHtmlText`；
  - 图片、文件用 `ClipData.newUri`，URI 由 FileProvider 生成（`grantUriPermissions="true"`），指向 Go 核心的缓存目录。缓存按 `CacheTTL`（默认 3 天）清理后，旧记录的 URI 随之失效，界面上显示为「已过期」。
  - Android 写剪贴板不需要焦点（AOSP 源码："Writing is allowed without focus."），所以服务在后台也能写。
- **局域网**：在线期间持有 `WifiManager.MulticastLock`，否则 Android 会丢弃 mDNS 用的组播包。监听网络变化，离开 Wi-Fi 时在界面上显示「不在局域网中」。
- **保存与分享**：图片经 MediaStore 存进相册，文件存进「下载」目录（Android 10 起不需要存储权限）；分享用 `ACTION_SEND` 加 FileProvider URI。

#### 3.3.4 Flutter 界面

- **新增 Android 工程**：`flutter create --platforms=android`。`desktop_drop` 没有 Android 实现，按平台条件引入。
- **复用**：`app_state.dart`、`records.dart`、`daemon_client.dart`（只改数据目录的取法）、配对对话框、雷达、记录详情、五种语言的文案。
- **新做**：
  - 底部标签：记录 / 发送 / 设备 / 设置。
  - 发送页：输入框、「粘贴剪贴板里的文字」、发送按钮、在线设备数。
  - 记录上的「复制 / 保存 / 分享」，以及下载进度（沿用桌面的进度事件）。
  - 首次引导：通知、配对（默认打开扫码）、后台运行。
  - 扫码页与「显示二维码」页（3.3.9 节）。
  - 触控尺寸、返回键。
- **读剪贴板**：发送页用 Flutter 自带的 `Clipboard.hasStrings()` 判断有没有文字。Android 上它只查剪贴板的元数据；官方文档说只取元数据（`getPrimaryClipDescription()`）不会弹「已粘贴」提示。点了按钮才用 `Clipboard.getData()` 读内容。这些都在 App 前台进行，不经 Go 核心。
- **不在 Android 上出现**：托盘、全局热键、快捷粘贴窗口（`ui/lib/picker`）、`background_service*.dart`、服务器与官方服务页、好友页、隔空传送、手机网页传输。

#### 3.3.5 权限

| 权限 | 用途 | 说明 |
|---|---|---|
| `INTERNET` | 所有网络 | — |
| `CHANGE_WIFI_MULTICAST_STATE` | MulticastLock，mDNS 发现 | 普通权限，安装即有；也是 `connectedDevice` 的前提 |
| `FOREGROUND_SERVICE`、`FOREGROUND_SERVICE_CONNECTED_DEVICE` | 后台保持连接 | 普通权限 |
| `POST_NOTIFICATIONS` | 常驻通知 | Android 13+ 运行时请求，拒绝也能用 |
| `CAMERA` | 扫码配对 | 只在点「扫码」时请求；拒绝后仍可用雷达或配对码 |
| `ACCESS_LOCAL_NETWORK` | 局域网访问 | 应用 target SDK 37（Android 17）起必须在运行时请求，见下 |

**局域网权限**：Android 17 起，target SDK 37 的应用访问局域网（mDNS、UDP、TCP）都要先拿到 `ACCESS_LOCAL_NETWORK`，它属于「附近的设备」权限组；target SDK 36 及以下由 `INTERNET` 隐式授予，而且官方要求这时不要声明它。

- **一期 target SDK 36**：少一个权限弹窗。APK 不经 Play 分发，没有 target SDK 的要求。
- 拒绝和撤销的处理照样写好（局域网不通时提示去设置里打开），升到 37 时只需要声明权限并在配对前请求。
- 系统的 NSD 设备选择器一次只能选一台设备，也只管发现，对隔空贴不适用。
- 回环地址上的 gRPC 不受这条规则影响（**待验证**）。

#### 3.3.6 后台在线

- 一期依靠：前台服务 + 引导用户关闭电池优化 + 国内机型的白名单说明页。
- 锁屏久置后，系统的省电模式（Doze）会不会掐断局域网连接、多久恢复，**待验证**（3.5 节第 5 条）。
- 省电：后台不做额外的探测。局域网通道本身的节奏是对未连通设备每 10 秒、已连通设备每 30 秒发一次 hello，耗电要实测。

#### 3.3.7 构建与分发

- **Go 核心**：`gomobile bind -target=android/arm64,android/amd64`（amd64 给模拟器），加 3.3.2 节第 2 条的链接参数。
- **APK**：`flutter build apk --target-platform android-arm64`。体积估计 30–50 MB，**待实测**：未裁剪的 Go 核心 arm64 可执行文件约 40 MB，正式包会去掉调试信息。
- **签名**：生成一把 Android 发版密钥，存在发版的 Mac 上，保存与备份方式参照更新私钥。它和 Mac 证书一样永远不换：换了用户只能卸载重装，官网 `assetlinks.json` 里写的证书指纹也会对不上（3.3.9 节）。APK 在这台 Mac 上本地构建，不放进 CI。
- **一期分发**：签名 APK 直接发给内测用户。公开发布时再定：
  - 进 Release 附件，从 14 个变成 15 个，要同时改 [commits-and-releases.md](../.claude/rules/commits-and-releases.md)、`tools/release/manifest.py`、Release 正文的下载表和官网下载页；
  - Google 开发者验证：2026-09-30 起已在巴西、印尼、新加坡、泰国生效，2027 年扩展到全球所有经认证的 Android 设备。在 GitHub 上公开发 APK，2027 年前要在 Android Developer Console 完成验证。国内没有 GMS 的手机是否受影响，**待确认**。

#### 3.3.8 最低版本

| 项 | 取值 | 理由 |
|---|---|---|
| minSdk | **28（Android 9）** | App 与 gomobile 核心同时使用 API 28，同一个 arm64 APK 支持 Android 9 及以上 |
| targetSdk / compileSdk | 36 | 本机 Flutter 3.44.9 的默认值；不用申请局域网权限（3.3.5 节） |
| CPU 架构 | arm64-v8a | 32 位的 armeabi-v7a 等内测反馈再决定要不要加；模拟器另编 x86_64 |

2.7.3 起从 Android 10 下放到 Android 9，不需要另出兼容 APK：

- Flutter、Go 核心与现有插件支持 API 28。前台服务经 `ServiceCompat` 在 Android 9 调用不带类型的系统接口。
- Android 9 只在点击「保存」时申请存储权限；允许后写入公共 Pictures/PasteFerry 或 Download/PasteFerry，图片通知媒体库收录。拒绝则说明原因并保留重试入口，同名文件另存而不覆盖。
- Android 10 及以上继续经 MediaStore 保存，不申请旧版存储权限；权限声明限定 `maxSdkVersion=28`。
- Android 9 也保持由用户在发送页粘贴并发送，不额外增加后台剪贴板读取。
- `FileSaverTest` 用 API 28 / 29 验证授权边界、保存、目录结构和同名文件保护；CI 同时运行 Android lint 检查高版本 API 的使用。
- **鸿蒙**：鸿蒙 2–4 的华为手机能装 APK（**待真机验证**）；鸿蒙 NEXT 不能。

#### 3.3.9 扫码配对

**用户怎么用：**

1. 电脑上打开「设备 → 添加设备」，窗口里在配对码上方显示二维码，写着「用隔空贴手机 App 扫码」。配对码仍保留，给旧版本和其他输入方式用。
2. 手机上点「设备 → 添加设备 → 扫码」，扫电脑上的二维码。首次使用时的配对步骤默认就打开扫码。
3. 手机上显示「已配对，等待 MacBook 确认」；电脑上弹出「『小米 14』请求配对」，点「确认」。
4. 两边都不用核对指纹。电脑确认后马上连上，手机上变成「已连接」。

不打开 App、直接用系统相机扫也行，见下文「系统相机扫码」。

**为什么可以不核对指纹：**

现在要核对指纹，是因为配对码在局域网里明文传输：截到码的人可以冒充一方（`transport/lan/pairing.go` 开头的注释）。二维码不一样，它只出现在电脑屏幕上，用户亲眼看着扫，相当于一条别人插不进来的通道：

- **手机确认电脑是真的。**二维码里有电脑的设备 ID，设备 ID 是公钥的哈希（`deviceid.For`）。手机收到电脑的回复时，核对回复里的公钥算出的 ID 和二维码里的一致，就知道对方确实是这台电脑。
- **电脑确认手机是扫了码的那台。**二维码里还有一个 16 字节的一次性密钥 `k`，它**不在网络上传**。手机发请求时只附上用它算出的校验值：

  `HMAC-SHA256(k, "pasteferry-qr-pair|v1|" ‖ 电脑 ID ‖ 手机公钥 ‖ 请求 nonce)`

  电脑核对通过，就知道请求来自扫了二维码的手机，而且手机的公钥在路上没被换过。

两边都拿到了对方真实的公钥，核对指纹就可以省掉。电脑上保留一次「确认」，挡住偷拍了二维码、又恰好在同一个网络里的人。

**二维码内容：**

`https://pasteferry.cc/pair#v=1&id=<电脑设备 ID>&k=<密钥>&a=<地址>&n=<电脑名>`

| 字段 | 内容 |
|---|---|
| `v` | 格式版本，现在是 1 |
| `id` | 电脑的设备 ID |
| `k` | 一次性密钥，16 字节，base64url |
| `a` | 电脑的局域网信令地址（`ip:port`），逗号分隔，最多 4 个，默认路由所在的网卡排第一；就是 `CreatePairingCodeResponse.lan_addresses` |
| `n` | 电脑名，UTF-8 再 base64url，最多 40 字节，只用于显示 |

- 全部放在 `#` 后面：用系统相机扫码、在浏览器里打开时，pasteferry.cc 的服务器也看不到这些内容。
- 总长约 150 个字符，二维码不会太密，手机隔一臂距离也扫得清。

**流程：**

1. **电脑**：打开添加设备窗口时，除了配对码，再生成 `k`，在局域网通道里开放「二维码配对」。和配对码一样 5 分钟有效、用一次就作废，窗口关掉就撤回。
2. **手机**：解析二维码，在 mDNS 里带上 `s=1`（沿用配对码的「敲门」：没放行防火墙的 Windows 也能收到请求）。然后向二维码里的地址、以及 mDNS 里带 `p=1` 的实例发 `pair_request`：`LanPairInfo` 里新增的 `qr_proof` 填上面的校验值，`code` 留空。每 500 毫秒重发一次，5 秒为限。
3. **电脑**：收到带 `qr_proof` 的请求，用 `k` 做常量时间比较：
   - 通过：撤下 `k`，回 `pair_response`（和现在一样带签名、回显 nonce），进入待确认，界面弹出简化的确认框（只显示手机名和型号，不显示指纹）；
   - 不通过：回 `pair_reject`（`wrong_code`）。
4. **手机**：收到回复后校验签名，并核对 `deviceid.For(回复里的公钥)` 等于二维码里的 `id`。
   - 对得上：自动确认，落库，开始连接；
   - 对不上：当作失败，提示「二维码与回应的设备不一致」。
5. **电脑**：用户点「确认」后落库，并重放手机此前发来的信令（现有的 `replaySignals`），马上连通。用户点「拒绝」或确认框超时，电脑向手机回一个 `pair_reject`，原因用新增的 `declined`；手机收到后撤掉这次配对，提示「电脑拒绝了配对」。

配好之后，和用其他方式配好的设备完全一样。

**改动：**

| 位置 | 改动 |
|---|---|
| `proto/pasteferry/v1/wire.proto` | `LanPairInfo` 新增 `bytes qr_proof = 12`；`LanPairReject.reason` 新增取值 `declined`。旧版本不显示二维码，也就不会收到这种请求 |
| `transport/lan/pairing.go` | 显示方：开放与撤回二维码配对；`handlePairRequest` 按有没有 `qr_proof` 分两路。扫码方：新增 `PairQR(ctx, payload)`，发请求、核对回复的设备 ID；处理 `declined` |
| `peers/manager.go` | `CreatePairingCode` 同时生成 `k`、返回二维码内容；新增 `RedeemPairingQR`，核对通过后自动确认；显示方的待确认会话记下「已由二维码验证」；拒绝或超时时回 `declined` |
| `daemon.proto` | `CreatePairingCodeResponse` 新增 `qr_payload`；新增 RPC `RedeemPairingQR`（返回 `RedeemPairingCodeResponse`）；配对事件里的 `Device` 新增 `verified_by_qr`，界面据此显示简化的确认框 |
| 桌面界面 | 添加设备窗口加二维码，与网页传输共用同一个二维码组件；简化的确认框（`ui/lib/widgets/pairing_dialog.dart`） |
| Android | 扫码页（只在点「扫码」时申请相机权限）、二维码解析与出错提示、「等待电脑确认」状态 |

**手机与手机**：Android App 的添加设备里也有「显示二维码」，让另一台手机扫，流程相同。电脑一般没有摄像头，不做电脑扫手机。

**扫码组件**：国内很多手机没有 Google Play 服务，扫码不能依赖它（Google 的 code scanner 接口要 Play 服务）。用 ZXing，或者把识别模型打包进 App 的 ML Kit。具体用哪个 Flutter 插件实现时定，在没有 Play 服务的手机上能不能用，**待验证**。

**系统相机扫码：**

- **装了 App**：App 注册 `https://pasteferry.cc/pair` 的 App Link（`autoVerify`），官网放 `/.well-known/assetlinks.json`，里面写 APK 签名证书的 SHA-256。系统相机扫码后直接打开 App 的配对页。
- **没装 App，或系统没验证 App Link**：打开的是官网的 `pair` 页面。没有 Google Play 服务的手机上，域名验证可能不生效，**待验证**。这个页面：
  - 只在浏览器里读 `#` 后面的内容，不发给服务器；
  - 显示「打开隔空贴」按钮，用 `pasteferry://pair#…` 自定义协议拉起 App；
  - 给出 Android 版的下载链接。
- **微信扫码**：会在微信里打开这个页面，微信不让跳到其他 App，页面提示改用系统相机或隔空贴 App 里的「扫码」。
- 官网页面走现有的 `tools/site` 生成，五种语言，随官网部署。

**和网页传输的二维码分开：**

- 两个二维码在不同的窗口：「添加设备」里的是配对用的（`https://pasteferry.cc/pair#…`），「手机网页传输」里的是网页用的（`http://局域网地址:8790/#…`）。
- App 扫到网页传输的二维码时，提示「这是网页传输的二维码，配对请扫『添加设备』里的二维码」。

**兼容：**

- 扫码配对要新版桌面端（显示二维码、处理 `qr_proof`）。桌面这部分随网页传输或下一个桌面版本发出，要早于 Android App 发布。按发版规范是 MINOR：只加字段，不破坏旧协议。
- 旧的 2.6.x 电脑照样能用雷达或配对码和手机配对，这时要核对指纹。

#### 3.3.10 实现记录（2026-10-28）

一期 Android 已按本节做出来，与上面方案不同或补充的地方：

- **Go 核心的组装**放在 `client-core/mobile/`（`Start`、`Stop`、`Running`），没有从 `cmd/pasteferryd/main.go` 抽出 `internal/runtime`：手机只用其中一小部分，抽出来反而让桌面的改动变大。手机这边不引用 X11 剪贴板、D-Bus 通知这些包，所以 3.3.2 节第 1 条的构建标签不用改。
- **宿主接口**是 `WriteClipboard(kind, text, html, paths)` 和 `StatusChanged(online, lastFrom, lastKind)`：常驻通知的文字由 Kotlin 按系统语言拼，Go 只给数据。
- **网卡**：除了 `transport/lan/addrs.go`、`transport/p2p/egress_history.go` 改用 `anet`，mDNS 用的 pion/mdns 自己也会调 `net.Interfaces()` 和 `Interface.Addrs()`，在 Android 11 起都报 `netlinkrib: permission denied`。复制了一份到 `client-core/third_party/pion-mdns`，只改这两处，`go.mod` 用 replace 指过去（见那里的 `PASTEFERRY.md`）。
- **只出 arm64**：x86_64 的 Go 核心一启动就被系统杀掉，因为 SQLite 用的 `modernc.org/libc` 在 linux/amd64 上直接调 `lstat`、`open` 这类老系统调用，Android 给 x86_64 App 的 seccomp 规则不允许。
- **保存与分享**要知道收到的文件在本机的路径：`ClipDetail` 新增 `local_paths`（图片和文件已在本机时才有）。
- **构建**：`scripts/build-android.sh`。gomobile、gobind 的版本由 `client-core/go.mod` 的 `tool` 一节固定。APK（arm64，release）约 47 MB。
- **模拟器测试**（这台 Intel Mac 上实测可行的组合）：
  - 镜像用 `system-images;android-34;google_apis;x86_64`。API 36 的镜像在这台机器上图形栈会卡死。
  - AVD 的 `config.ini` 加 `kernel.parameters=clearcpuid=waitpkg`：12 代 Intel 有 TPAUSE 指令，HVF 不支持，不加内核一启动就 panic。
  - `-gpu swiftshader_indirect`；App 用 `adb shell am start -n com.pasteferry.app/.MainActivity --ez enable-impeller false` 启动，否则 Impeller 经 ARM 转译画不出来、截不了屏。
  - x86_64 镜像靠 ARM 转译（`libndk_translation`）跑 arm64 的 APK，但它执行不了几条指令（`MRS MIDR_EL1`、`MRS DIT`、读通用计时器），所以 Go 核心要用 `./scripts/build-android.sh --aar --emulator` 打，只给模拟器用。
  - 模拟器在 NAT 后面（10.0.2.15），发现不了电脑：配对时输入电脑的配对码，地址填 `10.0.2.2:<电脑的局域网端口>`。之后的直连照常建立。
- **已在模拟器上跑通**（对端是本机另起的测试用后台服务）：配对码 + 地址配对、两边核对指纹；电脑复制文字 → 手机进记录并写入剪贴板，App 在后台时也一样；手机发送页发文字 → 电脑进记录并写入剪贴板；「粘贴」按钮；电脑复制图片 → 手机显示缩略图、不自动写剪贴板，点「复制」写入（系统剪贴板浮层显示了缩略图）、「保存」存进相册的 Pictures/PasteFerry、「分享」打开系统分享面板；前台服务是 connectedDevice 类型。网页传输也在同一台模拟器的 Chrome 里跑通：登记、记录、缩略图、复制、发送。
- **还没做**：扫码配对（第 B 部分）、首次引导、电池优化的品牌说明页、真机验证（3.5 节）、发版签名。

### 3.4 测试

- **Go 单元测试**：
  - `SubmitText`（经 `SubmitLocal`，`applyLocal=false`）：记录落库、offer 发给所有允许同步的设备、离线设备进补发队列、不写本机剪贴板；
  - 新配置项：图片推送完成后桌面默认写剪贴板、关掉后不写；手动下载完成后仍写；
  - Android 剪贴板实现：本机写入不触发 Watcher 的变化回调。
- **集成测试**：沿用 `peers/manager_test.go` 的两实例模式，一边用 Android 的组装方式（只开局域网），一边用桌面的组装方式，跑配对、文字双向、图片推送、超阈值文件手动下载。
- **扫码配对**（Go 单元测试与 `peers/manager_test.go` 的两实例集成测试）：
  - 用二维码配对成功后两边落库、直连，全程不经过指纹核对；
  - `qr_proof` 用错的 `k` 算、换了手机公钥、换了 nonce，都被拒绝；
  - 同一个二维码第二次使用被拒绝；5 分钟过期、窗口关闭后被拒绝；
  - 回复的公钥与二维码里的设备 ID 对不上时，手机不落库；
  - 电脑拒绝或确认框超时：手机收到 `declined` 后撤掉配对；
  - 二维码内容的生成与解析：IPv6 地址、电脑名里的中文和 emoji、超长名字截断、未知版本号。
- **Flutter 测试**：发送页的按钮状态（有无文字、有无在线设备）、记录上的按钮随类型和状态变化；扫码页的出错提示（不是隔空贴的二维码、网页传输的二维码、过期）。
- **真机**：3.5 节，加上一台 2.6.3 的 Mac 和一台 2.6.3 的 Windows 互通。

### 3.5 先验证的事

在第一周用真机做完，结论决定实现细节：

1. gomobile 打包：Go 核心在 App 进程里启动、停止、再启动，没有残留的 goroutine 和 socket；`daemon.json` 和 gRPC 回环连接正常。
2. `net.Interfaces()` 在 Android 11+ 是否报错；换成 `anet` 后本机地址、地址簿、多出口探测是否正常。
3. mDNS：持有 MulticastLock 时，手机能否发现电脑、被电脑发现（Mac、Windows 各一台）；雷达配对是否正常。
4. 后台写剪贴板：App 在后台、亮屏时写入后，微信、浏览器里能否粘贴；锁屏时能否写入，不能的话解锁后补写最新一条；后台写入时系统会不会弹「已复制」预览。
5. 前台服务：锁屏放置 8 小时以上能否保持在线、多久能收到电脑复制的文字、耗电多少；小米、OPPO、vivo、荣耀各一台，记录默认设置和加白名单后的差异。
6. 图片和文件经剪贴板 URI 粘贴：微信、QQ、备忘录、浏览器里各是什么效果。效果差的话，一期界面上弱化「复制」、突出「保存 / 分享」。
7. 与 2.6.3 桌面互通：配对、文字双向、图片、50 MiB 以上文件手动下载、电脑重启后补发。
8. 扫码组件：在没有 Google Play 服务的国内手机上能否打开相机、识别速度如何。
9. 系统相机扫码：Pixel 与国内手机上 App Link 能否直接拉起 App；拉不起时官网页面的「打开隔空贴」按钮在各家浏览器里能否用；微信扫码后的提示。
10. 扫码配对时没放行防火墙的 Windows：靠「敲门」能否收到手机的请求。

### 3.6 工作量

按一个人全职估算；3.5 节做完后重估。

| 阶段 | 时间 | 产出 |
|---|---|---|
| 验证 | 1 周 | 3.5 节的结论；能在真机上与 Mac 配对并收发文字的原型 |
| Go 核心 | 1–1.5 周 | 3.3.2 节的改动与测试，`SubmitLocal` 已随网页传输完成；桌面三端回归通过 |
| Kotlin 宿主 | 1–1.5 周 | 前台服务、剪贴板、MulticastLock、保存与分享、引导页的原生部分 |
| Flutter 界面 | 1.5–2 周 | 四个标签页、发送页、记录操作、首次引导 |
| 扫码配对 | 1–1.5 周 | 协议字段与核心逻辑、测试；桌面端二维码与简化确认框；Android 扫码页；App Link 与官网 `pair` 页面 |
| 联调与内测 | 1 周 | 3.4 节的测试；签名 APK 发给内测用户 |

一期合计约 **6.5–8.5 周**，从网页传输做完后算起。扫码配对的桌面部分要先随一个桌面版本发出。

需要的设备：至少一台 Pixel 或接近原生的机型，再加小米（HyperOS）、OPPO / 一加（ColorOS）、vivo（OriginOS）、荣耀（MagicOS）中的两三台。

### 3.7 后续阶段

按建议的先后顺序。每项单独评估、单独排期：

1. **手机发图片和文件**：系统分享进来、在 App 里选照片和文件。走现有的隔空传送（`SendFiles`），局域网里自动用 TCP 快速通道。在这之前，手机发照片到电脑可以先用网页传输。
2. **更快的发送入口**：通知栏「发送剪贴板」按钮、快捷设置磁贴、选中文字菜单里的「隔空贴」（`ACTION_PROCESS_TEXT`）。注意微信、QQ 等用自己的分享面板和长按菜单，后两种在它们里面不出现；通知栏和磁贴只依赖「复制」，在任何 App 里都能用。
3. **跨网同步**：接入现有的信令服务器、官方服务和 TURN。要加接收能力协商，让手机在蜂窝网络下不被自动推送大文件。二维码里再带上服务器签发的配对码，不在同一网络时也能扫码配对。
4. **安全与体验**：私钥改用 Keystore 加密；开机自启；手机端可设的接收上限；自动更新（复用 Ed25519 签名的更新清单，交给系统安装器）。
5. **快捷粘贴（可选，需要用户开启无障碍）**：从面板选一条记录，直接填进当前输入框，对应桌面的 Option+1–9。见 5.2 节。
6. 公开发布、Google Play 或国内应用商店上架。

## 4. 跨平台约定

现在的结构本来就是跨平台的：界面用 Flutter，业务在 Go 核心，各平台只有一层很薄的原生宿主。为了以后加 iOS 或别的平台时不返工，实现时守这几条：

- **业务逻辑只放在 Go 核心。**记录、同步规则、配对、接收策略都在核心里，Kotlin 只做系统能力：写剪贴板、通知、前台服务、保存与分享、组播锁。网页传输的逻辑也在核心的 `webshare` 包里，网页本身只负责显示和加解密。
- **原生桥接口按平台无关的方式定义。**`Start` / `Stop` / `Status` 和宿主回调（`WriteClipboard`、`UpdateNotification`）在 Go 里定义成接口，不出现 Android 专有的概念；以后 Swift 照同一个接口实现。
- **一套 Flutter 代码。**不另起手机工程，在现有的 `ui/lib` 里加手机布局（按窗口宽度和平台选择外壳）。功能显示与否看核心在 `GetStatus` 里报告的「本机支持什么」，不在页面里到处写 `Platform.isAndroid`；桌面专用的插件（拖放、全局热键、托盘）按平台条件引入。
- **构建标签。**Android 用 `linux && !android` 排除桌面 Linux 实现。另外记下：`GOOS=ios` 也会满足 `darwin` 标签，以后做 iOS 时 macOS 的 Cocoa 实现要改成 `darwin && !ios`（5.3 节有实测）。
- **核心改动先在桌面上落地。**像 `SubmitLocal` 这种共用接口，先由网页传输在桌面端用起来、测稳，Android 再接，减少两边同时改核心。

## 5. 平台边界（调研结论）

### 5.1 Android 能做和不能做的

| 能力 | 结论 | 依据 |
|---|---|---|
| 后台读其他 App 复制的内容 | 不能 | Android 10 起只有默认输入法和当前有焦点的 App 能读；后台注册的变化监听也收不到回调 |
| 锁屏时读剪贴板 | 不能 | `getPrimaryClip()` 在设备锁定时返回 null（AOSP 源码） |
| 后台写剪贴板 | 能 | AOSP 源码："Writing is allowed without focus." |
| 前台时只看剪贴板里有没有文字 | 能，且不弹提示 | 官方文档：只取元数据不显示「已粘贴」提示 |
| 全天后台在线 | `connectedDevice` 能，`dataSync` 不行 | Android 15 起 `dataSync` 每 24 小时最多 6 小时 |
| 从微信、QQ 的分享菜单发到隔空贴 | 不能 | 它们用自己的分享面板和长按菜单 |
| 华为 HarmonyOS NEXT（5.x 起） | 不能装 APK | 要另做鸿蒙原生应用 |

### 5.2 无障碍

- **能多做的只有快捷粘贴到当前输入框**：用户点无障碍按钮打开面板，选一条，隔空贴写入剪贴板并对当前输入框执行粘贴。每次由用户点选触发、动作固定。
- **不做：用无障碍在后台监测复制、自动发出手机剪贴板。**这等于绕过系统的剪贴板隐私限制。Google Play 政策明文禁止无障碍 API 用来 "Work around Android built-in platform security controls, privacy controls and notifications"，也和隔空贴「看不到你的内容」的定位相反。
- **代价**：
  - 从网页下载安装的 APK，在 Android 13+ 上要先「允许受限制的设置」才能打开无障碍；
  - 系统会给出很重的风险提示；
  - 上 Play 要做声明和披露页。

  所以它只适合做默认关闭的可选项。
- **想要「手机复制自动同步」**，官方允许的路只有隔空贴自己做输入法、用户把它设成默认键盘，相当于再做一个产品，不建议。

### 5.3 iOS（暂不做）

技术上能做，但体验比 Android 差很多；iPhone 用户先用网页传输。以后要做时，已知的情况：

- **代码**：用 Xcode 的 iOS 26.2 SDK、开 cgo 编 `client-core/internal/...`，只有 `clipboard` 和 `notifications` 两个包因为引用 `Cocoa/Cocoa.h` 编不过，`rpc`、`sync` 是因为依赖 `clipboard` 才一起失败。其余包（包括 `imagepreview` 和 macOS 的本地网络权限探测）都能编过。原因是 `GOOS=ios` 也满足 `darwin` 标签，见第 4 节。
- **后台**：App 退到后台约 5 秒后就被挂起，只能在打开 App 时同步，做不到「电脑复制、手机直接粘贴」。
- **剪贴板**：iOS 16 起程序读剪贴板会弹窗请求许可，要用系统的粘贴按钮 `UIPasteControl` 才不弹；用户在输入框里自己长按粘贴不受影响。
- **局域网发现**：iOS 上收发组播要向苹果申请 `com.apple.developer.networking.multicast` 权限。pion/mdns 用的是原始组播，所以要改用系统的 Bonjour 接口，经宿主回调交给 Go 核心。现有的发现接口（`transport/lan/discovery.go`）已经为 Windows 换过一次系统实现，可以照做。
- **分发**：只能走 App Store 或 TestFlight，开发者账号每年 99 美元。上架中国区时，部分 App 要提供 ICP 备案号，隔空贴是否需要**待确认**。
- **需求**：同一个 Apple 账户下的 Mac 和 iPhone 已经有苹果自带的通用剪贴板，iOS 版主要服务 Windows / Linux 用户。

## 6. 依据

### 6.1 仓库

- [同步引擎](../client-core/internal/sync/engine.go)：文字随 offer 内联、按发送方阈值推送、`handleOffer` 与 `finishReceive` 写剪贴板、`recordOutgoing`、`ImagePreview`、`localPaths`；[补发与广播](../client-core/internal/sync/backlog.go)：`offerToPeers`，每台设备补发 20 条、24 小时、只在内存。
- [剪贴板接口](../client-core/internal/clipboard/clipboard.go)、[Watcher](../client-core/internal/clipboard/watcher.go)：本机写入不触发变化回调；[Linux 实现](../client-core/internal/clipboard/linux.go)。
- [配置](../client-core/internal/config/config.go)：`AutoApplyToClipboard`、`AutoSyncThresholdBytes`（50 MiB）、`HistoryTTL` / `CacheTTL`（3 天）、`ReceiveDir` / `EffectiveReceiveDir`，读取时以默认值打底。
- [记录结构](../client-core/internal/store/store.go)：`OriginDeviceName`、`ListClips`。
- [隔空传送接收](../client-core/internal/send/incoming.go)：重名改名规则。
- [gRPC 服务](../client-core/internal/rpc/server.go)、[endpoint](../client-core/internal/rpc/endpoint.go)、[事件中心](../client-core/internal/rpc/hub.go)、[Flutter 客户端](../ui/lib/daemon_client.dart)、[后台服务管理](../ui/lib/background_service.dart)。
- [局域网直连](lan-mode.md)、[局域网 TCP 快速通道](send-files-lan-tcp.md)（防火墙一节）、[地址枚举](../client-core/internal/transport/lan/addrs.go)、[多出口探测](../client-core/internal/transport/p2p/egress_history.go)、[Windows 防火墙放行](../client-core/internal/transport/lan/permission_windows.go)。
- [私钥存放](../client-core/internal/identity/protect_other.go)、[守护进程组装](../client-core/cmd/pasteferryd/main.go)、[设备图标](../ui/lib/pages/devices_page.dart)。
- 配对：[局域网配对](../client-core/internal/transport/lan/pairing.go)（配对码明文传输、靠指纹防中间人、敲门）、[配对流程](../client-core/internal/peers/manager.go)（`addPending`、`RedeemPairingCode`、`ConfirmPairing` 只在本机落库并重放信令）、[设备 ID 与指纹](../proto/deviceid/deviceid.go)、[配对码格式](../proto/pairingcode/pairingcode.go)（6 位、5 分钟）、[线上协议](../proto/pasteferry/v1/wire.proto)（`LanPacket`、`LanPairInfo`、`LanPairReject`）、[配对确认框](../ui/lib/widgets/pairing_dialog.dart)。

### 6.2 本机实测（Go 1.26.10）

- `GOOS=android GOARCH=arm64 CGO_ENABLED=0 go build ./internal/...`：全部通过，包括纯 Go 的 SQLite（`modernc.org/sqlite`）。
- `go build ./cmd/pasteferryd`：链接报 `github.com/wlynxg/anet: invalid reference to net.zoneCache`；加 `-ldflags=-checklinkname=0` 后产出 ELF aarch64 可执行文件，约 40 MB（未裁剪）。
- `GOOS=ios GOARCH=arm64 CGO_ENABLED=1`（Xcode iOS 26.2 SDK）`go build ./internal/...`：`clipboard`、`notifications` 报 `'Cocoa/Cocoa.h' file not found`，`rpc`、`sync` 随之失败，其余通过。
- Flutter 3.44.9 的默认值（`packages/flutter_tools/gradle/src/main/kotlin/FlutterExtension.kt`）：`minSdkVersion = 24`、`compileSdkVersion = 36`、`targetSdkVersion = 36`；iOS 工程模板最低 13.0。
- 没做：真机运行、gomobile 打包、与电脑配对和传输；网页传输还没有原型。

### 6.3 平台（2026-10-27 读取）

- [Android 10 隐私变更：剪贴板](https://developer.android.com/about/versions/10/privacy/changes#clipboard-data)："Unless your app is the default input method editor (IME) or is the app that currently has focus, your app cannot access clipboard data on Android 10 or higher."
- [AOSP ClipboardService.java](https://android.googlesource.com/platform/frameworks/base/+/refs/heads/main/services/core/java/com/android/server/clipboard/ClipboardService.java)：写入不需要焦点、锁屏时读取返回 null、变化通知派发前重新检查权限。
- [复制和粘贴](https://developer.android.com/develop/ui/views/touch-and-input/copy-paste)：Android 12 读取提示及不提示的情况、Android 13 复制预览、`EXTRA_IS_SENSITIVE`。
- [前台服务类型](https://developer.android.com/develop/background-work/services/fgs/service-types)、[前台服务时限](https://developer.android.com/develop/background-work/services/fgs/timeout)、[后台启动前台服务的限制与豁免](https://developer.android.com/develop/background-work/services/fgs/restrictions-bg-start)。
- [局域网权限](https://developer.android.com/privacy-and-security/local-network-permission)、[Android 17 行为变更](https://developer.android.com/about/versions/17/behavior-changes-17)：target SDK 37 起需要 `ACCESS_LOCAL_NETWORK`。
- [接收其他 App 分享的数据](https://developer.android.com/training/sharing/receive)。
- Google Play：[使用 AccessibilityService API](https://support.google.com/googleplay/android-developer/answer/10964491)、[权限与敏感 API 政策](https://support.google.com/googleplay/android-developer/answer/16558241)。
- [受限制的设置](https://support.google.com/android/answer/12623953)（Android 13+）、[Android 开发者验证](https://developer.android.com/developer-verification)。
- 版本分布：[apilevels.com](https://apilevels.com/)（第三方，StatCounter 2026 年 4 月数据，页面注明 2026-05-28 更新）。
- iOS：[延长后台执行时间](https://developer.apple.com/documentation/uikit/extending-your-app-s-background-execution-time)（退到后台后约 5 秒挂起）、[UIPasteControl](https://developer.apple.com/documentation/uikit/uipastecontrol)、[UIPasteboard](https://developer.apple.com/documentation/uikit/uipasteboard)、[组播权限](https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.developer.networking.multicast)、[通用剪贴板](https://support.apple.com/en-us/102430)、[App Store Connect：App 信息（ICP 备案号）](https://developer.apple.com/help/app-store-connect/reference/app-information/)。

## 3.3.11 发版签名密钥（2.7.0 起）

- 密钥：`~/.pasteferry-android/pasteferry-release.jks`，别名 `pasteferry`，RSA 4096，有效期 10000 天。
- 密码在登录钥匙串，服务名 `pasteferry-android-keystore`，账号 `pasteferry`。
- `scripts/build-android.sh` 打完 APK 后用 `apksigner` 签名；没有这个密钥时退回调试签名，只能内测。
  **不写进 Gradle 的 signingConfigs**：这台机器的 Gradle 9.5 把旧的 `android {}` DSL 当错误，构建会直接失败。
- 这张密钥**不能换、也不要重新生成**：换掉以后，已经装过旧版的手机无法覆盖升级（签名不同，系统拒绝安装）。
  丢了只能从离线备份恢复，恢复不了就只能换包名重新发。
- 必须备份两样东西：`.jks` 文件本身，和钥匙串里的那段密码。建议各存一份离线。
- 2.7.0 的 Released APK（含网页传输那一版）是用调试密钥签的；从带这张密钥的构建开始，之后每一版都用它。
