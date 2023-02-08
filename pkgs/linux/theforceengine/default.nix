{ lib
, stdenv
, fetchFromGitHub
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
  version = "1.08.100";

  src = fetchFromGitHub {
    owner = "luciusDXL";
    repo = "TheForceEngine";
    rev = "v${version}";
    sha256 = "sha256-2XrpNdwAiXgLQmccvow7GHJmTmlowMS72MLltApCB5M=";
  };

  nativeBuildInputs = [
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
    # use nix store path instead of hardcoded /usr/share
    substituteInPlace TheForceEngine/TFE_FileSystem/paths-posix.cpp \
      --replace "/usr/share" "$out/share"

    # disable replacing of version string with "0.0.0" -- use static version from repo
    substituteInPlace CMakeLists.txt \
      --replace "create_git_version_h()" ""
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
