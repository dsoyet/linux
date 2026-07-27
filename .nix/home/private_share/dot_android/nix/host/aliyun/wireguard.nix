{ config, lib, pkgs, ... }:

let
  wgDir = "/etc/wireguard";

  # 一键添加客户端脚本
  wg-add-peer = pkgs.writeShellScriptBin "wg-add-peer" ''
    set -e
    NAME=''${1:?Usage: wg-add-peer <name> <ip>}
    IP=''${2:?Usage: wg-add-peer <name> <ip>}

    CLIENT_KEY=$(${pkgs.wireguard-tools}/bin/wg genkey)
    CLIENT_PUB=$(${pkgs.wireguard-tools}/bin/wg pubkey <<< "$CLIENT_KEY")
    SERVER_PUB=$(${pkgs.wireguard-tools}/bin/wg pubkey < ${wgDir}/wg0.key)
    SERVER_ENDPOINT=$(cat /etc/wireguard/endpoint 2>/dev/null || echo "YOUR_SERVER_IP")

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  添加到 nix 配置 peers 列表:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  # $NAME"
    echo "  { publicKey = \"$CLIENT_PUB\"; allowedIPs = [ \"$IP/32\" ]; }"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  客户端配置 ($NAME.conf):"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    cat <<CLIENTCONF
[Interface]
PrivateKey = $CLIENT_KEY
Address = $IP/24

[Peer]
PublicKey = $SERVER_PUB
Endpoint = $SERVER_ENDPOINT:51820
AllowedIPs = 192.168.64.0/24
PersistentKeepalive = 25
CLIENTCONF
  '';
in
{
  # --- 首次启动自动生成密钥对 ---
  systemd.services.wireguard-keygen = {
    description = "Generate WireGuard key pair on first boot";
    wantedBy = [ "multi-user.target" ];
    before = [ "wireguard-wg0.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      mkdir -p ${wgDir}
      if [ ! -f ${wgDir}/wg0.key ]; then
        ${pkgs.wireguard-tools}/bin/wg genkey > ${wgDir}/wg0.key
        chmod 600 ${wgDir}/wg0.key
      fi
      # 公钥始终同步 (私钥可能已有)
      ${pkgs.wireguard-tools}/bin/wg pubkey < ${wgDir}/wg0.key > ${wgDir}/wg0.pub
    '';
  };

  # --- WireGuard VPN Server ---
  networking.wireguard.interfaces.wg0 = {
    ips = [ "192.168.64.1/24" ];
    listenPort = 51820;
    mtu = 1280;
    privateKeyFile = "${wgDir}/wg0.key";

    peers = [
      # 使用 wg-add-peer <name> <ip> 生成后添加到这里
      # g634j1
      { publicKey = "JIrPdzBVDgrkFgHabAIwIH50NlpiNgo6mqvwfnzxE3g="; allowedIPs = [ "192.168.64.21/32" ]; }
    ];
  };

  # --- NAT 转发 ---
  networking.nat = {
    enable = true;
    internalInterfaces = [ "wg0" ];
    externalInterface = "ens5";
  };

  # --- 工具脚本 ---
  environment.systemPackages = [ wg-add-peer ];
}
