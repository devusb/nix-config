{ inputs, pkgs, ... }: {
  imports = [
  ];

  home.packages = with pkgs; [
    dig
    inetutils
  ];

  programs.kitty = {
    font.size = 12;
  };

  services.syncthing.enable = true;

  home.sessionVariables = {
    DOTFILES = "/dotfiles/";
  };

}
