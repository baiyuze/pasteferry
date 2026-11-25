package p2p

import (
	"context"
	"errors"
	"net"
	"net/netip"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/pion/ice/v4"
	"github.com/pion/stun/v4"
)

// fakeProber 按服务器地址返回预设的公网映射，模拟「按目标 IP 选出口」的网络。
type fakeProber map[string]string // 服务器 ip:port -> 本机公网 ip:port

func (f fakeProber) GetXORMappedAddr(addr net.Addr, _ time.Duration) (*stun.XORMappedAddress, error) {
	mapped, ok := f[addr.String()]
	if !ok {
		return nil, errors.New("超时")
	}
	ap := netip.MustParseAddrPort(mapped)
	return &stun.XORMappedAddress{IP: ap.Addr().AsSlice(), Port: int(ap.Port())}, nil
}

func TestParseProbeServer(t *testing.T) {
	cases := []struct {
		in   string
		host string
		port uint16
	}{
		{"stun:stun.l.google.com:19302", "stun.l.google.com", 19302},
		{"stun:101.6.6.6:3478", "101.6.6.6", 3478},
		{"stun.cloudflare.com:3478", "stun.cloudflare.com", 3478},
		{"stun:example.com", "example.com", 3478},
		{"stun:example.com:3478?transport=udp", "example.com", 3478},
	}
	for _, c := range cases {
		host, port, err := parseProbeServer(c.in)
		if err != nil || host != c.host || port != c.port {
			t.Errorf("parseProbeServer(%q) = %q, %d, %v；期望 %q, %d", c.in, host, port, err, c.host, c.port)
		}
	}
}

func TestUsableProbeIP(t *testing.T) {
	cases := []struct {
		ip           string
		allowPrivate bool
		want         bool
	}{
		{"101.6.6.6", false, true},
		{"162.159.207.0", false, true},
		{"192.0.2.42", false, false}, // 实测 stun.syncthing.net 被 DNS 污染到这里
		{"198.18.3.7", false, false}, // 代理软件 fake-ip 的默认网段
		{"100.64.1.1", false, false}, // 运营商 NAT 内部地址
		{"0.0.0.0", false, false},
		{"10.1.2.3", false, false},
		{"10.1.2.3", true, true}, // 实验环境允许内网
		{"127.0.0.1", false, false},
		{"127.0.0.1", true, true},
	}
	for _, c := range cases {
		if got := usableProbeIP(netip.MustParseAddr(c.ip), c.allowPrivate); got != c.want {
			t.Errorf("usableProbeIP(%s, allowPrivate=%v) = %v，期望 %v", c.ip, c.allowPrivate, got, c.want)
		}
	}
}

// 公司网络的情形：不同的服务器落在不同出口上，同一出口被多台服务器看到。
func TestProbeEgressMergesByMappedAddress(t *testing.T) {
	prober := fakeProber{
		"1.1.1.1:3478": "9.9.9.1:5000", // 出口 1，不改端口
		"2.2.2.2:3478": "9.9.9.2:6000", // 出口 2，改端口
		"3.3.3.3:3478": "9.9.9.2:6000", // 也走出口 2：同一线路上映射固定
		// 4.4.4.4 不响应
	}
	servers := []string{
		"stun:1.1.1.1:3478", "2.2.2.2:3478", "3.3.3.3:3478", "4.4.4.4:3478",
		"1.1.1.1:19302",   // 与第一个同 IP：出口只按 IP 选，不该重复探测
		"192.0.2.42:3478", // 被污染的地址：直接丢弃
	}
	r := probeEgress(context.Background(), prober, 5000, servers, probeOptions{})

	if r.Probed != 4 || r.Answered != 3 {
		t.Fatalf("探测 %d 个、响应 %d 个，期望 4 与 3", r.Probed, r.Answered)
	}
	if len(r.Egresses) != 2 {
		t.Fatalf("出口数 = %d，期望 2：%+v", len(r.Egresses), r.Egresses)
	}
	// 被更多服务器看到的出口排在前面
	if e := r.Egresses[0]; e.Addr.String() != "9.9.9.2:6000" || len(e.Via) != 2 || e.PortPreserved {
		t.Errorf("第一个出口 = %+v，期望 9.9.9.2:6000、2 个来源、改端口", e)
	}
	if e := r.Egresses[1]; e.Addr.String() != "9.9.9.1:5000" || !e.PortPreserved {
		t.Errorf("第二个出口 = %+v，期望 9.9.9.1:5000、不改端口", e)
	}
}

