package webshare

import (
	"context"
	"encoding/json"
	"errors"
	"sync"

	"github.com/baiyuze/pasteferry/client-core/internal/imagepreview"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// inlineTextMax 以内的文字随记录一起发给网页。「复制」必须在点击的同一时刻完成
// （document.execCommand 只在用户手势里有效），等网络回来再复制就晚了；更长的文字网页先点「加载全文」。
const inlineTextMax = 64 << 10

type webItem struct {
	Name string `json:"name"`
	Size int64  `json:"size"`
	Dir  bool   `json:"dir,omitempty"`
}

// webRecord 是网页上的一条复制记录。
type webRecord struct {
	ID      string    `json:"id"`
	Kind    string    `json:"kind"`   // text / image / file
	Status  string    `json:"status"` // ready / remote / fetching / failed / expired
	From    string    `json:"from"`   // 显示的来源：这台手机的名字、电脑名或别的设备名
	Mine    bool      `json:"mine"`   // 是这台手机发来的
	Text    string    `json:"text,omitempty"`
	Long    bool      `json:"long,omitempty"` // 文字太长，没随记录发来
	Preview string    `json:"preview"`
	Items   []webItem `json:"items,omitempty"`
	Size    int64     `json:"size"`
	At      int64     `json:"at"` // 毫秒
	Images  int32     `json:"images,omitempty"`
	Link    bool      `json:"link,omitempty"`
}

func (s *Server) toWeb(c store.Clip, sessName string) webRecord {
	r := webRecord{
		ID:      c.ID,
		Preview: c.TextPreview,
		Size:    c.TotalSize,
		At:      c.CreatedAt.UnixMilli(),
		Images:  imagepreview.ImageCount(c),
		Link:    c.IsLink,
	}
	switch c.Kind {
	case store.KindText, store.KindHTML:
		r.Kind = "text"
		if t := recordText(c); len(t) <= inlineTextMax {
			r.Text = t
		} else {
			r.Long = true
		}
	case store.KindImage:
		r.Kind = "image"
	default:
		r.Kind = "file"
	}
	switch c.Status {
	case store.StatusReady:
		r.Status = "ready"
	case store.StatusRemoteOnly:
		r.Status = "remote"
	case store.StatusFetching:
		r.Status = "fetching"
	case store.StatusExpired:
		r.Status = "expired"
	default:
		r.Status = "failed"
	}
	switch {
	case c.Outgoing && c.Via != "":
		r.From, r.Mine = c.Via, c.Via == sessName
	case c.Outgoing:
		if s.opts.DeviceName != nil {
			r.From = s.opts.DeviceName()
		}
	default:
		r.From = c.OriginDeviceName
	}
	for _, it := range c.Items {
		r.Items = append(r.Items, webItem{Name: it.Name, Size: it.Size, Dir: it.IsDir})
	}
	return r
}

// recordText 是一条文字记录在网页上复制出来的内容：网页格式只给纯文本。
func recordText(c store.Clip) string {
	if c.Kind == store.KindHTML && c.TextPlain != "" {
		return c.TextPlain
	}
	return c.TextContent
}

// webEvent 是推给网页的一件事：一条记录新增或变化（rec），或被删掉（del）。
type webEvent struct {
	Type   string     `json:"t"`
	Record *webRecord `json:"r,omitempty"`
	ID     string     `json:"id,omitempty"`
}

// clipEvent 是在事件流之间传递的原始事件：记录在发给每台手机时才转换，
// 因为「是不是这台手机发的」每台手机不一样。
type clipEvent struct {
	removed string
	clip    *store.Clip
}

func (s *Server) eventJSON(ev clipEvent, sessName string) ([]byte, error) {
	if ev.removed != "" {
		return json.Marshal(webEvent{Type: "del", ID: ev.removed})
	}
	if ev.clip == nil {
		return nil, errors.New("空事件")
	}
	r := s.toWeb(*ev.clip, sessName)
	return json.Marshal(webEvent{Type: "rec", Record: &r})
}

// forwardEvents 把后台服务的记录事件转给所有开着的网页。收藏不算复制记录，不转。
func (s *Server) forwardEvents(ctx context.Context, ch <-chan *pb.Event) {
	for {
		select {
		case <-ctx.Done():
			return
		case ev, ok := <-ch:
			if !ok {
				return
			}
			var id string
			switch p := ev.GetPayload().(type) {
			case *pb.Event_ClipAdded:
				id = p.ClipAdded.GetId()
			case *pb.Event_ClipUpdated:
				id = p.ClipUpdated.GetId()
			case *pb.Event_ClipRemoved:
				s.events.send(clipEvent{removed: p.ClipRemoved})
				continue
			default:
				continue
			}
			c, err := s.opts.Store.GetClip(id)
			if err != nil || c.Favorite {
				continue
			}
			s.events.send(clipEvent{clip: &c})
		}
	}
}

// ── 事件流的订阅者 ──

type eventClient struct {
	session string
	ch      chan clipEvent
	done    chan struct{}
	once    sync.Once
}

func (c *eventClient) close() { c.once.Do(func() { close(c.done) }) }

type broadcaster struct {
	mu      sync.Mutex
	clients map[*eventClient]struct{}
}

func newBroadcaster() *broadcaster { return &broadcaster{clients: make(map[*eventClient]struct{})} }

func (b *broadcaster) add(session string) *eventClient {
	c := &eventClient{session: session, ch: make(chan clipEvent, 64), done: make(chan struct{})}
	b.mu.Lock()
	b.clients[c] = struct{}{}
	b.mu.Unlock()
	return c
}

func (b *broadcaster) remove(c *eventClient) {
	b.mu.Lock()
	delete(b.clients, c)
	b.mu.Unlock()
	c.close()
}

// send 发给所有网页。某个网页积压太多（手机切到后台、网络卡住）就丢掉这一条：
// 它回到前台时会按游标重新取一遍记录。
func (b *broadcaster) send(ev clipEvent) {
	b.mu.Lock()
	defer b.mu.Unlock()
	for c := range b.clients {
		select {
		case c.ch <- ev:
		default:
		}
	}
}

func (b *broadcaster) closeSession(session string) {
	b.mu.Lock()
	defer b.mu.Unlock()
	for c := range b.clients {
		if c.session == session {
			c.close()
		}
	}
}

func (b *broadcaster) closeAll() {
	b.mu.Lock()
	defer b.mu.Unlock()
	for c := range b.clients {
		c.close()
	}
}
