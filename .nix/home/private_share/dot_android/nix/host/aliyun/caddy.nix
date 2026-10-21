{ config, lib, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    email = "dsoyet@foxmail.com";
    globalConfig = ''
      acme_ca https://acme-v02.api.letsencrypt.org/directory
    '';

    virtualHosts."dsoleaf.top" = {
      extraConfig = ''
        encode gzip

        redir /auth /auth/ 308
        redir /chuang /chuang/ 308

        # Preserve the prefix: Authelia itself is configured to serve /auth/.
        handle /auth/* {
          reverse_proxy 127.0.0.1:9091
        }

        handle /chuang/* {
          route {
            # Never accept an identity asserted by the browser.
            request_header -Remote-User
            request_header -Remote-Groups
            request_header -Remote-Email
            request_header -Remote-Name

            forward_auth 127.0.0.1:9091 {
              uri /api/authz/forward-auth
              copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
            }

            # Replace only this responder with the private Windows Web service later.
            # No unauthenticated fallback to static files if authentication fails.
            respond "Authentication succeeded. Chuang backend is not connected yet." 503
          }
        }

        # Existing homepage and all other static pages remain public.
        handle {
          root * /var/www/dsoleaf
          file_server
        }
      '';
    };

    virtualHosts."www.dsoleaf.top" = {
      extraConfig = ''
        redir https://dsoleaf.top{uri} permanent
      '';
    };
  };
}
