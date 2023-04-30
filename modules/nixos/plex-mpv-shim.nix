{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.plex-mpv-shim;

in

{
  options = {

    services.plex-mpv-shim = {
      enable = mkEnableOption (mdDoc "plex-mpv-shim");
    };

  };

  config = mkIf config.services.plex-mpv-shim.enable {

    environment.systemPackages = with pkgs; [ plex-mpv-shim ];

    systemd.user.services.plex-mpv-shim =
      {
        description = "plex-mpv-shim";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.plex-mpv-shim}/bin/plex-mpv-shim";
        };
      };

  };
}
