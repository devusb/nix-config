{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
  pulseaudio,
  alsa-lib,
  alsa-plugins,
  libGL,
  vulkan-loader,
  wayland,
  gsettings-desktop-schemas,
  gtk3,
}:

let
  pname = "vibetyper";
  version = "1.1.2";

  src = fetchurl {
    url = "https://cdn.vibetyper.com/releases/linux/VibeTyper.AppImage";
    sha256 = "sha256-dN0VDsmZZC/RoSAjYmvILE1PGUgBHxRszhw2BhjL3bg=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    # Install desktop file
    install -Dm444 ${appimageContents}/*.desktop $out/share/applications/vibetyper.desktop 2>/dev/null || true

    # Fix desktop file paths if it exists
    if [ -f $out/share/applications/vibetyper.desktop ]; then
      substituteInPlace $out/share/applications/vibetyper.desktop \
        --replace-quiet 'Exec=AppRun' "Exec=$out/bin/vibetyper"
    fi

    # Install icons (search common locations)
    for size in 16 32 48 64 128 256 512; do
      if [ -f ${appimageContents}/usr/share/icons/hicolor/''${size}x''${size}/apps/*.png ]; then
        mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
        cp ${appimageContents}/usr/share/icons/hicolor/''${size}x''${size}/apps/*.png \
           $out/share/icons/hicolor/''${size}x''${size}/apps/ 2>/dev/null || true
      fi
    done

    # Fallback: copy any PNG in root
    if [ -f ${appimageContents}/*.png ]; then
      mkdir -p $out/share/icons/hicolor/128x128/apps
      cp ${appimageContents}/*.png $out/share/icons/hicolor/128x128/apps/vibetyper.png 2>/dev/null || true
    fi

    # Wrap with runtime dependencies (conservative Handy-style config)
    # GDK_BACKEND=x11: WebKitGTK crashes on GNOME Wayland without this
    # WEBKIT_DISABLE_DMABUF_RENDERER=1: Prevents GPU buffer sharing crashes
    # VK_ICD_FILENAMES: Use software Vulkan renderer for stability
    # LD_LIBRARY_PATH: Ensures OpenGL drivers are found
    # ALSA_PLUGIN_DIR: Fixes "Unknown PCM pulse/jack" audio warnings
    source ${makeWrapper}/nix-support/setup-hook
    wrapProgram $out/bin/vibetyper \
      --prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name} \
      --prefix XDG_DATA_DIRS : ${gtk3}/share/gsettings-schemas/${gtk3.name} \
      --set WEBKIT_DISABLE_DMABUF_RENDERER 1 \
      --set GDK_BACKEND x11 \
      --set VK_ICD_FILENAMES /run/opengl-driver/share/vulkan/icd.d/lvp_icd.x86_64.json \
      --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib \
      --set ALSA_PLUGIN_DIR "${alsa-plugins}/lib/alsa-lib"
  '';

  extraPkgs =
    pkgs: with pkgs; [
      # Audio (critical for speech-to-text)
      pulseaudio
      alsa-lib
      alsa-plugins
      pipewire

      # Graphics
      libGL
      vulkan-loader
      mesa

      # Wayland
      wayland
      libxkbcommon

      # X11 fallback
      libx11
      libxcursor
      libxrandr
      libxi
      libxcb

      # WebKitGTK / Electron dependencies
      webkitgtk_4_1
      libsoup_3
      gtk3
      glib
      gdk-pixbuf
      cairo
      pango
      harfbuzz
      at-spi2-atk
      atk
      dconf
      gsettings-desktop-schemas

      # Misc
      openssl
      zlib
      stdenv.cc.cc.lib
    ];

  meta = with lib; {
    description = "AI-powered voice typing that transforms speech into polished writing";
    homepage = "https://vibetyper.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
    mainProgram = "vibetyper";
  };
}
