package portmap

import (
	"bufio"
	"bytes"
	"context"
	"encoding/xml"
	"errors"
	"fmt"
	"io"
	mathrand "math/rand/v2"
	"net"
	"net/http"
	"net/netip"
	"net/url"
	"regexp"
	"strconv"
	"strings"
	"time"
)

// UPnP IGD：组播 SSDP 找到路由器，读它的设备描述找到 WANIPConnection（或拨号上网时的
// WANPPPConnection）服务，再用 SOAP 调 AddPortMapping。

const ssdpWait = 1500 * time.Millisecond

var ssdpTargets = []string{
	"urn:schemas-upnp-org:device:InternetGatewayDevice:1",
	"urn:schemas-upnp-org:device:InternetGatewayDevice:2",
	"urn:schemas-upnp-org:service:WANIPConnection:1",
}

func (c *Client) mapUPnP(ctx context.Context, gateways []netip.Addr, localPort int) (*Mapping, error) {
	locations, err := c.discoverIGD(ctx, gateways)
	if err != nil {
		return nil, fmt.Errorf("UPnP: %w", err)
	}
	var errs []error
	for _, loc := range locations {
		m, err := c.upnpMapAt(ctx, loc, localPort)
		if err == nil {
			return m, nil
		}
		errs = append(errs, fmt.Errorf("UPnP %s: %w", loc.Host, err))
	}
	return nil, errors.Join(errs...)
}

// discoverIGD 发出 SSDP 搜索，收集应答里的设备描述地址。网关上的设备排在前面；
// 不在网关上的只在测试里接受，免得把局域网里别的设备（比如开了网络共享的电脑）当成路由器。
func (c *Client) discoverIGD(ctx context.Context, gateways []netip.Addr) ([]*url.URL, error) {
	target := c.SSDPAddr
	if target == "" {
		target = "239.255.255.250:1900"
	}
	dst, err := net.ResolveUDPAddr("udp4", target)
	if err != nil {
		return nil, err
	}
	conn, err := net.ListenUDP("udp4", &net.UDPAddr{})
	if err != nil {
		return nil, err
	}
	defer conn.Close()
	for _, st := range ssdpTargets {
		msg := "M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMAN: \"ssdp:discover\"\r\nMX: 1\r\nST: " + st + "\r\n\r\n"
		if _, err := conn.WriteToUDP([]byte(msg), dst); err != nil {
			return nil, err
		}
	}
	deadline := time.Now().Add(ssdpWait)
	if d, ok := ctx.Deadline(); ok && d.Before(deadline) {
		deadline = d
	}
	_ = conn.SetReadDeadline(deadline)

	isGateway := map[netip.Addr]bool{}
	for _, g := range gateways {
		isGateway[g] = true
	}
	seen := map[string]bool{}
	var onGateway, others []*url.URL
	buf := make([]byte, 2048)
	for {
		n, _, err := conn.ReadFromUDP(buf)
		if err != nil {
			break
		}
		resp, err := http.ReadResponse(bufio.NewReader(bytes.NewReader(buf[:n])), nil)
		if err != nil {
			continue
		}
		loc := resp.Header.Get("Location")
		_ = resp.Body.Close()
		u, err := url.Parse(loc)
		if err != nil || u.Scheme != "http" || seen[u.String()] {
			continue
		}
		host, err := netip.ParseAddr(u.Hostname())
		if err != nil || !(host.IsPrivate() || host.IsLoopback() || host.IsLinkLocalUnicast()) {
			continue // 设备描述只该在局域网里
		}
		seen[u.String()] = true
		if isGateway[host.Unmap()] {
			onGateway = append(onGateway, u)
		} else {
			others = append(others, u)
		}
	}
	if c.AllowAnyIGD {
		onGateway = append(onGateway, others...)
	}
	if len(onGateway) == 0 {
		return nil, errors.New("没有找到路由器")
	}
	return onGateway, nil
}

type upnpService struct {
	Type    string `xml:"serviceType"`
	Control string `xml:"controlURL"`
}

type upnpDevice struct {
	Services []upnpService `xml:"serviceList>service"`
	Devices  []upnpDevice  `xml:"deviceList>device"`
}

type upnpRoot struct {
	URLBase string     `xml:"URLBase"`
	Device  upnpDevice `xml:"device"`
}

func (d upnpDevice) findWANService() (upnpService, bool) {
	for _, s := range d.Services {
		if strings.Contains(s.Type, ":WANIPConnection:") || strings.Contains(s.Type, ":WANPPPConnection:") {
			return s, true
		}
	}
	for _, sub := range d.Devices {
		if s, ok := sub.findWANService(); ok {
			return s, true
		}
	}
	return upnpService{}, false
}

