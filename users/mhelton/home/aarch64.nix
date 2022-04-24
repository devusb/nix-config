{ pkgs, lib, config, ...}: {
    home.packages = with pkgs; [];
    programs.firefox.enable = true;

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