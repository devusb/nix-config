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

    displayManager= {
      defaultSession = "none+i3";
       autoLogin = {
         user = "mhelton";
         enable = true;
       };
    };
    
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu 
        i3status 
        i3lock 
     ];
      extraSessionCommands = "spice-vdagent";
    };
  };
}