#!/usr/bin/env bash
# 构建全部产物到 dist/。
#
#   dist/PasteFerry.app         发给用户的 App：界面 + 内置的后台服务与命令行工具
#   dist/PasteFerryDaemon.app   后台服务单独一份，供 install-macos.sh 在开发时安装
#   dist/pasteferry-server      信令 + TURN 中转服务器（macOS 版）
#   dist/pasteferry-cli         调试用命令行
#
# daemon 刻意打包成 .app 而非裸二进制：macOS 的剪贴板授权（TCC）以
# bundle identifier 为主体，下个大版本起剪贴板隐私机制将强制执行，
# 届时没有稳定 bundle id 的进程无法保留用户的授权选择。

set -euo pipefail
cd "$(dirname "$0")/.."

# shellcheck source=sign.sh
source scripts/sign.sh

DIST=dist
VERSION=${VERSION:-2.6.0}
APP_BUILD=${APP_BUILD:-$(git rev-parse --short=8 HEAD)}
rm -rf "$DIST" && mkdir -p "$DIST"

# 支持的最低 macOS 版本，与界面工程的 MACOSX_DEPLOYMENT_TARGET、后台服务的 LSMinimumSystemVersion 一致。
# cgo 的编译与链接要显式指定，否则按构建机的系统版本来，产物在旧系统上起不来
MACOS_MIN=13.0

# 构建 x86_64 + arm64 通用二进制：两台 Mac 的芯片未必相同，单架构的
# daemon 到 Apple Silicon 上要靠 Rosetta，而 Rosetta 默认并未安装。
# daemon 含 cgo，交叉编译时必须给 clang 显式指定 -arch。
build_universal() { # <模块目录> <包路径> <输出路径> <ldflags>
    local dir=$1 pkg=$2 out=$3 ldflags=$4 tmp
    tmp=$(mktemp -d)
    for arch in amd64 arm64; do
        local clang_arch=$arch
        [[ $arch == amd64 ]] && clang_arch=x86_64
        (cd "$dir" && CGO_ENABLED=1 GOOS=darwin GOARCH=$arch MACOSX_DEPLOYMENT_TARGET=$MACOS_MIN \
            CC="clang -arch $clang_arch -mmacosx-version-min=$MACOS_MIN" \
            go build -trimpath -ldflags "$ldflags" -o "$tmp/$arch" "$pkg")
    done
    lipo -create -output "$out" "$tmp/amd64" "$tmp/arm64"
    rm -rf "$tmp"
}

echo "▶ 构建 daemon"
build_universal client-core ./cmd/pasteferryd "$DIST/pasteferryd" \
    "-s -w -X main.version=$VERSION"

echo "▶ 构建 CLI"
build_universal client-core ./cmd/pasteferry-cli "$DIST/pasteferry-cli" "-s -w"

echo "▶ 构建服务器"
build_universal server ./cmd/pasteferry-server "$DIST/pasteferry-server" \
    "-s -w -X main.version=$VERSION"

