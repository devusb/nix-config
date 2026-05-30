{ ... }:
{
  imports = [
    ../common/darwin.nix
  ];

  system.stateVersion = 7;

  networking.hostName = "mhelton-mbp14";

  homebrew.casks = [
    "dbeaver-community"
    "microsoft-remote-desktop"
    "slack"
  ];

  system.defaults.dock.persistent-apps = [
    "/Applications/Slack.app"
  ];

}
