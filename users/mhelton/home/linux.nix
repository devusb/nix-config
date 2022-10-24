{ pkgs, ... }: {
  imports = [
  ];
  home.packages = with pkgs; [
    dig
    inetutils
  ];

  services.vscode-server.enable = true;

  home.sessionVariables = {
    DOTFILES = "/dotfiles/";
  };
}
