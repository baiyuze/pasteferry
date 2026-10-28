package webshare

import (
	"context"
	"embed"
	"encoding/json"
	"errors"
	"io"
	"io/fs"
	"net/http"
	"strings"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/clipboard"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
)

//go:embed web
var webFS embed.FS

const (
	// chunkSize 是上传、下载一块的大小，网页按它切分文件
	chunkSize = 1 << 20
	// maxTextBytes 是一次能发的文字上限
	maxTextBytes = 1 << 20
	// maxDownloadBytes 是网页能下载的单个文件上限：网页要把整个文件解密后放进内存，
	// 再大手机浏览器可能撑不住（design/phone-sync.md 2.5.4 节，真机测过再定）
	maxDownloadBytes = 200 << 20
	// maxUploadBytes 是网页能上传的单个文件上限
	maxUploadBytes = 4 << 30
	maxRPCBody     = maxTextBytes + 64<<10
	maxChunkBody   = chunkSize + 8<<10
)

// apiError 是返回给网页的错误：code 给网页选文案，msg 是给人看的说明（中文，调试用）。
type apiError struct {
	code   string
	msg    string
	status int // 没有密钥、只能明文回复时用的 HTTP 状态码
}

func (e *apiError) Error() string { return e.msg }

func errCode(code, msg string) *apiError { return &apiError{code: code, msg: msg} }

var (
	errBadRequest = errCode("bad_request", "请求格式不对")
	errNotReady   = errCode("not_ready", "内容还没有下载到这台电脑")
	errGone       = errCode("gone", "内容已不在这台电脑上，可能已经过期")
	errTooLarge   = errCode("too_large", "内容太大")
)

// Handler 返回网页与接口。只接受局域网来源；解密失败太多的来源暂时拒绝。
func (s *Server) Handler() http.Handler {
	mux := http.NewServeMux()
	sub, _ := fs.Sub(webFS, "web")
	files := http.FileServer(http.FS(sub))
	mux.HandleFunc("GET /{$}", func(w http.ResponseWriter, r *http.Request) {
		// 网页不缓存：升级后台服务后要拿到新网页
		w.Header().Set("Cache-Control", "no-store")
		http.ServeFileFS(w, r, sub, "index.html")
	})
	mux.Handle("GET /", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path == "/index.html" {
			http.Redirect(w, r, "/", http.StatusMovedPermanently)
			return
		}
		if strings.HasPrefix(r.URL.Path, "/assets/") {
			// 构建产物的文件名带内容哈希，内容变了名字就变，可以一直缓存
			w.Header().Set("Cache-Control", "public, max-age=31536000, immutable")
		} else {
			w.Header().Set("Cache-Control", "no-cache")
		}
		files.ServeHTTP(w, r)
	}))
	mux.HandleFunc("POST /api/rpc", s.handleRPC)
	mux.HandleFunc("POST /api/chunk", s.handleChunk)
	mux.HandleFunc("POST /api/fetch", s.handleFetch)
	mux.HandleFunc("GET /api/events", s.handleEvents)
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		ip, ok := remoteIP(r)
		if !ok || !allowedSource(ip) {
			plainError(w, &apiError{code: "not_local", msg: "只接受局域网里的连接", status: http.StatusForbidden})
			return
		}
		if s.limits.blocked(ip, s.opts.Now()) {
			plainError(w, &apiError{code: "too_many", msg: "失败次数太多，稍后再试", status: http.StatusTooManyRequests})
			return
		}
		h := w.Header()
		h.Set("X-Content-Type-Options", "nosniff")
		h.Set("Referrer-Policy", "no-referrer")
		h.Set("X-Frame-Options", "DENY")
		h.Set("Content-Security-Policy", "default-src 'self'; img-src 'self' blob: data:; style-src 'self'; script-src 'self'; connect-src 'self'; frame-ancestors 'none'; base-uri 'none'; form-action 'none'")
		mux.ServeHTTP(w, r)
	})
}

