package p2p

import (
	"context"
	"fmt"
	"hash/fnv"
	"net"
	"net/netip"
	"slices"
	"sort"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/pion/ice/v4"
	"github.com/pion/stun/v4"
)

// 出口探测：在打洞用的那一个本地端口上，向多台 STUN 服务器询问本机的公网地址。
//
// 有的网络不止一个出口——公司双线、运营商的 NAT 地址池——并且按目标地址选出口。
// 只问一台服务器，得到的只是「去往那台服务器」的出口地址；发往对端的包可能从另一个
// 出口出去，对端收到的源地址与告诉它的对不上，就会被它的路由器丢弃，打洞随之失败。
//
// 实测（见仓库提交记录）：这类网络里出口只按目标 IP 选择，与目标端口无关；同一条
// 线路上同一个本地端口的公网映射是固定的。所以向 IP 足够分散的一组服务器探测，
// 就能拿到本机在每条线路上的地址，把它们都告诉对端，对端挨个打过来总有一个对得上。

// DefaultProbeServers 是内置的公共 STUN 服务器，按「IP 分散、国内可达」挑选。
// 信令服务器下发的 STUN 地址总会被一并探测；这一组只在用户允许时使用。
var DefaultProbeServers = []string{
	"stun.chat.bilibili.com:3478",
	"stun.cloudflare.com:3478",
	"global.stun.twilio.com:3478",
	"stun.nextcloud.com:3478",
	"stun.l.google.com:19302",
	"stun.freeswitch.org:3478",
}

const (
	probeTimeout      = 1500 * time.Millisecond
	maxSrflxAdvertise = 8 // 发给对端的出口地址上限，太多只会拖慢连通性检查
	historyTTL        = 7 * 24 * time.Hour
	// maxProbeTargets 是一轮最多探测的服务器 IP 数。按目标 IP 分线路的网络里，
	// IP 越多越可能每条线路都落到；并发探测，多几个 IP 不多花时间
	maxProbeTargets = 24
)

// Egress 是本机在某个出口上的公网地址。
type Egress struct {
	Addr netip.AddrPort
	// PortPreserved 表示这个出口不改端口（公网端口等于本地端口）。
	// 这样的出口即使某一轮没探测到，也能用「出口 IP + 本地端口」推算出来。
	PortPreserved bool
	// Via 是经由哪些探测服务器发现的（域名，去重）；为空表示来自历史记录的推算。
	Via []string
	// Targets 是看到这个地址的探测服务器 IP。出口历史记住它们，以后每轮都探测，
	// 免得 DNS 换了一组 IP 之后这条线路就探测不到了（见 egressHistory.pinned）
	Targets []probeTarget
}

// Guessed 表示这个地址是按历史记录推算的，而非本轮实测。
func (e Egress) Guessed() bool { return len(e.Via) == 0 }

// mappingFresh：握手时探测结果超过这么久、又有会过时的地址（见 needsFreshProbe），先重新探测
const mappingFresh = 10 * time.Second

// needsFreshProbe 报告握手前是否该重新探测：有会改写端口的线路，或做了端口预测。
//
// 改写端口的线路（多是运营商级 NAT）映射空闲一两分钟就会回收，下次再发包换一个新端口。
// 实测公司一条这样的线路，同一个本地端口每隔 5 分钟探测一次，次次端口都不一样：
// 握手时拿几分钟前的结果去告诉对端，端口多半已经对不上了。重新探测一轮，既拿到当前的
// 端口，也让映射在接下来的连通性检查期间保持住。对称型 NAT 的端口计数一直在往后走，
// 预测同样要用最新的结果。不改端口的线路地址不会变，不必为它重探。
func (r EgressReport) needsFreshProbe() bool {
	if len(r.Predicted) > 0 {
		return true
	}
	for _, e := range r.Egresses {
		if !e.Guessed() && !e.PortPreserved {
			return true
		}
	}
	return false
}

// EgressReport 是一轮探测的结果。
type EgressReport struct {
	LocalPort int
	Egresses  []Egress
	Probed    int // 发出探测的服务器数（按 IP 去重后）
	Answered  int // 有响应的服务器数
	At        time.Time
	// Predicted 是按端口分配规律推测的、下一条新映射可能用到的公网地址（见 predictPorts）。
	// 只有对称型 NAT（同一公网 IP 对不同服务器给出不同端口）才有
	Predicted []netip.AddrPort
}

