# WebRTC parallel file transfer feasibility — 2026-11-13

后续实现与兼容性验证见 [implementation report](webrtc-parallel-transfer-implementation.md)。以下保留方案验证阶段的原始结论和实验记录。

## Scope and conclusion

用户反馈：跨网络、界面显示直连时，文件传输偶尔只有十几 KB/s。提议把文件切片，经多个通道并行发送，接收端检查完整性并组装；慢速持续约 10 秒时自动启用。

**方案可以实现；有希望提速的部分是独立传输连接，而单纯增加同一 PeerConnection 内的 DataChannel，没有在本次实验中提速。** 分片完整性、乱序写入、重试和续传都可以实现，但当前生产协议需要扩展。实际慢速的根因尚未确定，不能根据模拟数据保证用户这条公网线路的改善幅度。

本次只做源码审查和独立实验，没有修改生产代码、协议或默认参数，没有连接用户的远端设备。

基准提交：`2ebc01962397c39be79c05027266f5fd6aa4dcd0`。

## Existing implementation

- [chunkwriter.go](../client-core/internal/transport/p2p/chunkwriter.go)：已经将字节流拆成 60 KiB 消息，发送缓冲高水位为 1 MiB。这是消息分块，不是可独立校验、调度和续传的文件区间。
- [peer.go](../client-core/internal/transport/p2p/peer.go)：`OpenStream` 在已有的同一个 `PeerConnection` 上创建可靠、有序的 DataChannel。多个通道共用一个 SCTP association 的拥塞窗口、接收窗口和选中的 ICE 路径。
- [outgoing.go](../client-core/internal/send/outgoing.go)：一次文件传输只打开一条 pipe，顺序发送条目。
- [frames.go](../client-core/internal/pack/frames.go)：整条文件帧流经过一个连续的 zstd 压缩流。不能直接把任意一段压缩字节当作可独立解压的文件切片。
- [incoming.go](../client-core/internal/send/incoming.go)：接收端校验条目序号和续传位置，按顺序写文件并校验整个文件的 SHA-256。当前并行文件区间无法直接交给这套接收逻辑。
- [wire.proto](../proto/pasteferry/v1/wire.proto)：续传状态是单一的 `resume_index + resume_offset`，不能描述「中间缺一块、后面的块已收到」。
- [manager.go](../client-core/internal/transport/p2p/manager.go)：每个设备只有一个常规 Peer 对象，并共用一个本地打洞 UDP 端口。多独立连接需要额外的连接标识、信令分派和端口管理。
- [progress.go](../client-core/internal/send/progress.go)：速度来自最近约三秒的进度采样；发送侧进度统计的是送入压缩器的原始文件字节，不是对端确认收到的网络字节。自动提速不能直接把这项 UI 数值当作公网带宽。

当前依赖为 Pion WebRTC v4.2.23、SCTP v1.12.0。SCTP 默认接收缓冲为 1 MiB。`pc.SCTP().Stats()` 已能读取平滑 RTT、拥塞窗口和接收窗口，可用于下一步诊断，不必先改第三方库。

## Experiments

### Existing loopback benchmark

运行现有 `TestStreamThroughput`，128 MiB 随机数据、60 KiB 消息、每通道 1 MiB 发送高水位，每种情况运行三次，顺序执行以避免互相争抢 CPU：

| Setup | Run 1 | Run 2 | Run 3 |
| --- | ---: | ---: | ---: |
| 1 PeerConnection, 1 DataChannel | 30.3 MiB/s | 62.2 MiB/s | 61.1 MiB/s |
| 1 PeerConnection, 4 DataChannels | 28.0 MiB/s | 32.6 MiB/s | 32.7 MiB/s |

测试原有日志写作 MB/s，实际按 MiB 计量。这个测试测协议栈的本机吞吐，不含磁盘、压缩和文件协议。结果没有显示同连接多通道的收益；与 [send-files.md](send-files.md) 中此前的原型结论一致。波动明显，不应把各次差值解释为固定性能比例。

