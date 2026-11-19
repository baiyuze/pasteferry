package p2p

import (
	"context"
	"errors"
	"net"
	"net/netip"
	"strings"
	"testing"
	"time"

	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

type fakeMux struct {
	addrs []net.Addr
	got   []string
}

func (f *fakeMux) Close() error { return nil }
func (f *fakeMux) GetConn(ufrag string, addr net.Addr) (net.PacketConn, error) {
	f.got = append(f.got, addr.String())
	return nil, errors.New("fake")
}
func (f *fakeMux) RemoveConnByUfrag(string)        {}
func (f *fakeMux) GetListenAddresses() []net.Addr { return f.addrs }

func udp(s string) *net.UDPAddr {
	a := netip.MustParseAddrPort(s)
	return net.UDPAddrFromAddrPort(a)
}

// IPv6 端口只贡献公网 IPv6 地址；IPv4 端口的地址原样保留。
func TestDualStackMuxAdvertisesOnlyPublicIPv6(t *testing.T) {
	v4 := &fakeMux{addrs: []net.Addr{udp("192.168.1.147:54145"), udp("127.0.0.1:54145")}}
	v6 := &fakeMux{addrs: []net.Addr{
		udp("192.168.1.147:54145"),            // pion 在 [::] 上也会列出 IPv4 地址
		udp("[fe80::1]:54145"),                // 链路本地
		udp("[::1]:54145"),                    // 回环
		udp("[fd12:3456::1]:54145"),           // ULA
		udp("[2408:8207:1234:5678::9]:54145"), // 公网
	}}
	d := &dualStackMux{v4: v4, v6: v6}
	var got []string
	for _, a := range d.GetListenAddresses() {
		got = append(got, a.String())
	}
	want := "192.168.1.147:54145 127.0.0.1:54145 [2408:8207:1234:5678::9]:54145"
	if strings.Join(got, " ") != want {
		t.Fatalf("addresses = %v\nwant        %s", got, want)
	}

	_, _ = d.GetConn("u", udp("[2408:8207:1234:5678::9]:54145"))
	_, _ = d.GetConn("u", udp("192.168.1.147:54145"))
	if len(v6.got) != 1 || len(v4.got) != 1 {
		t.Fatalf("GetConn routed v4=%v v6=%v", v4.got, v6.got)
	}
}

func TestPublicIPv6(t *testing.T) {
	for addr, want := range map[string]bool{
		"2408:8207:1234::9": true,
		"240e:3b0::1":       true,
		"fd00::1":           false,
		"fe80::1":           false,
		"::1":               false,
		"192.168.1.2":       false,
		"::ffff:1.2.3.4":    false,
	} {
		if got := publicIPv6(netip.MustParseAddr(addr)); got != want {
			t.Errorf("publicIPv6(%s) = %v, want %v", addr, got, want)
		}
	}
}

func isIPv4Candidate(c string) bool {
	f := strings.Fields(strings.TrimPrefix(strings.TrimSpace(c), "a="))
	if len(f) < 5 {
		return false
	}
	ip, err := netip.ParseAddr(f[4])
	return err == nil && ip.Is4()
}

func stripIPv4Candidates(sdp string) string {
	var keep []string
	for _, line := range strings.Split(sdp, "\n") {
		if strings.HasPrefix(strings.TrimSpace(line), "a=candidate:") && isIPv4Candidate(line) {
			continue
		}
		keep = append(keep, line)
	}
	return strings.Join(keep, "\n")
}

// 只留 IPv6 地址也能直连：验证 IPv6 端口确实接进了 pion，收发都走它。
// 正式运行时只用公网 IPv6；测试机未必有，这里把本机的 ULA（如虚拟机网桥上的 fd00::/8）也算作可用。
// pion 不列出回环 ::1，本机连 ULA 也没有时跳过。
func TestDirectConnectionOverIPv6Only(t *testing.T) {
	old := usableHostV6
	usableHostV6 = func(ip netip.Addr) bool {
		return ip.Is6() && !ip.Is4In6() && !ip.IsLoopback() && !ip.IsLinkLocalUnicast() && (ip.IsGlobalUnicast() || ip.IsPrivate())
	}
	t.Cleanup(func() { usableHostV6 = old })

	var a, b *Manager
	deliver := func(from string, target **Manager) func(context.Context, string, *pb.SignalMessage) error {
		return func(_ context.Context, _ string, msg *pb.SignalMessage) error {
			if c := msg.GetCandidate(); c != nil && isIPv4Candidate(c.GetCandidate()) {
				return nil
			}
			if o := msg.GetOffer(); o != nil {
				o.Sdp = stripIPv4Candidates(o.Sdp)
			}
			if an := msg.GetAnswer(); an != nil {
				an.Sdp = stripIPv4Candidates(an.Sdp)
			}
			go func() { _ = (*target).HandleSignal(context.Background(), from, msg) }()
			return nil
		}
	}
	a = NewManager(ManagerOptions{SelfID: "alice", SendSignal: deliver("alice", &b)})
	b = NewManager(ManagerOptions{SelfID: "bob", SendSignal: deliver("bob", &a)})
	t.Cleanup(a.Close)
	t.Cleanup(b.Close)
	if a.mux6 == nil {
		t.Skip("没能打开 IPv6 打洞端口")
	}
	hasV6 := false
	for _, addr := range a.iceMux.GetListenAddresses() {
		if ua := addr.(*net.UDPAddr); ua.IP.To4() == nil {
			hasV6 = true
		}
	}
	if !hasV6 {
		t.Skip("本机没有可用的 IPv6 地址")
	}

	if err := a.Connect(context.Background(), "bob"); err != nil {
		t.Fatal(err)
	}
	deadline := time.Now().Add(15 * time.Second)
	for a.State("bob") != StateDirect || b.State("alice") != StateDirect {
		if time.Now().After(deadline) {
			t.Fatalf("states %v/%v, want direct over IPv6", a.State("bob"), b.State("alice"))
		}
		time.Sleep(20 * time.Millisecond)
	}
	a.mu.RLock()
	pc := a.peers["bob"].pc
	a.mu.RUnlock()
	pair, err := pc.SCTP().Transport().ICETransport().GetSelectedCandidatePair()
	if err != nil || pair == nil {
		t.Fatalf("no selected pair: %v", err)
	}
	for _, addr := range []string{pair.Local.Address, pair.Remote.Address} {
		if ip, err := netip.ParseAddr(addr); err != nil || !ip.Is6() {
			t.Fatalf("selected pair %s <-> %s, want IPv6 on both ends", pair.Local.Address, pair.Remote.Address)
		}
	}
}
