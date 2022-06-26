{ pkgs, config, system, lib, ... }: {
  xdg.configFile = {
    "iterm2/com.googlecode.iterm2.plist".text = lib.generators.toPlist { } (import ./extra/iterm2.nix);
    "iterm2/AppSupport/DynamicProfiles/mhelton.plist".text = lib.generators.toPlist { } (import ./extra/iterm2_profile.nix);
  };
  home.packages = with pkgs; [
  ];
}
