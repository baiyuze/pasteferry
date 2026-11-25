package portmap

import (
	"net/netip"
	"syscall"

	"golang.org/x/net/route"
)

// systemGateways 从路由表里找默认路由（目标与掩码都是 0.0.0.0）的 IPv4 网关。
func systemGateways() []netip.Addr {
	rib, err := route.FetchRIB(syscall.AF_INET, route.RIBTypeRoute, 0)
	if err != nil {
		return nil
	}
	msgs, err := route.ParseRIB(route.RIBTypeRoute, rib)
	if err != nil {
		return nil
	}
	var out []netip.Addr
	for _, m := range msgs {
		rm, ok := m.(*route.RouteMessage)
		if !ok || rm.Flags&syscall.RTF_GATEWAY == 0 || len(rm.Addrs) <= syscall.RTAX_NETMASK {
			continue
		}
		dst, ok := rm.Addrs[syscall.RTAX_DST].(*route.Inet4Addr)
		if !ok || dst.IP != [4]byte{} {
			continue
		}
		if mask, ok := rm.Addrs[syscall.RTAX_NETMASK].(*route.Inet4Addr); ok && mask.IP != [4]byte{} {
			continue
		}
		if gw, ok := rm.Addrs[syscall.RTAX_GATEWAY].(*route.Inet4Addr); ok {
			out = append(out, netip.AddrFrom4(gw.IP))
		}
	}
	return out
}
