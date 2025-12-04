{ pkgs, ... }:
{
  imports = [
  ];

  home.packages = with pkgs; [
    dig
    inetutils
  ];

  programs.kitty = {
    font.size = 12;
  };

  home.sessionVariables = {
    DOTFILES = "/dotfiles/";
  };

}
