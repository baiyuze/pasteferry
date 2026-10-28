module github.com/baiyuze/pasteferry/client-core

go 1.26.10

require modernc.org/sqlite v1.59.0

require (
	github.com/dustin/go-humanize v1.0.1 // indirect
	github.com/ebitengine/purego v0.11.1 // indirect
	github.com/go-ole/go-ole v1.2.6 // indirect
	github.com/google/uuid v1.6.0 // indirect
	github.com/lufia/plan9stats v0.0.0-20211012122336-39d0f177ccd0 // indirect
	github.com/mattn/go-isatty v0.0.24 // indirect
	github.com/mozillazg/go-pinyin v0.21.0
	github.com/ncruces/go-strftime v1.0.0 // indirect
	github.com/pion/datachannel v1.6.3 // indirect
	github.com/pion/dtls/v3 v3.1.10 // indirect
	github.com/pion/interceptor v0.1.49 // indirect
	github.com/pion/randutil v0.1.0 // indirect
	github.com/pion/rtcp v1.2.19 // indirect
	github.com/pion/rtp v1.10.5 // indirect
	github.com/pion/sctp v1.12.0 // indirect
	github.com/pion/sdp/v3 v3.0.20 // indirect
	github.com/pion/srtp/v3 v3.1.3 // indirect
	github.com/pion/stun/v3 v3.1.5 // indirect
	github.com/pion/transport/v4 v4.1.0 // indirect
	github.com/pion/turn/v4 v4.1.4 // indirect
	github.com/power-devops/perfstat v0.0.0-20260805114148-88456608a4f6 // indirect
	github.com/remyoudompheng/bigfft v0.0.0-20230129092748-24d4a6f8daec // indirect
	github.com/tklauser/go-sysconf v0.4.0 // indirect
	github.com/tklauser/numcpus v0.12.0 // indirect
	github.com/wlynxg/anet v0.0.5
	github.com/yusufpapurcu/wmi v1.2.4 // indirect
	golang.org/x/crypto v0.58.0
	golang.org/x/time v0.14.0 // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20260706201446-f0a921348800 // indirect
	modernc.org/libc v1.75.7 // indirect
	modernc.org/mathutil v1.7.1 // indirect
	modernc.org/memory v1.12.1 // indirect
)

require (
	github.com/baiyuze/pasteferry/proto v0.0.0
	github.com/coder/websocket v1.8.15
	google.golang.org/grpc v1.84.0
	google.golang.org/protobuf v1.36.12
)

replace github.com/baiyuze/pasteferry/proto => ../proto

require (
	github.com/baiyuze/pasteferry/server v0.0.0
	github.com/godbus/dbus/v5 v5.2.2
	github.com/jezek/xgb v1.3.1
	github.com/klauspost/compress v1.20.0
	github.com/pion/ice/v4 v4.4.7
	github.com/pion/logging v0.2.4
	github.com/pion/mdns/v2 v2.2.2
	github.com/pion/stun/v4 v4.0.1
	github.com/pion/transport/v5 v5.1.1
	github.com/pion/turn/v5 v5.1.2
	github.com/pion/webrtc/v4 v4.2.23
	github.com/shirou/gopsutil/v4 v4.26.9
	golang.org/x/net v0.61.0
	golang.org/x/sys v0.49.0
	golang.org/x/text v0.43.0
)

require rsc.io/qr v0.2.0

require (
	golang.org/x/mobile v0.0.0-20261011034528-197770444867 // indirect
	golang.org/x/mod v0.42.0 // indirect
	golang.org/x/sync v0.24.0 // indirect
	golang.org/x/tools v0.52.0 // indirect
)

replace github.com/baiyuze/pasteferry/server => ../server

tool (
	golang.org/x/mobile/cmd/gobind
	golang.org/x/mobile/cmd/gomobile
)

replace github.com/pion/mdns/v2 => ./third_party/pion-mdns
