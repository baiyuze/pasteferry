package main

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"io"
	"net"
	"os"
	"os/exec"
	"strings"
	"sync/atomic"
	"testing"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/rpc"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// Exercise the actual entry point in a separate process, including flag parsing,
// exit codes, stdout/stderr and RPC authentication, on every desktop platform.
func TestCLIProcess(t *testing.T) {
	if os.Getenv("PASTEFERRY_CLI_TEST_PROCESS") != "1" {
		return
	}
	for i, arg := range os.Args {
		if arg == "--" {
			os.Args = append([]string{"pasteferry-cli"}, os.Args[i+1:]...)
			break
		}
	}
	version = "2.9.0-test"
	main()
	os.Exit(0)
}

func invokeCLI(t *testing.T, args ...string) (string, string, int) {
	t.Helper()
	exe, err := os.Executable()
	if err != nil {
		t.Fatal(err)
	}
	ctx, cancel := context.WithTimeout(context.Background(), 12*time.Second)
	defer cancel()
	cmd := exec.CommandContext(ctx, exe, append([]string{"-test.run=^TestCLIProcess$", "--"}, args...)...)
	cmd.Env = append(os.Environ(), "PASTEFERRY_CLI_TEST_PROCESS=1")
	var stdout, stderr bytes.Buffer
	cmd.Stdout, cmd.Stderr = &stdout, &stderr
	code := 0
	if err := cmd.Run(); err != nil {
		var exit *exec.ExitError
		if !errors.As(err, &exit) || ctx.Err() != nil {
			t.Fatalf("CLI failed to run: %v (stdout=%q stderr=%q)", err, stdout.String(), stderr.String())
		}
		code = exit.ExitCode()
	}
	return stdout.String(), stderr.String(), code
}

func jsonCLI(t *testing.T, wantCode int, args ...string) map[string]any {
	t.Helper()
	out, stderr, code := invokeCLI(t, args...)
	if code != wantCode || stderr != "" {
		t.Fatalf("exit=%d want=%d stdout=%q stderr=%q", code, wantCode, out, stderr)
	}
	var result map[string]any
	decoder := json.NewDecoder(strings.NewReader(out))
	if err := decoder.Decode(&result); err != nil {
		t.Fatalf("invalid JSON: %v: %q", err, out)
	}
	if err := decoder.Decode(new(any)); err != io.EOF {
		t.Fatalf("extra stdout after JSON: %q (%v)", out, err)
	}
	if result["ok"] != (wantCode == 0) {
		t.Fatalf("unexpected envelope: %v", result)
	}
	if wantCode != 0 && result["error"] == "" {
		t.Fatalf("missing error: %v", result)
	}
	return result
}

type queryServer struct {
	pb.UnimplementedDaemonServiceServer
	devices *pb.ListDevicesResponse
	history *pb.ListHistoryResponse
	fail    bool
	wait    bool
	calls   atomic.Int32
}

func (s *queryServer) GetStatus(ctx context.Context, _ *pb.Empty) (*pb.Status, error) {
	if s.wait {
		<-ctx.Done()
		return nil, ctx.Err()
	}
	if s.fail {
		return nil, status.Error(codes.Unavailable, "test backend unavailable")
	}
	return &pb.Status{Version: "2.8.3", DeviceName: "我的 Mac <&> 🛳", LanEnabled: true, CacheBytesUsed: 9007199254740993}, nil
}

func (s *queryServer) ListDevices(context.Context, *pb.Empty) (*pb.ListDevicesResponse, error) {
	return s.devices, nil
}

func (s *queryServer) ListHistory(_ context.Context, req *pb.ListHistoryRequest) (*pb.ListHistoryResponse, error) {
	if req.GetLimit() != 20 {
		return nil, status.Error(codes.InvalidArgument, "expected history limit 20")
	}
	return s.history, nil
}

func (s *queryServer) GetConfig(context.Context, *pb.Empty) (*pb.Config, error) {
	return &pb.Config{DeviceName: "我的 Mac <&> 🛳", SyncText: true, SyncImage: true, Language: "ja", ReceiveFrom: "friends"}, nil
}

