# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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
    ../common/steam.nix
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
  boot.kernelPatches = [
    {
      name = "mfd: cros_ec: Separate charge-control probing from USB-PD";
      patch = pkgs.fetchpatch {
        url = "https://lore.kernel.org/lkml/20250521-cros-ec-mfd-chctl-probe-v1-1-6ebfe3a6efa7@weissschuh.net/raw";
        sha256 = "sha256-8nBcr7mFdUE40yHA1twDVbGKJ8tvAW+YRP23szUIhxk=";
      };
    }
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

  # power management
  services.udev.extraRules = ''
    # swap between 60Hz and 120Hz on battery/AC
    ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", RUN+="${pkgs.systemd}/bin/systemd-run --user --machine mhelton@ ${lib.getExe' pkgs.kdePackages.libkscreen "kscreen-doctor"} output.eDP-1.mode.2880x1920@60"
    ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", RUN+="${pkgs.systemd}/bin/systemd-run --user --machine mhelton@ ${lib.getExe' pkgs.kdePackages.libkscreen "kscreen-doctor"} output.eDP-1.mode.2880x1920@120"
  '';

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

  # Plasma
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  security.pam.services.login.fprintAuth = false;

  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    sbctl
    slack
  ];
  programs.kdeconnect.enable = true;

  environment.variables = {
    VDPAU_DRIVER = "radeonsi";
  };

  services.fwupd.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint ];
  };

  services.avahi.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment?

}
