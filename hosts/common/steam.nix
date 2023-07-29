{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    remotePlay.openFirewall = true;
  };
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
  environment.systemPackages = with pkgs; [ steamtinkerlaunch xdotool xorg.xwininfo ];
}
