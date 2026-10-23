package rpc

import (
	"testing"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
)

// 更新相关的两项设置要原样往返：界面每次保存都带全量设置，漏掉就会被清空。
func TestUpdateSettingsRoundTrip(t *testing.T) {
	c := config.Default()
	c.UpdateCheckDisabled = true
	c.UpdateSkipVersion = "2.3.1"
	got := configFromProto(configToProto(c), config.Default())
	if !got.UpdateCheckDisabled || got.UpdateSkipVersion != "2.3.1" {
		t.Fatalf("round trip lost update settings: %+v", got)
	}
	// 界面清空跳过的版本、重新打开自动检查
	in := configToProto(c)
	in.UpdateCheckDisabled, in.UpdateSkipVersion = false, ""
	got = configFromProto(in, c)
	if got.UpdateCheckDisabled || got.UpdateSkipVersion != "" {
		t.Fatalf("update settings not cleared: %+v", got)
	}
}

func TestSyncPolicyRoundTrip(t *testing.T) {
	c := config.Default()
	c.RealtimeSyncDisabled = true
	c.SyncBacklog = true
	c.SyncDisabledPeers = []string{"home", "office"}
	got := configFromProto(configToProto(c), config.Default())
	if !got.RealtimeSyncDisabled || !got.SyncBacklog || len(got.SyncDisabledPeers) != 2 || got.SyncDisabledPeers[0] != "home" {
		t.Fatalf("lost policy: %+v", got)
	}
	in := configToProto(config.Default())
	got = configFromProto(in, c)
	if got.RealtimeSyncDisabled || got.SyncBacklog || len(got.SyncDisabledPeers) != 0 {
		t.Fatalf("failed to clear policy: %+v", got)
	}
}
