{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-plex-client";
  version = "unstable-2023-05-08";

  src = fetchFromGitHub {
    owner = "jrudio";
    repo = "go-plex-client";
    rev = "834554e41d30eef59205fb43221dda92d8dbebd1";
    hash = "sha256-ulPMaScJrysAo1uuNzc+wCzKoBvmK8LZ2HNsyiqYMDE=";
  };

  vendorHash = "sha256-vRp3h+6GWSfmdz0LDO1mJnwU1kjUUUXsIwUsZM9aLIQ=";

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/plex-cli
  '';

  doCheck = false;

  meta = with lib; {
    description = "A Plex.tv and Plex Media Server Go client";
    homepage = "https://github.com/jrudio/go-plex-client";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [ ];
    mainProgram = "go-plex-client";
  };
}