// Symmetric 报告这一轮是否看到对称型 NAT：同一个公网 IP 对不同目标给出了不同的端口。
func (r EgressReport) Symmetric() bool {
	ports := map[netip.Addr]uint16{}
	for _, e := range r.Egresses {
		if e.Guessed() {
			continue
		}
		if p, ok := ports[e.Addr.Addr()]; ok && p != e.Addr.Port() {
			return true
		}
		ports[e.Addr.Addr()] = e.Addr.Port()
	}
	return false
}

// stunProber 由 ice.UniversalUDPMux 实现：在共享的那个端口上做一次 STUN 探测。
type stunProber interface {
	GetXORMappedAddr(stunAddr net.Addr, deadline time.Duration) (*stun.XORMappedAddress, error)
}

var _ stunProber = (*ice.UniversalUDPMuxDefault)(nil)

type probeOptions struct {
	// AllowPrivate 允许内网与回环地址的探测服务器，仅供测试与实验环境使用
	AllowPrivate bool
	// Lookup 解析域名的 IPv4 地址；为空时用系统解析，测试时替换
	Lookup func(ctx context.Context, host string) ([]netip.Addr, error)
	// Pinned 是出口历史里记下的、曾经探测到某条线路的服务器，排在各域名的第一个 IP 之后
	Pinned []probeTarget
}

// probeEgress 并发探测所有服务器，按公网地址归并结果。
func probeEgress(ctx context.Context, prober stunProber, localPort int, servers []string,
	opts probeOptions) EgressReport {
	targets := resolveProbeTargets(ctx, servers, opts)
	report := EgressReport{LocalPort: localPort, Probed: len(targets), At: time.Now()}

	type answer struct {
		target probeTarget
		addr   netip.AddrPort
	}
	answers := make(chan answer, len(targets))
	var wg sync.WaitGroup
	for _, t := range targets {
		wg.Add(1)
		go func(t probeTarget) {
			defer wg.Done()
			mapped, err := prober.GetXORMappedAddr(net.UDPAddrFromAddrPort(t.addr), probeTimeout)
			if err != nil || mapped == nil {
				return
			}
			ip, ok := netip.AddrFromSlice(mapped.IP)
			if !ok {
				return
			}
			answers <- answer{target: t, addr: netip.AddrPortFrom(ip.Unmap(), uint16(mapped.Port))}
		}(t)
	}
	wg.Wait()
	close(answers)

	byAddr := map[netip.AddrPort]*Egress{}
	var order []netip.AddrPort
	for a := range answers {
		report.Answered++
		e, ok := byAddr[a.addr]
		if !ok {
			e = &Egress{Addr: a.addr, PortPreserved: int(a.addr.Port()) == localPort}
			byAddr[a.addr] = e
			order = append(order, a.addr)
		}
		if !slices.Contains(e.Via, a.target.name) {
			e.Via = append(e.Via, a.target.name)
		}
		e.Targets = append(e.Targets, a.target)
	}
	// 被越多服务器看到的出口越可能是常用出口，排在前面
	sort.SliceStable(order, func(i, j int) bool {
		return len(byAddr[order[i]].Targets) > len(byAddr[order[j]].Targets)
	})
	for _, a := range order {
		e := byAddr[a]
		sort.Strings(e.Via)
		slices.SortFunc(e.Targets, func(x, y probeTarget) int { return x.addr.Compare(y.addr) })
		report.Egresses = append(report.Egresses, *e)
	}
	return report
}

type probeTarget struct {
	name string
	addr netip.AddrPort
}

