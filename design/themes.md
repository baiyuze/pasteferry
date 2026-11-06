# 隔空贴：主题、背景图与 AI（MCP）

> 方案稿 · 2026-11-06 · 第 1 期已实现；第 3 期（像素主题）提前做了界面部分，切换入口要等第 2 期
>
> - 标「待验证」的条目，要实测或做出原型后再定。

## 1. 概览

这次一共四项改动：

1. **主题**：「外观」里可以换主题。首发两套内置主题：
   - **默认**：就是现在的样子，浅色与深色各一套。
   - **像素**：颜色、字体、形状、图标、动效整体换成像素风格（第 5 节）。
2. **自定义主题**：基于任一主题新建，改颜色、圆角、字体，导入与导出主题文件（第 6 节）。
3. **背景图**：任何主题都可以加背景图，自动保证文字看得清（第 7 节）。
4. **AI 改主题**：新增 `pasteferry-cli mcp`，AI 通过 MCP 读取主题说明、生成主题、校验、预览并应用（第 9 节）。

**实现上**：

- 主题由一份带版本号的 JSON 描述（第 3 节）。内置主题、自定义主题、AI 生成的主题都用这一种格式。
- 主题与背景图存在后台服务里，桌面主窗口、快捷粘贴窗口、手机三处共用（第 4 节）。
- 设备之间的协议不变，服务器不变。后台服务的本机接口要加几个字段和 RPC。每一期按新功能升 MINOR。

## 2. 现状

- 颜色在 `ui/lib/theme.dart` 的 `AppPalette` 里：15 个语义颜色，浅色、深色各一套，写死在代码里。页面基本只用 `context.palette`。
- 形状和字体还不能替换：
  - 页面里直接写了几十处 `BorderRadius.circular(...)`，还有一些写死的 `Color(0x…)`、`Colors.white`、阴影，集中在 `widgets/common.dart`、`pages/send_page.dart`、`mobile/ui.dart`、`widgets/avatar.dart`。
  - 字号写死在 `buildTheme` 的 `TextTheme` 里，字体跟随系统。
- `buildTheme` 有三处调用：桌面 `main.dart`、快捷窗口 `picker/picker_view.dart`、手机 `mobile/mobile_app.dart`。
- 图标统一在 `ui/lib/icons.dart` 里按平台挑选。
- 深浅模式只能跟随系统。
- 没有 MCP。最接近的是 2.9 的 `pasteferry-cli -json` 只读查询（`design/cli-json.md`）。

## 3. 主题的格式

```json
{
  "schema": 1,
  "id": "pixel",
  "name": { "zh-Hans": "像素", "en": "Pixel", "ja": "ピクセル" },
  "base": "default",
  "modes": {
    "light": { "accent": "#3B5DC9", "background": "#F4F4F4", "surface": "#FFFFFF", "border": "#1A1C2C", "text": "#1A1C2C" },
    "dark":  { "accent": "#41A6F6", "background": "#1A1C2C", "surface": "#333C57", "border": "#0E0F18", "text": "#F4F4F4" }
  },
  "typography": { "family": "fusion-pixel-12", "sizes": [12, 24], "pixelSnap": true },
  "shape": { "radius": { "sm": 0, "md": 0, "lg": 0 }, "corner": "notch", "borderWidth": 2 },
  "elevation": { "shadow": "hard", "offset": [3, 3] },
  "motion": "stepped",
  "icons": "pixel",
  "background": null
}
```

