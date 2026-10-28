package webshare

import (
	"archive/zip"
	"bufio"
	"bytes"
	"context"
	"encoding/binary"
	"encoding/json"
	"io"
	"log/slog"
	"net/http"
	"net/http/httptest"
	"net/netip"
	"net/url"
	"os"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/clipboard"
	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// fakeEngine 按 sync.Engine 的样子把提交的内容落库，文件就记它的路径。
type fakeEngine struct {
	db        *store.Store
	mu        sync.Mutex
	submitted []clipboard.Content
	applied   []bool
	onRecord  func(id string)
}

func (f *fakeEngine) SubmitLocal(_ context.Context, c clipboard.Content, via string, applyLocal bool) (store.Clip, error) {
	f.mu.Lock()
	f.submitted = append(f.submitted, c)
	f.applied = append(f.applied, applyLocal)
	f.mu.Unlock()
	now := time.Now()
	clip := store.Clip{ID: randomID(9), Status: store.StatusReady, OriginDeviceID: "self", OriginDeviceName: "MacBook",
		Outgoing: true, Via: via, CreatedAt: now, ExpiresAt: now.Add(time.Hour)}
	switch c.Kind {
	case clipboard.KindText:
		clip.Kind, clip.TextContent, clip.TextPreview = store.KindText, c.Text, c.Text
	case clipboard.KindFile:
		clip.Kind, clip.SourcePaths = store.KindFile, c.Files
		for _, p := range c.Files {
			info, _ := os.Stat(p)
			clip.Items = append(clip.Items, store.Item{Name: filepath.Base(p), Size: info.Size(), IsDir: info.IsDir()})
		}
	}
	if err := f.db.PutClip(clip); err != nil {
		return store.Clip{}, err
	}
	if f.onRecord != nil {
		f.onRecord(clip.ID)
	}
	return clip, nil
}

func (f *fakeEngine) LocalPaths(id string) ([]string, error) {
	c, err := f.db.GetClip(id)
	if err != nil {
		return nil, err
	}
	return c.SourcePaths, nil
}

func (f *fakeEngine) SearchHistory(q string, limit int, flt store.Filter) ([]store.Clip, error) {
	return f.db.SearchRecords(q, limit, flt)
}

func (f *fakeEngine) ImagePreview(_ context.Context, id string, _ int) (string, string, int, error) {
	paths, err := f.LocalPaths(id)
	if err != nil || len(paths) == 0 {
		return "", "", 0, io.EOF
	}
	return paths[0], "", 1, nil
}

type fixture struct {
	srv      *Server
	db       *store.Store
	engine   *fakeEngine
	receive  string
	base     string
	now      *time.Time
	nowMu    *sync.Mutex
	events   chan *pb.Event
	changed  chan *pb.WebShareStatus
	protects int
}

func newFixture(t *testing.T) *fixture {
	t.Helper()
	dir := t.TempDir()
	db, err := store.Open(filepath.Join(dir, "test.db"))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { db.Close() })
	f := &fixture{db: db, receive: filepath.Join(dir, "Downloads"), events: make(chan *pb.Event, 64),
		changed: make(chan *pb.WebShareStatus, 64), nowMu: &sync.Mutex{}}
	now := time.Now()
	f.now = &now
	f.engine = &fakeEngine{db: db, onRecord: func(id string) {
		f.events <- &pb.Event{Payload: &pb.Event_ClipAdded{ClipAdded: &pb.ClipRecord{Id: id}}}
	}}
	cfg := config.Default()
	cfg.ReceiveDir = f.receive
	f.srv = New(Options{
		Logger:     slog.New(slog.NewTextHandler(io.Discard, nil)),
		Store:      db,
		Engine:     f.engine,
		LoadConfig: func() config.Config { return cfg },
		DeviceName: func() string { return "MacBook" },
		Subscribe: func() (<-chan *pb.Event, func()) {
			return f.events, func() {}
		},
		LocalAddrs: func() []netip.Addr { return []netip.Addr{netip.MustParseAddr("127.0.0.1")} },
		Protect: func(b []byte) ([]byte, error) {
			f.protects++
			return append([]byte("sealed:"), b...), nil
		},
		Unprotect: func(b []byte) ([]byte, error) { return bytes.TrimPrefix(b, []byte("sealed:")), nil },
		OnChanged: func(st *pb.WebShareStatus) {
			select {
			case f.changed <- st:
			default:
			}
		},
		WorkDir: filepath.Join(dir, "work"),
		Port:    -1,
		Now: func() time.Time {
			f.nowMu.Lock()
			defer f.nowMu.Unlock()
			return *f.now
		},
	})
	f.srv.SetEnabled(true)
	t.Cleanup(f.srv.Close)
	st := f.srv.Status()
	if !st.GetListening() {
		t.Fatalf("没有开始监听：%v", st.GetError())
	}
	f.base = "http://127.0.0.1:" + strconv.Itoa(int(st.GetPort()))
	return f
}

