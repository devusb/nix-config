{ inputs, pkgs, ... }: {
  imports = [
    inputs.vscode-server.nixosModules.home
  ];

  home.packages = with pkgs; [
    dig
    inetutils
  ];

  programs.kitty.font.size = 12;

  services.vscode-server.enable = true;

  home.sessionVariables = {
    DOTFILES = "/dotfiles/";
  };
}
