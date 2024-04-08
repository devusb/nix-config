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
  boot.kernelParams = [
    "apple_dcp.show_notch=1"
  ];
  boot.initrd.luks.devices = {
    luksroot = {
      device = "/dev/disk/by-uuid/da8b234f-f8cf-4b9d-a715-d800e53c89e1";
      preLVM = true;
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/e7db8c27-b422-440a-995f-e251b5042e65"; }
  ];

  hardware.asahi = {
    peripheralFirmwareDirectory = pkgs.fetchzip {
      url = "https://filebrowser.chopper.devusb.us/api/public/dl/xQYuJB9X/firmware.zip";
      hash = "sha256-L3XiUowdAOEC9T9XwCut+h05EylNhPZNnMIOkDsaHnQ=";
      stripRoot = false;
    };
    useExperimentalGPUDriver = true;
    withRust = true;
  };

  hardware.opengl.enable = true;
  sound.enable = true;

  networking.hostName = "r2d2"; # Define your hostname.
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  system.stateVersion = "24.05"; # Did you read the comment?

  environment.systemPackages = with pkgs; [
    kde-rounded-corners
  ];

  services.xserver.enable = true;

  # Plasma
  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.xserver.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

}

