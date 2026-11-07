# 隔空贴：让 AI 改主题（MCP）

> 方案稿 · 2026-11-06 · 已实现
>
> - 主题的格式与校验见 `design/themes.md`（第 3、8、9 节）；本文只讲 MCP 这一层。
> - 面向用户的说明见 `guide/ai-themes.zh-CN.md`。

## 1. 概览

`pasteferry-cli mcp` 是一个按 [Model Context Protocol](https://modelcontextprotocol.io/) 工作的本机服务，让 Claude Desktop、Claude Code、Cursor 这类 AI 客户端读、校验、保存、应用隔空贴的主题，导入背景图。

- **传输**：stdio。一行一条 JSON-RPC 2.0 消息；stdout 只写协议消息，日志写 stderr。
- **协议版本**：2025-06-18 与 2025-03-26。客户端要的版本在这两个里就照它回，否则回 2025-06-18。2025-06-18 下工具结果另带 `structuredContent`；2025-03-26 的批量请求照样处理。
- **不引入新依赖**：协议部分手写，在 `client-core/cmd/pasteferry-cli/mcp.go`；主题格式说明在 `mcp_schema.go`。
- **连接**：走 CLI 已有的本机 RPC 认证（`daemon.json` 里的端口与 token），与 `design/cli-json.md` 相同。每次调用工具时才连后台服务：AI 客户端常常比隔空贴先启动，后台服务重启后也不用重开会话。
- **设备之间的协议不变，服务器不变。**

## 2. 能做什么、不能做什么

只提供主题与背景图。复制记录、设备、好友、配置里的其他项一律不经 MCP 提供：AI 客户端会把工具结果发给模型服务商，剪贴板内容不能这样流出去。以后若要提供，需要在设置里单独开关，默认关闭。

修改类的工具只有：保存与删除自定义主题、切换当前主题与深浅模式、导入背景图。内置主题（`default`、`pixel`）不能覆盖也不能删除。是否让 AI 调用由客户端自己的授权流程把关（Claude Desktop 等每次调用前会问用户）。

## 3. 工具

| 工具 | 参数 | 结果 |
|---|---|---|
| `theme_list` | 无 | `current`（当前主题 id，默认主题是 `default`）、`mode`（system、light、dark）、`scanlines`、`themes[]`（`id`、`name`、`builtin`、`base`） |
| `theme_get` | `id`，`resolved`（默认 true） | 主题 JSON。`resolved` 时合并了 base，22 个颜色角色与各项设置齐全 |
| `theme_schema` | 无 | 主题格式的 JSON Schema：每个颜色角色用在界面哪里、要和谁达到多少对比度，各项的取值范围 |
| `theme_validate` | `theme`（对象或 JSON 字符串） | 只校验不保存：`valid`、`id`、`warnings[]`（`mode`、`foreground`、`background`、`ratio`、`minimum`）。格式错误以 `isError` 返回 |
| `theme_save` | `theme` | 保存：`saved`、`id`、`warnings[]` |
| `theme_apply` | `id`，`mode`（可选：system、light、dark） | `current`、`mode`。主窗口、快捷粘贴窗口、手机 App 立即换 |
| `theme_delete` | `id` | `deleted`。删的是正在用的主题时换回默认主题 |
| `background_import` | `path` 或 `base64`（二选一） | `sha256`、`reference`（`user:<sha256>`，写进主题的 `background.image`，或风景的 `scene.header`、`scene.sidebar`）、宽高、格式、`luminance`、`luminance_spread`、`colors[]`、`min_scrim_dark`、`min_scrim_light` |
| `background_analyze` | `sha256`（可带 `user:` 前缀） | 与上面相同的分析结果 |

- 工具的说明与参数说明都用英文写，写清每个字段的用途，模型照着就能用。
- `background_import` 不接受网址（含 `://` 的路径直接拒绝），要 AI 先下载到本机文件；`base64` 可以带 `data:` 前缀。
- 工具出错不算协议错误：结果里 `isError: true`，文字是人能读的原因。后台服务的校验消息本来就是给用户看的（中文），原样转过去；连不上后台服务等情况给英文说明。

`initialize` 的 `instructions` 给出建议的流程：`theme_list` → `theme_get` 一套内置主题作起点 → 写一套自己 id、`base` 指向它、只覆盖改动的主题 → `theme_validate` → 处理对比度警告 → `theme_save` → `theme_apply`。

## 4. 资源

| URI | 内容 |
|---|---|
| `pasteferry://themes/schema` | 与 `theme_schema` 相同的 JSON Schema（`application/schema+json`） |
| `pasteferry://themes/{id}` | 主题保存时的原样（不合并 base；要完整内容用 `theme_get`） |

`resources/list` 列出格式说明与现有的每套主题；后台服务没开时只列格式说明。另有 `resources/templates/list` 给出 `pasteferry://themes/{id}`。不支持订阅。

## 5. 后台服务的改动

- `PutThemeRequest.dry_run`：只校验、算对比度，不保存也不推送 `themes_changed`。`theme_validate` 用它，校验规则与保存时完全一致。
- `AnalyzeBackground(BackgroundRef) → BackgroundInfo`：重新分析一张已导入的背景图。分析的是保存下来的文件（重新编码过），结果与导入时可能差一点点。

## 6. 错误处理

| 情况 | 回复 |
|---|---|
| 一行不是 JSON | JSON-RPC 错误 -32700 |
| 没有 `jsonrpc: "2.0"` 或没有 `method` | -32600 |
| 不认识的方法 | -32601 |
| `tools/call` 缺工具名、工具不存在、参数不是对象 | -32602 |
| 资源不存在 | -32002 |
| 后台服务没运行、连不上、token 不对、版本太旧 | 工具结果 `isError`，说明怎么办 |

通知（没有 `id` 的消息，如 `notifications/initialized`）不回复。

## 7. 测试

`client-core/cmd/pasteferry-cli/mcp_test.go` 起一个真实的后台服务（只有配置与主题存储），用内存里的输入输出驱动整段 MCP 会话：

- 两个协议版本的 `initialize`、`tools/list`、`resources/list`、`ping`、不认识的方法；
- 校验、保存、应用、列表、合并后的读取、读资源、删除（删掉正在用的主题后换回默认）；
- 内置主题不能覆盖、格式错误说清楚、对比度警告；
- 背景图用 base64 导入、拒绝网址、重新分析、主题引用导入的图；
- 后台服务没开、坏输入、批量请求；
- 每个颜色角色都有说明。
