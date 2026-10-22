package power

import "os/exec"

// 经 systemd-logind 登记一个空闲抑制：桌面环境不会因为放着不动而睡眠。没有 systemd 时做不到。
func inhibit(reason string) (func(), error) {
	path, err := exec.LookPath("systemd-inhibit")
	if err != nil {
		return nil, err
	}
	return holdProcess(exec.Command(path, "--what=idle", "--who=PasteFerry", "--why="+reason,
		"--mode=block", "sleep", "infinity"))
}
