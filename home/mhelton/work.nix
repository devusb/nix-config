{
  config,
  pkgs,
  ...
}:
{
  programs.git = {
    userName = "Morgan Helton";
    userEmail = "morgan@flox.dev";
    signing = {
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      signByDefault = true;
      format = "ssh";
    };
  };

  home.packages = with pkgs; [
    postgresql
    pgcli
    dive
    crane
    aws-sso-cli
    pgdiff
    pg_activity
    diffr
    skopeo
  ];
  programs.keychain.keys = [ "id_ed25519" ];

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        user = "morgan";
      };
    };
  };

  programs.starship.settings = {
    kubernetes.disabled = false;
    aws.disabled = false;
  };

}
