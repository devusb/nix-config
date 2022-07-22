{ inputs, lib, config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    colima
    docker
    wget
    nano
  ];

  services.nix-daemon.enable = true;

  programs.zsh.enable = true; # default shell on catalina

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system.defaults = {
    dock = {
      autohide = false;
      orientation = "bottom";
      wvous-tl-corner = 2;
      wvous-br-corner = 1;
      wvous-tr-corner = 1;
      wvous-bl-corner = 1;
      tilesize = 57;
    };
    trackpad = {
      Clicking = true;
      ActuationStrength = 1;
    };
    NSGlobalDomain = {
      "com.apple.trackpad.scaling" = "1.0";
    };
  };
}
