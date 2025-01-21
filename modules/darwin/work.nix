{
  config,
  lib,
  ...
}:
let
  cfg = config.services.work;
  inherit (lib)
    mkEnableOption
    mdDoc
    mkIf
    ;
in
{
  options = {
    services.work = {
      enable = mkEnableOption (mdDoc "Services and packages for work");
    };
  };

  config = mkIf cfg.enable {
  };
}
