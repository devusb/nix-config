{ pkgs, ... }:
let sunshine = (pkgs.sunshine.override { cudaSupport = true; });
in {
  home.packages = with pkgs; [
    lutris
    lm_sensors
    dolphin-emu-beta
    chiaki
    theforceengine
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [ "steam.desktop" "net.lutris.Lutris.desktop" ];
    };
  };

  services.sunshine = {
    enable = true;
    package = sunshine;
  };

}