func (f *fixture) advance(d time.Duration) {
	f.nowMu.Lock()
	*f.now = f.now.Add(d)
	f.nowMu.Unlock()
}

// client 是测试里的网页：和 web/app.js 说同样的协议。
type client struct {
	t    *testing.T
	base string
	sid  string
	key  key
	now  func() time.Time
}

func (f *fixture) invite(t *testing.T) (id string, k key) {
	t.Helper()
	inv, err := f.srv.NewInvite("")
	if err != nil {
		t.Fatal(err)
	}
	u, err := url.Parse(inv.GetUrl())
	if err != nil {
		t.Fatal(err)
	}
	if u.Host != strings.TrimPrefix(f.base, "http://") {
		t.Fatalf("二维码网址 %q 的地址不对，应为 %s", inv.GetUrl(), f.base)
	}
	frag, err := url.ParseQuery(u.Fragment)
	if err != nil {
		t.Fatal(err)
	}
	raw, err := unb64(frag.Get("k"))
	if err != nil {
		t.Fatal(err)
	}
	k, ok := keyFromBytes(raw)
	if !ok {
		t.Fatal("二维码里的密钥长度不对")
	}
	return frag.Get("i"), k
}

func (f *fixture) claim(t *testing.T, name string) *client {
	t.Helper()
	id, k := f.invite(t)
	c := &client{t: t, base: f.base, key: k, now: f.srv.opts.Now}
	var info helloInfo
	if code := c.rpcAt("/api/rpc?i="+id, "hello", map[string]string{"name": name}, &info); code != "" {
		t.Fatalf("扫码登记失败：%s", code)
	}
	if info.Session == "" || info.Key == "" || info.Device != "MacBook" || info.Name != name {
		t.Fatalf("登记的回复 = %+v", info)
	}
	raw, _ := unb64(info.Key)
	c.key, _ = keyFromBytes(raw)
	c.sid = info.Session
	return c
}

func (c *client) envelope(method string, args any) []byte {
	a, _ := json.Marshal(args)
	data, _ := json.Marshal(request{TS: c.now().UnixMilli(), RID: randomID(12), Method: method, Args: a})
	return data
}

func (c *client) post(path string, body []byte) (*http.Response, []byte) {
	c.t.Helper()
	resp, err := http.Post(c.base+path, "application/octet-stream", bytes.NewReader(body))
	if err != nil {
		c.t.Fatal(err)
	}
	defer resp.Body.Close()
	data, _ := io.ReadAll(resp.Body)
	return resp, data
}

// rpcAt 发一次调用，返回错误码（空表示成功），结果解进 out。
func (c *client) rpcAt(path, method string, args, out any) string {
	c.t.Helper()
	return c.rawRPC(path, c.envelope(method, args), out)
}

func (c *client) rawRPC(path string, plain []byte, out any) string {
	c.t.Helper()
	resp, data := c.post(path, seal(&c.key, plain))
	if resp.Header.Get("Content-Type") == "application/json" {
		var e struct {
			Err string `json:"err"`
		}
		_ = json.Unmarshal(data, &e)
		return e.Err
	}
	plainRep, err := open(&c.key, data)
	if err != nil {
		c.t.Fatalf("解不开回复：%v", err)
	}
	var rep struct {
		OK   bool            `json:"ok"`
		R    json.RawMessage `json:"r"`
		Code string          `json:"err"`
	}
	if err := json.Unmarshal(plainRep, &rep); err != nil {
		c.t.Fatal(err)
	}
	if !rep.OK {
		return rep.Code
	}
	if out != nil {
		if err := json.Unmarshal(rep.R, out); err != nil {
			c.t.Fatal(err)
		}
	}
	return ""
}

