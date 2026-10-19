package update

import (
	"crypto/ed25519"
	"encoding/base64"
)

// publicKeys 是验证更新清单签名的公钥。私钥只在发版用的 Mac 的钥匙串里（cmd/updatesign）。
// 换密钥时先把新公钥加在这里发一版，等多数用户更新后再去掉旧的。
var publicKeys = []string{
	"EWOfsEYPzDLBExiUJblZe26t+jhXNzKNY3CF8lNyvGE=",
}

// PublicKeys 返回编进程序的公钥。
func PublicKeys() []ed25519.PublicKey {
	var out []ed25519.PublicKey
	for _, k := range publicKeys {
		if b, err := base64.StdEncoding.DecodeString(k); err == nil && len(b) == ed25519.PublicKeySize {
			out = append(out, ed25519.PublicKey(b))
		}
	}
	return out
}
