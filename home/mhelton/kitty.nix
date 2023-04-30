{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font Mono";
    };
    settings = {
      term = "xterm-256color";
      background_opacity = "0.9";
      confirm_os_window_close = "2";
      linux_display_server = "x11";
    };
    keybindings = {
      "ctrl+f2" = "detach_tab";
      "cmd+f2" = "detach_tab";
    };
  };
}