func (c *client) rpc(method string, args, out any) string {
	c.t.Helper()
	return c.rpcAt("/api/rpc?s="+c.sid, method, args, out)
}

func (c *client) chunk(upload string, n int64, data []byte) string {
	c.t.Helper()
	h, _ := json.Marshal(chunkHeader{TS: c.now().UnixMilli(), RID: randomID(12), Upload: upload, Index: n})
	plain := make([]byte, 4, 4+len(h)+len(data))
	binary.BigEndian.PutUint32(plain, uint32(len(h)))
	plain = append(append(plain, h...), data...)
	return c.rawRPC("/api/chunk?s="+c.sid, plain, nil)
}

func (c *client) fetch(method string, args any) ([]byte, string) {
	c.t.Helper()
	resp, data := c.post("/api/fetch?s="+c.sid, seal(&c.key, c.envelope(method, args)))
	if resp.Header.Get("Content-Type") == "application/json" {
		return nil, "plain:" + string(data)
	}
	plain, err := open(&c.key, data)
	if err != nil || len(plain) == 0 {
		c.t.Fatalf("解不开下载的回复：%v", err)
	}
	if plain[0] == 1 {
		var e struct {
			Code string `json:"err"`
		}
		_ = json.Unmarshal(plain[1:], &e)
		return nil, e.Code
	}
	return plain[1:], ""
}

func TestInviteIsSingleUseAndBecomesAPrivateSession(t *testing.T) {
	f := newFixture(t)
	id, k := f.invite(t)
	first := &client{t: t, base: f.base, key: k, now: f.srv.opts.Now}
	var info helloInfo
	if code := first.rpcAt("/api/rpc?i="+id, "hello", map[string]string{"name": "iPhone"}, &info); code != "" {
		t.Fatalf("第一次扫码：%s", code)
	}
	if info.Key == b64(k[:]) {
		t.Error("登记后的会话密钥不应和二维码里的一样")
	}
	for found := false; !found; {
		select {
		case st := <-f.changed:
			if st.GetInviteUsed() == "" {
				continue // 打开开关时的那一条
			}
			found = true
			if st.GetInviteUsed() != id || len(st.GetSessions()) != 1 || st.GetSessions()[0].GetName() != "iPhone" {
				t.Errorf("登记后的状态 = %v", st)
			}
		case <-time.After(time.Second):
			t.Fatal("登记后没有通知界面")
		}
	}
	second := &client{t: t, base: f.base, key: k, now: f.srv.opts.Now}
	if code := second.rpcAt("/api/rpc?i="+id, "hello", map[string]string{"name": "别人的手机"}, nil); code != "invite_used" {
		t.Errorf("同一个二维码第二次扫：%q，应为 invite_used", code)
	}
	w, err := f.db.WebSession(info.Session)
	if err != nil || !bytes.HasPrefix(w.Key, []byte("sealed:")) {
		t.Errorf("会话密钥应加密后落盘：%q, %v", w.Key, err)
	}
}

func TestInviteExpiresAndClosingTheWindowRevokesIt(t *testing.T) {
	f := newFixture(t)
	id, k := f.invite(t)
	f.advance(inviteTTL + time.Second)
	c := &client{t: t, base: f.base, key: k, now: f.srv.opts.Now}
	if code := c.rpcAt("/api/rpc?i="+id, "hello", nil, nil); code != "invite_used" {
		t.Errorf("过期的二维码：%q", code)
	}
	id2, k2 := f.invite(t)
	f.srv.CloseInvite(id2)
	c2 := &client{t: t, base: f.base, key: k2, now: f.srv.opts.Now}
	if code := c2.rpcAt("/api/rpc?i="+id2, "hello", nil, nil); code != "invite_used" {
		t.Errorf("窗口关掉后的二维码：%q", code)
	}
}

