{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;

  boot.uki = {
    name = "NixOS Linux";
  };

  networking.hostName = "nixos-aliyun";
}
