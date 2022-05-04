{ pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/aarch64-vm.nix
  ];
  system.stateVersion = "21.11";
}
