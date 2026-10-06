{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    mkMerge
    types
    ;
  cfg = config.programs.herdr;
in
{
  options.programs.herdr = {
    claudeCodeHooks.enable = mkEnableOption "the herdr Claude Code session hook";

    server = {
      enable = mkEnableOption "a systemd user service running the herdr server";

      tasksMax = mkOption {
        type = types.either types.ints.positive (types.enum [ "infinity" ]);
        default = "infinity";
        description = ''
          `TasksMax` for the herdr server service. The server exits and all panes
          are lost when this limit is reached. The user slice limit still applies.
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.claudeCodeHooks.enable {
      programs.claude-code.settings.hooks.SessionStart = [
        {
          matcher = "^(startup|resume|clear|compact|fork)$";
          hooks = [
            {
              type = "command";
              command = "PATH=${pkgs.python3}/bin:$PATH ${pkgs.runtimeShell} ${cfg.package.src}/src/integration/assets/claude/herdr-agent-state.sh session";
              timeout = 10;
            }
          ];
        }
      ];
    })

    (mkIf cfg.server.enable {
      systemd.user.services.herdr = {
        Unit = {
          Description = "herdr server";
          X-SwitchMethod = "keep-old";
        };
        Service = {
          ExecStart = "${lib.getExe cfg.package} server";
          Restart = "on-failure";
          TasksMax = cfg.server.tasksMax;
        };
        Install.WantedBy = [ "default.target" ];
      };
    })
  ]);
}
