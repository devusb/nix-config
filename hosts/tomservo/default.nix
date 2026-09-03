{
  config,
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

  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
    applications = {
      env = {
        PATH = "$(PATH):$(HOME)/.local/bin";
      };
      apps = [
        {
          name = "1440p Desktop";
          prep-cmd = [
            {
              do = "${config.programs.niri.package}/bin/niri msg output DP-4 mode 2560x1440";
              undo = "${config.programs.niri.package}/bin/niri msg output DP-4 mode auto";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "1080p Desktop";
          prep-cmd = [
            {
              do = "${config.programs.niri.package}/bin/niri msg output DP-4 mode 1920x1080";
              undo = "${config.programs.niri.package}/bin/niri msg output DP-4 mode auto";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "800p Desktop";
          prep-cmd = [
            {
              do = "${config.programs.niri.package}/bin/niri msg output DP-4 custom-mode 1280x800@60";
              undo = "${config.programs.niri.package}/bin/niri msg output DP-4 mode auto";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
      ];
    };
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
