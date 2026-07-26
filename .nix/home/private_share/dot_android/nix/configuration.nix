{ config, lib, pkgs, ... }:

{
  imports = [ ];

  system.stateVersion = "26.05";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = false;

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    packages = [ pkgs.terminus_font ];
    font = "ter-v32n";
    useXkbConfig = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
  ];

  services.getty.autologinUser = "share";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.share = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0xixRgRSmWVb1s9D9lSG9CbBvyToa1nWppPeF0Ae5C1FVKR1NSLh52pq9ib2crcfw7cU8DApeau4FDeYNvq+Kv5a/4kDX7/xjmDu3UmAUb3UaGdmKkBr3QLneTz6TR/99pLXtuIsqHXP3Mi/oGdmrltOlPAJrYQN6xKpyskIEx2Cui1Wy4qlC+t1p6Q/ckeWLXa8NQZ3CCb+acpnB8oU1M3kA0IMRl0GExNQCPKHkX2Y8dQuHvPTEb+gNboCIN0BNiVvVNZjo+CI3Le8xXm6mIr6GNYf5aYTAoEXnaQ0W+0Lht3brXLSvmdXi46UdejMj1FzkK5bC9TMg41wLf5H/EXDMkpDvQ1wuB8cOjOsoG3xITwWmojYTnqBacEDxJYarBq+lL4HW3Dww23o47+7BNbEyip7oyIDAbh8qfrZPhnYJqZqgzwQtZHn5ECPfjrK/tqTQA1j3yn9CqacNuyeKrpC0zuKYchPmVtCcdxX4JPwQrzYdRhWnzJKYP97UtWv7LjfOQGsgNQQwdU7R6ynsjrIMG2QaaAkZkcNClSgeIMmnGwyVKooQyJbCTiy17VITVS7j59P93mGFwJU/zWzfmm+JnqJuXacYmB35oRz36dZBpRpetLjKXnbK6RP+ncsnRJykHxmNXTyZ4jyBKgLNGqARnv6ukztHIlJvSAWWRw== share@id_rsa"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.niri.enable = true;
  security.polkit.enable = true;
  programs.direnv.enable = true;
  security.sudo.wheelNeedsPassword = false;

  programs.bash.promptInit = ''
    PROMPT_COLOR="1;31m"; ((UID)) && PROMPT_COLOR="1;32m"; export PS1="\[\033[$PROMPT_COLOR\][\h:\w]\\$\[\033[0m\] "
  '';

  environment.systemPackages = with pkgs; [
    alacritty
    chezmoi
    gcc
    bottom
    lsd
    psmisc
    cpx
    moor
    neovim
    dust
    delta
    pciutils
    vulkan-tools
  ];

  programs.neovim = {
    defaultEditor = true;
    enable = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
        set mouse=
        set viminfo='100,<50,s10,h
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
      '';
    };
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 8d --keep 5";  # 自动清理旧版本
    flake = "/home/share/.android/nix";
  };

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

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      extra-substituters = [ "https://mirrors.cernet.edu.cn/nix-channels/store" ];
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  services.openssh.enable = true;
  programs.ssh = {
    extraConfig = ''
      Host *
        ForwardAgent yes
        StrictHostKeyChecking no
        UserKnownHostsFile /dev/null
        LogLevel ERROR
    '';
  };
}
