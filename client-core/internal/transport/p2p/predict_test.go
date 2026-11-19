package p2p

import (
	"net/netip"
	"slices"
	"strings"
	"testing"
	"time"
)

func probeOf(at time.Time, ip string, ports ...int) EgressReport {
	r := EgressReport{LocalPort: 60682, At: at}
	for _, p := range ports {
		r.Egresses = append(r.Egresses, Egress{
			Addr: netip.AddrPortFrom(netip.MustParseAddr(ip), uint16(p)),
			Via:  []string{"stun"},
		})
	}
	return r
}

func ports(addrs []netip.AddrPort) []int {
	var out []int
	for _, a := range addrs {
		out = append(out, int(a.Port()))
	}
	return out
}

func span(from, n int) []int {
	var out []int
	for i := 0; i < n; i++ {
		out = append(out, from+i)
	}
	return out
}

// 端口不随目标变化（家用路由器这类好打的 NAT）时不预测。
func TestPredictSkipsEndpointIndependentNAT(t *testing.T) {
	r := probeOf(time.Now(), "203.0.113.7", 35364)
	r.Egresses[0].Via = []string{"a", "b", "c"}
	if got := predictPorts(r, EgressReport{}); got != nil {
		t.Fatalf("predicted %v for an endpoint-independent NAT", got)
	}
}

// 随身 WiFi 实测的一轮（10:35）：新映射 57288、57289、57476 挨在一起，
// 53785/53786 是一直保持着的旧映射，61220 是另一个计数器。
func TestPredictFollowsSequentialAllocation(t *testing.T) {
	now := time.Now()
	prev := probeOf(now.Add(-5*time.Minute), "198.51.100.9", 57262, 57269, 53785, 57254, 61201, 53786)
	cur := probeOf(now, "198.51.100.9", 57288, 57476, 53785, 61220, 53786, 57289)

	got := ports(predictPorts(cur, prev))
	want := append(append(span(57477, 12), span(61221, 12)...), span(53787, 8)...)
	if !slices.Equal(got, want) {
		t.Fatalf("predicted %v\nwant      %v", got, want)
	}
}

// 计数到 65535 后回到低位：22:20 那一轮的新映射是 2969、2970。
func TestPredictAfterCounterWraps(t *testing.T) {
	now := time.Now()
	prev := probeOf(now.Add(-30*time.Minute), "198.51.100.9", 64199, 59739, 59741, 64198)
	cur := probeOf(now, "198.51.100.9", 2969, 2970, 59739, 64198, 59741)
	got := ports(predictPorts(cur, prev))
	if !slices.Equal(got[:12], span(2971, 12)) {
		t.Fatalf("predicted %v, want the window after 2970 first", got)
	}
}

// 一段连续分配跨过 65535 时合成一段，从回绕后最新的端口往后预测。
func TestPredictWindowSpansWraparound(t *testing.T) {
	cur := probeOf(time.Now(), "198.51.100.9", 65530, 65533, 1025, 1026)
	got := ports(predictPorts(cur, EgressReport{}))
	if !slices.Equal(got, span(1027, 12)) {
		t.Fatalf("predicted %v, want 1027–1038", got)
	}
	if nextNATPort(65535) != natPortFloor {
		t.Fatal("port counter does not wrap")
	}
}

// 预测的端口不与已知映射重复，总数有上限。
func TestPredictSkipsKnownMappingsAndCaps(t *testing.T) {
	cur := probeOf(time.Now(), "198.51.100.9", 1000+0, 1002, 9000, 9001, 20000, 20001, 30000, 30001)
	got := predictPorts(cur, EgressReport{})
	if len(got) != maxPredictAdvertise {
		t.Fatalf("predicted %d addresses, want the cap %d", len(got), maxPredictAdvertise)
	}
	for _, a := range got {
		for _, e := range cur.Egresses {
			if a == e.Addr {
				t.Fatalf("predicted a known mapping %v", a)
			}
		}
	}
}

// 预测地址排在实测地址之后、单独计数，优先级最低。
func TestSrflxCandidatesAppendPredictions(t *testing.T) {
	r := probeOf(time.Now(), "198.51.100.9", 57288, 57289)
	r.Predicted = predictPorts(r, EgressReport{})
	cands := srflxCandidates(r)
	if len(cands) != 2+predictSpan {
		t.Fatalf("got %d candidates, want %d", len(cands), 2+predictSpan)
	}
	if !strings.Contains(cands[0], " 57288 typ srflx") || !strings.Contains(cands[2], " 57290 typ srflx") {
		t.Fatalf("unexpected order:\n%s", strings.Join(cands, "\n"))
	}
	if got := predictedSummary(r.Predicted); len(got) != 1 || got[0] != "198.51.100.9:57290-57301" {
		t.Fatalf("summary = %v", got)
	}
}
