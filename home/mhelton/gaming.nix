{ pkgs, osConfig, ... }:
{
  home.packages = with pkgs; [
    lutris
    lm_sensors
    chiaki4deck
    theforceengine
    ryujinx
    moonlight-qt
    # openjk.openjo
    heroic
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

  xdg.configFile."sunshine/apps.json" = pkgs.lib.mkIf osConfig.services.sunshine.enable {
    text = (builtins.toJSON {
      env = {
        PATH = "$(PATH):$(HOME)/.local/bin";
      };
      apps = [
        {
          name = "1440p Desktop";
          prep-cmd = [
            {
              do = "${pkgs.libsForQt5.libkscreen}/bin/kscreen-doctor output.DP-4.mode.2560x1440@144";
              undo = "${pkgs.libsForQt5.libkscreen}/bin/kscreen-doctor output.DP-4.mode.3440x1440@144";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "1080p Desktop";
          prep-cmd = [
            {
              do = "${pkgs.libsForQt5.libkscreen}/bin/kscreen-doctor output.DP-4.mode.1920x1080@120";
              undo = "${pkgs.libsForQt5.libkscreen}/bin/kscreen-doctor output.DP-4.mode.3440x1440@144";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
      ];
    });
  };

}
