{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./zsh.nix
    ./packages.nix
    ./micro.nix
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

}
