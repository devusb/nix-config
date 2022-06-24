{ lib, fetchurl, stdenv, undmg }:
  stdenv.mkDerivation rec {
    pname = "brave";
    version = "1.40.105";

    src = fetchurl {
      url = "https://github.com/brave/brave-browser/releases/download/v${version}/Brave-Browser-arm64.dmg";
      sha256 = "sha256-4UFmEbJBLH3y/yqp/uUGuYddkl1i3OlelWkTR6uWgNM=";
    };

    buildInputs = [ undmg ];

    unpackPhase = ''
      undmg $src
    '';

    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
    '';

    patchPhase = ''
      rm -rf Brave\ Browser.app/Contents/Frameworks/Brave\ Browser\ Framework.framework/Versions/Current/Frameworks/Sparkle.framework/Versions/Current/Resources/Autoupdate.app
    '';

    meta = {
      description = "Privacy-oriented browser for Desktop and Laptop computers";
      homepage = "https://brave.com/";
      platforms = lib.platforms.darwin;
    };
}