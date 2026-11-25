package p2p

import (
	"encoding/json"
	"net"
	"net/netip"
	"os"
	"path/filepath"
	"runtime"
	"sort"
	"strings"
	"sync"
	"time"

	"github.com/wlynxg/anet"
)

// egressHistory 记住每个网络里见过的出口 IP，补上某一轮探测漏掉的线路。
//
// 探测服务器的 IP 恰好都没落到某条线路上时，这一轮就看不到它。若这条线路不改端口，
// 它在本端口上的公网地址就是「出口 IP + 本地端口」，可以直接推算出来发给对端。
// 会改端口的线路无法推算，只能靠再探测到它：所以每条线路还记下探测到它的几台服务器
// 的 IP，以后每轮都探测这些 IP（见 pinned），线路就不会因为 DNS 换了一组 IP 而漏掉。
type egressHistory struct {
	path string
	now  func() time.Time

	mu   sync.Mutex
	data historyFile
}

type historyFile struct {
	// 键是网络标识（见 localNetworkKey）：换了网络，出口自然也不一样了
	Networks map[string][]historyEntry `json:"networks"`
}

type historyEntry struct {
	IP            string    `json:"ip"`
	PortPreserved bool      `json:"port_preserved"`
	LastSeen      time.Time `json:"last_seen"`
	// Servers 是最近看到这条线路的探测服务器，最新的在前，最多 maxPinnedPerEgress 台
	Servers []historyServer `json:"servers,omitempty"`
}

type historyServer struct {
	Name string `json:"name"`
	Addr string `json:"addr"` // IP:端口
}

const maxPinnedPerEgress = 3

// loadEgressHistory 读取历史；path 为空时只保存在内存里。文件损坏就当没有历史。
func loadEgressHistory(path string) *egressHistory {
	h := &egressHistory{path: path, now: time.Now, data: historyFile{Networks: map[string][]historyEntry{}}}
	if path == "" {
		return h
	}
	if raw, err := os.ReadFile(path); err == nil {
		var f historyFile
		if json.Unmarshal(raw, &f) == nil && f.Networks != nil {
			h.data = f
		}
	}
	return h
}

// record 把一轮实测结果并入历史，并清掉过期的条目。
func (h *egressHistory) record(network string, r EgressReport) {
	h.mu.Lock()
	defer h.mu.Unlock()

	now := h.now()
	byIP := map[string]historyEntry{}
	for _, e := range h.data.Networks[network] {
		if now.Sub(e.LastSeen) < historyTTL {
			byIP[e.IP] = e
		}
	}
	for _, e := range r.Egresses {
		if e.Guessed() {
			continue // 推算出来的不能反过来当作见过的证据
		}
		ip := e.Addr.Addr().String()
		entry := historyEntry{IP: ip, PortPreserved: e.PortPreserved, LastSeen: now}
		// 这一轮看到它的服务器排在前面，再接上以前记下的，去重后截断
		seen := map[string]bool{}
		for _, t := range e.Targets {
			if a := t.addr.String(); len(entry.Servers) < maxPinnedPerEgress && !seen[a] {
				seen[a] = true
				entry.Servers = append(entry.Servers, historyServer{Name: t.name, Addr: a})
			}
		}
		for _, s := range byIP[ip].Servers {
			if len(entry.Servers) < maxPinnedPerEgress && !seen[s.Addr] {
				seen[s.Addr] = true
				entry.Servers = append(entry.Servers, s)
			}
		}
		byIP[ip] = entry
	}

	entries := make([]historyEntry, 0, len(byIP))
	for _, e := range byIP {
		entries = append(entries, e)
	}
	sort.Slice(entries, func(i, j int) bool { return entries[i].IP < entries[j].IP })
	h.data.Networks[network] = entries
	h.saveLocked()
}

