// Package lantcp 是隔空传送的局域网快速通道：两台设备在同一局域网直连时，
// 文件数据改走一条 TCP 连接，比 WebRTC 数据通道快得多（逐包处理的开销小）。
//
// 只管连接本身：接收方在本端的局域网地址上临时监听、只接一次；发送方拨过去。
// 两端用 TLS 1.3 互相出示证书，证书的公钥就是设备身份密钥，按设备 ID 核对对方，
// 所以安全性与数据通道相同。握手后发送方先写一个数据流标签，接收方据此把连接交给对应的传输。
// 什么时候用、连不上怎么退回，由 internal/send 决定。
package lantcp

import (
	"context"
	"crypto"
	"crypto/ed25519"
	"crypto/rand"
	"crypto/tls"
	"crypto/x509"
	"encoding/binary"
	"errors"
	"fmt"
	"io"
	"math/big"
	"net"
	"net/netip"
	"sync"
	"time"

	"github.com/baiyuze/pasteferry/proto/deviceid"
)

const (
	keepAlive        = 15 * time.Second
	handshakeTimeout = 5 * time.Second
	// 每次写入的超时：对方睡眠或断网时，写入在这之后报错，发送方据此标为中断
	writeTimeout = 30 * time.Second
	maxLabel     = 256
)

var ErrClosed = errors.New("lantcp: 已关闭")

// Link 持有本机的 TLS 证书，负责监听与拨号。
type Link struct {
	cert tls.Certificate
}

// New 用设备身份密钥生成一张自签名证书（只在内存里）。
func New(signer crypto.Signer) (*Link, error) {
	if _, ok := signer.Public().(ed25519.PublicKey); !ok {
		return nil, errors.New("lantcp: 身份密钥不是 Ed25519")
	}
	serial, err := rand.Int(rand.Reader, new(big.Int).Lsh(big.NewInt(1), 63))
	if err != nil {
		return nil, err
	}
	tmpl := &x509.Certificate{
		SerialNumber: serial,
		NotBefore:    time.Now().Add(-24 * time.Hour),
		NotAfter:     time.Now().AddDate(10, 0, 0),
	}
	der, err := x509.CreateCertificate(rand.Reader, tmpl, tmpl, signer.Public(), signer)
	if err != nil {
		return nil, err
	}
	return &Link{cert: tls.Certificate{Certificate: [][]byte{der}, PrivateKey: signer}}, nil
}

// config 只认 peerID 这台设备：证书公钥派生出的设备 ID 必须等于它。
// 证书是自签名的，不走证书链校验，身份完全由公钥决定。
func (l *Link) config(peerID string) *tls.Config {
	return &tls.Config{
		Certificates:       []tls.Certificate{l.cert},
		MinVersion:         tls.VersionTLS13,
		InsecureSkipVerify: true,
		ClientAuth:         tls.RequireAnyClientCert,
		VerifyPeerCertificate: func(raw [][]byte, _ [][]*x509.Certificate) error {
			if len(raw) != 1 {
				return errors.New("lantcp: 对方没有出示证书")
			}
			c, err := x509.ParseCertificate(raw[0])
			if err != nil {
				return err
			}
			pub, ok := c.PublicKey.(ed25519.PublicKey)
			if !ok || !deviceid.Valid(peerID, pub) {
				return errors.New("lantcp: 对方不是要连的那台设备")
			}
			return nil
		},
	}
}

// Listener 是为一次传输尝试临时开的端口，只接一次连接。
type Listener struct {
	ln   net.Listener
	conf *tls.Config

	once sync.Once
}

// Listen 在本端的局域网地址 ip 上开一个随机端口，只接受 peerID 这台设备。
func (l *Link) Listen(ip netip.Addr, peerID string) (*Listener, error) {
	lc := net.ListenConfig{KeepAlive: keepAlive}
	ln, err := lc.Listen(context.Background(), "tcp", netip.AddrPortFrom(ip, 0).String())
	if err != nil {
		return nil, err
	}
	return &Listener{ln: ln, conf: l.config(peerID)}, nil
}

// Addr 返回给对方拨号用的地址（ip:port）。
func (ln *Listener) Addr() string { return ln.ln.Addr().String() }

// Close 关掉端口；正在等的 Accept 随即返回错误。
func (ln *Listener) Close() error {
	var err error
	ln.once.Do(func() { err = ln.ln.Close() })
	return err
}

// Accept 等那台设备连上来，完成握手并读出数据流标签，然后关掉端口。
// 握手失败或身份不对的连接直接断开，继续等；ctx 结束时返回 ctx 的错误。
func (ln *Listener) Accept(ctx context.Context) (net.Conn, string, error) {
	stop := context.AfterFunc(ctx, func() { ln.Close() })
	defer stop()
	defer ln.Close()
	for {
		raw, err := ln.ln.Accept()
		if err != nil {
			if ctx.Err() != nil {
				return nil, "", ctx.Err()
			}
			return nil, "", ErrClosed
		}
		c := tls.Server(raw, ln.conf)
		label, err := serverHello(c)
		if err != nil {
			_ = c.Close()
			continue
		}
		return &conn{Conn: c}, label, nil
	}
}

func serverHello(c *tls.Conn) (string, error) {
	_ = c.SetDeadline(time.Now().Add(handshakeTimeout))
	if err := c.Handshake(); err != nil {
		return "", err
	}
	var n [2]byte
	if _, err := io.ReadFull(c, n[:]); err != nil {
		return "", err
	}
	size := binary.BigEndian.Uint16(n[:])
	if size == 0 || size > maxLabel {
		return "", fmt.Errorf("lantcp: 标签长度不对: %d", size)
	}
	label := make([]byte, size)
	if _, err := io.ReadFull(c, label); err != nil {
		return "", err
	}
	_ = c.SetDeadline(time.Time{})
	return string(label), nil
}

// Dial 连到对方给的地址，核对对方是 peerID，再写上数据流标签。
func (l *Link) Dial(ctx context.Context, addr, peerID, label string) (net.Conn, error) {
	if len(label) == 0 || len(label) > maxLabel {
		return nil, fmt.Errorf("lantcp: 标签长度不对: %d", len(label))
	}
	d := net.Dialer{KeepAlive: keepAlive}
	raw, err := d.DialContext(ctx, "tcp", addr)
	if err != nil {
		return nil, err
	}
	c := tls.Client(raw, l.config(peerID))
	stop := context.AfterFunc(ctx, func() { _ = raw.Close() })
	defer stop()
	_ = c.SetDeadline(time.Now().Add(handshakeTimeout))
	if err := c.HandshakeContext(ctx); err != nil {
		_ = c.Close()
		return nil, err
	}
	msg := make([]byte, 2+len(label))
	binary.BigEndian.PutUint16(msg, uint16(len(label)))
	copy(msg[2:], label)
	if _, err := c.Write(msg); err != nil {
		_ = c.Close()
		return nil, err
	}
	_ = c.SetDeadline(time.Time{})
	if ctx.Err() != nil {
		_ = c.Close()
		return nil, ctx.Err()
	}
	return &conn{Conn: c}, nil
}

// conn 给每次写入加超时，对方没了的时候写入不会一直卡着。
type conn struct {
	*tls.Conn
}

func (c *conn) Write(p []byte) (int, error) {
	_ = c.Conn.SetWriteDeadline(time.Now().Add(writeTimeout))
	return c.Conn.Write(p)
}
