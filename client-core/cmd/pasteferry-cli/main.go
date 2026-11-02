// pasteferry-cli 是开发调试用的命令行客户端。
//
// 它走与 Flutter UI 完全相同的 gRPC 接口，因此既能在 UI 就绪前验证 daemon，
// 也能在之后用来区分「是 daemon 的问题还是 UI 的问题」。
//
//	pasteferry-cli status              查看 daemon 状态
//	pasteferry-cli watch               订阅事件流
//	pasteferry-cli history             列出历史记录
//	pasteferry-cli config              查看配置
//	pasteferry-cli devices             列出已配对设备
//	pasteferry-cli nat                 网络出口、局域网与各设备连接情况
//	pasteferry-cli pair                生成配对码
//	pasteferry-cli join CODE [ADDRESS] 兑换配对码；不在同一网段时带上对方显示的地址
//	pasteferry-cli nearby [NAME]       搜索附近设备：给了 NAME 就在它出现时向它发起配对，否则等对方点本机
//	pasteferry-cli address DEVICE ADDR 手动指定某台设备的地址
//	pasteferry-cli send [-relay] DEVICE PATH...  隔空传送：把文件或文件夹发给一台设备
//	pasteferry-cli transfers [-v]      最近收到和发出的文件（-v 带上 ID）
//	pasteferry-cli cancel ID           取消一批传输
//	pasteferry-cli web [on|off|invite [ADDR]|remove ID]  手机网页传输
package main

