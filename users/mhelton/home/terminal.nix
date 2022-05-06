{ pkgs, ...}: {
  programs.kitty = {
      enable = true;
      font.name = "monospace";
      extraConfig = "term xterm-256color";
  };
}