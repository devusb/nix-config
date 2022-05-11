{ pkgs, inputs, ... }: {
  imports = [
    ../common
    ../common/wsl.nix
  ];
  system.stateVersion = "22.05";
}
