function Find-EmptyFoldersRecursive {
    param(
        [string]$Path,
        [int]$CurrentDepth = 0,
        [int]$MaxDepth = 5
    )
    
    if ($CurrentDepth -ge $MaxDepth) { return }
    
    $folders = Get-ChildItem -Path $Path -Directory -ErrorAction SilentlyContinue
    
    foreach ($folder in $folders) {
        # 检查这个文件夹树中是否有任何文件
        $hasFile = $false
        $allItems = Get-ChildItem -Path $folder.FullName -Recurse -Force -ErrorAction SilentlyContinue
        foreach ($item in $allItems) {
            if (-not $item.PSIsContainer) {
                $hasFile = $true
                break
            }
        }
        
        if (-not $hasFile) {
            # 没有文件 → 输出这个文件夹
            Write-Output $folder.FullName
        }
    }
}

# 使用
# Find-EmptyFoldersRecursive -Path "C:\Users\Share\AppData" -MaxDepth 1

function Reboot-ToLinux {
    $LinuxGUID = "{125921dc-c1fc-11f0-99db-806e6f6e6963}"
    
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Start-Process pwsh -Verb RunAs -ArgumentList "-NoExit", "-Command", "Reboot-ToLinux"
        return
    }
    
    bcdedit /set "{fwbootmgr}" bootsequence $LinuxGUID
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ 已设置 Linux 为下次启动项，系统即将重启..." -ForegroundColor Green
        shutdown /r /t 0
    } else {
        Write-Host "❌ 设置失败，请检查 GUID 是否正确" -ForegroundColor Red
    }
}

function Get-Brightness {
    (Get-CimInstance -Namespace root/wmi -ClassName WmiMonitorBrightness | Where-Object Active).CurrentBrightness
}

function Set-Brightness {
    param([ValidateRange(0, 100)][int]$Level)
    $m = Get-CimInstance -Namespace root/wmi -ClassName WmiMonitorBrightnessMethods | Where-Object Active
    Invoke-CimMethod -InputObject $m -MethodName WmiSetBrightness -Arguments @{Timeout = 0; Brightness = $Level} | Out-Null
}

# 用
#Get-Brightness          # 查询
#Set-Brightness 60       # 调到 60
#Set-Brightness 30       # 调到 30
#Set-Brightness 100      # 最亮

# NVIDIA WMI 保底（独显直连下标准方式失效时用这个）
#function Get-NvBrightness {
#    (Get-CimInstance -Namespace root/wmi -ClassName NvWmiBrightness |
#        Invoke-CimMethod -MethodName NvGetSetBrightnessLevel -Arguments @{inArg = 0; Level = 0}).Result
#}

#function Set-NvBrightness {
#    param([ValidateRange(0, 100)][int]$Level)
#    $nv = Get-CimInstance -Namespace root/wmi -ClassName NvWmiBrightness
#    $nv | Invoke-CimMethod -MethodName NvGetSetBrightnessLevel -Arguments @{inArg = 1; Level = $Level} | Out-Null
#}

function tree {
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        $Path,
        [Alias("d")]
        [int]$Depth = 1
    )

    if ($Path) {
        lsd --tree --depth $Depth -A $Path
    } else {
        $paths = (Get-PSDrive -PSProvider FileSystem | 
                  Where-Object { $_.Name -notin @("Temp","C","X","S") }).Name | 
                  ForEach-Object { $_ + ":\" }
        lsd --tree --depth $Depth -A $paths
    }
}

function rvf {
    param(
        [string]$Path = $PWD
    )

    $video = '.mp4', '.mkv', '.avi', '.mov', '.wmv', '.flv', '.webm', '.m4v',
             '.ts', '.m2ts', '.mts', '.rmvb', '.rm', '.3gp', '.ogv', '.vob',
             '.divx', '.asf', '.f4v', '.mpeg', '.mpg', '.m2v', '.mpe', '.hevc', '.h265'

    Get-ChildItem -LiteralPath $Path -File | Where-Object {
        $video -contains $_.Extension
    } | ForEach-Object {
        $base = [IO.Path]::GetFileNameWithoutExtension($_.Name)
        $ext  = $_.Extension

        if ($base -match '@') {
            $base = $base -replace '^.*@', ''
        }
        if ($base -notmatch '_180_LR$') {
            $base = $base + '_180_LR'
        }

        $newName = $base + $ext
        if ($_.Name -ne $newName) {
            Rename-Item -LiteralPath $_.FullName -NewName $newName -Verbose
        }
    }
}

function Update-EnvironmentVariables {
    <#
    .SYNOPSIS
        刷新 Windows 环境变量，使其立即生效
    .DESCRIPTION
        通过 SendMessageTimeout API 向系统广播 WM_SETTINGCHANGE 消息，
        通知所有程序环境变量已更新
    .EXAMPLE
        Update-EnvironmentVariables
    #>
    
    # 定义 Win32 API
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Win32API {
    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern IntPtr SendMessageTimeout(
        IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam,
        uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
}
"@

    # 常量定义
    $HWND_BROADCAST = [IntPtr]::Zero
    $WM_SETTINGCHANGE = 0x001A
    $SMTO_ABORTIFHUNG = 0x0002
    $TIMEOUT = 5000
    $result = [UIntPtr]::Zero

    # 发送广播消息
    [Win32API]::SendMessageTimeout(
        $HWND_BROADCAST,
        $WM_SETTINGCHANGE,
        [UIntPtr]::Zero,
        "Environment",
        $SMTO_ABORTIFHUNG,
        $TIMEOUT,
        [ref]$result
    )

    Write-Host "已发送环境变量刷新通知！" -ForegroundColor Green
}

# 设置别名
#Set-Alias -Name refresh-env -Value Update-EnvironmentVariables

function Copy-EFI {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$SourcePath,
        [string]$AccessPath = "X:\"
    )

    $disk = Get-Disk | Where-Object { $_.BootFromDisk }
    $partition = $disk | Get-Partition | Where-Object { $_.Type -eq 'System' }

    if (-not $partition) {
        Write-Error "未找到 EFI 系统分区"
        return
    }

    try {
        $partition | Add-PartitionAccessPath -AccessPath $AccessPath -ErrorAction Stop
        Copy-Item -Path $SourcePath -Destination "$AccessPath\EFI\Boot\arch.efi" -Force
        Write-Host "✅ 已复制到 $AccessPath\EFI\Boot\arch.efi"
    } finally {
        $partition | Remove-PartitionAccessPath -AccessPath $AccessPath -ErrorAction SilentlyContinue
    }
}

# 使用
#Copy-EFI -SourcePath "E:\HD\FileRepository\EFI\Boot\arch.efi"