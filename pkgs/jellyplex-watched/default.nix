{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonPackage rec {
  pname = "jellyplex-watched";
  version = "5.0.0-unstable-2024-01-18";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "luigi311";
    repo = "JellyPlex-Watched";
    rev = "815596379c088f924167cb1666a889463b267ef5";
    hash = "sha256-z2FLktLG3nkWx7Eku60px2j3hZ66nDJXwH8kOm5F6DA=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    plexapi
    requests
    python-dotenv
    aiohttp
  ];

  installPhase = ''
    runHook preInstall

    # add shebang so it can be patched
    sed -i -e '1i#!/usr/bin/python' main.py

    mkdir -p $out/bin
    mkdir -p $out/share/jellyplex-watched

    cp -r src $out/share/jellyplex-watched
    install -m 755 -t $out/share/jellyplex-watched main.py
    makeWrapper $out/share/jellyplex-watched/main.py $out/bin/jellyplex-watched \
      --prefix PYTHONPATH : "$PYTHONPATH"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Sync watched between jellyfin and plex locally";
    homepage = "https://github.com/luigi311/JellyPlex-Watched";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "jellyplex-watched";
    platforms = platforms.all;
  };
}
