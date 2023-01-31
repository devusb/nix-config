{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation {
  pname = "nqptp";
  version = "1.1-dev";

  src = fetchFromGitHub {
    owner = "mikebrady";
    repo = "nqptp";
    rev = "845219c74cd0e35cd344da9f0a37c6e7d3e576f2";
    sha256 = "sha256-tnXYGo4QCuCOmdbxB10svqaiXpezUpVVZHgLadeRoGU=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with lib; {
    description = "Not Quite PTP";
    homepage = "https://github.com/mikebrady/nqptp";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ devusb ];
    platforms = platforms.linux;
  };
}
