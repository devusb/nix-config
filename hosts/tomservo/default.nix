{
  inputs,
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
    inputs.chaotic.nixosModules.default
  ];

  networking.hostName = "tomservo";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.enableContainers = false;

  powerManagement.cpuFreqGovernor = "performance";

  system.stateVersion = "21.11";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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

  services.ratbagd.enable = true;

  services.udev.extraRules = ''
    # Logitech G533
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0a66", TAG+="uaccess"
  '';

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
  chaotic.mesa-git.enable = true;

  # Plasma
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;
  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    kde-rounded-corners
  ];

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

  systemd.user.services.sunshine.path = with pkgs; [
    xdg-utils
  ];
  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
    package = pkgs.sunshine.override {
      boost = pkgs.boost185;
    };
    applications = {
      env = {
        PATH = "$(PATH):$(HOME)/.local/bin";
      };
      apps = [
        {
          name = "1440p Desktop";
          prep-cmd = [
            {
              do = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-4.mode.2560x1440@144";
              undo = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-4.mode.3440x1440@144";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "1080p Desktop";
          prep-cmd = [
            {
              do = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-4.mode.1920x1080@120";
              undo = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-4.mode.3440x1440@144";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "800p Desktop";
          prep-cmd = [
            {
              do = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-4.mode.1280x800@144";
              undo = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-4.mode.3440x1440@144";
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

}
