{ pkgs, ...}: {
    home.packages = with pkgs; [lutris];

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = ["google-chrome.desktop" "kitty.desktop" "steam.desktop" "net.lutris.Lutris.desktop" "code.desktop" "org.gnome.Nautilus.desktop" "org.gnome.Settings.desktop"];
    };
  };
}