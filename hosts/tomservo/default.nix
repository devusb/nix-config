{ pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/steam.nix
    ../common/_1password.nix
    ../common/docker.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "21.11";

  # pin kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_0;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # enable syslog
  services.syslogd.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = true;
    permitRootLogin = "no";
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

  # add GUI and nvidia drivers
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  services.xserver.displayManager = {
    gdm.enable = true;
    gdm.autoSuspend = false;
    # autoLogin = {
    #   enable = true;
    #   user = "mhelton";
    # };
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

}
