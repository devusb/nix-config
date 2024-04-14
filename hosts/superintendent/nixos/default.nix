{ inputs, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../common/users/mhelton
    ../../common/nixos.nix
    ../../common/_1password.nix
    ../../common/docker.nix
    inputs.nixos-apple-silicon.nixosModules.default
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.initrd.luks.devices = {
    luksroot = {
      device = "/dev/disk/by-uuid/f687fb72-c558-4eec-9020-d82b0dc94816";
      preLVM = true;
    };
  };

  hardware.asahi = {
    peripheralFirmwareDirectory = pkgs.fetchzip {
      url = "https://filebrowser.chopper.devusb.us/api/public/dl/xQYuJB9X/firmware_m1.zip";
      hash = "sha256-BOf2kKGPFn3P2zQf+DqLfT0K+JynrNicb9e3xlpY9MM=";
      stripRoot = false;
    };
    useExperimentalGPUDriver = true;
    withRust = true;
  };

  hardware.opengl.enable = true;
  sound.enable = true;

  networking.hostName = "superintendent";
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  system.stateVersion = "24.05";

  # widevine support
  nixpkgs.overlays = [
    inputs.nixos-aarch64-widevine.overlays.default
  ];
  environment.sessionVariables.MOZ_GMP_PATH = [ "${pkgs.widevine-cdm-lacros}/gmp-widevinecdm/system-installed" ];

  environment.systemPackages = with pkgs; [
    kde-rounded-corners
  ];

  services.xserver.enable = true;

  # Plasma
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

}

