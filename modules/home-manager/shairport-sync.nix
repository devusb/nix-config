{ config, pkgs, lib, osConfig, ... }:
with lib;
let
  cfg = config.services.shairport-sync;
in
{
  options.services.shairport-sync = {
    enable = mkEnableOption "shairport-sync";

    package = mkPackageOption pkgs "shairport-sync" { };
  };

  config = mkIf cfg.enable {

    systemd.user.services = {
      shairport-sync = {
        Unit.Description = "Airtunes server and emulator with multi-room capabilities";
        Service.ExecStart = "${cfg.package}/bin/shairport-sync -o pa -a ${osConfig.networking.hostName}";
        Install.WantedBy = [ "default.target" ];
        Unit.After = [ "wireplumber.service" ];
        Unit.Wants = [ "wireplumber.service" ];
        Service.Restart = "on-failure";
      };
    };
  };
}
