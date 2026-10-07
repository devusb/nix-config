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

  herdr = lib.getExe cfg.package;
  jq = lib.getExe pkgs.jq;

  pluginManifests = builtins.toJSON (
    lib.mapAttrsToList (_: plugin: "${plugin.package}/herdr-plugin.toml") cfg.plugins
  );
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

    plugins = mkOption {
      type = types.attrsOf (
        types.submodule {
          options.package = mkOption {
            type = types.either types.package types.path;
            description = "Plugin directory containing a {file}`herdr-plugin.toml` manifest.";
          };
        }
      );
      default = { };
      description = ''
        Plugins registered with herdr on activation. Plugins linked from the nix
        store that are no longer listed are unlinked when a herdr server is running.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.activation.herdrPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        registered=$(${herdr} plugin list --json 2>/dev/null) || registered='{}'

        ${jq} -r --arg store "${builtins.storeDir}/" --argjson desired ${lib.escapeShellArg pluginManifests} '
          .result.plugins[]?
          | select((.manifest_path // "") | startswith($store))
          | select(.manifest_path as $p | $desired | index($p) | not)
          | .plugin_id
        ' <<<"$registered" | while read -r id; do
          run ${herdr} plugin unlink "$id" >/dev/null 2>&1 || true
        done

        ${jq} -r --argjson desired ${lib.escapeShellArg pluginManifests} '
          ($desired - [.result.plugins[]?.manifest_path])[]
        ' <<<"$registered" | while read -r manifest; do
          run ${herdr} plugin link "$manifest" >/dev/null
        done
      '';
    }

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
