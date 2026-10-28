package webshare

import (
	"crypto/rand"
	"encoding/base64"
	"encoding/binary"
	"encoding/json"
	"errors"
	"sync"
	"time"

	"golang.org/x/crypto/nacl/secretbox"
)

// 网页只能走 http，浏览器的 crypto.subtle 用不了，所以内容用 secretbox（XSalsa20-Poly1305）加密，
// 网页那边用 tweetnacl-js 的 nacl.secretbox，两边的格式完全相同：24 字节随机 nonce 后接密文。
// 密钥只在二维码网址的 # 后面出现，浏览器不会把它发给服务器（design/phone-sync.md 2.4 节）。

const (
	keySize   = 32
	nonceSize = 24
	// replayWindow 内的请求必须带不同的 rid；时间戳与本机相差超过它的请求一律拒绝
	replayWindow = 2 * time.Minute
)

var (
	errDecrypt = errors.New("解密失败")
	errStale   = errors.New("请求的时间不对或已经处理过")
)

type key = [keySize]byte

func newKey() key {
	var k key
	if _, err := rand.Read(k[:]); err != nil {
		panic(err) // 系统随机源坏了，没法继续
	}
	return k
}

func randomID(n int) string {
	b := make([]byte, n)
	if _, err := rand.Read(b); err != nil {
		panic(err)
	}
	return b64(b)
}

func b64(b []byte) string { return base64.RawURLEncoding.EncodeToString(b) }

func unb64(s string) ([]byte, error) { return base64.RawURLEncoding.DecodeString(s) }

func keyFromBytes(b []byte) (key, bool) {
	var k key
	if len(b) != keySize {
		return k, false
	}
	copy(k[:], b)
	return k, true
}

// seal 加密一段数据，返回 nonce‖密文。
func seal(k *key, plain []byte) []byte {
	var nonce [nonceSize]byte
	if _, err := rand.Read(nonce[:]); err != nil {
		panic(err)
	}
	return secretbox.Seal(nonce[:], plain, &nonce, k)
}

// open 解开 seal 的结果。密文被改过、或者不是用这把密钥加密的，都返回 errDecrypt。
func open(k *key, msg []byte) ([]byte, error) {
	if len(msg) < nonceSize+secretbox.Overhead {
		return nil, errDecrypt
	}
	var nonce [nonceSize]byte
	copy(nonce[:], msg[:nonceSize])
	plain, ok := secretbox.Open(nil, msg[nonceSize:], &nonce, k)
	if !ok {
		return nil, errDecrypt
	}
	return plain, nil
}

// request 是网页发来的一次调用，整个 JSON 在加密之后传输。
type request struct {
	// TS 是网页按服务器时间校正后的毫秒时间戳，RID 是这次请求的随机标识，两者一起防重放
	TS     int64           `json:"ts"`
	RID    string          `json:"rid"`
	Method string          `json:"m"`
	Args   json.RawMessage `json:"a,omitempty"`
}

// replayGuard 记下 replayWindow 内见过的 rid。
//
// 不用递增序号：同一台手机可能开着几个标签页，刷新页面后序号也会从头开始。
// 时间戳加随机 rid 足够挡住同一网络里的人把截下来的请求原样再发一次。
type replayGuard struct {
	mu   sync.Mutex
	seen map[string]time.Time
}

func newReplayGuard() *replayGuard { return &replayGuard{seen: make(map[string]time.Time)} }

// check 检查一次请求：relaxed 时不看时间戳（hello 要先拿到服务器时间才能校正），只看 rid。
func (g *replayGuard) check(now time.Time, ts int64, rid string, relaxed bool) error {
	if len(rid) < 8 || len(rid) > 64 {
		return errStale
	}
	if !relaxed {
		d := now.Sub(time.UnixMilli(ts))
		if d < -replayWindow || d > replayWindow {
			return errStale
		}
	}
	g.mu.Lock()
	defer g.mu.Unlock()
	for id, at := range g.seen {
		if now.Sub(at) > replayWindow {
			delete(g.seen, id)
		}
	}
	if _, dup := g.seen[rid]; dup {
		return errStale
	}
	g.seen[rid] = now
	return nil
}

// chunkHeader 是上传一块数据时附在数据前面的说明：4 字节大端长度，后接这段 JSON，再接数据本身。
// 说明和数据一起加密，块号因此也受认证保护，换块、截断都会解密失败或对不上。
type chunkHeader struct {
	TS     int64  `json:"ts"`
	RID    string `json:"rid"`
	Upload string `json:"u"`
	Index  int64  `json:"n"`
}

func splitChunk(plain []byte) (chunkHeader, []byte, error) {
	var h chunkHeader
	if len(plain) < 4 {
		return h, nil, errDecrypt
	}
	n := binary.BigEndian.Uint32(plain[:4])
	if n == 0 || int(n) > len(plain)-4 || n > 4096 {
		return h, nil, errDecrypt
	}
	if err := json.Unmarshal(plain[4:4+n], &h); err != nil {
		return h, nil, errDecrypt
	}
	return h, plain[4+n:], nil
}
