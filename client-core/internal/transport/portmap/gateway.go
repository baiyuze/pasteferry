package portmap

import (
	"net"
	"net/netip"

	"github.com/wlynxg/anet"
)

// guessedGateways 是各块网卡所在内网网段的第一个地址（例如 192.168.31.0/24 的 .1）。
// 家用路由器几乎都在那里；系统路由表读不到时（Android 10 起读不了 /proc/net/route）靠它。
func guessedGateways() []netip.Addr {
	// Android 11 起标准库读不到网卡列表，anet 在那里改用 netlink
	ifaces, err := anet.Interfaces()
	if err != nil {
		return nil
	}
	var out []netip.Addr
	for _, ifc := range ifaces {
		if ifc.Flags&net.FlagUp == 0 || ifc.Flags&net.FlagLoopback != 0 {
			continue
		}
		addrs, err := anet.InterfaceAddrsByInterface(&ifc)
		if err != nil {
			continue
		}
		for _, a := range addrs {
			ipn, ok := a.(*net.IPNet)
			if !ok || ipn.IP.To4() == nil {
				continue
			}
			ip, _ := netip.AddrFromSlice(ipn.IP.To4())
			ones, _ := ipn.Mask.Size()
			if !ip.IsPrivate() || ones < 8 || ones > 30 {
				continue
			}
			prefix := netip.PrefixFrom(ip, ones).Masked()
			if first := prefix.Addr().Next(); first != ip {
				out = append(out, first)
			}
		}
	}
	return out
}