func TestSrflxCandidatesAreValidAndOrdered(t *testing.T) {
	r := EgressReport{LocalPort: 5000}
	for i := 0; i < 10; i++ {
		r.Egresses = append(r.Egresses, Egress{
			Addr: netip.AddrPortFrom(netip.AddrFrom4([4]byte{9, 9, 9, byte(i + 1)}), 5000),
			Via:  []string{"stun"},
		})
	}
	// 推算的地址排在实测之后；与实测重复的不再发
	r.Egresses = append([]Egress{{Addr: netip.MustParseAddrPort("8.8.8.8:5000"), PortPreserved: true}}, r.Egresses...)

	cands := srflxCandidates(r)
	if len(cands) != maxSrflxAdvertise {
		t.Fatalf("候选数 = %d，应截断到 %d", len(cands), maxSrflxAdvertise)
	}
	var last uint32 = 1<<32 - 1
	for i, s := range cands {
		c, err := ice.UnmarshalCandidate(s)
		if err != nil {
			t.Fatalf("pion 解析不了第 %d 个候选 %q: %v", i, s, err)
		}
		if c.Type() != ice.CandidateTypeServerReflexive {
			t.Errorf("第 %d 个候选类型 = %v，应为 srflx", i, c.Type())
		}
		if c.Priority() > last {
			t.Errorf("候选 %d 的优先级高于前一个：实测地址应排在前面", i)
		}
		last = c.Priority()
		if c.Address() == "8.8.8.8" {
			t.Errorf("推算的地址挤掉了实测地址：%q", s)
		}
	}
}

func TestHistoryFillsInMissedPreservedEgress(t *testing.T) {
	path := filepath.Join(t.TempDir(), "egress.json")
	now := time.Date(2026, 10, 8, 12, 0, 0, 0, time.UTC)

	h := loadEgressHistory(path)
	h.now = func() time.Time { return now }
	h.record("office", EgressReport{LocalPort: 5000, Egresses: []Egress{
		{Addr: netip.MustParseAddrPort("9.9.9.1:5000"), PortPreserved: true, Via: []string{"a"}},
		{Addr: netip.MustParseAddrPort("9.9.9.2:6000"), Via: []string{"b"}},
	}})

	// 重新加载：历史要能持久化
	h = loadEgressHistory(path)
	h.now = func() time.Time { return now.Add(time.Hour) }

	// 新一轮换了本地端口，且只探测到出口 2
	got := h.augment("office", EgressReport{LocalPort: 7000, Egresses: []Egress{
		{Addr: netip.MustParseAddrPort("9.9.9.2:6100"), Via: []string{"b"}},
	}})
	if len(got.Egresses) != 2 {
		t.Fatalf("出口数 = %d，期望补上不改端口的出口 1：%+v", len(got.Egresses), got.Egresses)
	}
	if g := got.Egresses[1]; g.Addr.String() != "9.9.9.1:7000" || !g.Guessed() {
		t.Errorf("补上的出口 = %+v，期望 9.9.9.1:7000（出口 IP + 新的本地端口）", g)
	}

	// 别的网络不受影响；过期的历史不再使用
	if other := h.augment("home", EgressReport{LocalPort: 7000}); len(other.Egresses) != 0 {
		t.Errorf("其他网络不该用这份历史：%+v", other.Egresses)
	}
	h.now = func() time.Time { return now.Add(historyTTL + time.Hour) }
	if stale := h.augment("office", EgressReport{LocalPort: 7000}); len(stale.Egresses) != 0 {
		t.Errorf("过期的历史不该再用：%+v", stale.Egresses)
	}
}

