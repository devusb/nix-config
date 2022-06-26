{ lib, fetchurl, stdenv, undmg }:
stdenv.mkDerivation rec {
  pname = "brave";
  version = "1.40.107";

  src = fetchurl {
    url = "https://github.com/brave/brave-browser/releases/download/v${version}/Brave-Browser-arm64.dmg";
    sha256 = "sha256-R1356X+T9iWk37ct6tgGvNz3szKTrF9/J1RTQQno/gU=";
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
