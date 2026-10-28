#!/usr/bin/env bash
# Standalone macOS / Linux download and latency benchmark. No root required.
set -euo pipefail
export LC_ALL=C

usage() {
    cat <<'EOF'
国内 / 海外测速（macOS / Linux，需要 bash、curl、awk；ping 可选）

用法：bash scripts/net-speedtest.sh [选项]
  --quick           快测：每节点 4 MiB、最多 4 秒，Ping 2 次
  --latency-only    只测延迟，不下载测速文件
  --seconds N       每节点 HTTP 总超时，默认 10 秒（含建连）
  --size N          每节点请求下载 N MiB，默认 16，范围 1–100
  --count N         每节点 Ping 次数，默认 4，范围 1–20
  --proxy URL       HTTP(S) / SOCKS 代理，如 http://127.0.0.1:1087
  -h, --help        显示帮助

默认 IPv4 直连，忽略代理环境变量和 ~/.curlrc；系统 VPN/TUN 仍会影响路由。
指定代理时仅测 HTTP，跳过不会经过该代理的 Ping；TCP 指连接代理的耗时。
结果为单连接下载均速，不含上传测试。可用 “| tee speedtest.txt” 保存结果。
后面的选项覆盖前面的选项。节点可在脚本的 NODES 数组中更换。
EOF
}

die() { printf '错误：%s\n' "$*" >&2; exit 2; }
integer() { [[ $1 =~ ^[1-9][0-9]{0,3}$ ]]; }
seconds=10
size_mib=16
count=4
latency_only=0
proxy=''
while [[ $# -gt 0 ]]; do
    case "$1" in
        --quick) seconds=4; size_mib=4; count=2; shift ;;
        --latency-only) latency_only=1; shift ;;
        --seconds|--size|--count|--proxy)
            [[ $# -ge 2 && -n $2 ]] || die "$1 缺少参数"
            case "$1" in
                --seconds) seconds=$2 ;;
                --size) size_mib=$2 ;;
                --count) count=$2 ;;
                --proxy) proxy=$2 ;;
            esac
            shift 2 ;;
        -h|--help) usage; exit 0 ;;
        *) die "未知选项：$1（用 --help 查看用法）" ;;
    esac
done
integer "$seconds" && (( seconds <= 120 )) || die '--seconds 必须是 1–120 的整数'
integer "$size_mib" && (( size_mib <= 100 )) || die '--size 必须是 1–100 的整数'
integer "$count" && (( count <= 20 )) || die '--count 必须是 1–20 的整数'
if [[ -n $proxy ]]; then
    case "$proxy" in
        http://*|https://*|socks5://*|socks5h://*) ;;
        *) die '--proxy 需要 http://、https://、socks5:// 或 socks5h:// URL' ;;
    esac
fi
for dependency in curl awk; do
    command -v "$dependency" >/dev/null 2>&1 || die "请先安装 $dependency"
done
os=$(uname -s)
case "$os" in Darwin|Linux) ;; *) die '本脚本支持 macOS / Linux' ;; esac

# name|URL: regional endpoints avoid a global CDN selecting a nearby node.
# Aliyun is a CDN and may select a different region when run outside mainland China.
NODES=(
    '国内·清华北京|https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ls-lR.gz'
    '国内·阿里云CDN|https://mirrors.aliyun.com/ubuntu/ls-lR.gz'
    '海外·新加坡|https://sgp-ping.vultr.com/vultr.com.100MB.bin'
    '海外·美国东部|https://was1-vin.speedtest.network.ovh.net/files/100Mb.dat'
    '海外·法国|https://lil2-gra.speedtest.network.ovh.net/files/100Mb.dat'
)
curl_args=(-q -4 --silent --show-error --fail --location --max-redirs 3
    --connect-timeout 4 --max-time "$seconds" --proto '=https' --proto-redir '=https')
if [[ -n $proxy ]]; then
    curl_args+=(--proxy "$proxy" --noproxy '')
else
    curl_args+=(--noproxy '*')
fi
tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/net-speedtest.XXXXXX")
trap 'rm -rf "$tmpdir"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
bytes=$((size_mib * 1024 * 1024))
total_bytes=0
successes=0

printf '国内 / 海外网络测速  %s\n' "$(date '+%Y-%m-%d %H:%M:%S %Z')"
if [[ -n $proxy ]]; then
    printf '模式：指定代理；Ping 跳过，TCP 为连接代理耗时。\n'
else
    printf '模式：IPv4 直连（忽略代理环境变量；系统 VPN/TUN 仍生效）。\n'
fi
if (( latency_only )); then
    printf '仅测延迟；每节点 HTTP 最多 %s 秒，Ping %s 次。\n' "$seconds" "$count"
else
    printf '每节点请求 %s MiB、HTTP 最多 %s 秒；总请求下载量最多 %s MiB。\n' \
        "$size_mib" "$seconds" "$((size_mib * ${#NODES[@]}))"
