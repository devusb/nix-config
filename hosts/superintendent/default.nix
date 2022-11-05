{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ../common/darwin.nix
    ../common/nix.nix
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  networking.hostName = "superintendent";

  users.users.mhelton.home = "/Users/mhelton";
}
