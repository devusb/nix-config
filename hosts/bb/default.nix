# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.disko.nixosModules.disko
      (import ./disko-config.nix { disks = [ "/dev/mmcblk0" ]; })
      "${inputs.jovian}/modules"
      ../common/users/mhelton
      ../common/nixos.nix
      ../common/steam.nix
      ../common/_1password.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bb"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  hardware.pulseaudio.enable = lib.mkForce false;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.displayManager = {
    sddm.enable = true;
    setupCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --rotate right
    '';
  };
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma5.mobile.enable = true;

  jovian.steam.enable = true;
  jovian.devices.steamdeck.enable = true;

  system.stateVersion = "23.05"; # Did you read the comment?

  specialisation = {
    gaming.configuration = {
      services.xserver.displayManager = {
        defaultSession = "steam-wayland";
        autoLogin.user = "mhelton";
      };
    };
    mobile.configuration = {
      services.xserver.displayManager = {
        defaultSession = "plasma-mobile";
        autoLogin.user = "mhelton";
      };
    };
  };

}