复现命令（在 `client-core/`）：

```sh
PF_THROUGHPUT=1 PF_THROUGHPUT_MB=128 PF_THROUGHPUT_STREAMS=1 go test ./internal/transport/p2p -run '^TestStreamThroughput$' -count=3 -v
PF_THROUGHPUT=1 PF_THROUGHPUT_MB=128 PF_THROUGHPUT_STREAMS=4 go test ./internal/transport/p2p -run '^TestStreamThroughput$' -count=3 -v
```

### Simulated WAN

使用依赖自带的 `vnet`，每个方向增加 50 ms 延迟，得到约 100 ms RTT；分别设置 0%、1%、5% 的随机 UDP 丢包。所有连接经过同一个虚拟路由器，**没有设置共享带宽上限**。独立 PeerConnection 使用不同 UDP socket，不复用生产中的单端口打洞 mux。

实验复用生产的 `ChunkWriter` 和 `Stream` 接收队列。连接建立后发送 10 秒，统计接收端实际交付且内容校验通过的应用字节，包含这十秒内的慢启动影响。不是统计 `Send` 已经入队的字节。下面是各设置的一次探索性采样，不是稳定性或生产环境验收结果。

| Packet loss | 1 PC / 1 DC | 1 PC / 4 DCs | 4 PCs / 1 DC each |
| --- | ---: | ---: | ---: |
| 0% | 9,258 KiB/s | 8,760 KiB/s | 37,091 KiB/s |
| 1% | 300 KiB/s | 240 KiB/s | 792 KiB/s |
| 5% | 84 KiB/s | Not run | 252 KiB/s |

观察：

- 无丢包时，四个独立连接约为单连接的四倍，但实验没有物理带宽瓶颈，不能据此推断真实公网也有四倍收益。
- 1% 丢包时，单连接结束时的拥塞窗口约 12 KiB，剩余接收窗口约 992 KiB；增加接收缓冲无法直接解决拥塞窗口过小。
- 1% 丢包时，四个独立连接的合计有效吞吐约为单连接的 2.64 倍；5% 丢包时约为三倍。它说明多个独立拥塞窗口在这种模拟条件下有收益。
- 单连接四通道没有改善。增加通道或 goroutine 本身不会增加独立拥塞窗口。
- 模拟没有复现用户实际线路的十几 KB/s；实际丢包率、RTT、UDP 策略、CPU 和磁盘状况仍未知。

另做单连接、单通道的窗口对照，仍使用约 100 ms RTT、相同的十秒统计口径：

| Receive buffer / send high-water mark | 0% loss | 1% loss |
| --- | ---: | ---: |
| 1 MiB / 1 MiB (production defaults) | 9,258 KiB/s | 300 KiB/s |
| 4 MiB / 1 MiB | 9,780 KiB/s | Not run |
| 4 MiB / 4 MiB | 36,228 KiB/s | 258 KiB/s |

仅增加接收缓冲没有明显改善；无丢包时，同时增加发送高水位和接收缓冲，单连接已经接近四独立连接的速度。1% 丢包时，同样的窗口调整没有显示收益，实验结束时拥塞窗口仅约 6 KiB，而剩余接收窗口约 4 MiB。因此需要区分可用发送/接收窗口限制与丢包导致的拥塞窗口限制，不能把无丢包时四连接的收益全部归因于必须多端口。

这项调参只通过额外的 Go overlay 验证，没有改变生产的 1 MiB 高水位。增加缓存也会增加内存和排队延迟，产品方案应受总预算约束，并结合真实线路测量。

实验源文件、Go overlay 和原始输出位于 `/tmp/pasteferry-webrtc-feasibility-20261113/`。overlay 把临时实验文件挂到测试包，未将实验改动写入生产源码。该临时目录可能被系统清理，保留结果以上表为准。

