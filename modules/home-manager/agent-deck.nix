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
    mkPackageOption
    literalExpression
    mkIf
    types
    ;
  settingsFormat = pkgs.formats.toml { };
  cfg = config.programs.agent-deck;

  isMcpServerEnabled =
    server:
    let
      enabled = server.enabled or null;
      disabled = (server.disabled or false) == true;
    in
    enabled != false && !disabled;

  transformMcpServer =
    name: server:
    lib.hm.mcp.transformMcpServer {
      inherit server;
      exclude = [ "enabled" ];
      extraTransforms = [
        (lib.hm.mcp.wrapEnvFilesCommand { inherit pkgs name; })
      ];
    };

  integratedMcps = lib.optionalAttrs (cfg.enableMcpIntegration && config.programs.mcp.enable) (
    lib.mapAttrs transformMcpServer (
      lib.filterAttrs (_: isMcpServerEnabled) config.programs.mcp.servers
    )
  );

  mergedMcps = integratedMcps // (cfg.settings.mcps or { });

  finalSettings = cfg.settings // lib.optionalAttrs (mergedMcps != { }) { mcps = mergedMcps; };
in
{
  options.programs.agent-deck = {
    enable = mkEnableOption "agent-deck";

    package = mkPackageOption pkgs "agent-deck" { };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      example = literalExpression ''
        {
          default_tool = "claude";
          theme = "dark";
        }
      '';
      description = "Configuration written to {file}`~/.agent-deck/config.toml`.";
    };

    claudeCodeHooks.enable = mkEnableOption "claude-code hooks for agent-deck";

    enableMcpIntegration = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to integrate the MCP servers config from
        {option}`programs.mcp.servers` into agent-deck's `mcps` table.

        Servers defined directly in {option}`programs.agent-deck.settings.mcps`
        are merged with {option}`programs.mcp.servers`, with the former taking
        precedence.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile = lib.mkIf (finalSettings != { }) {
      "agent-deck/config.toml".source = settingsFormat.generate "agent-deck-config.toml" finalSettings;
    };

    programs.claude-code.settings = mkIf cfg.claudeCodeHooks.enable {
      hooks = {
        Notification = [
          {
            matcher = "permission_prompt|elicitation_dialog";
            hooks = [
              {
                type = "command";
                command = "agent-deck hook-handler";
                async = true;
              }
            ];
          }
        ];

        PermissionRequest = [
          {
            hooks = [
              {
                type = "command";
                command = "agent-deck hook-handler";
              }
            ];
          }
        ];

        PreCompact = [
          {
            hooks = [
              {
                type = "command";
                command = "agent-deck hook-handler";
              }
            ];
          }
        ];

        SessionEnd = [
          {
            hooks = [
              {
                type = "command";
                command = "agent-deck hook-handler";
                async = true;
              }
            ];
          }
        ];

        SessionStart = [
          {
            hooks = [
              {
                type = "command";
                command = "agent-deck hook-handler";
                async = true;
              }
            ];
          }
        ];

        Stop = [
          {
            hooks = [
              {
                type = "command";
                command = "agent-deck hook-handler";
              }
            ];
          }
        ];

        UserPromptSubmit = [
          {
            hooks = [
              {
                type = "command";
                command = "agent-deck hook-handler";
                async = true;
              }
            ];
          }
        ];
      };
    };
  };
}
