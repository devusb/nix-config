{ pkgs, ... }: {
  programs.git = {
    userName = "Morgan Helton";
    userEmail = "mhelton@gmail.com";
  };

  home.sessionVariables = {
    VAULT_ADDR = "https://vault.chopper.devusb.us";
  };

  home.packages = with pkgs; [
    colmena
    flyctl
  ];

  nix.settings = {
    builders = [
      "ssh-ng://mhelton@chopper x86_64-linux,aarch64-linux - 6 - - - -"
    ];
  };

  programs.keychain.keys = [ "id_rsa" ];

  programs.starship.settings = {
    aws.disabled = true;
  };

  programs.gh = {
    enable = true;
    settings = {
      version = 1;
      git_protocol = "ssh";
    };
  };

}
