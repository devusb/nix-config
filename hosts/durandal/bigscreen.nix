{ pkgs, ... }:
let
  plasma-bigscreen = pkgs.kdePackages.plasma-bigscreen.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.kdePackages.kdeconnect-kde ];
    preFixup = (old.preFixup or "") + ''
      wrapQtApp $out/bin/plasma-bigscreen-wayland
    '';
  });
in
{
  environment.systemPackages = [ plasma-bigscreen ];

  services.displayManager = {
    sessionPackages = [ plasma-bigscreen ];
    defaultSession = "plasma-bigscreen-wayland";
  };

  xdg.portal.configPackages = [
    pkgs.kdePackages.plasma-workspace
    plasma-bigscreen
  ];
}
