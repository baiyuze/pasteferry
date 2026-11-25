package portmap

import (
	"bytes"
	"context"
	"crypto/rand"
	"encoding/binary"
	"errors"
	"fmt"
	"net"
	"net/netip"
	"time"
)

// PCP（RFC 6887）与它的前身 NAT-PMP（RFC 6886）都是向网关的 UDP 5351 端口发一个请求。
// 先试 PCP；只懂 NAT-PMP 的网关会回一个 NAT-PMP 格式的「版本不支持」，随即改用 NAT-PMP。

const (
	pcpVersion       = 2
	pcpOpMap         = 1
	pmpVersion       = 0
	pmpOpExternal    = 0
	pmpOpMapUDP      = 1
	protoUDP         = 17
	resultUnsuppVers = 1 // 两种协议的「版本不支持」都是 1
)

var errUnsupportedVersion = errors.New("网关不支持这个协议版本")

// mapPMP 在一个网关上先试 PCP，网关表示不支持时再试 NAT-PMP。
func (c *Client) mapPMP(ctx context.Context, gw netip.Addr, localPort int) (*Mapping, error) {
	local, err := localAddrFor(gw)
	if err != nil {
		return nil, err
	}
	m, err := c.pcpMap(ctx, gw, local, localPort, leaseSeconds)
	if err == nil {
		return m, nil
	}
	if !errors.Is(err, errUnsupportedVersion) {
		return nil, fmt.Errorf("PCP %s: %w", gw, err)
	}
	m, err = c.natpmpMap(ctx, gw, local, localPort, leaseSeconds)
	if err != nil {
		return nil, fmt.Errorf("NAT-PMP %s: %w", gw, err)
	}
	return m, nil
}

// exchange 向网关发一个请求，等对得上的应答。按协议建议的 250 毫秒起、每次翻倍重发，共 3 次。
func (c *Client) exchange(ctx context.Context, gw netip.Addr, req []byte, match func([]byte) bool) ([]byte, error) {
	conn, err := net.DialUDP("udp4", nil, net.UDPAddrFromAddrPort(netip.AddrPortFrom(gw, uint16(c.pmpPort()))))
	if err != nil {
		return nil, err
	}
	defer conn.Close()
	buf := make([]byte, 1100)
	wait := 250 * time.Millisecond
	for try := 0; try < 3; try++ {
		if _, err := conn.Write(req); err != nil {
			return nil, err
		}
		deadline := time.Now().Add(wait)
		if d, ok := ctx.Deadline(); ok && d.Before(deadline) {
			deadline = d
		}
		_ = conn.SetReadDeadline(deadline)
		for {
			n, err := conn.Read(buf)
			if err != nil {
				break // 超时：重发；ICMP 端口不可达（网关没开这个服务）也会走到这里
			}
			if match(buf[:n]) {
				return append([]byte(nil), buf[:n]...), nil
			}
		}
		if ctx.Err() != nil {
			return nil, ctx.Err()
		}
		wait *= 2
	}
	return nil, errors.New("没有应答")
}

// ───────────── PCP ─────────────

func pcpRequest(local netip.Addr, localPort, lifetime int, nonce []byte, suggestedPort uint16) []byte {
	req := make([]byte, 60)
	req[0] = pcpVersion
	req[1] = pcpOpMap
	binary.BigEndian.PutUint32(req[4:8], uint32(lifetime))
	client := local.As16() // IPv4 地址写成 IPv4 映射的 IPv6 形式（::ffff:a.b.c.d）
	copy(req[8:24], client[:])
	copy(req[24:36], nonce)
	req[36] = protoUDP
	binary.BigEndian.PutUint16(req[40:42], uint16(localPort))
	binary.BigEndian.PutUint16(req[42:44], suggestedPort)
	// 建议的外网地址：IPv4 的全零（::ffff:0.0.0.0），表示由网关决定
	any4 := netip.IPv4Unspecified().As16()
	copy(req[44:60], any4[:])
	return req
}

