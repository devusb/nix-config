{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font Mono";
    };
    extraConfig = ''
      term xterm-256color
      background_opacity 0.9
      confirm_os_window_close 2
    '';
  };
}
