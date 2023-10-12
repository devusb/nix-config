{ lib, pkgs, inputs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/users/mhelton
    ../common/nixos.nix
    ../common/docker.nix
    inputs.p81.nixosModules.perimeter81
    inputs.sentinelone.nixosModules.sentinelone
    inputs.sops-nix.nixosModules.sops
  ];

  networking.hostName = "imubit-morganh-dell";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "23.05";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = false;
  };
  services.tailscale.enable = lib.mkForce false;
  services.perimeter81.enable = true;

  sops = {
    secrets.s1_mgmt_token = {
      sopsFile = ../../secrets/sentinelone.yaml;
    };
  };
  services.sentinelone = {
    enable = true;
    serialNumber = "8908DB3";
    sentinelOneManagementTokenPath = config.sops.secrets.s1_mgmt_token.path;
    email = "morgan.helton@imubit.com";
  };

  environment.systemPackages = with pkgs; [
    google-chrome
    slack
    teams-for-linux
  ];
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # keychron function keys
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
  '';

  services.udev.extraRules = ''
    # Logitech G533
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0a66", TAG+="uaccess"
  '';

  # Graphical
  services.xserver = {
    enable = true;
  };
  hardware.opengl = {
    enable = true;
  };

  # Plasma
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.desktopManager.plasma5.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint ];
  };

}
