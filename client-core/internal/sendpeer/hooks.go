package sendpeer

import (
	"context"
	"io"
	"log/slog"

	"github.com/baiyuze/pasteferry/client-core/internal/identity"
	"github.com/baiyuze/pasteferry/client-core/internal/peers"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/lantcp"
)

// ListenLAN 为对方这次发来的一批开一个临时 TCP 端口，返回给对方拨号的地址和等连接的函数。
type ListenLAN func(deviceID string) (addr string, accept func(context.Context) (io.ReadCloser, string, error), ok bool)

// DialLAN 连到对方给的地址，并写上数据流标签。
type DialLAN func(ctx context.Context, deviceID, addr, label string) (io.WriteCloser, error)

// LANHooks 把局域网快速通道（2.5.1，lantcp）接到隔空传送上，见 design/send-files-lan-tcp.md。
// 证书建不起来时两个函数都为空，隔空传送只用数据通道，与 2.5.0 相同。
func LANHooks(id *identity.Identity, peerMgr *peers.Manager) (ListenLAN, DialLAN) {
	link, err := lantcp.New(id.Signer())
	if err != nil {
		slog.Warn("局域网快速通道不可用", "err", err)
		return nil, nil
	}
	listen := func(deviceID string) (string, func(context.Context) (io.ReadCloser, string, error), bool) {
		if !peerMgr.HasFeature(deviceID, peers.FeatureSendFilesTCP) {
			slog.Info("对方不支持局域网快速通道，用数据通道", "device", deviceID)
			return "", nil, false
		}
		ip, ok := peerMgr.P2P().LANAddr(deviceID)
		if !ok {
			slog.Info("不是局域网直连，用数据通道", "device", deviceID)
			return "", nil, false
		}
		ln, err := link.Listen(ip, deviceID)
		if err != nil {
			slog.Info("开不了局域网快速通道的端口，用数据通道", "addr", ip, "err", err)
			return "", nil, false
		}
		return ln.Addr(), func(ctx context.Context) (io.ReadCloser, string, error) {
			c, label, err := ln.Accept(ctx)
			if err != nil {
				return nil, "", err
			}
			return c, label, nil
		}, true
	}
	dial := func(ctx context.Context, deviceID, addr, label string) (io.WriteCloser, error) {
		c, err := link.Dial(ctx, addr, deviceID, label)
		if err != nil {
			return nil, err
		}
		return c, nil
	}
	return listen, dial
}
