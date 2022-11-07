{ lib, stdenvNoCC, version, hash }:

stdenvNoCC.mkDerivation rec {
  inherit version;
  pname = "helm2";

  src = builtins.fetchTarball {
    url = "https://get.helm.sh/helm-v${version}-darwin-amd64.tar.gz";
    sha256 = hash;
  };

  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp helm $out/bin/helm${version}
    runHook postInstall
  '';

  meta = with lib; {
    platforms = platforms.darwin;
  };
}

