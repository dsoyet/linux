{ config, lib, pkgs, ... }:

{
  # --- Caddy Web Server + 自动 HTTPS (Let's Encrypt) ---
  services.caddy = {
    enable = true;
    email = "dsoyet@foxmail.com";

    # 全局指定 Let's Encrypt (Caddy 默认走 ZeroSSL)
    globalConfig = ''
      acme_ca https://acme-v02.api.letsencrypt.org/directory
    '';

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
