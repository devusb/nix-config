{ pkgs, inputs, ... }: {
  imports = [
    ../common
    ../common/wsl.nix
  ];
  system.stateVersion = "21.11";
}
