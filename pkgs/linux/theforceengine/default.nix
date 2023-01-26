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
}:

stdenv.mkDerivation {
  pname = "theforceengine";
  version = "1.02";

  src = fetchFromGitHub {
    owner = "mlauss2";
    repo = "TheForceEngine";
    rev = "0683434d5540f964e008820e7952a34813ff867c";
    sha256 = "sha256-Onow2qZ3zTdfwhqa88sBzNaCyRgnAwkY1LVi34Fr0Sg=";
  };

  nativeBuildInputs = [
    makeWrapper
    cmake
    pkg-config
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