func TestTextAndRecords(t *testing.T) {
	f := newFixture(t)
	c := f.claim(t, "iPhone")
	var rec webRecord
	if code := c.rpc("text", map[string]string{"text": "从手机发来的"}, &rec); code != "" {
		t.Fatal(code)
	}
	if rec.Kind != "text" || rec.Text != "从手机发来的" || !rec.Mine || rec.From != "iPhone" {
		t.Errorf("发出的记录 = %+v", rec)
	}
	if len(f.engine.applied) != 1 || !f.engine.applied[0] {
		t.Error("网页发来的文字应按设置写进电脑的剪贴板（applyLocal）")
	}
	// 电脑本机复制的、别的设备发来的
	now := time.Now()
	for _, c := range []store.Clip{
		{ID: "mine", Kind: store.KindText, Status: store.StatusReady, Outgoing: true, TextContent: "电脑上复制的", CreatedAt: now.Add(-time.Minute), ExpiresAt: now.Add(time.Hour)},
		{ID: "peer", Kind: store.KindFile, Status: store.StatusRemoteOnly, OriginDeviceName: "办公室台式机", Items: []store.Item{{Name: "大文件.zip", Size: 1 << 30}}, CreatedAt: now.Add(-2 * time.Minute), ExpiresAt: now.Add(time.Hour)},
	} {
		if err := f.db.PutClip(c); err != nil {
			t.Fatal(err)
		}
	}
	var page struct {
		Records []webRecord `json:"records"`
		More    bool        `json:"more"`
	}
	if code := c.rpc("records", map[string]int{"limit": 2}, &page); code != "" {
		t.Fatal(code)
	}
	if len(page.Records) != 2 || !page.More || page.Records[0].Text != "从手机发来的" || page.Records[1].From != "MacBook" || page.Records[1].Mine {
		t.Fatalf("第一页 = %+v", page)
	}
	if code := c.rpc("records", map[string]any{"limit": 2, "before": page.Records[1].At}, &page); code != "" {
		t.Fatal(code)
	}
	if len(page.Records) != 1 || page.More || page.Records[0].Status != "remote" || page.Records[0].From != "办公室台式机" {
		t.Fatalf("第二页 = %+v", page)
	}
	if code := c.rpc("text", map[string]string{"text": "   "}, nil); code != "empty" {
		t.Errorf("空文字：%q", code)
	}
}

func TestLongTextIsFetchedSeparately(t *testing.T) {
	f := newFixture(t)
	c := f.claim(t, "iPhone")
	long := strings.Repeat("长", inlineTextMax)
	var rec webRecord
	if code := c.rpc("text", map[string]string{"text": long}, &rec); code != "" {
		t.Fatal(code)
	}
	if !rec.Long || rec.Text != "" {
		t.Fatalf("长文字不应随记录发：long=%v len=%d", rec.Long, len(rec.Text))
	}
	var full struct {
		Text string `json:"text"`
	}
	if code := c.rpc("full_text", map[string]string{"clip": rec.ID}, &full); code != "" || full.Text != long {
		t.Errorf("加载全文：%q，长度 %d", code, len(full.Text))
	}
}

