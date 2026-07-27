{ config, lib, pkgs, ... }:

{
  # --- WireGuard VPN Server ---
  networking.wireguard.interfaces.wg0 = {
    ips = [ "192.168.64.1/24" ];
    listenPort = 51820;
    mtu = 1280;
    privateKey = "wJGsDsZQj7xrFj3asDdQ7B3Ga37+XfLf2lnf+nbvWnY=";

    peers = [
      # client
      { publicKey = "FDqx2dZPBpjK7bRS5HCDJkhcPohy02hOzZ6EuJrA4XI="; allowedIPs = [ "192.168.64.22/32" ]; }
      # u532t
      { publicKey = "Kh3WRV76b8WTQukNg/KcD3X/vgms4hJKWHJ/P1+4kg0="; allowedIPs = [ "192.168.64.49/32" ]; }
    ];
  };

  # NAT 转发 → 替代 Debian 的 PostUp/PostDown iptables 规则
  networking.nat = {
    enable = true;
    internalInterfaces = [ "wg0" ];
    externalInterface = "eth0";
  };
}
