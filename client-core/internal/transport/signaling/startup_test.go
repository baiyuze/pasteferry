package signaling_test

import (
	"context"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/coder/websocket"
	"google.golang.org/protobuf/proto"

	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// Changing network mode while the initial handshake is pending must cancel
// that handshake. Otherwise it can keep the client on the old server forever.
func TestChangeServerDuringStartupHandshake(t *testing.T) {
	for _, disable := range []bool{false, true} {
		name := "switch"
		if disable {
			name = "disable"
		}
		t.Run(name, func(t *testing.T) {
			accepted := make(chan struct{})
			closed := make(chan struct{})
			releaseHello := make(chan struct{})
			oldServer := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				conn, err := websocket.Accept(w, r, nil)
				if err != nil {
					return
				}
				defer conn.CloseNow()
				defer close(closed)
				close(accepted)
				<-releaseHello
				hello, _ := proto.Marshal(&pb.ServerEnvelope{Payload: &pb.ServerEnvelope_Hello{Hello: &pb.ServerHello{Challenge: []byte("startup")}}})
				if err := conn.Write(r.Context(), websocket.MessageBinary, hello); err != nil {
					return
				}
				for {
					if _, _, err := conn.Read(r.Context()); err != nil {
						return
					}
				}
			}))
			defer oldServer.Close()
			url := "ws" + strings.TrimPrefix(oldServer.URL, "http")
			p := newPeer(t, "startup", url)
			ctx, cancel := context.WithCancel(context.Background())
			defer cancel()
			stopped := make(chan struct{})
			go func() {
				defer close(stopped)
				p.client.Run(ctx)
			}()
			select {
			case <-accepted:
			case <-time.After(3 * time.Second):
				close(releaseHello)
				t.Fatal("initial WebSocket was not opened")
			}
			newURL := ""
			if !disable {
				newURL = startServer(t)
			}
			p.client.SetURL(newURL)
			close(releaseHello)
			select {
			case <-closed:
			case <-time.After(3 * time.Second):
				cancel()
				t.Fatal("startup handshake stayed on the old server after SetURL")
			}
			if disable {
				if p.client.Connected() {
					t.Fatal("server connection remained active in LAN-only mode")
				}
			} else {
				waitConnected(t, p)
				if err := p.client.CreatePairingCode(ctx); err != nil {
					t.Fatal(err)
				}
				select {
				case <-p.codes:
				case <-time.After(3 * time.Second):
					t.Fatal("new server did not receive the pairing request")
				}
			}
			cancel()
			select {
			case <-stopped:
			case <-time.After(3 * time.Second):
				t.Fatal("client did not stop")
			}
		})
	}
}
