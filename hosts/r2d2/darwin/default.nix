{ ... }: {
  imports = [
    ../../common/darwin.nix
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  networking.hostName = "r2d2";

  homebrew.casks = [
    "1password"
    "tailscale"
    "moonlight"
    "grandperspective"
  ];

}
