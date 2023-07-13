{ lib
, fetchFromGitHub
, mkDerivation
, cmake
, pkg-config
, protobuf
, python3Packages
, ffmpeg_6
, libopus
, qtbase
, qtmultimedia
, qtsvg
, SDL2
, libevdev
, udev
, hidapi
, fftw
}:

mkDerivation rec {
  pname = "chiaki4deck";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "streetpea";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Pb+PuGl9KnYwnpcUJNTn29zpqEtYfPVxmzjRBYDymII=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    python3Packages.protobuf
    python3Packages.python
    python3Packages.setuptools
  ];

  buildInputs = [
    ffmpeg_6
    libopus
    qtbase
    qtmultimedia
    qtsvg
    protobuf
    SDL2
    hidapi
    fftw
    libevdev
    udev
  ];

  doCheck = true;

  installCheckPhase = "$out/bin/chiaki --help";

  meta = with lib; {
    homepage = "https://streetpea.github.io/chiaki4deck/";
    description = "Fork of Chiaki (Open Source Playstation Remote Play) with Enhancements for Steam Deck";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ devusb ];
    platforms = platforms.linux;
    mainProgram = "chiaki";
  };
}
