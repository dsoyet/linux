{ config, lib, pkgs, ... }:

{
  # --- Caddy Web Server + 自动 HTTPS ---
  services.caddy = {
    enable = true;
    email = "dsoyet@foxmail.com";   # Let's Encrypt 通知

    virtualHosts."dsoleaf.top" = {
      extraConfig = ''
        root * /var/www/dsoleaf
        file_server
        encode gzip
      '';
    };

    # www 子域名重定向到裸域
    virtualHosts."www.dsoleaf.top" = {
      extraConfig = ''
        redir https://dsoleaf.top{uri} permanent
      '';
    };
  };
}
