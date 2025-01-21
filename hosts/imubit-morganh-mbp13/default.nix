{ ... }:
{
  imports = [
    ../common/darwin.nix
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  networking.hostName = "imubit-morganh-mbp13";

  services.work.enable = true;

  homebrew.casks = [
    "dbeaver-community"
    "microsoft-remote-desktop"
    "bruno"
    "mongodb-compass"
  ];

  system.defaults.dock.persistent-apps = [
    "/Applications/Google\ Chrome.app"
    "/Applications/Slack.app"
  ];

}