func plainError(w http.ResponseWriter, e *apiError) {
	status := e.status
	if status == 0 {
		status = http.StatusBadRequest
	}
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Cache-Control", "no-store")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(map[string]string{"err": e.code})
}

func readBody(r *http.Request, limit int64) ([]byte, error) {
	body, err := io.ReadAll(io.LimitReader(r.Body, limit+1))
	if err != nil {
		return nil, err
	}
	if int64(len(body)) > limit {
		return nil, errTooLarge
	}
	return body, nil
}

func writeSealed(w http.ResponseWriter, k *key, plain []byte) {
	w.Header().Set("Content-Type", "application/octet-stream")
	w.Header().Set("Cache-Control", "no-store")
	_, _ = w.Write(seal(k, plain))
}

// reply 是加密前的回复：成功时带 r，失败时带 err 与 msg。
type reply struct {
	OK     bool   `json:"ok"`
	Result any    `json:"r,omitempty"`
	Code   string `json:"err,omitempty"`
	Msg    string `json:"msg,omitempty"`
}

func writeReply(w http.ResponseWriter, k *key, result any, err error) {
	rep := reply{OK: err == nil, Result: result}
	if err != nil {
		var ae *apiError
		if !errors.As(err, &ae) {
			ae = errCode("internal", err.Error())
		}
		rep.Result, rep.Code, rep.Msg = nil, ae.code, ae.msg
	}
	data, _ := json.Marshal(rep)
	writeSealed(w, k, data)
}

// authed 解开一次请求：找到会话、解密、校验时间戳与 rid。失败时已经写好了回复，返回 nil。
func (s *Server) authed(w http.ResponseWriter, r *http.Request, limit int64) (*session, []byte) {
	ip, _ := remoteIP(r)
	body, err := readBody(r, limit)
	if err != nil {
		plainError(w, errTooLarge)
		return nil, nil
	}
	sess, err := s.sessionByID(r.URL.Query().Get("s"))
	if err != nil {
		s.limits.fail(ip, s.opts.Now())
		plainError(w, &apiError{code: "unknown_session", msg: err.Error(), status: http.StatusUnauthorized})
		return nil, nil
	}
	plain, err := open(&sess.key, body)
	if err != nil {
		s.limits.fail(ip, s.opts.Now())
		plainError(w, &apiError{code: "bad_key", msg: err.Error(), status: http.StatusUnauthorized})
		return nil, nil
	}
	return sess, plain
}

func (s *Server) handleRPC(w http.ResponseWriter, r *http.Request) {
	if id := r.URL.Query().Get("i"); id != "" {
		s.handleClaim(w, r, id)
		return
	}
	sess, plain := s.authed(w, r, maxRPCBody)
	if sess == nil {
		return
	}
	var req request
	if err := json.Unmarshal(plain, &req); err != nil {
		writeReply(w, &sess.key, nil, errBadRequest)
		return
	}
	if err := s.guard.check(s.opts.Now(), req.TS, req.RID, req.Method == "hello"); err != nil {
		writeReply(w, &sess.key, nil, errCode("stale", err.Error()))
		return
	}
	s.touch(sess)
	result, err := s.dispatch(r.Context(), sess, req)
	writeReply(w, &sess.key, result, err)
}

