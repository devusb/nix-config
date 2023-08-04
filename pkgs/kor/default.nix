{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kor";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "yonahd";
    repo = "kor";
    rev = "v${version}";
    hash = "sha256-m4fjd+/tI7m7CI25lADVSFdVL+YHQxI6lqcawUynCmU=";
  };

  vendorHash = "sha256-pMh2HfL+EQX3JEhPkDP4xuckEH1eUzo4MH/2XDKmpNA=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A Tool to discover unused Kubernetes Resouorces";
    homepage = "https://github.com/yonahd/kor";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
  };
}