func (c *Client) pcpMap(ctx context.Context, gw, local netip.Addr, localPort, lifetime int) (*Mapping, error) {
	nonce := make([]byte, 12)
	if _, err := rand.Read(nonce); err != nil {
		return nil, err
	}
	req := pcpRequest(local, localPort, lifetime, nonce, uint16(localPort))
	resp, err := c.exchange(ctx, gw, req, func(b []byte) bool {
		// NAT-PMP 网关回的「版本不支持」：版本 0、操作码带应答位
		if len(b) >= 4 && b[0] == pmpVersion && b[1]&0x80 != 0 {
			return true
		}
		return len(b) >= 60 && b[0] == pcpVersion && b[1] == 0x80|pcpOpMap && bytes.Equal(b[24:36], nonce)
	})
	if err != nil {
		return nil, err
	}
	if resp[0] == pmpVersion {
		return nil, errUnsupportedVersion
	}
	if code := resp[3]; code != 0 {
		if code == resultUnsuppVers {
			return nil, errUnsupportedVersion
		}
		return nil, fmt.Errorf("结果代码 %d", code)
	}
	granted := binary.BigEndian.Uint32(resp[4:8])
	extPort := binary.BigEndian.Uint16(resp[42:44])
	extIP, _ := netip.AddrFromSlice(resp[44:60])
	if !extIP.Unmap().Is4() || extPort == 0 {
		return nil, fmt.Errorf("应答里的外网地址无效：%s:%d", extIP, extPort)
	}
	m := &Mapping{
		External: netip.AddrPortFrom(extIP.Unmap(), extPort),
		Internal: netip.AddrPortFrom(local, uint16(localPort)),
		Protocol: "PCP", Gateway: gw, Lifetime: time.Duration(granted) * time.Second, At: time.Now(),
	}
	m.release = func(ctx context.Context) error {
		// 删除：同一个 nonce、时长 0
		del := pcpRequest(local, localPort, 0, nonce, 0)
		_, err := c.exchange(ctx, gw, del, func(b []byte) bool {
			return len(b) >= 60 && b[0] == pcpVersion && bytes.Equal(b[24:36], nonce)
		})
		return err
	}
	return m, nil
}

// ───────────── NAT-PMP ─────────────

func (c *Client) natpmpMap(ctx context.Context, gw, local netip.Addr, localPort, lifetime int) (*Mapping, error) {
	resp, err := c.exchange(ctx, gw, []byte{pmpVersion, pmpOpExternal}, func(b []byte) bool {
		return len(b) >= 12 && b[0] == pmpVersion && b[1] == 0x80|pmpOpExternal
	})
	if err != nil {
		return nil, err
	}
	if code := binary.BigEndian.Uint16(resp[2:4]); code != 0 {
		return nil, fmt.Errorf("查询外网地址：结果代码 %d", code)
	}
	extIP := netip.AddrFrom4([4]byte(resp[8:12]))

	req := make([]byte, 12)
	req[0], req[1] = pmpVersion, pmpOpMapUDP
	binary.BigEndian.PutUint16(req[4:6], uint16(localPort))
	binary.BigEndian.PutUint16(req[6:8], uint16(localPort))
	binary.BigEndian.PutUint32(req[8:12], uint32(lifetime))
	isReply := func(b []byte) bool {
		return len(b) >= 16 && b[0] == pmpVersion && b[1] == 0x80|pmpOpMapUDP &&
			binary.BigEndian.Uint16(b[8:10]) == uint16(localPort)
	}
	resp, err = c.exchange(ctx, gw, req, isReply)
	if err != nil {
		return nil, err
	}
	if code := binary.BigEndian.Uint16(resp[2:4]); code != 0 {
		return nil, fmt.Errorf("映射端口：结果代码 %d", code)
	}
	extPort := binary.BigEndian.Uint16(resp[10:12])
	granted := binary.BigEndian.Uint32(resp[12:16])
	if extPort == 0 {
		return nil, errors.New("应答里的外网端口为 0")
	}
	m := &Mapping{
		External: netip.AddrPortFrom(extIP, extPort),
		Internal: netip.AddrPortFrom(local, uint16(localPort)),
		Protocol: "NAT-PMP", Gateway: gw, Lifetime: time.Duration(granted) * time.Second, At: time.Now(),
	}
	m.release = func(ctx context.Context) error {
		// 删除：时长与建议端口都填 0
		del := make([]byte, 12)
		del[0], del[1] = pmpVersion, pmpOpMapUDP
		binary.BigEndian.PutUint16(del[4:6], uint16(localPort))
		_, err := c.exchange(ctx, gw, del, isReply)
		return err
	}
	return m, nil
}
