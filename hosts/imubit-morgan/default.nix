{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  nixos-wsl = import ./nixos-wsl;
in
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    ../common
    nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "mhelton";
    startMenuLaunchers = true;
    docker-native.enable = true;
    # Enable integration with Docker Desktop (needs to be installed)
    # docker.enable = true;
  };
}
