{ lib, pkgs, config, modulesPath, inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "mhelton";
    startMenuLaunchers = true;
    docker-native.enable = true;
  };
}
