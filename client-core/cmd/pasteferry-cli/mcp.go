package main

import (
	"bufio"
	"bytes"
	"context"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/rpc"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// pasteferry-cli mcp：stdio 上的 MCP 服务，让 AI 读、校验、保存、应用主题（design/mcp.md）。
//
// 一行一条 JSON-RPC 2.0 消息。stdout 只写协议消息，日志写 stderr。只提供主题与背景图，
// 不碰复制记录、设备、好友。每次调用工具时才连后台服务：AI 客户端常常比后台服务先启动，
// 后台服务重启后也不用重开会话。

// 支持的协议版本，新的在前。客户端要的版本在这里面就照它回，否则回最新的
var mcpVersions = []string{"2025-06-18", "2025-03-26"}

const mcpInstructions = `PasteFerry themes. A theme is a JSON document (call theme_schema for the format and what every color role is used for). ` +
	`Typical flow: theme_list → theme_get a built-in theme with resolved=true as a starting point → write a new theme with your own id and "base" set to that theme, overriding only what you change → theme_validate → fix any contrast warnings → theme_save → theme_apply. ` +
	`Built-in themes ("default", "pixel") cannot be overwritten. Background images must be imported first with background_import, then referenced as "user:<sha256>"; ` +
	`the image fills the whole window behind the pages, and the scenery is hidden while it shows. ` +
	`To replace only the scenery (the strip behind the page header and the picture at the bottom of the sidebar, pixel art in the pixel theme), import pictures the same way and set scene.header / scene.sidebar.`

// themeClient 是 MCP 用到的那几个 RPC；测试里换成假的
type themeClient interface {
	GetConfig(ctx context.Context, in *pb.Empty, opts ...grpc.CallOption) (*pb.Config, error)
	UpdateConfig(ctx context.Context, in *pb.Config, opts ...grpc.CallOption) (*pb.Config, error)
	ListThemes(ctx context.Context, in *pb.Empty, opts ...grpc.CallOption) (*pb.ListThemesResponse, error)
	GetTheme(ctx context.Context, in *pb.GetThemeRequest, opts ...grpc.CallOption) (*pb.ThemeJson, error)
	PutTheme(ctx context.Context, in *pb.PutThemeRequest, opts ...grpc.CallOption) (*pb.PutThemeResponse, error)
	DeleteTheme(ctx context.Context, in *pb.ThemeRef, opts ...grpc.CallOption) (*pb.Empty, error)
	ImportBackground(ctx context.Context, in *pb.ImportBackgroundRequest, opts ...grpc.CallOption) (*pb.BackgroundInfo, error)
	AnalyzeBackground(ctx context.Context, in *pb.BackgroundRef, opts ...grpc.CallOption) (*pb.BackgroundInfo, error)
}

// dialer 连上后台服务，返回带认证 token 的 context 与关闭连接的函数
type dialer func() (themeClient, context.Context, func(), error)

func daemonDialer(paths config.Paths) dialer {
	return func() (themeClient, context.Context, func(), error) {
		ep, err := rpc.ReadEndpoint(paths.Endpoint)
		if err != nil {
			if os.IsNotExist(err) {
				return nil, nil, nil, errors.New("PasteFerry's background service is not running. Open the PasteFerry app (or start the service) and try again")
			}
			return nil, nil, nil, err
		}
		conn, err := grpc.NewClient(fmt.Sprintf("127.0.0.1:%d", ep.Port), grpc.WithTransportCredentials(insecure.NewCredentials()))
		if err != nil {
			return nil, nil, nil, fmt.Errorf("connect to the background service: %w", err)
		}
		ctx := metadata.AppendToOutgoingContext(context.Background(), "x-pasteferry-token", ep.Token)
		return pb.NewDaemonServiceClient(conn), ctx, func() { conn.Close() }, nil
	}
}

type mcpServer struct {
	dial     dialer
	out      io.Writer
	log      io.Writer
	mu       sync.Mutex // 写 stdout
	protocol string
}

type rpcRequest struct {
	JSONRPC string          `json:"jsonrpc"`
	ID      json.RawMessage `json:"id,omitempty"`
	Method  string          `json:"method"`
	Params  json.RawMessage `json:"params,omitempty"`
}

type rpcError struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
}

