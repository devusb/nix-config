{ pkgs, ... }:
let
  sunshine = (pkgs.sunshine.override {
    ffmpeg-full = with pkgs; ffmpeg-full.overrideAttrs (old: {
      postFixup = ''
        addOpenGLRunpath ${placeholder "lib"}/lib/libavcodec.so
        addOpenGLRunpath ${placeholder "lib"}/lib/libavutil.so
      '';
    });
  });
in
{
  home.packages = with pkgs; [
    lutris
    lm_sensors
    dolphin-emu-beta
    chiaki
    theforceengine
    ryujinx
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [ "steam.desktop" "net.lutris.Lutris.desktop" ];
    };
  };

  services.sunshine = {
    enable = true;
    package = sunshine;
  };

}
