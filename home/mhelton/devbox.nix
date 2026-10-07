{
  inputs,
  pkgs,
  ...
}:
{
  nixpkgs.overlays = [ inputs.nix-packages.overlays.default ];

  nix.package = pkgs.nix;

  programs.herdr.server.enable = true;

  services.collie = {
    enable = true;
    settings = {
      access.trusted_user = "morgan@flox.dev";
      network = {
        public_hosts = [ "machine-morgan.penguin-logarithm.ts.net" ];
        allowed_origins = [ "https://machine-morgan.penguin-logarithm.ts.net" ];
        public_url = "https://machine-morgan.penguin-logarithm.ts.net";
      };
    };
  };
}
