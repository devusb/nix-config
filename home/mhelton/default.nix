{ config, pkgs, ... }: {
  imports = [
    ./zsh.nix
    ./packages.nix
  ];

  home = {
    username = "mhelton";
    stateVersion = "21.11";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";
    sessionVariables = {
      EDITOR = "nvim";
    };

    # enable until 24.11 is in home-manager
    enableNixpkgsReleaseCheck = false;
  };

  # https://github.com/nix-community/home-manager/issues/4142
  manual.manpages.enable = false;

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
      "https://attic.springhare-egret.ts.net/r2d2"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
      "r2d2:dGjwZKsBup19Wq8b3/W2smJjrw55tC0DnCQhu/qsfb4="
    ];
    builders-use-substitutes = true;
    netrc-file = "${config.xdg.configHome}/nix/netrc";
  };

}
