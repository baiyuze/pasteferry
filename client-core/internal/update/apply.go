package update

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log/slog"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"time"
)

// Plan 是交给更新助手的安装计划。助手是后台服务程序的一份副本（见 Start），
// 等界面退出后替换文件、写结果，再把后台服务与界面重新拉起来。
type Plan struct {
	Kind Kind   `json:"kind"`
	From string `json:"from"`
	To   string `json:"to"`
	// Package 是下载并校验过的安装包
	Package string `json:"package"`
	// Staged 是提前准备好的新程序（Mac 的 .app、便携版与 tar.gz 的文件夹），与 App 在同一个文件夹里，替换只是改名
	Staged string `json:"staged,omitempty"`
	App    string `json:"app"`
	// UIPID 是要等它退出的界面；Daemons 是要结束的后台服务与守护进程（只结束位于 App 里的）
	UIPID   int    `json:"ui_pid"`
	Daemons []int  `json:"daemons,omitempty"`
	Result  string `json:"result"`
}

// Result 是一次安装的结果，新版后台服务启动后读出来给界面显示。
type Result struct {
	From  string `json:"from"`
	To    string `json:"to"`
	OK    bool   `json:"ok"`
	Error string `json:"error,omitempty"`
	At    int64  `json:"at"`
}

// updaterName 与后台服务的文件名不同：Windows 安装程序按名字结束 pasteferryd.exe，
// 同名的话会把正在安装的助手也一起结束。
func updaterName() string {
	if runtime.GOOS == "windows" {
		return "pasteferry-updater.exe"
	}
	return "pasteferry-updater"
}

// Prepare 在界面退出之前做完所有能提前做的事（挂载、解压、校验新程序），
// 这些步骤出错时界面还开着，可以直接告诉用户。
func Prepare(t Target, pkg, from, to, work string, uiPID int) (*Plan, error) {
	if t.Blocker != "" {
		return nil, fmt.Errorf("这种安装方式不能自动更新（%s）", t.Blocker)
	}
	p := &Plan{Kind: t.Kind, From: from, To: to, Package: pkg, App: t.App, UIPID: uiPID,
		Result: filepath.Join(filepath.Dir(work), "result.json")}
	if err := prepare(p, work); err != nil {
		return nil, err
	}
	return p, nil
}

// Start 把计划写到 work 里，复制一份自身作为更新助手并启动它。
// 助手立即再启动一个脱离当前进程树的自己，然后退出：之后结束后台服务（包括按进程树结束）
// 都不会波及正在安装的那个助手。
func Start(p *Plan, work string) error {
	planPath := filepath.Join(work, "plan.json")
	raw, err := json.MarshalIndent(p, "", "  ")
	if err != nil {
		return err
	}
	if err := os.WriteFile(planPath, raw, 0o600); err != nil {
		return err
	}
	self, err := os.Executable()
	if err != nil {
		return err
	}
	helper := filepath.Join(work, updaterName())
	if err := copyFile(self, helper, 0o755); err != nil {
		return err
	}
	cmd := exec.Command(helper, "-apply-update", planPath)
	if out, err := cmd.CombinedOutput(); err != nil {
		return fmt.Errorf("启动更新助手: %v %s", err, out)
	}
	return nil
}

