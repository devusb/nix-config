{ pkgs, config, system, lib, ... }: {
  home.packages = with pkgs; [
    tailscale
  ];

  programs.iterm2 = {
    enable = true;
    profiles = import ./extra/iterm2_profile.nix;
    preferences = import ./extra/iterm2.nix;
  };

  programs.zsh = {
    shellAliases = {
      tsup = "sudo tailscale up && networksetup -setdnsservers Wi-Fi 100.100.100.100";
      tsdn = "sudo tailscale down && networksetup -setdnsservers Wi-Fi Empty";
    };
    plugins = [
      {
        name = "iterm2";
        file = "Resources/shell_integration/iterm2_shell_integration.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "gnachman";
          repo = "iTerm2";
          rev = "698b83ec79d882ee5acb25b7e358680f9db47e01";
          sha256 = "sha256-86h4zVRjjQmPXuLsbTycdJeGhlhRumSDK33t4lMYZ78=";
        };
      }
    ];
  };

  home.sessionVariables = {
    DOTFILES = "$HOME/code/nix-config/";
  };
}
