package portmap

import (
	"context"
	"encoding/binary"
	"fmt"
	"io"
	"net"
	"net/http"
	"net/http/httptest"
	"net/netip"
	"strings"
	"sync"
	"testing"
	"time"
)

var loopback = netip.MustParseAddr("127.0.0.1")

// pmpServer 在本机模拟网关的 5351 端口。pcp 为假时只懂 NAT-PMP：收到 PCP 请求回「版本不支持」。
type pmpServer struct {
	conn    *net.UDPConn
	pcp     bool
	extIP   [4]byte
	mu      sync.Mutex
	deleted int
}

func startPMP(t *testing.T, pcp bool) *pmpServer {
	t.Helper()
	conn, err := net.ListenUDP("udp4", &net.UDPAddr{IP: net.IPv4(127, 0, 0, 1)})
	if err != nil {
		t.Fatal(err)
	}
	s := &pmpServer{conn: conn, pcp: pcp, extIP: [4]byte{8, 8, 4, 4}}
	t.Cleanup(func() { _ = conn.Close() })
	go s.serve()
	return s
}

func (s *pmpServer) port() int { return s.conn.LocalAddr().(*net.UDPAddr).Port }

func (s *pmpServer) serve() {
	buf := make([]byte, 1100)
	for {
		n, from, err := s.conn.ReadFromUDP(buf)
		if err != nil {
			return
		}
		req := buf[:n]
		var resp []byte
		switch {
		case req[0] == pcpVersion && !s.pcp:
			resp = []byte{0, 0x80 | req[1], 0, resultUnsuppVers, 0, 0, 0, 0}
		case req[0] == pcpVersion && len(req) >= 60:
			resp = make([]byte, 60)
			copy(resp, req)
			resp[1] = 0x80 | pcpOpMap
			resp[3] = 0
			lifetime := binary.BigEndian.Uint32(req[4:8])
			if lifetime == 0 {
				s.mu.Lock()
				s.deleted++
				s.mu.Unlock()
			}
			binary.BigEndian.PutUint32(resp[4:8], lifetime/2) // 网关可以给得比请求的短
			ext := binary.BigEndian.Uint16(req[40:42]) + 1    // 给一个与本地端口不同的外网端口
			binary.BigEndian.PutUint16(resp[42:44], ext)
			ip := netip.AddrFrom4(s.extIP).As16()
			copy(resp[44:60], ip[:])
		case req[0] == pmpVersion && req[1] == pmpOpExternal:
			resp = make([]byte, 12)
			resp[1] = 0x80
			copy(resp[8:12], s.extIP[:])
		case req[0] == pmpVersion && req[1] == pmpOpMapUDP && len(req) >= 12:
			resp = make([]byte, 16)
			resp[1] = 0x80 | pmpOpMapUDP
			copy(resp[8:10], req[4:6])
			lifetime := binary.BigEndian.Uint32(req[8:12])
			if lifetime == 0 {
				s.mu.Lock()
				s.deleted++
				s.mu.Unlock()
			} else {
				binary.BigEndian.PutUint16(resp[10:12], binary.BigEndian.Uint16(req[6:8]))
			}
			binary.BigEndian.PutUint32(resp[12:16], lifetime)
		default:
			continue
		}
		_, _ = s.conn.WriteToUDP(resp, from)
	}
}

func (s *pmpServer) deletes() int {
	s.mu.Lock()
	defer s.mu.Unlock()
	return s.deleted
}

func noUPnP(t *testing.T) string {
	// 一个不应答的 SSDP 地址，让 UPnP 这一步快速失败
	conn, err := net.ListenUDP("udp4", &net.UDPAddr{IP: net.IPv4(127, 0, 0, 1)})
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = conn.Close() })
	return conn.LocalAddr().String()
}

func TestMapWithPCP(t *testing.T) {
	srv := startPMP(t, true)
	c := &Client{Gateways: func() []netip.Addr { return []netip.Addr{loopback} }, PMPPort: srv.port(), SSDPAddr: noUPnP(t)}
	m, err := c.Map(context.Background(), 40000)
	if err != nil {
		t.Fatal(err)
	}
	if m.Protocol != "PCP" || m.External.String() != "8.8.4.4:40001" || m.Lifetime != leaseSeconds/2*time.Second {
		t.Fatalf("映射 = %+v，期望 PCP 8.8.4.4:40001、时长取网关给的", m)
	}
	if m.Internal.Port() != 40000 {
		t.Errorf("内部端口 = %d", m.Internal.Port())
	}
	if err := m.Release(context.Background()); err != nil || srv.deletes() != 1 {
		t.Fatalf("删除映射：err=%v，网关收到 %d 次删除", err, srv.deletes())
	}
}

// 只懂 NAT-PMP 的网关对 PCP 回「版本不支持」，随即改用 NAT-PMP。
func TestMapFallsBackToNATPMP(t *testing.T) {
	srv := startPMP(t, false)
	c := &Client{Gateways: func() []netip.Addr { return []netip.Addr{loopback} }, PMPPort: srv.port(), SSDPAddr: noUPnP(t)}
	m, err := c.Map(context.Background(), 40000)
	if err != nil {
		t.Fatal(err)
	}
	if m.Protocol != "NAT-PMP" || m.External.String() != "8.8.4.4:40000" {
		t.Fatalf("映射 = %+v，期望 NAT-PMP 8.8.4.4:40000", m)
	}
	if err := m.Release(context.Background()); err != nil || srv.deletes() != 1 {
		t.Fatalf("删除映射：err=%v，网关收到 %d 次删除", err, srv.deletes())
	}
}

