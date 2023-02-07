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
, cmake
, pkg-config
, git
}:

stdenv.mkDerivation rec {
  pname = "theforceengine";
  version = "1.08.000";

  src = fetchFromGitHub {
    owner = "luciusDXL";
    repo = "TheForceEngine";
    rev = "v${version}";
    sha256 = "sha256-N86w8vTRma/BmzMQmcQRZdF7YzkMdbc96Y5Fcly1f28=";
  };

  nativeBuildInputs = [
    makeWrapper
    cmake
    pkg-config
    git
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
    substituteInPlace TheForceEngine/TFE_FileSystem/paths-posix.cpp \
      --replace "/usr/share" "$out/share"
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
