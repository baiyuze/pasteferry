package main

import (
	"bufio"
	"context"
	"errors"
	"fmt"
	"os"
	"strings"
	"time"

	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// 好友（2.6.0）：friends、friend code|add|remove|auto、accept、decline、name、receive-from

func showFriends(ctx context.Context, c pb.DaemonServiceClient) error {
	p, err := c.GetProfile(ctx, &pb.Empty{})
	if err != nil {
		return err
	}
	fmt.Printf("本机显示为  %s（头像：%v）\n\n", p.GetDisplayName(), p.GetHasAvatar())
	resp, err := c.ListFriends(ctx, &pb.Empty{})
	if err != nil {
		return err
	}
	if len(resp.GetFriends()) == 0 {
		fmt.Println("（还没有好友，用 friend code / friend add CODE 添加）")
		return nil
	}
	for _, f := range resp.GetFriends() {
		state := "离线"
		if f.GetOnline() {
			state = map[pb.ConnectionKind]string{pb.ConnectionKind_CONNECTION_KIND_DIRECT: "直连",
				pb.ConnectionKind_CONNECTION_KIND_RELAY: "中转"}[f.GetConnection()]
			if state == "" {
				state = "在线"
			}
		}
		recv := "收文件"
		switch {
		case !f.GetFeaturesKnown():
			recv = "未知"
		case f.GetReceiveDisabled():
			recv = "不收文件"
		case !f.GetReceivesFiles():
			recv = "需要更新"
		}
		extra := ""
		if f.GetAutoAccept() {
			extra += " 自动接收"
		}
		if f.GetReachability() != "" {
			extra += " " + f.GetReachability()
		}
		fmt.Printf("%-12s %-16s %-6s %-6s %-8s %s%s\n", f.GetDisplayName(), f.GetDeviceName(), f.GetPlatform(), state, recv, f.GetId(), extra)
	}
	return nil
}

func friendCommand(ctx context.Context, c pb.DaemonServiceClient, args []string) error {
	if len(args) == 0 {
		return errors.New("用法: friend code | friend add CODE [ADDRESS] | friend remove NAME | friend auto NAME on|off")
	}
	switch args[0] {
	case "code":
		return showFriendCode(ctx, c)
	case "add":
		if len(args) < 2 {
			return errors.New("用法: friend add CODE [ADDRESS]")
		}
		address := ""
		if len(args) > 2 {
			address = args[2]
		}
		req, err := c.RedeemFriendCode(ctx, &pb.RedeemPairingCodeRequest{Code: args[1], Address: address})
		if err != nil {
			return err
		}
		return confirmFriend(ctx, c, req)
	case "remove":
		f, err := findFriend(ctx, c, arg(args, 1))
		if err != nil {
			return err
		}
		_, err = c.RemoveFriend(ctx, &pb.FriendRef{DeviceId: f.GetId()})
		return err
	case "auto":
		f, err := findFriend(ctx, c, arg(args, 1))
		if err != nil {
			return err
		}
		_, err = c.SetFriendAutoAccept(ctx, &pb.SetFriendAutoAcceptRequest{DeviceId: f.GetId(), AutoAccept: arg(args, 2) == "on"})
		return err
	}
	return fmt.Errorf("未知的 friend 子命令 %q", args[0])
}

func arg(args []string, i int) string {
	if i < len(args) {
		return args[i]
	}
	return ""
}

// showFriendCode 显示好友码，等别人兑换后核对、确认
func showFriendCode(ctx context.Context, c pb.DaemonServiceClient) error {
	events, err := c.Subscribe(ctx, &pb.SubscribeRequest{})
	if err != nil {
		return err
	}
	resp, err := c.CreateFriendCode(ctx, &pb.Empty{})
	if err != nil {
		return err
	}
	fmt.Printf("好友码  %s  （%s 前有效）\n", resp.GetCode(), time.Unix(resp.GetExpiresAtUnix(), 0).Format("15:04:05"))
	if len(resp.GetLanAddresses()) > 0 {
		fmt.Printf("本机地址  %s\n", strings.Join(resp.GetLanAddresses(), "  "))
	}
	fmt.Println("等待对方输入…")
	for {
		ev, err := events.Recv()
		if err != nil {
			return err
		}
		if r := ev.GetFriendRequest(); r != nil {
			return confirmFriend(ctx, c, r)
		}
	}
}

func confirmFriend(ctx context.Context, c pb.DaemonServiceClient, r *pb.FriendRequest) error {
	events, err := c.Subscribe(ctx, &pb.SubscribeRequest{})
	if err != nil {
		return err
	}
	fmt.Printf("\n添加 %s · %s（%s）为好友？\n", r.GetDisplayName(), r.GetDeviceName(), r.GetPlatform())
	fmt.Printf("  安全码  对方 %s\n          本机 %s\n", r.GetFingerprint(), r.GetSelfFingerprint())
	fmt.Print("  添加？[y/N] ")
	line, _ := bufio.NewReader(os.Stdin).ReadString('\n')
	accept := strings.EqualFold(strings.TrimSpace(line), "y")
	if _, err := c.ConfirmFriend(ctx, &pb.ConfirmPairingRequest{PairingSession: r.GetSession(), Accept: accept}); err != nil {
		return err
	}
	if !accept {
		fmt.Println("  已取消")
		return nil
	}
	fmt.Println("  等待对方添加…")
	timeout := time.After(5 * time.Minute)
	got := make(chan error, 1)
	go func() {
		for {
			ev, err := events.Recv()
			if err != nil {
				got <- err
				return
			}
			if f := ev.GetFriendChanged(); f != nil && f.GetId() == r.GetDeviceId() {
				got <- nil
				return
			}
			if id := ev.GetFriendRemoved(); id == r.GetDeviceId() {
				got <- errors.New("对方取消了")
				return
			}
		}
	}()
	// 对方可能在本端确认之前已经添加了
	if list, err := c.ListFriends(ctx, &pb.Empty{}); err == nil {
		for _, f := range list.GetFriends() {
			if f.GetId() == r.GetDeviceId() {
				fmt.Println("  ✓ 已成为好友")
				return nil
			}
		}
	}
	select {
	case err := <-got:
		if err != nil {
			return err
		}
		fmt.Println("  ✓ 已成为好友")
		return nil
	case <-timeout:
		return errors.New("对方一直没有添加")
	}
}

func findFriend(ctx context.Context, c pb.DaemonServiceClient, name string) (*pb.Friend, error) {
	resp, err := c.ListFriends(ctx, &pb.Empty{})
	if err != nil {
		return nil, err
	}
	for _, f := range resp.GetFriends() {
		if f.GetId() == name || strings.EqualFold(f.GetDisplayName(), name) || strings.EqualFold(f.GetDeviceName(), name) {
			return f, nil
		}
	}
	return nil, fmt.Errorf("没有叫 %q 的好友", name)
}

// answerIncoming 接受或拒绝别人发来、在等本机用户接受的一批（ID 为空时取最近的一批）
func answerIncoming(ctx context.Context, c pb.DaemonServiceClient, id string, accept, always bool) error {
	if id == "" {
		resp, err := c.ListTransfers(ctx, &pb.ListTransfersRequest{Direction: pb.TransferDirection_TRANSFER_DIRECTION_INCOMING, Limit: 20})
		if err != nil {
			return err
		}
		for _, t := range resp.GetTransfers() {
			if t.GetStatus() == "asking" {
				id = t.GetId()
				break
			}
		}
		if id == "" {
			return errors.New("没有在等接受的文件")
		}
	}
	_, err := c.AnswerIncoming(ctx, &pb.AnswerIncomingRequest{TransferId: id, Accept: accept, Always: always})
	return err
}

func setName(ctx context.Context, c pb.DaemonServiceClient, name string) error {
	p, err := c.SetDisplayName(ctx, &pb.SetDisplayNameRequest{Name: name})
	if err != nil {
		return err
	}
	fmt.Println("显示为", p.GetDisplayName())
	return nil
}

func setAvatar(ctx context.Context, c pb.DaemonServiceClient, path string) error {
	var err error
	if path == "" || path == "reset" {
		_, err = c.ResetAvatar(ctx, &pb.Empty{})
	} else {
		_, err = c.SetAvatar(ctx, &pb.SetAvatarRequest{Path: path})
	}
	return err
}

// setReceiveFrom 改「允许这些人给我发文件」：off / friends / everyone
func setReceiveFrom(ctx context.Context, c pb.DaemonServiceClient, v string) error {
	cfg, err := c.GetConfig(ctx, &pb.Empty{})
	if err != nil {
		return err
	}
	if v == "" {
		fmt.Println(cfg.GetReceiveFrom())
		return nil
	}
	cfg.ReceiveFrom = v
	out, err := c.UpdateConfig(ctx, cfg)
	if err != nil {
		return err
	}
	fmt.Println(out.GetReceiveFrom())
	return nil
}