import (
	"context"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/metadata"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/rpc"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// version 通过 -X main.version=... 在构建时注入，便于 brew 等打包工具标定版本。
var version = "0.1.0-dev"

// jsonOutput 是全局 -json / --json 开关。只读类命令把结构化结果打到 stdout，
// 供 Tinycast 扩展等界面直接解析；不加这个开关时输出仍是给人看的文本。
var jsonOutput bool

func main() {
	flag.BoolVar(&jsonOutput, "json", false, "以 JSON 输出（供界面或脚本解析）")
	dataDir := flag.String("data-dir", "", "数据目录（默认为系统标准位置）")
	flag.Parse()

	cmd := flag.Arg(0)
	if cmd == "" {
		fmt.Fprintln(os.Stderr,
			"用法: pasteferry-cli [-json] [-data-dir DIR] <status|version|watch|history|config [get|set KEY VALUE]|devices|nat|pair|join CODE [ADDRESS]|confirm SESSION|unpair DEVICE|apply ID|nearby [NAME]|address DEVICE ADDR|send [-relay] [-note TEXT] DEVICE PATH...|transfers [-v]|cancel ID|friends|friend code|add|remove|auto|accept [ID] [always]|decline [ID]|name NAME|avatar PATH|reset|receive-from [off|friends|everyone]|web [on|off|invite [ADDR]|remove ID]>")
		os.Exit(2)
	}

	if err := run(cmd, *dataDir); err != nil {
		if jsonOutput {
			// 界面按 stdout 解析；错误也走 JSON，stdout 始终只有一段可解析的内容
			_ = json.NewEncoder(os.Stdout).Encode(jsonError{OK: false, Error: err.Error()})
			os.Exit(1)
		}
		fmt.Fprintln(os.Stderr, "错误:", err)
		os.Exit(1)
	}
}

type jsonError struct {
	OK    bool   `json:"ok"`
	Error string `json:"error"`
}

func run(cmd, dataDir string) error {
	if cmd == "version" {
		if jsonOutput {
			return printJSON(map[string]any{"ok": true, "version": version})
		}
		fmt.Println(version)
		return nil
	}

	paths, err := resolvePaths(dataDir)
	if err != nil {
		return err
	}

	ep, err := rpc.ReadEndpoint(paths.Endpoint)
	if err != nil {
		if os.IsNotExist(err) {
			return fmt.Errorf("daemon 未运行（找不到 %s）", paths.Endpoint)
		}
		return err
	}

	conn, err := grpc.NewClient(fmt.Sprintf("127.0.0.1:%d", ep.Port),
		grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		return fmt.Errorf("连接 daemon: %w", err)
	}
	defer conn.Close()

	client := pb.NewDaemonServiceClient(conn)
	// token 随每次调用发送，daemon 侧用常数时间比较校验
	ctx := metadata.AppendToOutgoingContext(context.Background(), "x-pasteferry-token", ep.Token)

	switch cmd {
	case "status":
		if jsonOutput {
			return statusJSON(ctx, client, ep)
		}
		return showStatus(ctx, client, ep)
	case "watch":
		return watch(ctx, client)
	case "history":
		if jsonOutput {
			return historyJSON(ctx, client)
		}
		return showHistory(ctx, client)
	case "config":
		// 不带子命令时仍是给人看的文本；带 get/set 走 JSON
		if flag.NArg() < 2 {
			return showConfig(ctx, client)
		}
		return configCommand(ctx, client)
	case "devices":
		if jsonOutput {
			return devicesJSON(ctx, client)
		}
		return showDevices(ctx, client)
	case "nat":
		return showNetwork(ctx, client)
	case "pair":
		if jsonOutput {
			return pairingJSON(ctx, client)
		}
		return createPairing(ctx, client)
	case "confirm":
		return confirmJSON(ctx, client, flag.Arg(1), true)
	case "unpair":
		return unpairCommand(ctx, client, flag.Arg(1))
	case "apply":
		return applyCommand(ctx, client, flag.Arg(1), flag.Arg(2) == "plain")
	case "favorite":
		return favoriteCommand(ctx, client, flag.Arg(1), flag.Arg(2) != "off")
	case "join":
		return joinPairing(ctx, client, flag.Arg(1), flag.Arg(2))
	case "nearby":
		return nearbyPairing(ctx, client, flag.Arg(1))
	case "address":
		return setAddress(ctx, client, flag.Arg(1), flag.Arg(2))
	case "send":
		return sendFiles(ctx, client, flag.Args()[1:])
	case "transfers":
		return showTransfers(ctx, client, flag.Arg(1) == "-v")
	case "cancel":
		return cancelTransfer(ctx, client, flag.Arg(1))
	case "friends":
		return showFriends(ctx, client)
	case "friend":
		return friendCommand(ctx, client, flag.Args()[1:])
	case "accept":
		return answerIncoming(ctx, client, flag.Arg(1), true, flag.Arg(2) == "always")
	case "decline":
		return answerIncoming(ctx, client, flag.Arg(1), false, false)
	case "name":
		return setName(ctx, client, flag.Arg(1))
	case "avatar":
		return setAvatar(ctx, client, flag.Arg(1))
	case "strangers":
		return showStrangers(ctx, client)
	case "receive-from":
		return setReceiveFrom(ctx, client, flag.Arg(1))
	case "web":
		return webShare(ctx, client, flag.Args()[1:])
	default:
		return fmt.Errorf("未知命令 %q", cmd)
	}
}

func showDevices(ctx context.Context, c pb.DaemonServiceClient) error {
	ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	resp, err := c.ListDevices(ctx, &pb.Empty{})
	if err != nil {
		return err
	}
	self := resp.GetSelf()
	fmt.Printf("本机  %s  %s\n", self.GetName(), self.GetPublicKeyFingerprint())
	fmt.Printf("      %s\n\n", self.GetId())

	if len(resp.GetPeers()) == 0 {
		fmt.Println("（尚未配对任何设备，用 pair / join 建立配对）")
		return nil
	}
	for _, p := range resp.GetPeers() {
		fmt.Printf("%-16s %-10s %-8s %-10s %s\n",
			p.GetName(), p.GetPlatform(),
			connectionLabel(p), receiveLabel(p), p.GetPublicKeyFingerprint())
	}
	return nil
}

// receiveLabel 是对方能不能收隔空传送，后面带上它声明的版本号。
// 还没收到它的功能声明时只能说「未知」，不能当成旧版本
func receiveLabel(d *pb.Device) string {
	label := "收文件"
	switch {
	case !d.GetFeaturesKnown() && !d.GetReceivesFiles():
		return "未知"
	case !d.GetReceivesFiles():
		return "需要更新"
	case d.GetReceiveDisabled():
		label = "不收文件"
	}
	if v := d.GetAppVersion(); v != "" {
		label += " " + v
	}
	return label
}

// connectionLabel 区分直连与中转，便于排查网络问题：
// 一直显示「中转」说明 NAT 打洞没成功，走的是服务器带宽。
func connectionLabel(d *pb.Device) string {
	if !d.GetOnline() {
		return "离线"
	}
	switch d.GetConnection() {
	case pb.ConnectionKind_CONNECTION_KIND_DIRECT:
		return "直连"
	case pb.ConnectionKind_CONNECTION_KIND_RELAY:
		return "中转"
	default:
		return "在线"
	}
}

// createPairing 生成配对码并等待对方兑换。
func createPairing(ctx context.Context, c pb.DaemonServiceClient) error {
	// 先订阅事件流，才能在对方兑换后收到设备变化通知
	streamCtx, cancel := context.WithCancel(ctx)
	defer cancel()
	stream, err := c.Subscribe(streamCtx, &pb.SubscribeRequest{})
	if err != nil {
		return err
	}

	createCtx, createCancel := context.WithTimeout(ctx, 15*time.Second)
	resp, err := c.CreatePairingCode(createCtx, &pb.Empty{})
	createCancel()
	if err != nil {
		return err
	}

	fmt.Printf("\n  配对码：%s\n", resp.GetCode())
	fmt.Printf("  有效期至 %s\n", time.Unix(resp.GetExpiresAtUnix(), 0).Format("15:04:05"))
	if addrs := resp.GetLanAddresses(); len(addrs) > 0 {
		fmt.Printf("  本机地址：%s\n", strings.Join(addrs, "  "))
	}
	fmt.Println("\n  在另一台设备上运行：pasteferry-cli join " + resp.GetCode())
	if addrs := resp.GetLanAddresses(); len(addrs) > 0 {
		fmt.Printf("  不在同一网段时：pasteferry-cli join %s %s\n", resp.GetCode(), addrs[0])
	}
	fmt.Println("  等待对方兑换…（Ctrl+C 取消）")

	for {
		ev, err := stream.Recv()
		if err != nil {
			return err
		}
		d := ev.GetDeviceChanged()
		if d == nil || d.GetPairingSession() == "" {
			continue // 非待确认的配对事件（普通的在线状态变化）
		}
		fmt.Printf("\n  对方已兑换：%s（%s）\n", d.GetName(), d.GetPlatform())
		return confirmPeer(ctx, c, d, d.GetPairingSession())
	}
}

// confirmPeer 打印两行安全指纹，问用户是否一致，把回答告诉后台服务。
func confirmPeer(ctx context.Context, c pb.DaemonServiceClient, peer *pb.Device, session string) error {
	if err := printFingerprints(ctx, c, peer); err != nil {
		return err
	}
	fmt.Print("  确认配对？[y/N] ")

	var answer string
	fmt.Scanln(&answer)
	accept := answer == "y" || answer == "Y"

	confirmCtx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()
	if _, err := c.ConfirmPairing(confirmCtx, &pb.ConfirmPairingRequest{
		PairingSession: session,
		Accept:         accept,
	}); err != nil {
		return err
	}
	if accept {
		fmt.Println("\n  ✓ 配对成功")
	} else {
		fmt.Println("\n  已取消")
	}
	return nil
}

// printFingerprints 打印配对时要核对的两行：本机与对方的公钥指纹，按指纹排序。
// 两台设备打印出的内容完全相同，用户比对两块屏幕即可；规则与界面一致
// （见 ui/lib/widgets/pairing_dialog.dart 的 pairingFingerprintRows）。
func printFingerprints(ctx context.Context, c pb.DaemonServiceClient, peer *pb.Device) error {
	resp, err := c.ListDevices(ctx, &pb.Empty{})
	if err != nil {
		return err
	}
	rows := []*pb.Device{resp.GetSelf(), peer}
	sort.Slice(rows, func(i, j int) bool {
		return rows[i].GetPublicKeyFingerprint() < rows[j].GetPublicKeyFingerprint()
	})
	fmt.Println("  安全指纹：")
	for _, d := range rows {
		fmt.Printf("    %s  %s\n", d.GetPublicKeyFingerprint(), d.GetName())
	}
	fmt.Println("\n  两台设备上显示的这两行应当完全相同，一致才继续。")
	return nil
}

// showNetwork 打印后台服务最近一轮的网络出口探测结果，以及各设备当前走直连还是中转。
// 看的是后台服务实际在用的数据，而不是另起炉灶再测一遍。
func showNetwork(ctx context.Context, c pb.DaemonServiceClient) error {
	ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	info, err := c.GetNetwork(ctx, &pb.Empty{})
	if err != nil {
		return err
	}
	when := "尚未探测"
	if info.GetProbedAtUnix() > 0 {
		when = time.Unix(info.GetProbedAtUnix(), 0).Format("15:04:05")
	}
	fmt.Printf("打洞端口  %d（UDP）\n", info.GetLocalPort())
	fmt.Printf("最近探测  %s，%d 个服务器中 %d 个响应\n\n", when, info.GetProbed(), info.GetAnswered())

	measured := 0
	for _, e := range info.GetEgresses() {
		mode := "改端口  "
		if e.GetPortPreserved() {
			mode = "不改端口"
		}
		source := strings.Join(e.GetVia(), ", ")
		if e.GetGuessed() {
			source = "按历史推算"
		} else {
			measured++
		}
		fmt.Printf("  %-22s %s  %s\n", e.GetAddress(), mode, source)
	}
	switch n := len(info.GetEgresses()); {
	case n == 0:
		fmt.Println("  没有探测到出口：UDP 可能被拦截，设备之间只能走中转。")
	case n == 1:
		fmt.Println("\n单一出口。")
	default:
		fmt.Printf("\n%d 个出口：这是多出口网络。每个出口的地址都会发给对端，由对端逐个尝试。\n", n)
	}
	if measured > 0 && measured < len(info.GetEgresses()) {
		fmt.Println("按历史推算的出口这一轮没探测到，但它不改端口，地址可以推算出来。")
	}

	showLAN(info.GetLan())

	devs, err := c.ListDevices(ctx, &pb.Empty{})
	if err != nil {
		return nil
	}
	if peers := devs.GetPeers(); len(peers) > 0 {
		fmt.Println("\n设备连接：")
		for _, p := range peers {
			fmt.Printf("  %-18s %s\n", p.GetName(), connectionLabel(p))
		}
	}
	return nil
}

// showLAN 打印局域网直连的情况：本机在哪个端口、发现了几个实例、各设备在局域网里能否找到。
func showLAN(lan *pb.LanInfo) {
	if lan == nil {
		return
	}
	fmt.Println()
	if !lan.GetEnabled() {
		fmt.Println("局域网    已关闭")
		return
	}
	fmt.Printf("局域网    端口 %d（UDP），本机地址 %s\n", lan.GetPort(), strings.Join(lan.GetLocalAddresses(), "  "))
	fmt.Printf("          mDNS 发现了 %d 个 PasteFerry（含未配对的）\n", lan.GetDiscovered())
	if lan.GetBlocked() {
		fmt.Println("          系统拦下了发往局域网的包：到「系统设置 → 隐私与安全性 → 本地网络」里打开 PasteFerry")
	}
	for _, p := range lan.GetPeers() {
		state := "找不到"
		if p.GetReachable() {
			state = "可达 " + p.GetAddress()
		}
		fmt.Printf("  %-18s %s\n", p.GetDeviceName(), state)
		if known := p.GetKnownAddresses(); len(known) > 0 {
			fmt.Printf("  %-18s 记住的地址 %s\n", "", strings.Join(known, "  "))
		}
	}
}

func setAddress(ctx context.Context, c pb.DaemonServiceClient, device, addr string) error {
	if device == "" || addr == "" {
		return errors.New("用法: pasteferry-cli address <设备名或 ID> <地址>")
	}
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()
	devs, err := c.ListDevices(ctx, &pb.Empty{})
	if err != nil {
		return err
	}
	id := ""
	for _, p := range devs.GetPeers() {
		if p.GetId() == device || p.GetName() == device {
			id = p.GetId()
		}
	}
	if id == "" {
		return fmt.Errorf("没有叫 %q 的已配对设备", device)
	}
	if _, err := c.SetDeviceAddress(ctx, &pb.SetDeviceAddressRequest{DeviceId: id, Address: addr}); err != nil {
		return err
	}
	fmt.Println("已记下，正在那个地址上找它；用 pasteferry-cli nat 查看结果")
	return nil
}

func joinPairing(ctx context.Context, c pb.DaemonServiceClient, code, address string) error {
	if code == "" {
		return errors.New("用法: pasteferry-cli join <配对码> [对方地址]")
	}
	ctx, cancel := context.WithTimeout(ctx, 20*time.Second)
	defer cancel()

	resp, err := c.RedeemPairingCode(ctx, &pb.RedeemPairingCodeRequest{Code: code, Address: address})
	if err != nil {
		return err
	}
	peer := resp.GetPeer()
	fmt.Printf("\n  找到设备：%s（%s）\n", peer.GetName(), peer.GetPlatform())
	return confirmPeer(ctx, c, peer, resp.GetPairingSession())
}

// nearbyPairing 打开「搜索附近设备」，列出附近同样打开了的设备，直到配对完成或 Ctrl+C。
// 给了 target（设备名或实例名）时，它一出现就向它发起配对；没给时等对方点本机。
// 期间本机在局域网里公开设备名，与界面上开着这个窗口一样。
func nearbyPairing(ctx context.Context, c pb.DaemonServiceClient, target string) error {
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()
	events, err := c.Subscribe(ctx, &pb.SubscribeRequest{})
	if err != nil {
		return err
	}
	nearby, err := c.WatchNearby(ctx, &pb.Empty{})
	if err != nil {
		return err
	}

	requests := make(chan *pb.Device, 1)
	go func() {
		for {
			ev, err := events.Recv()
			if err != nil {
				return
			}
			if d := ev.GetDeviceChanged(); d != nil && d.GetPairingSession() != "" {
				select {
				case requests <- d:
				default:
				}
			}
		}
	}()
	lists := make(chan []*pb.NearbyDevice)
	lost := make(chan error, 1)
	go func() {
		for {
			msg, err := nearby.Recv()
			if err != nil {
				lost <- err
				return
			}
			select {
			case lists <- msg.GetDevices():
			case <-ctx.Done():
				return
			}
		}
	}()

	fmt.Println("\n  正在搜索附近的设备…（Ctrl+C 取消）")
	for {
		select {
		case err := <-lost:
			return err
		case list := <-lists:
			printNearby(list)
			for _, d := range list {
				if target == "" || d.GetPaired() || (d.GetName() != target && d.GetId() != target) {
					continue
				}
				pairCtx, pairCancel := context.WithTimeout(ctx, 20*time.Second)
				resp, err := c.PairNearby(pairCtx, &pb.PairNearbyRequest{Id: d.GetId()})
				pairCancel()
				if err != nil {
					return err
				}
				fmt.Printf("\n  %s 已回应\n", d.GetName())
				return confirmPeer(ctx, c, resp.GetPeer(), resp.GetPairingSession())
			}
		case d := <-requests:
			fmt.Printf("\n  %s（%s）请求配对\n", d.GetName(), d.GetPlatform())
			return confirmPeer(ctx, c, d, d.GetPairingSession())
		}
	}
}

func printNearby(list []*pb.NearbyDevice) {
	fmt.Printf("\n  %s 附近的设备：\n", time.Now().Format("15:04:05"))
	if len(list) == 0 {
		fmt.Println("    （没有。另一台也要打开「搜索附近设备」）")
	}
	for _, d := range list {
		note := d.GetId()
		if d.GetPaired() {
			note = "已配对"
		}
		fmt.Printf("    %-24s %-8s %s\n", d.GetName(), d.GetPlatform(), note)
	}
}

func resolvePaths(dataDir string) (config.Paths, error) {
	if dataDir != "" {
		abs, err := filepath.Abs(dataDir)
		if err != nil {
			return config.Paths{}, err
		}
		return config.PathsUnder(abs), nil
	}
	return config.DefaultPaths()
}

func showStatus(ctx context.Context, c pb.DaemonServiceClient, ep rpc.Endpoint) error {
	ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	st, err := c.GetStatus(ctx, &pb.Empty{})
	if err != nil {
		return err
	}
	fmt.Printf("daemon      PID %d  端口 %d  版本 %s\n", ep.PID, ep.Port, st.GetVersion())
	fmt.Printf("设备        %s\n", st.GetDeviceName())
	fmt.Printf("设备 ID     %s\n", st.GetDeviceId())
	server := "未设置（只在局域网里同步）"
	if st.GetServerConfigured() {
		server = boolText(st.GetSignalingConnected(), "已连接", "未连接")
	}
	fmt.Printf("服务器      %s\n", server)
	lan := boolText(st.GetLanEnabled(), "开启", "关闭")
	if st.GetLanBlocked() {
		lan += "（被系统拦截，需要允许本地网络访问）"
	}
	fmt.Printf("局域网      %s\n", lan)
	fmt.Printf("在线对端    %d\n", st.GetPeersOnline())
	fmt.Printf("剪贴板授权  %s\n", st.GetClipboardPermission())
	fmt.Printf("缓存占用    %s\n", humanBytes(st.GetCacheBytesUsed()))
	if u := st.GetOfficialUsage(); u != nil {
		switch {
		case u.GetUpdatedAtUnix() == 0 && u.GetReason() == "":
			fmt.Println("官方额度    正在获取")
		case u.GetUpdatedAtUnix() == 0:
			fmt.Printf("官方额度    暂时获取不到（%s）\n", u.GetReason())
		default:
			// 网关按十进制 MB 计量，与界面显示一致
			mb := func(n int64) string { return fmt.Sprintf("%.2f MB", float64(n)/1e6) }
			line := fmt.Sprintf("剩余 %s / 每日 %s，已用 %s（上传 %s，下载 %s）", mb(u.GetRemainingBytes()), mb(u.GetLimitBytes()),
				mb(u.GetUploadBytes()+u.GetDownloadBytes()), mb(u.GetUploadBytes()), mb(u.GetDownloadBytes()))
			if u.GetReason() != "" {
				line += "，" + u.GetReason()
			}
			fmt.Printf("官方额度    %s，更新于 %s\n", line, time.Unix(u.GetUpdatedAtUnix(), 0).Format("15:04:05"))
		}
	}
	return nil
}

func watch(ctx context.Context, c pb.DaemonServiceClient) error {
	stream, err := c.Subscribe(ctx, &pb.SubscribeRequest{})
	if err != nil {
		return err
	}
	fmt.Println("已订阅事件流，Ctrl+C 退出")
	for {
		ev, err := stream.Recv()
		if errors.Is(err, io.EOF) {
			fmt.Println("流已结束")
			return nil
		}
		if err != nil {
			return err
		}
		printEvent(ev)
	}
}

func printEvent(ev *pb.Event) {
	ts := time.Now().Format("15:04:05")
	switch p := ev.GetPayload().(type) {
	case *pb.Event_ClipAdded:
		r := p.ClipAdded
		fmt.Printf("[%s] + 新记录  %s  %s  %s  %q\n", ts,
			r.GetKind(), r.GetStatus(), humanBytes(r.GetTotalSize()), r.GetTextPreview())
	case *pb.Event_ClipUpdated:
		r := p.ClipUpdated
		fmt.Printf("[%s] ~ 更新    %s  %s\n", ts, r.GetId(), r.GetStatus())
	case *pb.Event_ClipRemoved:
		fmt.Printf("[%s] - 删除    %s\n", ts, p.ClipRemoved)
	case *pb.Event_Progress:
		pr := p.Progress
		fmt.Printf("[%s] ↓ 进度    %s  %s/%s\n", ts, pr.GetClipId(),
			humanBytes(pr.GetTransferred()), humanBytes(pr.GetTotal()))
	case *pb.Event_DeviceChanged:
		d := p.DeviceChanged
		fmt.Printf("[%s] ⇄ 设备    %s  %s  %s\n", ts,
			d.GetName(), boolText(d.GetOnline(), "在线", "离线"), d.GetConnection())
	case *pb.Event_PermissionChanged:
		fmt.Printf("[%s] ! 授权    %s\n", ts, p.PermissionChanged)
	case *pb.Event_StatusChanged:
		s := p.StatusChanged
		fmt.Printf("[%s] i 状态    信令=%v 对端=%d 授权=%s\n", ts,
			s.GetSignalingConnected(), s.GetPeersOnline(), s.GetClipboardPermission())
	default:
		fmt.Printf("[%s] ? 未知事件 %T\n", ts, p)
	}
}

func showHistory(ctx context.Context, c pb.DaemonServiceClient) error {
	ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	resp, err := c.ListHistory(ctx, &pb.ListHistoryRequest{Limit: 20})
	if err != nil {
		return err
	}
	if len(resp.GetRecords()) == 0 {
		fmt.Println("（暂无记录）")
		return nil
	}
	for _, r := range resp.GetRecords() {
		dir := "←收到"
		if r.GetOutgoing() {
			dir = "→本机"
		}
		fmt.Printf("%s  %s  %-6s %-14s %8s  %s\n",
			time.Unix(r.GetCreatedAtUnix(), 0).Format("01-02 15:04:05"),
			dir, r.GetKind(), r.GetStatus(),
			humanBytes(r.GetTotalSize()), preview(r))
	}
	return nil
}

func preview(r *pb.ClipRecord) string {
	if t := r.GetTextPreview(); t != "" {
		return fmt.Sprintf("%q", t)
	}
	switch n := len(r.GetItems()); n {
	case 0:
		return ""
	case 1:
		return r.GetItems()[0].GetName()
	default:
		return fmt.Sprintf("%s 等 %d 项", r.GetItems()[0].GetName(), n)
	}
}

func showConfig(ctx context.Context, c pb.DaemonServiceClient) error {
	ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	cfg, err := c.GetConfig(ctx, &pb.Empty{})
	if err != nil {
		return err
	}
	fmt.Printf("设备名称      %s\n", cfg.GetDeviceName())
	server := cfg.GetSignalingUrl()
	if server == "" {
		server = "（未设置）"
	}
	fmt.Printf("信令地址      %s\n", server)
	fmt.Printf("局域网发现    %v\n", !cfg.GetLanDisabled())
	fmt.Printf("自动同步阈值  %s\n", humanBytes(cfg.GetAutoSyncThresholdBytes()))
	fmt.Printf("历史保留      %s\n", time.Duration(cfg.GetHistoryTtlSeconds())*time.Second)
	fmt.Printf("缓存保留      %s\n", time.Duration(cfg.GetCacheTtlSeconds())*time.Second)
	fmt.Printf("同步类型      文本=%v HTML=%v 图片=%v 文件=%v\n",
		cfg.GetSyncText(), cfg.GetSyncHtml(), cfg.GetSyncImage(), cfg.GetSyncFile())
	fmt.Printf("自动写剪贴板  %v\n", cfg.GetAutoApplyToClipboard())
	return nil
}

func boolText(b bool, yes, no string) string {
	if b {
		return yes
	}
	return no
}

func humanBytes(n int64) string {
	const unit = 1024
	if n < unit {
		return fmt.Sprintf("%d B", n)
	}
	div, exp := int64(unit), 0
	for v := n / unit; v >= unit; v /= unit {
		div *= unit
		exp++
	}
	return fmt.Sprintf("%.1f %ciB", float64(n)/float64(div), "KMGTPE"[exp])
}

// ---- JSON 输出入口 ----

type statusJSONResp struct {
	OK   bool   `json:"ok"`
	Msg  string `json:"message,omitempty"`
	Data struct {
		Daemon struct {
			PID        int     `json:"pid"`
			Port       int     `json:"port"`
			Version    string  `json:"version"`
			DeviceID   string  `json:"device_id"`
			DeviceName string  `json:"device_name"`
			Signaling  string  `json:"signaling"`
			LAN        string  `json:"lan"`
			Peers      int     `json:"peers_online"`
			Clipboard  string  `json:"clipboard_permission"`
			CacheMB    float64 `json:"cache_bytes_used_mb"`
		} `json:"daemon"`
		OfficialUsage struct {
			Available        bool    `json:"available"`
			UploadBytesMB    float64 `json:"upload_bytes_mb"`
			DownloadBytesMB  float64 `json:"download_bytes_mb"`
			LimitBytesMB     float64 `json:"limit_bytes_mb"`
			RemainingBytesMB float64 `json:"remaining_bytes_mb"`
			UpdatedAtUnix    int64   `json:"updated_at_unix"`
			ResetAtUnix      int64   `json:"reset_at_unix"`
			Reason           string  `json:"reason"`
		} `json:"official_usage"`
	} `json:"data"`
}

func statusJSON(ctx context.Context, c pb.DaemonServiceClient, ep rpc.Endpoint) error {
	ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	st, err := c.GetStatus(ctx, &pb.Empty{})
	if err != nil {
		return err
	}
	resp := statusJSONResp{OK: true}
	resp.Data.Daemon.PID = ep.PID
	resp.Data.Daemon.Port = ep.Port
	resp.Data.Daemon.Version = st.GetVersion()
	resp.Data.Daemon.DeviceID = st.GetDeviceId()
	resp.Data.Daemon.DeviceName = st.GetDeviceName()
	resp.Data.Daemon.Signaling = boolText(st.GetSignalingConnected(), "已连接", "未连接")
	resp.Data.Daemon.LAN = boolText(st.GetLanEnabled(), "开启", "关闭")
	if st.GetLanBlocked() {
		resp.Data.Daemon.LAN += "（被系统拦截，需要允许本地网络访问）"
	}
	resp.Data.Daemon.Peers = int(st.GetPeersOnline())
	resp.Data.Daemon.Clipboard = statusJSONClip(st.GetClipboardPermission())
	resp.Data.Daemon.CacheMB = float64(st.GetCacheBytesUsed()) / 1024 / 1024
	if u := st.GetOfficialUsage(); u != nil {
		resp.Data.OfficialUsage = struct {
			Available        bool    `json:"available"`
			UploadBytesMB    float64 `json:"upload_bytes_mb"`
			DownloadBytesMB  float64 `json:"download_bytes_mb"`
			LimitBytesMB     float64 `json:"limit_bytes_mb"`
			RemainingBytesMB float64 `json:"remaining_bytes_mb"`
			UpdatedAtUnix    int64   `json:"updated_at_unix"`
			ResetAtUnix      int64   `json:"reset_at_unix"`
			Reason           string  `json:"reason"`
		}{
			Available:        u.GetAvailable(),
			UploadBytesMB:    func(n int64) float64 { return float64(n) / 1024 / 1024 }(u.GetUploadBytes()),
			DownloadBytesMB:  func(n int64) float64 { return float64(n) / 1024 / 1024 }(u.GetDownloadBytes()),
			LimitBytesMB:     func(n int64) float64 { return float64(n) / 1024 / 1024 }(u.GetLimitBytes()),
			RemainingBytesMB: func(n int64) float64 { return float64(n) / 1024 / 1024 }(u.GetRemainingBytes()),
			UpdatedAtUnix:    u.GetUpdatedAtUnix(),
			ResetAtUnix:      u.GetResetAtUnix(),
			Reason:           u.GetReason(),
		}
	}
	return printJSON(resp)
}

func statusJSONClip(p pb.ClipboardPermission) string {
	switch p {
	case pb.ClipboardPermission_CLIPBOARD_PERMISSION_ALWAYS_ALLOW:
		return "always_allow"
	case pb.ClipboardPermission_CLIPBOARD_PERMISSION_ASK:
		return "ask"
	case pb.ClipboardPermission_CLIPBOARD_PERMISSION_DEFAULT:
		return "default"
	default:
		return p.String()
	}
}

func printJSON(v any) error {
	enc := json.NewEncoder(os.Stdout)
	enc.SetEscapeHTML(false)
	return enc.Encode(v)
}

type devicesJSONResp struct {
	OK   bool   `json:"ok"`
	Msg  string `json:"message,omitempty"`
	Data struct {
		Self struct {
			ID       string `json:"id"`
			Name     string `json:"name"`
			Platform string `json:"platform"`
		} `json:"self"`
		Peers []struct {
			ID          string `json:"id"`
			Name        string `json:"name"`
			Platform    string `json:"platform"`
			Online      bool   `json:"online"`
			Connection  string `json:"connection"`
			Receives    bool   `json:"receives_files"`
			ReceiveOff  bool   `json:"receive_disabled"`
			LAN         bool   `json:"lan_reachable"`
			Fingerprint string `json:"public_key_fingerprint"`
			PairedAt    int64  `json:"paired_at_unix"`
			Pairing     string `json:"pairing_session,omitempty"`
		} `json:"peers"`
	} `json:"data"`
}

func devicesJSON(ctx context.Context, c pb.DaemonServiceClient) error {
	ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	resp, err := c.ListDevices(ctx, &pb.Empty{})
	if err != nil {
		return err
	}
	js := devicesJSONResp{OK: true}
	js.Data.Peers = []struct {
		ID          string `json:"id"`
		Name        string `json:"name"`
		Platform    string `json:"platform"`
		Online      bool   `json:"online"`
		Connection  string `json:"connection"`
		Receives    bool   `json:"receives_files"`
		ReceiveOff  bool   `json:"receive_disabled"`
		LAN         bool   `json:"lan_reachable"`
		Fingerprint string `json:"public_key_fingerprint"`
		PairedAt    int64  `json:"paired_at_unix"`
		Pairing     string `json:"pairing_session,omitempty"`
	}{}
	js.Data.Self.ID = resp.GetSelf().GetId()
	js.Data.Self.Name = resp.GetSelf().GetName()
	js.Data.Self.Platform = resp.GetSelf().GetPlatform()
	for _, p := range resp.GetPeers() {
		js.Data.Peers = append(js.Data.Peers, struct {
			ID          string `json:"id"`
			Name        string `json:"name"`
			Platform    string `json:"platform"`
			Online      bool   `json:"online"`
			Connection  string `json:"connection"`
			Receives    bool   `json:"receives_files"`
			ReceiveOff  bool   `json:"receive_disabled"`
			LAN         bool   `json:"lan_reachable"`
			Fingerprint string `json:"public_key_fingerprint"`
			PairedAt    int64  `json:"paired_at_unix"`
			Pairing     string `json:"pairing_session,omitempty"`
		}{
			ID:          p.GetId(),
			Name:        p.GetName(),
			Platform:    p.GetPlatform(),
			Online:      p.GetOnline(),
			Connection:  p.GetConnection().String(),
			Receives:    p.GetReceivesFiles(),
			ReceiveOff:  p.GetReceiveDisabled(),
			LAN:         p.GetLanReachable(),
			Fingerprint: p.GetPublicKeyFingerprint(),
			PairedAt:    p.GetPairedAtUnix(),
			Pairing:     p.GetPairingSession(),
		})
	}
	return printJSON(js)
}

type historyJSONResp struct {
	OK   bool   `json:"ok"`
	Msg  string `json:"message,omitempty"`
	Data struct {
		Records []struct {
			ID         string  `json:"id"`
			Kind       string  `json:"kind"`
			Status     string  `json:"status"`
			Outgoing   bool    `json:"outgoing"`
			OriginID   string  `json:"origin_device_id"`
			OriginName string  `json:"origin_device_name"`
			Count      int     `json:"item_count"`
			SizeMB     float64 `json:"total_size_mb"`
			Preview    string  `json:"text_preview"`
			CreatedAt  int64   `json:"created_at_unix"`
			ExpiresAt  int64   `json:"expires_at_unix"`
			Error      string  `json:"error,omitempty"`
			Favorite   bool    `json:"favorite"`
			Favorited  bool    `json:"favorited"`
			IsLink     bool    `json:"is_link"`
			Alias      string  `json:"alias"`
		} `json:"records"`
	} `json:"data"`
}

func historyJSON(ctx context.Context, c pb.DaemonServiceClient) error {
	ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	resp, err := c.ListHistory(ctx, &pb.ListHistoryRequest{Limit: 20})
	if err != nil {
		return err
	}
	js := historyJSONResp{OK: true}
	js.Data.Records = []struct {
		ID         string  `json:"id"`
		Kind       string  `json:"kind"`
		Status     string  `json:"status"`
		Outgoing   bool    `json:"outgoing"`
		OriginID   string  `json:"origin_device_id"`
		OriginName string  `json:"origin_device_name"`
		Count      int     `json:"item_count"`
		SizeMB     float64 `json:"total_size_mb"`
		Preview    string  `json:"text_preview"`
		CreatedAt  int64   `json:"created_at_unix"`
		ExpiresAt  int64   `json:"expires_at_unix"`
		Error      string  `json:"error,omitempty"`
		Favorite   bool    `json:"favorite"`
		Favorited  bool    `json:"favorited"`
		IsLink     bool    `json:"is_link"`
		Alias      string  `json:"alias"`
	}{}
	for _, r := range resp.GetRecords() {
		js.Data.Records = append(js.Data.Records, struct {
			ID         string  `json:"id"`
			Kind       string  `json:"kind"`
			Status     string  `json:"status"`
			Outgoing   bool    `json:"outgoing"`
			OriginID   string  `json:"origin_device_id"`
			OriginName string  `json:"origin_device_name"`
			Count      int     `json:"item_count"`
			SizeMB     float64 `json:"total_size_mb"`
			Preview    string  `json:"text_preview"`
			CreatedAt  int64   `json:"created_at_unix"`
			ExpiresAt  int64   `json:"expires_at_unix"`
			Error      string  `json:"error,omitempty"`
			Favorite   bool    `json:"favorite"`
			Favorited  bool    `json:"favorited"`
			IsLink     bool    `json:"is_link"`
			Alias      string  `json:"alias"`
		}{
			ID:         r.GetId(),
			Kind:       r.GetKind().String(),
			Status:     r.GetStatus().String(),
			Outgoing:   r.GetOutgoing(),
			OriginID:   r.GetOriginDeviceId(),
			OriginName: r.GetOriginDeviceName(),
			Count:      len(r.GetItems()),
			SizeMB:     float64(r.GetTotalSize()) / 1024 / 1024,
			Preview:    r.GetTextPreview(),
			CreatedAt:  r.GetCreatedAtUnix(),
			ExpiresAt:  r.GetExpiresAtUnix(),
			Error:      r.GetError(),
			Favorite:   r.GetFavorite(),
			Favorited:  r.GetFavorited(),
			IsLink:     r.GetIsLink(),
			Alias:      r.GetAlias(),
		})
	}
	return printJSON(js)
}

type pairJSONResp struct {
	OK   bool   `json:"ok"`
	Msg  string `json:"message,omitempty"`
	Data struct {
		Code      string   `json:"code"`
		ExpiresAt int64    `json:"expires_at_unix"`
		LAN       []string `json:"lan_addresses"`
		Peer      struct {
			ID          string `json:"id"`
			Name        string `json:"name"`
			Platform    string `json:"platform"`
			Online      bool   `json:"online"`
			Fingerprint string `json:"public_key_fingerprint"`
			Receives    bool   `json:"receives_files"`
			ReceiveOff  bool   `json:"receive_disabled"`
			Pairing     string `json:"pairing_session,omitempty"`
		} `json:"peer"`
	} `json:"data"`
}

func pairingJSON(ctx context.Context, c pb.DaemonServiceClient) error {
	ctx, cancel := context.WithTimeout(ctx, 15*time.Second)
	defer cancel()

	createCtx, createCancel := context.WithTimeout(ctx, 15*time.Second)
	resp, err := c.CreatePairingCode(createCtx, &pb.Empty{})
	createCancel()
	if err != nil {
		return err
	}
	js := pairJSONResp{OK: true}
	js.Data.Code = resp.GetCode()
	js.Data.ExpiresAt = resp.GetExpiresAtUnix()
	js.Data.LAN = append([]string(nil), resp.GetLanAddresses()...)
	return printJSON(js)
}

func configCommand(ctx context.Context, c pb.DaemonServiceClient) error {
	switch flag.Arg(1) {
	case "get":
		if flag.NArg() != 2 {
			return errors.New("用法: pasteferry-cli config get")
		}
		cfg, err := c.GetConfig(ctx, &pb.Empty{})
		if err != nil {
			return err
		}
		return printJSON(configJSON(cfg))
	case "set":
		if flag.NArg() < 4 {
			return errors.New("用法: pasteferry-cli config set KEY VALUE")
		}
		req := pb.Config{}
		switch flag.Arg(2) {
		case "name":
			req.DeviceName = flag.Arg(3)
		case "receive-from":
			req.ReceiveFrom = flag.Arg(3)
		case "receive-disabled":
			req.ReceiveDisabled = flag.Arg(3) == "true"
		case "lan-disabled":
			req.LanDisabled = flag.Arg(3) == "true"
		default:
			return errors.New("不支持的配置项: " + flag.Arg(2))
		}
		_, err := c.UpdateConfig(ctx, &req)
		if err != nil {
			return err
		}
		return printJSON(map[string]any{"ok": true, "updated": flag.Arg(2)})
	default:
		return errors.New("未知 config 子命令: " + flag.Arg(1))
	}
}

func configJSON(cfg *pb.Config) map[string]any {
	return map[string]any{
		"device_name":      cfg.GetDeviceName(),
		"signaling_url":    cfg.GetSignalingUrl(),
		"receive_from":     cfg.GetReceiveFrom(),
		"receive_disabled": cfg.GetReceiveDisabled(),
		"lan_disabled":     cfg.GetLanDisabled(),
		"auto_apply":       cfg.GetAutoApplyToClipboard(),
		"launch_at_login":  cfg.GetLaunchAtLogin(),
		"sync_text":        cfg.GetSyncText(),
		"sync_html":        cfg.GetSyncHtml(),
		"sync_image":       cfg.GetSyncImage(),
		"sync_file":        cfg.GetSyncFile(),
		"history_ttl":      cfg.GetHistoryTtlSeconds(),
		"receive_dir":      cfg.GetReceiveDir(),
	}
}

type confirmJSONResp struct {
	OK   bool   `json:"ok"`
	Msg  string `json:"message,omitempty"`
	Data struct {
		Peer struct {
			ID   string `json:"id"`
			Name string `json:"name"`
		} `json:"peer"`
	} `json:"data"`
}

func confirmJSON(ctx context.Context, c pb.DaemonServiceClient, session string, accept bool) error {
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()
	_, err := c.ConfirmPairing(ctx, &pb.ConfirmPairingRequest{
		PairingSession: session,
		Accept:         accept,
	})
	if err != nil {
		return err
	}
	return printJSON(confirmJSONResp{OK: true})
}

func unpairCommand(ctx context.Context, c pb.DaemonServiceClient, device string) error {
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()
	devs, err := c.ListDevices(ctx, &pb.Empty{})
	if err != nil {
		return err
	}
	var id string
	for _, p := range devs.GetPeers() {
		if p.GetId() == device || p.GetName() == device {
			id = p.GetId()
		}
	}
	if id == "" {
		return errors.New("没有匹配的已配对设备: " + device)
	}
	if _, err := c.Unpair(ctx, &pb.UnpairRequest{DeviceId: id}); err != nil {
		return err
	}
	return printJSON(map[string]any{"ok": true, "unpaired": id})
}

func applyCommand(ctx context.Context, c pb.DaemonServiceClient, id string, plain bool) error {
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()
	_, err := c.ApplyToClipboard(ctx, &pb.ApplyToClipboardRequest{
		ClipId:    id,
		PlainText: plain,
	})
	if err != nil {
		return err
	}
	return printJSON(map[string]any{"ok": true, "applied": id})
}

func favoriteCommand(ctx context.Context, c pb.DaemonServiceClient, id string, on bool) error {
	if id == "" {
		return errors.New("用法: pasteferry-cli favorite ID [off]")
	}
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()
	_, err := c.SetFavorite(ctx, &pb.SetFavoriteRequest{
		ClipId:   id,
		Favorite: on,
	})
	if err != nil {
		return err
	}
	return printJSON(map[string]any{"ok": true, "favorited": id, "on": on})
}
