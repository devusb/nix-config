{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
}:

buildGoModule rec {
  pname = "kubectl-gadget";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    rev = "v${version}";
    hash = "sha256-rlsjkjJg0IRGRBpTGhKTpMVQgxhizN7P+py2R+sczrk=";
  };

  vendorHash = "sha256-+DXQ4Rgd7egKsDyU0/WQgninlsjPHFAoHy/sSQYE1p8=";

  subPackages = [ "cmd/kubectl-gadget" ];

  tags = [ "withoutebpf" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.gadgetimage=ghcr.io/inspektor-gadget/inspektor-gadget:v${version}"
  ];

  CGO_ENABLED = 0;

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "The eBPF tool and systems inspection framework for Kubernetes, containers and Linux hosts";
    homepage = "https://github.com/inspektor-gadget/inspektor-gadget";
    license = with licenses; [ gpl2Only asl20 ];
    maintainers = with maintainers; [ devusb ];
  };
}
