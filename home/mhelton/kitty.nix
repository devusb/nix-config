{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font.name = "monospace";
    extraConfig = ''
      term xterm-256color
      background_opacity 0.9
    '';
  };
}