// 同一个域名的几个 IP 要都探测：按目标 IP 分线路的路由器会把它们分到不同线路上。
// 先排每个域名的第一个 IP，再排历史里记下的服务器，最后轮流取其余的 IP，总数有上限。
func TestResolveProbeTargetsUsesEveryAddress(t *testing.T) {
	dns := map[string][]netip.Addr{
		"multi.example":  {netip.MustParseAddr("1.0.0.1"), netip.MustParseAddr("1.0.0.2"), netip.MustParseAddr("1.0.0.3")},
		"single.example": {netip.MustParseAddr("2.0.0.1"), netip.MustParseAddr("1.0.0.2")},    // 与上面重复的 IP 只探一次
		"bogus.example":  {netip.MustParseAddr("198.18.0.5"), netip.MustParseAddr("2.0.0.2")}, // 先是 fake-ip，跳过它取下一个
	}
	opts := probeOptions{
		Lookup: func(_ context.Context, host string) ([]netip.Addr, error) {
			if ips, ok := dns[host]; ok {
				return ips, nil
			}
			return nil, errors.New("no such host")
		},
		Pinned: []probeTarget{
			{name: "pinned.example", addr: netip.MustParseAddrPort("4.0.0.1:3478")},
			{name: "multi.example", addr: netip.MustParseAddrPort("1.0.0.3:3478")}, // 已在名单里：提前，不重复
		},
	}
	got := resolveProbeTargets(context.Background(),
		[]string{"multi.example:3478", "single.example", "3.0.0.1:19302", "bogus.example", "missing.example"}, opts)
	var addrs []string
	for _, tg := range got {
		addrs = append(addrs, tg.name+"="+tg.addr.String())
	}
	want := []string{
		"multi.example=1.0.0.1:3478", "single.example=2.0.0.1:3478", "3.0.0.1=3.0.0.1:19302", "bogus.example=2.0.0.2:3478",
		"pinned.example=4.0.0.1:3478", "multi.example=1.0.0.3:3478",
		"multi.example=1.0.0.2:3478",
	}
	if strings.Join(addrs, " ") != strings.Join(want, " ") {
		t.Fatalf("探测目标 =\n  %v\n期望\n  %v", addrs, want)
	}

	// 一个域名有很多 IP 时总数截断
	var many []netip.Addr
	for i := 1; i <= 40; i++ {
		many = append(many, netip.AddrFrom4([4]byte{5, 0, 0, byte(i)}))
	}
	dns["many.example"] = many
	if got := resolveProbeTargets(context.Background(), []string{"many.example"}, opts); len(got) != maxProbeTargets {
		t.Fatalf("探测目标 %d 个，应截断到 %d", len(got), maxProbeTargets)
	}
}

// 同一个域名的两个 IP 看到同一个出口：来源域名只记一次，两个 IP 都记下，供出口历史使用。
func TestProbeEgressRecordsTargets(t *testing.T) {
	prober := fakeProber{"1.0.0.1:3478": "9.9.9.1:6000", "1.0.0.2:3478": "9.9.9.1:6000", "2.0.0.1:3478": "9.9.9.2:5000"}
	opts := probeOptions{Lookup: func(context.Context, string) ([]netip.Addr, error) {
		return []netip.Addr{netip.MustParseAddr("1.0.0.1"), netip.MustParseAddr("1.0.0.2")}, nil
	}}
	r := probeEgress(context.Background(), prober, 5000, []string{"stun.example", "2.0.0.1"}, opts)
	if len(r.Egresses) != 2 {
		t.Fatalf("出口 = %+v", r.Egresses)
	}
	e := r.Egresses[0]
	if e.Addr.String() != "9.9.9.1:6000" || len(e.Via) != 1 || e.Via[0] != "stun.example" || len(e.Targets) != 2 {
		t.Fatalf("第一个出口 = %+v，期望 9.9.9.1:6000、来源 stun.example 一个、两个服务器 IP", e)
	}
}

