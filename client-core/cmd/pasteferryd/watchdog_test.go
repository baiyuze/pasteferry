package main

import (
	"bytes"
	"log/slog"
	"strings"
	"testing"
	"time"
)

func TestExitWatchdogLogsStacksThenExits(t *testing.T) {
	var buf bytes.Buffer
	prev := slog.Default()
	slog.SetDefault(slog.New(slog.NewTextHandler(&buf, nil)))
	defer slog.SetDefault(prev)

	codes := make(chan int, 1)
	exitWatchdog(10*time.Millisecond, func(code int) { codes <- code })
	select {
	case code := <-codes:
		if code != 0 {
			t.Fatalf("exit code = %d, want 0 so the supervisor does not restart it", code)
		}
	case <-time.After(5 * time.Second):
		t.Fatal("watchdog never fired")
	}
	// 堆栈里能看到卡住的协程，比如正在等它的这个测试
	if log := buf.String(); !strings.Contains(log, "退出超时") || !strings.Contains(log, "TestExitWatchdogLogsStacksThenExits") {
		t.Fatalf("log lacks the stacks: %s", log)
	}
}
