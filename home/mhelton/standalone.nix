{ pkgs, ... }: {

  home.packages = with pkgs; [
    nix
  ];

  nix.package = pkgs.nix;
  nix.settings = {
    extra-experimental-features = "nix-command flakes";
  };

  programs.keychain.enable = pkgs.lib.mkForce false;

  home.sessionVariables = {
    DOTFILES = "$HOME/code/nix-config/";
  };
}
