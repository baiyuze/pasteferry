package lan

// Windows 防火墙 COM 规则的语言无关属性。单独放置以便在所有平台验证判定逻辑。
type firewallRule struct {
	Enabled         bool
	Direction       int
	Action          int
	Profiles        int
	Protocol        int
	ServiceName     string
	LocalPorts      string
	RemotePorts     string
	LocalAddresses  string
	RemoteAddresses string
	InterfaceTypes  string
	Interfaces      []string
}

func firewallRulesAllowProgram(rules []firewallRule) bool {
	var tcp, udp int
	for _, r := range rules {
		if !r.Enabled || r.Direction != 1 { // inbound
			continue
		}
		if r.Action == 0 { // 显式阻止优先于允许，包括用户取消系统防火墙弹窗留下的规则
			return false
		}
		if r.Action != 1 || r.ServiceName != "" ||
			!unrestrictedFirewallValue(r.LocalPorts) || !unrestrictedFirewallValue(r.RemotePorts) ||
			!unrestrictedFirewallValue(r.LocalAddresses) || !unrestrictedFirewallValue(r.RemoteAddresses) ||
			r.InterfaceTypes != "All" {
			continue
		}
		restrictedInterface := false
		for _, name := range r.Interfaces {
			if name != "" {
				restrictedInterface = true
			}
		}
		if restrictedInterface {
			continue
		}
		if r.Protocol == 6 || r.Protocol == 256 {
			tcp |= r.Profiles
		}
		if r.Protocol == 17 || r.Protocol == 256 {
			udp |= r.Profiles
		}
	}
	// Domain、Private、Public 都要放行，切换网络类型后仍然可用。
	return tcp&7 == 7 && udp&7 == 7
}

func unrestrictedFirewallValue(s string) bool { return s == "" || s == "*" }
