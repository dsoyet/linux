#https://learn.microsoft.com/en-us/powershell/
Set-PSReadLineOption -EditMode Emacs

$env:Path += ';E:\Mpv;E:\Telegram;E:\Vim\bin;E:\HD\Rust\cargo\bin;E:\HD\Js;E:\HD\Js\bootstrap;C:\Program Files\Git\usr\bin;C:\Program Files\VMware\VMware Workstation' 

function Prompt { $currentPath = (Get-Location).Path.Replace($HOME, '~'); 
    $IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator);
    "[`e[$($IsAdmin ? 31 : 32)m$env:COMPUTERNAME`e[0m] $currentPath> "
}
. "$PSScriptRoot\ReadLine.ps1"
. "$PSScriptRoot\..\Config\Function.ps1"

Remove-Alias -Name ls -Force

function which { Get-Command $args | Select-Object -ExpandProperty Definition }
function htop  { btm -b }
function env   { Get-ChildItem Env: }
function ls    { lsd -lA $args}
function ll    { lsd -1A $args}
function xdg   { lsd --tree --depth 1 -A ~/AppData/Local ~/AppData/LocalLow ~/AppData/Roaming }

function vim {
    $root = "E:\Vim"
    $env:XDG_CONFIG_HOME = "$root\home\.config"
    $env:XDG_DATA_HOME   = "$root\home\.local\share"
    $env:XDG_STATE_HOME  = "$root\home\.local\state"
    $env:XDG_CACHE_HOME  = "$root\home\.cache"
    $exe = if (Test-Path "$root\bin\nvim.exe") { "$root\bin\nvim.exe" } else { "$root\nvim.exe" }
    if (-not (Test-Path $exe)) { Write-Error "找不到 nvim.exe"; return }
    & $exe $args
}

function fastboot {  $env:HOME = "E:\Mpv\tools"; & "E:\Mpv\tools\fastboot.exe" $args }
function jf { E:\Jellyfin\system\jellyfin.exe -d E:\Jellyfin\storage }
function cz { E:\Mpv\tools\chezmoi.exe --config "E:\Job\chezmoi\chezmoi.toml" @args }
function oss { E:\Mpv\tools\ossutil.exe -c "E:\Job\chezmoi\oss" @args }
function npp { E:\Notepad\notepad++.exe @args }
function adb {  $env:HOME = "E:\Mpv\tools"; & "E:\Mpv\tools\adb.exe" $args }
function cloud { E:\Mpv\tools\cloud.exe --config "E:\Job\chezmoi\xanflorp.remote" @args }
function remote { E:\Mpv\tools\rclone.exe --config "E:\Job\chezmoi\xanflorp.remote" @args }


