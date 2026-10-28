package main

import (
	"context"
	"fmt"
	"time"

	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// webShare 是手机网页传输（design/phone-sync.md 第 2 节）：
//
//	web                 开关、端口、地址与登记的手机
//	web on | off        打开或关闭
//	web invite [ADDR]   生成一张二维码，打印其中的网址（10 分钟内有效，只能登记一台手机）
//	web remove ID       移除一台登记过的手机
func webShare(ctx context.Context, c pb.DaemonServiceClient, args []string) error {
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()
	sub := ""
	if len(args) > 0 {
		sub = args[0]
	}
	var st *pb.WebShareStatus
	var err error
	switch sub {
	case "":
		st, err = c.GetWebShare(ctx, &pb.Empty{})
	case "on", "off":
		st, err = c.SetWebShare(ctx, &pb.SetWebShareRequest{Enabled: sub == "on"})
	case "invite":
		addr := ""
		if len(args) > 1 {
			addr = args[1]
		}
		inv, err := c.NewWebShareInvite(ctx, &pb.NewWebShareInviteRequest{Address: addr})
		if err != nil {
			return err
		}
		fmt.Println(inv.GetUrl())
		fmt.Println("有效到", time.Unix(inv.GetExpiresAtUnix(), 0).Format("15:04:05"))
		return nil
	case "remove":
		if len(args) < 2 {
			return fmt.Errorf("用法: web remove ID")
		}
		st, err = c.RemoveWebSession(ctx, &pb.WebSessionRef{Id: args[1]})
	default:
		return fmt.Errorf("用法: web [on|off|invite [ADDR]|remove ID]")
	}
	if err != nil {
		return err
	}
	state := "关"
	switch {
	case st.GetListening():
		state = fmt.Sprintf("开，监听端口 %d", st.GetPort())
		if st.GetPortFallback() {
			state += "（固定端口被占用，用了随机端口）"
		}
	case st.GetEnabled():
		state = "开，但没能监听：" + st.GetError()
	}
	fmt.Println("手机网页传输：", state)
	fmt.Println("地址：", st.GetAddresses())
	for _, s := range st.GetSessions() {
		fmt.Printf("  %s  %s  最后使用 %s\n", s.GetId(), s.GetName(), time.Unix(s.GetLastSeenUnix(), 0).Format("01-02 15:04"))
	}
	return nil
}
