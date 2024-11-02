# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:
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
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.deckbd.enable = true;

  networking.hostName = "bob"; # Define your hostname.
  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
    wifi.backend = "iwd";
  };
  services.geoclue2.enableWifi = false;
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez.overrideAttrs (old: {
      patches = old.patches ++ [
        # revert bluez commit that causes https://github.com/Jovian-Experiments/Jovian-NixOS/issues/441
        (pkgs.fetchpatch2 {
          url = "https://github.com/bluez/bluez/commit/9cc587947b6ac56a4c94dcc880b273bc72af22a8.patch";
          hash = "sha256-1m6UHoQ95BH0cMcj7D/gldeNjlTyk/QZCNPnloH5emc=";
          revert = true;
        })
      ];
    });
  };

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

  services.desktopManager.plasma6.enable = true;
  programs.kdeconnect.enable = true;

  environment.variables = {
    VDPAU_DRIVER = "radeonsi";
  };

  jovian.steam = {
    enable = true;
    autoStart = true;
    user = "mhelton";
    desktopSession = "plasma";
  };
  jovian.devices.steamdeck = {
    enable = true;
  };
  programs.steam.extest.enable = true;

  sops = {
    secrets.registration_key = {
      sopsFile = ../../secrets/playstation.yaml;
      owner = config.users.users.mhelton.name;
    };
  };

  programs.chiaki4deck = {
    enable = true;
    consoleAddress = "192.168.10.50";
    registrationKeyPath = config.sops.secrets.registration_key.path;
    consoleNickname = "PS5-875";
  };

  services.flatpak = {
    enable = true;
  };

  system.stateVersion = "23.05"; # Did you read the comment?

}

