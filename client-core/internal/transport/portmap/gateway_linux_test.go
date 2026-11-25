package portmap

import (
	"bufio"
	"strings"
	"testing"
)

func TestParseProcRoute(t *testing.T) {
	const table = `Iface	Destination	Gateway 	Flags	RefCnt	Use	Metric	Mask		MTU	Window	IRTT
eth0	00000000	0101A8C0	0003	0	0	100	00000000	0	0	0
eth0	0001A8C0	00000000	0001	0	0	100	00FFFFFF	0	0	0
wlan0	00000000	011FA8C0	0003	0	0	600	00000000	0	0	0
`
	got := parseProcRoute(bufio.NewScanner(strings.NewReader(table)))
	if len(got) != 2 || got[0].String() != "192.168.1.1" || got[1].String() != "192.168.31.1" {
		t.Fatalf("网关 = %v，期望 192.168.1.1 与 192.168.31.1", got)
	}
}
