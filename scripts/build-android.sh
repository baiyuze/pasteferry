#!/usr/bin/env bash
# 构建 Android App（design/phone-sync.md 3.3.7 节）：先用 gomobile 把 Go 核心打成 AAR，再由 Flutter 打 APK。
#
#   ./scripts/build-android.sh          # arm64 的 APK，在 ui/build/app/outputs/flutter-apk/app-release.apk
#                                       # （不放进 release/：那里只放 Release 的 14 个附件）
#   ./scripts/build-android.sh --aar    # 只打 AAR，之后可以 flutter run --target-platform android-arm64 调试
#   ./scripts/build-android.sh --aar --emulator   # 给 x86_64 模拟器调试用的 AAR，见下面 --emulator 的说明
#
# 只出 arm64：x86_64 的 Go 核心在 Android 上一启动就被系统杀掉。SQLite 用的 modernc.org/libc
# 在 linux/amd64 上直接调 lstat、open 这类老系统调用，Android 给 x86_64 App 的 seccomp 规则不允许
# （arm64 上本来就没有这些调用，用的是 newfstatat、openat）。x86_64 的模拟器（API 30 起）
# 自带 ARM 转译（ro.dalvik.vm.native.bridge=libndk_translation.so），照样能跑 arm64 的 APK。
#
# 需要 Android SDK 与 NDK（ANDROID_HOME，默认 /usr/local/share/android-commandlinetools）和 JDK 17 以上。
# gomobile、gobind 的版本由 client-core/go.mod 的 tool 一节固定。
#
# 还没有发版签名密钥（phone-task.md C6），APK 用调试密钥签名，只能给内测用。

set -euo pipefail
cd "$(dirname "$0")/.."

export ANDROID_HOME="${ANDROID_HOME:-/usr/local/share/android-commandlinetools}"
if [[ -z "${ANDROID_NDK_HOME:-}" ]]; then
    ANDROID_NDK_HOME="$(ls -d "$ANDROID_HOME"/ndk/* 2>/dev/null | sort -V | tail -1)"
    export ANDROID_NDK_HOME
fi
[[ -d "$ANDROID_NDK_HOME" ]] || {
    echo "找不到 Android NDK：装上 ndk 或设置 ANDROID_NDK_HOME" >&2
    exit 1
}

aar_only=false
emulator=false
for arg in "$@"; do
    case "$arg" in
        --aar) aar_only=true ;;
        --emulator) emulator=true ;;
        *) echo "不认识的参数 $arg" >&2; exit 1 ;;
    esac
done

echo "▶ gomobile、gobind"
tools="$(mktemp -d)"
trap 'chmod -R u+w "$tools" 2>/dev/null; rm -rf "$tools"' EXIT
(cd client-core && GOBIN="$tools" go install golang.org/x/mobile/cmd/gomobile golang.org/x/mobile/cmd/gobind)
export PATH="$tools:$PATH"

