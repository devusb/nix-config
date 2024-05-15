# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.nixos-hardware.nixosModules.framework-13-7040-amd
      inputs.disko.nixosModules.disko
      (import ./disko-config.nix { disks = [ "/dev/nvme0n1" ]; })
      inputs.sops-nix.nixosModules.sops
      ../common/users/mhelton
      ../common/nixos.nix
      ../common/steam.nix
      ../common/_1password.nix
      ../common/docker.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.blacklistedKernelModules = [ "hid_sensor_hub" ];
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=1
  '';
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.automatic-timezoned.enable = false;
  time.timeZone = "US/Central";

  networking.hostName = "r2d2"; # Define your hostname.
  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };

  hardware.bluetooth.enable = true;
  hardware.sensor.iio.enable = false;
  hardware.enableAllFirmware = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = [ "modesetting" ];
  };

  hardware.opengl.enable = true;

  # Plasma
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  security.pam.services.login.fprintAuth = false;

  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    kde-rounded-corners
  ];
  programs.kdeconnect.enable = true;

  environment.variables = {
    VDPAU_DRIVER = "radeonsi";
  };

  system.stateVersion = "24.05"; # Did you read the comment?

}

