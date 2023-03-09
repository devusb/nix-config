{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.shairport-sync;
in
{
  options = {
    services.shairport-sync = {
      enable = mkEnableOption (mdDoc "shairport-sync");
      package = mkPackageOption pkgs "shairport-sync" { };
    };
  };
  config = mkIf config.services.shairport-sync.enable {
    systemd.user.services.shairport-sync =
      {
        description = "shairport-sync";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "wireplumber.service" ];
        after = [ "wireplumber.service" ];
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/shairport-sync -o pa -a ${config.networking.hostName}";
        };
      };
  };
}