// augment 给本轮结果补上历史里见过、这一轮没探测到、并且不改端口的出口。
func (h *egressHistory) augment(network string, r EgressReport) EgressReport {
	h.mu.Lock()
	defer h.mu.Unlock()

	present := map[netip.Addr]bool{}
	for _, e := range r.Egresses {
		present[e.Addr.Addr()] = true
	}
	now := h.now()
	for _, e := range h.data.Networks[network] {
		ip, err := netip.ParseAddr(e.IP)
		if err != nil || !e.PortPreserved || present[ip] || now.Sub(e.LastSeen) >= historyTTL {
			continue
		}
		r.Egresses = append(r.Egresses, Egress{
			Addr:          netip.AddrPortFrom(ip, uint16(r.LocalPort)),
			PortPreserved: true,
		})
	}
	return r
}

// pinned 返回这个网络里探测到过各条线路的服务器，每轮探测都带上它们。
// 按线路轮流取：每条线路的第一台排在前面，免得一条线路的几台挤掉另一条线路的。
func (h *egressHistory) pinned(network string) []probeTarget {
	h.mu.Lock()
	defer h.mu.Unlock()

	now := h.now()
	var lines [][]probeTarget
	for _, e := range h.data.Networks[network] {
		if now.Sub(e.LastSeen) >= historyTTL {
			continue
		}
		var line []probeTarget
		for _, s := range e.Servers {
			if ap, err := netip.ParseAddrPort(s.Addr); err == nil {
				line = append(line, probeTarget{name: s.Name, addr: ap})
			}
		}
		lines = append(lines, line)
	}
	var out []probeTarget
	for i := 0; i < maxPinnedPerEgress; i++ {
		for _, line := range lines {
			if i < len(line) {
				out = append(out, line[i])
			}
		}
	}
	return out
}

func (h *egressHistory) saveLocked() {
	if h.path == "" {
		return
	}
	raw, err := json.MarshalIndent(h.data, "", "  ")
	if err != nil {
		return
	}
	// 先写临时文件再改名，避免进程中途退出留下半个文件
	tmp := h.path + ".tmp"
	if err := os.MkdirAll(filepath.Dir(h.path), 0o700); err != nil {
		return
	}
	if err := os.WriteFile(tmp, raw, 0o600); err != nil {
		return
	}
	_ = os.Rename(tmp, h.path)
}

// localNetworkKey 用本机各网卡的 IPv4 地址标识「当前所在的网络」。
// 换了 Wi-Fi、插拔网线，地址随之变化，历史与探测结果也就跟着换一套。
//
// 不算链路本地地址（169.254.0.0/16）：没拿到 DHCP 地址的网卡（USB 网卡、雷电网桥）
// 会自己挑一个，时有时无、每次都不同。算进来的话同一个网络会被当成许多个，
// 出口历史分散开用不上，还会被误判为网络变化而反复重新探测。
func localNetworkKey() string {
	// Android 11 起标准库读不到网卡列表，anet 在那里改用 netlink，其他平台就是 net.Interfaces
	ifaces, err := anet.Interfaces()
	if err != nil {
		return ""
	}
	var addrs []string
	for _, ifc := range ifaces {
		if ifc.Flags&net.FlagUp == 0 || ifc.Flags&net.FlagLoopback != 0 || unstableAdapter(ifc.Name) {
			continue
		}
		list, err := anet.InterfaceAddrsByInterface(&ifc)
		if err != nil {
			continue
		}
		for _, a := range list {
			if ipn, ok := a.(*net.IPNet); ok && ipn.IP.To4() != nil && !ipn.IP.IsLinkLocalUnicast() {
				addrs = append(addrs, ipn.IP.String())
			}
		}
	}
	sort.Strings(addrs)
	return strings.Join(addrs, ",")
}

// unstableAdapter 判断一块网卡是否该排除在网络标识之外。
//
// Windows 上 WSL、Hyper-V、Docker 的虚拟网卡（名字以 vEthernet 开头）每次开机地址都会变，
// 算进来的话，同一个网络每次开机都像是新网络，出口历史就用不上了。其他平台不排除，
// 与之前的行为一致。
func unstableAdapter(name string) bool {
	return runtime.GOOS == "windows" && strings.HasPrefix(name, "vEthernet")
}
