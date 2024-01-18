{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.sunshine;

in

{
  options = {

    services.sunshine = {
      enable = mkEnableOption (mdDoc "Sunshine");
      package = mkPackageOption pkgs "sunshine" { };
    };

  };

  config = mkIf config.services.sunshine.enable {

    environment.systemPackages = [
      cfg.package
    ];

    security.wrappers.sunshine = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+p";
      source = "${cfg.package}/bin/sunshine";
    };

    systemd.user.services.sunshine =
      {
        description = "sunshine";
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${config.security.wrapperDir}/sunshine";
          Restart = "always";
        };
      };

  };
}
