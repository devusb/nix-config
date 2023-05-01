{ lib, buildPythonApplication, fetchFromGitHub, mpv, python, requests, python-mpv-jsonipc, pystray, tkinter
, wrapGAppsHook, gobject-introspection }:
let
  default-shader-pack = fetchFromGitHub {
    owner = "iwalton3";
    repo = "default-shader-pack";
    rev = "v2.1.0";
    sha256 = "sha256-BM2GvmUoWQUUMH464YIIqu5A1t1B+otbJxAGFbySuq8=";
  };
in
buildPythonApplication rec {
  pname = "plex-mpv-shim";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-hUGKOJEDZMK5uhHoevFt1ay6QQEcoN4F8cPxln5uMRo=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
  ];

  propagatedBuildInputs = [ mpv requests python-mpv-jsonipc pystray tkinter ];

  # needed for pystray to access appindicator using GI
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  dontWrapGApps = true;

  # does not contain tests
  doCheck = false;

  postInstall = ''
    mkdir -p $out/${python.sitePackages}/plex_mpv_shim/default_shader_pack
    cp -r ${default-shader-pack}/* $out/${python.sitePackages}/plex_mpv_shim/default_shader_pack
  '';

  meta = with lib; {
    homepage = "https://github.com/iwalton3/plex-mpv-shim";
    description = "Allows casting of videos to MPV via the Plex mobile and web app";
    license = licenses.mit;
  };
}
