{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.flatpak.autoUpdate;
in
{
  options = {

    services.flatpak.autoUpdate = {
      enable = mkEnableOption (mdDoc "Auto-updating of installed Flatpaks");
      schedule = mkOption {
        description = "Update schedule";
        type = types.str;
        default = "*-*-* 02:00:00 America/Chicago";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.flatpak-autoupdate = {
      description = "updating installed Flatpaks";
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.flatpak}/bin/flatpak update -y
      '';
    };

    systemd.timers.flatpak-autoupdate = {
      description = "updating installed flatpaks";
      timerConfig = {
        OnCalendar = cfg.schedule;
        Persistent = true;
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
