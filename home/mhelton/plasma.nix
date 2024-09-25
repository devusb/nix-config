{ inputs, ... }: {
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  programs.plasma = {
    enable = true;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    kwin = {
      virtualDesktops = {
        number = 2;
        rows = 1;
      };
    };

    panels = [
      {
        location = "bottom";
        height = 44;
        floating = true;
        widgets = [
          "org.kde.plasma.kickoff"
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General.launchers = [
                "applications:systemsettings.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:firefox.desktop"
                "applications:kitty.desktop"
              ];
            };
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.pager"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.showdesktop"
        ];
      }
    ];

    shortcuts = {
      kwin = {
        "ExposeAll" = "Ctrl+Alt+Tab";
      };
    };

    window-rules = [
      {
        description = "Firefox Picture-in-Picture";
        match = {
          window-class = {
            value = "firefox";
            type = "exact";
            match-whole = false;
          };
          title = {
            value = "Picture-in-Picture";
            type = "exact";
          };
          window-types = [ "normal" ];
        };
        apply = {
          above = {
            value = true;
          };
        };
      }
    ];

    powerdevil = {
      AC = {
        autoSuspend = {
          action = "nothing";
        };
      };
      battery = {
        autoSuspend = {
          action = "sleep";
          idleTimeout = 600;
        };
      };
    };
  };

}
