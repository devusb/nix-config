{ pkgs, inputs, config, ... }: {
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

  # pin kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_0;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # enable syslog
  services.syslogd.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
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

  # keychron function keys
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
  '';

  services.udev.extraRules = ''
    # Logitech G533
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0a66", TAG+="uaccess"
  '';

  # add GUI and nvidia drivers
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.package = (config.nur.repos.arc.packages.nvidia-patch.overrideAttrs (old: {
    # override until https://github.com/arcnmx/nixexprs/pull/41 is merged
    version = "2023-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "keylase";
      repo = "nvidia-patch";
      rev = "787785e1cf14cf6ae76ea15dc4004127b2b8f917";
      sha256 = "sha256-mIRM2N+C+EPKVLVXtuAvHV6CfVRzjfB39fK/rXe4sGA=";
    };
  })).override {
    nvidia_x11 = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.displayManager = {
    gdm.enable = true;
    gdm.autoSuspend = false;
    autoLogin = {
      enable = true;
      user = "mhelton";
    };
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

}
