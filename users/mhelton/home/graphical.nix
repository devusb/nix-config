{ pkgs, ...}: {
  imports = [
      ./terminal.nix
  ];
  home.packages = with pkgs; [lens zoom-us];
  programs.google-chrome.enable = true;
  programs.vscode.enable = true;
}
