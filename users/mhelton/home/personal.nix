{ pkgs, ... }: {
  programs.git = {
    userName = "Morgan Helton";
    userEmail = "mhelton@gmail.com";
  };

  home.sessionVariables = {
    VAULT_ADDR = "https://vault.gaia.devusb.us";
  };

  home.packages = with pkgs; [
    gh
  ];

  programs.keychain.keys = [ "id_rsa" ];

  programs.starship.settings = {
    aws.disabled = true;
  };

}
