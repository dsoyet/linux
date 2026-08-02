{ config, pkgs, lib, ... }:
lib.recursiveUpdate (import ../common.nix { inherit config pkgs lib; }) {
  home.packages = with pkgs; [
    git
    go
    rustup
  ];

  programs.bash = {
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
      xdg = "lsd --tree --depth 1 -A ~/.cache ~/.config ~/.local";
      lsblk = "lsblk -n -o NAME,SIZE,FSTYPE,MOUNTPOINT";
    };
  };
}
