{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, SDL2
, libdevil
, rtaudio
, rtmidi
, glew
, alsa-lib
}:

stdenv.mkDerivation rec {
  pname = "theforceengine";
  version = "1.01";

  src = fetchFromGitHub {
    owner = "mlauss";
    repo = "TheForceEngine";
    rev = "a4699ad99aeb3e9f66469740c40df9f4fbecc5a4";
    sha256 = "sha256-Uih7z8vyKtZYRprhPFT5Fo+i+UA/lNLMh0WBYZY1YYY=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    SDL2
    libdevil
    rtaudio
    rtmidi
    glew
    alsa-lib
  ];

  prePatch = ''
    substituteInPlace Makefile \
      --replace "-I/usr/include/SDL2" "-I${SDL2.dev}/include/SDL2"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r TheForceEngine $out/
  '';

  postFixup = ''
    makeWrapper $out/TheForceEngine/tfelnx $out/bin/tfelnx --chdir $out/TheForceEngine
  '';

  meta = with lib; {
    description = "Modern \"Jedi Engine\" replacement supporting Dark Forces, mods, and in the future Outlaws.";
    homepage = "https://theforceengine.github.io";
    mainProgram = "tfelnx";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ devusb ];
    platforms = platforms.linux;
  };
}