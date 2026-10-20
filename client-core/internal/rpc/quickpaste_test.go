package rpc

import (
	"context"
	"fmt"
	"testing"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"

	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// 快捷窗口连着 QuickPasteSession 时：状态推给界面，设置页的命令转给它；断开后算作没在运行。
func TestQuickPasteSession(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	hub := NewHub()
	s := NewServer(Deps{}, hub, "tok")
	port, _, err := s.Serve(ctx)
	if err != nil {
		t.Fatal(err)
	}
	conn, err := grpc.NewClient(fmt.Sprintf("127.0.0.1:%d", port), grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		t.Fatal(err)
	}
	defer conn.Close()
	client := pb.NewDaemonServiceClient(conn)
	authed := metadata.AppendToOutgoingContext(ctx, tokenHeader, "tok")
	events, unsubscribe := hub.Subscribe()
	defer unsubscribe()
	nextStatus := func() *pb.QuickPasteStatus {
		t.Helper()
		for {
			select {
			case e := <-events:
				if st := e.GetQuickPasteChanged(); st != nil {
					return st
				}
			case <-ctx.Done():
				t.Fatal("没等到 quick_paste_changed")
			}
		}
	}

	if _, err := client.SendQuickPasteCommand(authed, &pb.QuickPasteCommand{Command: "show"}); status.Code(err) != codes.FailedPrecondition {
		t.Fatalf("快捷窗口没运行时发命令：%v", err)
	}

	sessionCtx, endSession := context.WithCancel(authed)
	session, err := client.QuickPasteSession(sessionCtx)
	if err != nil {
		t.Fatal(err)
	}
	if err := session.Send(&pb.QuickPasteStatus{Hotkey: "alt+v", PasteAvailable: true}); err != nil {
		t.Fatal(err)
	}
	for st := nextStatus(); st.GetHotkey() != "alt+v"; st = nextStatus() {
		if !st.GetRunning() {
			t.Fatalf("连上之后应算作在运行：%v", st)
		}
	}
	if st, _ := client.GetQuickPasteStatus(authed, &pb.Empty{}); !st.GetRunning() || !st.GetPasteAvailable() {
		t.Fatalf("GetQuickPasteStatus = %v", st)
	}

	if _, err := client.SendQuickPasteCommand(authed, &pb.QuickPasteCommand{Command: "request_permission"}); err != nil {
		t.Fatal(err)
	}
	cmd, err := session.Recv()
	if err != nil || cmd.GetCommand() != "request_permission" {
		t.Fatalf("命令没转给快捷窗口：%v %v", cmd, err)
	}

	endSession()
	for st := nextStatus(); st.GetRunning(); st = nextStatus() {
	}
	if st, _ := client.GetQuickPasteStatus(authed, &pb.Empty{}); st.GetRunning() {
		t.Fatalf("断开后仍算作在运行：%v", st)
	}
}
