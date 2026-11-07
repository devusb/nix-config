{
  config,
  ...
}:
{
  programs.niri.enable = true;

  programs.dux-shell = {
    enable = true;
  };

  services.upower.enable = true;

  # niri-session imports the login shell's environment wholesale
  systemd.user.services.niri.serviceConfig.UnsetEnvironment = "SHLVL";
  systemd.user.services.dms.serviceConfig.UnsetEnvironment = "SHLVL";

  services.displayManager.dux-greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = config.users.users.mhelton.home;
  };
}
