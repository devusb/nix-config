{ pkgs, ... }: {
  home.packages = with pkgs; [
    lutris
    lm_sensors
    dolphin-emu-beta
    chiaki
    (sunshine.override { cudaSupport = true; })
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [ "steam.desktop" "net.lutris.Lutris.desktop" ];
    };
  };

  systemd.user.services = {
    sunshine = {
      Unit.Description = "Sunshine is a Game stream host for Moonlight.";
      Service.ExecStart = "${pkgs.sunshine}/bin/sunshine";
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };

}
