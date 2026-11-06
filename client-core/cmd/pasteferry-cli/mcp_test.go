package main

import (
	"bytes"
	"context"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"image"
	"image/color"
	"image/png"
	"strings"
	"testing"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/rpc"
	"github.com/baiyuze/pasteferry/client-core/internal/theme"
)

// startThemeDaemon 起一个真实的后台服务（只有配置与主题），返回它的数据目录
func startThemeDaemon(t *testing.T) (string, *config.Config) {
	t.Helper()
	dir := t.TempDir()
	paths := config.PathsUnder(dir)
	cfg := config.Default()
	s := rpc.NewServer(rpc.Deps{
		LoadConfig: func() config.Config { return cfg },
		SaveConfig: func(c config.Config) error { cfg = c; return nil },
		Themes:     theme.NewStore(paths),
	}, rpc.NewHub(), "mcp-test-token")
	ctx, cancel := context.WithCancel(context.Background())
	t.Cleanup(cancel)
	port, _, err := s.Serve(ctx)
	if err != nil {
		t.Fatal(err)
	}
	if err := rpc.WriteEndpoint(paths.Endpoint, rpc.Endpoint{Port: port, Token: "mcp-test-token", PID: 1}); err != nil {
		t.Fatal(err)
	}
	return dir, &cfg
}

// mcpSession 把几条请求按行喂给 MCP 服务，返回按 id 索引的回复。stdout 上每一行都必须是 JSON-RPC 消息
func mcpSession(t *testing.T, dir string, messages ...any) map[float64]map[string]any {
	t.Helper()
	var in bytes.Buffer
	for _, m := range messages {
		line, err := json.Marshal(m)
		if err != nil {
			t.Fatal(err)
		}
		in.Write(append(line, '\n'))
	}
	var out, log bytes.Buffer
	if err := serveMCP(&in, &out, &log, daemonDialer(config.PathsUnder(dir))); err != nil {
		t.Fatal(err)
	}
	replies := map[float64]map[string]any{}
	for _, line := range strings.Split(strings.TrimSpace(out.String()), "\n") {
		if line == "" {
			continue
		}
		var r map[string]any
		if err := json.Unmarshal([]byte(line), &r); err != nil {
			t.Fatalf("stdout 上有不是 JSON 的内容：%q", line)
		}
		if r["jsonrpc"] != "2.0" {
			t.Fatalf("不是 JSON-RPC 2.0：%v", r)
		}
		id, _ := r["id"].(float64)
		replies[id] = r
	}
	return replies
}

func req(id int, method string, params any) map[string]any {
	m := map[string]any{"jsonrpc": "2.0", "id": id, "method": method}
	if params != nil {
		m["params"] = params
	}
	return m
}

func call(id int, tool string, args any) map[string]any {
	return req(id, "tools/call", map[string]any{"name": tool, "arguments": args})
}

func initialize(version string) []any {
	return []any{
		req(1, "initialize", map[string]any{"protocolVersion": version, "capabilities": map[string]any{}, "clientInfo": map[string]any{"name": "test", "version": "1"}}),
		map[string]any{"jsonrpc": "2.0", "method": "notifications/initialized"},
	}
}

// toolData 取工具结果的 JSON 内容；isError 不对时失败
func toolData(t *testing.T, reply map[string]any, wantError bool) map[string]any {
	t.Helper()
	result, ok := reply["result"].(map[string]any)
	if !ok {
		t.Fatalf("没有 result：%v", reply)
	}
	if result["isError"] != wantError {
		t.Fatalf("isError=%v，想要 %v：%v", result["isError"], wantError, result)
	}
	text := result["content"].([]any)[0].(map[string]any)["text"].(string)
	if wantError {
		return map[string]any{"text": text}
	}
	var data map[string]any
	if err := json.Unmarshal([]byte(text), &data); err != nil {
		t.Fatalf("工具的文字结果不是 JSON：%q", text)
	}
	return data
}

