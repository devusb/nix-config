{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.programs.iterm2;

  toPlist = lib.generators.toPlist { };

in {
  #meta.maintainers = [ maintainers.devusb ];

  options.programs.iterm2 = {
    enable = mkEnableOption "iterm2";

    package = mkOption {
      type = types.package;
      default = pkgs.iterm2;
      defaultText = literalExpression "pkgs.iterm2";
      description = "The package to use for iterm2.";
    };

    settings = mkOption {
      type = with types;
        let
          prim = oneOf [ bool int str float ];
          primOrPrimAttrs = either prim (attrsOf prim);
          entry = either prim (listOf primOrPrimAttrs);
          entryOrAttrsOf = t: either entry (attrsOf t);
          entries = entryOrAttrsOf (entryOrAttrsOf entry);
        in attrsOf entries // { description = "iterm2 configuration"; };
      default = { };
      example = literalExpression ''
      '';
      description = ''
      '';
    };
  };

  config = mkIf cfg.enable {

    # Always add the configured `iterm2` package.
    #home.packages = [ cfg.package ];

    # If there are user-provided settings, generate the config file.
    xdg.configFile."iterm2/AppSupport/DynamicProfiles/home-manager.plist" = mkIf (cfg.settings != { }) {
      text = toPlist cfg.settings;
    };
  };
}
