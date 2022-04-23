{ pkgs, ...}: {
    home.packages = with pkgs; [lens];
    programs.google-chrome.enable = true;
    programs.vscode.enable = true;
}