{ ... }: {
  imports = [
    ../../common/darwin.nix
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  networking.hostName = "superintendent";

  homebrew.casks = [
    "1password"
    "tailscale"
    "moonlight"
    "grandperspective"
  ];

}