// handleClaim 是扫码后的第一次连接：用二维码里的邀请密钥解密，换成这台手机专属的会话。
func (s *Server) handleClaim(w http.ResponseWriter, r *http.Request, inviteID string) {
	ip, _ := remoteIP(r)
	body, err := readBody(r, 64<<10)
	if err != nil {
		plainError(w, errTooLarge)
		return
	}
	inv, ok := s.inviteByID(inviteID)
	if !ok {
		s.limits.fail(ip, s.opts.Now())
		plainError(w, &apiError{code: "invite_used", msg: errInviteUsed.Error(), status: http.StatusUnauthorized})
		return
	}
	plain, err := open(&inv.key, body)
	if err != nil {
		s.limits.fail(ip, s.opts.Now())
		plainError(w, &apiError{code: "bad_key", msg: err.Error(), status: http.StatusUnauthorized})
		return
	}
	var req request
	var args struct {
		Name string `json:"name"`
	}
	if json.Unmarshal(plain, &req) != nil || req.Method != "hello" || (len(req.Args) > 0 && json.Unmarshal(req.Args, &args) != nil) {
		writeReply(w, &inv.key, nil, errBadRequest)
		return
	}
	if err := s.guard.check(s.opts.Now(), req.TS, req.RID, true); err != nil {
		writeReply(w, &inv.key, nil, errCode("stale", err.Error()))
		return
	}
	sess, err := s.claim(inv, args.Name)
	if errors.Is(err, errInviteUsed) {
		writeReply(w, &inv.key, nil, errCode("invite_used", err.Error()))
		return
	}
	if err != nil {
		writeReply(w, &inv.key, nil, err)
		return
	}
	info := s.helloInfo(sess)
	info.Session, info.Key = sess.id, b64(sess.key[:])
	writeReply(w, &inv.key, info, nil)
}

type helloInfo struct {
	// 第一次扫码时才有：这台手机以后用的会话与密钥，网页写回地址栏
	Session string `json:"sid,omitempty"`
	Key     string `json:"key,omitempty"`

	Device      string `json:"device"` // 电脑的名字
	Name        string `json:"name"`   // 这台手机的名字
	Now         int64  `json:"now"`    // 电脑的时间（毫秒），网页据此校正时间戳
	Chunk       int    `json:"chunk"`
	MaxDownload int64  `json:"maxDownload"`
	MaxUpload   int64  `json:"maxUpload"`
	MaxText     int    `json:"maxText"`
}

func (s *Server) helloInfo(sess *session) helloInfo {
	device := ""
	if s.opts.DeviceName != nil {
		device = s.opts.DeviceName()
	}
	return helloInfo{
		Device: device, Name: s.sessionName(sess), Now: s.opts.Now().UnixMilli(),
		Chunk: chunkSize, MaxDownload: maxDownloadBytes, MaxUpload: maxUploadBytes, MaxText: maxTextBytes,
	}
}

