{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "kube-no-trouble";
  version = "nightly-0.7.0-53-g4fa4920";

  src = fetchFromGitHub {
    owner = "doitintl";
    repo = "kube-no-trouble";
    rev = "${version}";
    hash = "sha256-nMlyRmfsKFkQ18L/RxmVOqoNIWdDyHY7+vZaCOvj4Is=";
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
