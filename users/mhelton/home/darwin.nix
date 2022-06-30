{ pkgs, config, system, lib, ... }: {
  home.packages = with pkgs; [
  ];

  programs.iterm2 = {
    enable = true;
    profiles = import ./extra/iterm2_profile.nix;
    preferences = import ./extra/iterm2.nix;
  };

  home.sessionVariables = {
    DOTFILES = "$HOME/code/nix-config/";
  };
}
