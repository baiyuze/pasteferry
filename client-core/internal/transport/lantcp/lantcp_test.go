package lantcp

import (
	"bytes"
	"context"
	"crypto/ed25519"
	"crypto/rand"
	"io"
	"net"
	"net/netip"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/proto/deviceid"
)

type device struct {
	id   string
	link *Link
}

func newDevice(t *testing.T) device {
	t.Helper()
	pub, priv, err := ed25519.GenerateKey(rand.Reader)
	if err != nil {
		t.Fatal(err)
	}
	l, err := New(priv)
	if err != nil {
		t.Fatal(err)
	}
	return device{id: deviceid.For(pub), link: l}
}

var loopback = netip.MustParseAddr("127.0.0.1")

func TestSendThroughLink(t *testing.T) {
	sender, receiver := newDevice(t), newDevice(t)
	ln, err := receiver.link.Listen(loopback, sender.id)
	if err != nil {
		t.Fatal(err)
	}
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	data := make([]byte, 8<<20)
	_, _ = rand.Read(data)
	go func() {
		c, err := sender.link.Dial(ctx, ln.Addr(), receiver.id, "send:abc:1")
		if err != nil {
			t.Error(err)
			return
		}
		defer c.Close()
		if _, err := c.Write(data); err != nil {
			t.Error(err)
		}
	}()

	c, label, err := ln.Accept(ctx)
	if err != nil {
		t.Fatal(err)
	}
	defer c.Close()
	if label != "send:abc:1" {
		t.Fatalf("label = %q", label)
	}
	got, err := io.ReadAll(c)
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(got, data) {
		t.Fatalf("收到 %d 字节，内容不一致", len(got))
	}

	// 只接一次：端口已经关了
	if _, err := net.DialTimeout("tcp", ln.Addr(), time.Second); err == nil {
		t.Fatal("接过一次之后端口还开着")
	}
}

// 不是那台设备的连接被断开，端口继续等真正的那台
func TestRejectsOtherDevices(t *testing.T) {
	sender, receiver, stranger := newDevice(t), newDevice(t), newDevice(t)
	ln, err := receiver.link.Listen(loopback, sender.id)
	if err != nil {
		t.Fatal(err)
	}
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	type result struct {
		label string
		err   error
	}
	accepted := make(chan result, 1)
	go func() {
		c, label, err := ln.Accept(ctx)
		if c != nil {
			c.Close()
		}
		accepted <- result{label, err}
	}()

	if c, err := stranger.link.Dial(ctx, ln.Addr(), receiver.id, "send:x:1"); err == nil {
		// TLS 1.3 里客户端证书在服务器那边才校验，客户端这一侧可能先“成功”；读一下就会发现被断开
		_ = c.SetReadDeadline(time.Now().Add(3 * time.Second))
		if _, err := c.Read(make([]byte, 1)); err == nil {
			t.Fatal("陌生设备的连接没有被断开")
		}
		c.Close()
	}
	// 发送方认错了接收方，也连不上
	if _, err := sender.link.Dial(ctx, ln.Addr(), stranger.id, "send:x:1"); err == nil {
		t.Fatal("接收方身份不对时还能连上")
	}

	c, err := sender.link.Dial(ctx, ln.Addr(), receiver.id, "send:ok:2")
	if err != nil {
		t.Fatal(err)
	}
	defer c.Close()
	r := <-accepted
	if r.err != nil || r.label != "send:ok:2" {
		t.Fatalf("accept = %q, %v", r.label, r.err)
	}
}

func TestAcceptStopsWithContext(t *testing.T) {
	sender, receiver := newDevice(t), newDevice(t)
	ln, err := receiver.link.Listen(loopback, sender.id)
	if err != nil {
		t.Fatal(err)
	}
	ctx, cancel := context.WithTimeout(context.Background(), 200*time.Millisecond)
	defer cancel()
	start := time.Now()
	if _, _, err := ln.Accept(ctx); err == nil {
		t.Fatal("没有连接时 Accept 不该成功")
	}
	if time.Since(start) > 3*time.Second {
		t.Fatal("ctx 结束后 Accept 没有及时返回")
	}
}

func TestDialFailsFast(t *testing.T) {
	sender, receiver := newDevice(t), newDevice(t)
	ln, err := receiver.link.Listen(loopback, sender.id)
	if err != nil {
		t.Fatal(err)
	}
	addr := ln.Addr()
	ln.Close()
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()
	if _, err := sender.link.Dial(ctx, addr, receiver.id, "send:x:1"); err == nil {
		t.Fatal("端口关了还能连上")
	}
}
