{ pkgs, ... }:
{
  imports = [
    ./binds.nix
    ./dms.nix
    ./window-rules.nix
  ];

  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ "FiraCode Nerd Font Mono" ];
    sansSerif = [ "Noto Sans" ];
    serif = [ "Noto Serif" ];
    emoji = [ "Noto Color Emoji" ];
  };

  programs.ghostty.settings.window-decoration = "client";

  # electron only picks a secret store for desktops it recognises
  xdg.desktopEntries = {
    signal = {
      name = "Signal";
      comment = "Private messaging from your desktop";
      exec = "signal-desktop --password-store=gnome-libsecret %U";
      icon = "signal-desktop";
      terminal = false;
      type = "Application";
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      mimeType = [
        "x-scheme-handler/sgnl"
        "x-scheme-handler/signalcaptcha"
      ];
      settings.StartupWMClass = "signal";
    };

    "1password" = {
      name = "1Password";
      comment = "Password manager and secure wallet";
      exec = "1password --password-store=gnome-libsecret %U";
      icon = "1password";
      terminal = false;
      type = "Application";
      categories = [ "Office" ];
      mimeType = [ "x-scheme-handler/onepassword" ];
      settings.StartupWMClass = "1Password";
    };
  };

  wayland.windowManager.niri = {
    enable = true;
    portalPackage = null;
    systemd.enable = false;

    extraConfig = ''
      include optional=true "dms/outputs.kdl"
      include optional=true "dms/colors.kdl"
      include optional=true "dms/cursor.kdl"
    '';

    settings = {
      prefer-no-csd = { };
      hotkey-overlay.skip-at-startup = { };

      input = {
        keyboard.numlock = { };
        touchpad = {
          tap = { };
          natural-scroll = { };
          click-method = "clickfinger";
        };
        mouse.natural-scroll = { };
      };

      layout = {
        gaps = 8;
        default-column-width.proportion = 0.5;
        focus-ring.width = 2;
      };

    };
  };
}
