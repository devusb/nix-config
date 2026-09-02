# Transcribed from DankMaterialShell's core/internal/config/embedded/niri-binds.kdl
{ lib, pkgs, ... }:
let
  dms = args: {
    spawn = [
      "dms"
      "ipc"
      "call"
    ]
    ++ args;
  };

  locked = action: action // { _props.allow-when-locked = true; };

  titled = title: action: action // { _props.hotkey-overlay-title = title; };

  screenshot = args: {
    spawn = [
      "dms"
      "screenshot"
    ]
    ++ args;
  };

  workspaceBinds = lib.foldl' (
    acc: n:
    acc
    // {
      "Mod+${toString n}".focus-workspace = n;
      "Mod+Shift+${toString n}".move-column-to-workspace = n;
    }
  ) { } (lib.range 1 9);
in
{
  wayland.windowManager.niri.settings = {
    binds = workspaceBinds // {
      "Mod+O" = {
        _props.repeat = false;
        toggle-overview = { };
      };
      "Mod+Tab" = {
        _props.repeat = false;
        toggle-overview = { };
      };
      "Mod+Shift+Slash".show-hotkey-overlay = { };

      "Mod+T" = titled "Open Terminal" { spawn = [ "ghostty" ]; };
      "Mod+Space" = titled "Application Launcher" (dms [
        "spotlight"
        "toggle"
      ]);
      "Alt+Space" = titled "Spotlight Bar" (dms [
        "spotlight-bar"
        "toggle"
      ]);
      "Mod+V" = titled "Clipboard Manager" (dms [
        "clipboard"
        "toggle"
      ]);
      "Mod+M" = titled "Task Manager" (dms [
        "processlist"
        "focusOrToggle"
      ]);
      "Ctrl+Alt+Delete" = titled "Task Manager" (dms [
        "processlist"
        "focusOrToggle"
      ]);
      "Super+X" = titled "Power Menu: Toggle" (dms [
        "powermenu"
        "toggle"
      ]);
      "Mod+Comma" = titled "Settings" (dms [
        "settings"
        "focusOrToggle"
      ]);
      "Mod+Y" = titled "Browse Wallpapers" (dms [
        "dash"
        "toggle"
        "wallpaper"
      ]);
      "Mod+N" = titled "Notification Center" (dms [
        "notifications"
        "toggle"
      ]);
      "Mod+Shift+N" = titled "Notepad" (dms [
        "notepad"
        "toggle"
      ]);
      "Mod+Alt+L" = titled "Lock Screen" (dms [
        "lock"
        "lock"
      ]);
      "Mod+Shift+E".quit = { };

      "XF86AudioRaiseVolume" = locked (dms [
        "audio"
        "increment"
        "3"
      ]);
      "XF86AudioLowerVolume" = locked (dms [
        "audio"
        "decrement"
        "3"
      ]);
      "XF86AudioMute" = locked (dms [
        "audio"
        "mute"
      ]);
      "XF86AudioMicMute" = locked (dms [
        "audio"
        "micmute"
      ]);
      "XF86AudioPause" = locked (dms [
        "mpris"
        "playPause"
      ]);
      "XF86AudioPlay" = locked (dms [
        "mpris"
        "playPause"
      ]);
      "XF86AudioPrev" = locked (dms [
        "mpris"
        "previous"
      ]);
      "XF86AudioNext" = locked (dms [
        "mpris"
        "next"
      ]);
      "Ctrl+XF86AudioRaiseVolume" = locked (dms [
        "mpris"
        "increment"
        "3"
      ]);
      "Ctrl+XF86AudioLowerVolume" = locked (dms [
        "mpris"
        "decrement"
        "3"
      ]);
      "XF86MonBrightnessUp" = locked (dms [
        "brightness"
        "increment"
        "5"
        ""
      ]);
      "XF86MonBrightnessDown" = locked (dms [
        "brightness"
        "decrement"
        "5"
        ""
      ]);

      "Mod+Q" = {
        _props.repeat = false;
        close-window = { };
      };
      "Mod+F".maximize-column = { };
      "Mod+Shift+F".fullscreen-window = { };
      "Mod+Shift+T".toggle-window-floating = { };
      "Mod+Shift+V".switch-focus-between-floating-and-tiling = { };
      "Mod+W".toggle-column-tabbed-display = { };
      "Mod+Shift+W" = titled "Create window rule" (dms [
        "window-rules"
        "toggle"
      ]);

      "Mod+Left".focus-column-left = { };
      "Mod+Down".focus-window-down = { };
      "Mod+Up".focus-window-up = { };
      "Mod+Right".focus-column-right = { };
      "Mod+H".focus-column-left = { };
      "Mod+J".focus-window-down = { };
      "Mod+K".focus-window-up = { };
      "Mod+L".focus-column-right = { };

      "Mod+Shift+Left".move-column-left = { };
      "Mod+Shift+Down".move-window-down = { };
      "Mod+Shift+Up".move-window-up = { };
      "Mod+Shift+Right".move-column-right = { };
      "Mod+Shift+H".move-column-left = { };
      "Mod+Shift+J".move-window-down = { };
      "Mod+Shift+K".move-window-up = { };
      "Mod+Shift+L".move-column-right = { };

      "Mod+Home".focus-column-first = { };
      "Mod+End".focus-column-last = { };
      "Mod+Ctrl+Home".move-column-to-first = { };
      "Mod+Ctrl+End".move-column-to-last = { };

      "Mod+Ctrl+Left".focus-monitor-left = { };
      "Mod+Ctrl+Right".focus-monitor-right = { };
      "Mod+Ctrl+H".focus-monitor-left = { };
      "Mod+Ctrl+J".focus-monitor-down = { };
      "Mod+Ctrl+K".focus-monitor-up = { };
      "Mod+Ctrl+L".focus-monitor-right = { };

      "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = { };
      "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = { };
      "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = { };
      "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = { };
      "Mod+Shift+Ctrl+H".move-column-to-monitor-left = { };
      "Mod+Shift+Ctrl+J".move-column-to-monitor-down = { };
      "Mod+Shift+Ctrl+K".move-column-to-monitor-up = { };
      "Mod+Shift+Ctrl+L".move-column-to-monitor-right = { };

      "Mod+Page_Down".focus-workspace-down = { };
      "Mod+Page_Up".focus-workspace-up = { };
      "Mod+U".focus-workspace-down = { };
      "Mod+I".focus-workspace-up = { };
      "Mod+Ctrl+Down".move-column-to-workspace-down = { };
      "Mod+Ctrl+Up".move-column-to-workspace-up = { };
      "Mod+Ctrl+U".move-column-to-workspace-down = { };
      "Mod+Ctrl+I".move-column-to-workspace-up = { };
      "Ctrl+Shift+R" = titled "Rename Workspace" (dms [
        "workspace-rename"
        "open"
      ]);
      "Mod+Shift+Page_Down".move-workspace-down = { };
      "Mod+Shift+Page_Up".move-workspace-up = { };
      "Mod+Shift+U".move-workspace-down = { };
      "Mod+Shift+I".move-workspace-up = { };

      "Mod+WheelScrollDown" = {
        _props.cooldown-ms = 150;
        focus-workspace-down = { };
      };
      "Mod+WheelScrollUp" = {
        _props.cooldown-ms = 150;
        focus-workspace-up = { };
      };
      "Mod+Ctrl+WheelScrollDown" = {
        _props.cooldown-ms = 150;
        move-column-to-workspace-down = { };
      };
      "Mod+Ctrl+WheelScrollUp" = {
        _props.cooldown-ms = 150;
        move-column-to-workspace-up = { };
      };
      "Mod+WheelScrollRight".focus-column-right = { };
      "Mod+WheelScrollLeft".focus-column-left = { };
      "Mod+Ctrl+WheelScrollRight".move-column-right = { };
      "Mod+Ctrl+WheelScrollLeft".move-column-left = { };
      "Mod+Shift+WheelScrollDown".focus-column-right = { };
      "Mod+Shift+WheelScrollUp".focus-column-left = { };
      "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = { };
      "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = { };

      "Mod+BracketLeft".consume-or-expel-window-left = { };
      "Mod+BracketRight".consume-or-expel-window-right = { };
      "Mod+Period".expel-window-from-column = { };

      "Mod+R".switch-preset-column-width = { };
      "Mod+Shift+R".switch-preset-window-height = { };
      "Mod+Ctrl+R".reset-window-height = { };
      "Mod+Ctrl+F".expand-column-to-available-width = { };
      "Mod+C".center-column = { };
      "Mod+Ctrl+C".center-visible-columns = { };
      "Mod+Minus".set-column-width = "-10%";
      "Mod+Equal".set-column-width = "+10%";
      "Mod+Shift+Minus".set-window-height = "-10%";
      "Mod+Shift+Equal".set-window-height = "+10%";

      "Mod+Shift+S" = titled "Screenshot: Region" (screenshot [ ]);
      "Mod+Ctrl+Shift+S" = titled "Screenshot: Full Screen" (screenshot [ "full" ]);
      "Mod+Alt+Shift+S" = titled "Screenshot: Window" (screenshot [ "window" ]);
      "Print" = titled "Screenshot: Region" (screenshot [ ]);
      "Ctrl+Print" = titled "Screenshot: Full Screen" (screenshot [ "full" ]);
      "Alt+Print" = titled "Screenshot: Window" (screenshot [ "window" ]);
      "XF86Launch1" = titled "Screenshot: Region" (screenshot [ ]);
      "Ctrl+XF86Launch1" = titled "Screenshot: Full Screen" (screenshot [ "full" ]);
      "Alt+XF86Launch1" = titled "Screenshot: Window" (screenshot [ "window" ]);

      "Mod+P" = titled "Cycle Display Profile" {
        spawn = [
          "dms"
          "ipc"
          "outputs"
          "cycleProfile"
        ];
      };
      "Mod+Escape" = {
        _props.allow-inhibiting = false;
        toggle-keyboard-shortcuts-inhibit = { };
      };
      "Mod+Shift+P".power-off-monitors = { };

      "Ctrl+Alt+Shift+H" = titled "Toggle Handy Transcription" {
        spawn = [
          "${lib.getExe pkgs.llm-agents.handy}"
          "--toggle-transcription"
        ];
      };
    };
  };
}