- **`base` 继承**：只写想改的字段，其余从 `base` 补齐。只改一个强调色，也是合法的主题。继承最多两层，不能成环。
- **`modes`**：颜色就是现在 `AppPalette` 的 15 个角色，名字不变。只写了一个模式时，另一个模式由它推算（反转明度、保留色相），推算结果同样要过对比度检查。
- **`typography`**：`family` 只能是 App 自带的字体或 `system`；`sizes` 是允许的字号阶梯，像素字体只能用设计字号的整数倍。
- **`shape.corner`**：`round`（圆角）、`square`（直角）、`notch`（像素角：四角各切掉一个方格）。
- **`elevation.shadow`**：`soft`（现在的投影）、`hard`（不模糊的偏移投影）、`none`。
- **`motion`**：`smooth`（现在的动画）、`stepped`（逐帧，4 到 6 档）、`reduced`（尽量不动）。系统开了「减少动态效果」时一律按 `reduced`。
- **`icons`**：`system`（现在的 Cupertino / Fluent）或 `pixel`。
- **`background`**：见第 7 节。
- 未知字段忽略，`schema` 比本机认识的新时拒绝导入并提示升级。

Dart 里对应四个 `ThemeExtension`，页面代码只读这些名字，不判断当前是什么主题：

| 扩展 | 内容 |
|---|---|
| `AppPalette` | 15 个颜色，加上强调色底上的文字 `onAccent`、提示条的底 `inverse` 与文字 `onInverse` |
| `AppShape` | 三级圆角、投影；第 3 期加角的样式、边框宽度 |
| `AppTypography` | 等宽字体；第 3 期加正文字体与字号阶梯 |
| `AppMotion` | 动画时长与曲线：平滑、逐帧、不做动画 |

三处界面都调用 `buildTheme(brightness, spec: …)`（手机在它上面调整字号与触控尺寸），`spec` 是一套主题 `AppThemeSpec`。

**像素字号不改页面**：页面里写死的字号有几十处。像素主题经 `MediaQuery` 换一个 `TextScaler`，把所有字号吸附到允许的阶梯上，页面代码不用动。

## 4. 存在哪里

和界面语言一样存在后台服务里：

1. 快捷粘贴窗口是单独的进程，要用同一套主题。
2. CLI 与 MCP 只能经后台服务修改主题。
3. Windows 托盘菜单由后台服务画，以后可以跟着主题变。

**本机接口**：

- `Config` 加 `theme_id`（空字符串表示默认主题）与 `theme_mode`（跟随系统、浅色、深色）。
- 自定义主题存在数据目录 `themes/<id>.json`，背景图存在 `backgrounds/`（第 7.3 节）。
- 新增 RPC：`ListThemes`、`GetTheme`、`PutTheme`、`DeleteTheme`、`ImportBackground`、`DeleteBackground`。
- `PutTheme` 在后台服务里统一校验：格式、字段范围、继承关系，以及对比度（第 8 节）。界面、CLI、MCP 走同一套校验。
- 换主题时经 `Subscribe` 推送事件，三处界面立即刷新。
- 主题只在本机，不在设备之间同步。

## 5. 像素主题

| 方面 | 做法 |
|---|---|
| **颜色** | 16 色的有限调色板（参考 Sweetie 16）。深色「CRT 夜」：深蓝黑底、亮蓝强调色，绿、橙、红表示在线、警告、错误。浅色「纸面」：浅灰白底、黑色描边、钴蓝强调色。 |
| **文字** | 缝合像素字体（Fusion Pixel Font，OFL），12px 版本；等宽版用于配对码与指纹。字号只用 12 与 24，字间距 0，行高取整数像素。英文标题可另用 Silkscreen（OFL）。 |
| **形状** | 圆角全为 0。容器边框 2px 实线，四角切掉 2px 方格（`PixelBorder`）。阴影向右下偏 3px，不模糊。 |
| **控件** | 方块开关，按格填充的进度条，方格复选框配像素勾，闪烁光标，选中项反色。 |
| **图标** | Pixelarticons（MIT）。`icons.dart` 里加一套映射，缺的先用原图标。 |
| **动效** | 逐帧；雷达改成按格子扩散。 |
| **背景** | 内置 3 到 4 张平铺小图：星空、网格纸、远山剪影、CRT 扫描线。整数倍放大，不插值。 |

**字体体积（待验证）**：完整的中日文像素字体每种语言可能有几 MB。打算只打包简体与拉丁字母两份，繁体与日文第一次切到像素主题时下载，下载后核对 SHA-256。实测体积可以接受的话就全部打包。

