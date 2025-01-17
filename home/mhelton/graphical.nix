{ pkgs, ... }:
{
  imports = [
    ./plasma.nix
  ];

  home.packages =
    with pkgs;
    [
      xclip
      wl-clipboard
      obsidian
      jellyfin-media-player
      delfin
      haruna
      virt-manager
      calibre
    ]
    ++ lib.optionals (!stdenv.isAarch64) [
      zoom-us
    ];

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [
      pkgs.kdePackages.plasma-browser-integration
    ];
  };

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
