{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./zsh.nix
    ./packages.nix
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  home = {
    username = "mhelton";
    stateVersion = "21.11";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";
    sessionVariables = {
      EDITOR = "micro";
    };
  };

  systemd.user.startServices = "sd-switch";

  fonts = {
    fontconfig.enable = true;
  };

  nix.settings = {
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

}
