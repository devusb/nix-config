{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font Mono";
      size = 13;
    };
    extraConfig = ''
      term xterm-256color
      background_opacity 0.9
      confirm_os_window_close 2
    '';
  };
}
