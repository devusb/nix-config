{
  config,
  pkgs,
  ...
}:
{
  programs.git = {
    settings = {
      user = {
        name = "Morgan Helton";
        email = "morgan@flox.dev";
      };
    };
    signing = {
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      signByDefault = true;
      format = "ssh";
    };
  };

  home.packages = with pkgs; [
    postgresql
    dive
    crane
    aws-sso-cli
    pgdiff
    pg_activity
    diffr
    skopeo
    dbeaver-bin
    llm-agents.codex
    mcp-grafana
    (brev-cli.overrideAttrs {
      patches = [
        (fetchpatch {
          url = "https://github.com/devusb/brev-cli/commit/057012b9.patch";
          hash = "sha256-kwL1QNce8/IuIXPbLIONyLRqJne1L9YEqqsl4bLHD00=";
        })
      ];
    })
  ];
  programs.keychain.keys = [ "id_ed25519" ];

  programs.ssh = {
    enable = true;
    includes = [
      ''"${config.home.homeDirectory}/.brev/ssh_config"''
    ];
    matchBlocks = {
      "*" = {
        user = "morgan";
      };
      "github.com" = {
        user = "git";
      };
    };
  };

  programs.starship.settings = {
    aws.disabled = false;
  };

  programs.pgcli = {
    enable = true;
    settings = {
      main.use_local_timezone = false;
    };
  };

  programs.agent-deck = {
    enableMcpIntegration = true;
    settings.groups =
      let
        mkGroup = repo: {
          create = true;
          default_path = "${config.home.homeDirectory}/code/${repo}";
        };
      in
      {
        floxhub = mkGroup "floxhub";
        forge = mkGroup "forge";
        deltaops = mkGroup "deltaops";
        metrics = mkGroup "metrics";
        flox-installers = mkGroup "flox-installers";
        flox = mkGroup "flox";
      };
  };

  programs.mcp = {
    enable = true;
    servers = {
      fellow = {
        description = "Fellow MCP Server";
        url = "https://fellow.app/mcp";
      };
      grafana = {
        description = "Grafana MCP Server";
        url = "https://mcp.grafana.com/mcp";
        headers = {
          "X-Grafana-URL" = "https://floxdev.grafana.net";
        };
      };
      linear = {
        description = "Linear MCP Server";
        url = "https://mcp.linear.app/mcp";
      };
      notion = {
        description = "Notion MCP Server";
        url = "https://mcp.notion.com/mcp";
      };
      sentry = {
        description = "Sentry MCP Server";
        url = "https://mcp.sentry.dev/mcp";
      };
    };
  };

}
