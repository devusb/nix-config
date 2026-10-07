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

  services.collie = {
    enable = true;
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
