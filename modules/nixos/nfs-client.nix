{ config, lib, ... }:

with lib;

{
  options = {
    services.nfs-client = {
      enable = mkEnableOption (mdDoc "NFS shares");
    };
  };

  config = mkIf config.services.nfs-client.enable {
    fileSystems = {
      "/mnt/r2d2/media" = {
        device = "192.168.20.109:/r2d2_0/media";
        fsType = "nfs";
        options = [ "x-systemd.automount" "noauto" ];
      };
      "/mnt/r2d2/backup" = {
        device = "192.168.20.109:/r2d2_0/backup";
        fsType = "nfs";
        options = [ "x-systemd.automount" "noauto" ];
      };
      "/mnt/r2d2/homes" = {
        device = "192.168.20.109:/r2d2_0/homes";
        fsType = "nfs";
        options = [ "x-systemd.automount" "noauto" ];
      };
    };
  };
}