type rpcResponse struct {
	JSONRPC string          `json:"jsonrpc"`
	ID      json.RawMessage `json:"id"`
	Result  any             `json:"result,omitempty"`
	Error   *rpcError       `json:"error,omitempty"`
}

const (
	errParse          = -32700
	errInvalidRequest = -32600
	errMethodNotFound = -32601
	errInvalidParams  = -32602
)

func serveMCP(in io.Reader, out, log io.Writer, dial dialer) error {
	s := &mcpServer{dial: dial, out: out, log: log, protocol: mcpVersions[0]}
	sc := bufio.NewScanner(in)
	// 背景图可以 base64 直接给，一行可能很长
	sc.Buffer(make([]byte, 64<<10), 96<<20)
	for sc.Scan() {
		line := bytes.TrimSpace(sc.Bytes())
		if len(line) == 0 {
			continue
		}
		if line[0] == '[' {
			// 2025-03-26 允许批量；2025-06-18 去掉了，照样处理不报错
			var batch []json.RawMessage
			if err := json.Unmarshal(line, &batch); err != nil || len(batch) == 0 {
				s.write(rpcResponse{JSONRPC: "2.0", ID: json.RawMessage("null"), Error: &rpcError{errParse, "parse error"}})
				continue
			}
			var replies []rpcResponse
			for _, m := range batch {
				if r, ok := s.handle(m); ok {
					replies = append(replies, r)
				}
			}
			if len(replies) > 0 {
				s.write(replies)
			}
			continue
		}
		if r, ok := s.handle(line); ok {
			s.write(r)
		}
	}
	return sc.Err()
}

