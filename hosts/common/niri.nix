{ config, lib, ... }:
{
  programs.niri.enable = true;

  programs.dms-shell.enable = true;

  services.upower.enable = true;

  services.displayManager.sddm.enable = lib.mkForce false;

  # niri-session imports the login shell's environment wholesale
  systemd.user.services.niri.serviceConfig.UnsetEnvironment = "SHLVL";
  systemd.user.services.dms.serviceConfig.UnsetEnvironment = "SHLVL";

  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = config.users.users.mhelton.home;
  };
}
