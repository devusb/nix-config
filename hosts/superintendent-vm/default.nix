{ pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/aarch64-vm.nix
  ];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "21.11"; 

  # enable syslog
  services.syslogd.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = true;
    permitRootLogin = "yes";
  };

  networking.useDHCP = false;
  networking.interfaces.enp0s10.useDHCP = true;
  networking.firewall.enable = false;
}
