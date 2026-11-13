package main

import (
	"bytes"
	"context"
	"encoding/json"
	"github.com/pion/webrtc/v4"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"sync/atomic"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/send"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	"github.com/baiyuze/pasteferry/client-core/internal/transport/p2p"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
	"google.golang.org/protobuf/proto"
)

// This harness is compiled unchanged against both the archived baseline and
// the working tree. Reflection only wires capabilities absent from the old API.
func main() {
	self, peer := os.Getenv("PF_SELF"), os.Getenv("PF_PEER")
	listen, remote := os.Getenv("PF_LISTEN"), os.Getenv("PF_REMOTE")
	root := os.Getenv("PF_DATA")
	_ = os.MkdirAll(filepath.Join(root, "Downloads"), 0755)
	db, err := store.Open(filepath.Join(root, "state.sqlite"))
	if err != nil {
		panic(err)
	}
	defer db.Close()
	cfg := config.Default()
	cfg.ReceiveDir = filepath.Join(root, "Downloads")
	var eng *send.Engine
	var mgr *p2p.Manager
	var known, parallel atomic.Bool
	var stripes atomic.Int64
	mgr = p2p.NewManager(p2p.ManagerOptions{SelfID: self,
		SendSignal: func(_ context.Context, _ string, msg *pb.SignalMessage) error {
			data, err := proto.Marshal(msg)
			if err != nil {
				return err
			}
			go func() {
				c := http.Client{Timeout: 5 * time.Second}
				r, e := c.Post("http://"+remote+"/signal", "application/protobuf", bytes.NewReader(data))
				if e == nil {
					r.Body.Close()
				}
			}()
			return nil
		},
		OnState: func(_ string, s p2p.ConnState) {
			if s == p2p.StateDirect {
				f := []string{"send_files_v1"}
				if reflect.ValueOf(mgr).MethodByName("OpenIndependentStream").IsValid() {
					f = append(f, "send_files_parallel_v1")
				}
				_ = mgr.Send(peer, &pb.PeerMessage{Payload: &pb.PeerMessage_Features{Features: &pb.PeerFeatures{Features: f}}})
			}
		},
		OnMessage: func(from string, msg *pb.PeerMessage) {
			if f := msg.GetFeatures(); f != nil {
				for _, v := range f.GetFeatures() {
					if v == "send_files_parallel_v1" {
						parallel.Store(true)
					}
				}
				known.Store(true)
				if eng != nil {
					eng.PeerReady(from)
				}
				return
			}
			if eng != nil {
				eng.HandleMessage(from, msg)
			}
		},
		OnStream: func(from, label string, st *p2p.Stream) {
			if eng != nil && send.IsStream(label) {
				eng.HandleStream(from, label, st)
			} else {
				st.Close()
			}
		},
	})
	defer mgr.Close()
	mgr.SetICEServers(nil)
	opts := send.Options{Store: db, LoadConfig: func() config.Config { return cfg }, Send: mgr.Send,
		OpenStream: func(device, label string) (*webrtc.DataChannel, error) {
			if strings.HasSuffix(label, ":striped") {
				stripes.Add(1)
			}
			return mgr.OpenStream(device, label)
		},
		Peer: func(string) send.Peer {
			p := send.Peer{Known: true, Online: true, Connected: mgr.State(peer) == p2p.StateDirect, Supported: true, Name: peer}
			f := reflect.ValueOf(&p).Elem().FieldByName("Parallel")
			if f.IsValid() {
				f.SetBool(parallel.Load())
			}
			return p
		},
	}
	for name, method := range map[string]string{"OpenIndependent": "OpenIndependentStream", "AcceptIndependent": "AcceptIndependentStream"} {
		f := reflect.ValueOf(&opts).Elem().FieldByName(name)
		if f.IsValid() {
			f.Set(reflect.ValueOf(mgr).MethodByName(method))
		}
	}
	eng = send.New(opts)
	eng.Start()
	defer eng.Close()
	// The actual old/new production engines own all file transmission.
	mux := http.NewServeMux()
	mux.HandleFunc("/signal", func(w http.ResponseWriter, r *http.Request) {
		data, _ := io.ReadAll(io.LimitReader(r.Body, 1<<20))
		var msg pb.SignalMessage
		if proto.Unmarshal(data, &msg) != nil {
			w.WriteHeader(400)
			return
		}
		go func() {
			ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
			defer cancel()
			_ = mgr.HandleSignal(ctx, peer, &msg)
		}()
	})
	mux.HandleFunc("/connect", func(w http.ResponseWriter, r *http.Request) {
		go func() {
			ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
			defer cancel()
			_ = mgr.Connect(ctx, peer)
		}()
	})
	mux.HandleFunc("/ready", func(w http.ResponseWriter, r *http.Request) {
		json.NewEncoder(w).Encode(map[string]any{"ready": known.Load() && mgr.State(peer) == p2p.StateDirect, "parallel_remote": parallel.Load(), "stripes": stripes.Load()})
	})
	mux.HandleFunc("/send", func(w http.ResponseWriter, r *http.Request) {
		var paths []string
		if json.NewDecoder(r.Body).Decode(&paths) != nil {
			w.WriteHeader(400)
			return
		}
		tr, err := eng.SendFiles(peer, paths, false, "")
		if err != nil {
			http.Error(w, err.Error(), 500)
			return
		}
		json.NewEncoder(w).Encode(map[string]string{"id": tr.GetId()})
	})
	mux.HandleFunc("/status", func(w http.ResponseWriter, r *http.Request) {
		tr, err := db.GetTransfer(r.URL.Query().Get("id"))
		if err != nil {
			http.Error(w, err.Error(), 404)
			return
		}
		json.NewEncoder(w).Encode(tr)
	})
	mux.HandleFunc("/interrupt", func(w http.ResponseWriter, r *http.Request) { mgr.Disconnect(peer) })
	if err := http.ListenAndServe(listen, mux); err != nil {
		panic(err)
	}
}
