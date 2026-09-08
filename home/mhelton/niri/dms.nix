{
  inputs,
  osConfig,
  pkgs,
  ...
}:
let
  withSunshine = osConfig.services.sunshine.enable;
in
{
  imports = [
    inputs.dank-material-shell.homeModules.dank-material-shell
    inputs.dms-plugin-registry.homeModules.dms-plugin-registry
  ];

  programs.dank-material-shell = {
    enable = true;
    package = pkgs.dms-shell;
    systemd.enable = false;

    settings = {
      currentThemeName = "dynamic";
      currentThemeCategory = "dynamic";

      acMonitorTimeout = 600;
      acLockTimeout = if withSunshine then 0 else 600;
      acPostLockMonitorTimeout = 30;
      batteryMonitorTimeout = 300;
      batteryLockTimeout = 300;
      batterySuspendTimeout = 600;
      batteryPostLockMonitorTimeout = 30;
      batteryChargeLimit = 80;
      lockBeforeSuspend = if withSunshine then false else true;

      displayProfileAutoSelect = true;

      enableFprint = true;
      greeterEnableFprint = true;

      useFahrenheit = true;
      useAutoLocation = true;
      soundNewNotification = false;
    };

    managePluginSettings = true;
    plugins = {
      calculator = {
        enable = true;
      };
      dankNotepadModule.enable = true;
    };
  };

  xdg.configFile."systemd/user/app-@autostart.service.d/overrides.conf".text = ''
    [Unit]
    After=dms.service
  '';
}
