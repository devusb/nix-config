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
      EDITOR = "${pkgs.micro}/bin/micro";
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
      "https://colmena.cachix.org"
      "https://attic.springhare-egret.ts.net/attic"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
      "attic:D6/KHcMALn0Zc1BVc/bkuou0DbpVmm4RsyF6c4l9AsE="
    ];
    netrc-file = "${config.xdg.configHome}/nix/netrc";
  };

}
