{ pkgs, ... }:
{

  home.packages = with pkgs; [
    gnome.adwaita-icon-theme
    gnome.gnome-tweaks
    zoom-us
    ipmiview
    xclip
    wl-clipboard
    cider
    obsidian
    jellyfin-media-player
    haruna
    virt-manager
  ];

  programs.firefox = {
    enable = true;
  };

  xdg.configFile."autostart/1password.desktop".text = ''
    [Desktop Entry]
    Categories=Office;
    Comment[en_US]=Password manager and secure wallet
    Comment=Password manager and secure wallet
    Exec=1password %U --silent
    GenericName[en_US]=
    GenericName=
    Icon=1password
    MimeType=
    Name[en_US]=1Password
    Name=1Password
    Path=
    StartupNotify=true
    StartupWMClass=1Password
    Terminal=false
    TerminalOptions=
    Type=Application
    X-KDE-SubstituteUID=false
    X-KDE-Username=
  '';

}
