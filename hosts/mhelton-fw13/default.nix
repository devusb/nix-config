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
  boot.kernelPackages = pkgs.linuxPackages_6_18;

  boot.kernelPatches = [
    {
      name = "drm/amd/display: Increase DCN35 SR enter/exit latency by 3us";
      patch = pkgs.fetchpatch {
        url = "https://gitlab.freedesktop.org/-/project/4522/uploads/daad272f57fc56572461d789bc105809/0001-drm-amd-display-Increase-DCN35-SR-latency-by-3us.patch";
        sha256 = "sha256-84FgDHdqQ4OD4a5a3UoUGGC0Ip/oMug+t2FDpTHhzbc=";
      };
    }
    {
      name = "Revert drm/amdgpu: Enable MES lr_compute_wa by default";
      patch = pkgs.fetchpatch {
        url = "https://github.com/torvalds/linux/commit/1fb710793ce2619223adffaf981b1ff13cd48f17.patch";
        sha256 = "sha256-rOvOT626umgcmh9HPPGwC3eDNvO2Du5czeOnMR5Adx4=";
        revert = true;
      };
    }
  ];

  boot.kernelParams = [
    "amdgpu.cwsr_enable=0" # avoid amdgpu crashes
    "amdgpu.mes=0"
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
    pkgs.gnomeExtensions.appindicator
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