func startQueryServer(t *testing.T, s *queryServer) string {
	t.Helper()
	if s.devices == nil {
		s.devices = &pb.ListDevicesResponse{}
	}
	if s.history == nil {
		s.history = &pb.ListHistoryResponse{}
	}
	listener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	server := grpc.NewServer(grpc.UnaryInterceptor(func(ctx context.Context, req any, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (any, error) {
		s.calls.Add(1)
		md, _ := metadata.FromIncomingContext(ctx)
		if strings.Join(md.Get("x-pasteferry-token"), "") != "test-private-token" {
			return nil, status.Error(codes.Unauthenticated, "invalid token")
		}
		return handler(ctx, req)
	}))
	pb.RegisterDaemonServiceServer(server, s)
	go server.Serve(listener)
	t.Cleanup(server.Stop)
	dir := t.TempDir()
	if err := rpc.WriteEndpoint(config.PathsUnder(dir).Endpoint, rpc.Endpoint{
		Port: listener.Addr().(*net.TCPAddr).Port, Token: "test-private-token", PID: 1234,
	}); err != nil {
		t.Fatal(err)
	}
	return dir
}

func TestVersionWithoutDaemon(t *testing.T) {
	dir := t.TempDir()
	out, stderr, code := invokeCLI(t, "-data-dir", dir, "version")
	if code != 0 || stderr != "" || out != "2.9.0-test\n" {
		t.Fatalf("version: exit=%d stdout=%q stderr=%q", code, out, stderr)
	}
	for _, option := range []string{"-json", "--json"} {
		result := jsonCLI(t, 0, option, "-data-dir", dir, "version")
		if result["data"].(map[string]any)["version"] != "2.9.0-test" {
			t.Fatal(result)
		}
	}
}

func TestReadOnlyJSON(t *testing.T) {
	s := &queryServer{}
	dir := startQueryServer(t, s)
	for _, args := range [][]string{{"status"}, {"devices"}, {"history"}, {"config"}, {"config", "get"}} {
		t.Run(strings.Join(args, "_"), func(t *testing.T) {
			result := jsonCLI(t, 0, append([]string{"-json", "-data-dir", dir}, args...)...)
			data := result["data"].(map[string]any)
			switch args[0] {
			case "status":
				daemon := data["daemon"].(map[string]any)
				if data["pid"] != float64(1234) || daemon["version"] != "2.8.3" || daemon["cache_bytes_used"] != "9007199254740993" || daemon["device_name"] != "我的 Mac <&> 🛳" {
					t.Fatal(data)
				}
			case "devices", "history":
				key := "peers"
				if args[0] == "history" {
					key = "records"
				}
				if list, ok := data[key].([]any); !ok || len(list) != 0 {
					t.Fatal(data)
				}
			case "config":
				if data["sync_text"] != true || data["sync_image"] != true || data["sync_file"] != false || data["language"] != "ja" {
					t.Fatal(data)
				}
			}
			if strings.Contains(string(mustJSON(t, result)), "test-private-token") {
				t.Fatal("endpoint token leaked")
			}
		})
	}
}

func mustJSON(t *testing.T, value any) []byte {
	t.Helper()
	data, err := json.Marshal(value)
	if err != nil {
		t.Fatal(err)
	}
	return data
}

func TestPopulatedQueriesAndLegacyText(t *testing.T) {
	s := &queryServer{
		devices: &pb.ListDevicesResponse{Self: &pb.Device{Name: "My Mac"}, Peers: []*pb.Device{{Id: "peer", Name: "手机", Online: true, Connection: pb.ConnectionKind_CONNECTION_KIND_DIRECT}}},
		history: &pb.ListHistoryResponse{Records: []*pb.ClipRecord{{Id: "clip", TextPreview: "中文\n<&> 🛳", Kind: pb.ClipKind_CLIP_KIND_TEXT, TotalSize: 9007199254740993}}},
	}
	dir := startQueryServer(t, s)
	devices := jsonCLI(t, 0, "-json", "-data-dir", dir, "devices")["data"].(map[string]any)
	peer := devices["peers"].([]any)[0].(map[string]any)
	if peer["name"] != "手机" || peer["connection"] != "CONNECTION_KIND_DIRECT" || peer["online"] != true {
		t.Fatal(peer)
	}
	history := jsonCLI(t, 0, "-json", "-data-dir", dir, "history")["data"].(map[string]any)
	record := history["records"].([]any)[0].(map[string]any)
	if record["text_preview"] != "中文\n<&> 🛳" || record["total_size"] != "9007199254740993" {
		t.Fatal(record)
	}
	for _, args := range [][]string{{"status"}, {"devices"}, {"history"}, {"config"}, {"config", "get"}} {
		out, stderr, code := invokeCLI(t, append([]string{"-data-dir", dir}, args...)...)
		if code != 0 || stderr != "" || out == "" || json.Valid([]byte(out)) {
			t.Fatalf("legacy %v: %d %q %q", args, code, out, stderr)
		}
	}
}

func TestJSONRejectsUnsupportedOperationsBeforeRPC(t *testing.T) {
	s := &queryServer{}
	dir := startQueryServer(t, s)
	for _, args := range [][]string{{"name", "Changed"}, {"config", "set", "sync_text", "false"}, {"pair"}, {"join", "123"}, {"confirm", "session"}, {"unpair", "peer"}, {"apply", "clip"}, {"favorite", "clip"}, {"watch"}, {"status", "--json"}, {"unknown"}, {"config", "get", "extra"}} {
		jsonCLI(t, 1, append([]string{"-json", "-data-dir", dir}, args...)...)
	}
	if s.calls.Load() != 0 {
		t.Fatalf("unsupported commands made %d RPC calls", s.calls.Load())
	}
}

func TestJSONErrors(t *testing.T) {
	jsonCLI(t, 0, "-json", "-h")
	jsonCLI(t, 2, "-json")
	jsonCLI(t, 2, "-json", "-unknown")
	jsonCLI(t, 2, "-json", "-data-dir")
	jsonCLI(t, 1, "-json", "-data-dir", t.TempDir(), "status")
	staleDir := t.TempDir()
	listener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	port := listener.Addr().(*net.TCPAddr).Port
	listener.Close()
	if err := rpc.WriteEndpoint(config.PathsUnder(staleDir).Endpoint, rpc.Endpoint{Port: port, Token: "stale-token"}); err != nil {
		t.Fatal(err)
	}
	jsonCLI(t, 1, "-json", "-data-dir", staleDir, "status")

	s := &queryServer{fail: true}
	dir := startQueryServer(t, s)
	jsonCLI(t, 1, "-json", "-data-dir", dir, "status")
	ep, err := rpc.ReadEndpoint(config.PathsUnder(dir).Endpoint)
	if err != nil {
		t.Fatal(err)
	}
	ep.Token = "wrong-token"
	if err := rpc.WriteEndpoint(config.PathsUnder(dir).Endpoint, ep); err != nil {
		t.Fatal(err)
	}
	jsonCLI(t, 1, "-json", "-data-dir", dir, "config", "get")
	if err := os.WriteFile(config.PathsUnder(dir).Endpoint, []byte("not JSON"), 0600); err != nil {
		t.Fatal(err)
	}
	jsonCLI(t, 1, "-json", "-data-dir", dir, "status")
	out, stderr, code := invokeCLI(t, "-data-dir", t.TempDir(), "status")
	if code != 1 || out != "" || !strings.Contains(stderr, "daemon 未运行") {
		t.Fatalf("text error: %d %q %q", code, out, stderr)
	}
}

func TestJSONRequestDeadline(t *testing.T) {
	dir := startQueryServer(t, &queryServer{wait: true})
	start := time.Now()
	jsonCLI(t, 1, "-json", "-data-dir", dir, "status")
	if elapsed := time.Since(start); elapsed < 4*time.Second || elapsed > 10*time.Second {
		t.Fatalf("unexpected deadline: %v", elapsed)
	}
}
