{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
}:

buildGoModule rec {
  pname = "kubectl-gadget";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    rev = "v${version}";
    hash = "sha256-cwzxjK278xMqXwMQLhRhXWR2HhCKYOBMAiM4Y1B7Etk=";
  };

  vendorHash = "sha256-lBOZe74SWMv+z3quIx8NEK6lqygiQAbiU4AvzuXcOKg=";

  subPackages = [ "cmd/kubectl-gadget" ];

  tags = [ "withoutebpf" ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

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
