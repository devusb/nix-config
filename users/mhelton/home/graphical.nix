{ pkgs, ...}: {
    home.packages = with pkgs; [lens kitty];
    programs.google-chrome.enable = true;
    programs.vscode.enable = true;
}
