{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
    inputs.disko.nixosModules.disko
    inputs.lanzaboote.nixosModules.lanzaboote
    (import ./disko-config.nix { disks = [ "/dev/nvme0n1" ]; })
    inputs.sops-nix.nixosModules.sops
    ../common/users/mhelton
    ../common/nixos.nix
    ../common/_1password.nix
    ../common/docker.nix
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.blacklistedKernelModules = [ "hid_sensor_hub" ];
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=1
    options cros_charge-control probe_with_fwk_charge_control=1
  '';
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.overlays = [
    (final: prev: {
      linux-firmware = prev.linux-firmware.overrideAttrs (old: {
        version = "20260221-unstable-2026-02-26";
        src = prev.fetchFromGitLab {
          owner = "kernel-firmware";
          repo = "linux-firmware";
          rev = "d8e138dd8970ffc9f5f879e2d62938abe6cd3f22";
          hash = "sha256-/OkEh1xB8dud4Jun3eX3QjGeByJkfHxXNSVIctgoMyQ=";
        };
      });
    })
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "mhelton-fw13"; # Define your hostname.
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
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

  hardware.graphics.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    sbctl
    slack
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    (gnomeExtensions.nasa-apod.overrideAttrs {
      version = "47-unstable-2026-01-12";
      src =
        pkgs.fetchFromGitHub {
          owner = "Elinvention";
          repo = "gnome-shell-extension-nasa-apod";
          rev = "887fc40be3c8621385ca7fd1e65bfda48137f253";
          hash = "sha256-uy/zOPiyugjNq9YWc712gjtl4NwnjsMtSd5ktHLoB0c=";
        }
        + "/nasa_apod@elinvention.ovh";
    })
  ];
  services.udev.packages = [ pkgs.gnome-settings-daemon ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-source-record
    ];
  };

  environment.variables = {
    VDPAU_DRIVER = "radeonsi";
  };

  services.fwupd.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint ];
  };

  services.avahi.enable = true;

  services.flatpak.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };
  virtualisation.spiceUSBRedirection.enable = true;

  services.usbmuxd.enable = true;

  programs.ydotool.enable = true;

  system.stateVersion = "25.11";

  specialisation.personal.configuration = {
    imports = [
      ../common/steam.nix
    ];

    home-manager.users.mhelton.imports = [
      ../../home/mhelton/gaming.nix
      ../../home/mhelton/personal.nix
    ];
  };
  specialisation.compliance.configuration = {
    services.clamav = {
      daemon.enable = true;
      updater.enable = true;
    };
    environment.systemPackages = with pkgs; [
      drsprinto
    ];
  };

}
