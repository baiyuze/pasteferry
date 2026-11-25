package portmap

import (
	"bufio"
	"encoding/binary"
	"encoding/hex"
	"net/netip"
	"os"
	"strings"
)

// systemGateways 从 /proc/net/route 里找默认路由的网关。Android 10 起应用读不了这个文件，
// 那时返回空，由 guessedGateways 补上。
func systemGateways() []netip.Addr {
	f, err := os.Open("/proc/net/route")
	if err != nil {
		return nil
	}
	defer f.Close()
	return parseProcRoute(bufio.NewScanner(f))
}

// parseProcRoute 解析 /proc/net/route：列依次是网卡、目标、网关……，地址是小端序的十六进制。
func parseProcRoute(sc *bufio.Scanner) []netip.Addr {
	var out []netip.Addr
	sc.Scan() // 表头
	for sc.Scan() {
		f := strings.Fields(sc.Text())
		if len(f) < 8 || f[1] != "00000000" || f[7] != "00000000" {
			continue
		}
		raw, err := hex.DecodeString(f[2])
		if err != nil || len(raw) != 4 {
			continue
		}
		var ip [4]byte
		binary.BigEndian.PutUint32(ip[:], binary.LittleEndian.Uint32(raw))
		if a := netip.AddrFrom4(ip); !a.IsUnspecified() {
			out = append(out, a)
		}
	}
	return out
}
