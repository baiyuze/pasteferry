# Mac 版的代码签名，由 build.sh 与 package.sh 引入（source），不单独运行。
#
# 发版的 Mac 上有一张自签名证书「PasteFerry Code Signing」，放在单独的钥匙串
# ~/Library/Keychains/pasteferry-signing.keychain-db 里，钥匙串的密码存在登录钥匙串
# （服务名 pasteferry-signing-keychain）。有它就用它签：系统按「包名 + 这张证书」记录
# 辅助功能等授权，更新后授权仍然有效；临时签名按程序的哈希记录，每次更新都会失效。
# 见 design/quick-paste-and-favorites.md 第 7.1 节。
#
# 这张证书永远不换：换了，所有 Mac 用户的辅助功能授权都会失效，要重新授权一次。
# 所以下面固定了它的 SHA-1，钥匙串里的证书对不上就报错停下。丢了只能从备份恢复，
# 不要重新生成。
#
# 没有这张证书时（开发机、Codex）退回临时签名；REQUIRE_SIGNING=1 时（package.sh 打发布包）直接报错。
# 设了 ADHOC_SIGN=1 就一律用临时签名，只用于本地试验，不能用来发版。

SIGN_KEYCHAIN="$HOME/Library/Keychains/pasteferry-signing.keychain-db"
SIGN_CERT_SHA1=0D0DA1D5F1EEF4E7EDC2281416AFAF2A4470DA97
SIGN_IDENTITY=-

if [ -z "${ADHOC_SIGN:-}" ] && [ -f "$SIGN_KEYCHAIN" ] &&
    sign_pw=$(security find-generic-password -s pasteferry-signing-keychain -a pasteferry -w 2>/dev/null); then
    security unlock-keychain -p "$sign_pw" "$SIGN_KEYCHAIN"
    unset sign_pw
    # codesign 只在钥匙串搜索列表里找签名身份，不在列表里就加进去（保留原有的）
    if ! security list-keychains -d user | grep -q pasteferry-signing; then
        sign_list=()
        while IFS= read -r line; do
            line=${line#"${line%%[![:space:]]*}"}
            sign_list+=("${line//\"/}")
        done < <(security list-keychains -d user)
        security list-keychains -d user -s "${sign_list[@]}" "$SIGN_KEYCHAIN"
        unset sign_list
    fi
    # 证书没被系统信任，codesign 按名字找不到，要用它的 SHA-1
    if ! security find-identity -p codesigning "$SIGN_KEYCHAIN" | grep -q "$SIGN_CERT_SHA1"; then
        echo "✗ 签名钥匙串里没有 SHA-1 为 $SIGN_CERT_SHA1 的「PasteFerry Code Signing」证书。" >&2
        echo "  这张证书不能换，请从备份恢复 ${SIGN_KEYCHAIN}，不要重新生成。" >&2
        exit 1
    fi
    SIGN_IDENTITY=$SIGN_CERT_SHA1
fi

if [ "$SIGN_IDENTITY" = - ]; then
    if [ -n "${REQUIRE_SIGNING:-}" ]; then
        echo "✗ 发布包必须用「PasteFerry Code Signing」证书签名（SHA-1 ${SIGN_CERT_SHA1}），这台电脑上没有。" >&2
        echo "  证书只在发版的 Mac 上；丢了要从备份恢复 $SIGN_KEYCHAIN 与它的密码，不要重新生成。" >&2
        exit 1
    fi
    echo "  · 签名：临时签名（没有 PasteFerry Code Signing 证书，只能自己用，不能发版）"
else
    echo "  · 签名：PasteFerry Code Signing（${SIGN_IDENTITY}）"
fi

# sign [codesign 的其他参数…] <路径>
sign() {
    codesign --force --sign "$SIGN_IDENTITY" "$@"
}

# check_signed <App>：App 与里面的三个组件都由这张证书签名（发布包用）
check_signed() {
    local want p
    want=$(echo "$SIGN_CERT_SHA1" | tr 'A-F' 'a-f')
    for p in "$1" "$1/Contents/Helpers/PasteFerryDaemon.app" "$1/Contents/Helpers/PasteFerryPicker.app" \
        "$1/Contents/Helpers/pasteferry-cli"; do
        if ! codesign -d -r- "$p" 2>&1 | grep -q "certificate root = H\"$want\""; then
            echo "✗ $p 不是用 PasteFerry Code Signing 证书签的" >&2
            return 1
        fi
    done
}
