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
    claude-code
    dbeaver-bin
  ];
  programs.keychain.keys = [ "id_ed25519" ];

  programs.ssh = {
    enable = true;
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

}
