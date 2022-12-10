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
    substituters = [ "https://cache.nixos.org/" "https://cache.garnix.io/" ];
    trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
  };

}
