package lan

import (
	"context"
	"errors"
	"net/netip"
	"sort"
	"time"

	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// 「所有人」模式（2.6.0，见 design/friends-send.md 第 9.1 节）：只在局域网里。
//
//   - 接收方打开「所有人」期间，广播里带 e=1 和名字（n、o，编码同「搜索附近设备」）；
//   - 发送方在隔空传送页上看到它们（Strangers），要发文件时先发一个签名的 stranger_request
//     （带自己的名片），对方开着「所有人」就回自己的签名信息和名片。两边从此认得对方的公钥，
//     之后的 P2P 连接、发文件、接收方的确认都与好友相同；
//   - 「所有人」关掉后，广播撤下，新的请求一律拒绝。

// strangerStale 是多久没再在 mDNS 里见到就不列出（mDNS 不报下线，这里只能宽一点）
const strangerStale = 10 * time.Minute

type everyoneState struct {
	name, platform string
}

// StrangerInstance 是附近一台开着「所有人」的设备。
type StrangerInstance struct {
	ID       string // mDNS 实例名
	Name     string
	Platform string
	// PeerID 非空表示这是已配对的设备或好友（按广播里的令牌认出来的）
	PeerID string
}

// ShowEveryone 打开「所有人」：在局域网里公开名字，接受陌生设备的请求。name 为空时撤下。
func (t *Transport) ShowEveryone(name, platform string) {
	t.mu.Lock()
	changed := false
	if name == "" {
		changed = t.everyone != nil
		t.everyone = nil
	} else {
		next := &everyoneState{name: name, platform: platform}
		changed = t.everyone == nil || *t.everyone != *next
		t.everyone = next
	}
	t.mu.Unlock()
	if changed {
		t.updateAdvert()
	}
}

func (t *Transport) everyoneAdvertLocked(text map[string]string) {
	if t.everyone == nil {
		return
	}
	text["e"] = "1"
	text["n"] = encodeNearbyName(t.everyone.name)
	if t.everyone.platform != "" {
		text["o"] = t.everyone.platform
	}
}

// Strangers 返回附近开着「所有人」的设备，按名字排序。
func (t *Transport) Strangers() []StrangerInstance {
	now := time.Now()
	t.mu.Lock()
	defer t.mu.Unlock()
	if !t.running {
		return nil
	}
	var out []StrangerInstance
	for id, si := range t.instances {
		if si.inst.Text["e"] != "1" || now.Sub(si.seen) > strangerStale {
			continue
		}
		name, ok := nearbyName(si.inst.Text)
		if !ok {
			continue
		}
		out = append(out, StrangerInstance{ID: id, Name: name, Platform: si.inst.Text["o"], PeerID: t.tokens[si.inst.Text["t"]]})
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].Name != out[j].Name {
			return out[i].Name < out[j].Name
		}
		return out[i].ID < out[j].ID
	})
	return out
}

// RequestStranger 向附近一台开着「所有人」的设备要它的公钥和名片，直到 ctx 结束。
func (t *Transport) RequestStranger(ctx context.Context, id string, card *pb.FriendCard) (PeerInfo, error) {
	if !t.Running() {
		return PeerInfo{}, ErrDisabled
	}
	targets := func() []netip.AddrPort {
		t.mu.Lock()
		defer t.mu.Unlock()
		return t.nearbyAddrsLocked(id)
	}
	if len(targets()) == 0 {
		return PeerInfo{}, ErrNotFound
	}
	req := t.selfPairInfo()
	req.Card = card
	peer, err := t.exchange(ctx, req, strangerRequest, targets, false)
	if errors.Is(err, ErrCodeClosed) {
		// 对方已经关掉了「所有人」
		return PeerInfo{}, ErrNotFound
	}
	return peer, err
}

func (t *Transport) handleStrangerRequest(ps *pb.LanPairSigned, src netip.AddrPort) {
	info, ok := t.openPairInfo(ps)
	if !ok || len(info.GetNonce()) < 8 || t.resendResponse(info.GetNonce(), src) {
		return
	}
	t.mu.Lock()
	open := t.everyone != nil
	t.mu.Unlock()
	if !open || t.opts.AcceptStranger == nil {
		t.reject(src, info.GetNonce(), "closed")
		return
	}
	peer := peerFromInfo(info, src)
	card := t.opts.AcceptStranger(peer)
	if card == nil {
		t.reject(src, info.GetNonce(), "closed")
		return
	}
	t.log.Info("「所有人」：附近的设备要给本机发文件", "peer", peer.Name, "src", src)
	t.respondPairFor(info, peer, src, IntentDevice, card)
}
