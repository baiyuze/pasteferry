package power

import (
	"runtime"

	"golang.org/x/sys/windows"
)

var setThreadExecutionState = windows.NewLazySystemDLL("kernel32.dll").NewProc("SetThreadExecutionState")

const (
	esContinuous     = 0x80000000
	esSystemRequired = 0x00000001
)

// SetThreadExecutionState 的设置跟着调用它的线程走，所以专门用一个锁定在线程上的
// goroutine 持有它，解除时在同一个线程上恢复。
func inhibit(string) (func(), error) {
	if err := setThreadExecutionState.Find(); err != nil {
		return nil, err
	}
	done := make(chan struct{})
	go func() {
		runtime.LockOSThread()
		defer runtime.UnlockOSThread()
		setThreadExecutionState.Call(esContinuous | esSystemRequired)
		<-done
		setThreadExecutionState.Call(esContinuous)
	}()
	return func() { close(done) }, nil
}
