{ pkgs, inputs, config, ... }:
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

  boot.kernelPackages = pkgs.linuxPackages_6_5;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  environment.variables = {
    VDPAU_DRIVER = "radeonsi";
  };

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

  # Graphical
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    videoDrivers = [ "modesetting" ];
    deviceSection = ''
      Option "VariableRefresh" "true"
    '';
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Plasma
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.desktopManager.plasma5.enable = true;
  programs.kdeconnect.enable = true;

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

  services.flatpak = {
    enable = true;
    autoUpdate.enable = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint ];
  };

  services.sunshine.enable = true;

  services.plex-mpv-shim.enable = true;

  networking.interfaces.enp5s0.wakeOnLan.enable = true;
  services.sleep-on-lan.enable = true;

  services.nfs-client.enable = true;

}
