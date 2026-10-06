{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    ;
  cfg = config.programs.herdr;
in
{
  options.programs.herdr = {
    claudeCodeHooks.enable = mkEnableOption "the herdr Claude Code session hook";
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
  ]);
}
