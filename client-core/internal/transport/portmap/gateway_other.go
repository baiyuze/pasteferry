//go:build !darwin && !linux && !windows

package portmap

import "net/netip"

func systemGateways() []netip.Addr { return nil }
