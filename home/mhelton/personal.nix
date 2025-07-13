{ config, pkgs, ... }:
{
  programs.git = {
    userName = "Morgan Helton";
    userEmail = "mhelton@gmail.com";
    signing = {
      key = "${config.home.homeDirectory}/.ssh/id_rsa.pub";
      signByDefault = true;
      format = "ssh";
    };
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
      "ssh-ng://mhelton@chopper x86_64-linux,i686-linux - 6 - big-parallel,nixos-test,benchmark,kvm - -"
    ];
  };

  programs.keychain.keys = [ "id_rsa" ];

  programs.starship.settings = {
    aws.disabled = true;
  };

}