// 出口历史记住每条线路上的探测服务器（最新的在前，每条最多 3 台），以后每轮都探测它们；
// 按线路轮流排，过期的线路不再带。用户只允许用自己的服务器时由 Manager 决定不带。
func TestHistoryPinsServersPerLine(t *testing.T) {
	path := filepath.Join(t.TempDir(), "egress.json")
	now := time.Date(2026, 11, 26, 0, 0, 0, 0, time.UTC)
	h := loadEgressHistory(path)
	h.now = func() time.Time { return now }
	target := func(name, addr string) probeTarget {
		return probeTarget{name: name, addr: netip.MustParseAddrPort(addr)}
	}
	h.record("office", EgressReport{LocalPort: 5000, Egresses: []Egress{
		{Addr: netip.MustParseAddrPort("9.9.9.1:5000"), PortPreserved: true, Via: []string{"a"},
			Targets: []probeTarget{target("a", "1.0.0.1:3478"), target("a", "1.0.0.2:3478")}},
		{Addr: netip.MustParseAddrPort("9.9.9.2:6000"), Via: []string{"b"},
			Targets: []probeTarget{target("b", "2.0.0.1:3478")}},
	}})
	// 下一轮出口 1 又被另外两台服务器看到：新的排前面，最多留 3 台
	now = now.Add(time.Hour)
	h.record("office", EgressReport{LocalPort: 5000, Egresses: []Egress{
		{Addr: netip.MustParseAddrPort("9.9.9.1:5000"), PortPreserved: true, Via: []string{"c"},
			Targets: []probeTarget{target("c", "3.0.0.1:3478"), target("c", "3.0.0.2:3478")}},
	}})

	h = loadEgressHistory(path) // 要能持久化
	h.now = func() time.Time { return now }
	var got []string
	for _, tg := range h.pinned("office") {
		got = append(got, tg.name+"="+tg.addr.String())
	}
	want := "c=3.0.0.1:3478 b=2.0.0.1:3478 c=3.0.0.2:3478 a=1.0.0.1:3478"
	if strings.Join(got, " ") != want {
		t.Fatalf("记下的服务器 = %v\n期望 %s", got, want)
	}
	if other := h.pinned("home"); len(other) != 0 {
		t.Errorf("别的网络不该带这些服务器：%v", other)
	}
	h.now = func() time.Time { return now.Add(historyTTL) }
	if stale := h.pinned("office"); len(stale) != 0 {
		t.Errorf("过期的线路不该再带：%v", stale)
	}
}

// 握手前要不要重新探测：只有改端口的线路或端口预测会过时。
func TestNeedsFreshProbe(t *testing.T) {
	preserved := Egress{Addr: netip.MustParseAddrPort("9.9.9.1:5000"), PortPreserved: true, Via: []string{"a"}}
	translated := Egress{Addr: netip.MustParseAddrPort("9.9.9.2:6000"), Via: []string{"b"}}
	guessed := Egress{Addr: netip.MustParseAddrPort("9.9.9.3:5000"), PortPreserved: true}
	cases := []struct {
		name string
		r    EgressReport
		want bool
	}{
		{"没有出口", EgressReport{}, false},
		{"只有不改端口的", EgressReport{Egresses: []Egress{preserved, guessed}}, false},
		{"有改端口的", EgressReport{Egresses: []Egress{preserved, translated}}, true},
		{"有端口预测", EgressReport{Egresses: []Egress{preserved}, Predicted: []netip.AddrPort{netip.MustParseAddrPort("9.9.9.1:5001")}}, true},
	}
	for _, c := range cases {
		if got := c.r.needsFreshProbe(); got != c.want {
			t.Errorf("%s：needsFreshProbe = %v，期望 %v", c.name, got, c.want)
		}
	}
}
