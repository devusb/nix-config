# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, ... }: {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors), use something like:
    # inputs.nix-colors.homeManagerModule

    # Feel free to split up your configuration and import pieces of it here.
  ];

  # Comment out if you wish to disable unfree packages for your system
  nixpkgs.config.allowUnfree = true;

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [ lens kubectl kubectx k9s lutris gnome.adwaita-icon-theme fluxcd vault ];
  programs.google-chrome.enable = true;
  programs.vscode.enable = true;
  programs.fzf.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName  = "Morgan Helton";
    userEmail = "mhelton@gmail.com";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  
  programs.bash = {
    enable = true;
    shellAliases = {
      kb = "kubectl";
    };
  };
  
}
