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

  niriPrep = mode: {
    do = "${niri} msg output ${output} ${mode}";
    undo = "${niri} msg output ${output} mode auto";
  };

  plasmaPrep = mode: {
    do = "${kscreen-doctor} output.${output}.mode.${mode}";
    undo = "${kscreen-doctor} output.${output}.mode.${nativeMode}";
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
        {
          name = "1440p Desktop";
          prep-cmd =
            lib.optional withNiri (niriPrep "mode 2560x1440")
            ++ lib.optional withPlasma (plasmaPrep "2560x1440@60");
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "1080p Desktop";
          prep-cmd =
            lib.optional withNiri (niriPrep "mode 1920x1080")
            ++ lib.optional withPlasma (plasmaPrep "1920x1080@60");
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "800p Desktop";
          prep-cmd =
            lib.optional withNiri (niriPrep "custom-mode 1280x800@60")
            ++ lib.optional withPlasma (plasmaPrep "1280x800@60");
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
      ];
    };
  };
}
