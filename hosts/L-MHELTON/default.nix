{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-11th-gen
    ../common/users/mhelton
    ../common/nixos.nix
    ../common/docker.nix
    inputs.disko.nixosModules.disko
    (import ./disko-config.nix { disks = [ "/dev/nvme0n1" ]; })
    inputs.p81.nixosModules.perimeter81
    inputs.sentinelone.nixosModules.sentinelone
    inputs.sops-nix.nixosModules.sops
  ];

  networking.hostName = "L-MHELTON";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.11";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  services.automatic-timezoned.enable = false;
  time.timeZone = "US/Central";

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
  ];
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
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
  hardware.graphics = {
    enable = true;
  };

  # Plasma
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint ];
  };

}