func TestUploadInChunks(t *testing.T) {
	f := newFixture(t)
	c := f.claim(t, "Android 手机")
	data := bytes.Repeat([]byte("0123456789"), chunkSize/10*2+500) // 两块多一点
	var st struct {
		Upload string `json:"upload"`
	}
	if code := c.rpc("upload_start", map[string]any{"name": "../../IMG_0001.jpg", "size": len(data)}, &st); code != "" {
		t.Fatal(code)
	}
	parts := [][]byte{data[:chunkSize], data[chunkSize : 2*chunkSize], data[2*chunkSize:]}
	if code := c.chunk(st.Upload, 2, parts[2]); code != "" { // 乱序
		t.Fatal(code)
	}
	if code := c.chunk(st.Upload, 0, parts[0]); code != "" {
		t.Fatal(code)
	}
	if code := c.chunk(st.Upload, 0, parts[0]); code != "" { // 重复
		t.Fatal(code)
	}
	if code := c.chunk(st.Upload, 1, parts[1][:100]); code != "bad_request" {
		t.Errorf("长度不对的块：%q", code)
	}
	if code := c.chunk(st.Upload, 3, parts[2]); code != "bad_request" {
		t.Errorf("超出范围的块：%q", code)
	}
	if code := c.rpc("upload_done", map[string]any{"uploads": []string{st.Upload}}, nil); code != "incomplete" {
		t.Errorf("没传完就结束：%q", code)
	}
	if code := c.chunk(st.Upload, 1, parts[1]); code != "" {
		t.Fatal(code)
	}
	var rec webRecord
	if code := c.rpc("upload_done", map[string]any{"uploads": []string{st.Upload}}, &rec); code != "" {
		t.Fatal(code)
	}
	got, err := os.ReadFile(filepath.Join(f.receive, "IMG_0001.jpg"))
	if err != nil || !bytes.Equal(got, data) {
		t.Fatalf("收到的文件不对：%d 字节，%v", len(got), err)
	}
	if info, err := os.Stat(filepath.Join(f.receive, "IMG_0001.jpg")); err != nil || info.Mode().Perm() != 0o644 {
		t.Errorf("收到的文件权限 = %v，应为 0644", info.Mode().Perm())
	}
	if rec.Kind != "file" || !rec.Mine || len(rec.Items) != 1 || rec.Items[0].Name != "IMG_0001.jpg" {
		t.Errorf("文件记录 = %+v", rec)
	}

	// 同名再传一次：改名，不覆盖
	if code := c.rpc("upload_start", map[string]any{"name": "IMG_0001.jpg", "size": 3}, &st); code != "" {
		t.Fatal(code)
	}
	if code := c.chunk(st.Upload, 0, []byte("abc")); code != "" {
		t.Fatal(code)
	}
	if code := c.rpc("upload_done", map[string]any{"uploads": []string{st.Upload}}, nil); code != "" {
		t.Fatal(code)
	}
	if got, err := os.ReadFile(filepath.Join(f.receive, "IMG_0001 (1).jpg")); err != nil || string(got) != "abc" {
		t.Errorf("重名的文件：%q, %v", got, err)
	}
	// 别的手机碰不到这次上传
	other := f.claim(t, "别的手机")
	if code := other.rpc("upload_start", map[string]any{"name": "x", "size": 1}, &st); code != "" {
		t.Fatal(code)
	}
	if code := c.chunk(st.Upload, 0, []byte("x")); code != "upload_gone" {
		t.Errorf("往别的手机的上传里写：%q", code)
	}
}

