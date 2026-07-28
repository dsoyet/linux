@echo off
setlocal enabledelayedexpansion

set "root=C:\Users\Administrator\Downloads\Vim"
set "XDG_CONFIG_HOME=%root%\home\.config"
set "XDG_DATA_HOME=%root%\home\.local\share"
set "XDG_STATE_HOME=%root%\home\.local\state"
set "XDG_CACHE_HOME=%root%\home\.cache"

set "exe=%root%\bin\nvim.exe"
if not exist "%exe%" set "exe=%root%\nvim.exe"

if not exist "%exe%" (
    echo [ERROR] 找不到 nvim.exe
    exit /b 1
)

"%exe%" %*