fi
printf '逐个测量以避免相互抢带宽；海外节点不通时会自动跳过。\n\n'
printf '节点\tPing均值(ms)\t丢包\tTCP(ms)\t首字节(ms)\t下载(Mbps)\tMB/s\t状态\n'

for node in "${NODES[@]}"; do
    name=${node%%|*}
    url=${node#*|}
    request_args=()
    if (( latency_only )); then
        request_args+=(--head)
    else
        request_args+=(--range "0-$((bytes - 1))" --max-filesize "$bytes")
    fi
    # Keep errors separate from the machine-readable result, including on timeout.
    rc=0
    metrics=$(curl "${curl_args[@]}" "${request_args[@]}" --output /dev/null \
        --write-out '%{http_code}|%{remote_ip}|%{time_namelookup}|%{time_connect}|%{time_starttransfer}|%{speed_download}|%{size_download}|%{num_redirects}|%{content_type}' \
        "$url" 2>"$tmpdir/curl.err") || rc=$?
    IFS='|' read -r http ip dns connect first rate received redirects content_type <<< "$metrics"
    total_bytes=$(awk -v a="$total_bytes" -v b="${received:-0}" 'BEGIN {printf "%.0f", a+b}')
    tcp='-'; ttfb='-'; mbps='-'; mbytes='-'
    # curl aggregates timings across redirects, so do not label them as one RTT.
    if [[ ${redirects:-0} == 0 ]]; then
        tcp=$(awk -v t="${connect:-0}" -v d="${dns:-0}" \
            'BEGIN {if (t>0 && t>=d) printf "%.1f", (t-d)*1000; else printf "-"}')
    fi
    ttfb=$(awk -v t="${first:-0}" 'BEGIN {if (t>0) printf "%.1f", t*1000; else printf "-"}')
    status="失败(curl=$rc,HTTP=${http:-000})"
    if [[ $http == 200 || $http == 206 ]]; then
        if (( latency_only && rc == 0 )); then
            status='正常'; successes=$((successes + 1))
        elif (( !latency_only )) && [[ $rc == 0 || $rc == 28 ]]; then
            case "${content_type:-}" in
                application/octet-stream*|application/gzip*|application/x-gzip*)
                    if awk -v n="${received:-0}" 'BEGIN {exit !(n>=65536)}'; then
                        mbps=$(awk -v v="$rate" 'BEGIN {printf "%.2f", v*8/1000000}')
                        mbytes=$(awk -v v="$rate" 'BEGIN {printf "%.2f", v/1000000}')
                        status='完成'
                        [[ $rc == 28 ]] && status='限时采样'
                        successes=$((successes + 1))
                    else
                        status='样本不足(<64KiB)'
                    fi ;;
                *) status='非测速文件（可能被拦截）' ;;
            esac
        fi
    fi
    ping_avg='-'; loss='-'
    if [[ -z $proxy && $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && command -v ping >/dev/null 2>&1; then
        # Ping the IP curl actually reached; macOS -W uses ms, Linux uses seconds.
        if [[ $os == Darwin ]]; then
            ping -n -q -c "$count" -W 1000 -t "$((count + 2))" "$ip" >"$tmpdir/ping.txt" 2>&1 || true
        else
            ping -n -q -c "$count" -W 1 -w "$((count + 2))" "$ip" >"$tmpdir/ping.txt" 2>&1 || true
        fi
        ping_avg=$(awk -F= '/^(rtt|round-trip)/ {split($2,a,"/"); gsub(/ /,"",a[2]); print a[2]; found=1} END {if (!found) print "-"}' "$tmpdir/ping.txt")
        loss=$(awk '/packet loss/ {for(i=1;i<=NF;i++) if($i=="packet") {print $(i-1); found=1; break}} END {if (!found) print "-"}' "$tmpdir/ping.txt")
    fi
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
        "$name" "$ping_avg" "$loss" "$tcp" "$ttfb" "$mbps" "$mbytes" "$status"
    if [[ $status == 失败* ]]; then
        awk 'NR==1 {print "  " $0}' "$tmpdir/curl.err"
    fi
done

printf '\n成功节点：%s/%s；收到的 HTTP 正文：' "$successes" "${#NODES[@]}"
awk -v n="$total_bytes" 'BEGIN {printf "%.2f MiB（不含协议开销）\n", n/1048576}'
printf '%s\n' \
    'Ping 与 HTTP 分开测量；丢包只代表这几次探测，禁 Ping 不代表断网。' \
    'TCP 不含 DNS；首字节包含 DNS、建连、TLS 和服务端响应，不等于 Ping。' \
    '下载是单连接短时均速（含建连开销），受节点限速和路由影响，不代表宽带上限。' \
    '阿里云由 CDN 就近调度，不保证落在国内；大文件请求由 Range 和 curl 限制。'
(( successes > 0 ))