func TestDownloadFileAndFolder(t *testing.T) {
	f := newFixture(t)
	c := f.claim(t, "iPhone")
	src := t.TempDir()
	file := filepath.Join(src, "报告.pdf")
	content := bytes.Repeat([]byte("p"), chunkSize+10)
	if err := os.WriteFile(file, content, 0o600); err != nil {
		t.Fatal(err)
	}
	folder := filepath.Join(src, "照片")
	if err := os.MkdirAll(filepath.Join(folder, "子目录"), 0o700); err != nil {
		t.Fatal(err)
	}
	_ = os.WriteFile(filepath.Join(folder, "a.txt"), []byte("A"), 0o600)
	_ = os.WriteFile(filepath.Join(folder, "子目录", "b.txt"), []byte("B"), 0o600)
	_ = os.Symlink("/etc/passwd", filepath.Join(folder, "link"))
	clip, err := f.engine.SubmitLocal(context.Background(), clipboard.Content{Kind: clipboard.KindFile, Files: []string{file, folder}}, "", false)
	if err != nil {
		t.Fatal(err)
	}

	var info struct {
		Name   string `json:"name"`
		Size   int64  `json:"size"`
		Chunks int64  `json:"chunks"`
		Zip    bool   `json:"zip"`
		Mime   string `json:"mime"`
	}
	if code := c.rpc("file_info", map[string]any{"clip": clip.ID, "item": 0}, &info); code != "" {
		t.Fatal(code)
	}
	if info.Name != "报告.pdf" || info.Size != int64(len(content)) || info.Chunks != 2 || info.Zip || info.Mime != "application/pdf" {
		t.Fatalf("文件信息 = %+v", info)
	}
	var got []byte
	for n := int64(0); n < info.Chunks; n++ {
		part, code := c.fetch("chunk", map[string]any{"clip": clip.ID, "item": 0, "n": n})
		if code != "" {
			t.Fatal(code)
		}
		got = append(got, part...)
	}
	if !bytes.Equal(got, content) {
		t.Errorf("下载的内容不对：%d 字节", len(got))
	}

	if code := c.rpc("file_info", map[string]any{"clip": clip.ID, "item": 1}, &info); code != "" {
		t.Fatal(code)
	}
	if !info.Zip || info.Name != "照片.zip" {
		t.Fatalf("文件夹信息 = %+v", info)
	}
	var zipped []byte
	for n := int64(0); n < info.Chunks; n++ {
		part, code := c.fetch("chunk", map[string]any{"clip": clip.ID, "item": 1, "n": n})
		if code != "" {
			t.Fatal(code)
		}
		zipped = append(zipped, part...)
	}
	zr, err := zip.NewReader(bytes.NewReader(zipped), int64(len(zipped)))
	if err != nil {
		t.Fatal(err)
	}
	names := map[string]bool{}
	for _, zf := range zr.File {
		names[zf.Name] = true
	}
	if !names["照片/a.txt"] || !names["照片/子目录/b.txt"] || names["照片/link"] {
		t.Errorf("压缩包里的文件 = %v（符号链接不应打包进去）", names)
	}
	if _, code := c.fetch("chunk", map[string]any{"clip": clip.ID, "item": 0, "n": 5}); code != "bad_request" {
		t.Errorf("超出范围的块：%q", code)
	}
	if _, code := c.fetch("chunk", map[string]any{"clip": "nope", "item": 0, "n": 0}); code != "gone" {
		t.Errorf("不存在的记录：%q", code)
	}
}

func TestReplayAndStaleRequestsAreRejected(t *testing.T) {
	f := newFixture(t)
	c := f.claim(t, "iPhone")
	plain := c.envelope("text", map[string]string{"text": "只发一次"})
	if code := c.rawRPC("/api/rpc?s="+c.sid, plain, nil); code != "" {
		t.Fatal(code)
	}
	if code := c.rawRPC("/api/rpc?s="+c.sid, plain, nil); code != "stale" {
		t.Errorf("原样重发：%q，应为 stale", code)
	}
	if n := len(f.engine.submitted); n != 1 {
		t.Errorf("重发的请求被处理了：提交了 %d 次", n)
	}
	old := c.envelope("records", nil)
	f.advance(replayWindow + time.Second)
	if code := c.rawRPC("/api/rpc?s="+c.sid, old, nil); code != "stale" {
		t.Errorf("过时的请求：%q", code)
	}
}

func TestWrongKeyUnknownSessionAndRateLimit(t *testing.T) {
	f := newFixture(t)
	c := f.claim(t, "iPhone")
	bad := &client{t: t, base: f.base, sid: c.sid, key: newKey(), now: f.srv.opts.Now}
	if code := bad.rpc("records", nil, nil); code != "bad_key" {
		t.Errorf("密钥不对：%q", code)
	}
	ghost := &client{t: t, base: f.base, sid: "nope", key: newKey(), now: f.srv.opts.Now}
	if code := ghost.rpc("records", nil, nil); code != "unknown_session" {
		t.Errorf("没登记的会话：%q", code)
	}
	for i := 0; i < 20; i++ {
		bad.rpc("records", nil, nil)
	}
	if code := c.rpc("records", nil, nil); code != "too_many" {
		t.Errorf("失败太多次之后同一来源：%q，应被暂时拒绝", code)
	}
	f.advance(6 * time.Minute)
	if code := c.rpc("records", nil, nil); code != "" {
		t.Errorf("过了五分钟还被拒绝：%q", code)
	}
}

