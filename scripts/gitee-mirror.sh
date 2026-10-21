#!/usr/bin/env bash
# 把一次发版同步到 Gitee 国内镜像 https://gitee.com/baiyuze/pasteferry ：
#
#   1. 推送 GitHub 上的 main 与本地全部 tag
#   2. 建与 GitHub Release 同名、同正文的发行版
#   3. 上传 release/ 里的 14 个文件（已有的同名文件跳过，可以重复运行）
#   4. 只保留最近 KEEP 个发行版的附件：Gitee 每个仓库的附件总共只有 1 GB，一版约 270 MB
#
#   ./scripts/gitee-mirror.sh vX.Y.Z "PasteFerry X.Y.Z — Summary" <正文文件>
#
# 令牌存在 macOS 钥匙串里（服务名 pasteferry-gitee-token），只需要 projects 权限：
#   security add-generic-password -U -a baiyuze -s pasteferry-gitee-token -w
# 令牌只经标准输入交给 curl 与 git，不出现在命令行参数、远程地址和输出里。
#
# 官网中文下载页的「国内镜像」链接是 releases/download/vX.Y.Z/<文件名>，与这里上传的文件一一对应；
# Gitee 没有 latest 跳转，所以每次发版都要重新生成网站。

set -euo pipefail
cd "$(dirname "$0")/.."

TAG=${1:?用法: scripts/gitee-mirror.sh vX.Y.Z 标题 正文文件}
TITLE=${2:?用法: scripts/gitee-mirror.sh vX.Y.Z 标题 正文文件}
NOTES=${3:?用法: scripts/gitee-mirror.sh vX.Y.Z 标题 正文文件}
OWNER=baiyuze
REPO=pasteferry
KEEP=${KEEP:-2}
API=https://gitee.com/api/v5/repos/$OWNER/$REPO

TOKEN=$(security find-generic-password -s pasteferry-gitee-token -w)
[[ $(find release -maxdepth 1 -type f | wc -l) -eq 14 ]] || { echo "release/ 里应当正好有 14 个文件" >&2; exit 1; }
git rev-parse -q --verify "refs/tags/$TAG^{commit}" >/dev/null || { echo "本地没有 tag $TAG" >&2; exit 1; }
[[ -f $NOTES ]] || { echo "找不到正文文件 $NOTES" >&2; exit 1; }

# gitee <方法> <路径> [curl 参数…]：令牌作为表单或查询参数，经 curl 的配置文件从标准输入传入
gitee() {
    local method=$1 path=$2
    shift 2
    if [[ $method == GET || $method == DELETE ]]; then
        printf 'url = "%s%s%saccess_token=%s"\n' "$API" "$path" "$([[ $path == *\?* ]] && echo '&' || echo '?')" "$TOKEN" |
            curl -sS --fail-with-body -K - -X "$method" "$@"
    else
        printf 'form-string = "access_token=%s"\nurl = "%s%s"\n' "$TOKEN" "$API" "$path" |
            curl -sS --fail-with-body -K - -X "$method" "$@"
    fi
}
json() { python3 -c "import sys, json; d = json.load(sys.stdin); $1"; }

echo "▶ 推送代码与 tag"
ASKPASS=$(mktemp)
trap 'rm -f "$ASKPASS"' EXIT
printf '#!/bin/sh\ncase "$1" in Username*) echo %s ;; *) security find-generic-password -s pasteferry-gitee-token -w ;; esac\n' "$OWNER" >"$ASKPASS"
chmod 700 "$ASKPASS"
# 推的是本地记录的 origin/main（先 git fetch），而不是本地 main，免得带上还没推到 GitHub 的提交
git merge-base --is-ancestor "$TAG" refs/remotes/origin/main || { echo "origin/main 里没有 ${TAG}，先 git fetch" >&2; exit 1; }
GIT_ASKPASS=$ASKPASS GIT_TERMINAL_PROMPT=0 git push -q "https://gitee.com/$OWNER/$REPO.git" \
    refs/remotes/origin/main:refs/heads/main 'refs/tags/*:refs/tags/*'

echo "▶ 发行版 $TAG"
ID=$(gitee GET "/releases/tags/$TAG" 2>/dev/null | json 'print(d.get("id") or "" if isinstance(d, dict) else "")' || true)
if [[ -z $ID ]]; then
    ID=$(gitee POST /releases -F "tag_name=$TAG" -F "name=$TITLE" -F "body=<$NOTES" \
        -F "target_commitish=$(git rev-parse "$TAG^{commit}")" -F prerelease=false | json 'print(d["id"])')
fi
echo "  id $ID"

echo "▶ 上传附件"
HAVE=$(gitee GET "/releases/$ID/attach_files?per_page=100" | json 'print("\n".join(a["name"] for a in d))')
for f in release/*; do
    name=$(basename "$f")
    if grep -qxF "$name" <<<"$HAVE"; then
        echo "  已有 $name"
        continue
    fi
    gitee POST "/releases/$ID/attach_files" -F "file=@$f" >/dev/null
    echo "  ✓ $name"
done

echo "▶ 清理旧版本的附件（保留最近 $KEEP 个发行版）"
OLD=$(gitee GET "/releases?per_page=100&direction=desc" |
    json "rs = sorted(d, key=lambda r: r['created_at'], reverse=True); print('\n'.join(str(r['id']) for r in rs[$KEEP:]))")
for rid in $OLD; do
    for aid in $(gitee GET "/releases/$rid/attach_files?per_page=100" | json 'print("\n".join(str(a["id"]) for a in d))'); do
        gitee DELETE "/releases/$rid/attach_files/$aid" >/dev/null
        echo "  删除发行版 $rid 的附件 $aid"
    done
done

echo "▶ 核对匿名下载"
for f in PasteFerry.dmg PasteFerry-Setup.exe PasteFerry-linux-amd64.deb SHA256SUMS; do
    code=$(curl -s -o /dev/null -L -r 0-0 -w '%{http_code}' "https://gitee.com/$OWNER/$REPO/releases/download/$TAG/$f")
    echo "  $code  $f"
done
