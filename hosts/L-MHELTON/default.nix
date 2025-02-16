{
  lib,
  config,
  pkgs,
  inputs,
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

  services.openssh = {
    enable = true;
    openFirewall = false;
  };
  services.tailscale.enable = lib.mkForce false;

  services.work = {
    enable = true;
    sentinelOneSerial = "8908DB3";
    sentinelOneEmail = "morgan.helton@imubit.com";
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

  services.pulseaudio.enable = false;
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
    videoDrivers = [
      "modesetting"
    ] ++ lib.optionals config.services.work.enable [ "displaylink" ];
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
