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
    optional
    types
    ;
  cfg = config.services.collie;
  tomlFormat = pkgs.formats.toml { };

  configFile = tomlFormat.generate "collie-config.toml" cfg.settings;

  herdrService = optional config.programs.herdr.server.enable "herdr.service";
in
{
  options.services.collie = {
    enable = mkEnableOption "a systemd user service running Collie";

    package = mkOption {
      type = types.package;
      description = "Collie package providing the `collie` CLI.";
    };

    settings = mkOption {
      inherit (tomlFormat) type;
      default = { };
      example = {
        network.public_hosts = [ "host.tailnet.ts.net" ];
        access.trusted_user = "you@example.com";
      };
      description = ''
        Configuration written to {file}`~/.collie/config.toml`. Run
        `collie config init --print` for every setting. Secrets such as
        `push.vapid_private` belong in {file}`~/.config/collie/.env`, which
        overrides this file.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file.".collie/config.toml".source = configFile;

    systemd.user.services.collie = {
      Unit = {
        Description = "Collie";
        After = herdrService;
        Wants = herdrService;
        StartLimitIntervalSec = 0;
        X-Restart-Triggers = [ configFile ];
      };
      Service = {
        ExecStart = "${lib.getExe cfg.package} _exec-bridge";
        Restart = "on-failure";
        RestartSec = 5;
        NoNewPrivileges = true;
        PrivateTmp = true;
        EnvironmentFile = "-%h/.config/collie/.env";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
