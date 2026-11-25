package main

import (
	"encoding/binary"
	"flag"
	"fmt"
	"net"
	"net/netip"
	"os"
	"os/exec"
	"strconv"
)

// natpmp 在路由器的命名空间里扮演支持 NAT-PMP 的家用路由器：收到映射请求就用 iptables
// 把外网端口转发给请求的设备，并放行外网主动发来的包（路由器的防火墙本来会丢掉它们）。
//
//	natlab natpmp -lan 192.168.10.1 -wan-ip 10.255.0.11 [-report 100.64.0.11]
//
// 外网端口故意与内部端口不同（加 10000），确认客户端发给对端的是映射到的端口。
// -report 让路由器报告另一个外网地址，模拟「外面还有一层运营商 NAT」的路由器。
// PCP 请求一律回「版本不支持」，客户端随即改用 NAT-PMP。
func runNATPMP(args []string) error {
	fs := flag.NewFlagSet("natpmp", flag.ExitOnError)
	lan := fs.String("lan", "", "路由器的内网地址，在它的 5351 端口上应答")
	wanIP := fs.String("wan-ip", "", "路由器的外网地址，映射建在它上面")
	report := fs.String("report", "", "报告给客户端的外网地址，默认同 -wan-ip")
	_ = fs.Parse(args)
	wan, err := netip.ParseAddr(*wanIP)
	if err != nil {
		return fmt.Errorf("-wan-ip: %w", err)
	}
	reported := wan
	if *report != "" {
		if reported, err = netip.ParseAddr(*report); err != nil {
			return fmt.Errorf("-report: %w", err)
		}
	}
	conn, err := net.ListenUDP("udp4", &net.UDPAddr{IP: net.ParseIP(*lan), Port: 5351})
	if err != nil {
		return err
	}
	defer conn.Close()

	buf := make([]byte, 1100)
	for {
		n, from, err := conn.ReadFromUDP(buf)
		if err != nil {
			return err
		}
		req := buf[:n]
		if n < 2 {
			continue
		}
		var resp []byte
		switch {
		case req[0] == 2: // PCP：不支持
			resp = []byte{0, 0x80 | req[1], 0, 1, 0, 0, 0, 0}
		case req[0] == 0 && req[1] == 0: // 查询外网地址
			resp = make([]byte, 12)
			resp[1] = 0x80
			ip := reported.As4()
			copy(resp[8:12], ip[:])
		case req[0] == 0 && req[1] == 1 && n >= 12: // 映射 UDP 端口
			internal := binary.BigEndian.Uint16(req[4:6])
			lifetime := binary.BigEndian.Uint32(req[8:12])
			external := internal + 10000
			if internal > 55535 {
				external = internal - 10000
			}
			client := from.IP.String()
			rules := mappingRules(wan.String(), external, client, internal)
			for _, r := range rules {
				if lifetime == 0 {
					_ = iptables(append([]string{"-D"}, r...)...)
				} else if iptables(append([]string{"-C"}, r...)...) != nil {
					if err := iptables(append([]string{"-I"}, r...)...); err != nil {
						fmt.Fprintln(os.Stderr, "natpmp: iptables:", err)
					}
				}
			}
			fmt.Fprintf(os.Stderr, "natpmp: %s:%d <- %s:%d 时长 %d\n", client, internal, wan, external, lifetime)
			resp = make([]byte, 16)
			resp[1] = 0x80 | 1
			binary.BigEndian.PutUint16(resp[8:10], internal)
			if lifetime != 0 {
				binary.BigEndian.PutUint16(resp[10:12], external)
			}
			binary.BigEndian.PutUint32(resp[12:16], lifetime)
		default:
			continue
		}
		_, _ = conn.WriteToUDP(resp, from)
	}
}

// mappingRules 是一条映射对应的两条规则（不含 -I/-D）：把外网端口转给设备，并在路由器
// 丢弃外来新连接的规则之前放行它。
func mappingRules(wan string, external uint16, client string, internal uint16) [][]string {
	return [][]string{
		{"PREROUTING", "-t", "nat", "-i", "wan", "-p", "udp", "-d", wan, "--dport", strconv.Itoa(int(external)),
			"-j", "DNAT", "--to-destination", client + ":" + strconv.Itoa(int(internal))},
		{"FORWARD", "-i", "wan", "-p", "udp", "-d", client, "--dport", strconv.Itoa(int(internal)), "-j", "ACCEPT"},
	}
}

func iptables(args ...string) error {
	// -t nat 要放在链名前面：把 [链, -t, nat, ...] 调成 [-t, nat, 操作, 链, ...]
	if len(args) >= 4 && args[2] == "-t" {
		args = append([]string{args[2], args[3], args[0], args[1]}, args[4:]...)
	}
	out, err := exec.Command("iptables", args...).CombinedOutput()
	if err != nil {
		return fmt.Errorf("%v: %s", err, out)
	}
	return nil
}
