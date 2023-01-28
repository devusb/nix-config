{ config, pkgs, lib, osConfig, ... }:
with lib;
let
  cfg = config.services.uxplay;
in
{
  options.services.uxplay = {
    enable = mkEnableOption "uxplay";
  };

  config = mkIf cfg.enable {

    systemd.user.services = {
      uxplay = {
        Unit.Description = "AirPlay Unix mirroring server";
        Service.ExecStart = "${pkgs.uxplay}/bin/uxplay -nh -n ${osConfig.networking.hostName}";
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