## 6. 自定义主题

「设置 › 外观」：

- 主题卡片：默认、像素、我的主题。每张卡片是一块真实渲染的小预览。
- 深浅模式：跟随系统、浅色、深色。
- 「基于当前主题新建」：改强调色、背景、文字颜色；圆角选「圆 / 方 / 像素角」；字体选「系统 / 像素」。旁边实时预览，对比度不够时直接提示。
- 导入与导出 `.pasteferry-theme` 文件（第 7.4 节）。
- 字体只能选 App 自带的或 `system`，不能导入字体文件。

## 7. 背景图

### 7.1 字段

```json
"background": {
  "image": "user:3f9a…c1",
  "fit": "cover",
  "align": "center",
  "blur": 12,
  "scrim": { "color": "#000000", "opacity": 0.35 },
  "surfaceOpacity": 0.82,
  "scope": ["main", "mobile"],
  "accentFromImage": false
}
```

- `image`：`asset:<名字>` 是内置图，`user:<sha256>` 是用户导入的图。也可以写在 `modes.light` / `modes.dark` 里，两个模式用不同的图。
- `fit`：`cover`、`contain`、`tile`。`tile` 只按整数倍缩放，并关闭插值。
- `blur`：0 到 40。
- `scrim`：盖在图上的一层颜色，用来压暗或提亮。
- `surfaceOpacity`：侧边栏、分组框、对话框的不透明度，0.6 到 1。
- `scope`：`main`、`picker`、`mobile`。快捷粘贴窗口默认不显示背景：它很小，主要用来快速认字。
- `accentFromImage`：用图片的主色作强调色。

### 7.2 文字要看得清

1. **导入时分析**：后台服务算出平均亮度、各区域的亮度差异、3 到 5 种主色，和图片一起保存。
2. **遮罩下限**：按分析结果与文字颜色，算出遮罩至少多浓，正文才能达到 WCAG AA。用户只能调得更浓。图片很花时，自动提高面板不透明度。
3. **配色建议**：从主色里给出强调色建议，点一下就用。

### 7.3 处理与存储

- `ImportBackground` 的参数与 `SetAvatar` 一样：文件路径或图片数据。返回哈希与分析结果。
- **重新编码，去掉 EXIF**。很多照片带 GPS 坐标，分享主题时不能把位置带出去。
- 长边最长 3840px。模糊版本导入时就算好、另存一份，**运行时不做全窗口实时模糊**：在 Windows 与 Linux 上很耗显卡。
- 存在 `backgrounds/<sha256>.jpg`（平铺图保留 PNG）。没有主题再用到的图片自动清理。
- 支持 JPEG、PNG、WebP，GIF 取第一帧。HEIC 第一版不支持。不做动图与视频背景。
- 输入最大 20 MB。

### 7.4 主题文件

`.pasteferry-theme` 是 zip：`theme.json` 加用到的图片。导入时逐项校验，图片同样重新编码。

### 7.5 界面

- `Shell` 外面套 `ThemedBackdrop`：背景图、遮罩、内容三层。有背景图时 `scaffoldBackgroundColor` 透明。
- 侧边栏、分组框、对话框按 `surfaceOpacity` 半透明。面板上不加实时模糊；只有侧边栏可以开「毛玻璃」，默认关。
- 图片按窗口实际尺寸解码一次；窗口大小变化时，等停止拖动再重新解码。
- 「外观 › 背景」：选图、拖入或粘贴，实时预览，调模糊、遮罩和面板透明度，「用图片配色」。
- 手机端同样可以设置，各设备分开保存。

## 8. 校验

后台服务对每个主题检查：

- 正文（`text`）与 `background`、`surface` 的对比度 ≥ 4.5；`textDim` ≥ 4.5；`textFaint` 只用于提示文字，≥ 3。
- 强调色上的白字（按钮文字）≥ 4.5。
- 有背景图时，按 7.2 节的分析结果，算上遮罩与面板透明度后再检查一遍。
- 不达标的内置主题在 CI 里直接失败；用户与 AI 的主题允许保存，但界面上标出警告，MCP 返回具体哪一对颜色不达标、差多少。

