{ config, lib, pkgs, ... }:

let
  auth = config.services.authelia.instances.main;
  stateDir = "/var/lib/authelia-main";
  bootstrapDir = "/var/lib/dsoleaf-auth";
  # Only program text enters the store. All secrets are generated on activation.
  initialize = pkgs.writeText "initialize-dsoleaf-authelia.py" ''
    import json
    import os
    import pathlib
    import pwd
    import secrets
    import subprocess
    import tempfile

    state = pathlib.Path("${stateDir}")
    bootstrap = pathlib.Path("${bootstrapDir}")
    account = pwd.getpwnam("${auth.user}")
    state.mkdir(mode=0o700, parents=True, exist_ok=True)
    os.chown(state, account.pw_uid, account.pw_gid)
    os.chmod(state, 0o700)
    bootstrap.mkdir(mode=0o700, parents=True, exist_ok=True)
    os.chmod(bootstrap, 0o700)

    def save_new(path, content, uid, gid):
        if path.exists():
            return
        fd, temporary = tempfile.mkstemp(prefix=".init-", dir=path.parent)
        try:
            os.fchmod(fd, 0o600)
            os.fchown(fd, uid, gid)
            with os.fdopen(fd, "w") as stream:
                stream.write(content)
                stream.flush()
                os.fsync(stream.fileno())
            os.link(temporary, path)
        finally:
            os.unlink(temporary)

    for filename in ("jwt-secret", "session-secret", "storage-key"):
        save_new(state / filename, secrets.token_hex(32) + "\n", account.pw_uid, account.pw_gid)

    users = state / "users.yml"
    if not users.exists():
        result = subprocess.run([
            "${auth.package}/bin/authelia", "crypto", "hash", "generate", "argon2",
            "--random", "--random.length", "32", "--memory", "65536", "--parallelism", "2",
        ], check=True, capture_output=True, text=True)
        fields = dict(line.split(": ", 1) for line in result.stdout.splitlines() if ": " in line)
        password, digest = fields["Random Password"], fields["Digest"]
        # Preserve an incomplete initialization for recovery rather than overwrite it.
        if (bootstrap / "initial-password.txt").exists():
            raise RuntimeError("Initial password already exists but users.yml is missing; restore users.yml before switching")
        save_new(bootstrap / "initial-password.txt", password + "\n", 0, 0)
        database = {"users": {"share": {
            "displayname": "Dsoleaf", "password": digest,
            "email": "dsoyet@foxmail.com", "groups": ["owners"],
        }}}
        save_new(users, json.dumps(database, indent=2) + "\n", account.pw_uid, account.pw_gid)
    print("Dsoleaf Authelia files ready; no secrets printed. Existing files preserved.")
  '';
in
{
  services.authelia.instances.main = {
    enable = true;
    secrets = {
      jwtSecretFile = "${stateDir}/jwt-secret";
      sessionSecretFile = "${stateDir}/session-secret";
      storageEncryptionKeyFile = "${stateDir}/storage-key";
    };
    settings = {
      theme = "auto";
      log = { level = "info"; format = "text"; };
      server.address = "tcp://127.0.0.1:9091/auth";

      authentication_backend = {
        password_reset.disable = true;
        file = {
          path = "${stateDir}/users.yml";
          watch = true;
          password = {
            algorithm = "argon2";
            argon2 = { variant = "argon2id"; memory = 65536; iterations = 3; parallelism = 2; };
          };
        };
      };

      webauthn = {
        disable = false;
        enable_passkey_login = true;
        display_name = "Dsoleaf";
        selection_criteria = { discoverability = "required"; user_verification = "required"; };
      };
      # Keep the usual OTP route available as an optional recovery method.
      totp.issuer = "Dsoleaf";

      session = {
        name = "dsoleaf_session";
        same_site = "lax";
        inactivity = "30 minutes";
        expiration = "12 hours";
        remember_me = "7 days";
        cookies = [{
          domain = "dsoleaf.top";
          authelia_url = "https://dsoleaf.top/auth/";
          default_redirection_url = "https://dsoleaf.top/chuang/";
        }];
      };

      # Authelia is only invoked for protected Caddy routes. Other content stays public.
      # one_factor supports direct Passkey login without experimental 2FA semantics.
      access_control = {
        default_policy = "deny";
        rules = [
          {
            # A dedicated stronger-authentication check. Must precede the general rule.
            # v4.39.20 exposes WebAuthn enrollment only if MFA exists in the authorizer.
            # Ordinary /chuang/ access still permits passwordless Passkey login below.
            domain = "dsoleaf.top";
            resources = [ "^/chuang/security-check(/.*)?$" ];
            subject = [ "user:share" ];
            policy = "two_factor";
          }
          {
            domain = "dsoleaf.top";
            resources = [ "^/chuang(/.*)?$" ];
            subject = [ "user:share" ];
            policy = "one_factor";
          }
        ];
      };
      storage.local.path = "${stateDir}/db.sqlite3";
      # Single owner bootstrap: read verification codes over SSH, no SMTP credentials needed.
      # This private file is NOT inside /var/www and is never exposed by Caddy.
      notifier.filesystem.filename = "${stateDir}/notifications.txt";
      regulation = { max_retries = 5; find_time = "2 minutes"; ban_time = "5 minutes"; };
    };
  };

  # Idempotent initialization during the user-requested nixos-rebuild switch.
  # No daemon is started and no live NixOS generation is switched by adding this file.
  system.activationScripts.dsoleafAuthelia = {
    deps = [ "users" ];
    text = ''
      ${pkgs.python3}/bin/python3 ${initialize}
    '';
  };
}