func TestMCPInitializeAndList(t *testing.T) {
	dir, _ := startThemeDaemon(t)
	for _, version := range []string{"2025-06-18", "2025-03-26", "2099-01-01"} {
		replies := mcpSession(t, dir, append(initialize(version),
			req(2, "tools/list", nil),
			req(3, "resources/list", nil),
			req(4, "ping", nil),
			req(5, "nope", nil),
		)...)
		if len(replies) != 5 {
			t.Fatalf("通知不该有回复，其余每条一条：%v", replies)
		}
		got := replies[1]["result"].(map[string]any)["protocolVersion"]
		want := version
		if version == "2099-01-01" {
			want = "2025-06-18"
		}
		if got != want {
			t.Errorf("协议版本：要 %s 回了 %v", version, got)
		}
		tools := replies[2]["result"].(map[string]any)["tools"].([]any)
		names := map[string]bool{}
		for _, tool := range tools {
			m := tool.(map[string]any)
			names[m["name"].(string)] = true
			if m["description"] == "" || m["inputSchema"].(map[string]any)["type"] != "object" {
				t.Errorf("工具要有说明与对象类型的参数：%v", m)
			}
		}
		for _, n := range []string{"theme_list", "theme_get", "theme_schema", "theme_validate", "theme_save", "theme_apply", "theme_delete", "background_import", "background_analyze"} {
			if !names[n] {
				t.Errorf("少了工具 %s", n)
			}
		}
		for n := range names {
			if !strings.HasPrefix(n, "theme_") && !strings.HasPrefix(n, "background_") {
				t.Errorf("只能提供主题与背景图的工具，不该有 %s", n)
			}
		}
		uris := map[string]bool{}
		for _, r := range replies[3]["result"].(map[string]any)["resources"].([]any) {
			uris[r.(map[string]any)["uri"].(string)] = true
		}
		if !uris[schemaURI] || !uris["pasteferry://themes/default"] || !uris["pasteferry://themes/pixel"] {
			t.Errorf("资源里要有格式说明与内置主题：%v", uris)
		}
		if replies[5]["error"].(map[string]any)["code"] != float64(errMethodNotFound) {
			t.Errorf("不认识的方法：%v", replies[5])
		}
	}
}

func TestMCPThemeWorkflow(t *testing.T) {
	dir, cfg := startThemeDaemon(t)
	mint := map[string]any{
		"schema": 1, "id": "mint", "base": "pixel",
		"name":  map[string]any{"en": "Mint"},
		"modes": map[string]any{"dark": map[string]any{"accent": "#7CF5C4"}},
	}
	bad := map[string]any{"schema": 1, "id": "faint", "modes": map[string]any{"dark": map[string]any{"textDim": "#2A2A2C"}}}
	replies := mcpSession(t, dir, append(initialize("2025-06-18"),
		call(2, "theme_validate", map[string]any{"theme": mint}),
		call(3, "theme_list", map[string]any{}),
		call(4, "theme_validate", map[string]any{"theme": bad}),
		call(5, "theme_save", map[string]any{"theme": mint}),
		call(6, "theme_apply", map[string]any{"id": "mint", "mode": "dark"}),
		call(7, "theme_list", nil),
		call(8, "theme_get", map[string]any{"id": "mint"}),
		call(9, "theme_save", map[string]any{"theme": map[string]any{"schema": 1, "id": "pixel"}}),
		call(10, "theme_validate", map[string]any{"theme": `{"schema":1,"id":"x","shape":{"corner":"star"}}`}),
		req(11, "resources/read", map[string]any{"uri": "pasteferry://themes/mint"}),
		req(12, "resources/read", map[string]any{"uri": schemaURI}),
		call(13, "theme_schema", nil),
		call(14, "theme_delete", map[string]any{"id": "mint"}),
	)...)

	if v := toolData(t, replies[2], false); v["valid"] != true || v["id"] != "mint" {
		t.Errorf("校验：%v", v)
	}
	if list := toolData(t, replies[3], false); len(list["themes"].([]any)) != 2 {
		t.Errorf("只校验不该保存：%v", list)
	}
	if w := toolData(t, replies[4], false)["warnings"].([]any); len(w) == 0 || w[0].(map[string]any)["foreground"] != "textDim" {
		t.Errorf("对比度不够要有警告：%v", w)
	}
	if v := toolData(t, replies[5], false); v["saved"] != true {
		t.Errorf("保存：%v", v)
	}
	if v := toolData(t, replies[6], false); v["current"] != "mint" || v["mode"] != "dark" {
		t.Errorf("应用：%v", v)
	}
	if list := toolData(t, replies[7], false); list["current"] != "mint" || list["mode"] != "dark" || len(list["themes"].([]any)) != 3 {
		t.Errorf("列表：%v", list)
	}
	if structured := replies[7]["result"].(map[string]any)["structuredContent"]; structured == nil {
		t.Error("2025-06-18 应当带 structuredContent")
	}
	got := toolData(t, replies[8], false)
	dark := got["modes"].(map[string]any)["dark"].(map[string]any)
	if dark["accent"] != "#7CF5C4" || dark["background"] == nil || got["typography"] == nil {
		t.Errorf("resolved 的主题应当补齐 base：%v", got)
	}
	if e := toolData(t, replies[9], true)["text"].(string); !strings.Contains(e, "内置") {
		t.Errorf("内置主题不能覆盖：%q", e)
	}
	if e := toolData(t, replies[10], true)["text"].(string); !strings.Contains(e, "corner") {
		t.Errorf("格式错误要说清楚：%q", e)
	}
	content := replies[11]["result"].(map[string]any)["contents"].([]any)[0].(map[string]any)
	if !strings.Contains(content["text"].(string), `"mint"`) || content["mimeType"] != "application/json" {
		t.Errorf("读主题资源：%v", content)
	}
	schema := replies[12]["result"].(map[string]any)["contents"].([]any)[0].(map[string]any)["text"].(string)
	if !strings.Contains(schema, "onAccent") || !strings.Contains(schema, "4.5") {
		t.Error("格式说明里要讲清颜色角色与对比度")
	}
	if toolData(t, replies[13], false)["properties"] == nil {
		t.Error("theme_schema 要返回 JSON Schema")
	}
	if v := toolData(t, replies[14], false); v["deleted"] != "mint" {
		t.Errorf("删除：%v", v)
	}
	if cfg.ThemeID != "" {
		t.Errorf("删掉正在用的主题后应当换回默认：%q", cfg.ThemeID)
	}
}

