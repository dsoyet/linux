# 批量更新 NRPT 规则（先清空再添加）
# 以管理员身份运行

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "请以管理员身份运行此脚本"
    exit 1
}

$dnsServer = "223.5.5.5"

# 要添加的域名列表
$domains = @(
    ".deepseek.com",
    ".115.com",
    ".115vod.com",
    ".115cdn.net",
    ".cn",
    ".com.cn",
    ".net.cn",
    ".org.cn",
    ".gov.cn",
    ".edu.cn"
)

# 清空所有现有规则
Get-DnsClientNrptRule | Remove-DnsClientNrptRule -Force
Write-Host "已清空所有规则"

# 添加新规则
foreach ($domain in $domains) {
    Add-DnsClientNrptRule -Namespace $domain -NameServers $dnsServer
    Write-Host "已添加: $domain -> $dnsServer"
}

# 刷新 DNS 缓存
# ipconfig /flushdns | Out-Null

Write-Host "`n当前规则列表："
Get-DnsClientNrptRule | Format-Table -AutoSize