{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.flatpak;
in
{
  options = {
    services.flatpak = {
      autoUpdate = mkOption {
        type = types.bool;
        description = "Enable Flatpak auto-updating";
      };
    };
  };

  config =
    mkIf cfg.autoUpdate {
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
          OnCalendar = "*-*-* 02:00:00 America/Chicago";
          Persistent = true;
        };
        wantedBy = [ "timers.target" ];
      };
    };
}
