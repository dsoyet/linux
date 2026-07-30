{ config, pkgs, lib, ... }:
lib.recursiveUpdate (import ../common.nix { inherit config pkgs lib; }) {
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
        padding = { x = 0; y = 0; };
      };
      font.size = 14;
      selection.save_to_clipboard = true;
    };
  };

  programs.mpv.enable = true;

  programs.bash = {
    bashrcExtra = ''
      export RUSTUP_HOME=$HOME/.local/share/rustup
      export GOPATH=$HOME/.local/share/go
      export CARGO_HOME=$HOME/.local/share/cargo
      export PATH="$HOME/.local/bin:$GOPATH/bin:$CARGO_HOME/bin:$PATH"
    '';
    shellAliases = {
      xdg = "lsd --tree --depth 1 -A ~/.cache ~/.config ~/.local";
    };
  };
}
