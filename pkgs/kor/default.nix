{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kor";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "yonahd";
    repo = "kor";
    rev = "v${version}";
    hash = "sha256-+/dsDMjENLqBzEJK6zlc1qcHZPKMVIFEISkw+DINtHY=";
  };

  vendorHash = "sha256-iAqptugku3qX6e45+YYf1bU9j2YntNQj82vR04bFMOQ=";

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
