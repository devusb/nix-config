{ pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/steam.nix
  ];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "21.11"; 

  # enable syslog
  services.syslogd.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = true;
    permitRootLogin = "no";
  };

  networking.useDHCP = false;
  networking.interfaces.enp31s0.useDHCP = true;
  networking.firewall.enable = false;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # add GUI and nvidia drivers
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  # autorandr
  services.autorandr = {
      enable = true;
      profiles = {
          home = {
              fingerprint = {DP-0 = "00ffffffffffff0010acd1a051344130191b0104a53c227806ee91a3544c99260f505421080001010101010101010101010101010101565e00a0a0a029503020350056502100001a000000ff0023415350764577666e33313764000000fd001e9022d139010a202020202020000000fc0044656c6c20533237313644470a0146020312412309070183010000654b040001015a8700a0a0a03b503020350056502100001a5aa000a0a0a046503020350056502100001a6fc200a0a0a055503020350056502100001a8fde00a0a0a00f503020350056502100001e1c2500a0a0a011503020350056502100001a0000000000000000000000000000000000000098";};
              config = {
                  DP-0 = {
                      enable = true;
                      mode = "2560x1440";
                      rate = "143.96";
                      primary = true;
                  };
              };
          };
      };
    };
  
}
