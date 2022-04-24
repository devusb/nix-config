{ pkgs, inputs, lib, ... }: 
  let
    mkSure = lib.mkOverride 0;
  in {
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = mkSure true;

    # enable syslog
    services.syslogd.enable = true;

    services.openssh = {
      enable = true;
      passwordAuthentication = true;
      permitRootLogin = "yes";
    };

    # add GUI
    environment.pathsToLink = [ "/libexec" ];
    services.xserver = {
      enable = true;
      layout = "us";
      dpi = 180;
      libinput = {  
        enable = true;
        touchpad.naturalScrolling = true;
        mouse.naturalScrolling = true;
      };

      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        defaultSession = "none+i3";
        autoLogin = {
          user = "mhelton";
          enable = true;
        };
        sessionCommands = "spice-vdagent";
      };
      
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu 
          i3status 
          i3lock 
      ];
        extraSessionCommands = "${pkgs.xorg.xrandr}/bin/xrandr --dpi 180";
      };
    };

  # hidpi
    console.font =
      "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    environment.variables = {
      GDK_SCALE = "2";
      GDK_DPI_SCALE = "0.5";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    };
    hardware.video.hidpi.enable = true;
    boot.loader.systemd-boot.consoleMode = "0";

}