# ── 把 daemon 包成 .app ──
APP="$DIST/PasteFerryDaemon.app"
FOLDER_USAGE_EN="PasteFerry reads the files you send to your other computers and saves the files they send you."
mkdir -p "$APP/Contents/MacOS"
mv "$DIST/pasteferryd" "$APP/Contents/MacOS/pasteferryd"
cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>         <string>pasteferryd</string>
    <key>CFBundleIdentifier</key>         <string>com.pasteferry.daemon</string>
    <key>CFBundleName</key>               <string>PasteFerry Daemon</string>
    <key>CFBundleDevelopmentRegion</key>  <string>en</string>
    <key>CFBundleIconFile</key>           <string>AppIcon</string>
    <key>CFBundlePackageType</key>        <string>APPL</string>
    <key>CFBundleShortVersionString</key> <string>$VERSION</string>
    <key>CFBundleVersion</key>            <string>$VERSION</string>
    <key>LSMinimumSystemVersion</key>     <string>$MACOS_MIN</string>
    <!-- 后台常驻：不出现在 Dock 与任务切换器里 -->
    <key>LSUIElement</key>                <true/>
    <!-- macOS 15 起，后台服务连接局域网里的设备要经用户允许，系统弹窗里显示这段说明 -->
    <key>NSLocalNetworkUsageDescription</key>
    <string>PasteFerry finds your other computers on this network and syncs the clipboard with them directly.</string>
    <key>NSBonjourServices</key>
    <array><string>_pasteferry._udp</string></array>
    <!-- 隔空传送：后台服务读用户发出的文件、把收到的文件存进「下载」等文件夹，第一次时系统弹窗请用户允许 -->
    <key>NSDesktopFolderUsageDescription</key>    <string>$FOLDER_USAGE_EN</string>
    <key>NSDocumentsFolderUsageDescription</key>  <string>$FOLDER_USAGE_EN</string>
    <key>NSDownloadsFolderUsageDescription</key>  <string>$FOLDER_USAGE_EN</string>
    <key>NSRemovableVolumesUsageDescription</key> <string>$FOLDER_USAGE_EN</string>
    <key>NSNetworkVolumesUsageDescription</key>   <string>$FOLDER_USAGE_EN</string>
</dict>
</plist>
PLIST
# 系统设置的「隐私与安全性」列表里会显示后台服务，给它同一个图标
mkdir -p "$APP/Contents/Resources"
cp assets/brand/AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"
# 本地网络与文件夹权限弹窗里的说明，按系统语言显示。$2 是本地网络，$3 是文件夹（隔空传送）
localize() {
    mkdir -p "$APP/Contents/Resources/$1.lproj"
    {
        printf '"NSLocalNetworkUsageDescription" = "%s";\n' "$2"
        for key in NSDesktopFolderUsageDescription NSDocumentsFolderUsageDescription \
            NSDownloadsFolderUsageDescription NSRemovableVolumesUsageDescription NSNetworkVolumesUsageDescription; do
            printf '"%s" = "%s";\n' "$key" "$3"
        done
    } > "$APP/Contents/Resources/$1.lproj/InfoPlist.strings"
}
localize en "PasteFerry finds your other computers on this network and syncs the clipboard with them directly." \
    "$FOLDER_USAGE_EN"
localize zh-Hans "PasteFerry 在局域网里查找你的其他电脑，直接与它们同步剪贴板。" \
    "隔空贴要读取你发给其他电脑的文件，并保存它们发给你的文件。"
localize zh-Hant "PasteFerry 會在區域網路中尋找你的其他電腦，直接與它們同步剪貼簿。" \
    "隔空貼要讀取你傳給其他電腦的檔案，並儲存它們傳給你的檔案。"
localize zh-HK "PasteFerry 會在區域網絡中尋找你的其他電腦，直接與它們同步剪貼簿。" \
    "隔空貼要讀取你傳給其他電腦的檔案，並儲存它們傳給你的檔案。"
localize ja "PasteFerry はこのネットワーク上のほかのコンピューターを見つけ、クリップボードを直接同期します。" \
    "PasteFerry は、ほかのコンピューターに送るファイルを読み取り、送られてきたファイルを保存します。"
sign "$APP"
echo "  ✓ $APP"

echo "▶ 构建图形界面"
(cd ui && flutter build macos --release \
    --build-name "$VERSION" --dart-define=APP_VERSION="$VERSION" \
    --dart-define=APP_BUILD="$APP_BUILD" 2>&1 | tail -1)
UI="$DIST/PasteFerry.app"
cp -R ui/build/macos/Build/Products/Release/PasteFerry.app "$UI"

# 后台服务与命令行工具内置进 App：用户只需把一个 App 拖进「应用程序」，
# 首次打开时由界面把后台服务注册为登录项（见 ui/lib/background_service.dart）
mkdir -p "$UI/Contents/Helpers"
cp -R "$APP" "$UI/Contents/Helpers/"
cp "$DIST/pasteferry-cli" "$UI/Contents/Helpers/pasteferry-cli"

