{ lib, ... }:
{
  programs.mangohud.enable = lib.mkForce false;

  xdg.configFile."autostart/Steam.desktop".text = ''
    [Desktop Entry]
    Exec=steam -silent
    GenericName[en_US]=
    GenericName=
    Icon=Steam
    MimeType=
    Name[en_US]=Steam
    Name=Steam
    Path=
    StartupNotify=true
    StartupWMClass=Steam
    Terminal=false
    TerminalOptions=
    Type=Application
    X-KDE-SubstituteUID=false
    X-KDE-Username=
  '';
}
