package main

import (
	"context"
	"errors"
	"log/slog"

	"github.com/baiyuze/pasteferry/client-core/internal/config"
	"github.com/baiyuze/pasteferry/client-core/internal/rpc"
	"github.com/baiyuze/pasteferry/client-core/internal/update"
	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// newUpdater 建更新服务。版本号不是 X.Y.Z 的构建返回 nil，界面会说明不支持检查更新。
func newUpdater(root string, loadCfg func() config.Config, changed func()) *update.Service {
	svc, err := update.NewService(version, root, slog.Default().With("part", "update"))
	if err != nil {
		slog.Info("这个构建不检查更新", "version", version, "err", err)
		return nil
	}
	svc.AutoCheck = func() bool { return !loadCfg().UpdateCheckDisabled }
	svc.Skipped = func() string { return loadCfg().UpdateSkipVersion }
	svc.Changed = changed
	if r := svc.LastResult(); r != nil {
		slog.Info("上一次自动更新", "from", r.From, "to", r.To, "ok", r.OK, "err", r.Error)
	}
	return svc
}

// wireUpdater 把更新服务接到 gRPC 上；svc 为 nil 时这些调用返回「不支持」。
func wireUpdater(deps *rpc.Deps, svc *update.Service) {
	if svc == nil {
		return
	}
	deps.CheckUpdate = func(ctx context.Context, lang string) (*pb.UpdateInfo, error) {
		found, err := svc.Check(ctx)
		if err != nil {
			return nil, err
		}
		return updateInfo(svc, found, lang), nil
	}
	deps.DownloadUpdate = svc.Download
	deps.InstallUpdate = func(version string, uiPID int) error {
		if uiPID <= 0 {
			return errors.New("需要界面的进程号")
		}
		return svc.Install(version, uiPID)
	}
	deps.UpdateNotice = svc.Notice
	deps.LastUpdate = func() *pb.UpdateResult {
		r := svc.LastResult()
		if r == nil {
			return nil
		}
		return &pb.UpdateResult{FromVersion: r.From, ToVersion: r.To, Ok: r.OK, Error: r.Error, AtUnix: r.At}
	}
}

func updateInfo(svc *update.Service, found *update.Found, lang string) *pb.UpdateInfo {
	m := found.Manifest
	info := &pb.UpdateInfo{
		CurrentVersion: svc.Current.String(),
		LatestVersion:  m.Latest,
		InstallBlocker: svc.Target.Blocker,
		InstallKind:    string(svc.Target.Kind),
		Source:         found.Source,
		CheckedAtUnix:  found.At.Unix(),
	}
	latest, _ := update.ParseVersion(m.Latest)
	info.Available = latest.Compare(svc.Current) > 0
	if a, ok := svc.Asset(m); ok {
		info.DownloadBytes = a.Size
	} else if info.InstallBlocker == "" {
		info.InstallBlocker = update.BlockerUnsupported
	}
	for _, r := range m.Newer(svc.Current) {
		n := r.Localized(lang)
		info.Releases = append(info.Releases, &pb.UpdateRelease{Version: r.Version, Date: r.Date, Changes: n.Changes, Fixes: n.Fixes})
	}
	return info
}
