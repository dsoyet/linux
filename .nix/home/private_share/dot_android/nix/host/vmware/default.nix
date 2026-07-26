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

  virtualisation.vmware.guest.enable = true;
  virtualisation.vmware.guest.headless = false;

  systemd.services.vmhgfs-fuse = {
    description = "VMware HGFS Shared Folders";
    wantedBy = [ "multi-user.target" ];

    unitConfig = {
      ConditionVirtualization = "vmware";
    };

    serviceConfig = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /ntx";
      ExecStart = "${pkgs.open-vm-tools}/bin/vmhgfs-fuse .host:/E /ntx -f -o allow_other -o auto_unmount";
      ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u /ntx";
      Restart = "always";
      RestartSec = "5s";
    };
  };

  environment.etc."fuse.conf".text = ''
    mount_max = 1000
    user_allow_other
  '';

  networking.hostName = "CS61";

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
