{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # virtio 驱动（阿里云 ECS 使用 KVM/virtio）
  boot.initrd.availableKernelModules = [
    "virtio_pci" "virtio_blk" "virtio_net" "nvme" "ahci" "xhci_pci"
  ];
  boot.kernelModules = [ "virtio_net" ];

  # 文件系统: mkDefault 让 image 变体构建时可覆盖
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = lib.mkDefault {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
