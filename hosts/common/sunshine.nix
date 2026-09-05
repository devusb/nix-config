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

  kscreen-doctor = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor";
  niri = "${config.programs.niri.package}/bin/niri";

  desktop =
    {
      name,
      plasmaMode,
      niriMode,
    }:
    {
      inherit name;
      prep-cmd =
        lib.optional withNiri {
          do = "${niri} msg output ${output} ${niriMode}";
          undo = "${niri} msg output ${output} mode auto";
        }
        ++ lib.optional withPlasma {
          do = "${kscreen-doctor} output.${output}.mode.${plasmaMode}";
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
          plasmaMode = "2560x1440@60";
          niriMode = "mode 2560x1440";
        })
        (desktop {
          name = "1080p Desktop";
          plasmaMode = "1920x1080@60";
          niriMode = "mode 1920x1080";
        })
        (desktop {
          name = "800p Desktop";
          plasmaMode = "1280x800@60";
          niriMode = "custom-mode 1280x800@60";
        })
      ];
    };
  };
}
