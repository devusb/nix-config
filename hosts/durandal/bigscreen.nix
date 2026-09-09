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

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="rc", ENV{DRV_NAME}=="cec", RUN+="${pkgs.v4l-utils}/bin/ir-keytable -s %k -k 0x0000=KEY_ENTER -k 0x0001=KEY_UP -k 0x0002=KEY_DOWN -k 0x0003=KEY_LEFT -k 0x0004=KEY_RIGHT -k 0x000d=KEY_BACK -k 0x0044=KEY_PLAYPAUSE -k 0x0046=KEY_COMPOSE"
  '';
}
