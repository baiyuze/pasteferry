package rpc

import (
	"testing"

	"github.com/baiyuze/pasteferry/client-core/internal/send"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func TestConnectingTransferError(t *testing.T) {
	s := status.Convert(transferError(send.ErrConnecting))
	if s.Code() != codes.FailedPrecondition || s.Message() != "connecting" {
		t.Fatalf("连接中不能变成不支持或内部错误: %v", s)
	}
}
