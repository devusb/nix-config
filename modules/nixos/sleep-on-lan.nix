{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sleep-on-lan;
in

{
  options = {
    services.sleep-on-lan = {
      enable = mkEnableOption (mdDoc "sleep-on-lan");

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to automatically open ports in the firewall.
        '';
      };
    };
  };

  config = mkIf config.services.sleep-on-lan.enable {

    networking.firewall = mkIf cfg.openFirewall {
      allowedUDPPortRanges = [ 9 ];
    };

    systemd.services.sleep-on-lan =
      {
        description = "sleep-on-lan";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.sleep-on-lan}/bin/sleep-on-lan";
        };
      };

  };
}
