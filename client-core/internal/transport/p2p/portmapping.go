package p2p

import (
	"context"
	"net/netip"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/transport/portmap"
)

// 路由器端口映射（见 portmap 包）。
//
// 映射到的「路由器外网 IP:端口」作为优先级最高的出口地址发给对端。对端的包直接打到这个
// 端口就能进来，不必等本端先发包打开路由器的过滤，也不管本端发往对端的包走哪条线路，
// 所以对端是对称型 NAT、或本端是多线路的网络时同样能直连。映射不改变本端往外发包的方式。

const (
	// portmapRetry：路由器不支持、或外面还有一层运营商 NAT 时，隔这么久再试（换了网络立即试）
	portmapRetry = 30 * time.Minute
	// portmapTimeout 是一次尝试的上限：PCP/NAT-PMP 各网关并发，UPnP 还要发现与读描述
	portmapTimeout = 10 * time.Second
)

// portMapLoop 维持端口映射：启动时、换了网络时建立，到期前续期，退出时删除。
func (m *Manager) portMapLoop(enabled func() bool) {
	defer close(m.portmapDone)
	client := &portmap.Client{}
	var current *portmap.Mapping
	var lastErr string
	release := func() {
		if current == nil {
			return
		}
		ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
		if err := current.Release(ctx); err != nil {
			m.log.Debug("删除路由器端口映射失败", "err", err)
		}
		cancel()
		current = nil
	}
	defer release()

	for {
		var mp *portmap.Mapping
		var err error
		on := enabled()
		if on {
			ctx, cancel := context.WithTimeout(context.Background(), portmapTimeout)
			mp, err = client.Map(ctx, m.localPort)
			cancel()
		}
		wait := portmapRetry
		switch {
		case !on:
			// 没有服务器、只在局域网里用：映射没有用处
			release()
			m.setMapped(nil)
		case err != nil:
			if msg := err.Error(); msg != lastErr {
				lastErr = msg
				m.log.Info("路由器没有给打洞端口做映射", "原因", firstLine(msg))
			}
			current = nil
			m.setMapped(nil)
		case !usableProbeIP(mp.External.Addr(), m.probeOpts.AllowPrivate):
			// 路由器的外网地址是内网或运营商级 NAT 地址：外面还有一层 NAT，映射到不了公网
			if msg := "behind:" + mp.External.Addr().String(); msg != lastErr {
				lastErr = msg
				m.log.Info("路由器外面还有一层运营商 NAT，端口映射用不上",
					"协议", mp.Protocol, "路由器外网地址", mp.External.Addr())
			}
			current = mp
			release()
			m.setMapped(nil)
		default:
			if current == nil || current.External != mp.External {
				m.log.Info("路由器已为打洞端口做了映射", "协议", mp.Protocol, "外网地址", mp.External,
					"时长", mp.Lifetime)
			}
			lastErr = ""
			current = mp
			m.setMapped(mp)
			wait = time.Until(mp.RenewAt())
		}

		timer := time.NewTimer(wait)
		select {
		case <-m.stop:
			timer.Stop()
			return
		case <-m.portmapKick:
			timer.Stop()
			// 换了网络：旧映射所在的路由器多半已经不在了，不必删，到期自会消失
			current = nil
		case <-timer.C:
		}
	}
}

// kickPortMap 让 portMapLoop 立即重新建立映射（网络变化时）。
func (m *Manager) kickPortMap() {
	if m.portmapKick == nil {
		return
	}
	select {
	case m.portmapKick <- struct{}{}:
	default:
	}
}

// setMapped 记下当前的映射，并立即并入出口结果，下一次握手就会带上。
func (m *Manager) setMapped(mp *portmap.Mapping) {
	var e *Egress
	if mp != nil {
		e = &Egress{
			Addr:          mp.External,
			PortPreserved: int(mp.External.Port()) == m.localPort,
			Via:           []string{mp.Protocol},
			Mapped:        true,
		}
	}
	m.egressMu.Lock()
	m.mapped = e
	m.egress = withMapped(m.egress, e)
	m.egressMu.Unlock()
}

// withMapped 把端口映射放在出口列表最前面（替换掉旧的）；与实测地址重复时不再加。
func withMapped(r EgressReport, e *Egress) EgressReport {
	out := r.Egresses[:0:0]
	for _, x := range r.Egresses {
		if !x.Mapped {
			out = append(out, x)
		}
	}
	if e != nil && !containsAddr(out, e.Addr) {
		out = append([]Egress{*e}, out...)
	}
	r.Egresses = out
	return r
}

func containsAddr(es []Egress, a netip.AddrPort) bool {
	for _, e := range es {
		if e.Addr == a {
			return true
		}
	}
	return false
}

func firstLine(s string) string {
	for i, r := range s {
		if r == '\n' {
			return s[:i]
		}
	}
	return s
}