## 9. AI 与 MCP

新增 `pasteferry-cli mcp`：stdio 方式的 MCP 服务，复用 CLI 已有的本地 RPC 认证，不开端口。Claude Desktop、Claude Code、Cursor 等在配置里加一行命令即可。

**工具**：

| 工具 | 作用 |
|---|---|
| `theme_list` | 主题列表与当前主题 |
| `theme_get` | 合并 `base` 之后的完整主题 |
| `theme_schema` | JSON Schema，每个字段附说明，例如「`separator`：容器内行与行之间的分隔线，比 `border` 浅」。AI 靠它知道每个颜色用在哪里 |
| `theme_validate` | 格式错误与对比度问题，AI 可以自己改后再提交 |
| `theme_save` / `theme_apply` / `theme_delete` | 保存、应用、删除 |
| `theme_preview` | 用截图工具的渲染方式，返回几个主要页面的 PNG |
| `background_import` | 只接受本机路径或 base64 数据，**不接受网址** |
| `background_analyze` | 亮度、主色、建议的遮罩浓度 |

**资源**：`pasteferry://themes/schema`、`pasteferry://themes/{id}`。

**权限**：CLI 的 JSON 模式现在拒绝一切修改。MCP 只放开主题与背景图这一类低风险修改。复制记录、设备、好友这类敏感内容不经 MCP 提供；以后要提供，需要设置里单独开关，默认关闭。

## 10. 分期

| 期 | 内容 | 依赖 |
|---|---|---|
| 1 | **整理主题结构**：加 `AppThemeSpec`、`AppShape`、`AppTypography`、`AppMotion`；三处 `buildTheme` 统一；页面里写死的圆角、强调色上的白色、投影、等宽字体、过渡动画改为读主题。默认主题的截图与改动前一致。只改界面 | — |
| 2 | **后台服务**：`Config` 字段、主题 RPC 与校验、背景图导入与分析、切换事件；「外观」里选主题、深浅模式 | 1 |
| 3 | **像素主题**：字体与字号吸附、`PixelBorder` 与边框宽度、像素控件、图标、雷达、内置平铺背景 | 2 |
| 4 | **自定义主题与背景设置**：编辑器、导入导出、`ThemedBackdrop` 与半透明分层 | 2 |
| 5 | **MCP**：`pasteferry-cli mcp`、全部工具 | 2 |

第 3、4、5 期互不依赖，可以并行。

**像素主题提前做了界面部分（2026-11-06）**：为了先看到效果，第 3 期在第 2 期之前完成了渲染。还没有切换入口，现在用编译参数试：

```bash
flutter run -d macos --dart-define=PASTEFERRY_THEME=pixel
```

截图工具用 `SCREENSHOT_THEME=pixel` 渲染像素主题。视觉设计见 `design/pixel-theme.md`。字体与图标由 `tools/pixel-theme/build_assets.py` 生成，放在 `ui/assets/fonts/`，许可证在同一目录。还没做的：见 `design/pixel-theme.md` 第 11 节，另外繁体与日文的像素字形（现在都用简体字形）、手机端逐页检查。

## 11. 第 1 期的验证（2026-11-06）

- `flutter analyze` 没有问题，`flutter test` 全部通过。
- 用 `ui/tool/screenshots` 在改动前后各渲染一次简体中文截图（39 张）。34 张逐字节相同；另 5 张只有相对时间与时刻不同（「40 秒前」与「41 秒前」、18:26 与 18:33），是两次渲染的时间差，其余像素相同。
- 新增 `ui/test/theme_test.dart`：默认主题的关键值不变；直角、无投影、逐帧的主题能传到按钮、对话框与分段控件；主题之间的过渡正确。
- 留在原处、不跟主题变的颜色：头像底色（按设备区分）、头像上的白字、网页传输二维码的黑白两色（扫码需要）。
- 雷达的扩散动画在 CustomPainter 里，第 3 期换成像素雷达时一起改。
