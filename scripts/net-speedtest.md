# 国内 / 海外一键测速

适用于 macOS 和 Linux，不需要管理员权限。依赖 Bash、curl、awk，安装了 ping 时也会显示 ICMP 延迟和丢包率。脚本可单独复制到其他电脑运行。

```bash
bash scripts/net-speedtest.sh
```

依次测试清华北京镜像、阿里云 CDN、新加坡、美国东部和法国节点，输出 Ping 平均延迟、丢包率、TCP 连接耗时、HTTP 首字节耗时、下载 Mbps 和 MB/s。默认每节点请求 16 MiB，HTTP 最多 10 秒，总请求下载量最多 80 MiB，下载数据直接丢弃。

```bash
# 快速检查：每节点 4 MiB，HTTP 最多 4 秒
bash scripts/net-speedtest.sh --quick

# 只测延迟，不下载测速文件
bash scripts/net-speedtest.sh --latency-only

# 更长的下载采样：每节点最多 32 MiB / 15 秒
bash scripts/net-speedtest.sh --size 32 --seconds 15

# 通过本机代理测试
bash scripts/net-speedtest.sh --proxy http://127.0.0.1:1087
bash scripts/net-speedtest.sh --proxy socks5h://127.0.0.1:1080

# 保存可分享的文本结果
bash scripts/net-speedtest.sh | tee speedtest.txt
```

默认强制 IPv4 直连，忽略代理环境变量和 curl 配置文件；系统 VPN 或 TUN 路由仍然生效。代理模式跳过 Ping，因为普通 ICMP 不会经过 HTTP / SOCKS 代理；此时 TCP 显示的是连接代理的耗时，首字节耗时反映整条 HTTP 请求链路。

测速逐个运行，避免节点争抢带宽。“限时采样”表示达到时间限制后，用已收到的数据计算均速；不足 64 KiB 不报告速度。HTTP 错误或返回 HTML 拦截页面不会被当作测速结果。全部节点失败时退出码为 1，参数错误为 2。

这些是公共下载端点的单连接短时测速，不测上传，不代表宽带的最高容量。首字节耗时包括 DNS、TCP、TLS 与服务端处理；Ping 在下载结束后测量，不代表下载满载时的延迟。阿里云 CDN 会就近调度，在境外运行时不保证连接到国内节点。脚本使用 HTTP Range 和 curl 的文件大小限制；旧版 curl 对无 Content-Length 且忽略 Range 的服务器可能无法严格限制流量，但仍有总超时。

公共服务可能更换地址、限速或屏蔽探测。需要更换节点时，编辑脚本顶部的 `NODES` 数组，填入支持 HTTPS Range 的二进制文件地址；地域标签应与服务器实际部署位置一致。
