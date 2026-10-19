// updatesign 给更新清单签名，发版时由 tools/release/manifest.py 调用。
//
//	updatesign -genkey          生成签名密钥：私钥存进 macOS 钥匙串，打印公钥（编进 internal/update/keys.go）
//	updatesign -sign FILE       用钥匙串里的私钥签名，写出 FILE.sig，并用程序内置的公钥回验
//	updatesign -verify FILE     只用内置公钥验证 FILE.sig
//
// 私钥只在钥匙串里（服务名 pasteferry-update-signing-key），不落地成文件、不打印。
// 丢了它就再也发不出能自动更新的版本：备份见 design/auto-update.md。
package main

import (
	"crypto/ed25519"
	"crypto/rand"
	"encoding/base64"
	"errors"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"strings"

	"github.com/baiyuze/pasteferry/client-core/internal/update"
)

const keychainService = "pasteferry-update-signing-key"

func main() {
	genkey := flag.Bool("genkey", false, "生成签名密钥并存进钥匙串")
	sign := flag.String("sign", "", "给这个文件签名")
	verify := flag.String("verify", "", "验证这个文件的签名")
	flag.Parse()
	var err error
	switch {
	case *genkey:
		err = genKey()
	case *sign != "":
		err = signFile(*sign)
	case *verify != "":
		err = verifyFile(*verify)
	default:
		flag.Usage()
		os.Exit(2)
	}
	if err != nil {
		fmt.Fprintln(os.Stderr, "错误:", err)
		os.Exit(1)
	}
}

func genKey() error {
	if _, err := loadKey(); err == nil {
		return errors.New("钥匙串里已经有签名密钥，不覆盖。确实要换密钥时先在「钥匙串访问」里删掉 " + keychainService)
	}
	pub, priv, err := ed25519.GenerateKey(rand.Reader)
	if err != nil {
		return err
	}
	seed := base64.StdEncoding.EncodeToString(priv.Seed())
	cmd := exec.Command("security", "add-generic-password", "-a", "pasteferry", "-s", keychainService,
		"-l", "PasteFerry update signing key", "-w", seed)
	if out, err := cmd.CombinedOutput(); err != nil {
		return fmt.Errorf("写入钥匙串: %v %s", err, out)
	}
	fmt.Println(base64.StdEncoding.EncodeToString(pub))
	return nil
}

func loadKey() (ed25519.PrivateKey, error) {
	out, err := exec.Command("security", "find-generic-password", "-s", keychainService, "-w").Output()
	if err != nil {
		return nil, errors.New("钥匙串里没有 " + keychainService)
	}
	seed, err := base64.StdEncoding.DecodeString(strings.TrimSpace(string(out)))
	if err != nil || len(seed) != ed25519.SeedSize {
		return nil, errors.New("钥匙串里的签名密钥格式不对")
	}
	return ed25519.NewKeyFromSeed(seed), nil
}

func signFile(path string) error {
	key, err := loadKey()
	if err != nil {
		return err
	}
	raw, err := os.ReadFile(path)
	if err != nil {
		return err
	}
	sig := base64.StdEncoding.EncodeToString(ed25519.Sign(key, raw)) + "\n"
	if err := update.Verify(raw, []byte(sig), update.PublicKeys()); err != nil {
		return errors.New("钥匙串里的私钥与程序内置的公钥不配对，签出的清单客户端不会认")
	}
	return os.WriteFile(path+".sig", []byte(sig), 0o644)
}

func verifyFile(path string) error {
	raw, err := os.ReadFile(path)
	if err != nil {
		return err
	}
	sig, err := os.ReadFile(path + ".sig")
	if err != nil {
		return err
	}
	if err := update.Verify(raw, sig, update.PublicKeys()); err != nil {
		return err
	}
	if _, err := update.Parse(raw); err != nil {
		return err
	}
	fmt.Println("签名正确")
	return nil
}
