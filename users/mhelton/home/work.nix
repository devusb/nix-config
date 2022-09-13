{ pkgs, ... }: {
  programs.git = {
    userName = "Morgan Helton";
    userEmail = "morgan@imubit.com";
  };

  home.sessionVariables = {
    VAULT_ADDR = "https://vault.admin.imubit.in";
  };

  programs.zsh.shellAliases = {
    vssh = "vault ssh -mode=ca -role=infra-admin -private-key-path=~/.ssh/id_ed25519 -public-key-path=~/.ssh/id_ed25519.pub";
  };

  home.packages = with pkgs; [
    mpack
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin-darwin-arm ])
    postgresql
    pgcli
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
