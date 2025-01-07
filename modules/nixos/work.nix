{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.services.work;
  inherit (lib)
    mkEnableOption
    mkOption
    mdDoc
    mkIf
    types
    ;
in
{
  imports = [
    inputs.p81.nixosModules.perimeter81
    inputs.sentinelone.nixosModules.sentinelone
    inputs.sops-nix.nixosModules.sops
  ];

  options = {
    services.work = {
      enable = mkEnableOption (mdDoc "Services and packages for work");
      sentinelOneSerial = mkOption {
        description = "Machine serial number for SentinelOne";
        type = types.str;
      };
      sentinelOneEmail = mkOption {
        description = "Email address for SentinelOne";
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    services.perimeter81.enable = true;

    sops = {
      secrets.s1_mgmt_token = {
        sopsFile = ../../secrets/sentinelone.yaml;
      };
    };
    services.sentinelone = {
      enable = true;
      sentinelOneManagementTokenPath = config.sops.secrets.s1_mgmt_token.path;
      email = cfg.sentinelOneEmail;
      serialNumber = cfg.sentinelOneSerial;
    };
  };
}
