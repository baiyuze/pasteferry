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
	note := ""
	var rest []string
	for i := 0; i < len(args); i++ {
		a := args[i]
		if a == "-relay" || a == "--relay" {
			allowRelay = true
			continue
		}
		if (a == "-note" || a == "--note") && i+1 < len(args) {
			note = args[i+1]
			i++
			continue
		}
		rest = append(rest, a)
	}
	if len(rest) < 2 {
		return errors.New("用法: send [-relay] [-note TEXT] DEVICE PATH...")
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
		// 好友，或者「所有人」模式下附近的陌生设备（lan:实例名）
		if f, ferr := findFriend(ctx, c, rest[0]); ferr == nil {
			target = &pb.Device{Id: f.GetId(), Name: f.GetDisplayName() + " · " + f.GetDeviceName()}
		} else if strings.HasPrefix(rest[0], "lan:") {
			target = &pb.Device{Id: rest[0], Name: rest[0]}
		}
	}
	if target == nil {
		return fmt.Errorf("没有叫 %q 的已配对设备或好友", rest[0])
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
	t, err := c.SendFiles(ctx, &pb.SendFilesRequest{DeviceId: target.GetId(), Paths: paths, AllowRelay: allowRelay, Note: note})
	if err != nil {
		if s, ok := status.FromError(err); ok && s.Code() == codes.FailedPrecondition && s.Message() == "relay" {
			return errors.New("要经服务中转（有每日额度），确认要发的话加上 -relay")
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
	case "asking":
		return "等待对方接受…"
	case "declined":
		return "declined " + t.GetError()
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

// showTransfers 列出最近收到和发出的文件。verbose 时带上 ID（取消时用）。
func showTransfers(ctx context.Context, c pb.DaemonServiceClient, verbose bool) error {
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
		id := ""
		if verbose {
			id = t.GetId()[:8] + "  "
		}
		fmt.Printf("%s %s%s  %s %s  %s  %s  %s\n", dir, id, when, who, t.GetDeviceName(),
			strings.Join(names, ", "), humanBytes(t.GetTotalBytes()), state)
		if t.GetNote() != "" {
			fmt.Printf("      备注：%s\n", t.GetNote())
		}
		for _, p := range t.GetPaths() {
			if t.GetDirection() == pb.TransferDirection_TRANSFER_DIRECTION_INCOMING {
				fmt.Printf("      %s\n", p)
			}
		}
	}
	return nil
}

// cancelTransfer 取消一批（发出的或收到的），ID 可以只写开头几位。
func cancelTransfer(ctx context.Context, c pb.DaemonServiceClient, prefix string) error {
	if prefix == "" {
		return errors.New("用法: cancel ID（pasteferry-cli transfers -v 查看 ID）")
	}
	resp, err := c.ListTransfers(ctx, &pb.ListTransfersRequest{Limit: 200})
	if err != nil {
		return err
	}
	var match []*pb.Transfer
	for _, t := range resp.GetTransfers() {
		if strings.HasPrefix(t.GetId(), prefix) {
			match = append(match, t)
		}
	}
	switch len(match) {
	case 0:
		return fmt.Errorf("没有 ID 以 %q 开头的传输", prefix)
	case 1:
	default:
		return fmt.Errorf("有 %d 个传输的 ID 以 %q 开头，请多写几位", len(match), prefix)
	}
	if _, err := c.CancelTransfer(ctx, &pb.TransferRef{Id: match[0].GetId()}); err != nil {
		return err
	}
	fmt.Println("已取消")
	return nil
}
