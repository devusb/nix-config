{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.nqptp;

in

{
  options = {

    services.nqptp = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable the Not Quite PTP daemon.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to automatically open ports in the firewall.
        '';
      };

    };

  };

  config = mkIf config.services.nqptp.enable {

    services.avahi.enable = true;
    services.avahi.publish.enable = true;
    services.avahi.publish.userServices = true;

    networking.firewall = mkIf cfg.openFirewall {
      allowedUDPPortRanges = [ 319 320 ];
    };

    systemd.services.nqptp =
      {
        description = "nqptp";
        after = [ "network.target" "avahi-daemon.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.nqptp}/bin/nqptp";
        };
      };

  };
}
