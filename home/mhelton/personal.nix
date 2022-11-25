{ pkgs, ... }: {
  programs.git = {
    userName = "Morgan Helton";
    userEmail = "mhelton@gmail.com";
  };

  home.sessionVariables = {
    VAULT_ADDR = "https://vault.springhare-egret.ts.net";
  };

  home.packages = with pkgs; [
    colmena
    fluxcd
  ];

  programs.keychain.keys = [ "id_rsa" ];

  programs.starship.settings = {
    aws.disabled = true;
  };

  programs.gh.enable = true;

}
