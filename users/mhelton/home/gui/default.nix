{ pkgs, ...}: {
    home.packages = with pkgs; [lens lutris gnome.adwaita-icon-theme];

    programs.google-chrome.enable = true;
    programs.vscode.enable = true;
}