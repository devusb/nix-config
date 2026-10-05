{ pkgs, ... }:
{
  imports = [
    ./kitty.nix
  ];

  home.packages = with pkgs; [
    llm-agents.handy
    dbeaver-bin
    tailscale
    gnused
    gnugrep
    gawk
    watch
    tart
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
}
