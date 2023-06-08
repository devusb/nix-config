{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    package = with pkgs; steam.override { extraPkgs = pkgs: [ attr ]; };
  };
  programs.gamemode.enable = true;
  environment.systemPackages = with pkgs; [ steamtinkerlaunch xdotool xorg.xwininfo ];
}