// resolveProbeTargets 解析服务器地址，过滤掉不可能是公网 STUN 的地址，并按 IP 去重。
//
// 按 IP 去重是因为出口只按目标 IP 选择：同一 IP 的不同端口、同一 IP 的多个域名
// （Google 的 stun1–4 就是同一个 IP）只会落在同一个出口上，多探无益。
//
// 反过来，同一个域名的多个 IP 要都探测：多线路的路由器按目标 IP 选线路，一个域名的
// 几个 IP 常常分落在不同线路上。实测公司网络 4 条线路，B 站一个域名的 7 个 IP 就
// 覆盖了全部 4 条；以前每个域名只取第一个 IP，DNS 返回的顺序一变，某条线路就整轮
// 探测不到，恰好经那条线路去往对端时就打不通。
//
// 排列顺序：先是每个域名的第一个 IP，再是历史里记下的服务器（opts.Pinned），
// 最后轮流取各域名的其余 IP，总数不超过 maxProbeTargets。
//
// 各域名并发解析：逐个解析时一台 DNS 慢就拖住整轮探测，而刚开机、刚换网络时
// 正是 DNS 最慢、最需要尽快探完的时候（探完才能把出口地址发给对端）。
func resolveProbeTargets(ctx context.Context, servers []string, opts probeOptions) []probeTarget {
	lookup := opts.Lookup
	if lookup == nil {
		lookup = func(ctx context.Context, host string) ([]netip.Addr, error) {
			return net.DefaultResolver.LookupNetIP(ctx, "ip4", host)
		}
	}
	type resolved struct {
		host string
		port uint16
		ips  []netip.Addr
	}
	results := make([]resolved, len(servers))
	var wg sync.WaitGroup
	for i, s := range servers {
		host, port, err := parseProbeServer(s)
		if err != nil {
			continue
		}
		results[i] = resolved{host: host, port: port}
		if ip, err := netip.ParseAddr(host); err == nil {
			results[i].ips = []netip.Addr{ip}
			continue
		}
		wg.Add(1)
		go func() {
			defer wg.Done()
			lctx, cancel := context.WithTimeout(ctx, 2*time.Second)
			defer cancel()
			if ips, err := lookup(lctx, host); err == nil {
				results[i].ips = ips
			}
		}()
	}
	wg.Wait()

	// 按服务器原本的顺序去重，结果与解析快慢无关
	seen := map[netip.Addr]bool{}
	var out []probeTarget
	add := func(t probeTarget) bool {
		ip := t.addr.Addr().Unmap()
		if len(out) >= maxProbeTargets || !ip.Is4() || seen[ip] || !usableProbeIP(ip, opts.AllowPrivate) {
			return false
		}
		seen[ip] = true
		out = append(out, probeTarget{name: t.name, addr: netip.AddrPortFrom(ip, t.addr.Port())})
		return true
	}
	// 每个域名的第一个可用 IP；记下用到了第几个，后面接着轮流取
	next := make([]int, len(results))
	for i, r := range results {
		for next[i] < len(r.ips) {
			ip := r.ips[next[i]]
			next[i]++
			if add(probeTarget{name: r.host, addr: netip.AddrPortFrom(ip, r.port)}) {
				break
			}
		}
	}
	for _, t := range opts.Pinned {
		add(t)
	}
	for more := true; more && len(out) < maxProbeTargets; {
		more = false
		for i, r := range results {
			for next[i] < len(r.ips) {
				ip := r.ips[next[i]]
				next[i]++
				more = true
				if add(probeTarget{name: r.host, addr: netip.AddrPortFrom(ip, r.port)}) {
					break
				}
			}
		}
	}
	return out
}

// parseProbeServer 接受 "stun:host:port"、"stun:host"、"host:port" 等写法。
func parseProbeServer(s string) (string, uint16, error) {
	s = strings.TrimSpace(s)
	s = strings.TrimPrefix(strings.TrimPrefix(s, "stuns:"), "stun:")
	if i := strings.IndexByte(s, '?'); i >= 0 {
		s = s[:i]
	}
	if s == "" {
		return "", 0, fmt.Errorf("空地址")
	}
	host, portStr, err := net.SplitHostPort(s)
	if err != nil {
		return s, 3478, nil // 没写端口，用 STUN 默认端口
	}
	port, err := strconv.ParseUint(portStr, 10, 16)
	if err != nil || port == 0 {
		return "", 0, fmt.Errorf("端口无效: %q", portStr)
	}
	return host, uint16(port), nil
}

// 不可能是公网 STUN 服务器的地址段。DNS 污染与代理软件的 fake-ip 会把域名解析到这些地方，
// 向它们发探测只会超时，或者更糟——被当成一个出口。
var bogusPrefixes = mustPrefixes(
	"0.0.0.0/8",       // 本网络
	"100.64.0.0/10",   // 运营商 NAT 内部地址
	"192.0.0.0/24",    // IETF 协议分配
	"192.0.2.0/24",    // 文档示例（实测某些域名被污染到这里）
	"198.18.0.0/15",   // 基准测试段，Clash 等代理的 fake-ip 默认用它
	"198.51.100.0/24", // 文档示例
	"203.0.113.0/24",  // 文档示例
	"240.0.0.0/4",     // 保留
)

