{ inputs, lib, config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ 
      vim 
      colima 
      docker
    ];

  services.nix-daemon.enable = true;

  programs.zsh.enable = true;  # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}