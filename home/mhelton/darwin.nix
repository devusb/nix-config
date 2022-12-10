{ pkgs, config, system, lib, ... }: {
  
  home.packages = with pkgs; [
    tailscale
    gnused
    gnugrep
    gawk
  ];

  programs.zsh = {
    shellAliases = {
      tsup = "sudo ${pkgs.tailscale}/bin/tailscale up --accept-routes --qr && networksetup -setdnsservers Wi-Fi 100.100.100.100";
      tsdn = "sudo ${pkgs.tailscale}/bin/tailscale down && networksetup -setdnsservers Wi-Fi Empty";
    };
  };

  programs.kitty.font.size = 13;

  home.sessionVariables = {
    DOTFILES = "$HOME/code/nix-config/";
  };

  nix.settings = {
    builders = "ssh://tomservo x86_64-linux ; ssh://tomservo aarch64-linux";
  };
}
