# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:
let
  steam-extest = pkgs.steam.override {
    extraEnv = {
      LD_PRELOAD = "${pkgs.pkgsi686Linux.extest}/lib/libextest.so:${if config.chaotic.mesa-git.enable then config.environment.sessionVariables.LD_PRELOAD else ""}";
    };
  };
in
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
      ../common/docker.nix
      inputs.chaotic.nixosModules.default
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.deckbd.enable = true;

  networking.hostName = "bob"; # Define your hostname.
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
    desktopSession = "plasmawayland";

  };
  jovian.devices.steamdeck = {
    enable = true;
    enableGyroDsuService = true;
  };
  jovian.decky-loader.enable = true;
  programs.steam.package = steam-extest;

  sops = {
    secrets.registration_key = {
      sopsFile = ../../secrets/playstation.yaml;
      owner = config.users.users.mhelton.name;
    };
  };

  programs.chiaki4deck = {
    enable = true;
    consoleAddress = "192.168.11.7";
    registrationKeyPath = config.sops.secrets.registration_key.path;
    consoleNickname = "PS5-875";
  };

  services.joycond.enable = true;

  services.flatpak = {
    enable = true;
  };

  system.stateVersion = "23.05"; # Did you read the comment?

  specialisation = {
    mesa-git.configuration = {
      chaotic.mesa-git = {
        enable = true;
        fallbackSpecialisation = false;
      };
    };
  };

}

