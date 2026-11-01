package send

import (
	"path/filepath"
	"testing"
	"time"

	"github.com/pion/webrtc/v4"

	"github.com/baiyuze/pasteferry/client-core/internal/store"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

func TestSenderKeepsStreamUntilReceiverResult(t *testing.T) {
	p := newPair(t)
	p.b.mu.Lock()
	p.b.dropResult = true
	p.b.mu.Unlock()
	opened := make(chan *webrtc.DataChannel, 1)
	open := p.a.eng.opts.OpenStream
	p.a.eng.opts.OpenStream = func(device, label string) (*webrtc.DataChannel, error) {
		dc, err := open(device, label)
		if err == nil {
			opened <- dc
		}
		return dc, err
	}
	path := filepath.Join(t.TempDir(), "ack.txt")
	writeFile(t, path, []byte("wait for the receiver"))
	tr, err := p.a.eng.SendFiles("bob", []string{path}, false, "")
	if err != nil {
		t.Fatal(err)
	}
	waitStatus(t, p.b, tr.Id, store.TransferDone)
	dc := <-opened
	// The result is deliberately withheld after the remote file is complete.
	// Local buffering must not make the sender tear down this stream early.
	waitFor(t, time.Second, func() bool { return dc.BufferedAmount() == 0 })
	time.Sleep(100 * time.Millisecond)
	if dc.ReadyState() != webrtc.DataChannelStateOpen {
		t.Fatalf("stream closed before receiver acknowledgement: %v", dc.ReadyState())
	}
	if err := p.b.mgr.Send("alice", &pb.PeerMessage{Payload: &pb.PeerMessage_SendResult{
		SendResult: &pb.SendResult{TransferId: tr.Id, Attempt: 1, Ok: true},
	}}); err != nil {
		t.Fatal(err)
	}
	waitStatus(t, p.a, tr.Id, store.TransferDone)
	waitFor(t, time.Second, func() bool { return dc.ReadyState() != webrtc.DataChannelStateOpen })
}
