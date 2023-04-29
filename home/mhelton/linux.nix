{ inputs, pkgs, ... }: {
  imports = [
  ];

  home.packages = with pkgs; [
    dig
    inetutils
  ];

  programs.kitty = {
    font.size = 12;
    settings = {
      linux_display_server = "x11";
    };
  };

  services.syncthing.enable = true;

  home.sessionVariables = {
    DOTFILES = "/dotfiles/";
  };

}
