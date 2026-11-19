package p2p_test

import (
	"context"
	"fmt"
	"net"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/transport/p2p"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
	"github.com/pion/logging"
	"github.com/pion/stun/v4"
	"github.com/pion/transport/v5/vnet"
)

// 虚拟网络里复现那台随身 WiFi 与家用路由器之间的打洞：
//
//   - 「家里」：端口不随目标变化、只放行回复的 NAT（端口限制型），Mac 那边就是这样；
//   - 「随身 WiFi」：对称型 NAT，每个目标一个新端口，端口顺序递增（pion 虚拟 NAT 正是这样分配的），
//     只放行目标原样回来的包。
//
// 两边各自探测 5 台 STUN 服务器。不做端口预测时打不通（只能等中转）；做了就能直连。

var stunIPs = []string{"1.1.1.1", "1.1.1.2", "1.1.1.3", "1.1.1.4", "1.1.1.5"}

type natLab struct {
	wan  *vnet.Router
	home *vnet.Net // 端口限制型锥形 NAT 后面
	mifi *vnet.Net // 顺序分配端口的对称型 NAT 后面
}

func newNATLab(t *testing.T) *natLab {
	t.Helper()
	wan, err := vnet.NewRouter(&vnet.RouterConfig{CIDR: "0.0.0.0/0", LoggerFactory: logging.NewDefaultLoggerFactory()})
	if err != nil {
		t.Fatal(err)
	}
	for _, ip := range stunIPs {
		n, err := vnet.NewNet(&vnet.NetConfig{StaticIPs: []string{ip}})
		if err != nil {
			t.Fatal(err)
		}
		if err := wan.AddNet(n); err != nil {
			t.Fatal(err)
		}
		serveSTUN(t, n, ip)
	}
	lan := func(cidr, public, host string, nat *vnet.NATType) *vnet.Net {
		r, err := vnet.NewRouter(&vnet.RouterConfig{CIDR: cidr, StaticIPs: []string{public}, NATType: nat, LoggerFactory: logging.NewDefaultLoggerFactory()})
		if err != nil {
			t.Fatal(err)
		}
		if err := wan.AddRouter(r); err != nil {
			t.Fatal(err)
		}
		n, err := vnet.NewNet(&vnet.NetConfig{StaticIPs: []string{host}})
		if err != nil {
			t.Fatal(err)
		}
		if err := r.AddNet(n); err != nil {
			t.Fatal(err)
		}
		return n
	}
	l := &natLab{wan: wan}
	l.home = lan("192.168.1.0/24", "27.10.0.1", "192.168.1.2", &vnet.NATType{
		MappingBehavior:   vnet.EndpointIndependent,
		FilteringBehavior: vnet.EndpointAddrPortDependent,
	})
	l.mifi = lan("192.168.0.0/24", "39.20.0.1", "192.168.0.100", &vnet.NATType{
		MappingBehavior:   vnet.EndpointAddrPortDependent,
		FilteringBehavior: vnet.EndpointAddrPortDependent,
	})
	if err := wan.Start(); err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = wan.Stop() })
	return l
}

// serveSTUN 在虚拟网络里起一个只回答 Binding 请求的 STUN 服务。
func serveSTUN(t *testing.T, n *vnet.Net, ip string) {
	t.Helper()
	conn, err := n.ListenPacket("udp4", ip+":3478")
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { conn.Close() })
	go func() {
		buf := make([]byte, 1500)
		for {
			k, from, err := conn.ReadFrom(buf)
			if err != nil {
				return
			}
			req := &stun.Message{Raw: append([]byte(nil), buf[:k]...)}
			if req.Decode() != nil || req.Type != stun.BindingRequest {
				continue
			}
			ua := from.(*net.UDPAddr)
			resp, err := stun.Build(stun.NewTransactionIDSetter(req.TransactionID), stun.BindingSuccess,
				&stun.XORMappedAddress{IP: ua.IP, Port: ua.Port}, stun.Fingerprint)
			if err == nil {
				_, _ = conn.WriteTo(resp.Raw, from)
			}
		}
	}()
}

func newLabHarness(t *testing.T, id string, r *relay, n *vnet.Net, noPredict bool) *harness {
	t.Helper()
	h := &harness{id: id, states: make(chan p2p.ConnState, 32), messages: make(chan *pb.PeerMessage, 16)}
	h.manager = p2p.NewManager(p2p.ManagerOptions{
		SelfID:                id,
		SendSignal:            r.send(id),
		Net:                   n,
		DisablePortPrediction: noPredict,
		OnState: func(_ string, s p2p.ConnState) {
			select {
			case h.states <- s:
			default:
			}
		},
	})
	var urls []string
	for _, ip := range stunIPs {
		urls = append(urls, "stun:"+ip+":3478")
	}
	h.manager.SetICEServers([]*pb.IceServer{{Urls: urls}})
	r.register(id, h.manager)
	t.Cleanup(h.manager.Close)
	return h
}

func waitProbed(t *testing.T, h *harness) p2p.EgressReport {
	t.Helper()
	deadline := time.Now().Add(10 * time.Second)
	for time.Now().Before(deadline) {
		if r := h.manager.Egress(); r.Answered == len(stunIPs) {
			return r
		}
		time.Sleep(20 * time.Millisecond)
	}
	t.Fatalf("%s: egress probe did not finish: %+v", h.id, h.manager.Egress())
	return p2p.EgressReport{}
}

func runSymmetricNAT(t *testing.T, homeID, mifiID string, noPredict bool) (p2p.ConnState, p2p.EgressReport) {
	lab := newNATLab(t)
	r := newRelay()
	home := newLabHarness(t, homeID, r, lab.home, false)
	mifi := newLabHarness(t, mifiID, r, lab.mifi, noPredict)
	if rep := waitProbed(t, home); rep.Symmetric() || len(rep.Predicted) > 0 {
		t.Fatalf("home NAT looks symmetric: %+v", rep)
	}
	rep := waitProbed(t, mifi)
	if !rep.Symmetric() {
		t.Fatalf("mobile NAT does not look symmetric: %+v", rep)
	}

	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()
	_ = home.manager.Connect(ctx, mifiID)
	_ = mifi.manager.Connect(ctx, homeID)

	deadline := time.After(15 * time.Second)
	for {
		select {
		case s := <-mifi.states:
			if s == p2p.StateDirect {
				return s, rep
			}
		case <-deadline:
			return mifi.manager.State(homeID), rep
		}
	}
}

func TestSymmetricNATPortPrediction(t *testing.T) {
	for _, tc := range []struct{ name, home, mifi string }{
		{"easy side offers", "alice", "bob"},
		{"symmetric side offers", "bob", "alice"},
	} {
		t.Run(tc.name, func(t *testing.T) {
			got, rep := runSymmetricNAT(t, tc.home, tc.mifi, false)
			if len(rep.Predicted) == 0 {
				t.Fatalf("no ports predicted: %+v", rep)
			}
			if got != p2p.StateDirect {
				t.Fatalf("state = %v, want a direct connection through the symmetric NAT (predicted %v)", got, rep.Predicted)
			}
		})
	}
}

// 对照：同样的网络不做预测就打不通，说明上面的直连确实是预测带来的。
func TestSymmetricNATWithoutPredictionFails(t *testing.T) {
	got, rep := runSymmetricNAT(t, "alice", "bob", true)
	if len(rep.Predicted) != 0 {
		t.Fatal(fmt.Sprintf("prediction ran although disabled: %v", rep.Predicted))
	}
	if got == p2p.StateDirect {
		t.Fatal("connected directly without prediction; the lab no longer models the symmetric NAT")
	}
}