func TestOnlyLocalSourcesAreAccepted(t *testing.T) {
	f := newFixture(t)
	h := f.srv.Handler()
	for _, c := range []struct {
		addr string
		ok   bool
	}{
		{"192.168.1.20:5000", true}, {"10.1.2.3:5000", true}, {"100.101.1.2:5000", true},
		{"[fe80::1]:5000", true}, {"8.8.8.8:5000", false}, {"[2001:db8::1]:5000", false},
	} {
		req := httptest.NewRequest(http.MethodGet, "/", nil)
		req.RemoteAddr = c.addr
		rec := httptest.NewRecorder()
		h.ServeHTTP(rec, req)
		if ok := rec.Code == http.StatusOK; ok != c.ok {
			t.Errorf("%s：状态 %d", c.addr, rec.Code)
		}
	}
}

func TestEventsStreamNewRecordsAndCloseOnRemoval(t *testing.T) {
	f := newFixture(t)
	c := f.claim(t, "iPhone")
	token := b64(seal(&c.key, c.envelope("events", nil)))
	resp, err := http.Get(f.base + "/api/events?s=" + c.sid + "&t=" + url.QueryEscape(token))
	if err != nil {
		t.Fatal(err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK || resp.Header.Get("Content-Type") != "text/event-stream" {
		t.Fatalf("事件流：%d %s", resp.StatusCode, resp.Header.Get("Content-Type"))
	}
	lines := make(chan string, 16)
	go func() {
		sc := bufio.NewScanner(resp.Body)
		for sc.Scan() {
			lines <- sc.Text()
		}
		close(lines)
	}()
	time.Sleep(50 * time.Millisecond) // 等订阅登记好
	var rec webRecord
	if code := c.rpc("text", map[string]string{"text": "推给网页"}, &rec); code != "" {
		t.Fatal(code)
	}
	deadline := time.After(3 * time.Second)
	for got := false; !got; {
		select {
		case line, ok := <-lines:
			if !ok {
				t.Fatal("事件流提前结束")
			}
			data, found := strings.CutPrefix(line, "data: ")
			if !found {
				continue
			}
			raw, _ := unb64(data)
			plain, err := open(&c.key, raw)
			if err != nil {
				t.Fatal(err)
			}
			var ev webEvent
			_ = json.Unmarshal(plain, &ev)
			if ev.Type == "rec" && ev.Record.ID == rec.ID && ev.Record.Text == "推给网页" && ev.Record.Mine {
				got = true
			}
		case <-deadline:
			t.Fatal("没收到新记录的事件")
		}
	}
	if err := f.srv.RemoveSession(c.sid); err != nil {
		t.Fatal(err)
	}
	for {
		select {
		case _, ok := <-lines:
			if !ok {
				if code := c.rpc("records", nil, nil); code != "unknown_session" {
					t.Errorf("移除后再请求：%q", code)
				}
				return
			}
		case <-time.After(3 * time.Second):
			t.Fatal("移除手机后事件流没有断开")
		}
	}
}

func TestDisableStopsListeningAndKeepsSessions(t *testing.T) {
	f := newFixture(t)
	c := f.claim(t, "iPhone")
	f.srv.SetEnabled(false)
	if st := f.srv.Status(); st.GetListening() || len(st.GetSessions()) != 1 {
		t.Fatalf("关掉后：listening=%v sessions=%d", st.GetListening(), len(st.GetSessions()))
	}
	if _, err := http.Get(f.base + "/"); err == nil {
		t.Error("关掉后端口还能连上")
	}
	if _, err := f.srv.NewInvite(""); err == nil {
		t.Error("关掉后还能生成二维码")
	}
	f.srv.SetEnabled(true)
	st := f.srv.Status()
	c.base = "http://127.0.0.1:" + strconv.Itoa(int(st.GetPort()))
	if code := c.rpc("records", nil, nil); code != "" {
		t.Errorf("重新打开后已登记的手机：%q", code)
	}
}

func TestSessionsIdleFor30DaysAreRemoved(t *testing.T) {
	f := newFixture(t)
	c := f.claim(t, "iPhone")
	f.advance(sessionIdle + time.Hour)
	f.srv.expireSessions()
	if code := c.rpc("records", nil, nil); code != "unknown_session" {
		t.Errorf("30 天没用的手机：%q", code)
	}
}

func TestSafeFileName(t *testing.T) {
	for in, want := range map[string]string{
		"../../etc/passwd": "passwd",
		`C:\Users\a\b.txt`: "b.txt",
		"  .hidden. ":      "hidden",
		"a<b>c?.txt":       "a_b_c_.txt",
		"":                 "file",
		"\x00\x01":         "__",
	} {
		if got := safeFileName(in); got != want {
			t.Errorf("safeFileName(%q) = %q，应为 %q", in, got, want)
		}
	}
}

func TestCleanName(t *testing.T) {
	if got := cleanName("  我的\x00 iPhone  "); got != "我的 iPhone" {
		t.Errorf("cleanName = %q", got)
	}
	if got := cleanName(" "); got != "手机" {
		t.Errorf("空名字 = %q", got)
	}
	if got := cleanName(strings.Repeat("长", 100)); len([]rune(got)) != maxNameLen {
		t.Errorf("超长名字截成了 %d 个字", len([]rune(got)))
	}
}

func TestRecordsFilterAndSearch(t *testing.T) {
	f := newFixture(t)
	c := f.claim(t, "iPhone")
	now := time.Now()
	for i, cl := range []store.Clip{
		{ID: "t", Kind: store.KindText, TextContent: "会议纪要", TextPreview: "会议纪要"},
		{ID: "l", Kind: store.KindText, TextContent: "https://example.com/report", TextPreview: "https://example.com/report"},
		{ID: "i", Kind: store.KindImage, TextPreview: "图片"},
		{ID: "f", Kind: store.KindFile, Items: []store.Item{{Name: "季度报告.pdf"}}, TextPreview: "季度报告.pdf"},
	} {
		cl.Status, cl.Outgoing = store.StatusReady, true
		cl.CreatedAt, cl.ExpiresAt = now.Add(-time.Duration(i)*time.Minute), now.Add(time.Hour)
		if err := f.db.PutClip(cl); err != nil {
			t.Fatal(err)
		}
	}
	ids := func(args map[string]any) []string {
		var page struct {
			Records []webRecord `json:"records"`
		}
		if code := c.rpc("records", args, &page); code != "" {
			t.Fatal(code)
		}
		var out []string
		for _, r := range page.Records {
			out = append(out, r.ID)
		}
		return out
	}
	for filter, want := range map[string]string{"all": "t,l,i,f", "text": "t", "link": "l", "image": "i", "file": "f"} {
		if got := strings.Join(ids(map[string]any{"filter": filter}), ","); got != want {
			t.Errorf("筛选 %s = %s，应为 %s", filter, got, want)
		}
	}
	if got := strings.Join(ids(map[string]any{"q": "报告"}), ","); got != "l,f" && got != "f,l" && got != "f" {
		t.Errorf("搜索「报告」= %s", got)
	}
	if got := strings.Join(ids(map[string]any{"q": "报告", "filter": "file"}), ","); got != "f" {
		t.Errorf("在文件里搜索「报告」= %s", got)
	}
}

// 网页是 web/phone 用 Vite 构建后嵌进来的：index.html 引用的每个文件都要在嵌入目录里，
// 防止改了网页源码却没重新构建、或者构建产物没一起提交。
func TestEmbeddedPageIsComplete(t *testing.T) {
	index, err := webFS.ReadFile("web/index.html")
	if err != nil {
		t.Fatal(err)
	}
	refs := regexp.MustCompile(`(?:src|href)="\./([^"]+)"`).FindAllStringSubmatch(string(index), -1)
	if len(refs) < 3 {
		t.Fatalf("index.html 里的引用太少：%v", refs)
	}
	scripts := 0
	for _, m := range refs {
		if _, err := webFS.ReadFile("web/" + m[1]); err != nil {
			t.Errorf("index.html 引用的 %s 不在嵌入目录里：先在 web/phone 里 npm run build", m[1])
		}
		if strings.HasSuffix(m[1], ".js") {
			scripts++
		}
	}
	if scripts == 0 {
		t.Error("index.html 没有引用脚本：嵌入的不是构建产物")
	}
	if bytes.Contains(index, []byte("<script>")) {
		t.Error("index.html 里有内联脚本，会被内容安全策略拦下")
	}
}
