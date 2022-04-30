# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, hostname, graphical, gaming, system, work, ... }: {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors), use something like:
    # inputs.nix-colors.homeManagerModule
    ./zsh.nix

    # Feel free to split up your configuration and import pieces of it here.
    "${fetchTarball { url="https://github.com/msteen/nixos-vscode-server/tarball/master"; sha256="1cszfjwshj6imkwip270ln4l1j328aw2zh9vm26wv3asnqlhdrak";}}/modules/vscode-server/home.nix"
  ]
  ++ (if graphical == true then [ ./graphical.nix ] else [])
  ++ (if gaming == true then [ ./gaming.nix ] else [])
  ++ (if system == "aarch64-linux" then [./aarch64.nix] else [])
  ++ (if work == true then [./work.nix] else [./personal.nix]);

  # Comment out if you wish to disable unfree packages for your system
  nixpkgs.config.allowUnfree = true;

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [ kubectl kubectx k9s fluxcd vault kustomize kubernetes-helm ansible librespeed-cli
   k3sup kompose micro mosh pwgen python3 inetutils python39Packages.pip zip unzip awscli2 dig jq yq sqlite
   (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })];
  fonts.fontconfig.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
  };

  # enable vscode-server
  services.vscode-server.enable = true;
  
}
