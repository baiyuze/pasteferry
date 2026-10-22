package power

import (
	"os"
	"os/exec"
	"strconv"
)

// caffeinate -i 阻止空闲睡眠；-w 让它在后台服务退出时自己结束，不会留下来一直挡着。
func inhibit(string) (func(), error) {
	return holdProcess(exec.Command("/usr/bin/caffeinate", "-i", "-w", strconv.Itoa(os.Getpid())))
}
