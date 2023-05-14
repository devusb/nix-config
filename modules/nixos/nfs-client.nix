{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nfs-client;
in

{
  options = {
    services.nfs-client = {
      enable = mkEnableOption (mdDoc "NFS shares");
    };
  };

  config = mkIf config.services.nfs-client.enable {
    fileSystems = {
      "/mnt/r2d2/media" = {
        device = "192.168.20.131:/mnt/media";
        fsType = "nfs";
        options = [ "x-systemd.automount" "noauto" ];
      };
      "/mnt/r2d2/backup" = {
        device = "192.168.20.131:/mnt/backup";
        fsType = "nfs";
        options = [ "x-systemd.automount" "noauto" ];
      };
      "/mnt/r2d2/homes" = {
        device = "192.168.20.131:/mnt/homes";
        fsType = "nfs";
        options = [ "x-systemd.automount" "noauto" ];
      };
    };
  };
}
