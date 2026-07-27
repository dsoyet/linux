{ config, lib, pkgs, ... }:

{
  imports = [
    ../../base.nix
    ./hardware-configuration.nix
    ./image.nix
    ./caddy.nix
    ./wireguard.nix
  ];

  # --- UEFI 启动 (阿里云使用 UEFI) ---
  boot.loader.systemd-boot.enable = true;

  # --- 网络 ---
  networking.hostName = "aliyun";
  networking.useDHCP = lib.mkDefault true;
  networking.firewall.enable = false;  # 用阿里云安全组, 关闭系统防火墙

  # --- cloud-init: 磁盘扩容 + 阿里云助手 ---
  services.cloud-init = {
    enable = true;
    # 只处理底层, 不碰用户管理 (由 base.nix 声明式管理)
    config = ''
      users:
        - default
      ssh_pwauth: false
      disable_root: false
    '';
  };

  # --- SSH 加固 ---
  services.openssh.settings = {
    PermitRootLogin = "prohibit-password";
    PasswordAuthentication = false;
  };

  # --- 终端管理器 ---
  environment.systemPackages = with pkgs; [
    zellij
  ];
}