func (s *Server) dispatch(ctx context.Context, sess *session, req request) (any, error) {
	args := func(v any) error {
		if len(req.Args) == 0 {
			return nil
		}
		if err := json.Unmarshal(req.Args, v); err != nil {
			return errBadRequest
		}
		return nil
	}
	switch req.Method {
	case "hello":
		var a struct {
			Name string `json:"name"`
		}
		if err := args(&a); err != nil {
			return nil, err
		}
		if a.Name != "" {
			s.rename(sess, a.Name)
		}
		return s.helloInfo(sess), nil

	case "records":
		var a struct {
			Before int64  `json:"before"`
			Limit  int    `json:"limit"`
			Filter string `json:"filter"` // all / text / link / image / file，与桌面记录页的筛选相同
			Query  string `json:"q"`
		}
		if err := args(&a); err != nil {
			return nil, err
		}
		if a.Limit <= 0 || a.Limit > 100 {
			a.Limit = 30
		}
		var f store.Filter
		switch a.Filter {
		case "text":
			f.Text = true
		case "link":
			f.LinksOnly = true
		case "image":
			f.Kind = store.KindImage
		case "file":
			f.Kind = store.KindFile
		}
		var clips []store.Clip
		var err error
		more := false
		if q := strings.TrimSpace(a.Query); q != "" {
			// 搜索一次给出所有结果（最多 100 条），不分页，与桌面相同
			clips, err = s.opts.Engine.SearchHistory(q, 100, f)
		} else {
			before := time.Time{}
			if a.Before > 0 {
				before = time.UnixMilli(a.Before)
			}
			clips, err = s.opts.Store.ListRecords(a.Limit+1, before, f)
			if more = len(clips) > a.Limit; more {
				clips = clips[:a.Limit]
			}
		}
		if err != nil {
			return nil, err
		}
		name := s.sessionName(sess)
		out := make([]webRecord, 0, len(clips))
		for _, c := range clips {
			out = append(out, s.toWeb(c, name))
		}
		return map[string]any{"records": out, "more": more}, nil

	case "text":
		var a struct {
			Text string `json:"text"`
		}
		if err := args(&a); err != nil {
			return nil, err
		}
		if strings.TrimSpace(a.Text) == "" {
			return nil, errCode("empty", "没有要发送的文字")
		}
		if len(a.Text) > maxTextBytes {
			return nil, errTooLarge
		}
		clip, err := s.opts.Engine.SubmitLocal(ctx, clipboard.Content{Kind: clipboard.KindText, Text: a.Text}, s.sessionName(sess), true)
		if err != nil {
			return nil, err
		}
		return s.toWeb(clip, s.sessionName(sess)), nil

	case "own_copy":
		// 网页在自己的浏览器里复制了记录：把这次剪贴板变化忽略掉，不再记成一条新记录
		_ = s.opts.Engine.NoteOwnCopy(ctx)
		return nil, nil
	case "full_text":
		var a struct {
			Clip string `json:"clip"`
		}
		if err := args(&a); err != nil {
			return nil, err
		}
		c, err := s.opts.Store.GetClip(a.Clip)
		if err != nil || c.Favorite || (c.Kind != store.KindText && c.Kind != store.KindHTML) {
			return nil, errGone
		}
		return map[string]string{"text": recordText(c)}, nil

	case "upload_start":
		var a struct {
			Name string `json:"name"`
			Size int64  `json:"size"`
		}
		if err := args(&a); err != nil {
			return nil, err
		}
		if a.Size < 0 || a.Size > maxUploadBytes {
			return nil, errTooLarge
		}
		id, err := s.uploads.start(sess.id, a.Name, a.Size, s.opts.Now())
		if err != nil {
			return nil, err
		}
		return map[string]any{"upload": id, "chunk": chunkSize}, nil

	case "upload_cancel":
		var a struct {
			Upload string `json:"upload"`
		}
		if err := args(&a); err != nil {
			return nil, err
		}
		s.uploads.cancel(sess.id, a.Upload)
		return map[string]bool{}, nil

	case "upload_done":
		var a struct {
			Uploads []string `json:"uploads"`
		}
		if err := args(&a); err != nil {
			return nil, err
		}
		return s.finishUploads(ctx, sess, a.Uploads)

	case "file_info":
		var a struct {
			Clip string `json:"clip"`
			Item int    `json:"item"`
		}
		if err := args(&a); err != nil {
			return nil, err
		}
		f, err := s.downloadable(a.Clip, a.Item)
		if err != nil {
			return nil, err
		}
		chunks := (f.size + chunkSize - 1) / chunkSize
		return map[string]any{"name": f.name, "size": f.size, "chunks": chunks, "zip": f.zip, "mime": f.mime}, nil
	}
	return nil, errCode("unknown_method", "不认识的调用")
}

// handleChunk 收一块上传的数据。
func (s *Server) handleChunk(w http.ResponseWriter, r *http.Request) {
	sess, plain := s.authed(w, r, maxChunkBody)
	if sess == nil {
		return
	}
	h, data, err := splitChunk(plain)
	if err != nil {
		writeReply(w, &sess.key, nil, errBadRequest)
		return
	}
	if err := s.guard.check(s.opts.Now(), h.TS, h.RID, false); err != nil {
		writeReply(w, &sess.key, nil, errCode("stale", err.Error()))
		return
	}
	s.touch(sess)
	writeReply(w, &sess.key, map[string]bool{}, s.uploads.write(sess.id, h.Upload, h.Index, data, s.opts.Now()))
}

