{ inputs, lib, config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ 
      vim 
      colima 
      docker
      wget
      nano
      brave
    ];

  services.nix-daemon.enable = true;

  programs.zsh.enable = true;  # default shell on catalina

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system.defaults = {
      dock.autohide = false;
      dock.orientation = "bottom";
  };
}
