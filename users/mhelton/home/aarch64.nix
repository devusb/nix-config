{ pkgs, ...}: {
    home.packages = with pkgs; [];
    programs.firefox.enable = true;
}