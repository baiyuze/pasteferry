package mobile

import (
	"context"
	"fmt"
	"runtime"
	gosync "sync"
	"testing"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/metadata"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/rpc"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

type fakeHost struct {
	mu     gosync.Mutex
	writes []string
	online []string
}

func (h *fakeHost) WriteClipboard(kind, text, html, paths string) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	h.writes = append(h.writes, kind+":"+text+paths)
	return nil
}

func (h *fakeHost) StatusChanged(online, lastFrom, lastKind string) {
	h.mu.Lock()
	defer h.mu.Unlock()
	h.online = append(h.online, online)
}

func dial(t *testing.T, dir string) (pb.DaemonServiceClient, context.Context) {
	t.Helper()
	ep, err := rpc.ReadEndpoint(config.PathsUnder(dir).Endpoint)
	if err != nil {
		t.Fatal(err)
	}
	conn, err := grpc.NewClient(fmt.Sprintf("127.0.0.1:%d", ep.Port), grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { conn.Close() })
	ctx := metadata.AppendToOutgoingContext(context.Background(), "x-pasteferry-token", ep.Token)
	return pb.NewDaemonServiceClient(conn), ctx
}

func TestStartServesGRPCAndStopsCleanly(t *testing.T) {
	dir := t.TempDir()
	host := &fakeHost{}
	before := runtime.NumGoroutine()
	if err := Start(dir, "Pixel 8", "2.7.0", host); err != nil {
		t.Fatal(err)
	}
	if err := Start(dir, "Pixel 8", "2.7.0", host); err != nil || !Running() {
		t.Fatalf("重复 Start：%v，running=%v", err, Running())
	}
	client, ctx := dial(t, dir)
	st, err := client.GetStatus(ctx, &pb.Empty{})
	if err != nil {
		t.Fatal(err)
	}
	if st.GetVersion() != "2.7.0" || st.GetDeviceName() != "Pixel 8" {
		t.Errorf("状态 = 版本 %q 名字 %q", st.GetVersion(), st.GetDeviceName())
	}
	cfg, err := client.GetConfig(ctx, &pb.Empty{})
	if err != nil {
		t.Fatal(err)
	}
	if cfg.GetServiceMode() != pb.ServiceMode_SERVICE_MODE_LAN {
		t.Errorf("服务模式 = %q，一期应只走局域网", cfg.GetServiceMode())
	}

	rec, err := client.SubmitText(ctx, &pb.SubmitTextRequest{Text: "手机上输入的文字"})
	if err != nil {
		t.Fatal(err)
	}
	if !rec.GetOutgoing() || rec.GetTextPreview() != "手机上输入的文字" {
		t.Errorf("发出的记录 = %v", rec)
	}
	hist, err := client.ListHistory(ctx, &pb.ListHistoryRequest{Limit: 10})
	if err != nil || len(hist.GetRecords()) != 1 {
		t.Fatalf("复制记录 = %v, %v", hist.GetRecords(), err)
	}
	// 发送页的文字不写回手机自己的剪贴板；「复制」才写
	host.mu.Lock()
	writes := len(host.writes)
	host.mu.Unlock()
	if writes != 0 {
		t.Errorf("发出的文字写进了手机剪贴板 %d 次", writes)
	}
	if _, err := client.ApplyToClipboard(ctx, &pb.ApplyToClipboardRequest{ClipId: rec.GetId()}); err != nil {
		t.Fatal(err)
	}
	host.mu.Lock()
	got := append([]string(nil), host.writes...)
	host.mu.Unlock()
	if len(got) != 1 || got[0] != "text:手机上输入的文字" {
		t.Errorf("复制 → 宿主收到 %v", got)
	}

	Stop()
	if Running() {
		t.Fatal("Stop 之后还在运行")
	}
	if _, err := client.GetStatus(ctx, &pb.Empty{}); err == nil {
		t.Error("Stop 之后 gRPC 还能连")
	}
	// 再启动一次：同一个数据目录，记录还在
	if err := Start(dir, "Pixel 8", "2.7.0", host); err != nil {
		t.Fatal(err)
	}
	client2, ctx2 := dial(t, dir)
	hist, err = client2.ListHistory(ctx2, &pb.ListHistoryRequest{Limit: 10})
	if err != nil || len(hist.GetRecords()) != 1 {
		t.Fatalf("重启后的复制记录 = %v, %v", hist.GetRecords(), err)
	}
	Stop()

	// 停止后不应残留大量 goroutine（允许少量运行时与 gRPC 的后台协程收尾）
	deadline := time.Now().Add(5 * time.Second)
	for runtime.NumGoroutine() > before+8 && time.Now().Before(deadline) {
		time.Sleep(100 * time.Millisecond)
	}
	if n := runtime.NumGoroutine(); n > before+8 {
		buf := make([]byte, 1<<16)
		t.Errorf("停止后还剩 %d 个 goroutine（启动前 %d）\n%s", n, before, buf[:runtime.Stack(buf, true)])
	}
}
