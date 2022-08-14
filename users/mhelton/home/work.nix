{ pkgs, ... }: {
  programs.git = {
    userName = "Morgan Helton";
    userEmail = "morgan@imubit.com";
  };

  home.sessionVariables = {
    VAULT_ADDR = "https://vault.admin.imubit.in";
  };

  home.packages = with pkgs; [
    mpack
    google-cloud-sdk
    postgresql
    stable.pgcli # pin to stable until #186513 is merged
    dive
    crane
    helm2_15_1
    helm2_13_1
    helm2_16_2
    helm2_17_0
    aws-sso-cli
    pgdiff
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
