package lan

import "testing"

func TestFirewallRulesAllowProgram(t *testing.T) {
	allow := firewallRule{Enabled: true, Direction: 1, Action: 1, Profiles: 7, Protocol: 256, InterfaceTypes: "All"}
	change := func(edit func(*firewallRule)) firewallRule {
		r := allow
		edit(&r)
		return r
	}
	tests := []struct {
		name  string
		rules []firewallRule
		want  bool
	}{
		{"no rules", nil, false},
		{"all traffic", []firewallRule{allow}, true},
		{"TCP only cannot sync", []firewallRule{change(func(r *firewallRule) { r.Protocol = 6 })}, false},
		{"UDP only cannot serve phone", []firewallRule{change(func(r *firewallRule) { r.Protocol = 17 })}, false},
		{"separate TCP UDP", []firewallRule{change(func(r *firewallRule) { r.Protocol = 6 }), change(func(r *firewallRule) { r.Protocol = 17 })}, true},
		{"disabled", []firewallRule{change(func(r *firewallRule) { r.Enabled = false })}, false},
		{"outbound only", []firewallRule{change(func(r *firewallRule) { r.Direction = 2 })}, false},
		{"private only", []firewallRule{change(func(r *firewallRule) { r.Profiles = 2 })}, false},
		{"profiles combined", []firewallRule{change(func(r *firewallRule) { r.Profiles = 3 }), change(func(r *firewallRule) { r.Profiles = 4 })}, true},
		{"cancelled prompt block wins", []firewallRule{allow, change(func(r *firewallRule) { r.Action = 0 })}, false},
		{"disabled block ignored", []firewallRule{allow, change(func(r *firewallRule) { r.Action, r.Enabled = 0, false })}, true},
		{"outbound block ignored", []firewallRule{allow, change(func(r *firewallRule) { r.Action, r.Direction = 0, 2 })}, true},
	}
	for _, field := range []string{"local port", "remote port", "local address", "remote address", "interface", "interface name", "service"} {
		r := change(func(r *firewallRule) {
			switch field {
			case "local port":
				r.LocalPorts = "8790"
			case "remote port":
				r.RemotePorts = "443"
			case "local address":
				r.LocalAddresses = "192.168.1.5"
			case "remote address":
				r.RemoteAddresses = "192.168.1.6"
			case "interface":
				r.InterfaceTypes = "Wireless"
			case "interface name":
				r.Interfaces = []string{"Ethernet 2"}
			case "service":
				r.ServiceName = "Dnscache"
			}
		})
		tests = append(tests, struct {
			name  string
			rules []firewallRule
			want  bool
		}{"restricted " + field, []firewallRule{r}, false})
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := firewallRulesAllowProgram(tt.rules); got != tt.want {
				t.Fatalf("firewallRulesAllowProgram() = %v, want %v", got, tt.want)
			}
		})
	}
}
