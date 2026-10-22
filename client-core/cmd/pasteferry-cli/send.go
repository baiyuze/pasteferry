package main

import (
	"context"
	"errors"
	"fmt"
	"path/filepath"
	"strings"
	"time"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// sendFiles 把文件发给一台设备（隔空传送），一直显示进度到结束。DEVICE 可以是设备名或 ID。
// 要经官方服务中转时，带上 -relay 才发。
func sendFiles(ctx context.Context, c pb.DaemonServiceClient, args []string) error {
	allowRelay := false
	var rest []string
	for _, a := range args {
		if a == "-relay" || a == "--relay" {
			allowRelay = true
			continue
		}
		rest = append(rest, a)
	}
	if len(rest) < 2 {
		return errors.New("用法: send [-relay] DEVICE PATH...")
	}
	devices, err := c.ListDevices(ctx, &pb.Empty{})
	if err != nil {
		return err
	}
	var target *pb.Device
	for _, d := range devices.GetPeers() {
		if d.GetId() == rest[0] || strings.EqualFold(d.GetName(), rest[0]) {
			target = d
		}
	}
	if target == nil {
		return fmt.Errorf("没有叫 %q 的已配对设备", rest[0])
	}
	var paths []string
	for _, p := range rest[1:] {
		abs, err := filepath.Abs(p)
		if err != nil {
			return err
		}
		paths = append(paths, abs)
	}

	events, err := c.Subscribe(ctx, &pb.SubscribeRequest{})
	if err != nil {
		return err
	}
	t, err := c.SendFiles(ctx, &pb.SendFilesRequest{DeviceId: target.GetId(), Paths: paths, AllowRelay: allowRelay})
	if err != nil {
		if s, ok := status.FromError(err); ok && s.Code() == codes.FailedPrecondition && s.Message() == "relay" {
			return errors.New("要经官方服务中转（有每日额度），确认要发的话加上 -relay")
		}
		return err
	}
	fmt.Printf("发给 %s：%d 项\n", target.GetName(), len(paths))
	start := time.Now()
	last := ""
	for {
		ev, err := events.Recv()
		if err != nil {
			return err
		}
		u := ev.GetTransferChanged()
		if u == nil || u.GetId() != t.GetId() {
			continue
		}
		line := transferLine(u)
		if line != last {
			fmt.Printf("\r\033[K%s", line)
			last = line
		}
		switch u.GetStatus() {
		case "done":
			secs := time.Since(start).Seconds()
			fmt.Printf("\n已送达，%.1f 秒，平均 %.1f MB/s\n", secs, float64(u.GetTotalBytes())/secs/(1<<20))
			return nil
		case "failed", "declined", "cancelled", "expired":
			fmt.Println()
			return fmt.Errorf("没有发出：%s", u.GetError())
		case "interrupted", "paused":
			fmt.Println("\n已中断，重新连上后会自动继续（pasteferry-cli transfers 查看）")
			return nil
		}
	}
}

func transferLine(t *pb.Transfer) string {
	switch t.GetStatus() {
	case "scanning":
		return fmt.Sprintf("统计中… %d 个文件", t.GetScannedFiles())
	case "active":
		pct := 0.0
		if t.GetTotalBytes() > 0 {
			pct = float64(t.GetDoneBytes()) * 100 / float64(t.GetTotalBytes())
		}
		return fmt.Sprintf("%5.1f%%  %s / %s  %.1f MB/s  %s", pct, humanBytes(t.GetDoneBytes()),
			humanBytes(t.GetTotalBytes()), t.GetBytesPerSecond()/(1<<20), t.GetCurrentFile())
	default:
		return t.GetStatus()
	}
}

// showTransfers 列出最近收到和发出的文件。
func showTransfers(ctx context.Context, c pb.DaemonServiceClient) error {
	resp, err := c.ListTransfers(ctx, &pb.ListTransfersRequest{Limit: 50})
	if err != nil {
		return err
	}
	if len(resp.GetTransfers()) == 0 {
		fmt.Println("（还没有收发过文件）")
		return nil
	}
	for _, t := range resp.GetTransfers() {
		dir, who := "↓", "来自"
		if t.GetDirection() == pb.TransferDirection_TRANSFER_DIRECTION_OUTGOING {
			dir, who = "↑", "发给"
		}
		names := make([]string, 0, len(t.GetItems()))
		for _, it := range t.GetItems() {
			names = append(names, it.GetName())
		}
		when := time.Unix(t.GetCreatedAtUnix(), 0).Format("01-02 15:04")
		state := t.GetStatus()
		if t.GetError() != "" {
			state += " (" + t.GetError() + ")"
		}
		fmt.Printf("%s %s  %s %s  %s  %s  %s\n", dir, when, who, t.GetDeviceName(),
			strings.Join(names, ", "), humanBytes(t.GetTotalBytes()), state)
		for _, p := range t.GetPaths() {
			if t.GetDirection() == pb.TransferDirection_TRANSFER_DIRECTION_INCOMING {
				fmt.Printf("      %s\n", p)
			}
		}
	}
	return nil
}
