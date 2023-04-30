{ pkgs, ... }: {
  dconf.settings = {
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-l.webp";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-d.webp";
      primary-color = "#3071AE";
      secondary-color = "#000000";
    };
    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      lock-enabled = false;
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
      primary-color = "#3465a4";
      secondary-color = "#000000";
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
    };
    "org/gnome/shell" = {
      favorite-apps = [ "brave-browser.desktop" "kitty.desktop" "org.gnome.Nautilus.desktop" "org.gnome.Settings.desktop" ];
    };
    "org/gnome/shell/keybindings" = {
      toggle-overview = [ "<Control><Alt>Tab" ];
    };
    "org/gnome/mutter" = {
      auto-maximize = false;
    };
  };

  home.packages = with pkgs; [ gnome.adwaita-icon-theme gnome.gnome-tweaks ];

}
