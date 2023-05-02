{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.plex-mpv-shim;
in
{
  options = {
    services.plex-mpv-shim = {
      enable = mkEnableOption (mdDoc "plex-mpv-shim");
      package = mkPackageOption pkgs "plex-mpv-shim" { };
    };
  };

  config =
  mkIf config.services.plex-mpv-shim.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.user.services.plex-mpv-shim =
      {
        description = "plex-mpv-shim";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/plex-mpv-shim";
        };
      };
  };
}
