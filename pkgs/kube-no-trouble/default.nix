{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "kube-no-trouble";
  version = "unstable-2023-09-04";

  src = fetchFromGitHub {
    owner = "doitintl";
    repo = "kube-no-trouble";
    rev = "f6ebd85d8856d41d91578f793587b41a374e1fac";
    hash = "sha256-yqKc/vqUFZqePCUWNtu/rmR3XJk+9Y+cPinsdiLnQWk=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-Y0n8tDQeiBdEnCbIrI2je8UCvK72REDBnAH+AtwQf1Q=";

  meta = with lib; {
    homepage = "https://github.com/doitintl/kube-no-trouble";
    description = "Easily check your clusters for use of deprecated APIs";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "kubent";
  };
}