// RunHelper 是更新助手的入口（pasteferryd -apply-update / -apply-update-run）。
// detach 为 true 时只负责启动脱离进程树的第二级，然后退出。
func RunHelper(planPath string, detach bool) int {
	if detach {
		self, err := os.Executable()
		if err == nil {
			err = startDetached(self, "-apply-update-run", planPath)
		}
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			return 1
		}
		return 0
	}
	logFile, err := os.OpenFile(filepath.Join(filepath.Dir(planPath), "updater.log"), os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0o600)
	var out io.Writer = io.Discard
	if err == nil {
		defer logFile.Close()
		out = logFile
	}
	log := slog.New(slog.NewTextHandler(out, nil))
	raw, err := os.ReadFile(planPath)
	var p Plan
	if err == nil {
		err = json.Unmarshal(raw, &p)
	}
	if err != nil {
		log.Error("读取更新计划失败", "err", err)
		return 1
	}
	log.Info("开始安装", "from", p.From, "to", p.To, "kind", p.Kind)
	if p.UIPID > 0 && !waitExit(p.UIPID, time.Minute) {
		log.Warn("界面没有退出，结束它", "pid", p.UIPID)
		terminate(p.UIPID)
		waitExit(p.UIPID, 10*time.Second)
	}
	res := Result{From: p.From, To: p.To, At: time.Now().Unix()}
	if err := apply(&p, log); err != nil {
		log.Error("安装失败", "err", err)
		res.Error = err.Error()
	} else {
		res.OK = true
		log.Info("安装完成")
	}
	if raw, err := json.Marshal(res); err == nil {
		_ = os.WriteFile(p.Result, raw, 0o600)
	}
	// 无论成败都把后台服务与界面拉起来：失败时是旧版，用户不会落得什么都没有
	if err := relaunch(&p, log); err != nil {
		log.Error("重新打开失败", "err", err)
	}
	return 0
}

// ReadResult 读出上一次安装的结果，没有或已过时就返回 nil。
// 读了不删：安装后后台服务可能被界面再重启一两次，每一次都要能告诉界面结果；过时的才删掉。
func ReadResult(dataDir string) *Result {
	path := filepath.Join(dataDir, "updates", "result.json")
	raw, err := os.ReadFile(path)
	if err != nil {
		return nil
	}
	var r Result
	if json.Unmarshal(raw, &r) != nil || r.To == "" || time.Since(time.Unix(r.At, 0)) > resultFresh {
		_ = os.Remove(path)
		return nil
	}
	return &r
}

func copyFile(src, dst string, mode os.FileMode) error {
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()
	_ = os.Remove(dst)
	out, err := os.OpenFile(dst, os.O_CREATE|os.O_TRUNC|os.O_WRONLY, mode)
	if err != nil {
		return err
	}
	if _, err := io.Copy(out, in); err != nil {
		out.Close()
		return err
	}
	return out.Close()
}

// swapDir 把 staged 换到 app 的位置，旧的改名为 old。失败时尽量还原。
func swapDir(app, staged, old string) error {
	_ = os.RemoveAll(old)
	// Windows 上刚结束的进程可能还占着文件一会儿，杀毒软件也可能正在扫描，多等几次
	var err error
	for deadline := time.Now().Add(15 * time.Second); ; {
		if err = os.Rename(app, old); err == nil || time.Now().After(deadline) {
			break
		}
		time.Sleep(500 * time.Millisecond)
	}
	if err != nil {
		return fmt.Errorf("挪开旧版本: %w", err)
	}
	if err := os.Rename(staged, app); err != nil {
		if rerr := os.Rename(old, app); rerr != nil {
			return errors.Join(fmt.Errorf("放入新版本: %w", err), fmt.Errorf("还原旧版本: %w", rerr))
		}
		return fmt.Errorf("放入新版本: %w", err)
	}
	return nil
}

// stopDaemons 结束计划里位于 App 里的后台服务与守护进程，并等它们退出。
// Daemons 是 [后台服务, 它的父进程]：倒着结束，先结束守护进程，否则它会把刚结束的后台服务重新拉起来。
func stopDaemons(p *Plan, log *slog.Logger) {
	for i := len(p.Daemons) - 1; i >= 0; i-- {
		pid := p.Daemons[i]
		if pid <= 0 || !processInDir(pid, p.App) {
			continue
		}
		log.Info("结束旧的后台服务", "pid", pid)
		terminate(pid)
		if !waitExit(pid, 10*time.Second) {
			kill(pid)
			waitExit(pid, 5*time.Second)
		}
	}
}
