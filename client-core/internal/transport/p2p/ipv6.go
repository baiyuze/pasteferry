package p2p

import (
	"net"
	"net/netip"

	"github.com/pion/ice/v4"
	"github.com/wlynxg/anet"
)

// IPv6 直连。
//
// 两边都有公网 IPv6 时根本不需要穿越 NAT：对方的 IPv6 地址就是它真正的地址，
// 双方同时往对方发包，各自防火墙都看到了「本机先发出去」的流量，回包自然放行。
// 国内宽带与 4G/5G 大多已经下发 IPv6，正好绕开运营商对称型 NAT 这类最难打的情况。
//
// 以前打洞端口只按 IPv4 打开（为了让出口探测在同一个端口上成立，见 egress.go），
// pion 在这个端口上只收集得到 IPv4 地址，IPv6 一直没有用上。现在另开一个 IPv6 端口，
// 与 IPv4 的共享端口合成一个 UDPMux 交给 pion：IPv4 的行为不变，另外多出本机的
// 公网 IPv6 地址作为 host candidate。

// usableHostV6 判断一个本机 IPv6 地址值不值得发给对端：只要公网单播地址。
// 链路本地、回环、ULA（fc00::/7，只在本地网络内有效）都排除。变量供测试放宽。
var usableHostV6 = func(ip netip.Addr) bool {
	return ip.Is6() && !ip.Is4In6() && ip.IsGlobalUnicast() && !ip.IsPrivate()
}

// openIPv6Mux 打开 IPv6 打洞端口，尽量与 IPv4 的共享端口同号（便于诊断与防火墙规则对照）。
// 本机没有 IPv6 协议栈时返回 nil。
func openIPv6Mux(port int) *ice.UDPMuxDefault {
	conn, err := net.ListenUDP("udp6", &net.UDPAddr{IP: net.IPv6unspecified, Port: port})
	if err != nil {
		conn, err = net.ListenUDP("udp6", &net.UDPAddr{IP: net.IPv6unspecified})
	}
	if err != nil {
		return nil
	}
	return ice.NewUDPMuxDefault(ice.UDPMuxParams{UDPConn: conn})
}

// dualStackMux 把 IPv4 与 IPv6 两个打洞端口合成 pion 的一个 UDPMux。
//
// 不用 pion 自带的 MultiUDPMuxDefault：它在创建时就把各端口的本机地址抄下来，
// 之后换了网络、地址变了也不再更新；这里每次收集地址时都现查。
type dualStackMux struct {
	v4 ice.UDPMux
	v6 ice.UDPMux
}

var _ ice.UDPMux = (*dualStackMux)(nil)

// Close 不关闭两个端口：它们归 Manager 所有，由 Manager.Close 关闭。
func (d *dualStackMux) Close() error { return nil }

func (d *dualStackMux) GetConn(ufrag string, addr net.Addr) (net.PacketConn, error) {
	if ua, ok := addr.(*net.UDPAddr); ok && ua.IP.To4() == nil {
		return d.v6.GetConn(ufrag, addr)
	}
	return d.v4.GetConn(ufrag, addr)
}

func (d *dualStackMux) RemoveConnByUfrag(ufrag string) {
	d.v4.RemoveConnByUfrag(ufrag)
	d.v6.RemoveConnByUfrag(ufrag)
}

// GetListenAddresses 是 IPv4 端口原有的地址，加上 IPv6 端口上可用的公网 IPv6 地址。
// IPv6 端口绑在 [::] 上时 pion 会把本机的 IPv4 地址也列进来，必须滤掉。
func (d *dualStackMux) GetListenAddresses() []net.Addr {
	out := d.v4.GetListenAddresses()
	for _, a := range d.v6.GetListenAddresses() {
		ua, ok := a.(*net.UDPAddr)
		if !ok {
			continue
		}
		ip, ok := netip.AddrFromSlice(ua.IP)
		if ok && ua.IP.To4() == nil && usableHostV6(ip) {
			out = append(out, a)
		}
	}
	return out
}

// onLocalIPv6Subnet 判断一个公网 IPv6 地址是否与本机某块网卡在同一个子网，也就是同一个局域网。
// 公网 IPv6 的 host 对 host 连接可能跨着整个互联网，不能像 IPv4 内网地址那样直接当成局域网。
func onLocalIPv6Subnet(remote netip.Addr) bool {
	ifaces, err := anet.Interfaces()
	if err != nil {
		return false
	}
	for _, ifc := range ifaces {
		if ifc.Flags&net.FlagUp == 0 {
			continue
		}
		addrs, err := anet.InterfaceAddrsByInterface(&ifc)
		if err != nil {
			continue
		}
		for _, a := range addrs {
			ipn, ok := a.(*net.IPNet)
			if !ok || ipn.IP.To4() != nil {
				continue
			}
			if ipn.Contains(net.IP(remote.AsSlice())) {
				return true
			}
		}
	}
	return false
}

// publicIPv6 判断对端地址是不是公网 IPv6（而非内网、链路本地或 IPv4）。
func publicIPv6(ip netip.Addr) bool {
	return ip.Is6() && !ip.Is4In6() && ip.IsGlobalUnicast() && !ip.IsPrivate()
}
