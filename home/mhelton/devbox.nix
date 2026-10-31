{
  lib,
  pkgs,
  config,
  ...
}:
let
  collieHost = "machine-morgan.penguin-logarithm.ts.net";
in
{
  nix.package = pkgs.nix;

  programs.keychain.enable = lib.mkForce false;

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = config.programs.fish.enable;
    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
    pinentry.package = lib.mkIf pkgs.stdenv.hostPlatform.isLinux pkgs.pinentry-curses;
  };

  programs.password-store = {
    enable = true;
    settings.PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
  };

  programs.claude-code.enableMcpIntegration = true;

  programs.herdr.server.enable = true;
  systemd.user.services.herdr.Service.KillMode = "mixed";

  services.collie = {
    enable = true;
    package = pkgs.collie.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        # fix for the page staying shifted up after the iOS keyboard closes with the wide sidebar open
        (pkgs.fetchpatch {
          url = "https://github.com/devusb/collie/commit/7410f0970309517d80549272190c9b24606c4450.patch";
          includes = [ "web/src/components/wide-layout.tsx" ];
          hash = "sha256-C+vsMu8yxnChqG6iMOiChmbOoRwoVUcq3ZxC62UqXRI=";
        })
      ];
    });
    settings = {
      access.trusted_user = "morgan@flox.dev";
      network = {
        public_hosts = [ collieHost ];
        allowed_origins = [ "https://${collieHost}" ];
        public_url = "https://${collieHost}";
      };
    };
  };
}
