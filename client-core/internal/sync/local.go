package sync

import (
	"context"
	"errors"

	"github.com/baiyuze/pasteferry/client-core/internal/clipboard"
	"github.com/baiyuze/pasteferry/client-core/internal/store"
)

// ErrNothingToSubmit 表示提交的内容是空的：没有文字，也没有文件。
var ErrNothingToSubmit = errors.New("没有要发送的内容")

// SubmitLocal 把不是从本机剪贴板读到的内容当成本机复制处理：手机网页传输里手机发来的文字和文件，
// 以及 Android App 发送页里输入的文字（design/phone-sync.md 2.5.3 节、3.3.2 节）。
//
// 和本机复制一样落库、发给允许同步的其他设备（这种类型在设置里关掉了同步时只落库）。
// via 是经由的设备名，记进 store.Clip.Via，界面上显示「来自 via」；空表示就是本机。
// applyLocal 时再按「收到后自动写入剪贴板」的设置写进本机剪贴板：经 Watcher 写入，
// 不会被当成用户的新复制再发一遍。写剪贴板失败不算提交失败，记录已经在了。
func (e *Engine) SubmitLocal(ctx context.Context, content clipboard.Content, via string, applyLocal bool) (store.Clip, error) {
	switch content.Kind {
	case clipboard.KindText:
		if content.Text == "" {
			return store.Clip{}, ErrNothingToSubmit
		}
	case clipboard.KindHTML:
		if content.HTML == "" && content.Text == "" {
			return store.Clip{}, ErrNothingToSubmit
		}
	case clipboard.KindImage:
		if len(content.Image) == 0 {
			return store.Clip{}, ErrNothingToSubmit
		}
	case clipboard.KindFile:
		if len(content.Files) == 0 {
			return store.Clip{}, ErrNothingToSubmit
		}
	default:
		return store.Clip{}, ErrNothingToSubmit
	}

	generation := e.policyGeneration.Load()
	cfg := e.loadConfig()
	clip, err := e.recordOutgoingVia(content, cfg, via)
	if err != nil {
		return store.Clip{}, err
	}
	e.emitRecord(clip)
	if e.kindEnabled(cfg, content.Kind) && generation == e.policyGeneration.Load() {
		e.offerToPeers(ctx, clip, cfg)
	}
	if applyLocal && cfg.AutoApplyToClipboard {
		if err := e.applyToClipboard(ctx, clip); err != nil {
			e.log.Warn("写入剪贴板失败", "clip", clip.ID, "err", err)
		}
	}
	return clip, nil
}

// LocalPaths 返回一条记录在本机可用的文件路径（图片与文件记录），内容已不在本机时报错。
func (e *Engine) LocalPaths(clipID string) ([]string, error) {
	clip, err := e.store.GetClip(clipID)
	if err != nil {
		return nil, err
	}
	if clip.Status != store.StatusReady {
		return nil, errors.New("内容还没有下载到本机")
	}
	return e.localPaths(clip)
}

// NoteOwnCopy 让网页复制记录后把这次剪贴板变化忽略掉，避免自己复制自己又生成一条记录。
func (e *Engine) NoteOwnCopy(ctx context.Context) error {
	if e.watcher == nil {
		return nil
	}
	return e.watcher.MarkCurrentAsOwn(ctx)
}
