{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  collieHost = "machine-morgan.penguin-logarithm.ts.net";
in
{
  nixpkgs.overlays = [ inputs.nix-packages.overlays.default ];

  nix.package = pkgs.nix;

  programs.keychain.enable = lib.mkForce false;

  programs.claude-code.enableMcpIntegration = true;

  programs.herdr.server.enable = true;

  services.collie = {
    enable = true;
    package = pkgs.llm-agents.collie;
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
