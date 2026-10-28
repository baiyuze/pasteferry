//go:build windows

package lan

import (
	"context"
	"encoding/base64"
	"encoding/binary"
	"encoding/json"
	"fmt"
	"net/netip"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"
	"syscall"
	"time"
	"unicode/utf16"
)

var permissionMu sync.Mutex

// RequestPermission 检查后台服务的入站规则；需要修复时弹出 UAC，并等待
// netsh 完成后重新检查。二维码窗口每次打开都会调用，已放行时不再弹 UAC。
// TCP 用于手机网页传输和隔空传送，UDP 用于设备同步。
func RequestPermission() error {
	permissionMu.Lock()
	defer permissionMu.Unlock()
	exe, err := os.Executable()
	if err != nil {
		return err
	}
	allowed, err := firewallAllowsProgram(exe)
	if err != nil {
		return err
	}
	if allowed {
		return nil
	}
	// 不经过 cmd.exe：路径中的 %、&、引号等不能变成命令或环境变量。
	// 先移除旧的入站阻止规则（阻止优先于允许），保留原有的出站规则。
	repair := `$ErrorActionPreference = 'Stop'
$exe = ` + powershellLiteral(exe) + `
$netsh = Join-Path $env:SystemRoot 'System32\netsh.exe'
& $netsh advfirewall firewall delete rule name=all dir=in "program=$exe" | Out-Null
foreach ($protocol in @('UDP', 'TCP')) {
    & $netsh advfirewall firewall add rule name=PasteFerry dir=in action=allow "program=$exe" "protocol=$protocol" profile=any | Out-Null
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
exit 0
`
	// Start-Process -Wait 等待提权后的进程退出，不能把「UAC 已启动」当成成功。
	script := `$ErrorActionPreference = 'Stop'
$p = Start-Process -FilePath (Join-Path $PSHOME 'powershell.exe') -Verb RunAs -WindowStyle Hidden -Wait -PassThru -ArgumentList @('-NoProfile', '-NonInteractive', '-EncodedCommand', '` + encodePowershell(repair) + `')
exit $p.ExitCode
`
	if _, err := runFirewallScript(script, 2*time.Minute); err != nil {
		return fmt.Errorf("防火墙授权未完成，请在系统弹窗中允许管理员操作后重试: %w", err)
	}
	allowed, err = firewallAllowsProgram(exe)
	if err != nil {
		return err
	}
	if !allowed {
		return fmt.Errorf("防火墙规则未生效，请检查系统或组织的防火墙策略后重试")
	}
	return nil
}

func firewallAllowsProgram(exe string) (bool, error) {
	// COM 的属性与系统语言无关；NetSecurity cmdlet 启动较慢。
	script := `$ErrorActionPreference = 'Stop'
$policy = New-Object -ComObject HNetCfg.FwPolicy2
$rules = @($policy.Rules | Where-Object { $_.ApplicationName -ieq ` + powershellLiteral(exe) + ` } | ForEach-Object {
    $localPorts = $remotePorts = ''
    if ($_.Protocol -eq 6 -or $_.Protocol -eq 17) {
        $localPorts = $_.LocalPorts
        $remotePorts = $_.RemotePorts
    }
    [PSCustomObject]@{
        Enabled = $_.Enabled; Direction = $_.Direction; Action = $_.Action
        Profiles = $_.Profiles; Protocol = $_.Protocol; ServiceName = $_.ServiceName
        LocalPorts = $localPorts; RemotePorts = $remotePorts
        LocalAddresses = $_.LocalAddresses; RemoteAddresses = $_.RemoteAddresses
        InterfaceTypes = $_.InterfaceTypes; Interfaces = @($_.Interfaces)
    }
})
ConvertTo-Json -InputObject $rules -Depth 4 -Compress
`
	out, err := runFirewallScript(script, 15*time.Second)
	if err != nil {
		return false, fmt.Errorf("检查 Windows 防火墙失败: %w", err)
	}
	var rules []firewallRule
	if err := json.Unmarshal(out, &rules); err != nil {
		return false, fmt.Errorf("读取 Windows 防火墙规则失败: %w", err)
	}
	return firewallRulesAllowProgram(rules), nil
}

func powershellLiteral(s string) string { return "'" + strings.ReplaceAll(s, "'", "''") + "'" }

func encodePowershell(script string) string {
	units := utf16.Encode([]rune(script))
	b := make([]byte, len(units)*2)
	for i, u := range units {
		binary.LittleEndian.PutUint16(b[i*2:], u)
	}
	return base64.StdEncoding.EncodeToString(b)
}

func runFirewallScript(script string, timeout time.Duration) ([]byte, error) {
	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()
	// 使用系统自带的 PowerShell，避免 PATH 中的同名程序接到提权请求。
	ps := filepath.Join(os.Getenv("SystemRoot"), "System32", "WindowsPowerShell", "v1.0", "powershell.exe")
	cmd := exec.CommandContext(ctx, ps, "-NoProfile", "-NonInteractive", "-EncodedCommand", encodePowershell(script))
	cmd.SysProcAttr = &syscall.SysProcAttr{HideWindow: true}
	out, err := cmd.Output()
	if ctx.Err() != nil {
		return nil, ctx.Err()
	}
	return out, err
}

// Windows 不会在发送时拦截，防火墙只挡入站。
func deniedByOS(error) bool { return false }

// 只有 macOS 会在发送时拦截，Windows 不需要探测。
func probeTarget() (netip.Addr, bool) { return netip.Addr{}, false }
