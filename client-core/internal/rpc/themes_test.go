package rpc

import (
	"context"
	"testing"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/theme"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

func themeServer(t *testing.T) (*Server, *config.Config, <-chan *pb.Event) {
	t.Helper()
	cfg := config.Default()
	hub := NewHub()
	events, cancel := hub.Subscribe()
	t.Cleanup(cancel)
	s := NewServer(Deps{
		LoadConfig: func() config.Config { return cfg },
		SaveConfig: func(c config.Config) error { cfg = c; return nil },
		Themes:     theme.NewStore(config.PathsUnder(t.TempDir())),
	}, hub, "")
	return s, &cfg, events
}

func TestThemeModeRoundTrip(t *testing.T) {
	c := config.Default()
	c.ThemeID, c.ThemeMode, c.ThemeScanlines = "pixel", "dark", true
	got := configFromProto(configToProto(c), config.Default())
	if got.ThemeID != "pixel" || got.ThemeMode != "dark" || !got.ThemeScanlines {
		t.Fatalf("主题设置没有原样往返：%+v", got)
	}
	if configToProto(config.Default()).GetThemeMode() != pb.ThemeMode_THEME_MODE_UNSPECIFIED {
		t.Fatal("默认应当跟随系统")
	}
}

func TestUpdateConfigRejectsUnknownTheme(t *testing.T) {
	s, cfg, _ := themeServer(t)
	in := configToProto(*cfg)
	in.ThemeId = "nope"
	if _, err := s.UpdateConfig(context.Background(), in); status.Code(err) != codes.InvalidArgument {
		t.Fatalf("不存在的主题应当拒绝：%v", err)
	}
	in.ThemeId = "pixel"
	in.ThemeMode = pb.ThemeMode_THEME_MODE_LIGHT
	out, err := s.UpdateConfig(context.Background(), in)
	if err != nil || out.GetThemeId() != "pixel" || cfg.ThemeMode != "light" {
		t.Fatalf("换成 pixel：%v %+v", err, cfg)
	}
}

func TestDeleteCurrentThemeFallsBack(t *testing.T) {
	s, cfg, events := themeServer(t)
	ctx := context.Background()
	res, err := s.PutTheme(ctx, &pb.PutThemeRequest{Json: `{"schema":1,"id":"mine","base":"pixel"}`})
	if err != nil || res.GetId() != "mine" {
		t.Fatal(err)
	}
	if e := <-events; e.GetThemesChanged().GetIds()[0] != "mine" {
		t.Fatalf("保存后应当推 themes_changed：%v", e)
	}
	cfg.ThemeID = "mine"
	if _, err := s.DeleteTheme(ctx, &pb.ThemeRef{Id: "mine"}); err != nil {
		t.Fatal(err)
	}
	if cfg.ThemeID != "" {
		t.Fatalf("删掉正在用的主题后应当换回默认主题：%q", cfg.ThemeID)
	}
	if _, err := s.DeleteTheme(ctx, &pb.ThemeRef{Id: "default"}); status.Code(err) != codes.PermissionDenied {
		t.Fatalf("内置主题不能删：%v", err)
	}
	if _, err := s.PutTheme(ctx, &pb.PutThemeRequest{Json: `{"schema":1,"id":"x","modes":{"light":{"text":"#EEEEEE"}}}`}); err != nil {
		t.Fatal(err)
	}
	r, err := s.PutTheme(ctx, &pb.PutThemeRequest{Json: `{"schema":1,"id":"x","modes":{"light":{"text":"#EEEEEE"}}}`})
	if err != nil || len(r.GetWarnings()) == 0 {
		t.Fatalf("浅色上的浅字应当有对比度警告：%v %v", err, r)
	}
	if _, err := s.PutTheme(ctx, &pb.PutThemeRequest{Json: `{"id":"x"}`}); status.Code(err) != codes.InvalidArgument {
		t.Fatalf("格式不对应当是 InvalidArgument：%v", err)
	}
	list, err := s.ListThemes(ctx, &pb.Empty{})
	if err != nil || len(list.GetThemes()) != 3 || !list.GetThemes()[0].GetBuiltin() {
		t.Fatalf("列表不对：%v %v", err, list)
	}
}

func TestPutThemeDryRun(t *testing.T) {
	s, _, events := themeServer(t)
	ctx := context.Background()
	res, err := s.PutTheme(ctx, &pb.PutThemeRequest{Json: `{"schema":1,"id":"try","base":"pixel"}`, DryRun: true})
	if err != nil || res.GetId() != "try" {
		t.Fatal(res, err)
	}
	if _, err := s.GetTheme(ctx, &pb.GetThemeRequest{Id: "try"}); status.Code(err) != codes.NotFound {
		t.Fatalf("只校验时不该保存：%v", err)
	}
	select {
	case ev := <-events:
		t.Fatalf("只校验时不该推送事件：%v", ev)
	default:
	}
	if _, err := s.PutTheme(ctx, &pb.PutThemeRequest{Json: `{"schema":1}`, DryRun: true}); status.Code(err) != codes.InvalidArgument {
		t.Fatalf("格式不对：%v", err)
	}
}
