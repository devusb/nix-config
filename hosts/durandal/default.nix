{ inputs, config, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.disko.nixosModules.disko
      (import ./disko-config.nix { disks = [ "/dev/sda" ]; })
      ../common/users/mhelton
      ../common/nixos.nix
      ../common/steam.nix
      ../common/_1password.nix
    ];

  boot.loader.grub.devices = [ "/dev/sda" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.memtest86.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
    }
  ];

  networking.hostName = "durandal"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.localCommands = ''
    ip route add throw 192.168.0.0/16 table 52
  '';
  hardware.bluetooth = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    nvtop
  ];

  system.autoUpgrade = {
    enable = true;
    flake = "github:devusb/nix-config";
    allowReboot = true;
    rebootWindow = {
      upper = "02:30";
      lower = "04:00";
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
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.opengl.enable = true;

  # Plasma
  services.xserver.displayManager.sddm = {
    enable = true;
  };
  services.xserver.displayManager = {
    defaultSession = "plasma";
    autoLogin = {
      enable = true;
      user = "mhelton";
    };
  };
  services.xserver.desktopManager.plasma5 = {
    enable = true;
    bigscreen.enable = true;
    useQtScaling = true;
  };
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    plasma-remotecontrollers
  ];
  programs.kdeconnect.enable = true;
  system.stateVersion = "22.11";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

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

}

