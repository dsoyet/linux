{ pkgs }:

pkgs.open-vm-tools.overrideAttrs (old: {
  pname = "open-vm-tools-wayland";
  version = "13.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "vmware";
    repo = "open-vm-tools";
    rev = "stable-13.1.0";
    hash = "sha256-XDIgWp6imGVFrodDAncTKh4ohGkTQKulAw5AC4iQ/zc=";
  };

  patches = [
    ./open-vm-tools-gcc16.patch
    ./clipway.patch
    ./desktopEvents-wayland.patch
  ];

  buildInputs = (old.buildInputs or []) ++ [ pkgs.wl-clipboard ];
  nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.autoreconfHook ];

  meta = (old.meta or {}) // {
    description = "open-vm-tools with Wayland clipboard support (clipway patch)";
  };
})
