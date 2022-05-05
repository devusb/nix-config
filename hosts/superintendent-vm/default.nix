{ pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/aarch64-vm.nix
    ../common/docker.nix
  ];
  system.stateVersion = "21.11";
}