此实验没有实现独立文件区间协议，也没有验证真实 NAT 打洞、多连接重连、崩溃续传或完整文件组装。内容校验只验证测试消息，不能替代完整文件协议验收。

## Recommended design

### Selected implementation direction

推荐在现有传输上增加可协商的并行区间模式：已有 WebRTC 连接保留控制消息和第一路文件数据；慢速时增加独立的文件数据 PeerConnection，总数据连接数按 `1 → 2 → 4` 试探。新增连接各自使用独立 UDP socket、ICE 会话、DTLS 和 SCTP association。同设备的所有任务共用这个上限，文件不能各自再开四路。

局域网继续优先使用现有 TLS/TCP 快速通道。第一版只在双方支持新能力、且当前是跨网络直连时试探加速；额外连接不能悄悄改走需要用户同意的中转。旧客户端使用现有协议。

建议原型从以下参数开始。这些是待实机验证的设计值，不是本次实验测出的最佳参数：

| Item | Initial choice |
| --- | --- |
| Baseline | One connection; observe actual receiver progress for 10 seconds |
| Initial trigger | Average below 256 KiB/s, estimated remaining time above 30 seconds, and sender has pending data |
| Connection count | Try two; try four only after the previous increase produces sustained benefit |
| Trial evaluation | After a short warm-up, compare aggregate receiver goodput across two consecutive five-second windows against the preceding baseline |
| Retention | Start with a 20% improvement requirement; retreat if no benefit or control latency materially worsens |
| Retry cooldown | At least 30 seconds after an unsuccessful probe |
| First prototype range size | Fixed 64 KiB; then evaluate bounded adaptation between 64 KiB and 1 MiB |
| Compression | Compress each range independently; fall back to raw bytes when compression increases its size |

这个慢速阈值先覆盖用户反馈的场景；以后应根据实机结果评估是否也对中等速度但剩余时间较长的传输试探加速。若消费侧磁盘或解压已受限，不应继续加连接。若诊断表明受发送/接收窗口限制，应先对受控窗口调整做对照实验，不能仅凭速度阈值认定需要多连接。

任务调度使用公共区间队列，连接空闲时领取下一块。接收端按偏移写临时文件，逐块确认、保存完成区间，最后验证整个文件。连接失败后先释放并关闭旧连接，再把其未确认区间重新排队；迟到帧按尝试代次和区间标识去重，防止与重新分配的任务冲突。

接收确认应区分两个目的：用于实时测速的累计唯一接收字节可以定时反馈；用于续传的区间完成确认必须在完整区间校验和写入成功后发出。速度采样不能只等整块完成，否则极慢线路会长期显示零进度。崩溃恢复时不能仅信任数据库完成位，应结合检查点持久化顺序和区间重校验确认数据仍然存在。

实现分两步：先完成固定分片、最多两路、手动实验开关，以及完整性和续传验证；真实慢速线路证明有稳定收益后，再启用自动试探、四路和动态分片。

### Connections and automatic activation

1. 开始时只使用一个数据连接。持续收集对端确认的有效字节、RTT、拥塞窗口、接收窗口、发送积压，以及磁盘/解压耗时。
2. 以约 10 秒作为初始观测窗口，使用窗口平均值或平滑值。慢速还需结合剩余文件量和预计剩余时间，避免小文件刚启动就建新连接。
3. 将数据连接从 1 增加到 2，观察后再决定是否增加到 4。上限 4 是原型起点，需要实测调整。
4. 对比增加前后的**总有效吞吐**，只有连续观测到明显收益才保留；例如 20% 增益可以作为初始试验阈值，不能当作已验证的产品默认值。没有收益、重传加剧或控制消息明显变慢时撤回新增连接，并设置冷却期。
5. 若接收窗口或本地发送积压构成限制，先用有上限的窗口调节实验确认；若拥塞窗口因丢包缩小，多独立连接才更值得试。若真实上下行总带宽已满，多连接无法突破总带宽。

