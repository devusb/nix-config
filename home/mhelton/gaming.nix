{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lutris
    lm_sensors
    dolphin-emu-beta
    chiaki
    theforceengine
    ryujinx
    moonlight-qt
    openjk.openjo
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [ "steam.desktop" "net.lutris.Lutris.desktop" ];
    };
  };

  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      gl_vsync = -1;
      vsync = 0;
      fps_limit = 144;
    };
  };

}
