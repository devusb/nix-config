{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lutris
    lm_sensors
    theforceengine
    ryujinx
    moonlight-qt
    chiaki4deck
    dreamm
  ];

  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      gl_vsync = -1;
      vsync = 0;
      fps_limit = "144,60";
      full = true;
      toggle_hud_position = "R_Shift+F10";
      toggle_fps_limit = "L_Shift+F1";
      position = "top-right";
      no_display = true;
    };
  };

}
