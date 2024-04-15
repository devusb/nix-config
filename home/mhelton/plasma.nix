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

    configFile = {
      "kwinrulesrc"."1"."Description".value = "Firefox Picture-in-Picture";
      "kwinrulesrc"."1"."above".value = true;
      "kwinrulesrc"."1"."aboverule".value = 2;
      "kwinrulesrc"."1"."title".value = "Picture-in-Picture";
      "kwinrulesrc"."1"."titlematch".value = 1;
      "kwinrulesrc"."1"."types".value = 1;
      "kwinrulesrc"."1"."wmclass".value = "firefox";
      "kwinrulesrc"."1"."wmclassmatch".value = 1;
      "kwinrulesrc"."General"."count".value = 1;
      "kwinrulesrc"."General"."rules".value = "1";
    };
  };

}