func usableProbeIP(ip netip.Addr, allowPrivate bool) bool {
	if !ip.IsValid() || ip.IsUnspecified() || ip.IsMulticast() || ip.IsLinkLocalUnicast() {
		return false
	}
	if ip.IsLoopback() || ip.IsPrivate() {
		return allowPrivate
	}
	for _, p := range bogusPrefixes {
		if p.Contains(ip) {
			return false
		}
	}
	return true
}

func mustPrefixes(ss ...string) []netip.Prefix {
	out := make([]netip.Prefix, len(ss))
	for i, s := range ss {
		out[i] = netip.MustParsePrefix(s)
	}
	return out
}

// srflxCandidates 把探测结果转成发给对端的 srflx candidate 字符串。
//
// 实测到的地址排在前面、优先级更高；推算的地址其次；端口预测的地址垫底。数量有上限：
// 每多一个地址，对端就要多做一轮连通性检查。预测的地址单独计数，不挤占实测地址的名额。
func srflxCandidates(r EgressReport) []string {
	var out []string
	seen := map[netip.AddrPort]bool{}
	add := func(a netip.AddrPort, localPref int) {
		seen[a] = true
		// RFC 8445 5.1.2.1：priority = 2^24*type + 2^8*local + (256 - component)
		priority := (1<<24)*100 + (1<<8)*localPref + 255
		out = append(out, fmt.Sprintf("candidate:%d 1 udp %d %s %d typ srflx raddr 0.0.0.0 rport %d",
			candidateFoundation(a), priority, a.Addr(), a.Port(), r.LocalPort))
	}
	var measured, guessed []Egress
	for _, e := range r.Egresses {
		if e.Guessed() {
			guessed = append(guessed, e)
		} else {
			measured = append(measured, e)
		}
	}
	for i, e := range append(measured, guessed...) {
		if len(out) >= maxSrflxAdvertise {
			break
		}
		if seen[e.Addr] {
			continue
		}
		pref := 65535 - i
		if e.Guessed() {
			pref = 32767 - i
		}
		add(e.Addr, pref)
	}
	predicted := 0
	for i, a := range r.Predicted {
		if predicted >= maxPredictAdvertise {
			break
		}
		if seen[a] {
			continue
		}
		add(a, 16383-i)
		predicted++
	}
	return out
}

// ───────────── 对称型 NAT 的端口预测 ─────────────
//
// 对称型 NAT 给每个目标分配一个新的公网端口，STUN 探测到的端口只对探测服务器有效，
// 对端往那里发包会被丢弃——这是对称型 NAT 打不通的根本原因。
//
// 但不少对称型 NAT（实测某款随身 WiFi 走的运营商网络）的端口是一个计数器顺序往上加：
// 同一轮探测里新开的几个映射端口挨在一起（如 59739–59743），一天里只缓慢地往后走，
// 到 65535 后回到低位。这样下一条新映射——发往对端的那一条——多半就落在刚探测到的
// 最大端口后面几个号里。把这一段端口也作为出口地址告诉对端，对端的连通性检查会挨个
// 往这些端口发包：既打开了它自己路由器对这些端口的过滤，也总有一个正好对上本端的
// 新映射，连接就通了。对端无需任何改动，照常检查收到的 candidate 即可。
//
// 端口随机分配的对称型 NAT 预测不中，只是多发了几十个检查包，照旧落到中转。
const (
	maxPredictAdvertise = 32          // 发给对端的预测地址上限
	predictSpan         = 12          // 每段连续分配之后预测的端口数
	predictClusterGap   = 512         // 端口相距不超过这么多，算同一段连续分配（中途偶有一两百的跳跃）
	predictPersistAge   = time.Minute // 两轮探测至少隔这么久，才能据此认出一直保持着的旧映射
	natPortFloor        = 1024        // 端口计数到 65535 后假定从这里重新开始
)

