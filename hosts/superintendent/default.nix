{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ../common/darwin.nix
  ];
  
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
