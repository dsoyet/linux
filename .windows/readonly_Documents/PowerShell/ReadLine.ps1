# PSReadLine 主题适配 — 自动跟随 Windows 系统深浅色模式
# 用法: 在 $PROFILE 中添加一行:  . "$PSScriptRoot\psreadline-theme.ps1"
# 手动切换: Set-PsTheme Light  或  Set-PsTheme Dark

if ($host.Name -ne 'ConsoleHost') { return }

Import-Module PSReadLine -MinimumVersion 2.4.5 -ErrorAction SilentlyContinue

$esc = [char]27

function Set-PsTheme {
    param([ValidateSet("Light", "Dark")] $Theme = "Dark")

    if ($Theme -eq "Dark") {
        # ═══════════════════════════════════════
        # Dark 主题配色 (背景 #000000 / 前景 #FFFFFF)
        # 调色板: 红#FE0100 绿#33FF00 黄#FEFF00 蓝#0066FF 紫#CC00FF 青#00FFFF
        # ═══════════════════════════════════════
        Set-PSReadLineOption -Colors @{
            "Default"            = "${esc}[37m"     # 白色 #D0D0D0 — 正文
            "Command"            = "${esc}[93m"     # 亮黄 #FEFF00 — 命令名
            "Comment"            = "${esc}[32m"     # 绿色 #33FF00 — 注释
            "Keyword"            = "${esc}[92m"     # 亮绿 #33FF00 — 关键字
            "String"             = "${esc}[36m"     # 青色 #00FFFF — 字符串
            "Number"             = "${esc}[97m"     # 亮白 #FFFFFF — 数字
            "Member"             = "${esc}[37m"     # 白色 — 成员访问
            "Type"               = "${esc}[37m"     # 白色 — 类型名
            "Variable"           = "${esc}[92m"     # 亮绿 — 变量
            "Parameter"          = "${esc}[90m"     # 灰色 #808080 — 参数
            "Operator"           = "${esc}[90m"     # 灰色 — 运算符
            "Emphasis"           = "${esc}[96m"     # 亮青 — 强调
            "Error"              = "${esc}[91m"     # 亮红 #FE0100 — 错误
            "Selection"          = "${esc}[30;47m"  # 黑底白字 — 选择
            "ContinuationPrompt" = "${esc}[37m"     # 白色 — 续行提示
            "InlinePrediction"   = "${esc}[97;2;3m" # 亮白暗斜 — 预测
        }
    }
    else {
        # ═══════════════════════════════════════
        # Light 主题配色 (背景 #FFFFFF / 前景 #000000)
        # 调色板: 黑#000000 红#db4437 绿#0f9d58 黄#f4b400 蓝#4285f4
        # 注意: 35/36 与 31/34 同色，可用色仅 5 种：黑红绿黄蓝
        # ANSI 37(白) 和 97(亮白) 在白色背景上完全不可见，必须替换
        # ═══════════════════════════════════════
        Set-PSReadLineOption -Colors @{
            "Default"            = "${esc}[30m"     # 黑色 — 正文 (原37白→不可见)
            "Command"            = "${esc}[33m"     # 黄色 #f4b400 — 命令名
            "Comment"            = "${esc}[32m"     # 绿色 #0f9d58 — 注释
            "Keyword"            = "${esc}[34m"     # 蓝色 #4285f4 — 关键字
            "String"             = "${esc}[31m"     # 红色 #db4437 — 字符串
            "Number"             = "${esc}[35m"     # 品红(映射红) — 数字 (原97亮白→不可见)
            "Member"             = "${esc}[34m"     # 蓝色 — 成员 (原37白→不可见)
            "Type"               = "${esc}[34m"     # 蓝色 — 类型 (原37白→不可见)
            "Variable"           = "${esc}[34m"     # 蓝色 — 变量
            "Parameter"          = "${esc}[90m"     # 灰黑 — 参数
            "Operator"           = "${esc}[90m"     # 灰黑 — 运算符
            "Emphasis"           = "${esc}[34m"     # 蓝色 — 强调
            "Error"              = "${esc}[91m"     # 亮红 — 错误
            "Selection"          = "${esc}[30;47m"  # 黑字白底 — 选择
            "ContinuationPrompt" = "${esc}[30m"     # 黑色 — 续行提示 (原37白→不可见)
            "InlinePrediction"   = "${esc}[90m"     # 灰黑 — 预测 (原97亮白→不可见)
        }
    }
}

function Get-SystemTheme {
    $light = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -ErrorAction SilentlyContinue
    if ($light -eq 0) { return "Dark" } else { return "Light" }
}

# 编译一次 Windows API 调用，用于广播系统主题变化
if (-not ([System.Management.Automation.PSTypeName]'ThemeHelper').Type) {
    Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class ThemeHelper {
    [DllImport("user32.dll", SetLastError = true)]
    private static extern IntPtr SendMessageTimeout(IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam, uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
    private const uint HWND_BROADCAST = 0xFFFF;
    private const uint WM_SETTINGCHANGE = 0x001A;
    private const uint SMTO_ABORTIFHUNG = 0x0002;
    public static void BroadcastThemeChange() {
        UIntPtr result;
        SendMessageTimeout((IntPtr)HWND_BROADCAST, WM_SETTINGCHANGE, UIntPtr.Zero, "ImmersiveColorSet", SMTO_ABORTIFHUNG, 5000, out result);
        SendMessageTimeout((IntPtr)HWND_BROADCAST, WM_SETTINGCHANGE, UIntPtr.Zero, "WindowsThemeElement", SMTO_ABORTIFHUNG, 5000, out result);
    }
}
'@
}

function Set-SystemTheme {
    <#
    .SYNOPSIS
    切换 Windows 系统深浅色模式
    .EXAMPLE
    Set-SystemTheme Dark   # 切深色
    Set-SystemTheme Light  # 切浅色
    #>
    param([ValidateSet("Light", "Dark")] $Theme)
    $value = if ($Theme -eq "Light") { 1 } else { 0 }
    $regPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    Set-ItemProperty -Path $regPath -Name "AppsUseLightTheme" -Value $value
    Set-ItemProperty -Path $regPath -Name "SystemUsesLightTheme" -Value $value
    [ThemeHelper]::BroadcastThemeChange()
    Write-Host "System theme switched to: $Theme" -ForegroundColor Green
}

# === 启动时应用 ===
$script:CurrentPsTheme = Get-SystemTheme
Set-PsTheme $script:CurrentPsTheme

# === 运行时轮询（每 2 秒检查系统主题变化） ===
if (-not (Get-EventSubscriber -SourceIdentifier "ThemePollTimer" -ErrorAction SilentlyContinue)) {
    $timer = New-Object System.Timers.Timer
    $timer.Interval = 2000
    $timer.AutoReset = $true
    $null = Register-ObjectEvent `
        -InputObject $timer `
        -EventName "Elapsed" `
        -SourceIdentifier "ThemePollTimer" `
        -Action {
            try {
                $newTheme = Get-SystemTheme
                if ($newTheme -ne $script:CurrentPsTheme) {
                    $script:CurrentPsTheme = $newTheme
                    Set-PsTheme $newTheme
                }
            } catch { }
        }
    $timer.Start()
}
