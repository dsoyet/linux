{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # virtio 驱动（阿里云 ECS 使用 KVM/virtio）
  boot.initrd.availableKernelModules = [
    "virtio_pci" "virtio_blk" "virtio_net" "nvme" "ahci" "xhci_pci"
  ];
  boot.kernelModules = [ "virtio_net" ];

  # 文件系统由 image 变体 (qemu-efi) 自动管理
  # 分区以 label 挂载: / → nixos, /boot → ESP

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
