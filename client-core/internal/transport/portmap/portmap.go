// Package portmap 请路由器为打洞端口开一个外网端口映射，依次尝试 PCP、NAT-PMP 与 UPnP IGD。
//
// 映射成功后，对端可以从任何地址直接发包到「路由器外网 IP:映射端口」，不必等本端先发包
// 打开路由器的过滤，也不受本端经哪条线路出去的影响。这是 Tailscale 直连率高的主要原因之一：
// 家用路由器大多支持其中一种协议。
//
// 局限：路由器自己的外网地址若是内网地址或运营商级 NAT 地址（100.64.0.0/10），说明外面
// 还有一层运营商的 NAT，映射用不上，调用方据此丢弃（见 p2p.Manager）。
package portmap

import (
	"context"
	"errors"
	"fmt"
	"net"
	"net/http"
	"net/netip"
	"sync"
	"time"
)

const (
	// leaseSeconds 是请求的映射时长。到一半就续期，进程意外退出时映射也会自己过期
	leaseSeconds = 7200
	description  = "PasteFerry"
)

// ErrNotSupported 表示网关都没有响应任何一种端口映射协议。
var ErrNotSupported = errors.New("路由器不支持端口映射（PCP、NAT-PMP、UPnP 都没有响应）")

// Mapping 是一条已建立的端口映射。
type Mapping struct {
	External netip.AddrPort // 路由器外网地址与映射到的外网端口
	Internal netip.AddrPort // 本机地址与打洞端口
	Protocol string         // "PCP"、"NAT-PMP" 或 "UPnP"
	Gateway  netip.Addr     // 应答的路由器
	Lifetime time.Duration  // 路由器给的时长；0 表示永久（只有 UPnP 会这样）
	At       time.Time

	release func(ctx context.Context) error
}

// RenewAt 是该续期的时间：时长过半；永久映射也每 30 分钟确认一次，路由器重启会丢掉它。
func (m *Mapping) RenewAt() time.Time {
	d := m.Lifetime / 2
	if d <= 0 || d > 30*time.Minute {
		d = 30 * time.Minute
	}
	if d < time.Minute {
		d = time.Minute
	}
	return m.At.Add(d)
}

// Release 请路由器删除这条映射。尽力而为：失败了映射也会到期自己消失。
func (m *Mapping) Release(ctx context.Context) error {
	if m == nil || m.release == nil {
		return nil
	}
	return m.release(ctx)
}

func (m *Mapping) String() string {
	return fmt.Sprintf("%s %s -> %s", m.Protocol, m.External, m.Internal)
}

// Client 发起端口映射。零值可用；字段只供测试替换。
type Client struct {
	// Gateways 返回要询问的网关；为空时用系统路由表里的默认网关，加上各内网网段的 .1
	Gateways func() []netip.Addr
	// PMPPort 是 PCP 与 NAT-PMP 的服务端口，默认 5351
	PMPPort int
	// SSDPAddr 是 UPnP 发现用的组播地址，默认 239.255.255.250:1900
	SSDPAddr string
	// HTTP 用来读取 UPnP 设备描述、发送 SOAP 请求
	HTTP *http.Client
	// AllowAnyIGD 接受不在网关地址上的 UPnP 设备，仅供测试
	AllowAnyIGD bool
}

// Map 为本机的 UDP 端口 localPort 建立映射，尽量让外网端口与它相同。
func (c *Client) Map(ctx context.Context, localPort int) (*Mapping, error) {
	gateways := c.gateways()
	// 各网关同时问 PCP/NAT-PMP（每个最多约 1.75 秒），按网关顺序取第一个成功的；
	// 其余成功的映射删掉，免得在别的路由器上留下没人用的映射
	type result struct {
		m   *Mapping
		err error
	}
	results := make([]result, len(gateways))
	var wg sync.WaitGroup
	for i, gw := range gateways {
		wg.Add(1)
		go func() {
			defer wg.Done()
			m, err := c.mapPMP(ctx, gw, localPort)
			results[i] = result{m, err}
		}()
	}
	wg.Wait()
	var chosen *Mapping
	var errs []error
	for _, r := range results {
		switch {
		case r.err != nil:
			errs = append(errs, r.err)
		case chosen == nil:
			chosen = r.m
		default:
			_ = r.m.Release(ctx)
		}
	}
	if chosen != nil {
		return chosen, nil
	}
	if ctx.Err() != nil {
		return nil, ctx.Err()
	}
	m, err := c.mapUPnP(ctx, gateways, localPort)
	if err == nil {
		return m, nil
	}
	errs = append(errs, err)
	return nil, fmt.Errorf("%w: %w", ErrNotSupported, errors.Join(errs...))
}

func (c *Client) gateways() []netip.Addr {
	if c.Gateways != nil {
		return c.Gateways()
	}
	return candidateGateways()
}

func (c *Client) pmpPort() int {
	if c.PMPPort != 0 {
		return c.PMPPort
	}
	return 5351
}

func (c *Client) httpClient() *http.Client {
	if c.HTTP != nil {
		return c.HTTP
	}
	return &http.Client{Timeout: 3 * time.Second}
}

// localAddrFor 返回本机发往 dst 时用的地址。UDP 的 connect 只查路由，不发包。
func localAddrFor(dst netip.Addr) (netip.Addr, error) {
	conn, err := net.DialUDP("udp4", nil, net.UDPAddrFromAddrPort(netip.AddrPortFrom(dst, 9)))
	if err != nil {
		return netip.Addr{}, err
	}
	defer conn.Close()
	return conn.LocalAddr().(*net.UDPAddr).AddrPort().Addr().Unmap(), nil
}

// candidateGateways 是系统报告的默认网关，再补上各内网网段的第一个地址（多数家用路由器
// 就在那里，系统路由表读不到时也能找到），去重，最多 4 个。
func candidateGateways() []netip.Addr {
	var out []netip.Addr
	seen := map[netip.Addr]bool{}
	add := func(a netip.Addr) {
		a = a.Unmap()
		if !a.Is4() || !a.IsPrivate() || seen[a] || len(out) >= 4 {
			return
		}
		seen[a] = true
		out = append(out, a)
	}
	for _, gw := range systemGateways() {
		add(gw)
	}
	for _, gw := range guessedGateways() {
		add(gw)
	}
	return out
}