func (c *Client) upnpMapAt(ctx context.Context, loc *url.URL, localPort int) (*Mapping, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, loc.String(), nil)
	if err != nil {
		return nil, err
	}
	resp, err := c.httpClient().Do(req)
	if err != nil {
		return nil, err
	}
	raw, err := io.ReadAll(io.LimitReader(resp.Body, 256<<10))
	_ = resp.Body.Close()
	if err != nil {
		return nil, err
	}
	var root upnpRoot
	if err := xml.Unmarshal(raw, &root); err != nil {
		return nil, fmt.Errorf("设备描述: %w", err)
	}
	svc, ok := root.Device.findWANService()
	if !ok {
		return nil, errors.New("设备描述里没有 WANIPConnection 服务")
	}
	base := loc
	if root.URLBase != "" {
		if b, err := url.Parse(root.URLBase); err == nil {
			base = b
		}
	}
	ctrl, err := base.Parse(svc.Control)
	if err != nil {
		return nil, err
	}

	host, err := netip.ParseAddr(loc.Hostname())
	if err != nil {
		return nil, err
	}
	local, err := localAddrFor(host.Unmap())
	if err != nil {
		return nil, err
	}

	body, err := c.soap(ctx, ctrl, svc.Type, "GetExternalIPAddress", nil)
	if err != nil {
		return nil, fmt.Errorf("查询外网地址: %w", err)
	}
	extIP, err := netip.ParseAddr(xmlValue(body, "NewExternalIPAddress"))
	if err != nil || !extIP.Unmap().Is4() {
		return nil, fmt.Errorf("路由器报告的外网地址无效：%q", xmlValue(body, "NewExternalIPAddress"))
	}

	add := func(extPort, lease int) error {
		_, err := c.soap(ctx, ctrl, svc.Type, "AddPortMapping", [][2]string{
			{"NewRemoteHost", ""},
			{"NewExternalPort", strconv.Itoa(extPort)},
			{"NewProtocol", "UDP"},
			{"NewInternalPort", strconv.Itoa(localPort)},
			{"NewInternalClient", local.String()},
			{"NewEnabled", "1"},
			{"NewPortMappingDescription", description},
			{"NewLeaseDuration", strconv.Itoa(lease)},
		})
		return err
	}
	// 先要与本地端口相同的外网端口；被别的设备占了（718）就换随机端口再试几次。
	// 有的路由器只接受永久映射（725），改用 0，退出时要记得删掉
	lease, extPort := leaseSeconds, localPort
	for try := 0; ; try++ {
		err = add(extPort, lease)
		var se *soapError
		switch {
		case err == nil:
		case errors.As(err, &se) && se.Code == 725 && lease != 0:
			lease = 0
			continue
		case errors.As(err, &se) && se.Code == 718 && try < 3:
			extPort = 20000 + mathrand.IntN(40000)
			continue
		default:
			return nil, fmt.Errorf("映射端口: %w", err)
		}
		break
	}

	m := &Mapping{
		External: netip.AddrPortFrom(extIP.Unmap(), uint16(extPort)),
		Internal: netip.AddrPortFrom(local, uint16(localPort)),
		Protocol: "UPnP", Gateway: host.Unmap(), Lifetime: time.Duration(lease) * time.Second, At: time.Now(),
	}
	m.release = func(ctx context.Context) error {
		_, err := c.soap(ctx, ctrl, svc.Type, "DeletePortMapping", [][2]string{
			{"NewRemoteHost", ""}, {"NewExternalPort", strconv.Itoa(extPort)}, {"NewProtocol", "UDP"},
		})
		return err
	}
	return m, nil
}

// soapError 是 UPnP 动作返回的错误，Code 是 UPnP 错误代码（如 718 端口冲突）。
type soapError struct {
	Code   int
	Status int
}

func (e *soapError) Error() string {
	return fmt.Sprintf("UPnP 错误 %d（HTTP %d）", e.Code, e.Status)
}

func (c *Client) soap(ctx context.Context, ctrl *url.URL, serviceType, action string, args [][2]string) ([]byte, error) {
	var b strings.Builder
	b.WriteString(`<?xml version="1.0"?><s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body>`)
	fmt.Fprintf(&b, `<u:%s xmlns:u="%s">`, action, serviceType)
	for _, a := range args {
		b.WriteString("<" + a[0] + ">")
		_ = xml.EscapeText(&b, []byte(a[1]))
		b.WriteString("</" + a[0] + ">")
	}
	fmt.Fprintf(&b, `</u:%s></s:Body></s:Envelope>`, action)

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, ctrl.String(), strings.NewReader(b.String()))
	if err != nil {
		return nil, err
	}
	req.Header.Set("Content-Type", `text/xml; charset="utf-8"`)
	req.Header.Set("SOAPAction", `"`+serviceType+"#"+action+`"`)
	resp, err := c.httpClient().Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	body, err := io.ReadAll(io.LimitReader(resp.Body, 64<<10))
	if err != nil {
		return nil, err
	}
	if resp.StatusCode != http.StatusOK {
		code, _ := strconv.Atoi(xmlValue(body, "errorCode"))
		return nil, &soapError{Code: code, Status: resp.StatusCode}
	}
	return body, nil
}

// xmlValue 取出第一个名为 name 的元素的文本（不管命名空间前缀）。SOAP 应答结构简单，
// 各家路由器的命名空间写法又五花八门，按名字找比完整解析可靠。
func xmlValue(body []byte, name string) string {
	re := regexp.MustCompile(`<(?:[A-Za-z0-9_]+:)?` + regexp.QuoteMeta(name) + `(?:\s[^>]*)?>([^<]*)<`)
	m := re.FindSubmatch(body)
	if m == nil {
		return ""
	}
	return strings.TrimSpace(string(m[1]))
}
