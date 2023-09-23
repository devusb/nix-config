{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-plex-client";
  version = "unstable-2023-09-23";

  src = fetchFromGitHub {
    owner = "devusb";
    repo = "go-plex-client";
    rev = "e717ba6c074086a24fa7b94eb5535d0a9c2578ed";
    hash = "sha256-+cuG/0kh7S1OF99jqNeaoZWcqe+IHJvJCp+CRp96st8=";
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
    mainProgram = "plex-cli";
  };
}
