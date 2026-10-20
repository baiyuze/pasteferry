package rpc

import (
	"context"
	"testing"

	"github.com/baiyuze/pasteferry/client-core/internal/store"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

func TestListHistorySearch(t *testing.T) {
	var gotQuery string
	var gotFilter store.Filter
	s := NewServer(Deps{SearchHistory: func(query string, limit int, f store.Filter) ([]store.Clip, error) {
		gotQuery, gotFilter = query, f
		return []store.Clip{
			{ID: "t", Kind: store.KindText, TextPreview: "季度汇报"},
			{ID: "f", Kind: store.KindFile, Items: []store.Item{{Name: "季度汇报.key"}}},
		}, nil
	}}, NewHub(), "test-token")

	resp, err := s.ListHistory(context.Background(), &pb.ListHistoryRequest{Query: "  季度  ", Limit: 200})
	if err != nil {
		t.Fatal(err)
	}
	// 界面靠 searched 区分「搜过了」与旧版后台服务原样返回的全部记录
	if !resp.GetSearched() || len(resp.GetRecords()) != 2 || gotQuery != "季度" {
		t.Fatalf("searched=%v records=%d query=%q", resp.GetSearched(), len(resp.GetRecords()), gotQuery)
	}
	if gotFilter != (store.Filter{}) {
		t.Errorf("没选筛选条件时 filter = %+v", gotFilter)
	}

	// 筛选条件交给后台服务在数据库里筛，不是搜完再过滤
	for _, tc := range []struct {
		req  *pb.ListHistoryRequest
		want store.Filter
	}{
		{&pb.ListHistoryRequest{Query: "季度", KindFilter: pb.ClipKind_CLIP_KIND_FILE}, store.Filter{Kind: store.KindFile}},
		{&pb.ListHistoryRequest{Query: "季度", KindFilter: pb.ClipKind_CLIP_KIND_TEXT}, store.Filter{Text: true}},
		{&pb.ListHistoryRequest{Query: "季度", LinksOnly: true}, store.Filter{LinksOnly: true}},
		{&pb.ListHistoryRequest{Query: "季度", Favorites: true, KindFilter: pb.ClipKind_CLIP_KIND_IMAGE},
			store.Filter{Favorites: true, Kind: store.KindImage}},
	} {
		if _, err := s.ListHistory(context.Background(), tc.req); err != nil {
			t.Fatal(err)
		}
		if gotFilter != tc.want {
			t.Errorf("%v: filter = %+v, want %+v", tc.req, gotFilter, tc.want)
		}
	}
}
