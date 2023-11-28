{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonPackage rec {
  pname = "jellyplex-watched";
  version = "5.0.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "luigi311";
    repo = "JellyPlex-Watched";
    rev = "v${version}";
    hash = "sha256-Dq4MMyOe3gIUNu+2WJ+GXuu+p8Z4wlSOOZL17jthx9M=";
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
    mkdir -p $out/share

    cp -r src $out/share
    install -m 755 -t $out/share main.py
    makeWrapper $out/share/main.py $out/bin/jellyplex-watched \
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
