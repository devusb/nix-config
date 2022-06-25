{ pkgs, ...}: {
  home.packages = with pkgs; [lutris lm_sensors dolphin-emu-beta];

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [ "steam.desktop" "net.lutris.Lutris.desktop" ];
    };
  };
}