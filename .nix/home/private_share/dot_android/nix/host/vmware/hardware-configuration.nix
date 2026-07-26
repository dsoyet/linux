{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "ehci_pci" "ahci" "xhci_pci" "nvme" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/722de861-e1f9-4e2f-b856-250fa5ff93bf";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/D8B2-C186";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/85de6e16-0292-49c1-90ad-3636cc6c3029";
      fsType = "btrfs";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/8a4cab9d-a650-4c34-a275-40131a49a6f8"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
