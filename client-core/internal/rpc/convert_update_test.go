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
