package rpc

import (
	"context"
	"errors"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/baiyuze/pasteferry/client-core/internal/theme"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// 主题与背景图，见 design/themes.md。正在用哪一套主题存在配置里（theme_id、theme_mode），
// 改了走 UpdateConfig 与 config_changed 事件；这里管主题与背景图本身。

func EventThemesChanged(ids ...string) *pb.Event {
	return &pb.Event{Payload: &pb.Event_ThemesChanged{ThemesChanged: &pb.ThemesChanged{Ids: ids}}}
}

func (s *Server) themes() (*theme.Store, error) {
	if s.deps.Themes == nil {
		return nil, status.Error(codes.Unimplemented, "这个版本的后台服务不支持主题")
	}
	return s.deps.Themes, nil
}

// themeError 把主题包的错误换成 gRPC 状态码，消息直接给界面显示
func themeError(err error) error {
	var inv *theme.InvalidError
	switch {
	case errors.As(err, &inv):
		return status.Error(codes.InvalidArgument, inv.Msg)
	case errors.Is(err, theme.ErrNotFound):
		return status.Error(codes.NotFound, err.Error())
	case errors.Is(err, theme.ErrBuiltin):
		return status.Error(codes.PermissionDenied, err.Error())
	case errors.Is(err, theme.ErrIsBase), errors.Is(err, theme.ErrInUse):
		return status.Error(codes.FailedPrecondition, err.Error())
	case errors.Is(err, theme.ErrNotImage):
		return status.Error(codes.InvalidArgument, err.Error())
	}
	return status.Errorf(codes.Internal, "%v", err)
}

func (s *Server) ListThemes(context.Context, *pb.Empty) (*pb.ListThemesResponse, error) {
	store, err := s.themes()
	if err != nil {
		return nil, err
	}
	infos, err := store.List()
	if err != nil {
		return nil, themeError(err)
	}
	out := &pb.ListThemesResponse{}
	for _, i := range infos {
		out.Themes = append(out.Themes, &pb.ThemeInfo{Id: i.ID, Name: i.Name, Builtin: i.Builtin, Base: i.Base})
	}
	return out, nil
}

func (s *Server) GetTheme(_ context.Context, req *pb.GetThemeRequest) (*pb.ThemeJson, error) {
	store, err := s.themes()
	if err != nil {
		return nil, err
	}
	data, err := store.Get(req.GetId(), req.GetResolved())
	if err != nil {
		return nil, themeError(err)
	}
	return &pb.ThemeJson{Json: string(data)}, nil
}

func (s *Server) PutTheme(_ context.Context, req *pb.PutThemeRequest) (*pb.PutThemeResponse, error) {
	store, err := s.themes()
	if err != nil {
		return nil, err
	}
	put := store.Put
	if req.GetDryRun() {
		put = store.Check
	}
	id, warnings, err := put([]byte(req.GetJson()))
	if err != nil {
		return nil, themeError(err)
	}
	out := &pb.PutThemeResponse{Id: id}
	for _, w := range warnings {
		out.Warnings = append(out.Warnings, &pb.ThemeWarning{
			Mode: w.Mode, Foreground: w.Foreground, Background: w.Background, Ratio: w.Ratio, Minimum: w.Minimum,
		})
	}
	if !req.GetDryRun() {
		s.hub.Publish(EventThemesChanged(id))
	}
	return out, nil
}

func (s *Server) DeleteTheme(_ context.Context, req *pb.ThemeRef) (*pb.Empty, error) {
	store, err := s.themes()
	if err != nil {
		return nil, err
	}
	id := req.GetId()
	if err := store.Delete(id); err != nil {
		return nil, themeError(err)
	}
	// 正在用的主题没了：换回默认主题（保存配置时会推 config_changed）
	if c := s.deps.LoadConfig(); c.ThemeID == id {
		c.ThemeID = ""
		if err := s.deps.SaveConfig(c); err != nil {
			return nil, status.Errorf(codes.Internal, "保存配置: %v", err)
		}
	}
	s.hub.Publish(EventThemesChanged(id))
	return &pb.Empty{}, nil
}

func (s *Server) ImportBackground(_ context.Context, req *pb.ImportBackgroundRequest) (*pb.BackgroundInfo, error) {
	store, err := s.themes()
	if err != nil {
		return nil, err
	}
	info, err := store.ImportBackground(req.GetImage(), req.GetPath())
	if err != nil {
		return nil, themeError(err)
	}
	return backgroundInfo(info), nil
}

func (s *Server) AnalyzeBackground(_ context.Context, req *pb.BackgroundRef) (*pb.BackgroundInfo, error) {
	store, err := s.themes()
	if err != nil {
		return nil, err
	}
	info, err := store.AnalyzeBackground(req.GetSha256())
	if err != nil {
		return nil, themeError(err)
	}
	return backgroundInfo(info), nil
}

func backgroundInfo(info theme.BackgroundInfo) *pb.BackgroundInfo {
	return &pb.BackgroundInfo{
		Sha256:          info.SHA256,
		Width:           int32(info.Width),
		Height:          int32(info.Height),
		Format:          info.Format,
		Luminance:       info.Luminance,
		LuminanceSpread: info.LuminanceSpread,
		Colors:          info.Colors,
		MinScrimDark:    info.MinScrimDark,
		MinScrimLight:   info.MinScrimLight,
	}
}

func (s *Server) GetBackground(_ context.Context, req *pb.GetBackgroundRequest) (*pb.BackgroundImage, error) {
	store, err := s.themes()
	if err != nil {
		return nil, err
	}
	data, format, err := store.Background(req.GetSha256(), req.GetBlurred())
	if err != nil {
		return nil, themeError(err)
	}
	return &pb.BackgroundImage{Data: data, Format: format}, nil
}

func (s *Server) DeleteBackground(_ context.Context, req *pb.BackgroundRef) (*pb.Empty, error) {
	store, err := s.themes()
	if err != nil {
		return nil, err
	}
	if err := store.DeleteBackground(req.GetSha256()); err != nil {
		return nil, themeError(err)
	}
	return &pb.Empty{}, nil
}
