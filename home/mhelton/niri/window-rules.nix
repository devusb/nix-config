{ ... }:
{
  wayland.windowManager.niri.settings = {
    _children = [
      {
        window-rule._children = [
          {
            match._props = {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            };
          }
          { open-floating = true; }
          { default-column-width.fixed = 480; }
          { default-window-height.fixed = 270; }
        ];
      }
      {
        window-rule._children = [
          { match._props.app-id = "^1Password$"; }
          { block-out-from = "screen-capture"; }
        ];
      }
      {
        window-rule._children = [
          {
            match._props = {
              app-id = "^zoom$";
              title = "^zoom_linux_float_video_window$";
            };
          }
          { open-floating = true; }
          {
            default-floating-position._props = {
              x = 16;
              y = 16;
              relative-to = "bottom-right";
            };
          }
        ];
      }
      {
        window-rule._children = [
          {
            match._props = {
              app-id = "^zoom$";
              title = "^as_toolbar$";
            };
          }
          {
            match._props = {
              app-id = "^zoom$";
              title = "^as_preview$";
            };
          }
          { open-floating = true; }
          {
            default-floating-position._props = {
              x = 16;
              y = 16;
              relative-to = "top-right";
            };
          }
        ];
      }
      {
        window-rule._children = [
          { match._props.app-id = "^bluebubbles$"; }
          { default-column-width.proportion = 0.33333; }
        ];
      }
    ];
  };
}
