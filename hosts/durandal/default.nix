{ inputs, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.disko.nixosModules.disko
      ./disko-config.nix
      ../common/users/mhelton
      ../common/nixos.nix
      ../common/steam.nix
      ../common/_1password.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "durandal"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.localCommands = ''
    ip route add throw 192.168.0.0/16 table 52
  '';
  hardware.bluetooth = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    nvtopPackages.amd
  ];

  system.autoUpgrade = {
    enable = true;
    flake = "github:devusb/nix-config";
    dates = "Sat *-*-* 02:30:00";
    allowReboot = true;
    rebootWindow = {
      upper = "04:45";
      lower = "02:30";
    };
  };

  # monitoring
  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [ "systemd" "ethtool" "netstat" ];
    };
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.opengl.enable = true;

  # Plasma
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.displayManager = {
    defaultSession = "plasma";
    autoLogin = {
      enable = true;
      user = "mhelton";
    };
  };
  services.desktopManager.plasma6.enable = true;

  programs.kdeconnect.enable = true;
  system.stateVersion = "22.11";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.firewall.enable = false;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.flatpak = {
    enable = true;
    autoUpdate.enable = true;
  };
  services.plex-mpv-shim.enable = true;
  services.nfs-client.enable = true;

  networking.interfaces.enp31s0.wakeOnLan.enable = true;
  services.sleep-on-lan.enable = true;

}

