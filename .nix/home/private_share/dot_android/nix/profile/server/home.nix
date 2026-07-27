{ config, pkgs, ... }:
{
  home.username = "share";
  home.homeDirectory = "/home/share";

  home.packages = with pkgs; [
    git
    go
    rustup
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Lattice Sum";
        email = "dsoyet@foxmail.com";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyFile = "$HOME/.android/share/history";
    historySize = 10000;
    historyFileSize = 100000;
    bashrcExtra = ''
      export RUSTUP_HOME=$HOME/.local/share/rustup
      export GOPATH=$HOME/.local/share/go
      export CARGO_HOME=$HOME/.local/share/cargo
      export PATH="$HOME/.local/bin:$GOPATH/bin:$CARGO_HOME/bin:$PATH"

      # zellij 自动启动 (暂时禁用)
      # if [ -n "$SSH_CONNECTION" ] && [ -z "$ZELLIJ" ]; then
      #   zellij attach -c main 2>/dev/null || zellij -s main
      # fi
    '';
    shellAliases = {
      cz = "chezmoi --config $HOME/.android/chezmoi/chezmoi.toml";
      ex = "nh os switch -H ";
      grep = "grep --color=auto";
      ll = "lsd -lA";
      ls = "lsd -1A";
      less = "moor";
      tree = "lsd --tree --depth 2 -A";
      htop = "btm -b";
      lsblk = "lsblk -n -o NAME,SIZE,FSTYPE,MOUNTPOINT";
      xdg="lsd --tree --depth 1 -A ~/.cache ~/.config ~/.local";
    };
  };

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
