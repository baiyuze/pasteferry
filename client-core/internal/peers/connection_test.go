package peers

import (
	"context"
	"crypto/ed25519"
	"errors"
	"fmt"
	"path/filepath"
	"sync/atomic"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/identity"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/lan"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/p2p"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/signed"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// 已成为好友的一端仍会回复丢失的确认，但不能把对方的回执再无限回复。
func TestFriendConfirmationDoesNotEcho(t *testing.T) {
	network := lan.NewMemoryNetwork()
	a := newDevice(t, "a", network, lanOnly())
	id, err := identity.LoadOrCreate(filepath.Join(t.TempDir(), "identity.json"))
	if err != nil {
		t.Fatal(err)
	}
	a.m.mu.Lock()
	a.m.contacts[id.DeviceID] = store.Contact{ID: id.DeviceID, PublicKey: id.PublicKey}
	a.m.mu.Unlock()
	var confirmations atomic.Int32
	var remote *lan.Transport
	confirm := func() {
		msg, err := signed.Sign(id, a.id(), &pb.SignalMessage{Payload: &pb.SignalMessage_FriendConfirm{
			FriendConfirm: &pb.FriendConfirm{Accepted: true},
		}})
		if err == nil {
			_ = remote.Send(a.id(), msg)
		}
	}
	remote = lan.New(lan.Options{
		Identity: id, Port: -1, Discovery: network.Discovery(),
		Peers: func() []string { return []string{a.id()} },
		Verifier: signed.NewVerifier(id.DeviceID, func(peer string) ed25519.PublicKey {
			if peer == a.id() {
				return a.m.identity.PublicKey
			}
			return nil
		}),
		OnSignal: func(_ string, msg *pb.SignalMessage) {
			if msg.GetFriendConfirm().GetAccepted() {
				confirmations.Add(1)
				confirm() // 模拟对端收到确认后发回确认的旧行为。
			}
		},
	})
	if err := remote.Start(); err != nil {
		t.Fatal(err)
	}
	t.Cleanup(remote.Stop)
	waitLANUp(t, a)
	a.m.lan.Remember(id.DeviceID, []string{fmt.Sprintf("127.0.0.1:%d", remote.Port())})
	remote.Remember(a.id(), []string{fmt.Sprintf("127.0.0.1:%d", a.m.lan.Port())})
	waitFor(t, "双向局域网可达", func() bool {
		return a.m.lan.Reachable(id.DeviceID) && remote.Reachable(a.id())
	})
	confirm()
	waitFor(t, "收到确认回复", func() bool { return confirmations.Load() > 0 })
	time.Sleep(300 * time.Millisecond)
	if got := confirmations.Load(); got != 1 {
		t.Fatalf("确认回执循环了 %d 次", got)
	}
	// 对端可能丢失了第一次回复；它稍后重试时仍然能得到确认。
	time.Sleep(time.Second)
	confirm()
	waitFor(t, "重试确认得到回复", func() bool { return confirmations.Load() > 1 })
	time.Sleep(300 * time.Millisecond)
	if got := confirmations.Load(); got != 2 {
		t.Fatalf("重试后确认回执循环了 %d 次", got)
	}
}

func TestFriendConnectionRecovery(t *testing.T) {
	for _, trigger := range []string{"manual", "patrol", "restart", "presence", "lan"} {
		t.Run(trigger, func(t *testing.T) {
			network := lan.NewMemoryNetwork()
			a, events := newFriendDevice(t, "a", network, lanOnly())
			b, _ := newFriendDevice(t, "b", network, lanOnly())
			waitLANUp(t, a, b)
			addFriends(t, a, b, events)
			waitDirect(t, a, b)
			// 只让应答方触发恢复，验证它能请发起方重新发 offer。
			if a.id() < b.id() {
				a, b = b, a
			}
			a.m.P2P().Disconnect(b.id())
			b.m.P2P().Disconnect(a.id())
			a.m.touch(b.id())
			switch trigger {
			case "manual":
				ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
				defer cancel()
				kind, err := a.m.Reconnect(ctx, b.id())
				if err != nil || kind != pb.ConnectionKind_CONNECTION_KIND_DIRECT {
					t.Fatalf("好友重新连接: kind=%v err=%v", kind, err)
				}
			case "patrol":
				a.m.connectPending(context.Background())
			case "restart":
				a.m.handlePeerRestarted(b.id())
			case "presence":
				a.m.handlePresence(b.id(), true)
			case "lan":
				a.m.handleLANReachable(b.id(), true)
			}
			waitDirect(t, a, b)

			// 有意空闲断开的好友不能被巡检反复拉起。
			a.m.P2P().Disconnect(b.id())
			b.m.P2P().Disconnect(a.id())
			a.m.mu.Lock()
			a.m.lastUse[b.id()] = time.Now().Add(-2 * friendIdle)
			a.m.mu.Unlock()
			a.m.connectPending(context.Background())
			time.Sleep(100 * time.Millisecond)
			if got := a.m.P2P().State(b.id()); got != p2p.StateOffline {
				t.Fatalf("空闲好友被巡检重新连上: %v", got)
			}
		})
	}
}

func TestReconnectRejectsUnknownDevice(t *testing.T) {
	a := newDevice(t, "a", nil, lanOnly())
	if _, err := a.m.Reconnect(context.Background(), "unknown"); !errors.Is(err, ErrNotPaired) {
		t.Fatalf("不应连接陌生的设备 ID: %v", err)
	}
}

func TestFeaturesAcrossConnectionTransitions(t *testing.T) {
	for _, role := range []string{RoleSelf, RoleFriend} {
		t.Run(role, func(t *testing.T) {
			cfg := lanOnly()
			cfg.LANDisabled = true
			a := newDevice(t, "a", nil, cfg)
			const id = "peer"
			a.m.mu.Lock()
			if role == RoleSelf {
				d := store.Device{ID: id, Name: id, Platform: "windows", PublicKey: make([]byte, 32)}
				if err := a.m.store.PutDevice(d); err != nil {
					t.Fatal(err)
				}
				a.m.known[id] = d
			} else {
				a.m.contacts[id] = store.Contact{ID: id, Platform: "windows", PublicKey: make([]byte, 32)}
			}
			a.m.serverOnline[id] = true
			a.m.mu.Unlock()
			snapshot := func() (known, receives bool) {
				if role == RoleSelf {
					d := peerDevice(t, a, id)
					return d.GetFeaturesKnown(), d.GetReceivesFiles()
				}
				f, _ := a.m.Friend(id)
				return f.GetFeaturesKnown(), f.GetReceivesFiles()
			}

			a.m.handleP2PState(id, p2p.StateConnecting)
			firstEpoch := a.m.connectionEpoch[id]
			// 远端消息可早于本地的就绪回调到达。
			a.m.updatePeerFeatures(id, &pb.PeerFeatures{Features: []string{FeatureSendFiles, FeatureSendAsk}, AppVersion: "2.8.1"})
			a.m.handleP2PState(id, p2p.StateDirect)
			a.m.checkLegacy(id, firstEpoch)
			if known, receives := snapshot(); !known || !receives {
				t.Fatal("早到的现代版本声明被就绪回调清除了")
			}

			a.m.handleP2PState(id, p2p.StateOffline)
			a.m.handleP2PState(id, p2p.StateConnecting)
			a.m.handleP2PState(id, p2p.StateDirect)
			a.m.checkLegacy(id, firstEpoch)
			if _, receives := snapshot(); !receives {
				t.Fatal("上一轮连接的计时器影响了新连接")
			}
			// 本轮真的一直没有声明，才会判定旧版本。
			a.m.checkLegacy(id, a.m.connectionEpoch[id])
			if known, receives := snapshot(); !known || receives {
				t.Fatal("未识别出已连通但不声明功能的旧版本")
			}
			a.m.handleP2PState(id, p2p.StateOffline)
			a.m.handleP2PState(id, p2p.StateConnecting)
			if known, _ := snapshot(); known {
				t.Fatal("重新连接期间仍沿用了旧版本判定")
			}

			// 显式声明不支持之后，下一轮连接也要重新确认。
			a.m.updatePeerFeatures(id, &pb.PeerFeatures{AppVersion: "2.4.0"})
			a.m.handleP2PState(id, p2p.StateDirect)
			a.m.handleP2PState(id, p2p.StateOffline)
			if known, _ := snapshot(); known {
				t.Fatal("断线后仍把旧的负面声明当作当前能力")
			}
		})
	}
}