// fakeIGD 模拟一台 UPnP 路由器：SSDP 应答、设备描述（服务藏在子设备里）与 SOAP 控制。
// 想要的外网端口第一次被说成已占用（718），客户端应换端口重试。
type fakeIGD struct {
	ssdp    *net.UDPConn
	http    *httptest.Server
	mu      sync.Mutex
	actions []string
}

const igdDescription = `<?xml version="1.0"?>
<root xmlns="urn:schemas-upnp-org:device-1-0">
 <device><deviceType>urn:schemas-upnp-org:device:InternetGatewayDevice:1</deviceType>
  <deviceList><device><deviceType>urn:schemas-upnp-org:device:WANDevice:1</deviceType>
   <deviceList><device><deviceType>urn:schemas-upnp-org:device:WANConnectionDevice:1</deviceType>
    <serviceList><service>
     <serviceType>urn:schemas-upnp-org:service:WANPPPConnection:1</serviceType>
     <controlURL>/ctl/ppp</controlURL>
    </service></serviceList>
   </device></deviceList>
  </device></deviceList>
 </device>
</root>`

func startIGD(t *testing.T) *fakeIGD {
	t.Helper()
	g := &fakeIGD{}
	conflict := true
	g.http = httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodGet {
			_, _ = io.WriteString(w, igdDescription)
			return
		}
		body, _ := io.ReadAll(r.Body)
		action := r.Header.Get("SOAPAction")
		g.mu.Lock()
		g.actions = append(g.actions, action[strings.Index(action, "#")+1:len(action)-1]+" "+xmlValue(body, "NewExternalPort"))
		g.mu.Unlock()
		switch {
		case strings.HasSuffix(action, `#GetExternalIPAddress"`):
			_, _ = io.WriteString(w, `<s:Envelope><s:Body><u:GetExternalIPAddressResponse><NewExternalIPAddress>8.8.4.4</NewExternalIPAddress></u:GetExternalIPAddressResponse></s:Body></s:Envelope>`)
		case strings.HasSuffix(action, `#AddPortMapping"`) && conflict:
			conflict = false
			w.WriteHeader(http.StatusInternalServerError)
			_, _ = io.WriteString(w, `<s:Envelope><s:Body><s:Fault><detail><UPnPError><errorCode>718</errorCode></UPnPError></detail></s:Fault></s:Body></s:Envelope>`)
		default:
			_, _ = io.WriteString(w, `<s:Envelope><s:Body/></s:Envelope>`)
		}
	}))
	t.Cleanup(g.http.Close)

	conn, err := net.ListenUDP("udp4", &net.UDPAddr{IP: net.IPv4(127, 0, 0, 1)})
	if err != nil {
		t.Fatal(err)
	}
	g.ssdp = conn
	t.Cleanup(func() { _ = conn.Close() })
	go func() {
		buf := make([]byte, 2048)
		for {
			n, from, err := conn.ReadFromUDP(buf)
			if err != nil {
				return
			}
			if !strings.HasPrefix(string(buf[:n]), "M-SEARCH") {
				continue
			}
			reply := fmt.Sprintf("HTTP/1.1 200 OK\r\nCACHE-CONTROL: max-age=120\r\nST: upnp:rootdevice\r\nLOCATION: %s/desc.xml\r\n\r\n", g.http.URL)
			_, _ = conn.WriteToUDP([]byte(reply), from)
		}
	}()
	return g
}

func TestMapWithUPnP(t *testing.T) {
	pmp := startPMP(t, false)
	_ = pmp.conn.Close() // 网关不应答 PCP/NAT-PMP：走到 UPnP
	igd := startIGD(t)
	c := &Client{
		Gateways: func() []netip.Addr { return []netip.Addr{loopback} },
		PMPPort:  pmp.port(), SSDPAddr: igd.ssdp.LocalAddr().String(),
	}
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	m, err := c.Map(ctx, 40000)
	if err != nil {
		t.Fatal(err)
	}
	if m.Protocol != "UPnP" || m.External.Addr().String() != "8.8.4.4" || m.External.Port() == 40000 {
		t.Fatalf("映射 = %+v，期望 UPnP、外网 IP 8.8.4.4、端口冲突后换了一个", m)
	}
	if err := m.Release(ctx); err != nil {
		t.Fatal(err)
	}
	igd.mu.Lock()
	defer igd.mu.Unlock()
	want := fmt.Sprintf("GetExternalIPAddress  AddPortMapping 40000 AddPortMapping %d DeletePortMapping %d",
		m.External.Port(), m.External.Port())
	if got := strings.Join(igd.actions, " "); got != want {
		t.Fatalf("路由器收到的动作 = %q\n期望 %q", got, want)
	}
}

func TestMapReportsUnsupported(t *testing.T) {
	pmp := startPMP(t, false)
	_ = pmp.conn.Close()
	c := &Client{Gateways: func() []netip.Addr { return []netip.Addr{loopback} }, PMPPort: pmp.port(), SSDPAddr: noUPnP(t)}
	if _, err := c.Map(context.Background(), 40000); err == nil {
		t.Fatal("网关什么都不应答时应报错")
	}
}

func TestXMLValueIgnoresNamespacePrefix(t *testing.T) {
	body := []byte(`<s:Envelope><s:Body><m:R xmlns:m="x"><m:NewExternalIPAddress> 1.2.3.4 </m:NewExternalIPAddress></m:R></s:Body></s:Envelope>`)
	if v := xmlValue(body, "NewExternalIPAddress"); v != "1.2.3.4" {
		t.Fatalf("xmlValue = %q", v)
	}
}
