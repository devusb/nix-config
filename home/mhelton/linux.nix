{ inputs, pkgs, ... }: {
  imports = [
    inputs.vscode-server.nixosModules.home
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
