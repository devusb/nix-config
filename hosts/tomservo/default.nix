{ pkgs, inputs, config, ... }:
let
  shairport-sync = pkgs.shairport-sync.override { enableAirplay2 = true; };
in
{
  imports = [
    ./hardware-configuration.nix
    ../common/users/mhelton
    ../common/nixos.nix
    ../common/steam.nix
    ../common/_1password.nix
    ../common/docker.nix
  ];

  networking.hostName = "tomservo";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "21.11";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  networking.firewall.enable = false;

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

  # add GUI
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.videoDrivers = [ "modesetting" ];
  services.xserver.deviceSection = ''
    Option "VariableRefresh" "true"
  '';
  hardware.opengl.enable = true;

  services.xserver.displayManager = {
    gdm.enable = true;
    gdm.autoSuspend = false;
    gdm.wayland = false;
  };

  # autologin crash workaround
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.avahi = {
    enable = true;
    reflector = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      userServices = true;
      workstation = true;
    };
  };

  services.flatpak.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint ];
  };

  services.nqptp.enable = true;
  services.shairport-sync = {
    enable = true;
    package = shairport-sync;
  };

  services.sunshine.enable = true;

  networking.interfaces.enp5s0.wakeOnLan.enable = true;
  services.sleep-on-lan.enable = true;

}
