{ pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common
  ];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "21.11"; 

  # enable syslog
  services.syslogd.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = true;
    permitRootLogin = "yes";
  };

  networking.useDHCP = false;
  networking.interfaces.enp0s10.useDHCP = true;
  networking.firewall.enable = false;
  
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # setup windowing environment
  services.xserver = {
    enable = true;
    layout = "us";
    dpi = 220;

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "scale";
    };

    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;

      # AARCH64: For now, on Apple Silicon, we must manually set the
      # display resolution. This is a known issue with VMware Fusion.
      sessionCommands = ''
        ${pkgs.xlibs.xset}/bin/xset r rate 200 40
      '' + (if currentSystem == "aarch64-linux" then ''
        ${pkgs.xorg.xrandr}/bin/xrandr -s '2880x1800'
      '' else "");
    };

    windowManager = {
      i3.enable = true;
    };
  };

}
