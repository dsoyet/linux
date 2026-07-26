{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;

  boot.uki = {
    name = "NixOS Linux";
  };

  boot.kernelParams = [
    "video=Virtual-1:2560x1600"
  ];

  fileSystems."/ntx" = {
    device = "remote";
    fsType = "virtiofs";
    options = [
      "nofail"
      "x-systemd.automount"
    ];
  };

  networking.hostName = "CS61";

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
