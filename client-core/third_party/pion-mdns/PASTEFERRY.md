# pion/mdns v2.2.2，带一处改动

来源：github.com/pion/mdns/v2 v2.2.2（MIT，见 LICENSE），只复制了非测试的源文件。

改动只有 `server.go` 里取网卡和网卡地址的两行：`net.Interfaces()` 换成 `anet.Interfaces()`，
`ifc.Addrs()` 换成 `anet.InterfaceAddrsByInterface(&ifc)`。

原因：Android 11 起 App 不能对 NETLINK_ROUTE 套接字 bind，也不能用 RTM_GETLINK，
Go 标准库的这两个函数在 Android 上都报 `route ip+net: netlinkrib: permission denied`，
mDNS 起不来，手机发现不了局域网里的电脑（design/phone-sync.md 3.3.2 节第 3 条）。
其他平台上 anet 直接调用标准库，行为不变。

`client-core/go.mod` 用 replace 指到这里。上游修好、或者 pion/mdns 能让调用方传入地址后，删掉这个目录和 replace。
