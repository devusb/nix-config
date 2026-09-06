{ pkgs, ... }:
let
  # the homescreen containment imports org.kde.kdeconnect, which upstream leaves off
  # the session wrapper's qml import path
  plasma-bigscreen = pkgs.kdePackages.plasma-bigscreen.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.kdePackages.kdeconnect-kde ];
    preFixup = (old.preFixup or "") + ''
      wrapQtApp $out/bin/plasma-bigscreen-wayland
    '';
  });
in
{
  # the session script sources plasma-bigscreen-common-env by bare name
  environment.systemPackages = [ plasma-bigscreen ];

  services.displayManager = {
    sessionPackages = [ plasma-bigscreen ];
    defaultSession = "plasma-bigscreen-wayland";
  };

  # plasma6 sets this to plasma-workspace alone with mkDefault
  xdg.portal.configPackages = [
    pkgs.kdePackages.plasma-workspace
    plasma-bigscreen
  ];
}
