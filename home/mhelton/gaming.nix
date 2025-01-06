{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lutris
    lm_sensors
    theforceengine
    ryujinx
    moonlight-qt
    heroic
    chiaki4deck
    dreamm
    (Starship.overrideAttrs (old: {
      version = "1.0.0-unstable-2025-01-06";
      src = old.src.override {
        rev = "34c94df42d3c2075d454c2730abfe548bcacd8ad";
        hash = "sha256-zDsaq34fZQDzJ2rwNQ05FaCSpPYwgPguUrLN2RJiIKg=";
      };
    }))
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
