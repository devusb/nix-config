{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  withPlasma = osConfig.services.desktopManager.plasma6.enable;
  withNiri = osConfig.programs.niri.enable;
in
{
  imports = [
    ./ghostty.nix
  ]
  ++ lib.optionals withPlasma [
    ./plasma.nix
  ]
  ++ lib.optionals withNiri [
    ./niri.nix
  ];

  home.packages =
    with pkgs;
    [
      xclip
      wl-clipboard
      virt-manager
      remmina
      jellyfin-media-player
      bluebubbles
      signal-desktop
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isAarch64) [
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
    configPath = ".mozilla/firefox";
  };

  programs.keychain.enable = lib.mkForce withPlasma;

  xdg.autostart = {
    enable = true;
    entries = [
      "${
        pkgs.makeDesktopItem {
          name = "1password";
          desktopName = "1Password";
          comment = "Password manager and secure wallet";
          icon = "1password";
          exec = "1password${lib.optionalString withNiri " --password-store=gnome-libsecret"} %U --silent";
          terminal = false;
          startupNotify = true;
          startupWMClass = "1Password";
          categories = [ "Office" ];
        }
      }/share/applications/1password.desktop"
    ];
  };

  xdg.configFile = {
    "plex-mpv-shim/mpv.conf".text = ''
      fs=yes
      hwdec=vaapi
    '';
  };

}
