{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.programs.iterm2;

  toPlist = lib.generators.toPlist { };

in
{
  options.programs.iterm2 = {
    enable = mkEnableOption "iterm2";

    package = mkOption {
      type = types.package;
      default = pkgs.iterm2;
      defaultText = literalExpression "pkgs.iterm2";
      description = "The package to use for iterm2.";
    };

    profile = mkOption {
      type = with types;
        let
          prim = oneOf [ bool int str float ];
          primOrPrimAttrs = either prim (attrsOf prim);
          entry = either prim (listOf primOrPrimAttrs);
          entryOrAttrsOf = t: either entry (attrsOf t);
          entries = entryOrAttrsOf (entryOrAttrsOf entry);
        in
        attrsOf entries // { description = "iterm2 configuration"; };
      default = { };
      example = literalExpression ''
        {
          Name = "home-manager profile";
          Guid = "C732FDA8-7A4A-4998-A019-C9FDDAB1C0BC";
          "Unlimited Scrollback" = true;
        }
      '';
      description = "iTerm2 profile to be linked into the DynamicProfiles directory.";
    };

    preferences = mkOption {
      type = with types;
        let
          prim = oneOf [ bool int str float ];
          primOrPrimAttrs = either prim (attrsOf prim);
          entry = either prim (listOf primOrPrimAttrs);
          entryOrAttrsOf = t: either entry (attrsOf t);
          entries = entryOrAttrsOf (entryOrAttrsOf entry);
        in
        attrsOf entries // { description = "iterm2 configuration"; };
      default = { };
      example = literalExpression ''
      {
        PromptOnQuit = false;
        SoundForEsc = false;
      }
      '';
      description = ''
        iTerm2 preferences to be linked into ~/.config/iterm2.
        To be used, will need to set "Load preferences from a custom folder or URL" in General->Preferences to this folder.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Always add the configured `iterm2` package.
    home.packages = [ cfg.package ];

    # If a profile is specified, add it to the DynamicProfiles folder
    xdg.configFile."iterm2/AppSupport/DynamicProfiles/home-manager.plist" = mkIf (cfg.profile != { }) {
      text = toPlist { Profiles = [ cfg.profile ]; };
    };

    # If preferences are specified, add them to .config/iterm2
    xdg.configFile."iterm2/com.googlecode.iterm2.plist" = mkIf (cfg.preferences != { }) {
      text = toPlist cfg.preferences;
    };
  };
}
