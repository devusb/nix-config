{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeWrapper,
}:

let
  pname = "drsprinto";
  version = "4.0.8";
  src = fetchurl {
    url = "https://static.sprinto.com/drsprinto/DrSprinto-${version}.AppImage";
    hash = "sha256-jZH6Wpwy7e/buYBXnV7D9gSYesNNlefgVKKFtfdzAi8=";
  };

  appimage = appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs =
      pkgs: with pkgs; [
        lsb-release # Otherwise it fails to get system info
        vulkan-tools # Maybe?

        libGL
        libglvnd
        ffmpeg
        amdvlk
      ];
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in

# appimageContents
stdenv.mkDerivation {
  inherit pname version;

  src = appimage;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r bin $out/bin

    mkdir -p $out/share/${pname}
    cp -a ${appimageContents}/locales $out/share/${pname}
    cp -a ${appimageContents}/resources $out/share/${pname}
    cp -a ${appimageContents}/usr/share/icons $out/share/
    install -Dm 644 ${appimageContents}/${pname}.desktop -t $out/share/applications

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail "AppRun" "${pname}"

    runHook postInstall
  '';

  meta = {
    description = "Security policy compliance software";
    longDescription = ''
      DrSprinto helps you keep your machine compatible with your organisation’s
      security policies.
    '';
    homepage = "https://sprinto.com";
    # license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ devusb ];
    platforms = [ "x86_64-linux" ];
  };
}
