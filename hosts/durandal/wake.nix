{ pkgs, ... }:
{
  # work around wireplumber missing HDMI output at wake from sleep
  systemd.services.restart-wireplumber =
    let
      user = "mhelton";
    in
    {
      unitConfig = {
        DefaultDependencies = "no";
        StopWhenUnneeded = "yes";
        Before = "sleep.target";
      };
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStop = "${pkgs.lib.getExe' pkgs.systemd "machinectl"} shell ${user}@ ${pkgs.lib.getExe' pkgs.systemd "systemctl"} --user restart wireplumber";
      };
      wantedBy = [ "sleep.target" ];
    };
}
