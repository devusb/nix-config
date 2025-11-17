{ config, ... }:
{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = config.programs.fish.enable;
    enableZshIntegration = config.programs.zsh.enable;
    settings = {
      window-height = 45;
      window-width = 170;
      shell-integration-features = "ssh-env";
      background-opacity = 0.97;
    };
  };
}