// predictPorts 为对称型 NAT 推测接下来会分配的公网端口。
//
// 按公网 IP 分组，把本轮实测的端口按「相距不远」分段，每一段的末尾（最新分配的那个）
// 之后预测 predictSpan 个端口。分段而不是只看最大值：运营商 NAT 可能有不止一个计数器
// （比如另一个公网 IP 或另一段端口池），只看最大值会押错。
//
// prev 是上一轮探测：间隔足够久仍原样出现的映射是一直保持着的旧映射（发往某台服务器的
// 映射被保活），它们所在的段不代表当前计数，排到最后。
func predictPorts(cur, prev EgressReport) []netip.AddrPort {
	if !cur.Symmetric() {
		return nil
	}
	persistent := map[netip.AddrPort]bool{}
	if !prev.At.IsZero() && prev.LocalPort == cur.LocalPort && cur.At.Sub(prev.At) >= predictPersistAge {
		for _, e := range prev.Egresses {
			if !e.Guessed() {
				persistent[e.Addr] = true
			}
		}
	}

	type cluster struct {
		ip    netip.Addr
		top   int // 段内最新分配的端口
		size  int
		stale bool // 段内全是上一轮就有的旧映射
	}
	var clusters []cluster
	seen := map[netip.AddrPort]bool{}
	var ipOrder []netip.Addr
	byIP := map[netip.Addr][]int{}
	for _, e := range cur.Egresses {
		if e.Guessed() {
			continue
		}
		seen[e.Addr] = true
		ip := e.Addr.Addr()
		if _, ok := byIP[ip]; !ok {
			ipOrder = append(ipOrder, ip)
		}
		byIP[ip] = append(byIP[ip], int(e.Addr.Port()))
	}
	for _, ip := range ipOrder {
		for _, seg := range portClusters(byIP[ip]) {
			stale := true
			for _, port := range seg {
				if !persistent[netip.AddrPortFrom(ip, uint16(port))] {
					stale = false
				}
			}
			clusters = append(clusters, cluster{ip: ip, top: seg[len(seg)-1], size: len(seg), stale: stale})
		}
	}
	// 新分配的段在前，其中端口多的（计数器最活跃的）在前
	sort.SliceStable(clusters, func(i, j int) bool {
		if clusters[i].stale != clusters[j].stale {
			return !clusters[i].stale
		}
		return clusters[i].size > clusters[j].size
	})

	var out []netip.AddrPort
	for _, c := range clusters {
		port := c.top
		for n := 0; n < predictSpan && len(out) < maxPredictAdvertise; {
			port = nextNATPort(port)
			a := netip.AddrPortFrom(c.ip, uint16(port))
			if seen[a] {
				continue // 已是发往别处的映射，不会再分给新目标
			}
			seen[a] = true
			out = append(out, a)
			n++
		}
	}
	return out
}

// portClusters 把端口分成若干段「连续分配」：排序后相邻两个相距不超过 predictClusterGap 的归为一段。
// 计数到顶后会回到低位，跨过 65535 的两段首尾相接，合成一段。每段按分配先后排列，末尾是最新的。
func portClusters(ports []int) [][]int {
	if len(ports) == 0 {
		return nil
	}
	sorted := slices.Clone(ports)
	slices.Sort(sorted)
	sorted = slices.Compact(sorted)
	var segs [][]int
	start := 0
	for i := 1; i <= len(sorted); i++ {
		if i == len(sorted) || sorted[i]-sorted[i-1] > predictClusterGap {
			segs = append(segs, sorted[start:i])
			start = i
		}
	}
	if len(segs) > 1 {
		first, last := segs[0], segs[len(segs)-1]
		if (65535-last[len(last)-1])+(first[0]-natPortFloor) <= predictClusterGap {
			// 高位那段在前（先分配），回绕后的低位那段在后
			merged := append(slices.Clone(last), first...)
			segs = append([][]int{merged}, segs[1:len(segs)-1]...)
		}
	}
	return segs
}

// nextNATPort 是端口计数的下一个值，到顶后回到低位。
func nextNATPort(p int) int {
	if p >= 65535 {
		return natPortFloor
	}
	return p + 1
}

// predictedSummary 把预测的地址压缩成「IP:起-止」的区间，用于日志。
func predictedSummary(addrs []netip.AddrPort) []string {
	var out []string
	for i := 0; i < len(addrs); {
		j := i
		for j+1 < len(addrs) && addrs[j+1].Addr() == addrs[i].Addr() && int(addrs[j+1].Port()) == nextNATPort(int(addrs[j].Port())) {
			j++
		}
		s := addrs[i].String()
		if j > i {
			s += fmt.Sprintf("-%d", addrs[j].Port())
		}
		out = append(out, s)
		i = j + 1
	}
	return out
}

func candidateFoundation(a netip.AddrPort) uint32 {
	h := fnv.New32a()
	h.Write([]byte(a.String()))
	return h.Sum32()
}
