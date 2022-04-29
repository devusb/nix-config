{ pkgs, lib, config, ...}: {
    home.packages = with pkgs; [];
    programs.firefox.enable = true;

  programs.terminator = {
    enable = true;
    config = {
      profiles.default.use_system_font = false;
    };
  };

    xsession.windowManager.i3 = {
        enable = true;
        config = {
            modifier = "Mod1";
            keybindings = let modifier = config.xsession.windowManager.i3.config.modifier; in lib.mkOptionDefault {
                "${modifier}+Shift+t" = "exec xrandr --dpi 180";
            };
        };
    };
}