# 快捷粘贴窗口：单独的辅助程序，由界面登记成第二个 LaunchAgent（见 ui/lib/quick_paste_service.dart）。
# 只有一个很小的 Swift 可执行文件，Flutter 引擎与 Dart 代码用主 App 的 Contents/Frameworks/
# （rpath 指过去），所以不进 Xcode 工程，在这里用 swiftc 编译。见 ui/macos/Picker/main.swift
echo "▶ 构建快捷粘贴窗口"
PICKER="$UI/Contents/Helpers/PasteFerryPicker.app"
FLUTTER_ROOT=$(dirname "$(dirname "$(readlink -f "$(command -v flutter)")")")
FLUTTER_FW="$FLUTTER_ROOT/bin/cache/artifacts/engine/darwin-x64-release/FlutterMacOS.xcframework/macos-arm64_x86_64"
mkdir -p "$PICKER/Contents/MacOS" "$PICKER/Contents/Resources"
PICKER_TMP=$(mktemp -d)
for arch in x86_64 arm64; do
    swiftc -O -target "$arch-apple-macos$MACOS_MIN" -F "$FLUTTER_FW" -framework FlutterMacOS \
        -Xlinker -rpath -Xlinker @executable_path/../../../../Frameworks \
        ui/macos/Picker/main.swift -o "$PICKER_TMP/$arch"
done
lipo -create -output "$PICKER/Contents/MacOS/PasteFerryPicker" "$PICKER_TMP/x86_64" "$PICKER_TMP/arm64"
rm -rf "$PICKER_TMP"
cat > "$PICKER/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>         <string>PasteFerryPicker</string>
    <key>CFBundleIdentifier</key>         <string>com.pasteferry.picker</string>
    <key>CFBundleName</key>               <string>PasteFerry</string>
    <key>CFBundleDisplayName</key>        <string>PasteFerry</string>
    <key>CFBundleDevelopmentRegion</key>  <string>en</string>
    <key>CFBundleIconFile</key>           <string>AppIcon</string>
    <key>CFBundlePackageType</key>        <string>APPL</string>
    <key>CFBundleShortVersionString</key> <string>$VERSION</string>
    <key>CFBundleVersion</key>            <string>$VERSION</string>
    <key>LSMinimumSystemVersion</key>     <string>$MACOS_MIN</string>
    <key>LSUIElement</key>                <true/>
    <key>NSHighResolutionCapable</key>    <true/>
</dict>
</plist>
PLIST
cp assets/brand/AppIcon.icns "$PICKER/Contents/Resources/AppIcon.icns"
# 「辅助功能」授权列表里显示的名字，按系统语言：中文系统上叫隔空贴
for loc in zh-Hans zh-Hant zh-HK; do
    mkdir -p "$PICKER/Contents/Resources/$loc.lproj"
    name=$([[ $loc == zh-Hans ]] && echo 隔空贴 || echo 隔空貼)
    printf '"CFBundleDisplayName" = "%s";\n"CFBundleName" = "%s";\n' "$name" "$name" \
        > "$PICKER/Contents/Resources/$loc.lproj/InfoPlist.strings"
done

# 签名由内向外：先签内置的组件，最后签外层 App。
# Flutter 增量构建在 Dart 代码变化后会重新生成 App.framework 却不重签，
# 留下失效签名，Apple Silicon 上会直接拒绝运行，这里一并重签。
# 外层 App 保留 Xcode 写进去的权限声明（entitlements）与标志；签名要求不保留，按新的签名身份生成
sign "$UI/Contents/Helpers/pasteferry-cli"
sign "$UI/Contents/Helpers/PasteFerryDaemon.app"
sign "$UI/Contents/Helpers/PasteFerryPicker.app"
sign "$UI/Contents/Frameworks/App.framework"
sign --preserve-metadata=entitlements,flags "$UI"
codesign --verify --deep --strict "$UI" "$APP"
echo "  ✓ $UI"

echo
echo "完成。产物："
ls -1 "$DIST"
cat <<'EOF'

下一步：
  open dist/PasteFerry.app              首次打开会引导启用后台同步
  ./scripts/package.sh                打出 DMG 与服务器发布包
  ./dist/pasteferry-server -h           查看服务器参数
EOF
