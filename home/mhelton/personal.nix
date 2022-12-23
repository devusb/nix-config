{ pkgs, ... }: {
  programs.git = {
    userName = "Morgan Helton";
    userEmail = "mhelton@gmail.com";
  };

  home.sessionVariables = {
    VAULT_ADDR = "https://vault.springhare-egret.ts.net";
    NOMAD_ADDR = "https://nomad.gaia.devusb.us";
  };

  home.packages = with pkgs; [
    colmena
    nomad
    flyctl
  ];

  programs.keychain.keys = [ "id_rsa" ];

  programs.starship.settings = {
    aws.disabled = true;
  };

  programs.gh.enable = true;

}