// handleFetch 取一块下载的数据或一张缩略图。回复解密后第一个字节是 0 时后面是数据，是 1 时后面是 JSON 错误。
func (s *Server) handleFetch(w http.ResponseWriter, r *http.Request) {
	sess, plain := s.authed(w, r, 64<<10)
	if sess == nil {
		return
	}
	fail := func(err error) {
		var ae *apiError
		if !errors.As(err, &ae) {
			ae = errCode("internal", err.Error())
		}
		data, _ := json.Marshal(reply{Code: ae.code, Msg: ae.msg})
		writeSealed(w, &sess.key, append([]byte{1}, data...))
	}
	var req request
	if err := json.Unmarshal(plain, &req); err != nil {
		fail(errBadRequest)
		return
	}
	if err := s.guard.check(s.opts.Now(), req.TS, req.RID, false); err != nil {
		fail(errCode("stale", err.Error()))
		return
	}
	s.touch(sess)
	var a struct {
		Clip  string `json:"clip"`
		Item  int    `json:"item"`
		Index int64  `json:"n"`
	}
	if len(req.Args) > 0 && json.Unmarshal(req.Args, &a) != nil {
		fail(errBadRequest)
		return
	}
	var data []byte
	var err error
	switch req.Method {
	case "thumb":
		data, err = s.thumbnail(r.Context(), a.Clip)
	case "chunk":
		data, err = s.readChunk(a.Clip, a.Item, a.Index)
	default:
		err = errCode("unknown_method", "不认识的调用")
	}
	if err != nil {
		fail(err)
		return
	}
	writeSealed(w, &sess.key, append([]byte{0}, data...))
}

// handleEvents 是推给网页的事件流（SSE）。EventSource 不能带请求体，凭据放在查询参数 t 里：
// 一段加密的 {ts, rid}，和其他请求一样校验。
func (s *Server) handleEvents(w http.ResponseWriter, r *http.Request) {
	ip, _ := remoteIP(r)
	sess, err := s.sessionByID(r.URL.Query().Get("s"))
	if err != nil {
		s.limits.fail(ip, s.opts.Now())
		plainError(w, &apiError{code: "unknown_session", msg: err.Error(), status: http.StatusUnauthorized})
		return
	}
	token, err := unb64(r.URL.Query().Get("t"))
	var req request
	if err == nil {
		var plain []byte
		if plain, err = open(&sess.key, token); err == nil {
			err = json.Unmarshal(plain, &req)
		}
	}
	if err != nil {
		s.limits.fail(ip, s.opts.Now())
		plainError(w, &apiError{code: "bad_key", msg: "凭据不对", status: http.StatusUnauthorized})
		return
	}
	if err := s.guard.check(s.opts.Now(), req.TS, req.RID, false); err != nil {
		plainError(w, &apiError{code: "stale", msg: err.Error(), status: http.StatusUnauthorized})
		return
	}
	flusher, ok := w.(http.Flusher)
	if !ok {
		plainError(w, errBadRequest)
		return
	}
	s.touch(sess)
	h := w.Header()
	h.Set("Content-Type", "text/event-stream")
	h.Set("Cache-Control", "no-store")
	h.Set("X-Accel-Buffering", "no")
	w.WriteHeader(http.StatusOK)
	_, _ = io.WriteString(w, ": ok\n\n")
	flusher.Flush()

	client := s.events.add(sess.id)
	defer s.events.remove(client)
	heartbeat := time.NewTicker(20 * time.Second)
	defer heartbeat.Stop()
	for {
		select {
		case <-r.Context().Done():
			return
		case <-client.done:
			return
		case <-heartbeat.C:
			if _, err := io.WriteString(w, ": ping\n\n"); err != nil {
				return
			}
			flusher.Flush()
		case ev := <-client.ch:
			data, err := s.eventJSON(ev, s.sessionName(sess))
			if err != nil {
				continue
			}
			if _, err := io.WriteString(w, "data: "+b64(seal(&sess.key, data))+"\n\n"); err != nil {
				return
			}
			flusher.Flush()
		}
	}
}

