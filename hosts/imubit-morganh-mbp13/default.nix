{ ... }:
{
  imports = [
    ../common/darwin.nix
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  networking.hostName = "imubit-morganh-mbp13";

  homebrew.casks = [
    "dbeaver-community"
    "microsoft-remote-desktop"
  ];

}
