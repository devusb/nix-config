{ pkgs, ... }:
let
  moonlight = pkgs.moonlight-qt.override { SDL2 = pkgs.SDL2.override { drmSupport = true; }; };
in
{
  home.packages = with pkgs; [
    lutris
    lm_sensors
    dolphin-emu-beta
    chiaki
    theforceengine
    ryujinx
    moonlight
    openjk.openjo
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
