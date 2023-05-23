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
    heroic
  ];


  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      gl_vsync = -1;
      vsync = 0;
      fps_limit = 144;
      full = true;
      toggle_hud_position = "R_Shift+F10";
      position = "top-right";
      no_display = true;
    };
  };

}
