package p2p

import (
	"net/netip"
	"testing"

	"github.com/pion/ice/v4"
)

// 端口映射得到的地址排在出口最前面、优先级最高；换了映射替换旧的，与实测地址重复时不加，
// 撤销映射时移除。它不算探测到的线路：不让报告看起来像对称型 NAT，也不触发握手前重探。
func TestWithMappedEgress(t *testing.T) {
	measured := Egress{Addr: netip.MustParseAddrPort("8.8.4.4:15470"), Via: []string{"stun"}}
	r := EgressReport{LocalPort: 62653, Egresses: []Egress{measured}}
	mapped := &Egress{Addr: netip.MustParseAddrPort("8.8.4.4:62653"), PortPreserved: true, Via: []string{"UPnP"}, Mapped: true}

	r = withMapped(r, mapped)
	if len(r.Egresses) != 2 || !r.Egresses[0].Mapped {
		t.Fatalf("出口 = %+v，映射地址应排第一", r.Egresses)
	}
	if r.Symmetric() {
		t.Error("同一 IP 的映射端口与实测端口不同，不该据此判为对称型 NAT")
	}
	if (EgressReport{Egresses: []Egress{*mapped}}).needsFreshProbe() {
		t.Error("只有映射地址时不该在握手前重探")
	}

	cands := srflxCandidates(r)
	c, err := ice.UnmarshalCandidate(cands[0])
	if err != nil || c.Port() != 62653 {
		t.Fatalf("第一个候选应是映射地址：%q %v", cands[0], err)
	}
	second, _ := ice.UnmarshalCandidate(cands[1])
	if c.Priority() <= second.Priority() {
		t.Error("映射地址的优先级应高于实测地址")
	}

	// 换一个映射：替换而不是并存
	other := &Egress{Addr: netip.MustParseAddrPort("8.8.4.4:40000"), Via: []string{"PCP"}, Mapped: true}
	r = withMapped(r, other)
	if len(r.Egresses) != 2 || r.Egresses[0].Addr != other.Addr {
		t.Fatalf("换映射后出口 = %+v", r.Egresses)
	}
	// 与实测地址相同：不重复
	if got := withMapped(r, &Egress{Addr: measured.Addr, Via: []string{"PCP"}, Mapped: true}); len(got.Egresses) != 1 {
		t.Fatalf("与实测重复的映射不该再加：%+v", got.Egresses)
	}
	// 撤销映射
	if got := withMapped(r, nil); len(got.Egresses) != 1 || got.Egresses[0].Mapped {
		t.Fatalf("撤销映射后出口 = %+v", got.Egresses)
	}
}
