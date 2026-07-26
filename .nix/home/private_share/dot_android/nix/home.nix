{ config, pkgs, ... }:
{
  home.username = "share";
  home.homeDirectory = "/home/share";

  home.packages = with pkgs; [
    chromium
    go
    rustup
    git
    mpv
    vscode
  ];

  home.file.".config/mpv/mpv.conf".text = ''
    gpu-api=opengl
    vo=gpu-next
    hwdec=no
    profile=high-quality
    sub-auto=fuzzy
    border=no
    osc=no
    osd-bar=no
    panscan=1.0
  '';

  programs.keepassxc.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        dynamic_padding = true;
        decorations = "None";
        padding = {
          x = 0;
          y = 0;
        };
      };

      font = {
        size = 14;
      };
    };
  };

  programs.mpv = {
    enable = true;
  };

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

  #sudo nixos-rebuild switch --flake path:$HOME/.android/nixos#vmware
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
    '';
    shellAliases = {
      cz = "chezmoi --config $HOME/.android/chezmoi/chezmoi.toml";
      ex = "nh os switch -H ";
      grep = "grep --color=auto";
      ll = "lsd -lA";
      ls = "lsd -1A";
      tree = "lsd --tree --depth 2 -A";
      less = "moor";
      htop = "btm -b";
      xdg = "lsd --tree --depth 1 -A ~/.cache ~/.config ~/.local";
    };
  };

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
