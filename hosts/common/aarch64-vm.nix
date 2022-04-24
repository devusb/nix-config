{ pkgs, inputs, ... }: {
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # add GUI
  environment.pathsToLink = [ "/libexec" ];
  services.xserver = {
    enable = true;
    layout = "us";
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
      #extraSessionCommands = "spice-vdagent";
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
  # hardware.video.hidpi.enable = true;
  # services.xserver.dpi = 180;

  # services.autorandr = {
  #   enable = true;
  #   defaultTarget = "utm";
  #   profiles = {
  #     "utm" = {
  #       fingerprint = {
  #         Virtual-1 = "";
  #       };
  #       config = {
  #         Virtual-1 = {
  #           enable = true;
  #           dpi = 180;
  #           mode = "640x480";
  #         };
  #       };
  #     };
  #   };
  # };

}
