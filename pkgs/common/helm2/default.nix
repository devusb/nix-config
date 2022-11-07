{ lib, stdenvNoCC, version, hash, autoPatchelfHook }:
let
  arches = {
    aarch64-darwin = "darwin-amd64";
    x86_64-darwin = "darwin-amd64";
    x86_64-linux = "linux-amd64";
  };
in
stdenvNoCC.mkDerivation rec {
  inherit version;
  pname = "kubernetes-helm";

  src = builtins.fetchTarball {
    url = "https://get.helm.sh/helm-v${version}-${arches.${stdenvNoCC.hostPlatform.system}}.tar.gz";
    sha256 = hash.${stdenvNoCC.hostPlatform.system};
  };

  nativeBuildInputs = [ ] ++ lib.optionals stdenvNoCC.isLinux [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp helm $out/bin/helm${version}
    runHook postInstall
  '';

  meta = with lib; {
    platforms = [ "aarch64-darwin" "x86_64-linux" "x86_64-darwin" ];
    mainProgram = "helm${version}";
  };
}

