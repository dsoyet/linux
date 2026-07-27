{ config, lib, pkgs, ... }:

{
  imports = [ ];

  system.stateVersion = "26.05";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # --- ZRAM 压缩内存交换 ---
  zramSwap = {
    enable = true;
    algorithm = "zstd";       # zstd 压缩比高且速度快
    memoryPercent = 50;       # 使用 50% 内存作为 swap
  };

  networking.networkmanager.enable = false;

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    packages = [ pkgs.terminus_font ];
    font = "ter-v32n";
    useXkbConfig = true;
  };

  # --- 用户 ---
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

  # --- SSH ---
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

  # --- 基础系统包 ---
  environment.systemPackages = with pkgs; [
    chezmoi
    gcc
    bottom
    lsd
    psmisc
    neovim
    dust
    delta
    aliyun-cli
  ];

  # --- Neovim ---
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

  # --- Nix 工具 ---
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 8d --keep 5";
    flake = "/home/share/.android/nix";
  };

  programs.direnv.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # --- Shell ---
  programs.bash.promptInit = ''
    PROMPT_COLOR="1;31m"; ((UID)) && PROMPT_COLOR="1;32m"; export PS1="\[\033[$PROMPT_COLOR\][\h:\w]\\$\[\033[0m\] "
  '';

  # --- Nix 配置 ---
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      # 优先使用国内镜像, cache.nixos.org 兜底
      substituters = [
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://mirrors.cernet.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
}
