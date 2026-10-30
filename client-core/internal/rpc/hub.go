package rpc

import (
	"sync"
	"time"

	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// Hub 把 daemon 内部发生的事件广播给所有已连接的 UI。
//
// 订阅者是慢速消费者时不能拖垮 daemon：每个订阅者有独立缓冲，
// 满了就丢弃该订阅者的这条事件，而不是阻塞发布方。UI 可以用
// SubscribeRequest.since_unix 重连补齐。
type Hub struct {
	mu     sync.Mutex
	subs   map[int]chan *pb.Event
	nextID int
	// 最近一次「切到某一页」，见 Navigate
	navPage string
	navAt   time.Time
}

func NewHub() *Hub {
	return &Hub{subs: make(map[int]chan *pb.Event)}
}

// Subscribe 返回事件通道与取消函数。调用方必须在结束时调用取消函数。
func (h *Hub) Subscribe() (<-chan *pb.Event, func()) {
	h.mu.Lock()
	defer h.mu.Unlock()

	id := h.nextID
	h.nextID++
	ch := make(chan *pb.Event, 64)
	h.subs[id] = ch

	return ch, func() {
		h.mu.Lock()
		defer h.mu.Unlock()
		if c, ok := h.subs[id]; ok {
			delete(h.subs, id)
			close(c)
		}
	}
}

func (h *Hub) Publish(e *pb.Event) {
	h.mu.Lock()
	defer h.mu.Unlock()
	for _, ch := range h.subs {
		select {
		case ch <- e:
		default:
			// 该订阅者积压严重，丢弃这条而不是阻塞其他订阅者
		}
	}
}

// Navigate 让界面切到某一页，并记下来：界面是被这次点击拉起来的话，订阅时补发给它。
func (h *Hub) Navigate(page string) {
	h.mu.Lock()
	h.navPage, h.navAt = page, time.Now()
	h.mu.Unlock()
	h.Publish(EventNavigate(page))
}

// RecentNavigate 返回 within 之内的那次「切到某一页」，没有时返回空字符串。
func (h *Hub) RecentNavigate(within time.Duration) string {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.navPage == "" || time.Since(h.navAt) > within {
		return ""
	}
	return h.navPage
}

func EventNavigate(page string) *pb.Event {
	return &pb.Event{Payload: &pb.Event_Navigate{Navigate: page}}
}

// EventNotice 推一条给用户看的提示，kind 是固定代码，文案由界面翻译。
func EventNotice(kind string) *pb.Event {
	return &pb.Event{Payload: &pb.Event_Notice{Notice: &pb.AppNotice{Kind: kind}}}
}

func (h *Hub) SubscriberCount() int {
	h.mu.Lock()
	defer h.mu.Unlock()
	return len(h.subs)
}

// 便捷构造：事件类型很多，包一层省得调用点到处写 oneof 包装。

func EventClipAdded(r *pb.ClipRecord) *pb.Event {
	return &pb.Event{Payload: &pb.Event_ClipAdded{ClipAdded: r}}
}

func EventClipUpdated(r *pb.ClipRecord) *pb.Event {
	return &pb.Event{Payload: &pb.Event_ClipUpdated{ClipUpdated: r}}
}

func EventClipRemoved(id string) *pb.Event {
	return &pb.Event{Payload: &pb.Event_ClipRemoved{ClipRemoved: id}}
}

func EventProgress(p *pb.TransferProgress) *pb.Event {
	return &pb.Event{Payload: &pb.Event_Progress{Progress: p}}
}

func EventDeviceChanged(d *pb.Device) *pb.Event {
	return &pb.Event{Payload: &pb.Event_DeviceChanged{DeviceChanged: d}}
}

func EventPermissionChanged(p pb.ClipboardPermission) *pb.Event {
	return &pb.Event{Payload: &pb.Event_PermissionChanged{PermissionChanged: p}}
}

func EventStatusChanged(s *pb.Status) *pb.Event {
	return &pb.Event{Payload: &pb.Event_StatusChanged{StatusChanged: s}}
}
