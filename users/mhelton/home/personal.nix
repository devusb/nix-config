{ pkgs, ...}: {
  programs.git = {
    userName  = "Morgan Helton";
    userEmail = "mhelton@gmail.com";
  };

  home.sessionVariables = {
    VAULT_ADDR = "https://vault.gaia.devusb.us";
  };
}