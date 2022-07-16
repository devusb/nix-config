{ pkgs, config, system, lib, ... }: {
  home.packages = with pkgs; [
    tailscale
  ];

  programs.iterm2 = {
    enable = true;
    profiles = import ./extra/iterm2_profile.nix;
    preferences = import ./extra/iterm2.nix;
  };

  programs.zsh ={
    shellAliases = {
      tsup = "sudo tailscale up --accept-routes --qr && networksetup -setdnsservers Wi-Fi 100.100.100.100";
      tsdn = "sudo tailscale down && networksetup -setdnsservers Wi-Fi Empty";
    };
  };

  home.sessionVariables = {
    DOTFILES = "$HOME/code/nix-config/";
  };
}
