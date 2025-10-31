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
    pkgs.gnomeExtensions.appindicator
  ];
  services.udev.packages = [ pkgs.gnome-settings-daemon ];

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

  system.stateVersion = "25.11";

  specialisation.personal.configuration = {
    imports = [
      ../common/steam.nix
    ];

    home-manager.users.mhelton.imports = [
      ../../home/mhelton/gaming.nix
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
