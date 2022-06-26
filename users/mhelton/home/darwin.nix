{ pkgs, config, system, lib, ... }: {
  home.packages = with pkgs; [
  ];

  programs.iterm2 = {
    enable = true;
    profile = import ./extra/iterm2_profile.nix;
    preferences = import ./extra/iterm2.nix;
  };
}
