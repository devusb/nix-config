{ pkgs, config, system, lib, ... }: {
  xdg.configFile = {
    "iterm2/com.googlecode.iterm2.plist".text = lib.generators.toPlist { } (import ./extra/iterm2.nix);
  };
  home.packages = with pkgs; [
  ];
}
