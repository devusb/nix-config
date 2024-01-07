{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kor";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "yonahd";
    repo = "kor";
    rev = "v${version}";
    hash = "sha256-Ov+aad+6Tp6Mm+fyjR9+xTYVlRu7uv1kD14AgSFmPMA=";
  };

  vendorHash = "sha256-HPcLjeLw3AxqZg2f5v5G4uYX65D7yXaXDZUPUgWnLFA=";

  ldflags = [ "-s" "-w" ];

  checkFlags = [
    "--skip=TestWriteOutputToFile"
  ];

  meta = with lib; {
    description = "A Tool to discover unused Kubernetes Resouorces";
    homepage = "https://github.com/yonahd/kor";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
  };
}
