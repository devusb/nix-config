{ pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/steam.nix
  ];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "21.11"; 

  # enable syslog
  services.syslogd.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = true;
    permitRootLogin = "no";
  };

  networking.useDHCP = false;
  networking.interfaces.enp31s0.useDHCP = true;
  networking.firewall.enable = false;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # add GUI and nvidia drivers
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  
}