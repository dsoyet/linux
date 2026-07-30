{ config, pkgs, ... }:
{
  home.username = "share";
  home.homeDirectory = "/home/share";

  # --- 共享 home.file ---
  home.file.".config/helix/config.toml".text = ''
    theme = "base16_transparent"

    [editor]
    gutters = []
  '';

  # --- 共享程序 ---
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Lattice Sum";
        email = "dsoyet@foxmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyFile = "$HOME/.android/share/history";
    historySize = 10000;
    historyFileSize = 100000;
    shellAliases = {
      cz = "chezmoi --config $HOME/.android/chezmoi/chezmoi.toml";
      ex = "nh os switch -H ";
      grep = "grep --color=auto";
      ll = "lsd -lA";
      ls = "lsd -1A";
      less = "moor";
      tree = "lsd --tree --depth 2 -A";
      htop = "btm -b";
    };
  };

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
