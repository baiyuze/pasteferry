package portmap

import (
	"net/netip"
	"syscall"
	"unsafe"

	"golang.org/x/sys/windows"
)

// systemGateways 从各块网卡的配置里取 IPv4 默认网关（GetAdaptersAddresses）。
func systemGateways() []netip.Addr {
	const flags = windows.GAA_FLAG_INCLUDE_GATEWAYS | windows.GAA_FLAG_SKIP_ANYCAST |
		windows.GAA_FLAG_SKIP_MULTICAST | windows.GAA_FLAG_SKIP_DNS_SERVER
	size := uint32(15 << 10)
	var buf []byte
	for range 3 {
		buf = make([]byte, size)
		err := windows.GetAdaptersAddresses(windows.AF_INET, flags, 0,
			(*windows.IpAdapterAddresses)(unsafe.Pointer(&buf[0])), &size)
		if err == nil {
			break
		}
		if err != windows.ERROR_BUFFER_OVERFLOW {
			return nil
		}
		buf = nil
	}
	if buf == nil {
		return nil
	}
	var out []netip.Addr
	for a := (*windows.IpAdapterAddresses)(unsafe.Pointer(&buf[0])); a != nil; a = a.Next {
		if a.OperStatus != windows.IfOperStatusUp {
			continue
		}
		for g := a.FirstGatewayAddress; g != nil; g = g.Next {
			sa, err := g.Address.Sockaddr.Sockaddr()
			if err != nil {
				continue
			}
			if v4, ok := sa.(*syscall.SockaddrInet4); ok {
				out = append(out, netip.AddrFrom4(v4.Addr))
			}
		}
	}
	return out
}
