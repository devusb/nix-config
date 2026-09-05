{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../common/users/mhelton
    ../common/nixos.nix
    ../common/steam.nix
    ../common/_1password.nix
    ../common/docker.nix
    ../common/libvirt.nix
    ../common/mesa-git.nix
    ../common/niri.nix
    ../common/sunshine.nix
  ];

  networking.hostName = "tomservo";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.enableContainers = false;
  boot.loader.timeout = 30;

  powerManagement.cpuFreqGovernor = "performance";

  system.stateVersion = "21.11";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.firewall.enable = false;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.ratbagd.enable = true;

  # Graphical
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    videoDrivers = lib.mkDefault [ "modesetting" ];
    deviceSection = ''
      Option "VariableRefresh" "true"
    '';
  };
  hardware.graphics = {
    enable = true;
  };

  services.displayManager.autoLogin.user = "mhelton";

  services.avahi = {
    enable = true;
    reflector = true;
    nssmdns4 = true;
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

  networking.interfaces.enp6s0.wakeOnLan.enable = true;
  services.sleep-on-lan.enable = true;

  services.nfs-client.enable = true;

  specialisation = {
    vfio.configuration = {
      imports = [
        ./vfio.nix
      ];
      services.ollama.enable = lib.mkForce false;
      services.sunshine.enable = lib.mkForce false;
    };
  };
}
