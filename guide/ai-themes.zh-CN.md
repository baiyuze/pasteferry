# 让 AI 帮你做主题

[English](ai-themes.md) · [回到 README](../README.zh-CN.md)

隔空贴的主题可以交给 AI 来做：说一句「给我做一个赛博朋克风的主题」或者「用这张照片当背景，配一套颜色」，AI 会读主题格式、写好配色、检查文字是否看得清、保存并换上。它通过桌面版自带的 `pasteferry-cli mcp` 连接隔空贴，支持 Claude Desktop、Claude Code、Cursor 等支持 MCP 的 AI 客户端。

**只给主题**：AI 能读、改、删的只有主题与背景图，看不到你的复制记录、设备和好友。保存、应用、删除主题前，AI 客户端会先问你。

## 准备

1. 装好隔空贴桌面版并打开（后台服务要在运行）。
2. 找到 `pasteferry-cli`：

| 系统 | 路径 |
|---|---|
| Mac | `/Applications/PasteFerry.app/Contents/Helpers/pasteferry-cli`（用 Homebrew 装的可以直接写 `pasteferry-cli`） |
| Windows | `%LOCALAPPDATA%\Programs\PasteFerry\pasteferry-cli.exe`，写进配置时要展开成完整路径，如 `C:\Users\你的用户名\AppData\Local\Programs\PasteFerry\pasteferry-cli.exe` |
| Linux | deb 包是 `/usr/bin/pasteferry-cli`；tar.gz 是解压目录里的 `PasteFerry/pasteferry-cli` |

下面的例子用 Mac 的路径，其他系统换成上表里的。

## Claude Desktop

打开「设置 → 开发者 → 编辑配置」，在 `claude_desktop_config.json` 里加上：

```json
{
  "mcpServers": {
    "pasteferry": {
      "command": "/Applications/PasteFerry.app/Contents/Helpers/pasteferry-cli",
      "args": ["mcp"]
    }
  }
}
```

Windows 上路径里的反斜杠要写两遍：`"C:\\Users\\你的用户名\\AppData\\Local\\Programs\\PasteFerry\\pasteferry-cli.exe"`。保存后重启 Claude Desktop。

## Claude Code

```bash
claude mcp add pasteferry -- /Applications/PasteFerry.app/Contents/Helpers/pasteferry-cli mcp
```

## Cursor

在 `~/.cursor/mcp.json`（所有项目）或项目里的 `.cursor/mcp.json` 加上：

```json
{
  "mcpServers": {
    "pasteferry": {
      "command": "/Applications/PasteFerry.app/Contents/Helpers/pasteferry-cli",
      "args": ["mcp"]
    }
  }
}
```

## 可以这样说

- 「看看隔空贴现在有哪些主题，换成像素主题，深色。」
- 「基于默认主题做一套抹茶绿的主题，浅色和深色都要，文字要看得清。」
- 「把像素主题的强调色换成珊瑚橙，存成一套新主题并用上。」
- 「用 ~/Pictures/海边.jpg 当背景，按照片的颜色配一套主题。」
- 「删掉刚才那套主题。」

AI 做好的主题会出现在「设置 → 外观」里，和内置主题放在一起，随时可以换回来。

## 常见问题

**AI 说连不上隔空贴**
打开隔空贴（或者在「设置」里确认后台服务在运行），再让 AI 重试，不用重启 AI 客户端。

**AI 说某些颜色对比度不够**
这是隔空贴的检查：正文和说明文字与背景的对比度要达到 4.5:1，提示文字 3:1，按钮上的字与按钮 4.5:1。让 AI 按警告调深或调浅那几个颜色即可；不改也能保存，只是那几处字可能看不清。

**能不能用网上的图片当背景**
不能直接给网址。先把图片下载到电脑上，再让 AI 用这个文件。导入时会重新编码，照片里的拍摄位置等信息不会保留。

**同时有好几台电脑**
主题只保存在本机，不会同步到其他设备。在另一台电脑上同样配置一遍，或者让 AI 把主题再存一次。

技术细节见 [MCP 方案](../design/mcp.md) 与 [主题格式](../design/themes.md)。
