//go:build !darwin && !linux && !windows

package update

import (
	"errors"
	"log/slog"
	"time"
)

func waitExit(int, time.Duration) bool      { return true }
func terminate(int)                         {}
func kill(int)                              {}
func processInDir(int, string) bool         { return false }
func startDetached(string, ...string) error { return errors.New("unsupported") }
func prepare(*Plan, string) error           { return errors.New("unsupported") }
func apply(*Plan, *slog.Logger) error       { return errors.New("unsupported") }
func relaunch(*Plan, *slog.Logger) error    { return nil }
