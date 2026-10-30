// Package sendpeer 把 peers.Manager 里某台设备的状态换成隔空传送要的 send.Peer，
// 以及「收不收它发来的文件」的判定。桌面守护进程和手机端都用这一份，两边的判定不会跑偏。
package sendpeer

import (
	"github.com/baiyuze/pasteferry/client-core/internal/peers"
	"github.com/baiyuze/pasteferry/client-core/internal/send"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// Peer 是隔空传送看到的某台设备：自己的设备或好友、陌生设备。
func Peer(peerMgr *peers.Manager, deviceID string) send.Peer {
	state := peerMgr.ConnState(deviceID)
	connected := state.Proto() == pb.ConnectionKind_CONNECTION_KIND_DIRECT ||
		state.Proto() == pb.ConnectionKind_CONNECTION_KIND_RELAY
	relayed := state.Proto() == pb.ConnectionKind_CONNECTION_KIND_RELAY
	switch peerMgr.Role(deviceID) {
	case peers.RoleSelf:
		_, list := peerMgr.Devices()
		for _, d := range list {
			if d.GetId() == deviceID {
				return send.Peer{
					Known: true, Name: d.GetName(), Online: d.GetOnline(), Role: peers.RoleSelf,
					Connected: connected, Relayed: relayed,
					Supported: d.GetReceivesFiles(), Disabled: d.GetReceiveDisabled(),
					Ask: peerMgr.HasFeature(deviceID, peers.FeatureSendAsk),
				}
			}
		}
	case peers.RoleFriend:
		if fr, ok := peerMgr.Friend(deviceID); ok {
			name := fr.GetDisplayName()
			if fr.GetDeviceName() != "" {
				name += " · " + fr.GetDeviceName()
			}
			return send.Peer{
				Known: true, Name: name, Online: fr.GetOnline(), Role: peers.RoleFriend,
				Connected: connected, Relayed: relayed,
				Supported: fr.GetReceivesFiles() || fr.GetReceiveDisabled(), Disabled: fr.GetReceiveDisabled(),
				Ask: peerMgr.HasFeature(deviceID, peers.FeatureSendAsk),
			}
		}
	case peers.RoleStranger:
		if st, ok := peerMgr.Stranger(deviceID); ok {
			return send.Peer{
				Known: true, Name: st.GetDisplayName(), Online: true, Role: peers.RoleStranger,
				Connected: connected, Relayed: relayed,
				Supported: peerMgr.HasFeature(deviceID, peers.FeatureSendFiles) || peerMgr.HasFeature(deviceID, peers.FeatureSendFilesOff),
				Disabled:  peerMgr.HasFeature(deviceID, peers.FeatureSendFilesOff),
				Ask:       peerMgr.HasFeature(deviceID, peers.FeatureSendAsk),
			}
		}
	}
	return send.Peer{}
}

// Admit 决定收不收某台电脑发来的文件：自己的设备看「接收文件」开关，别人看「允许这些人给我发文件」，
// 被屏蔽的陌生设备一律不收；打开了自动接收的好友不用问。
func Admit(peerMgr *peers.Manager, db *store.Store, deviceID string) send.Admission {
	role := peerMgr.Role(deviceID)
	if role == peers.RoleSelf {
		return send.Admission{Allowed: peerMgr.ReceivesFrom(deviceID), AutoAccept: true}
	}
	if db.IsBlocked(deviceID) {
		return send.Admission{}
	}
	a := send.Admission{Allowed: peerMgr.ReceivesFrom(deviceID)}
	if c, ok := peerMgr.FriendContact(deviceID); ok && role == peers.RoleFriend {
		a.AutoAccept = c.AutoAccept
	}
	return a
}
