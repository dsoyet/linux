{ config, lib, pkgs, ... }:

{
  imports = [
    ../../base.nix
    ./hardware-configuration.nix
    ./image.nix
    ./caddy.nix
    ./authelia.nix
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
    config = ''
      # 不碰 hostname, 由 NixOS 声明式管理
      preserve_hostname: true
      # 不碰用户管理
      users:
        - default
      ssh_pwauth: false
      disable_root: false
    '';
  };

  # --- Syncthing ---
  systemd.services.syncthing.serviceConfig.WorkingDirectory = "/var/lib/syncthing";
  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
    guiAddress = "192.168.64.1:8384"; # By default syncthing only listens to localhost
    settings = {
      defaults.folder.path = "/var/lib/syncthing/data";
    };
  };

  # --- SSH 加固 ---
  services.openssh.settings = {
    PermitRootLogin = "prohibit-password";
    PasswordAuthentication = false;
  };

  # --- 终端管理器 + OSS 挂载 ---
  environment.systemPackages = with pkgs; [
    ossfs2
    zellij
  ];

  # --- GPG 终端密码输入 ---
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-curses;
}
