{ pkgs, ...}: {
  programs.git = {
    userName  = "Morgan Helton";
    userEmail = "morgan@imubit.com";
  };

  home.sessionVariables = {
    VAULT_ADDR = "https://vault.admin.imubit.in";
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [ terraform google-cloud-sdk postgresql ];

  programs.keychain.keys = [ "id_ed25519" ];

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        user = "morgan";
      };
    };
  };
  
}
