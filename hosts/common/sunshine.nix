{
  config,
  pkgs,
  lib,
  ...
}:
let
  withPlasma = config.services.desktopManager.plasma6.enable;
  withNiri = config.programs.niri.enable;

  output = "DP-4";
  nativeMode = "3440x1440@144";
  refresh = "60";

  kscreen-doctor = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor";
  niri = "${config.programs.niri.package}/bin/niri";

  desktop =
    {
      name,
      resolution,
    }:
    {
      inherit name;
      prep-cmd =
        lib.optional withNiri {
          do = "${niri} msg output ${output} custom-mode ${resolution}@${refresh}";
          undo = "${niri} msg output ${output} mode auto";
        }
        ++ lib.optional withPlasma {
          do = "${kscreen-doctor} output.${output}.mode.${resolution}@${refresh}";
          undo = "${kscreen-doctor} output.${output}.mode.${nativeMode}";
        };
      exclude-global-prep-cmd = "false";
      auto-detach = "true";
    };
in
{
  assertions = [
    {
      assertion = !(withNiri && withPlasma);
      message = "sunshine prep-cmds cannot target both niri and plasma6";
    }
  ];

  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
    applications = {
      env = {
        PATH = "$(PATH):$(HOME)/.local/bin";
      };
      apps = [
        (desktop {
          name = "1440p Desktop";
          resolution = "2560x1440";
        })
        (desktop {
          name = "1080p Desktop";
          resolution = "1920x1080";
        })
        (desktop {
          name = "800p Desktop";
          resolution = "1280x800";
        })
      ];
    };
  };
}
