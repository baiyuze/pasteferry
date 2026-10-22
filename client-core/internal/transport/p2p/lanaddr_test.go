package p2p

import (
	"net"
	"testing"
)

// 本机两端直连（host 对 host）：LANAddr 给出一个能在上面监听的本机地址。
// CI 的机器上两端经回环地址连，这时给的也是回环地址
func TestLANAddrOnDirectConnection(t *testing.T) {
	alice, bob := connectPair(t)
	for _, c := range []struct {
		n    *testNode
		peer string
	}{{alice, "bob"}, {bob, "alice"}} {
		addr, ok := c.n.m.LANAddr(c.peer)
		if !ok {
			t.Fatalf("对 %s 应当是局域网直连", c.peer)
		}
		if addr.IsUnspecified() {
			t.Fatalf("地址不能是 %v", addr)
		}
		ln, err := net.Listen("tcp", net.JoinHostPort(addr.String(), "0"))
		if err != nil {
			t.Fatalf("在 %v 上监听: %v", addr, err)
		}
		ln.Close()
	}
	if _, ok := alice.m.LANAddr("nobody"); ok {
		t.Fatal("没有连接的设备不该有地址")
	}
}
