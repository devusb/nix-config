{ pkgs, ... }:
let
  plasma-bigscreen = pkgs.kdePackages.plasma-bigscreen.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.kdePackages.kdeconnect-kde ];
    preFixup = (old.preFixup or "") + ''
      wrapQtApp $out/bin/plasma-bigscreen-wayland
    '';
  });

  user = "mhelton";
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
    SUBSYSTEM=="cec", KERNEL=="cec0", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="bigscreen-cec-reattach.service"
  '';

  systemd.services.bigscreen-cec-reattach = {
    description = "Reattach the Plasma Bigscreen input handler to the CEC device";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.lib.getExe' pkgs.systemd "machinectl"} shell ${user}@ ${pkgs.lib.getExe' pkgs.systemd "systemctl"} --user restart bigscreen-inputhandler";
    };
  };

  systemd.services.bigscreen-cec-resume = {
    description = "Restart the Plasma Bigscreen input handler after resume";
    unitConfig = {
      DefaultDependencies = "no";
      StopWhenUnneeded = "yes";
      Before = "sleep.target";
    };
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";

      ExecStop = "${pkgs.lib.getExe' pkgs.systemd "machinectl"} shell ${user}@ ${pkgs.lib.getExe' pkgs.systemd "systemctl"} --user restart bigscreen-inputhandler";
    };
    wantedBy = [ "sleep.target" ];
  };
}
