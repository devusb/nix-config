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
    zed-editor
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

  programs.opencode = {
    enable = true;
    package = pkgs.llm-agents.opencode;
  };

}
