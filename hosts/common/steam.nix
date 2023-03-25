{ pkgs, ... }:
let
  steam = pkgs.steam.override {
    extraPkgs = pkgs: with pkgs; [
      steamtinkerlaunch
    ];
  };
in
{
  programs.steam = {
    enable = true;
    package = steam;
  };
  programs.gamemode.enable = true;
}
