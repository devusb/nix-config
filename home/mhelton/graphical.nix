{ pkgs, ... }:
let
  brave = pkgs.brave.override { vulkanSupport = true; };
in
{

  home.packages = with pkgs; [ gnome.adwaita-icon-theme gnome.gnome-tweaks zoom-us ipmiview brave xclip cider ];
  programs.vscode.enable = true;

  dconf.settings = {
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
      primary-color = "#3465a4";
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
      favorite-apps = [ "brave-browser.desktop" "kitty.desktop" "code.desktop" "org.gnome.Nautilus.desktop" "org.gnome.Settings.desktop" ];
    };
    "org/gnome/shell/keybindings" = {
      toggle-overview = [ "<Control><Alt>Tab" ];
    };
    "org/gnome/mutter" = {
      auto-maximize = false;
    };
  };

  home.file.".config/autostart/_1password.desktop".text = ''
    [Desktop Entry]
    Name=1Password
    Exec=1password --silent
    Terminal=false
    Type=Application
    Icon=1password
    StartupWMClass=1Password
    Comment=Password manager and secure wallet
    MimeType=x-scheme-handler/onepassword;
    Categories=Office;
  '';

}
