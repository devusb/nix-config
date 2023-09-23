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
      (import ./disko-config.nix { disks = [ "/dev/nvme0n1" ]; })
      inputs.jovian.nixosModules.jovian
      inputs.sops-nix.nixosModules.sops
      ../common/users/mhelton
      ../common/nixos.nix
      ../common/steam.nix
      ../common/_1password.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bb"; # Define your hostname.
  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };
  hardware.pulseaudio.enable = lib.mkForce false;
  hardware.bluetooth.enable = true;

  services.openssh.enable = true;

  fileSystems."/mnt/sdcard" = {
    device = "/dev/mmcblk0p1";
    options = [
      "rw"
      "user"
      "defaults"
      "exec"
      "nofail"
      "x-systemd.automount"
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.desktopManager.plasma5.enable = true;
  programs.kdeconnect.enable = true;

  environment.variables = {
    VDPAU_DRIVER = "radeonsi";
  };

  environment.systemPackages = with pkgs; [
    partition-manager
    libsForQt5.kpmcore
  ];

  jovian.steam = {
    enable = true;
    autoStart = true;
    user = "mhelton";
    desktopSession = lib.mkDefault "plasma";
  };
  jovian.devices.steamdeck.enable = true;
  programs.steam.package = pkgs.steam.override {
    extraArgs = "-steamdeck";
  };

  sops = {
    secrets.registration_key = {
      sopsFile = ../../secrets/playstation.yaml;
      owner = config.users.users.mhelton.name;
    };
  };

  programs.chiaki4deck = {
    enable = true;
    consoleAddress = "192.168.10.58";
    registrationKeyPath = config.sops.secrets.registration_key.path;
    consoleNickname = "PS5-875";
  };

  system.stateVersion = "23.05"; # Did you read the comment?

  specialisation = {
    plasma-wayland.configuration = {
      jovian.steam.desktopSession = "plasmawayland";
    };
  };

}