# --emulator：x86_64 模拟器的 ARM 转译（ndk_translation）有几条指令执行不了，Go 运行时一跑就 SIGILL：
#   - 它给的 AT_HWCAP 报了 CPUID、DIT，却执行不了 MRS MIDR_EL1、MRS DIT；
#   - 读不了通用计时器（MRS CNTFRQ_EL0、CNTVCT_EL0），Go 1.26 的 procyield 要用。
# 真机没有这些问题。这里复制一份 Go 工具链改两处再编译：运行时把辅助向量里的 AT_HWCAP、AT_HWCAP2
# 清零（internal/cpu 和 golang.org/x/sys/cpu 都读它们，清零后不用任何可选指令），procyield 不再等待。
# 只给模拟器调试用，不能拿去发布。
# （go build -overlay 不行：工具链在模块缓存里时不许替换其中的文件）
if $emulator; then
    $aar_only || { echo "--emulator 只能和 --aar 一起用" >&2; exit 1; }
    goroot="$tools/goroot"
    cp -Rc "$(cd client-core && go env GOROOT)" "$goroot" 2>/dev/null || cp -R "$(cd client-core && go env GOROOT)" "$goroot"
    chmod -R u+w "$goroot/src/runtime"
    auxv="$goroot/src/runtime/os_linux.go"
    perl -0pi -e 's/(\t\ttag, val := auxv\[i\], auxv\[i\+1\]\n)/$1\t\tif tag == 16 || tag == 26 { \/\/ AT_HWCAP、AT_HWCAP2\n\t\t\tauxv[i+1], val = 0, 0\n\t\t}\n/' "$auxv"
    grep -q 'AT_HWCAP、AT_HWCAP2' "$auxv" || { echo "标准库变了，改不了 $auxv" >&2; exit 1; }
    asm="$goroot/src/runtime/asm_arm64.s"
    perl -pi -e 's/^\tMRS     CNTFRQ_EL0, R1$/\tB       done \/\/ 模拟器读不了计时器/' "$asm"
    grep -q '模拟器读不了计时器' "$asm" || { echo "标准库变了，改不了 $asm" >&2; exit 1; }
    cat > "$tools/go" <<EOF2
#!/bin/sh
GOROOT="$goroot" GOTOOLCHAIN=local exec "$goroot/bin/go" "\$@"
EOF2
    chmod +x "$tools/go"
fi

echo "▶ Go 核心 AAR"
mkdir -p ui/android/app/libs
# -checklinkname=0：pion 的间接依赖 wlynxg/anet 用了 go:linkname（3.3.2 节第 2 条）
(cd client-core && gomobile bind \
    -target=android/arm64 \
    -androidapi 29 \
    -javapkg=com.pasteferry.core \
    -ldflags="-checklinkname=0 -s -w" \
    -o ../ui/android/app/libs/pasteferry-core.aar \
    ./mobile)
rm -f ui/android/app/libs/pasteferry-core-sources.jar

$aar_only && exit 0

echo "▶ APK"
(cd ui && flutter build apk --release --target-platform android-arm64)
apk=ui/build/app/outputs/flutter-apk/app-release.apk

# 发版签名：密钥固定在 ~/.pasteferry-android/pasteferry-release.jks，密码在登录钥匙串
# （服务名 pasteferry-android-keystore）。这张密钥不能换：换了，已装的用户没法覆盖升级。
# 没有密钥时留着 gradle 打的调试签名，只能内测。
KEYSTORE="$HOME/.pasteferry-android/pasteferry-release.jks"
ks_pw=""
if [[ -n "${ANDROID_KEYSTORE_BASE64:-}" ]]; then
    # CI：密钥以 base64 放在 secret 里，临时的 .jks 写在构建目录，用完删除
    KEYSTORE="${RUNNER_TEMP:-/tmp}/pasteferry-release.jks"
    printf '%s' "$ANDROID_KEYSTORE_BASE64" | base64 -d > "$KEYSTORE"
    ks_pw="${ANDROID_KEYSTORE_PASSWORD:-}"
    key_pw="${ANDROID_KEY_PASSWORD:-$ks_pw}"
elif [[ -f "$KEYSTORE" ]] && ks_pw=$(security find-generic-password -s pasteferry-android-keystore -a pasteferry -w 2>/dev/null); then
    key_pw="$ks_pw"
fi

if [[ -n "$ks_pw" ]]; then
    apksigner="$(ls -d "$ANDROID_HOME"/build-tools/*/apksigner 2>/dev/null | sort -V | tail -1)"
    "$apksigner" sign --ks "$KEYSTORE" --ks-key-alias pasteferry \
        --ks-pass "pass:$ks_pw" --key-pass "pass:$key_pw" "$apk"
    unset ks_pw key_pw
    if [[ -n "${ANDROID_KEYSTORE_BASE64:-}" ]]; then rm -f "$KEYSTORE"; fi
    echo "  · 签名：PasteFerry Android release key"
else
    echo "  · 签名：调试密钥（没有发版密钥，只能内测）"
fi
ls -lh "$apk"
