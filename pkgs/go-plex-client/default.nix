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
    rev = "8d015b55b9b4824a74a4bdca613fa975497ac598";
    hash = "sha256-ovpyeuBI7zUQBb6NHIa0R2epMD0G2RQqcDM+QsCcfsg=";
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
    maintainers = with maintainers; [ devusb ];
    mainProgram = "plex-cli";
  };
}
