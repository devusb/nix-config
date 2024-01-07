{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-simple-upload-server";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "mayth";
    repo = "go-simple-upload-server";
    rev = "v${version}";
    hash = "sha256-dHWVE59EOWj6oskWyTJK+pA1lNY3eYzMocVT54RYlAg=";
  };

  vendorHash = "sha256-uaC/pSR2PYrTBH1nWMu/dJ9cpJRtO3c4ZAP0frkYaMA=";

  patches = [
    ./config-fix.patch
  ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Simple HTTP server to save artifacts";
    homepage = "https://github.com/mayth/go-simple-upload-server";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "go-simple-upload-server";
  };
}
