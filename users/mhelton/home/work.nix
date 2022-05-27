{ pkgs, ...}: {
  programs.git = {
    userName  = "Morgan Helton";
    userEmail = "morgan@imubit.com";
  };

  home.sessionVariables = {
    VAULT_ADDR = "https://vault.admin.imubit.in";
  };

  home.packages = with pkgs; [ terraform google-cloud-sdk postgresql pgcli mpack dive crane helm2 aws-sso-cli ];

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