独立连接不一定代表不同网络路线。普通多连接仍可能共用同一运营商出口、路由器和 UDP 限制；只有真实存在其他可达路径时，才谈得上按路径择优。

生产的 `UDPMux` 按远端地址分派非 STUN 数据。如果两端所有并行连接都复用相同本地端口和远端地址，会出现会话分派冲突的风险，不能直接对同一个 mux 重复创建 PeerConnection。最小原型应让额外数据连接使用独立端口、独立 ICE 探测和连接标识，维持原有控制连接。

### File ranges and reconstruction

- 元数据包含传输 ID、尝试代次、文件 ID、相对路径、总大小、分片布局及整文件校验值；每块明确自己的区间 ID、offset、原始长度、传输长度、压缩方式和校验值。连接必须绑定已认证的设备和已接受的传输。
- 文件区间与 60 KiB DataChannel 消息是两层概念。一个文件区间可以由多个网络消息承载。
- 建议使用公共待传区间队列，空闲连接领取下一块。这样快连接承担更多任务，个别慢连接不会固定占有文件的四分之一。
- 接收端可将校验通过的块用 `WriteAt(offset)` 写到同一临时文件，无须先保存几百个独立文件、最后再复制一遍。需要严格限制区间边界并禁止不一致的重叠写入。
- 持久化已经完成的块或区间集合，重复块幂等处理，失败只重传缺失区间；断线后重新安排未完成的块。
- 「切片数相同」不足以证明完整；需要确认所有预期区间都有且只覆盖正确范围、长度正确、每块校验通过，最后整文件 SHA-256 一致，再原子移到正式保存位置。
- 当前连续 zstd 流需要调整为每个文件区间独立压缩，才能独立接收、校验和重试。完成时通常还要顺序读取临时文件计算整文件 SHA-256，不能简单拼接各块 SHA-256。
- 所有连接共享总的内存、排队字节和在途区间预算，避免新增连接使缓存数量不受控制。当前每条接收流的 256 消息队列理论上约可容纳 15 MiB 数据，四条就约 60 MiB，尚未计入其他缓冲。

### Use of the ten-second maximum

不建议按「近十秒的最大瞬时速度 × 十秒」直接决定切片大小。瞬时速度会受本地缓冲、压缩比、采样时间和积压集中释放影响，可能远高于持续可用吞吐；大块还会拖长失败重试和慢连接收尾时间。

十秒适合判断趋势。区间大小应面向单个 worker 的持续有效速度，目标是每块约一到几秒可完成，并设置明确的大小上下限。例如 64 KiB 到 1 MiB 可以作为初始试验范围，再根据极慢线路的完成时延调整；已经分配的区间保持不变，新区间才使用调整后的大小，保证续传布局明确。

## Minimum implementation and acceptance work

1. 先给当前传输加诊断采样，针对实际慢速直连拿到有效吞吐、RTT、窗口和重传/停顿迹象，区分网络、窗口和消费侧瓶颈。
2. 做双端支持的实验能力标记，例如 `send_files_parallel_v1`；双方都支持才协商新模式，与旧客户端仍使用已有传输协议。
3. 最小实现先支持单个大文件、两条独立连接、固定区间、完整性校验和缺块续传，然后再加四连接、动态区间和自动启停。
4. 在同一对真实设备上比较单连接默认参数、单连接受控窗口调整、多通道、两独立连接、四独立连接。覆盖良好网络、高 RTT、随机/突发丢包、共享带宽上限以及不同 NAT。
5. 验证文件乱序到达、重复块、连接中断、进程重启、源文件变化、磁盘满、取消、旧客户端兼容，以及大文件期间文字同步的延迟。至少使用不可压缩和可压缩两类数据。

进入生产实现的依据应是：在实际慢速网络上存在可重复的总吞吐收益，文件完整性和恢复行为通过验证，并且无收益时能自动退回单连接。
