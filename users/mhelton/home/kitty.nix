{ pkgs, ...}: {
  programs.kitty = {
      enable = true;
      font.name = "monospace";
  };
}