{ config, lib, pkgs, ... }:

{
  # nixos-rebuild build-image --flake .#aliyun --image-variant qemu-efi
  #
  # qemu-efi 变体生成 qcow2 + UEFI 启动，匹配阿里云 ECS 环境。
  # 构建产物位于 result/ ，上传 OSS 后通过阿里云控制台导入自定义镜像。
  #
  # 可在此文件中添加镜像专属配置，例如：
  #   - image.size = "20G";
  #   - 额外的 initrd 模块
}

