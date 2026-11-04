package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"time"

	"google.golang.org/protobuf/encoding/protojson"
	"google.golang.org/protobuf/proto"

	"github.com/baiyuze/pasteferry/client-core/internal/rpc"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// JSON mode is deliberately restricted to queries. Reject unsupported commands
// before opening a connection so an automation cannot accidentally change data.
func validateJSONCommand(cmd string) error {
	switch cmd {
	case "version", "status", "devices", "history":
		if flag.NArg() == 1 {
			return nil
		}
	case "config":
		if flag.NArg() == 1 || (flag.NArg() == 2 && flag.Arg(1) == "get") {
			return nil
		}
	}
	return fmt.Errorf("JSON 模式仅支持 version、status、devices、history、config [get]，不接受额外参数")
}

func writeJSON(data any) error {
	enc := json.NewEncoder(os.Stdout)
	enc.SetEscapeHTML(false)
	return enc.Encode(struct {
		OK   bool `json:"ok"`
		Data any  `json:"data"`
	}{true, data})
}

// Use the existing RPC schema, with stable snake_case field names, enum names,
// explicit defaults and empty arrays. ProtoJSON represents int64 as strings.
func writeProtoJSON(message proto.Message) error {
	data, err := (protojson.MarshalOptions{
		UseProtoNames: true, EmitUnpopulated: true,
	}).Marshal(message)
	if err != nil {
		return err
	}
	return writeJSON(json.RawMessage(data))
}

func queryJSON(ctx context.Context, client pb.DaemonServiceClient, ep rpc.Endpoint, cmd string) error {
	ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()
	switch cmd {
	case "status":
		status, err := client.GetStatus(ctx, &pb.Empty{})
		if err != nil {
			return err
		}
		data, err := (protojson.MarshalOptions{UseProtoNames: true, EmitUnpopulated: true}).Marshal(status)
		if err != nil {
			return err
		}
		return writeJSON(struct {
			PID    int             `json:"pid"`
			Port   int             `json:"port"`
			Daemon json.RawMessage `json:"daemon"`
		}{ep.PID, ep.Port, data})
	case "devices":
		response, err := client.ListDevices(ctx, &pb.Empty{})
		if err != nil {
			return err
		}
		return writeProtoJSON(response)
	case "history":
		response, err := client.ListHistory(ctx, &pb.ListHistoryRequest{Limit: 20})
		if err != nil {
			return err
		}
		return writeProtoJSON(response)
	case "config":
		response, err := client.GetConfig(ctx, &pb.Empty{})
		if err != nil {
			return err
		}
		return writeProtoJSON(response)
	default:
		return fmt.Errorf("不支持的 JSON 查询 %q", cmd)
	}
}
