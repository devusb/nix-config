{ pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common
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
  
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # add GUI

  services.xserver = {
    enable = true;
    layout = "us";
    dpi = 180;

    displayManager = {
      gdm.enable = true;
      autoLogin = {
        user = "mhelton";
        enable = true;
      };
    };
    windowManager.i3.enable = true;

  };

}