func (s *mcpServer) write(v any) {
	data, err := json.Marshal(v)
	if err != nil {
		fmt.Fprintln(s.log, "mcp: encode:", err)
		return
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	s.out.Write(append(data, '\n'))
}

// handle 处理一条消息。通知（没有 id）不回复，第二个返回值为 false
func (s *mcpServer) handle(raw []byte) (rpcResponse, bool) {
	var req rpcRequest
	if err := json.Unmarshal(raw, &req); err != nil {
		return rpcResponse{JSONRPC: "2.0", ID: json.RawMessage("null"), Error: &rpcError{errParse, "parse error"}}, true
	}
	notification := len(req.ID) == 0
	if req.JSONRPC != "2.0" || req.Method == "" {
		if notification {
			return rpcResponse{}, false
		}
		return rpcResponse{JSONRPC: "2.0", ID: req.ID, Error: &rpcError{errInvalidRequest, "invalid request"}}, true
	}
	if notification {
		// notifications/initialized、notifications/cancelled 等：不需要做什么
		return rpcResponse{}, false
	}
	result, rerr := s.dispatch(req.Method, req.Params)
	resp := rpcResponse{JSONRPC: "2.0", ID: req.ID}
	if rerr != nil {
		resp.Error = rerr
	} else {
		resp.Result = result
	}
	return resp, true
}

func (s *mcpServer) dispatch(method string, params json.RawMessage) (any, *rpcError) {
	switch method {
	case "initialize":
		var p struct {
			ProtocolVersion string `json:"protocolVersion"`
		}
		_ = json.Unmarshal(params, &p)
		s.protocol = mcpVersions[0]
		for _, v := range mcpVersions {
			if v == p.ProtocolVersion {
				s.protocol = v
			}
		}
		return map[string]any{
			"protocolVersion": s.protocol,
			"capabilities": map[string]any{
				"tools":     map[string]any{"listChanged": false},
				"resources": map[string]any{"listChanged": false, "subscribe": false},
			},
			"serverInfo":   map[string]any{"name": "pasteferry", "title": "PasteFerry", "version": version},
			"instructions": mcpInstructions,
		}, nil
	case "ping":
		return map[string]any{}, nil
	case "tools/list":
		return map[string]any{"tools": mcpTools()}, nil
	case "tools/call":
		var p struct {
			Name      string          `json:"name"`
			Arguments json.RawMessage `json:"arguments"`
		}
		if err := json.Unmarshal(params, &p); err != nil || p.Name == "" {
			return nil, &rpcError{errInvalidParams, "tools/call needs a tool name"}
		}
		tool, ok := toolHandlers[p.Name]
		if !ok {
			return nil, &rpcError{errInvalidParams, fmt.Sprintf("unknown tool %q", p.Name)}
		}
		args := map[string]any{}
		if len(p.Arguments) > 0 && string(p.Arguments) != "null" {
			if err := json.Unmarshal(p.Arguments, &args); err != nil {
				return nil, &rpcError{errInvalidParams, "arguments must be a JSON object"}
			}
		}
		data, err := tool(s, args)
		return s.toolResult(data, err), nil
	case "resources/list":
		return s.listResources(), nil
	case "resources/templates/list":
		return map[string]any{"resourceTemplates": []any{map[string]any{
			"uriTemplate": "pasteferry://themes/{id}",
			"name":        "theme",
			"title":       "PasteFerry theme",
			"description": "A theme as saved (base not merged in). Use theme_get with resolved=true for the complete theme.",
			"mimeType":    "application/json",
		}}}, nil
	case "resources/read":
		var p struct {
			URI string `json:"uri"`
		}
		if err := json.Unmarshal(params, &p); err != nil || p.URI == "" {
			return nil, &rpcError{errInvalidParams, "resources/read needs a uri"}
		}
		return s.readResource(p.URI)
	}
	return nil, &rpcError{errMethodNotFound, fmt.Sprintf("method %q not found", method)}
}

// toolResult 把工具的结果包成 MCP 的 CallToolResult。工具出错不算协议错误：isError 加一句人能读的话
func (s *mcpServer) toolResult(data any, err error) map[string]any {
	if err != nil {
		return map[string]any{
			"content": []any{map[string]any{"type": "text", "text": describeRPCError(err)}},
			"isError": true,
		}
	}
	text, _ := json.MarshalIndent(data, "", "  ")
	out := map[string]any{"content": []any{map[string]any{"type": "text", "text": string(text)}}, "isError": false}
	// 2025-06-18 起有结构化结果；它必须是对象
	if s.protocol >= "2025-06-18" {
		if _, ok := data.(map[string]any); ok {
			out["structuredContent"] = data
		}
	}
	return out
}

// describeRPCError 把 gRPC 错误换成给 AI 看的话：后台服务的消息本来就是给人看的，去掉状态码前缀
func describeRPCError(err error) string {
	st, ok := status.FromError(err)
	if !ok {
		return err.Error()
	}
	switch st.Code() {
	case codes.Unavailable:
		return "Cannot reach PasteFerry's background service. Make sure PasteFerry is running, then try again."
	case codes.Unauthenticated:
		return "The background service rejected the connection. Restart PasteFerry and try again."
	case codes.Unimplemented:
		return "This version of PasteFerry does not support themes. Update PasteFerry and try again."
	case codes.DeadlineExceeded:
		return "The background service did not answer in time. Try again."
	}
	return st.Message()
}

// call 连上后台服务、执行 f、断开。每次调用都重新连：后台服务重启后照样能用
func (s *mcpServer) call(timeout time.Duration, f func(context.Context, themeClient) (any, error)) (any, error) {
	client, ctx, closeConn, err := s.dial()
	if err != nil {
		return nil, err
	}
	defer closeConn()
	ctx, cancel := context.WithTimeout(ctx, timeout)
	defer cancel()
	return f(ctx, client)
}

// ───────────────────────────── 资源 ─────────────────────────────

const schemaURI = "pasteferry://themes/schema"

func (s *mcpServer) listResources() map[string]any {
	resources := []any{map[string]any{
		"uri":         schemaURI,
		"name":        "theme-schema",
		"title":       "PasteFerry theme format",
		"description": "JSON Schema of a PasteFerry theme, with what every color role is used for and which contrast it must reach.",
		"mimeType":    "application/schema+json",
	}}
	// 后台服务没开时只列格式说明
	list, err := s.call(5*time.Second, func(ctx context.Context, c themeClient) (any, error) {
		return c.ListThemes(ctx, &pb.Empty{})
	})
	if err == nil {
		for _, t := range list.(*pb.ListThemesResponse).GetThemes() {
			resources = append(resources, map[string]any{
				"uri":         "pasteferry://themes/" + t.GetId(),
				"name":        t.GetId(),
				"title":       themeTitle(t),
				"description": themeDescription(t),
				"mimeType":    "application/json",
			})
		}
	} else {
		fmt.Fprintln(s.log, "mcp: list themes:", describeRPCError(err))
	}
	return map[string]any{"resources": resources}
}

func themeTitle(t *pb.ThemeInfo) string {
	if n := t.GetName()["en"]; n != "" {
		return n
	}
	return t.GetId()
}

func themeDescription(t *pb.ThemeInfo) string {
	if t.GetBuiltin() {
		return "Built-in theme (read-only)."
	}
	base := t.GetBase()
	if base == "" {
		base = "default"
	}
	return "Custom theme based on " + base + "."
}

func (s *mcpServer) readResource(uri string) (any, *rpcError) {
	contents := func(mime, text string) map[string]any {
		return map[string]any{"contents": []any{map[string]any{"uri": uri, "mimeType": mime, "text": text}}}
	}
	if uri == schemaURI {
		data, _ := json.MarshalIndent(themeSchema(), "", "  ")
		return contents("application/schema+json", string(data)), nil
	}
	id, ok := strings.CutPrefix(uri, "pasteferry://themes/")
	if !ok || id == "" || strings.Contains(id, "/") {
		return nil, &rpcError{-32002, "resource not found: " + uri}
	}
	got, err := s.call(5*time.Second, func(ctx context.Context, c themeClient) (any, error) {
		return c.GetTheme(ctx, &pb.GetThemeRequest{Id: id})
	})
	if err != nil {
		if status.Code(err) == codes.NotFound {
			return nil, &rpcError{-32002, "resource not found: " + uri}
		}
		return nil, &rpcError{-32603, describeRPCError(err)}
	}
	return contents("application/json", got.(*pb.ThemeJson).GetJson()), nil
}

// ───────────────────────────── 工具 ─────────────────────────────

type toolHandler func(s *mcpServer, args map[string]any) (any, error)

var toolHandlers = map[string]toolHandler{
	"theme_list":         toolThemeList,
	"theme_get":          toolThemeGet,
	"theme_schema":       func(*mcpServer, map[string]any) (any, error) { return themeSchema(), nil },
	"theme_validate":     func(s *mcpServer, args map[string]any) (any, error) { return putTheme(s, args, true) },
	"theme_save":         func(s *mcpServer, args map[string]any) (any, error) { return putTheme(s, args, false) },
	"theme_apply":        toolThemeApply,
	"theme_delete":       toolThemeDelete,
	"background_import":  toolBackgroundImport,
	"background_analyze": toolBackgroundAnalyze,
}

func obj(props map[string]any, required ...string) map[string]any {
	o := map[string]any{"type": "object", "properties": props, "additionalProperties": false}
	if len(required) > 0 {
		o["required"] = required
	}
	return o
}

func mcpTools() []any {
	themeArg := map[string]any{
		"type":        []string{"object", "string"},
		"description": "The theme document (a JSON object, or the same as a JSON string). Format: theme_schema. It needs schema=1 and your own id; set base to the theme you start from and include only what you change.",
	}
	readOnly := map[string]any{"readOnlyHint": true, "openWorldHint": false}
	return []any{
		map[string]any{
			"name":        "theme_list",
			"title":       "List themes",
			"description": "List the built-in and custom themes, plus which theme is in use, the light/dark mode setting and whether the CRT scanline effect is on.",
			"inputSchema": obj(map[string]any{}),
			"annotations": readOnly,
		},
		map[string]any{
			"name":        "theme_get",
			"title":       "Get a theme",
			"description": "Get one theme as JSON. With resolved=true (default) its base is merged in, so every color role and option is present — use this to see a built-in theme's exact values before deriving your own.",
			"inputSchema": obj(map[string]any{
				"id":       map[string]any{"type": "string", "description": "Theme id from theme_list, e.g. \"default\" or \"pixel\"."},
				"resolved": map[string]any{"type": "boolean", "description": "Merge the base theme in (default true). false returns the theme exactly as saved.", "default": true},
			}, "id"),
			"annotations": readOnly,
		},
		map[string]any{
			"name":        "theme_schema",
			"title":       "Theme format",
			"description": "JSON Schema of a theme. Explains every color role (where it appears and which contrast it must reach), shapes, fonts, motion and background options. Read this before writing a theme.",
			"inputSchema": obj(map[string]any{}),
			"annotations": readOnly,
		},
		map[string]any{
			"name":        "theme_validate",
			"title":       "Check a theme",
			"description": "Check a theme without saving it: format errors come back as an error; contrast problems come back as warnings (foreground/background role, actual ratio, required minimum). Fix warnings before saving.",
			"inputSchema": obj(map[string]any{"theme": themeArg}, "theme"),
			"annotations": readOnly,
		},
		map[string]any{
			"name":        "theme_save",
			"title":       "Save a theme",
			"description": "Save a custom theme (creates it or replaces the custom theme with the same id). Returns its id and any contrast warnings. Built-in theme ids cannot be used. Saving does not switch to it; call theme_apply.",
			"inputSchema": obj(map[string]any{"theme": themeArg}, "theme"),
			"annotations": map[string]any{"readOnlyHint": false, "destructiveHint": false, "idempotentHint": true, "openWorldHint": false},
		},
		map[string]any{
			"name":        "theme_apply",
			"title":       "Use a theme",
			"description": "Switch PasteFerry to a theme on this device. The main window, Quick Paste and the phone app update immediately. Optionally also set light/dark mode.",
			"inputSchema": obj(map[string]any{
				"id":   map[string]any{"type": "string", "description": "Theme id from theme_list."},
				"mode": map[string]any{"type": "string", "enum": []string{"system", "light", "dark"}, "description": "Light/dark mode. Omit to keep the current setting."},
			}, "id"),
			"annotations": map[string]any{"readOnlyHint": false, "destructiveHint": false, "idempotentHint": true, "openWorldHint": false},
		},
		map[string]any{
			"name":        "theme_delete",
			"title":       "Delete a theme",
			"description": "Delete a custom theme. If it is in use, PasteFerry switches back to the default theme. Fails for built-in themes and for themes other themes use as their base.",
			"inputSchema": obj(map[string]any{"id": map[string]any{"type": "string", "description": "Custom theme id."}}, "id"),
			"annotations": map[string]any{"readOnlyHint": false, "destructiveHint": true, "idempotentHint": true, "openWorldHint": false},
		},
		map[string]any{
			"name":        "background_import",
			"title":       "Import a background image",
			"description": "Import an image from a file on this computer or from base64 data (no URLs), for a window background or the scenery. The image is re-encoded without metadata (EXIF/GPS removed) and analyzed. Reference it in a theme as background.image, scene.header or scene.sidebar = \"user:<sha256>\". The analysis gives average luminance, how busy it is, its main colors (good accent candidates) and the minimum scrim opacity that keeps text readable.",
			"inputSchema": obj(map[string]any{
				"path":   map[string]any{"type": "string", "description": "Path of a PNG, JPEG or GIF file on this computer."},
				"base64": map[string]any{"type": "string", "description": "Image bytes as base64 (a data: URI prefix is allowed). Use instead of path."},
			}),
			"annotations": map[string]any{"readOnlyHint": false, "destructiveHint": false, "idempotentHint": true, "openWorldHint": false},
		},
		map[string]any{
			"name":        "background_analyze",
			"title":       "Analyze a background image",
			"description": "Analysis of an already imported background image: luminance, how busy it is, main colors and the minimum scrim opacity for readable text.",
			"inputSchema": obj(map[string]any{"sha256": map[string]any{"type": "string", "description": "The sha256 returned by background_import (the part after \"user:\")."}}, "sha256"),
			"annotations": readOnly,
		},
	}
}

func str(args map[string]any, key string) string {
	v, _ := args[key].(string)
	return strings.TrimSpace(v)
}

var modeNames = map[pb.ThemeMode]string{
	pb.ThemeMode_THEME_MODE_UNSPECIFIED: "system",
	pb.ThemeMode_THEME_MODE_LIGHT:       "light",
	pb.ThemeMode_THEME_MODE_DARK:        "dark",
}

func currentThemeID(c *pb.Config) string {
	if c.GetThemeId() == "" {
		return "default"
	}
	return c.GetThemeId()
}

func toolThemeList(s *mcpServer, _ map[string]any) (any, error) {
	return s.call(5*time.Second, func(ctx context.Context, c themeClient) (any, error) {
		cfg, err := c.GetConfig(ctx, &pb.Empty{})
		if err != nil {
			return nil, err
		}
		list, err := c.ListThemes(ctx, &pb.Empty{})
		if err != nil {
			return nil, err
		}
		themes := []any{}
		for _, t := range list.GetThemes() {
			base := t.GetBase()
			if base == "" && !t.GetBuiltin() {
				base = "default"
			}
			themes = append(themes, map[string]any{"id": t.GetId(), "name": t.GetName(), "builtin": t.GetBuiltin(), "base": base})
		}
		return map[string]any{
			"current":   currentThemeID(cfg),
			"mode":      modeNames[cfg.GetThemeMode()],
			"scanlines": cfg.GetThemeScanlines(),
			"themes":    themes,
		}, nil
	})
}

func toolThemeGet(s *mcpServer, args map[string]any) (any, error) {
	id := str(args, "id")
	if id == "" {
		return nil, errors.New("id is required")
	}
	resolved := true
	if v, ok := args["resolved"].(bool); ok {
		resolved = v
	}
	return s.call(5*time.Second, func(ctx context.Context, c themeClient) (any, error) {
		got, err := c.GetTheme(ctx, &pb.GetThemeRequest{Id: id, Resolved: resolved})
		if err != nil {
			return nil, err
		}
		var doc map[string]any
		if err := json.Unmarshal([]byte(got.GetJson()), &doc); err != nil {
			return nil, fmt.Errorf("the saved theme is not valid JSON: %w", err)
		}
		return doc, nil
	})
}

// themeJSON 取工具参数里的主题：对象或 JSON 字符串都行
func themeJSON(args map[string]any) (string, error) {
	switch v := args["theme"].(type) {
	case string:
		if !json.Valid([]byte(v)) {
			return "", errors.New("theme is not valid JSON")
		}
		return v, nil
	case map[string]any:
		data, err := json.Marshal(v)
		return string(data), err
	}
	return "", errors.New("theme is required: pass the theme document as a JSON object")
}

func putTheme(s *mcpServer, args map[string]any, dryRun bool) (any, error) {
	doc, err := themeJSON(args)
	if err != nil {
		return nil, err
	}
	return s.call(10*time.Second, func(ctx context.Context, c themeClient) (any, error) {
		resp, err := c.PutTheme(ctx, &pb.PutThemeRequest{Json: doc, DryRun: dryRun})
		if err != nil {
			return nil, err
		}
		warnings := []any{}
		for _, w := range resp.GetWarnings() {
			warnings = append(warnings, map[string]any{
				"mode": w.GetMode(), "foreground": w.GetForeground(), "background": w.GetBackground(),
				"ratio": w.GetRatio(), "minimum": w.GetMinimum(),
			})
		}
		out := map[string]any{"id": resp.GetId(), "warnings": warnings}
		if dryRun {
			out["valid"] = true
		} else {
			out["saved"] = true
		}
		return out, nil
	})
}

func toolThemeApply(s *mcpServer, args map[string]any) (any, error) {
	id := str(args, "id")
	if id == "" {
		return nil, errors.New("id is required")
	}
	mode, hasMode := args["mode"].(string)
	var want pb.ThemeMode
	if hasMode {
		found := false
		for m, name := range modeNames {
			if name == mode {
				want, found = m, true
			}
		}
		if !found {
			return nil, fmt.Errorf("mode must be system, light or dark, not %q", mode)
		}
	}
	return s.call(5*time.Second, func(ctx context.Context, c themeClient) (any, error) {
		cfg, err := c.GetConfig(ctx, &pb.Empty{})
		if err != nil {
			return nil, err
		}
		if id == "default" {
			cfg.ThemeId = ""
		} else {
			cfg.ThemeId = id
		}
		if hasMode {
			cfg.ThemeMode = want
		}
		next, err := c.UpdateConfig(ctx, cfg)
		if err != nil {
			return nil, err
		}
		return map[string]any{"current": currentThemeID(next), "mode": modeNames[next.GetThemeMode()]}, nil
	})
}

func toolThemeDelete(s *mcpServer, args map[string]any) (any, error) {
	id := str(args, "id")
	if id == "" {
		return nil, errors.New("id is required")
	}
	return s.call(5*time.Second, func(ctx context.Context, c themeClient) (any, error) {
		if _, err := c.DeleteTheme(ctx, &pb.ThemeRef{Id: id}); err != nil {
			return nil, err
		}
		return map[string]any{"deleted": id}, nil
	})
}

func backgroundResult(info *pb.BackgroundInfo) map[string]any {
	colors := info.GetColors()
	if colors == nil {
		colors = []string{}
	}
	return map[string]any{
		"sha256":           info.GetSha256(),
		"reference":        "user:" + info.GetSha256(),
		"width":            info.GetWidth(),
		"height":           info.GetHeight(),
		"format":           info.GetFormat(),
		"luminance":        info.GetLuminance(),
		"luminance_spread": info.GetLuminanceSpread(),
		"colors":           colors,
		"min_scrim_dark":   info.GetMinScrimDark(),
		"min_scrim_light":  info.GetMinScrimLight(),
	}
}

func toolBackgroundImport(s *mcpServer, args map[string]any) (any, error) {
	path, data := str(args, "path"), str(args, "base64")
	if (path == "") == (data == "") {
		return nil, errors.New("give exactly one of path or base64")
	}
	req := &pb.ImportBackgroundRequest{}
	if path != "" {
		if strings.Contains(path, "://") {
			return nil, errors.New("URLs are not accepted: download the image to a file first, then pass its path")
		}
		abs, err := filepath.Abs(path)
		if err != nil {
			return nil, err
		}
		req.Path = abs
	} else {
		if strings.HasPrefix(data, "data:") {
			if _, after, ok := strings.Cut(data, ","); ok {
				data = after
			}
		}
		raw, err := base64.StdEncoding.DecodeString(data)
		if err != nil {
			if raw, err = base64.RawStdEncoding.DecodeString(data); err != nil {
				return nil, errors.New("base64 is not valid base64 data")
			}
		}
		req.Image = raw
	}
	return s.call(60*time.Second, func(ctx context.Context, c themeClient) (any, error) {
		info, err := c.ImportBackground(ctx, req)
		if err != nil {
			return nil, err
		}
		return backgroundResult(info), nil
	})
}

func toolBackgroundAnalyze(s *mcpServer, args map[string]any) (any, error) {
	sha := strings.TrimPrefix(str(args, "sha256"), "user:")
	if sha == "" {
		return nil, errors.New("sha256 is required")
	}
	return s.call(30*time.Second, func(ctx context.Context, c themeClient) (any, error) {
		info, err := c.AnalyzeBackground(ctx, &pb.BackgroundRef{Sha256: sha})
		if err != nil {
			return nil, err
		}
		return backgroundResult(info), nil
	})
}
