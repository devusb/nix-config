{ ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font Mono";
    };
    settings = {
      term = "xterm-256color";
      background_opacity = "0.9";
      confirm_os_window_close = "2";
      macos_option_as_alt = "yes";
      scrollback_pager_history_size = "100";
    };
    keybindings = {
      "ctrl+f2" = "detach_tab";
      "cmd+f2" = "detach_tab";
      "ctrl+shift+t" = "new_tab_with_cwd";
      "cmd+shift+t" = "new_tab_with_cwd";
    };
  };
}
