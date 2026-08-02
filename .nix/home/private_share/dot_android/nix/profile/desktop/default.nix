{ config, lib, pkgs, ... }:

{
  imports = [
    ../../base.nix
  ];

  # systemd-resolved DNS 委派
  environment.etc."systemd/dns-delegate.d/share.conf".text = ''
    [Delegate]
    DNS=223.5.5.5
    Domains=deepseek.com
    Domains=115.com
    Domains=115vod.com
    Domains=115cdn.net
    Domains=cn
    Domains=com.cn
    Domains=net.cn
    Domains=org.cn
    Domains=gov.cn
    Domains=edu.cn
  '';

  # --- 音频 ---
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # --- 图形 ---
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
  ];

  # --- 桌面环境 ---
  programs.niri.enable = true;
  security.polkit.enable = true;
  services.getty.autologinUser = "share";

  # --- 输入法 ---
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      waylandFrontend = true;

      addons = with pkgs; [
        fcitx5-gtk
        qt6Packages.fcitx5-chinese-addons
        qt6Packages.fcitx5-configtool
      ];
    };
  };

  # --- 桌面包 ---
  environment.systemPackages = with pkgs; [
    alacritty
    pciutils
    vulkan-tools
  ];

  # --- GPG 图形密码弹窗 ---
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;
}
