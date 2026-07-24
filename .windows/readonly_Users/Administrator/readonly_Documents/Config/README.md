
### 常见命令

#### Matlab
```
.\mpm.exe install --release=R2025b --destination="C:\Program Files\MATLAB\R2025b" --products=MATLAB Parallel_Computing_Toolbox
md "C:\Program Files\MATLAB\R2025b\licenses"
copy .\license.lic "C:\Program Files\MATLAB\R2025b\licenses"
Copy-Item -Path C:\Users\Administrator\Downloads\mpm\libmwlmgrimpl.dll -Destination "C:\Program Files\MATLAB\R2025b\bin\win64\matlab_startup_plugins\lmgrimpl\libmwlmgrimpl.dll" -force

winget install Microsoft.VisualStudioCode --scope machine

wsl --install --distribution Ubuntu --location "E:\HD\Linux"



D:\setup.exe -inputFile C:\Users\Administrator\Downloads\matlab.txt

Copy-Item -Path C:\Users\Administrator\Downloads\libmwlmgrimpl.dll -Destination "C:\Program Files\MATLAB\R2024a\bin\win64\matlab_startup_plugins\lmgrimpl\libmwlmgrimpl.dll" -force

:: bcdedit /enum firmware

bcdedit /set {fwbootmgr} bootsequence {125921dc-c1fc-11f0-99db-806e6f6e6963}
pause
shutdown /r /t 0
```

## AV
```
	
唯井まひろ

水原わこ

	PXVR-269

```


## Windows
```
[CS64] ~> dir C:\Users\Share\AppData\Local

    Directory: C:\Users\Share\AppData\Local

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----           7/12/2026  5:09 AM                ASUS
d----           7/12/2026  5:00 AM                ConnectedDevicesPlatform
d----           7/12/2026  5:18 AM                D3DSCache
d----           7/11/2026  2:39 PM                Microsoft
d----           7/12/2026  5:10 AM                NVIDIA
d----           7/11/2026  2:37 PM                Packages
d----           7/11/2026  2:33 PM                Publishers
d----           7/11/2026  2:47 PM                Temp
d----           7/12/2026  5:00 AM                VirtualStore
[CS64] ~> dir C:\Users\Share\AppData\LocalLow\

    Directory: C:\Users\Share\AppData\LocalLow

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----           7/12/2026  5:07 AM                Intel
d---s           7/11/2026  2:37 PM                Microsoft
d----           7/12/2026  5:10 AM                NVIDIA
[CS64] ~> dir C:\Users\Share\AppData\Roaming\

    Directory: C:\Users\Share\AppData\Roaming

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----           7/11/2026  2:39 PM                Code
d----           7/11/2026  2:39 PM                KeePassXC
d---s           7/11/2026  2:22 PM                Microsoft

[CS64] ~> Get-NetAdapter

Name                      InterfaceDescription                    ifIndex Status       MacAddress
----                      --------------------                    ------- ------       ----------
Bluetooth Network Connec… Bluetooth Device (Personal Area Networ…      19 Disconnected 58-1C-F8-AF…
G634J                     WireGuard Tunnel                             29 Up
Ethernet                  Realtek Gaming 2.5GbE Family Controller       7 Disconnected 08-BF-B8-2E…
Wi-Fi                     Intel(R) Wi-Fi 6E AX211 160MHz                5 Up           58-1C-F8-AF…

```

```
# 获取 EFI 分区
$disk = Get-Disk | Where-Object { $_.BootFromDisk -eq $true }
$partition = $disk | Get-Partition | Where-Object { $_.Type -eq 'System' }

# 分配盘符（需要管理员权限）
$partition | Add-PartitionAccessPath -AccessPath "X:\"

# 访问
copy E:\HD\FileRepository\EFI\Boot\arch.efi X:\EFI\Boot\arch.efi

# 移除盘符
$partition | Remove-PartitionAccessPath -AccessPath "X:\"
```