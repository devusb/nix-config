{ pkgs, lib, config, ...}: {
  imports = [
    ./kitty.nix
  ];
  home.packages = with pkgs; [];
  programs.firefox.enable = true;
  programs.kitty.font.size = 20;

  xsession.windowManager.i3 = {
      enable = true;
      config = {
          modifier = "Mod1";
          terminal = "kitty";
          keybindings = let modifier = config.xsession.windowManager.i3.config.modifier; in lib.mkOptionDefault {
              "${modifier}+Shift+t" = "exec xrandr --dpi 180";
          };
      };
  };
}