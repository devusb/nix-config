{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  withPlasma = osConfig.services.desktopManager.plasma6.enable;
in
{
  imports = lib.optionals withPlasma [
    ./plasma.nix
  ];

  home.packages =
    with pkgs;
    [
      xclip
      wl-clipboard
      virt-manager
      calibre
      remmina
      jellyfin-media-player
    ]
    ++ lib.optionals (!stdenv.isAarch64) [
      zoom-us
    ]
    ++ lib.optionals withPlasma [
      haruna
    ];

  programs.firefox = {
    enable = true;
    policies = {
      disablePocket = true;
    };
    nativeMessagingHosts = lib.optionals withPlasma [
      pkgs.kdePackages.plasma-browser-integration
    ];
  };

  programs.keychain.enable = lib.mkForce withPlasma;

  xdg.configFile = {
    "autostart/1password.desktop".text = ''
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
    "plex-mpv-shim/mpv.conf".text = ''
      fs=yes
      hwdec=vaapi
    '';
  };

}
