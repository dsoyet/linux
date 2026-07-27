{ config, lib, pkgs, ... }:

{
  # --- WireGuard VPN Server ---
  networking.wireguard.interfaces.wg0 = {
    ips = [ "192.168.64.1/24" ];
    listenPort = 51820;
    mtu = 1280;
    privateKey = "wJGsDsZQj7xrFj3asDdQ7B3Ga37+XfLf2lnf+nbvWnY=";

    peers = [
      # client
      { publicKey = "FDqx2dZPBpjK7bRS5HCDJkhcPohy02hOzZ6EuJrA4XI="; allowedIPs = [ "192.168.64.22/32" ]; }
      # g634j1
      { publicKey = "81FyffrOH6fuMvSxeFHzC6rf3dBNjYI4UpKKwvWdi00="; allowedIPs = [ "192.168.64.23/32" ]; }
      # 14u
      { publicKey = "L/SZFF3KKzqZbWuxC0pn7eLGnImBPseVnwPcnz8/6zw="; allowedIPs = [ "192.168.64.24/32" ]; }
      # laptop
      { publicKey = "sLD3nnNSUVhO6si6KneGZIM2pEDg8NtknVqG/Sq0BRE="; allowedIPs = [ "192.168.64.25/32" ]; }
      # phone
      { publicKey = "0hV4TmFI727aESF/nfgEGMpaG2PK08bDRiSqTffrTQ4="; allowedIPs = [ "192.168.64.26/32" ]; }
      # r14
      { publicKey = "5ar82i6+FR5E0ohCQrmd4mLdaTiYNurNQggmnVmZpTg="; allowedIPs = [ "192.168.64.27/32" ]; }
      # tablet
      { publicKey = "O16XmELfbjSdW7v2xZuPvrUrsFE6qYYEiakKWFlUJ2A="; allowedIPs = [ "192.168.64.28/32" ]; }
      # fx506hm
      { publicKey = "OWzRmEbN3790Tw4PO6lXjMooKCidhUBFKSfI4BELJC0="; allowedIPs = [ "192.168.64.29/32" ]; }
      # shamy
      { publicKey = "pP4M5IwfHrPUGgzqp/zVX864/HX1a/cyu2C92JQeMW4="; allowedIPs = [ "192.168.64.30/32" ]; }
      # rarx8
      { publicKey = "3ampWzyOqkUtajC5edI+3cpmB2uGlHmACyUwRhgiNGs="; allowedIPs = [ "192.168.64.31/32" ]; }
      # node1
      { publicKey = "v6ekbAKWlXzsPj9YuVaHWxjBDDYt6s3x9PY0vyLIGmo="; allowedIPs = [ "192.168.64.41/32" ]; }
      # node2
      { publicKey = "XOYIn2hVBW8uj9LSaAej4hJCIPbfBv/qRvBaXifTjGs="; allowedIPs = [ "192.168.64.42/32" ]; }
      # node3
      { publicKey = "tuRep36PJ8ObVDsFpD+FSZ39twNSkJQqYqUe/mg2b3k="; allowedIPs = [ "192.168.64.43/32" ]; }
      # rar8x2
      { publicKey = "gxcfuXFR3+V06Y8FnEypz72SbxPnxKUqq/sibY5B43U="; allowedIPs = [ "192.168.64.44/32" ]; }
      # g634j2
      { publicKey = "0RXXN4IzHUsBGEX4FaGODg1yqjDUu5N5EFZ7Xhv2/Eo="; allowedIPs = [ "192.168.64.45/32" ]; }
      # r590t
      { publicKey = "s7b2zGZXm9QAu0rtrteY6dziYu5KoYRjnftsgyDuPSI="; allowedIPs = [ "192.168.64.46/32" ]; }
      # rar8t
      { publicKey = "oV0CadSOUiNvUL7ZABnqwoWsDeqB8L5lTAfEZX2/+GI="; allowedIPs = [ "192.168.64.47/32" ]; }
      # r590x
      { publicKey = "gONipJ6dle6tqnDW+YlPnUJ9FCrCNHupMlEG649ByCg="; allowedIPs = [ "192.168.64.48/32" ]; }
      # u532t
      { publicKey = "Kh3WRV76b8WTQukNg/KcD3X/vgms4hJKWHJ/P1+4kg0="; allowedIPs = [ "192.168.64.49/32" ]; }
    ];
  };

  # NAT 转发 → 替代 Debian 的 PostUp/PostDown iptables 规则
  networking.nat = {
    enable = true;
    internalInterfaces = [ "wg0" ];
    externalInterface = "eth0";
  };
}