func TestMCPBackground(t *testing.T) {
	dir, _ := startThemeDaemon(t)
	img := image.NewRGBA(image.Rect(0, 0, 8, 8))
	for i := range img.Pix {
		img.Pix[i] = 255
	}
	img.Set(0, 0, color.RGBA{255, 0, 0, 255})
	var buf bytes.Buffer
	png.Encode(&buf, img)
	encoded := "data:image/png;base64," + base64.StdEncoding.EncodeToString(buf.Bytes())

	replies := mcpSession(t, dir, append(initialize("2025-03-26"),
		call(2, "background_import", map[string]any{"base64": encoded}),
		call(3, "background_import", map[string]any{"path": "https://example.com/a.png"}),
		call(4, "background_import", map[string]any{}),
	)...)
	info := toolData(t, replies[2], false)
	sha := info["sha256"].(string)
	if len(sha) != 64 || info["reference"] != "user:"+sha || info["luminance"].(float64) < 0.8 {
		t.Fatalf("导入：%v", info)
	}
	if _, ok := replies[2]["result"].(map[string]any)["structuredContent"]; ok {
		t.Error("2025-03-26 没有 structuredContent")
	}
	if e := toolData(t, replies[3], true)["text"].(string); !strings.Contains(e, "URL") {
		t.Errorf("不接受网址：%q", e)
	}
	toolData(t, replies[4], true)

	replies = mcpSession(t, dir, append(initialize("2025-06-18"),
		call(2, "background_analyze", map[string]any{"sha256": "user:" + sha}),
		call(3, "theme_save", map[string]any{"theme": map[string]any{"schema": 1, "id": "photo", "background": map[string]any{"image": "user:" + sha, "fit": "tile"}}}),
	)...)
	if again := toolData(t, replies[2], false); again["sha256"] != sha || again["format"] != "png" {
		t.Errorf("重新分析：%v", again)
	}
	toolData(t, replies[3], false)
}

func TestMCPWithoutDaemon(t *testing.T) {
	dir := t.TempDir()
	replies := mcpSession(t, dir, append(initialize("2025-06-18"),
		call(2, "theme_list", nil),
		call(3, "theme_schema", nil),
		req(4, "resources/list", nil),
	)...)
	if e := toolData(t, replies[2], true)["text"].(string); !strings.Contains(e, "not running") {
		t.Errorf("后台服务没开要说清楚：%q", e)
	}
	toolData(t, replies[3], false)
	if r := replies[4]["result"].(map[string]any)["resources"].([]any); len(r) != 1 {
		t.Errorf("后台服务没开时只列格式说明：%v", r)
	}
}

func TestMCPMalformedInput(t *testing.T) {
	var out, log bytes.Buffer
	in := strings.NewReader("not json\n" + `{"jsonrpc":"2.0","id":7,"method":"tools/call","params":{"name":"nope"}}` + "\n" +
		`[{"jsonrpc":"2.0","id":8,"method":"ping"},{"jsonrpc":"2.0","method":"notifications/initialized"}]` + "\n")
	if err := serveMCP(in, &out, &log, func() (themeClient, context.Context, func(), error) {
		return nil, nil, nil, fmt.Errorf("unused")
	}); err != nil {
		t.Fatal(err)
	}
	lines := strings.Split(strings.TrimSpace(out.String()), "\n")
	if len(lines) != 3 {
		t.Fatalf("三行输入、三条回复：%q", out.String())
	}
	if !strings.Contains(lines[0], `"code":-32700`) || !strings.Contains(lines[1], `"code":-32602`) || !strings.HasPrefix(lines[2], "[") {
		t.Errorf("错误码不对：%q", lines)
	}
}

// 每个颜色角色都要有给 AI 看的说明
func TestRoleDocsComplete(t *testing.T) {
	for _, r := range theme.Roles {
		if roleDocs[r] == "" {
			t.Errorf("颜色角色 %s 缺说明", r)
		}
	}
	if len(roleDocs) != len(theme.Roles) {
		t.Error("roleDocs 里有多余的角色")
	}
}
