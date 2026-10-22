package p2p_test

import (
	"context"
	"crypto/rand"
	"fmt"
	"os"
	"strconv"
	"sync"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/transport/p2p"
)

// TestStreamThroughput 量数据通道在本机回环上的吞吐上限，是隔空传送的测速原型
// （design/send-files.md 第 12 节第 1 项）。回环上没有网络瓶颈，量到的是 pion 的
// SCTP 与我们的分片、背压本身能跑多快。默认跳过：
//
//	PF_THROUGHPUT=1 go test ./internal/transport/p2p -run TestStreamThroughput -v
//
// PF_THROUGHPUT_MB 改总量（默认 1024），PF_THROUGHPUT_HIGH_KB 改背压高水位（默认 1024，
// 与 sync 包一致），PF_THROUGHPUT_STREAMS 改并行的数据通道数（默认 1）。
func TestStreamThroughput(t *testing.T) {
	if os.Getenv("PF_THROUGHPUT") == "" {
		t.Skip("测速原型，设 PF_THROUGHPUT=1 才运行")
	}
	totalMB := envInt("PF_THROUGHPUT_MB", 1024)
	highWater := uint64(envInt("PF_THROUGHPUT_HIGH_KB", 1024)) << 10
	streams := envInt("PF_THROUGHPUT_STREAMS", 1)

	r := newRelay()
	alice := newHarness(t, "alice", r)
	bob := newHarness(t, "bob", r)
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Minute)
	defer cancel()
	if err := alice.manager.Connect(ctx, "bob"); err != nil {
		t.Fatalf("建立连接: %v", err)
	}
	waitConnected(t, alice, "bob")
	waitConnected(t, bob, "alice")

	block := make([]byte, 4<<20)
	if _, err := rand.Read(block); err != nil {
		t.Fatal(err)
	}
	perStream := int64(totalMB) << 20 / int64(streams)

	start := time.Now()
	var wg sync.WaitGroup
	errs := make(chan error, 2*streams)
	for i := 0; i < streams; i++ {
		dc, err := alice.manager.OpenStream("bob", fmt.Sprintf("bench-%d", i))
		if err != nil {
			t.Fatalf("开数据流: %v", err)
		}
		opened := make(chan struct{})
		dc.OnOpen(func() { close(opened) })
		select {
		case <-opened:
		case <-time.After(20 * time.Second):
			t.Fatal("数据流未能打开")
		}
		var st *p2p.Stream
		select {
		case st = <-bob.streams:
		case <-time.After(20 * time.Second):
			t.Fatal("接收方未收到数据流")
		}

		wg.Add(2)
		go func() {
			defer wg.Done()
			var got int64
			for c := range st.Chunks() {
				got += int64(len(c))
				if got >= perStream {
					break
				}
			}
			if got < perStream {
				errs <- fmt.Errorf("只收到 %d / %d 字节", got, perStream)
			}
		}()
		go func() {
			defer wg.Done()
			const chunk = 60 * 1024
			var sent int64
			for sent < perStream {
				for dc.BufferedAmount() >= highWater {
					time.Sleep(2 * time.Millisecond)
				}
				off := sent % int64(len(block)-chunk)
				n := min(int64(chunk), perStream-sent)
				if err := dc.Send(block[off : off+n]); err != nil {
					errs <- err
					return
				}
				sent += n
			}
		}()
	}
	wg.Wait()
	close(errs)
	for err := range errs {
		t.Fatal(err)
	}
	elapsed := time.Since(start)
	t.Logf("%d MB，%d 条通道，高水位 %d KB：%.1f 秒，%.1f MB/s",
		totalMB, streams, highWater>>10, elapsed.Seconds(), float64(totalMB)/elapsed.Seconds())
}

func envInt(name string, def int) int {
	if v, err := strconv.Atoi(os.Getenv(name)); err == nil && v > 0 {
		return v
	}
	return def
}
