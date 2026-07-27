{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # virtio 驱动（阿里云 ECS 使用 KVM/virtio）
  boot.initrd.availableKernelModules = [
    "virtio_pci" "virtio_blk" "virtio_net" "nvme" "ahci" "xhci_pci"
  ];
  boot.kernelModules = [ "virtio_net" ];

  # 文件系统: mkDefault 让 image 变体构建时可覆盖
  # 镜像构建后根分区 label 为 "nixos"
  # /boot (ESP) 由 systemd 自动发现, 无需声明
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
