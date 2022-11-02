{ callPackage
, fetchFromGitHub
, autoPatchelfHook
, zlib
, stdenvNoCC
, lib
}:

callPackage ./generic.nix {
  pname = "sm64ex-coop";
  version = "0.pre+date=2022-10-01";

  src = fetchFromGitHub {
    owner = "djoslin0";
    repo = "sm64ex-coop";
    rev = "8c232211878a4bac6ae8f311eb9031aae99a78d6";
    sha256 = "sha256-LqbK9vQZGIRbD9xON1OWmCFQTJYrjSbMJGFVhyZTVGo=";
  };

  extraNativeBuildInputs = [
    autoPatchelfHook
  ];

  extraBuildInputs = [
    zlib
  ];

  postInstall =
    let
      sharedLib = stdenvNoCC.hostPlatform.extensions.sharedLibrary;
    in
    ''
      mkdir -p $out/lib
      cp $src/lib/bass/libbass{,_fx}${sharedLib} $out/lib
      cp $src/lib/discordsdk/libdiscord_game_sdk${sharedLib} $out/lib
    '';

  extraMeta = {
    homepage = "https://github.com/djoslin0/sm64ex-coop";
    description = "Super Mario 64 online co-op mod, forked from sm64ex";
  };
}
